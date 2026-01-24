pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
--========================================================
-- THE CORPUSCLE CREW™  (CONSTITUTIONAL EDITION v1.0)
-- Fossil Record: PICO-8 reference implementation
--
-- LAW: graphics serve gameplay. when stressed, reduce
-- visual sampling first, never input/collision clarity.
--========================================================

--========================
-- constants / tuning
--========================
w=128 h=128
center_y=64
base_r=30

-- phase machine
-- menu -> shooter -> briefing -> defense -> briefing -> (shooter|boss)
state="crawl"
next_state=nil
brief_t=0

wave=1
score=0
credits=50
health=100

-- shooter quota law
quota=0
spawned=0
killed=0

-- performance / lod
lod=2 -- 0 static,1 pulse1,2 pulse3
cpu=0

-- input
sel=0 -- crew selection 0..3

-- crew archetypes (speed,cool,damage,mode)
-- mode: 0 blaster,1 heavy,2 medic,3 scout
crew_name={"blaster","heavy","medic","scout"}
c_spd ={1.8, 1.4, 2.1, 2.6}
c_cd  ={6,   14,  10,  5}
c_dmg ={1,   3,   1,   1}
c_col ={11,  9,   12,  10}

-- entities
p=nil
bul={}
en={}
parts={}
cells={}
towers={}
boss=nil

-- defense cursor
cx=0 cy=0
tower_sel=0

--========================================================
-- util
--========================================================
function clamp(v,a,b) if v<a then return a elseif v>b then return b end return v end
function sgn(v) return v<0 and -1 or 1 end
function len2(dx,dy) return dx*dx+dy*dy end

--========================================================
-- SDF vein walls (truth)
-- signed distance: positive inside, negative in wall
--========================================================
function vein_sdf(x,y,t,l)
 local pulse=0
 if l==1 then
  pulse=8*sin(x/20+t)
 elseif l>=2 then
  pulse=8*sin(x/20+t)+4*sin(x/10-t*2)+2*sin(x/5+t*3)
 end
 local r=base_r+pulse
 return r-abs(y-center_y)
end

-- central diff normal (used sparingly: player + enemies only)
function vein_nrm(x,y,t,l)
 local e=0.5
 local dx=vein_sdf(x+e,y,t,l)-vein_sdf(x-e,y,t,l)
 local dy=vein_sdf(x,y+e,t,l)-vein_sdf(x,y-e,t,l)
 local ll=sqrt(dx*dx+dy*dy)
 if ll<0.0001 then return 0, (y<center_y and -1 or 1) end
 return dx/ll, dy/ll
end

function push_out(e,t,l)
 local d=vein_sdf(e.x,e.y,t,l)
 if d<e.r then
  local pen=e.r-d
  local nx,ny=vein_nrm(e.x,e.y,t,l)
  e.x+=nx*pen
  e.y+=ny*pen
  e.vx*=0.7 e.vy*=0.7
  return true
 end
 return false
end

--========================================================
-- spawn helpers
--========================================================
function spawn_enemy()
 -- spawn outside bounds, aim toward player
 local side=flr(rnd(4))
 local x,y
 if side==0 then x=rnd(128) y=-8
 elseif side==1 then x=136 y=rnd(128)
 elseif side==2 then x=rnd(128) y=136
 else x=-8 y=rnd(128) end

 local ang=atan2(p.y-y,p.x-x)
 local sp=0.35+rnd(0.25)+wave*0.03
 local arm=rnd()<0.2
 local hp=2+flr(wave/2)
 if arm then hp*=2 end

 add(en,{
  x=x,y=y,
  vx=cos(ang)*sp, vy=sin(ang)*sp,
  a=ang, s=rnd(6.28),
  hp=hp, mhp=hp,
  arm=arm,
  r=4
 })
 spawned+=1
end

function spawn_cell()
 local left=rnd()<0.5
 add(cells,{
  x=left and -6 or 134,
  y=rnd(128),
  vx=left and 0.5 or -0.5,
  r=2+rnd(2)
 })
end

