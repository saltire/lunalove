local sky = require("sky")

if arg[2] == "debug" then
  require("lldebugger").start()
end

TAU = math.pi * 2

local time = 0 -- game days passed
local timescale = .25 -- game days per real second

-- Callbacks

function love.load()
  sky.initSkybox()
  sky.initBodies()
end

function love.update(dt)
  local elapsed = dt * timescale -- days passed this frame
  time = time + elapsed

  sky.moveBodies(elapsed)
end

function love.draw()
  sky.drawSkybox(time)
  sky.drawBodies()
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
