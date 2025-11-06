local utils = require("utils")

if arg[2] == "debug" then
  require("lldebugger").start()
end

TAU = math.pi * 2

local bodies = {
  {
    ["size"] = 40,
    ["period"] = 10,
    ["color"] = { 1, 1, 1 },
    ["phase"] = 0,
  }
}

local time = 0 -- game days passed
local timescale = .25 -- game days per real second

local skyImage
local skyImageSize = 1024
local skyCanvas
local canvasSize = 2048
local eclipticRadius = 256
local skyPeriod = 10

function love.load()
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

  love.graphics.setDefaultFilter('nearest', 'nearest')
  skyImage = love.graphics.newImage("sky.png")
  skyCanvas = love.graphics.newCanvas(canvasSize, canvasSize)
end

function love.update(dt)
  local elapsed = dt * timescale -- days passed this frame
  time = time + elapsed

  for i, body in ipairs(bodies) do
    body["phase"] = (body["phase"] + elapsed / body["period"]) % 1
  end
end

local width, height = love.window.getMode()
local ex = width * .5
local ey = height * .5
local erx = width * 1.2 / 2
local ery = height * .6 / 2

function love.draw()
  love.graphics.setColor(1, 1, 1)

  local cscalex = erx / eclipticRadius

  -- love.graphics.draw(skyImage, ex, ey, 7 / 8 * TAU, 1, 1, 512, 512)
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

  love.graphics.ellipse("line", ex, ey, erx, ery)

  for i, body in ipairs(bodies) do
    love.graphics.setColor(body["color"])
    love.graphics.circle("fill",
      ex + math.sin(body["phase"] * TAU) * erx,
      ey - math.cos(body["phase"] * TAU) * ery,
      body["size"])
  end
end

-- Error handling

local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
  if lldebugger then
    error(msg, 2)
  else
    return love_errorhandler(msg)
  end
end