function boom(x,y,n,col)
 for i=1,n do
  add(parts,{
   x=x,y=y,
   vx=cos(i/n*6.28)* (1+rnd(1.5)),
   vy=sin(i/n*6.28)* (1+rnd(1.5)),
   t=10+rnd(10),
   c=col
  })
 end
end

--========================================================
-- boss: pathological geometry (equations breathe)
--========================================================
function spawn_boss()
 boss={
  x=64,y=40,
  hp=120+wave*15, mhp=120+wave*15,
  base=12,
  lobes=6,
  inst=0,
  drift=rnd(6.28),
  pf=1,
  core=false,
  tm=0,
  r=14
 }
end

function boss_stage()
 local h=boss.hp/boss.mhp
 if h>0.7 then return 1
 elseif h>0.4 then return 2
 elseif h>0.2 then return 3
 else return 4 end
end

function update_boss()
 if not boss then return end
 boss.tm+=1

 local h=boss.hp/boss.mhp
 boss.inst=(1-h)*5

 local st=boss_stage()
 if st==1 then boss.lobes=6 boss.pf=1 boss.core=false
 elseif st==2 then boss.lobes=5 boss.pf=1.3 boss.core=false
 elseif st==3 then boss.lobes=4 boss.pf=1.8 boss.core=false
 else boss.lobes=3 boss.pf=3 boss.core=true end

 -- lissajous drift (cheap): dual freq sin/cos
 local t=time()
 boss.x=64+sin(t*0.7+boss.drift)*18
 boss.y=44+sin(t*0.9-boss.drift)*12
end

function boss_hit(b)
 if not boss then return false end

 local st=boss_stage()
 local t=time()
 local mem=boss.base + sin(t*boss.pf)*3 + (rnd(boss.inst)-boss.inst/2)
 local hit=false

 -- lobe zones: half dmg, communicate armor
 for i=1,boss.lobes do
  local ang=i/boss.lobes*6.28 + boss.drift
  local wob=sin(t*2+ang*3+i)*boss.inst
  local ld=mem+6+wob
  local lx=boss.x+cos(ang)*ld
  local ly=boss.y+sin(ang)*ld
  if len2(b.x-lx,b.y-ly) < 8*8 then
   boss.hp-=max(1,flr(b.dmg*0.5))
   boom(lx,ly,6,14)
   hit=true
   break
  end
 end

 -- core zone (only exposed): 2x dmg
 if (not hit) and boss.core and len2(b.x-boss.x,b.y-boss.y) < 8*8 then
  boss.hp-=b.dmg*2
  boom(boss.x,boss.y,10,8)
  hit=true
 end

 -- membrane hit (always): normal dmg
 if (not hit) and len2(b.x-boss.x,b.y-boss.y) < (mem+6)*(mem+6) then
  boss.hp-=b.dmg
  boom(b.x,b.y,4,2)
  hit=true
 end

 if hit then b.dead=true end
 if boss.hp<=0 then
  score+=500
  credits+=50
  boom(boss.x,boss.y,24,8)
  boss=nil
  -- victory: next wave
  wave+=1
  to_brief("defense")
 end
 return hit
end

--========================================================
-- state transitions
--========================================================
function to_brief(ns)
 state="brief"
 next_state=ns
 brief_t=60 -- 2 seconds @30fps
end

function start_run()
 score=0 credits=50 health=100
 wave=1
 p={
  x=64,y=64,a=0,vx=0,vy=0,
  t=sel, r=4,
  cd=0
 }
 bul={} en={} parts={} cells={} towers={}
 boss=nil
 set_quota()
 to_brief("shooter")
end

function set_quota()
 quota=10+wave*3
 spawned=0
 killed=0
end

--========================================================
-- update loops
--========================================================
function upd_common()
 cpu=stat(1)
 -- graceful degradation ladder (visual only)
 if cpu>0.95 then lod=0
 elseif cpu>0.80 then lod=min(lod,1)
 else lod=2 end

 -- ambient blood cells
 if (frame%90)==0 then spawn_cell() end

 -- update cells
 for i=#cells,1,-1 do
  local c=cells[i]
  c.x+=c.vx
  if c.x<-12 or c.x>140 then del(cells,c) end
 end

 -- particles
 for i=#parts,1,-1 do
  local pt=parts[i]
  pt.x+=pt.vx pt.y+=pt.vy
  pt.vx*=0.9 pt.vy*=0.9
  pt.t-=1
  if pt.t<=0 then del(parts,pt) end
 end
