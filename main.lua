-- constants
local NB_SIZE = 2.5
local RANDOM_POS_MAX = 50

-- variables
local sky
local headset_pos
local headset_angle
local headset_ax
local headset_ay
local headset_az

local nextbots = {
  ['obunga'] = {image = "obunga.png", sound = "", vel = 3, pos = lovr.math.newVec3(0, NB_SIZE / 2, 0), tex = nil, mat = nil},
  ['baller'] = {image = "baller.png", sound = "", vel = 3, pos = lovr.math.newVec3(0, NB_SIZE / 2, 0), tex = nil, mat = nil},
  ['rock'] = {image = "rock.png", sound = "death.mp3", vel = 3, pos = lovr.math.newVec3(0, NB_SIZE / 2, 0), tex = nil, mat = nil},
  ['spongebob'] = {image = "bob.jpeg", sound = "", vel = 3, pos = lovr.math.newVec3(0, NB_SIZE / 2, 0), tex = nil, mat = nil}
}

function lovr.load()
  sky = lovr.graphics.newTexture("sky.jpg", {})

  for k,v in pairs(nextbots) do
    v.tex = lovr.graphics.newTexture(v.image, {})
    v.mat = lovr.graphics.newMaterial(v.tex)
    v.pos = lovr.math.newVec3(lovr.math.random(-RANDOM_POS_MAX, RANDOM_POS_MAX), NB_SIZE / 2, lovr.math.random(-RANDOM_POS_MAX, RANDOM_POS_MAX))
  end
end

function lovr.update(dt)
  headset_pos = lovr.math.newVec3(lovr.headset.getPosition())
  headset_angle, headset_ax, headset_ay, headset_az = lovr.headset.getOrientation()

  for k,v in pairs(nextbots) do
    local distance = v.pos:distance(headset_pos)
    local nb_pos_tmp = v.pos:lerp(headset_pos, (v.vel / distance) * dt)
    v.pos = lovr.math.newVec3(nb_pos_tmp.x, NB_SIZE / 2, nb_pos_tmp.z)
  end
end

function lovr.draw()
  lovr.graphics.skybox(sky)

  for k,v in pairs(nextbots) do
    local x, y, z = v.pos:unpack()
    lovr.graphics.plane(v.mat, x, y, z, 2.5, 2.5, headset_angle, headset_ax, headset_ay, headset_az) -- next bot image / body
  end

  lovr.graphics.plane('fill', 0, 0, 0, 40, 40, math.rad(90), 1, 0, 0) -- floor
end