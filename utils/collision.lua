function collides(player_rect, object_rect, type)
    local aabb_info = object_rect.aabb_info

    local half1 = { x = player_rect.width / 2, y = player_rect.height / 2 }
    local center1 = {
        x = player_rect.x + half1.x,
        y = player_rect.y + half1.y
    }

    local half2 = { x = object_rect.width / 2, y = object_rect.height / 2 }
    local center2 = {
        x = object_rect.x + half2.x,
        y = object_rect.y + half2.y
    }

    local delta = { x = math.abs(center1.x - center2.x), y = math.abs(center1.y - center2.y) }

    aabb_info.overlap_x = half1.x + half2.x - delta.x
    aabb_info.overlap_y = half1.y + half2.y - delta.y

    if aabb_info.overlap_x > 0 and aabb_info.overlap_y > 0 then
        if aabb_info.previous_overlap_y > 0 then
            player_rect.x = player_rect.x + ((center1.x < center2.x and -aabb_info.overlap_x) or aabb_info.overlap_x)
        elseif aabb_info.previous_overlap_x > 0 then
            player_rect.y = player_rect.y + ((center1.y < center2.y and -aabb_info.overlap_y) or aabb_info.overlap_y)
            if type == "tile" then
                if center1.y < center2.y then
                    if player.y_velocity > 0 then
                        player.in_air = false
                        player.y_velocity = 0
                        player.can_animate = true
                    end
                else
                    player.y_velocity = 0
                    player.can_animate = true
                end
            elseif type == "ghost" then
                if center1.y < center2.y and player.in_air then
                    player.y_velocity = -player.jump_velocity / 1.25
                    ghost.is_enabled = false
                    ghost:explode()
                    sound.ghost:play()
                    return false
                end
            end
        else
            player.y_velocity = 0
            player_rect.x = player_rect.x + ((center1.x < center2.x and -aabb_info.overlap_x) or aabb_info.overlap_x)
            player_rect.y = player_rect.y + ((center1.y < center2.y and -aabb_info.overlap_y) or aabb_info.overlap_y)
        end
    else
        aabb_info.previous_overlap_x = aabb_info.overlap_x
        aabb_info.previous_overlap_y = aabb_info.overlap_y
    end

    return aabb_info.overlap_x >= 0 and aabb_info.overlap_y >= 0
end

function distance(x1, y1, x2, y2)
    return math.sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2)
end
