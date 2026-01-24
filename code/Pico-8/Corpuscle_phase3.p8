pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
--========================================================
-- THE CORPUSCLE CREW™  (PHASE 3: STABILIZED)
-- Constitutional Edition v1.3.2
--
-- LAW: graphics serve gameplay. 
-- UPDATE: Implemented deferred deletion (iterator safety).
-- UPDATE: 3D projection z-clipping safety.
--========================================================

--========================
-- constants / tuning
--========================
w=128 h=128
center_y=64
base_r=30

-- phase machine
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
lod=2
cpu=0
t_now=0

-- input
sel=0

-- death queue (iterator safety)
dead_q={}

-- crew archetypes
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

-- inoculation bolt
inoc_bolt={active=false,x=0,y=0,vx=0,vy=0,age=0,max_age=60,cooldown=0,max_cooldown=45,radius=2}
vein_shake={active=false,x=0,amplitude=8,decay=0}

--========================================================
-- 3D KERNEL: ICOSAHEDRON_PI_V0 (SDF-BLAZE SIGIL)
-- Pure ALU projection. No sprite memory used.
--========================================================
sigil_v={} -- vertices

function init_sigil()
 local g=1.618
 -- 12 vertices of icosahedron
 local v={
  {0,1,g},{0,-1,g},{0,1,-g},{0,-1,-g},
  {1,g,0},{-1,g,0},{1,-g,0},{-1,-g,0},
  {g,0,1},{g,0,-1},{-g,0,1},{-g,0,-1}
 }
 sigil_v=v
end

--========================================================
-- util
--========================================================
function clamp(v,a,b) if v<a then return a elseif v>b then return b end return v end
function sgn(v) return v<0 and -1 or 1 end
function len2(dx,dy) return dx*dx+dy*dy end

--========================================================
-- SDF vein walls (truth)
--========================================================
function vein_sdf(x,y,t,l)
 local pulse=0
 if l==1 then
  pulse=8*sin(x/20+t)
 elseif l>=2 then
  pulse=8*sin(x/20+t)+4*sin(x/10-t*2)+2*sin(x/5+t*3)
 end
 
 if vein_shake.active and vein_shake.decay>0 then
  local dist=abs(x-vein_shake.x)
  local inf=max(0,1-dist/30)
  pulse+=vein_shake.amplitude*inf*(vein_shake.decay/10)
 end
 
 local r=base_r+pulse
 return r-abs(y-center_y)
end

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
 local wbc_chance=wave>3 and 0.3 or 0
 if rnd()<wbc_chance then spawn_wbc() return end
 
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

 add(en,{x=x,y=y,vx=cos(ang)*sp, vy=sin(ang)*sp,a=ang, s=rnd(6.28),hp=hp, mhp=hp,arm=arm,r=4,dead=false})
 spawned+=1
end

function spawn_wbc()
 local side=flr(rnd(4))
 local x,y
 if side==0 then x=rnd(128) y=-8
 elseif side==1 then x=136 y=rnd(128)
 elseif side==2 then x=rnd(128) y=136
 else x=-8 y=rnd(128) end
 local ang=atan2(p.y-y,p.x-x)
 local sp=0.3+rnd(0.2)
 add(en,{x=x,y=y,vx=cos(ang)*sp,vy=sin(ang)*sp,a=ang,s=rnd(6.28),hp=3,mhp=3,type="wbc",confused=true,ally=false,r=4,dead=false})
 spawned+=1
end

function spawn_cell()
 local left=rnd()<0.5
 add(cells,{x=left and -6 or 134,y=rnd(128),vx=left and 0.5 or -0.5,r=2+rnd(2)})
end

function boom(x,y,n,col)
 for i=1,n do
  add(parts,{x=x,y=y,vx=cos(i/n*6.28)*(1+rnd(1.5)),vy=sin(i/n*6.28)*(1+rnd(1.5)),t=10+rnd(10),c=col})
 end
end

