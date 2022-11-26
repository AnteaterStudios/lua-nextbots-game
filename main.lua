-- constants
local NB_SIZE = 2.5
-- variables
local sky
local headset_pos
local headset_angle
local headset_ax
local headset_ay
local headset_az

local nextbots = {
  obunga = {name = "obunga", image = "obunga.png", sound = "", vel = 3, pos = lovr.math.newVec3(0, NB_SIZE / 2, 0), tex = nil, mat = nil};
  baller = {name = "baller", image = "baller.png", sound = "", vel = 3, pos = lovr.math.newVec3(0, NB_SIZE / 2, 0), tex = nil, mat = nil};
  rock = {name = "rock", image = "rock.png", sound = "death.mp3", vel = 3, pos = lovr.math.newVec3(0, NB_SIZE / 2, 0), tex = nil, mat = nil};
  bob = {name = "spongebob", image = "bob.jpeg", sound = "", vel = 3, pos = lovr.math.newVec3(0, NB_SIZE / 2, 0), tex = nil, mat = nil};
}

function lovr.load()
  sky = lovr.graphics.newTexture("sky.jpg", {})

  for i = #nextbots, 1, -1 do
    nextbots[i].tex = lovr.graphics.newTexture(nextbots[i].image, {})
    nextbots[i].mat = lovr.graphics.newMaterial(nextbots[i].tex)
    nextbots[i].pos = lovr.math.newVec3(lovr.math.random(1, 10), NB_SIZE / 2, lovr.math.random(1, 10))
  end
end

function lovr.update(dt)
  headset_pos = lovr.math.newVec3(lovr.headset.getPosition())
  headset_angle, headset_ax, headset_ay, headset_az = lovr.headset.getOrientation()

  for i = #nextbots, 1, -1 do
    local distance = nextbots[i].pos:distance(headset_pos)
    local nb_pos_tmp = nextbots[i].pos:lerp(headset_pos, (nextbots[i].vel / distance) * dt)
    nextbots[i].pos = lovr.math.newVec3(nb_pos_tmp.x, NB_SIZE / 2, nb_pos_tmp.z)
  end
end

function lovr.draw()
  lovr.graphics.skybox(sky)

  for i = #nextbots, 1, -1 do
    local x, y, z = nextbots[i].pos:unpack()
    lovr.graphics.plane(nextbots[i].mat, x, y, z, 2.5, 2.5, headset_angle, headset_ax, headset_ay, headset_az) -- next bot image / body
  end

  lovr.graphics.plane('fill', 0, 0, 0, 20, 20, math.rad(90), 1, 0, 0) -- floor
end