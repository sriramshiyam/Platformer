require "utils.music"
require "sprites.background"
require "sprites.glow"
require "sprites.decorations"
require "sprites.player"
require "sprites.fireballs"
require "utils.tilemap"
require "utils.collision"

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
    music:load()
    background:load()
    decorations:load()
    player:load()
    tilemap:load()
    glow:load()
    fireballs:load()
    glow.decoration_positions = decorations:get_pumpkin_positions()
end

function love.update(dt)
    glow:update(dt)
    player:update(dt)
    fireballs:update(dt)
    glow.fireball_positions = fireballs:get_fireball_positions()
    player.collides = false
    for i = 1, #tilemap.collision_rects do
        tilemap.collision_rects[i].collides = false
        if collides(player.collision_rect, tilemap.collision_rects[i]) then
            player.position.x = player.collision_rect.x + (player.collision_rect.width / 2)
            if player.state == "crouching" then
                player.position.y = player.collision_rect.y + (player.collision_rect.height * 0.3)
            else
                player.position.y = player.collision_rect.y + (player.collision_rect.height / 2)
            end
            player.collides = true
            tilemap.collision_rects[i].collides = true
        end
    end
end

function love.draw()
    glow:draw()
    love.graphics.clear()
    love.graphics.setCanvas(canvas)
    love.graphics.clear(0, 0, 0, 1)
    background:draw()
    tilemap:draw()
    decorations:draw()
    player:draw()
    fireballs:draw()
    glow:draw()
    print_memory_usage()
    love.graphics.setCanvas()
    draw_canvas()
end

function print_memory_usage()
    local luaMemory = collectgarbage("count") / 1024
    local stats = love.graphics.getStats()
    local textureMemory = stats.texturememory / 1024 / 1024

    love.graphics.print(string.format("RAM Memory: %.2f MB", luaMemory), 10, 10)
    love.graphics.print(string.format("GPU Memory: %.2f MB", textureMemory), 10, 30)
end
