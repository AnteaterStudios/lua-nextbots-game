local sky
local nb_tex
local nb_mat
local headset_pos
local headset_angle
local headset_ax
local headset_ay
local headset_az
local nb_pos
local nb_vel = 3

function lovr.load()
  sky = lovr.graphics.newTexture("sky.jpg")
  nb_tex = lovr.graphics.newTexture('obunga.png', { mipmaps = false })
  nb_mat = lovr.graphics.newMaterial(nb_tex)
  nb_pos = lovr.math.newVec3(10, 10, 10)
end

function lovr.update(dt)
  headset_pos = lovr.math.newVec3(lovr.headset.getPosition())
  headset_angle, headset_ax, headset_ay, headset_az = lovr.headset.getOrientation()

  local distance = nb_pos:distance(headset_pos)
  nb_pos = nb_pos:lerp(headset_pos, (nb_vel / distance) * dt)
end

function lovr.draw()
  lovr.graphics.skybox(sky)

  local x, y, z = nb_pos:unpack()
  lovr.graphics.plane(nb_mat, x, y, z, 2.5, 2.5, headset_angle, headset_ax, headset_ay, headset_az)

  lovr.graphics.plane('fill', 0, 0, 0, 10, 10, math.rad(90), 1, 0, 0)
end