--========================================================
-- inoculation / boss mechanics
--========================================================
function fire_inoc_bolt()
 if inoc_bolt.cooldown>0 then return false end
 inoc_bolt.active=true
 inoc_bolt.x=p.x inoc_bolt.y=p.y
 inoc_bolt.vx=cos(p.a)*3 inoc_bolt.vy=sin(p.a)*3
 inoc_bolt.age=0 inoc_bolt.cooldown=inoc_bolt.max_cooldown
 return true
end

function update_inoc_bolt()
 if inoc_bolt.cooldown>0 then inoc_bolt.cooldown-=1 end
 if inoc_bolt.active then
  inoc_bolt.x+=inoc_bolt.vx inoc_bolt.y+=inoc_bolt.vy
  inoc_bolt.age+=1
  local wall_d=vein_sdf(inoc_bolt.x,inoc_bolt.y,t_now,lod)
  if (inoc_bolt.age>3 and wall_d<inoc_bolt.radius) or inoc_bolt.age>=inoc_bolt.max_age then
   trigger_shake_at(inoc_bolt.x)
   inoc_bolt.active=false
   boom(inoc_bolt.x,inoc_bolt.y,12,12)
  end
  if inoc_bolt.x<0 or inoc_bolt.x>128 or inoc_bolt.y<0 or inoc_bolt.y>128 then inoc_bolt.active=false end
 end
 if vein_shake.decay>0 then
  vein_shake.decay-=1
  if vein_shake.decay==0 then vein_shake.active=false end
 end
end

function trigger_shake_at(x)
 vein_shake.active=true vein_shake.x=x vein_shake.decay=10
 convert_wbcs_at(x)
end

function convert_wbcs_at(sx)
 for e in all(en) do
  if e.type=="wbc" and e.confused and not e.dead then
   if abs(e.x-sx)<30 and abs(vein_sdf(e.x,e.y,t_now,lod))<8 then
    e.confused=false e.ally=true e.vx=0 e.vy=0 e.aura_cd=30
    boom(e.x,e.y,8,12) score+=15 credits+=5
   end
  end
 end
end

function spawn_boss()
 boss={x=64,y=40,hp=120+wave*15,mhp=120+wave*15,base=12,lobes=6,inst=0,drift=rnd(6.28),pf=1,core=false,tm=0,r=14,mem=12,visual_jitter=0}
end

function boss_stage()
 local h=boss.hp/boss.mhp
 if h>0.7 then return 1 elseif h>0.4 then return 2 elseif h>0.2 then return 3 else return 4 end
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
 boss.mem = boss.base + sin(t_now*boss.pf)*3
 boss.visual_jitter = (rnd(boss.inst)-boss.inst/2)
 boss.x=64+sin(t_now*0.7+boss.drift)*18
 boss.y=44+sin(t_now*0.9-boss.drift)*12
end

function boss_hit(b)
 if not boss then return false end
 local st=boss_stage()
 local mem=boss.mem
 local hit=false
 for i=1,boss.lobes do
  local ang=i/boss.lobes*6.28 + boss.drift
  local wob=sin(t_now*2+ang*3+i)*boss.inst
  local ld=mem+6+wob
  local lx=boss.x+cos(ang)*ld local ly=boss.y+sin(ang)*ld
  if len2(b.x-lx,b.y-ly) < 8*8 then
   boss.hp-=max(1,flr(b.dmg*0.5)) boom(lx,ly,6,14) hit=true break
  end
 end
 if (not hit) and boss.core and len2(b.x-boss.x,b.y-boss.y) < 8*8 then
  boss.hp-=b.dmg*2 boom(boss.x,boss.y,10,8) hit=true
 end
 if (not hit) and len2(b.x-boss.x,b.y-boss.y) < (mem+6)*(mem+6) then
  boss.hp-=b.dmg boom(b.x,b.y,4,2) hit=true
 end
 if hit then b.dead=true end
 if boss.hp<=0 then
  score+=500 credits+=50 boom(boss.x,boss.y,24,8) boss=nil wave+=1 to_brief("defense")
 end
 return hit
end

function count_allies()
 local count=0
 for e in all(en) do if e.ally and not e.dead then count+=1 end end
 return count
end

function flush_dead()
 for e in all(dead_q) do del(en,e) end
 dead_q={}
end