end

function upd_shooter()
 -- spawn enemies until quota met
 if spawned<quota then
  if (frame%max(20,50-wave*2))==0 then spawn_enemy() end
 end

 -- boss trigger every 3 waves (after shooter quota)
 if (wave%3)==0 and spawned>=quota and #en==0 and boss==nil then
  to_brief("boss") return
 end

 -- shooter -> defense when quota met and cleared
 if spawned>=quota and #en==0 and boss==nil then
  credits+=10+wave*2
  to_brief("defense") return
 end

 -- movement
 local sp=c_spd[p.t]
 if btn(0) then p.a-=0.10 end
 if btn(1) then p.a+=0.10 end
 local ax=0 local ay=0
 if btn(2) then ax=cos(p.a)*sp ay=sin(p.a)*sp end
 if btn(3) then ax-=cos(p.a)*sp*0.5 ay-=sin(p.a)*sp*0.5 end
 p.vx=ax p.vy=ay
 p.x=clamp(p.x+p.vx,8,120)
 p.y=clamp(p.y+p.vy,8,120)

 -- walls
 push_out(p,time(),lod)

 -- shoot (O button)
 p.cd=max(0,p.cd-1)
 if btn(4) and p.cd==0 then
  local cd=c_cd[p.t+1]
  local dmg=c_dmg[p.t+1]
  local ox=cos(p.a) local oy=sin(p.a)
  if p.t==1 then
   -- heavy: slow big
   add(bul,{x=p.x+ox*6,y=p.y+oy*6,vx=ox*2,vy=oy*2,dmg=dmg,typ=1})
  elseif p.t==3 then
   -- scout: 3-shot spread
   for s=-1,1 do
    local a=p.a+s*0.18
    add(bul,{x=p.x+cos(a)*6,y=p.y+sin(a)*6,vx=cos(a)*3,vy=sin(a)*3,dmg=1,typ=3})
   end
  elseif p.t==2 then
   -- medic: weak shot + self heal tick
   add(bul,{x=p.x+ox*6,y=p.y+oy*6,vx=ox*2.4,vy=oy*2.4,dmg=1,typ=2})
   health=min(100,health+1)
  else
   -- blaster
   add(bul,{x=p.x+ox*6,y=p.y+oy*6,vx=ox*3.5,vy=oy*3.5,dmg=1,typ=0})
  end
  p.cd=cd
 end

 -- towers fire (cheap nearest)
 for tw in all(towers) do
  tw.t=(tw.t+1)%tw.cd
  if tw.t==0 then
   local best=nil local bd=9999
   for e in all(en) do
    local d=len2(e.x-tw.x,e.y-tw.y)
    if d<40*40 and d<bd then bd=d best=e end
   end
   if best then
    local a=atan2(best.y-tw.y,best.x-tw.x)
    add(bul,{x=tw.x,y=tw.y,vx=cos(a)*3,vy=sin(a)*3,dmg=tw.dmg,typ=tw.typ,from=1})
   end
  end
 end

 -- bullets
 for i=#bul,1,-1 do
  local b=bul[i]
  b.x+=b.vx b.y+=b.vy
  if b.x<-8 or b.x>136 or b.y<-8 or b.y>136 or b.dead then
   del(bul,b)
  end
 end

 -- enemies
 for i=#en,1,-1 do
  local e=en[i]
  -- spiral overlay
  e.s+=0.18
  local sx=cos(e.s)*0.25
  local sy=sin(e.s)*0.25
  e.x+=e.vx+sx
  e.y+=e.vy+sy
  -- wall collision
  push_out(e,time(),lod)

  -- collide player
  if len2(e.x-p.x,e.y-p.y) < (e.r+p.r)*(e.r+p.r) then
   health-= e.arm and 8 or 5
   boom(e.x,e.y,8,8)
   del(en,e)
  end
 end

 -- bullet hits
 for b in all(bul) do
  for e in all(en) do
   local rr=(b.typ==1) and 10 or 6
   if len2(b.x-e.x,b.y-e.y)<rr*rr then
    e.hp-=b.dmg
    b.dead=true
    boom(b.x,b.y,4,7)
    if b.typ==1 then
     -- heavy splash
     for o in all(en) do
      if o!=e and len2(b.x-o.x,b.y-o.y)<14*14 then o.hp-=1 end
     end
    end
    if e.hp<=0 then
     killed+=1
     score+= e.arm and 20 or 10
     credits+= e.arm and 3 or 2
     boom(e.x,e.y,8,14)
     del(en,e)
    end
    break
   end
  end
 end

 if health<=0 then state="gameover" end
