fireballs = {}

function fireballs:load()
    self.texture = love.graphics.newImage("res/image/fireball.png")
    self.spawn_timer = 1.05
    self.list = {}
end

function fireballs:update(dt)
    self.spawn_timer = self.spawn_timer - dt
    if self.spawn_timer < 0.0 then
        self.spawn_timer = 1.05
        self:spawn()
    end

    for i = #self.list, 1, -1 do
        local fireball = self.list[i]

        if fireball.position.x < -500 or fireball.position.x > (virtual_width + 500) then
            table.remove(self.list, i)
        else
            fireball.position.x = fireball.position.x + fireball.velocity * dt
            fireball.add_fire_timer = fireball.add_fire_timer - dt
            fireball.collision_rect.x = fireball.position.x - self.texture:getWidth() / 2 * 2.5
            fireball.collision_rect.y = fireball.position.y - self.texture:getHeight() / 2 * 2.5

            if fireball.add_fire_timer < 0.0 then
                fireball.add_fire_timer = 0.01
                table.insert(fireball.fires, { initialized = false })
            end
            self:handle_fires(fireball.fires, fireball.position, dt)
        end
    end
end

function fireballs:draw()
    for i = 1, #self.list do
        local fireball = self.list[i]
        local fires = self.list[i].fires

        for j = 1, #fires do
            local fire = fires[j]

            local x1 = fire.position.x + fire.vertices.x1 * fire.size
            local y1 = fire.position.y + fire.vertices.y1 * fire.size
            local x2 = fire.position.x + fire.vertices.x2 * fire.size
            local y2 = fire.position.y + fire.vertices.y2 * fire.size
            local x3 = fire.position.x + fire.vertices.x3 * fire.size
            local y3 = fire.position.y + fire.vertices.y3 * fire.size
            local x4 = fire.position.x + fire.vertices.x4 * fire.size
            local y4 = fire.position.y + fire.vertices.y4 * fire.size

            love.graphics.setColor(fire.color.r, fire.color.g, fire.color.b, fire.color.a)
            love.graphics.polygon("fill", x1, y1, x2, y2, x3, y3, x4, y4)
            love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
        end

        love.graphics.draw(self.texture, fireball.position.x, fireball.position.y, 0, 2.5, 2.5,
            self.texture:getWidth() / 2,
            self.texture:getHeight() / 2)
    end
end

function fireballs:get_fireball_positions()
    local fireball_positions = {}
    for i = 1, #self.list do
        local fireball = self.list[i]
        table.insert(fireball_positions, {
            x = fireball.position.x,
            y = fireball.position.y
        })
    end
    return fireball_positions
end

function fireballs:handle_fires(fires, position, dt)
    for i = 1, #fires do
        local fire = fires[i]

        if not fire.initialized then
            fire.initialized = true
            fire.rotation = 17.5
            fire.size = 19.0
            fire.position = { x = position.x, y = position.y + 5 }
            fire.color = { r = 0.99, g = 0.90, b = 0.42, a = 1.0 }
            fire.y_velocity = (love.math.random(0, 1) == 1 and 35) or -35

            fire.vertices = {
                x1 = 0,
                y1 = 1,
                x2 = 1,
                y2 = 0,
                x3 = 0,
                y3 = -1,
                x4 = -1,
                y4 = 0
            }
        else
            fire.color.g = fire.color.g - 2 * dt
            if fire.color.g < 0.8 then
                fire.color.a = fire.color.a - dt
                fire.position.y = fire.position.y + fire.y_velocity * dt
                fire.size = fire.size - 20 * dt
                fire.rotation = fire.rotation - fire.rotation * dt
            else
                fire.size = fire.size - 15 * dt
            end
            local x1 = fire.vertices.x1
            local y1 = fire.vertices.y1
            local x2 = fire.vertices.x2
            local y2 = fire.vertices.y2
            local x3 = fire.vertices.x3
            local y3 = fire.vertices.y3
            local x4 = fire.vertices.x4
            local y4 = fire.vertices.y4

            local radian = math.rad(fire.rotation)

            x1, y1 = x1 * math.cos(radian) - y1 * math.sin(radian), y1 * math.cos(radian) + x1 * math.sin(radian)
            x2, y2 = x2 * math.cos(radian) - y2 * math.sin(radian), y2 * math.cos(radian) + x2 * math.sin(radian)
            x3, y3 = x3 * math.cos(radian) - y3 * math.sin(radian), y3 * math.cos(radian) + x3 * math.sin(radian)
            x4, y4 = x4 * math.cos(radian) - y4 * math.sin(radian), y4 * math.cos(radian) + x4 * math.sin(radian)

            fire.vertices = { x1 = x1, y1 = y1, x2 = x2, y2 = y2, x3 = x3, y3 = y3, x4 = x4, y4 = y4 }
        end
    end

    for i = #fires, 1, -1 do
        if fires[i].color.a < 0.75 then
            if love.math.random(0, 4) == 0 then
                table.remove(fires, i)
            end
        end
    end
end

function fireballs:spawn()
    local direction = (love.math.random(0, 1) == 1 and 1) or -1
    local velocity = ({ 600, 700, 800 })[love.math.random(1, 3)] * direction
    local x = (direction == 1) and -500 or virtual_width + 500;
    local y = love.math.random(100, virtual_height - 200)
    table.insert(self.list,
        {
            position = { x = x, y = y },
            velocity = velocity,
            fires = {},
            add_fire_timer = 0.01,
            collision_rect = {
                x = x - self.texture:getWidth() / 2 * 2.5,
                y = y - self.texture:getHeight() / 2 * 2.5,
                width = self.texture:getWidth() * 2.5,
                height = self.texture:getHeight() * 2.5,
                aabb_info = {
                    overlap_x = 0,
                    overlap_y = 0,
                    previous_overlap_x = 0,
                    previous_overlap_y = 0
                }
            }
        })
end