--========================================================
-- state / main loop
--========================================================
function to_brief(ns) state="brief" next_state=ns brief_t=120 end

function start_run()
 score=0 credits=50 health=100 wave=1
 p={x=64,y=64,a=0,vx=0,vy=0,t=sel,r=4,cd=0}
 bul={} en={} parts={} cells={} towers={} boss=nil
 inoc_bolt.cooldown=0 set_quota() to_brief("shooter")
end

function set_quota() quota=10+wave*3 spawned=0 killed=0 end

function upd_common()
 cpu=stat(1)
 -- CONSTITUTIONAL LOD GOVERNOR
 if cpu>0.95 then lod=0 elseif cpu>0.80 then lod=min(lod,1) else lod=2 end
 t_now=time()
 update_inoc_bolt()
 if (frame%180)==0 then spawn_cell() end
 for i=#cells,1,-1 do
  local c=cells[i] c.x+=c.vx
  if c.x<-12 or c.x>140 then del(cells,c) end
 end
 for i=#parts,1,-1 do
  local pt=parts[i] pt.x+=pt.vx pt.y+=pt.vy
  pt.vx*=0.9 pt.vy*=0.9 pt.t-=1
  if pt.t<=0 then del(parts,pt) end
 end
end

function upd_shooter()
 if spawned<quota and (frame%max(20,50-wave*2))==0 then spawn_enemy() end
 if (wave%3)==0 and spawned>=quota and #en==0 and boss==nil then to_brief("boss") return end
 if spawned>=quota and #en==0 and boss==nil then credits+=10+wave*2 to_brief("defense") return end

 local sp=c_spd[p.t+1]
 if btn(0) then p.a-=0.10 end if btn(1) then p.a+=0.10 end
 local ax=0 local ay=0
 if btn(2) then ax=cos(p.a)*sp ay=sin(p.a)*sp end
 if btn(3) then ax-=cos(p.a)*sp*0.5 ay-=sin(p.a)*sp*0.5 end
 p.vx=ax p.vy=ay
 p.x=clamp(p.x+p.vx,8,120) p.y=clamp(p.y+p.vy,8,120)
 push_out(p,t_now,lod)
 if btnp(5) then fire_inoc_bolt() end

 p.cd=max(0,p.cd-1)
 if btn(4) and p.cd==0 then
  local cd=c_cd[p.t+1] local dmg=c_dmg[p.t+1]
  local ox=cos(p.a) local oy=sin(p.a)
  if p.t==1 then add(bul,{x=p.x+ox*6,y=p.y+oy*6,vx=ox*2,vy=oy*2,dmg=dmg,typ=1})
  elseif p.t==3 then for s=-1,1 do local a=p.a+s*0.18 add(bul,{x=p.x+cos(a)*6,y=p.y+sin(a)*6,vx=cos(a)*3,vy=sin(a)*3,dmg=1,typ=3}) end
  elseif p.t==2 then add(bul,{x=p.x+ox*6,y=p.y+oy*6,vx=ox*2.4,vy=oy*2.4,dmg=1,typ=2}) health=min(100,health+1)
  else add(bul,{x=p.x+ox*6,y=p.y+oy*6,vx=ox*3.5,vy=oy*3.5,dmg=1,typ=0}) end
  p.cd=cd
 end
 
 for tw in all(towers) do
  tw.t=(tw.t+1)%tw.cd
  if tw.t==0 then
   local best=nil local bd=9999
   for e in all(en) do
    if not e.ally and not e.dead then
     local d=len2(e.x-tw.x,e.y-tw.y) if d<40*40 and d<bd then bd=d best=e end
    end
   end
   if best then local a=atan2(best.y-tw.y,best.x-tw.x) add(bul,{x=tw.x,y=tw.y,vx=cos(a)*3,vy=sin(a)*3,dmg=tw.dmg,typ=tw.typ,from=1}) end
  end
 end

 for i=#bul,1,-1 do
  local b=bul[i] b.x+=b.vx b.y+=b.vy
  if b.x<-8 or b.x>136 or b.y<-8 or b.y>136 or b.dead then del(bul,b) end
 end

 for i=#en,1,-1 do
  local e=en[i]
  if e.ally and not e.dead then
   e.aura_cd=(e.aura_cd or 0)-1
   if e.aura_cd<=0 then
    for o in all(en) do
     if not o.ally and not o.dead and len2(e.x-o.x,e.y-o.y)<12*12 then
      o.hp-=1 if o.hp<=0 then o.dead=true killed+=1 score+=o.arm and 20 or 10 credits+=o.arm and 3 or 2 boom(o.x,o.y,8,14) add(dead_q,o) end
     end
    end
    e.aura_cd=30
   end
   e.x+=e.vx*0.3 e.y+=e.vy*0.3 push_out(e,t_now,lod)
  elseif not e.dead then
   if e.type=="wbc" then e.x+=e.vx e.y+=e.vy
   else e.s+=0.18 e.x+=e.vx+cos(e.s)*0.25 e.y+=e.vy+sin(e.s)*0.25 end
   push_out(e,t_now,lod)
   if len2(e.x-p.x,e.y-p.y) < (e.r+p.r)*(e.r+p.r) then
    health-= e.arm and 8 or 5 boom(e.x,e.y,8,8) e.dead=true add(dead_q,e)
   end
  end
 end

 for b in all(bul) do
  for e in all(en) do
   if not e.ally and not e.dead then
    local rr=(b.typ==1) and 10 or 6
    if len2(b.x-e.x,b.y-e.y)<rr*rr then
     e.hp-=b.dmg b.dead=true boom(b.x,b.y,4,7)
     if b.typ==1 then for o in all(en) do if not o.ally and not o.dead and o!=e and len2(b.x-o.x,b.y-o.y)<14*14 then o.hp-=1 if o.hp<=0 then o.dead=true killed+=1 score+=o.arm and 20 or 10 credits+=o.arm and 3 or 2 boom(o.x,o.y,8,14) add(dead_q,o) end end end end
     if e.hp<=0 then e.dead=true killed+=1 score+= e.arm and 20 or 10 credits+= e.arm and 3 or 2 boom(e.x,e.y,8,14) add(dead_q,e) end
     break
    end
   end
  end
 end
 flush_dead()
 if health<=0 then state="gameover" end
