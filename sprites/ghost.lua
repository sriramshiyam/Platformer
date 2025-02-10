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
    self.spawn_timer = 5.0
    self.y_velocity_factor = 90.0
end

function ghost:update(dt)
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