end

function upd_defense()
 -- grid cursor
 if btnp(0) then cx=max(0,cx-16) end
 if btnp(1) then cx=min(112,cx+16) end
 if btnp(2) then cy=max(0,cy-16) end
 if btnp(3) then cy=min(112,cy+16) end

 -- cycle tower type (X)
 if btnp(5) then tower_sel=(tower_sel+1)%4 end

 -- place tower (O)
 local cost={20,40,35,25}
 if btnp(4) and credits>=cost[tower_sel+1] then
  local px=cx+8 local py=cy+8
  local occ=false
  for t in all(towers) do
   if t.x==px and t.y==py then occ=true end
  end
  if not occ then
   add(towers,{
    x=px,y=py,
    typ=tower_sel,
    dmg=c_dmg[tower_sel+1],
    cd=c_cd[tower_sel+1],
    t=0
   })
   credits-=cost[tower_sel+1]
  end
 end

 -- continue to shooter (X+O not needed, just X hold? keep simple: press X again)
 if btnp(5) then
  -- note: already used for cycle; so use btnp(4) on top-right? no.
  -- continue uses "start": press 🅾 + 🅾? keep: press both O+X
 end
 if btn(4) and btnp(5) then
  set_quota()
  to_brief("shooter")
 end
end

function upd_boss()
 if boss==nil then
  spawn_boss()
 end
 update_boss()

 -- player controls (same)
 local sp=c_spd[p.t]
 if btn(0) then p.a-=0.10 end
 if btn(1) then p.a+=0.10 end
 local ax=0 local ay=0
 if btn(2) then ax=cos(p.a)*sp ay=sin(p.a)*sp end
 if btn(3) then ax-=cos(p.a)*sp*0.5 ay-=sin(p.a)*sp*0.5 end
 p.vx=ax p.vy=ay
 p.x=clamp(p.x+p.vx,8,120)
 p.y=clamp(p.y+p.vy,8,120)
 push_out(p,time(),lod)

 -- boss spawns minions unless core-exposed (final stage)
 if (not boss.core) and (frame%120)==0 then
  for i=1,3 do spawn_enemy() end
 end

 -- shoot
 p.cd=max(0,p.cd-1)
 if btn(4) and p.cd==0 then
  local cd=c_cd[p.t+1]
  local dmg=c_dmg[p.t+1]
  local ox=cos(p.a) local oy=sin(p.a)
  if p.t==1 then
   add(bul,{x=p.x+ox*6,y=p.y+oy*6,vx=ox*2,vy=oy*2,dmg=dmg,typ=1})
  elseif p.t==3 then
   for s=-1,1 do
    local a=p.a+s*0.18
    add(bul,{x=p.x+cos(a)*6,y=p.y+sin(a)*6,vx=cos(a)*3,vy=sin(a)*3,dmg=1,typ=3})
   end
  elseif p.t==2 then
   add(bul,{x=p.x+ox*6,y=p.y+oy*6,vx=ox*2.4,vy=oy*2.4,dmg=1,typ=2})
   health=min(100,health+1)
  else
   add(bul,{x=p.x+ox*6,y=p.y+oy*6,vx=ox*3.5,vy=oy*3.5,dmg=1,typ=0})
  end
  p.cd=cd
 end

 -- bullets
 for i=#bul,1,-1 do
  local b=bul[i]
  b.x+=b.vx b.y+=b.vy
  if b.x<-8 or b.x>136 or b.y<-8 or b.y>136 or b.dead then
   del(bul,b)
  else
   boss_hit(b)
  end
 end

 -- enemies (minions)
 for i=#en,1,-1 do
  local e=en[i]
  e.s+=0.18
  e.x+=e.vx+cos(e.s)*0.25
  e.y+=e.vy+sin(e.s)*0.25
  push_out(e,time(),lod)
  if len2(e.x-p.x,e.y-p.y) < (e.r+p.r)*(e.r+p.r) then
   health-= e.arm and 8 or 5
   boom(e.x,e.y,8,8)
   del(en,e)
  end
 end

 if health<=0 then state="gameover" end