end

function upd_defense()
 if btnp(0) then cx=max(0,cx-16) end if btnp(1) then cx=min(112,cx+16) end
 if btnp(2) then cy=max(0,cy-16) end if btnp(3) then cy=min(112,cy+16) end
 if btnp(5) then tower_sel=(tower_sel+1)%4 end
 local base_cost={20,40,35,25}
 local discount=min(10,count_allies()*2)
 local cost={} for i=1,4 do cost[i]=max(5,base_cost[i]-discount) end
 if btnp(4) and credits>=cost[tower_sel+1] then
  local px=cx+8 local py=cy+8 local occ=false
  for t in all(towers) do if t.x==px and t.y==py then occ=true end end
  if not occ then add(towers,{x=px,y=py,typ=tower_sel,dmg=c_dmg[tower_sel+1],cd=c_cd[tower_sel+1],t=0}) credits-=cost[tower_sel+1] end
 end
 if btn(4) and btnp(5) then set_quota() to_brief("shooter") end
end

function upd_boss()
 if boss==nil then spawn_boss() end
 update_boss()
 local sp=c_spd[p.t+1]
 if btn(0) then p.a-=0.10 end if btn(1) then p.a+=0.10 end
 local ax=0 local ay=0
 if btn(2) then ax=cos(p.a)*sp ay=sin(p.a)*sp end
 if btn(3) then ax-=cos(p.a)*sp*0.5 ay-=sin(p.a)*sp*0.5 end
 p.vx=ax p.vy=ay
 p.x=clamp(p.x+p.vx,8,120) p.y=clamp(p.y+p.vy,8,120)
 push_out(p,t_now,lod)
 if btnp(5) then fire_inoc_bolt() end
 if (not boss.core) and (frame%240)==0 then for i=1,3 do spawn_enemy() end end
 p.cd=max(0,p.cd-1)
 if btn(4) and p.cd==0 then
  local cd=c_cd[p.t+1] local dmg=c_dmg[p.t+1] local ox=cos(p.a) local oy=sin(p.a)
  if p.t==1 then add(bul,{x=p.x+ox*6,y=p.y+oy*6,vx=ox*2,vy=oy*2,dmg=dmg,typ=1})
  elseif p.t==3 then for s=-1,1 do local a=p.a+s*0.18 add(bul,{x=p.x+cos(a)*6,y=p.y+sin(a)*6,vx=cos(a)*3,vy=sin(a)*3,dmg=1,typ=3}) end
  elseif p.t==2 then add(bul,{x=p.x+ox*6,y=p.y+oy*6,vx=ox*2.4,vy=oy*2.4,dmg=1,typ=2}) health=min(100,health+1)
  else add(bul,{x=p.x+ox*6,y=p.y+oy*6,vx=ox*3.5,vy=oy*3.5,dmg=1,typ=0}) end
  p.cd=cd
 end
 for i=#bul,1,-1 do local b=bul[i] b.x+=b.vx b.y+=b.vy if b.x<-8 or b.x>136 or b.y<-8 or b.y>136 or b.dead then del(bul,b) else boss_hit(b) end end
 for i=#en,1,-1 do
  local e=en[i]
  if e.ally and not e.dead then
   e.aura_cd=(e.aura_cd or 0)-1
   if e.aura_cd<=0 then
    for o in all(en) do if not o.ally and not o.dead and len2(e.x-o.x,e.y-o.y)<12*12 then o.hp-=1 if o.hp<=0 then o.dead=true killed+=1 score+=o.arm and 20 or 10 credits+=o.arm and 3 or 2 boom(o.x,o.y,8,14) add(dead_q,o) end end end
    e.aura_cd=30
   end
   e.x+=e.vx*0.3 e.y+=e.vy*0.3
  elseif not e.dead then
   if e.type=="wbc" then e.x+=e.vx e.y+=e.vy else e.s+=0.18 e.x+=e.vx+cos(e.s)*0.25 e.y+=e.vy+sin(e.s)*0.25 end
   push_out(e,t_now,lod)
   if not e.ally and len2(e.x-p.x,e.y-p.y) < (e.r+p.r)*(e.r+p.r) then health-= e.arm and 8 or 5 boom(e.x,e.y,8,8) e.dead=true add(dead_q,e) end
  end
 end
 flush_dead()
 if health<=0 then state="gameover" end
