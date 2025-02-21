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
require "utils.hud"

game = {}

function game:load()
    hud:load()
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

function game:update(dt)
    if not loading.enabled then
        sound:update(dt)
        hud:update(dt)
    end
    glow:update(dt)
    player:update(dt)
    if sound.start_sound.index > 4 then
        fireballs:update(dt)
        ghost:update(dt)
    end
    explosion:update(dt)
    tilemap:update(dt)
    decorations:update(dt)
    background:update(dt)
    glow.fireball_positions = fireballs:get_fireball_positions()
    glow.ghost_position.x = ghost.position.x
    glow.ghost_position.y = ghost.position.y
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
                player.health = player.health - 1
                return
            end
        end

        if not ghost.is_exploding and distance(player.collision_rect.x, player.collision_rect.y, ghost.position.x, ghost.position.y) < 200 then
            if collides(player.collision_rect, ghost.collision_rect, "ghost") then
                decorations:add_shake_effect()
                tilemap:add_shake_effect()
                background:add_shake_effect()
                sound.attacked:play()
                player.attacked_direction = (ghost.position.x < player.position.x and 1) or -1
                player.attacked_velocity = 500 * player.attacked_direction
                player.y_velocity = -player.jump_velocity / 1.25
                player.attacked = true
                player.health = player.health - 1
                ghost.is_enabled = false
                ghost:explode()
                sound.ghost:play()
            end
        end
    end
end

function game:draw()
    background:draw()
    tilemap:draw()
    decorations:draw()
    player:draw()
    fireballs:draw()
    ghost:draw()
    glow:draw()
    explosion:draw()
    if not loading.enabled then
        hud:draw()
    end
end
