-- constants
local NB_SIZE = 2.5
local RANDOM_POS_MAX = 50

local configs = require("Settings.lua")

-- variables
local sky
local headset_pos
local headset_angle
local headset_ax
local headset_ay
local headset_az
local nextbots = {
  ['obunga'] = {image = "obunga.png", sound = "", vel = 4, pos = lovr.math.newVec3(0, NB_SIZE / 2, 0), tex = nil, mat = nil},
  ['baller'] = {image = "baller.png", sound = "", vel = 6, pos = lovr.math.newVec3(0, NB_SIZE / 2, 0), tex = nil, mat = nil},
  ['rock'] = {image = "rock.png", sound = "death.mp3", vel = 5, pos = lovr.math.newVec3(0, NB_SIZE / 2, 0), tex = nil, mat = nil},
  ['spongebob'] = {image = "bob.jpeg", sound = "", vel = 5.5, pos = lovr.math.newVec3(0, NB_SIZE / 2, 0), tex = nil, mat = nil}
}



-- script:

function lovr.load()
  sky = lovr.graphics.newTexture("sky.jpg", {})
  floor_tex = lovr.graphics.newTexture("floor.jpeg", {})
  floor_mat = lovr.graphics.newMaterial(floor_tex)
  -- floor_mat.uvScale = {4, 4}
  wall_tex = lovr.graphics.newTexture("wall.png", {})
  wall_mat = lovr.graphics.newMaterial(wall_tex)

  for k,v in pairs(nextbots) do
    v.tex = lovr.graphics.newTexture(v.image, { mipmaps = true })
    v.mat = lovr.graphics.newMaterial(v.tex)
    v.pos = lovr.math.newVec3(lovr.math.random(-RANDOM_POS_MAX, RANDOM_POS_MAX), NB_SIZE / 2, lovr.math.random(-RANDOM_POS_MAX, RANDOM_POS_MAX))
  end
end

function lovr.update(dt)
  headset_pos = lovr.math.newVec3(lovr.headset.getPosition())
  headset_angle, headset_ax, headset_ay, headset_az = lovr.headset.getOrientation()

  for i, v in pairs(nextbots) do
    local distance = v.pos:distance(headset_pos)
    local nb_pos_tmp = v.pos:lerp(headset_pos, (v.vel / distance) * dt)
    v.pos = lovr.math.newVec3(nb_pos_tmp.x, NB_SIZE / 2, nb_pos_tmp.z)

    if configs.FogMode == true then
      
    end

    if distance <= 3 then
      -- player dies
      if configs.JumpScare == true then
        -- add jumpscare script

      else
        -- put code here if the player don't want jumpscares! :trollface:

      end
    end
  end
end

function lovr.draw(pass)
  lovr.graphics.skybox(sky)

  for k,v in pairs(nextbots) do
    local x, y, z = v.pos:unpack()
    lovr.graphics.plane(v.mat, x, y, z, 2.5, 2.5, headset_angle, headset_ax, headset_ay, headset_az) -- next bot image / body
  end

  lovr.graphics.plane(floor_mat, 0, 0, 0, 40, 40, math.rad(90), 1, 0, 0) -- floor
  lovr.graphics.plane(wall_mat, 0, 0, 0, 40, 40, math.rad(0), 1, 0, 0) -- wall
end