end

--========================================================
-- draw
--========================================================
function draw_sigil3d(cx,cy,scale,col)
 -- CONSTITUTIONAL GOVERNOR: if physics stressed, abort graphics
 if lod==0 then circfill(cx,cy,scale/2,col) return end

 local t=time()*2
 local ca, sa = cos(t/4), sin(t/4)
 local cb, sb = cos(t/3), sin(t/3)
 
 -- project vertices
 local proj={}
 for v in all(sigil_v) do
  -- rotate y (a)
  local x1=v[1]*ca - v[3]*sa
  local z1=v[1]*sa + v[3]*ca
  -- rotate x (b)
  local y2=v[2]*cb - z1*sb
  local z2=v[2]*sb + z1*cb
  
  -- perspective project
  -- SAFETY PATCH v1.3.2: Prevent divide by zero
  local z=max(0.1, 4+z2)
  local screen_x = cx + x1/z * scale * 10
  local screen_y = cy + y2/z * scale * 10
  add(proj,{x=screen_x,y=screen_y})
 end
 
 -- draw edges (nearest neighbors < 2.1 units)
 -- optimize: only draw if lod==2. if lod==1, just points
 if lod==2 then
  for i=1,#proj do
   for j=i+1,#proj do
    local d2 = len2(proj[i].x-proj[j].x, proj[i].y-proj[j].y)
    -- heuristic: connected verts are close on screen usually
    -- better: use math. dist in 3d is 2. 
    -- cheat: just connect reasonably close points for sigil effect
    if d2 < (scale*12)^2 then 
     line(proj[i].x,proj[i].y,proj[j].x,proj[j].y,col)
    end
   end
  end
 end
 
 -- draw verts
 for p in all(proj) do pset(p.x,p.y,7) end
