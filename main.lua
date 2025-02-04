require "sprites.background"
require "sprites.player"
require "utils.tilemap"

virtual_height = 1080
virtual_width = 1872

local canvas

canvasOffsetX = 0
canvasOffsetY = 0

function draw_canvas()
    local windowWidth, windowHeight = love.graphics.getDimensions()

    local scale = math.min(windowWidth / virtual_width, windowHeight / virtual_height)

    canvasOffsetX = (windowWidth - virtual_width * scale) / 2
    canvasOffsetY = (windowHeight - virtual_height * scale) / 2

    love.graphics.draw(canvas, canvasOffsetX, canvasOffsetY, 0, scale, scale)
end

function love.load()
    love.window.setTitle("Platformer")
    love.window.setMode(800, 600, { resizable = true })
    love.window.maximize()
    love.graphics.setDefaultFilter("nearest", "nearest")
    canvas = love.graphics.newCanvas(virtual_width, virtual_height)
    background:load()
    player:load()
    tilemap:load()
end

function love.update(dt)
    player:update(dt)
end

function love.draw()
    love.graphics.clear()
    love.graphics.setCanvas(canvas)
    love.graphics.clear(0, 0, 0, 1)
    background:draw()
    tilemap:draw()
    player:draw()
    love.graphics.setCanvas()
    draw_canvas()
end