ghost = {}

function ghost:load()
    self.texture = love.graphics.newImage("res/image/ghost.png")
    self.frame_count = 4
    self.frame_number = 0
    self.frame_time = 0.100
    self.frame_width = self.texture:getWidth() / 4
    self.frame_height = self.texture:getHeight()
    self.frame_quad = love.graphics.newQuad(0, 0, self.frame_width, self.frame_height, self.texture:getWidth(),
        self.texture:getHeight())
    self.origin = { x = self.frame_width / 2, y = self.frame_height / 2 }
    self.position = { x = -500, y = 0 }
    self.scale = 3.5
    self.collision_rect = {
        x = self.position.x - 10 * self.scale,
        y = self.position.y - 13 * self.scale,
        width = self.frame_width * 1.2,
        height = self.frame_height * 1.2,
        aabb_info = {
            overlap_x = 0,
            overlap_y = 0,
            previous_overlap_x = 0,
            previous_overlap_y = 0
        }
    }
    self.is_enabled = false
    self.direction = -1
    self.speed = 225
    self.spawn_timer = 0.0
    self.y_velocity_factor = 90.0
    self.is_exploding = false
    self.explosion_list = {}
    self.explosion_timer = 0.0
end

function ghost:update(dt)
    if self.is_exploding then
        self:handle_explosion(dt);
        return
    end

    if self.spawn_timer > 0.0 then
        self.spawn_timer = self.spawn_timer - dt
    elseif not self.is_enabled then
        self.is_enabled = true
        self:spawn()
    end

    if self.is_enabled then
        self:update_animation(dt)

        self.y_velocity_factor = self.y_velocity_factor + 270 * dt

        if player.position.x > self.position.x then
            self.direction = 1
        else
            self.direction = -1
        end

        local direction = { x = player.position.x - self.position.x, y = player.position.y - self.position.y }
        local length = math.sqrt(direction.x ^ 2 + direction.y ^ 2)

        direction.x = direction.x / length
        direction.y = direction.y / length

        self.position.x = self.position.x + direction.x * self.speed * dt
        self.position.y = self.position.y + direction.y * self.speed * dt

        local factor = math.sin(math.rad(self.y_velocity_factor)) * 100
        self.position.y = self.position.y + factor * dt

        self.collision_rect.x = self.position.x - 10 * self.scale
        self.collision_rect.y = self.position.y - 13 * self.scale
    end
end

function ghost:update_animation(dt)
    self.frame_time = self.frame_time - dt
    if self.frame_time < 0.0 then
        self.frame_number = self.frame_number + 1
        if self.frame_number == self.frame_count then
            self.frame_number = 0
        end
        self.frame_time = 0.150
        self.frame_quad:setViewport(self.frame_width * self.frame_number, 0, self.frame_width, self.frame_height)
    end
end

function ghost:draw()
    if self.is_exploding then
        self:draw_explosion()
        return
    end
    if self.is_enabled then
        love.graphics.draw(self.texture, self.frame_quad, self.position.x, self.position.y, 0,
            self.scale * self.direction * -1, self.scale,
            self.origin.x, self.origin.y)
        -- love.graphics.rectangle("line", self.collision_rect.x, self.collision_rect.y, self.collision_rect.width,
        --     self.collision_rect.height)
    end
end

function ghost:spawn()
    self.y_velocity_factor = 90.0
    self.spawn_timer = 2.0
    if love.math.random(0, 1) == 0 then
        self.position.x = love.math.random(-500, -100)
    else
        self.position.x = love.math.random(virtual_width + 100, virtual_width + 500)
    end
    self.position.y = love.math.random(0, virtual_height)
end

function ghost:explode()
    self.explosion_timer = 0.4
    self.is_exploding = true
    self.explosion_list = {}

    local colors = {}
    table.insert(colors, { r = 0.71, g = 0.71, b = 0.7 })
    table.insert(colors, { r = 0.89, g = 0.88, b = 0.88 })
    table.insert(colors, { r = 0.8, g = 0.79, b = 0.76 })

    for i = 1, 55 do
        local explosion_item = {};

        explosion_item.alpha = math.random()
        local radian = math.rad(math.random(0, 360))

        explosion_item.direction = {}
        explosion_item.direction.x = 1 * math.cos(radian) - 0 * math.sin(radian)
        explosion_item.direction.y = 0 * math.cos(radian) + 1 * math.sin(radian)

        local scale = math.random(1, 3) * 10
        radian = math.rad(math.random(0, 360))

        local vertices = {}

        local vertex = {}
        vertex.x = (1 * math.cos(radian) - 0 * math.sin(radian)) * scale
        vertex.y = (0 * math.cos(radian) + 1 * math.sin(radian)) * scale
        table.insert(vertices, vertex)

        vertex = {}
        vertex.x = (0 * math.cos(radian) - (-1) * math.sin(radian)) * scale
        vertex.y = (-1 * math.cos(radian) + 0 * math.sin(radian)) * scale
        table.insert(vertices, vertex)

        vertex = {}
        vertex.x = (-1 * math.cos(radian) - 0 * math.sin(radian)) * scale
        vertex.y = (0 * math.cos(radian) + (-1) * math.sin(radian)) * scale
        table.insert(vertices, vertex)

        vertex = {}
        vertex.x = (0 * math.cos(radian) - 1 * math.sin(radian)) * scale
        vertex.y = (1 * math.cos(radian) + 0 * math.sin(radian)) * scale
        table.insert(vertices, vertex)

        explosion_item.vertices = vertices

        explosion_item.position = {}
        explosion_item.position.x = self.position.x
        explosion_item.position.y = self.position.y

        explosion_item.speed = math.random(50, 300)
        explosion_item.color = colors[math.random(1, 3)]

        table.insert(self.explosion_list, explosion_item)
    end
end

function ghost:handle_explosion(dt)
    self.explosion_timer = self.explosion_timer - dt

    if self.explosion_timer < 0.0 then
        self.is_exploding = false
        self:spawn()
    end

    for i = 1, #self.explosion_list do
        local explosion_item = self.explosion_list[i]
        explosion_item.position.x = explosion_item.position.x + explosion_item.direction.x * explosion_item.speed * dt
        explosion_item.position.y = explosion_item.position.y + explosion_item.direction.y * explosion_item.speed * dt
    end
end

function ghost:draw_explosion()
    for i = 1, #self.explosion_list do
        local explosion_item = self.explosion_list[i]

        local x1 = explosion_item.position.x + explosion_item.vertices[1].x
        local y1 = explosion_item.position.y + explosion_item.vertices[1].y
        local x2 = explosion_item.position.x + explosion_item.vertices[2].x
        local y2 = explosion_item.position.y + explosion_item.vertices[2].y
        local x3 = explosion_item.position.x + explosion_item.vertices[3].x
        local y3 = explosion_item.position.y + explosion_item.vertices[3].y
        local x4 = explosion_item.position.x + explosion_item.vertices[4].x
        local y4 = explosion_item.position.y + explosion_item.vertices[4].y

        local color = explosion_item.color
        love.graphics.setColor(color.r, color.g, color.b, explosion_item.alpha)
        love.graphics.polygon("fill", x1, y1, x2, y2, x3, y3, x4, y4)
        love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
    end
end