end

function draw_walls()
 local t=time()
 local step= (lod==2 and 2) or (lod==1 and 3) or 4
 for x=0,127,step do
  local d=vein_sdf(x,center_y,t,lod)
  local r=d
  local y1=center_y-r
  local y2=center_y+r
  for dx=0,step-1 do pset(x+dx,y1,2) pset(x+dx,y1+1,2) pset(x+dx,y2,2) pset(x+dx,y2-1,2) end
 end
end

function draw_player()
 local col=c_col[p.t+1]
 local x=p.x local y=p.y
 circfill(x,y,3,col) pset(x+cos(p.a)*4,y+sin(p.a)*4,7)
 if p.t==2 then line(x-2,y,x+2,y,7) line(x,y-2,x,y+2,7)
 elseif p.t==1 then rect(x-2,y-2,x+2,y+2,9)
 elseif p.t==3 then line(x-3,y,x+1,y-2,10) line(x-3,y,x+1,y+2,10) end
end

function draw_enemies()
 for e in all(en) do
  if not e.dead then
   if e.type=="wbc" then
    local col=e.ally and 12 or 7
    circfill(e.x,e.y,3,col)
    for i=0,3 do local ang=e.a+i*1.57 line(e.x,e.y,e.x+cos(ang)*5,e.y+sin(ang)*5,col) end
    if e.confused then circfill(e.x,e.y,1+sin(time()*4),8) end
    if e.ally and lod>=2 and (e.aura_cd or 0)<5 then circ(e.x,e.y,12,12) end
   else
    local col=e.arm and 4 or 8
    local seg=10 local sx=cos(e.s)*2 local sy=sin(e.s)*2 local px,py
    for i=1,seg do
     local t=i/seg local a=e.a+t*2.6 local x=e.x+sx*cos(a) local y=e.y+sy*sin(a)
     if i==1 then px=x py=y else line(px,py,x,y,col) px=x py=y end
    end
   end
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
 for t in all(towers) do rectfill(t.x-4,t.y-4,t.x+4,t.y+4,5) rectfill(t.x-2,t.y-2,t.x+2,t.y+2,7) end
end

function draw_boss()
 if not boss then return end
 local t=time()
 local mem=boss.mem + (lod>0 and boss.visual_jitter or 0)
 circfill(boss.x,boss.y,mem,2)
 for i=1,boss.lobes do
  local ang=i/boss.lobes*6.28 + boss.drift
  local wob=sin(t*2+ang*3+i)*boss.inst
  local lr=6+wob local ld=mem+4+wob*2
  local lx=boss.x+cos(ang)*ld local ly=boss.y+sin(ang)*ld
  circfill(lx,ly,lr, boss.core and 14 or 8) line(boss.x,boss.y,lx,ly,2)
 end
 
 if boss.core then
  -- PHASE 3: THE SIGIL REVEALED
  draw_sigil3d(boss.x,boss.y,1.5,12)
 else
  circfill(boss.x,boss.y,4+sin(t*boss.pf*2),9)
 end
 
 if lod>0 and boss.inst>1 then
  local rings=(boss_stage()>=3) and 2 or 1
  for i=1,rings do if sin(t*4+i)>0.2 then circ(boss.x,boss.y,mem+2+i*3,8) end end
 end
 rectfill(20,4,108,6,0) rectfill(20,4,20+ (boss.hp/boss.mhp)*88,6,8)
end

function draw_hud()
 print("wave "..wave,1,1,7) print("hp "..health,1,8,11)
 print("cr "..credits,1,15,10) print("sc "..score,78,1,7)
 print("cpu "..flr(cpu*100).."%",78,8,6) print("lod "..lod,78,15,6)
 local ready=inoc_bolt.cooldown==0
 local pct=1-(inoc_bolt.cooldown/inoc_bolt.max_cooldown)
 rectfill(98,120,126,124,0)
 local bar_w=flr(26*pct)
 rectfill(99,121,99+bar_w,123,ready and 12 or 6)
 rect(98,120,126,124,ready and 12 or 5)
 print("inoc",100,115,ready and 12 or 6)
 local ac=count_allies()
 if ac>0 then print("allies:"..ac,1,22,12) end
