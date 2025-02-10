require "utils.music"
require "utils.sound"
require "sprites.background"
require "sprites.glow"
require "sprites.decorations"
require "sprites.player"
require "sprites.fireballs"
require "sprites.explosion"
require "sprites.ghost"
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
    love.window.setPosition(0, 0, 2)
    love.window.maximize()
    love.graphics.setDefaultFilter("nearest", "nearest")
    canvas = love.graphics.newCanvas(virtual_width, virtual_height)
    sound:load()
    music:load()
    background:load()
    decorations:load()
    player:load()
    tilemap:load()
    glow:load()
    fireballs:load()
    explosion:load()
    ghost:load()
    glow.decoration_positions = decorations:get_pumpkin_positions()
end

function love.update(dt)
    glow:update(dt)
    player:update(dt)
    fireballs:update(dt)
    explosion:update(dt)
    tilemap:update(dt)
    decorations:update(dt)
    background:update(dt)
    ghost:update(dt)
    glow.fireball_positions = fireballs:get_fireball_positions()

    player.collides = false

    for i = 1, #tilemap.collision_rects do
        tilemap.collision_rects[i].collides = false
        if collides(player.collision_rect, tilemap.collision_rects[i], "tile") then
            player.position.x = player.collision_rect.x + (player.collision_rect.width / 2)
            player.attacked_velocity = 0.0
            if player.state == "crouching" then
                player.position.y = player.collision_rect.y + (player.collision_rect.height * 0.3)
            else
                player.position.y = player.collision_rect.y + (player.collision_rect.height / 2)
            end
            player.collides = true
            tilemap.collision_rects[i].collides = true
        end
    end

    if player.attacked_velocity == 0.0 and not player.attacked then
        for i = #fireballs.list, 1, -1 do
            local fireball = fireballs.list[i]
            if distance(player.collision_rect.x, player.collision_rect.y, fireball.collision_rect.x, fireball.collision_rect.y) < 200 and collides(player.collision_rect, fireball.collision_rect, "fireball") then
                table.remove(fireballs.list, i)
                decorations:add_shake_effect()
                tilemap:add_shake_effect()
                background:add_shake_effect()
                sound.attacked:play()
                explosion:spawn(fireball.collision_rect.x + fireballs.texture:getWidth() / 2,
                    fireball.collision_rect.y + fireballs.texture:getHeight() / 2)
                player.attacked_direction = (fireball.velocity > 0 and 1) or -1
                player.attacked_velocity = 500 * player.attacked_direction
                player.attacked = true
                player.y_velocity = -player.jump_velocity / 1.25
            end
        end
    end
end

function love.draw()
    love.graphics.clear()
    love.graphics.setCanvas(canvas)
    love.graphics.clear(0, 0, 0, 1)
    background:draw()
    tilemap:draw()
    decorations:draw()
    player:draw()
    fireballs:draw()
    glow:draw()
    explosion:draw()
    ghost:draw()
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