end

--========================================================
-- draw
--========================================================
function draw_walls()
 -- render by sampling x and drawing top/bottom points
 local t=time()
 -- step depends on lod: lower lod => fewer samples
 local step= (lod==2 and 2) or (lod==1 and 3) or 4
 for x=0,127,step do
  local d=vein_sdf(x,center_y,t,lod) -- radius at x
  local r=d -- because sdf(centerline)=radius
  local y1=center_y-r
  local y2=center_y+r
  -- 2px thickness
  for dx=0,step-1 do
   pset(x+dx,y1,2) pset(x+dx,y1+1,2)
   pset(x+dx,y2,2) pset(x+dx,y2-1,2)
  end
 end
end

function draw_player()
 local col=c_col[p.t+1]
 local x=p.x local y=p.y
 -- 5 primitives max: body + detail
 circfill(x,y,3,col)
 pset(x+cos(p.a)*4,y+sin(p.a)*4,7)
 if p.t==2 then -- medic cross
  line(x-2,y,x+2,y,7) line(x,y-2,x,y+2,7)
 elseif p.t==1 then -- heavy block
  rect(x-2,y-2,x+2,y+2,9)
 elseif p.t==3 then -- scout chevron
  line(x-3,y,x+1,y-2,10) line(x-3,y,x+1,y+2,10)
 end
end

function draw_enemies()
 for e in all(en) do
  -- 10 segment spiral-ish stroke
  local col=e.arm and 4 or 8
  local seg=10
  local sx=cos(e.s)*2
  local sy=sin(e.s)*2
  for i=1,seg do
   local t=i/seg
   local a=e.a+t*2.6
   local x=e.x+sx*cos(a)
   local y=e.y+sy*sin(a)
   if i==1 then px=x py=y else line(px,py,x,y,col) px=x py=y end
  end
 end
end

function draw_bullets()
 for b in all(bul) do
  if b.typ==1 then rectfill(b.x-2,b.y-2,b.x+2,b.y+2,9)
  elseif b.typ==2 then circfill(b.x,b.y,2,12)
  elseif b.typ==3 then rectfill(b.x-1,b.y-1,b.x+1,b.y+1,10)
  else pset(b.x,b.y,7) end
 end
end

function draw_towers()
 for t in all(towers) do
  rectfill(t.x-4,t.y-4,t.x+4,t.y+4,5)
  rectfill(t.x-2,t.y-2,t.x+2,t.y+2,7)
 end
end

function draw_boss()
 if not boss then return end
 local t=time()
 local mem=boss.base + sin(t*boss.pf)*3 + (rnd(boss.inst)-boss.inst/2)

 -- membrane
 circfill(boss.x,boss.y,mem,2)

 -- lobes (draw calls reduce as damaged)
 for i=1,boss.lobes do
  local ang=i/boss.lobes*6.28 + boss.drift
  local wob=sin(t*2+ang*3+i)*boss.inst
  local lr=6+wob
  local ld=mem+4+wob*2
  local lx=boss.x+cos(ang)*ld
  local ly=boss.y+sin(ang)*ld
  circfill(lx,ly,lr, boss.core and 14 or 8)
  line(boss.x,boss.y,lx,ly,2)
 end

 -- core
 if boss.core then
  local cp=sin(t*6)*2
  circfill(boss.x,boss.y,5+cp,8)
  -- fracture lines (4)
  for i=1,4 do
   local a=i/4*6.28 + t
   line(boss.x+cos(a)*3,boss.y+sin(a)*3,
        boss.x+cos(a)*10,boss.y+sin(a)*10,7)
  end
 else
  circfill(boss.x,boss.y,4+sin(t*boss.pf*2),9)
 end

 -- aura (visual-only; reduce when cpu high)
 if lod>0 and boss.inst>1 then
  local rings=(boss_stage()>=3) and 2 or 1
  for i=1,rings do
   if sin(t*4+i)>0.2 then circ(boss.x,boss.y,mem+2+i*3,8) end
  end
 end

 -- hp bar (clarity > vibe)
 rectfill(20,4,108,6,0)
 rectfill(20,4,20+ (boss.hp/boss.mhp)*88,6,8)
