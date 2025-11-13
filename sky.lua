local utils = require("utils")

local sky = {}

local width, height = love.window.getMode()

-- Ecliptic ellipse
local ex = width * .5
local ey = height * .5
local erx = width * 1.2 / 2
local ery = height * .6 / 2

-- Skybox

local skyImage
local skyImageSize = 1024
local eclipticRadius = 256 -- Pixels in the sky image
local skyCanvas
local canvasSize = 2048
local skyPeriod = 10 -- Game days for a full rotation

function sky.initSkybox()
  skyImage = love.graphics.newImage("sky.png")
  skyCanvas = love.graphics.newCanvas(canvasSize, canvasSize)
end

function sky.drawSkybox(time)
  local cscalex = erx / eclipticRadius

  love.graphics.setColor(1, 1, 1)

  skyCanvas:renderTo(function ()
    love.graphics.draw(skyImage,
      canvasSize / 2, canvasSize / 2,
      time / skyPeriod * TAU,
      1, 1,
      skyImageSize / 2, skyImageSize / 2)
  end)

  love.graphics.draw(skyCanvas,
    ex, ey,
    0,
    cscalex, cscalex * ery / erx,
    canvasSize / 2, canvasSize / 2)
end

-- Bodies

local bodies = {
  {
    ["size"] = 40,
    ["period"] = 10,
    ["color"] = { 1, 1, 1 },
    ["phase"] = 0,
  }
}

function sky.initBodies()
  for i = 2, 10 do
    bodies[i] = {
      ["size"] = love.math.random(2, 32),
      ["period"] = love.math.random(8, 80),
      ["color"] = utils.hsl(
        love.math.random(),
        utils.randomFloat(0, .6),
        utils.randomFloat(.5, 1)),
      ["phase"] = love.math.random(),
    }
  end
end

function sky.moveBodies(elapsed)
  for i, body in ipairs(bodies) do
    body["phase"] = (body["phase"] + elapsed / body["period"]) % 1
  end
end

function sky.drawBodies()
  love.graphics.ellipse("line", ex, ey, erx, ery)

  for i, body in ipairs(bodies) do
    love.graphics.setColor(body["color"])
    love.graphics.circle("fill",
      ex + math.sin(body["phase"] * TAU) * erx,
      ey - math.cos(body["phase"] * TAU) * ery,
      body["size"])
  end
end

return sky