end

--========================================================
-- main
--========================================================
frame=0
function _init()
 init_sigil()
end

function _update60() _update() end

function _update()
 frame+=1
 if state=="crawl" then
  if frame>120 then state="menu" end
 elseif state=="menu" then
  if btnp(0) then sel=(sel+3)%4 end if btnp(1) then sel=(sel+1)%4 end
  if btnp(4) then start_run() end
 elseif state=="brief" then
  brief_t-=1
  if brief_t<=0 then state=next_state if state=="shooter" then set_quota() end end
 elseif state=="shooter" then upd_common() upd_shooter()
 elseif state=="defense" then upd_common() upd_defense()
 elseif state=="boss" then upd_common() upd_boss()
 elseif state=="gameover" then if btnp(4) then state="menu" frame=0 end end
end

function _draw()
 cls(1)
 if state=="crawl" then
  cls(0)
  print("patient: human host",18,44,7) print("condition: infection - stage ii",8,54,7)
  print("autonomous response insufficient",10,68,8) print("micro-intervention authorized",14,78,8)
  print("deploy the corpuscle crew",18,94,11)
  return
 end
 if state=="menu" then
  cls(0)
  -- SIGIL ON MENU
  draw_sigil3d(64,15,1,12)
  print("the corpuscle crew",28,30,11)
  print("constitutional edition v1.3.2",20,40,6)
  print("select crew",42,50,7)
  for i=0,3 do
   local y=66+i*12
   local col=(i==sel) and 11 or 6
   print((i==sel and "> " or "  ")..crew_name[i+1],40,y,col)
  end
  print("arrows: select  |  z: deploy",18,100,6)
  print("controls:",32,108,7)
  print("arrows=move  z=shoot  x=bolt",16,116,6)
  return
 end

 draw_walls()
 if inoc_bolt.active then
  circfill(inoc_bolt.x,inoc_bolt.y,2,12)
  local tx=inoc_bolt.x-inoc_bolt.vx*2 local ty=inoc_bolt.y-inoc_bolt.vy*2
  circfill(tx,ty,1,12)
  if inoc_bolt.age<5 then circ(inoc_bolt.x,inoc_bolt.y,3,7) end
 end
 if vein_shake.active and vein_shake.decay>0 and lod>=1 then
  local x=vein_shake.x
  for i=1,3 do local r=(10-vein_shake.decay)*i*3 if vein_shake.decay>3 then circ(x,center_y,r,7) end end
 end
 draw_towers()
 for c in all(cells) do circfill(c.x,c.y,c.r,13) end
 for pt in all(parts) do pset(pt.x,pt.y,pt.c) end
 draw_enemies()
 draw_bullets()
 if state=="boss" then draw_boss() end
 if state=="shooter" or state=="boss" then draw_player() end
 draw_hud()
 if state=="brief" then
  rectfill(18,52,110,78,0) rect(18,52,110,78,11)
  print("mission briefing",30,56,11) print("wave "..wave,52,66,7) print(next_state,52,72,8)
 end
 if state=="defense" then
  for x=0,128,16 do line(x,0,x,127,3) end
  for y=0,128,16 do line(0,y,127,y,3) end
  rect(cx,cy,cx+15,cy+15,11) rectfill(0,100,127,127,0)
  print("defense: z=place  x+z=continue",4,102,7)
  print("tower: "..crew_name[tower_sel+1],4,110, c_col[tower_sel+1])
  local base_cost={20,40,35,25} local ac=count_allies() local discount=min(10,ac*2)
  local cost=max(5,base_cost[tower_sel+1]-discount)
  print("cost "..cost,4,118,10) if discount>0 then print("(-"..discount..")",36,118,12) end
  print("x: cycle tower",78,110,6)
 end
 if state=="gameover" then
  rectfill(18,50,110,86,0) rect(18,50,110,86,8)
  print("crew member down",28,56,8) print("score "..score,36,68,7) print("press z",48,78,11)
 end
end
__gfx__