end

function draw_hud()
 print("wave "..wave,1,1,7)
 print("hp "..health,1,8,11)
 print("cr "..credits,1,15,10)
 print("sc "..score,78,1,7)
 -- PI compliance display
 print("cpu "..flr(cpu*100).."%",78,8,6)
 print("lod "..lod,78,15,6)
end

--========================================================
-- main pico-8 entry
--========================================================
frame=0
function _init()
end

function _update60()
 _update()
end

function _update()
 frame+=1
 if state=="crawl" then
  -- 2 seconds then menu
  if frame>60 then state="menu" end
 elseif state=="menu" then
  if btnp(0) then sel=(sel+3)%4 end
  if btnp(1) then sel=(sel+1)%4 end
  if btnp(4) then start_run() end
 elseif state=="brief" then
  brief_t-=1
  if brief_t<=0 then
   state=next_state
   if state=="shooter" then set_quota() end
  end
 elseif state=="shooter" then
  upd_common()
  upd_shooter()
 elseif state=="defense" then
  upd_common()
  upd_defense()
 elseif state=="boss" then
  upd_common()
  upd_boss()
 elseif state=="gameover" then
  if btnp(4) then state="menu" frame=0 end
 end
end

function _draw()
 cls(1)

 if state=="crawl" then
  cls(0)
  print("patient: human host",18,44,7)
  print("condition: infection - stage ii",8,54,7)
  print("autonomous response insufficient",10,68,8)
  print("micro-intervention authorized",14,78,8)
  print("deploy the corpuscle crew",18,94,11)
  return
 end

 if state=="menu" then
  cls(0)
  print("the corpuscle crew",28,18,11)
  print("select crew",42,34,7)
  for i=0,3 do
   local y=52+i*12
   local col=(i==sel) and 11 or 6
   print((i==sel and "> " or "  ")..crew_name[i+1],40,y,col)
  end
  print("left/right select  |  o deploy",18,108,6)
  return
 end

 -- playfield
 draw_walls()
 draw_towers()
 for c in all(cells) do circfill(c.x,c.y,c.r,13) end
 for pt in all(parts) do pset(pt.x,pt.y,pt.c) end
 draw_enemies()
 draw_bullets()
 if state=="boss" then draw_boss() end
 if state=="shooter" or state=="boss" then draw_player() end
 draw_hud()

 if state=="brief" then
  rectfill(18,52,110,78,0)
  rect(18,52,110,78,11)
  print("mission briefing",30,56,11)
  print("wave "..wave,52,66,7)
  print(next_state,52,72,8)
 end

 if state=="defense" then
  -- grid + cursor
  for x=0,128,16 do line(x,0,x,127,3) end
  for y=0,128,16 do line(0,y,127,y,3) end
  rect(cx,cy,cx+15,cy+15,11)
  rectfill(0,100,127,127,0)
  print("defense: o=place  x+o=continue",4,102,7)
  print("tower: "..crew_name[tower_sel+1],4,110, c_col[tower_sel+1])
  print("cost "..({20,40,35,25})[tower_sel+1],4,118,10)
  print("x: cycle tower",78,110,6)
 end

 if state=="gameover" then
  rectfill(18,50,110,86,0)
  rect(18,50,110,86,8)
  print("crew member down",28,56,8)
  print("score "..score,36,68,7)
  print("press o",48,78,11)
 end
end
__gfx__