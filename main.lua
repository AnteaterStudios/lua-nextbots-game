-- constants
local NB_SIZE = 2.5
local RANDOM_POS_MAX = 50
local DOOR_SIZE_X = 2
local DOOR_SIZE_Y = 3
local JUMP_CHANCE = 0.05 -- chance of jumping each second (value between 0 and 1)
local JUMP_MAXHEIGHT = 3
local JUMP_DURATION = 1

local SOUND_CHANCE = {min = 1, max = 6}

-- variables
local sky
local headset_pos
local headset_angle
local headset_ax
local headset_ay
local headset_az
local wood_tex

--local plr = require("player.lua")

--[[--
/ dsound = death sound (when you die it will happen this soundtrack)
#---------
/ sLoop = sound loop (this constant returns the rules of the sound track, example: if its on, then the next bot sound track will loop every time,
/ if not, then the nextbot will play the track randomly)
#---------
/ sound = nextbot sound track (the nextbot will play this sound track randomly if sLoop (sound loop / bool) is false (off), else it will repeat the track several times)
#---------
--]]--

local doors = {
  {is_destroyed = false, rot = lovr.math.newQuat(math.rad(90), 0, 0, 0), pos = lovr.math.newVec3(4, DOOR_SIZE_Y / 2, 0)}
}

local nextbots = {
  ['obunga'] = {image = "nextbots/obunga/obunga.jpg", sound = "", dsound = "", vel = 4, pos = lovr.math.newVec3(0, NB_SIZE / 2, 0), tex = nil, mat = nil, sLoop = false, timeJumping = -1},
  ['baller'] = {image = "nextbots/baller/baller.jpeg", sound = "", dsound = "", vel = 6, pos = lovr.math.newVec3(0, NB_SIZE / 2, 0), tex = nil, mat = nil, sLoop = true, timeJumping = -1},
  ['rock'] = {image = "nextbots/rock/rock.jpeg", sound = "nextbots/rock/death.mp3", dsound = "nextbots/rock/death.mp3", vel = 5, pos = lovr.math.newVec3(0, NB_SIZE / 2, 0), tex = nil, mat = nil, sLoop = false, timeJumping = -1},
  ['spongebob'] = {image = "nextbots/bob/bob.jpeg", sound = "", dsound = "", vel = 5.5, pos = lovr.math.newVec3(0, NB_SIZE / 2, 0), tex = nil, mat = nil, sLoop = false, timeJumping = -1}
}

local function nbJump(duration, max_height, time)
  return (4*max_height*time*(duration-time))/(duration^2)
end

function lovr.load()
  sky = lovr.graphics.newTexture("sky.jpg", {})
  wood_tex = lovr.graphics.newMaterial(lovr.graphics.newTexture("materials/wood.jpeg", {}))

  for k, v in pairs(nextbots) do
    v.tex = lovr.graphics.newTexture(v.image, {})
    v.mat = lovr.graphics.newMaterial(v.tex)
    v.pos = lovr.math.newVec3(lovr.math.random(-RANDOM_POS_MAX, RANDOM_POS_MAX), NB_SIZE / 2, lovr.math.random(-RANDOM_POS_MAX, RANDOM_POS_MAX))

    -- if math.random(SOUND_CHANCE.min, SOUND_CHANCE.max) == 1 then
    --   local x, y, z = v.pos:unpack()
    --   lovr.sound.setPosition(x, y, z)
    --   lovr.audio.newSource(v.sound)
    -- end
  end
end

function lovr.update(dt)
  headset_pos = lovr.math.newVec3(lovr.headset.getPosition())
  headset_angle, headset_ax, headset_ay, headset_az = lovr.headset.getOrientation()

  --plr.updFunc(dt)

  for k, v in pairs(nextbots) do
    local distance = v.pos:distance(headset_pos)
    local nb_pos_tmp = v.pos:lerp(headset_pos, (v.vel / distance) * dt)
    v.pos = lovr.math.newVec3(nb_pos_tmp.x, NB_SIZE / 2, nb_pos_tmp.z)
    local x, y, z = v.pos:unpack()
    if v.timeJumping < 0 then
      local jumpChance = dt * JUMP_CHANCE
      local rnd = lovr.math.random()
      if rnd <= jumpChance then
        v.timeJumping = 0
      end
    elseif v.timeJumping >= 0 and v.timeJumping < JUMP_DURATION then
      local jump = nbJump(JUMP_DURATION, JUMP_MAXHEIGHT, v.timeJumping)
      v.pos = lovr.math.newVec3(x, y + jump, z)
      v.timeJumping = v.timeJumping + dt
    else
      v.timeJumping = -1
    end
  end

  for i = 1, #doors, 1 do
    local dist = doors[i].pos:distance(headset_pos)
    if dist <= 1.5 then
      doors[i].is_destroyed = true
    end
  end
end

function lovr.draw(pass)
  lovr.graphics.skybox(sky)

  --plr.drwFunc(pass)

  for k, v in pairs(nextbots) do
    local x, y, z = v.pos:unpack()
    lovr.graphics.plane(v.mat, x, y, z, 2.5, 2.5, headset_angle, headset_ax, headset_ay, headset_az) -- next bot image / body
  end

  -- hands
  for i, hand in ipairs(lovr.headset.getHands()) do
    local x, y, z = lovr.headset.getPosition(hand)
    --pass:sphere(x, y, z, .1)
  end
  
  -- others
  lovr.graphics.plane(wood_tex, 0, 0, 0, 40, 40, math.rad(90), 1, 0, 0) -- floor
  lovr.graphics.plane(wood_tex, 20, 0, 0, 20, 40, math.rad(90), 0, 0, 0) -- wall

  for i = 1, #doors, 1 do
    if doors[i].is_destroyed == false then
      local angle, ax, ay, az = doors[i].rot:unpack()
      lovr.graphics.plane(wood_tex, doors[i].pos.x, doors[i].pos.y, doors[i].pos.z, DOOR_SIZE_X, DOOR_SIZE_Y, angle, ax, ay, az)
    end
  end
end