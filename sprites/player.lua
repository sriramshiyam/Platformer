player = {}

function player:load()
    self.state = "idle"
    self.facing_direction = "right"
    self.idle_texture = love.graphics.newImage("res/image/adventurer-idle-sheet.png")
    self.run_texture = love.graphics.newImage("res/image/adventurer-run-sheet.png")
    self.current_texture = self.idle_texture
    self.frame_count = 4
    self.frame_number = 0
    self.frame_time = 0.100
    self.frame_width = self.current_texture:getWidth() / 4
    self.frame_height = self.current_texture:getHeight()
    self.frame_quad = love.graphics.newQuad(0, 0, self.frame_width, self.frame_height, self.current_texture:getWidth(),
        self.current_texture:getHeight())
    self.scale = 4.5
    self.origin = { x = self.frame_width / 2, y = self.frame_height / 2 }
    self.position = { x = 100, y = 100 }
    self.outline_width = self.frame_width * 0.8
    self.outline_height = self.frame_height
    self.outline_rect = {
        x = self.position.x - (self.outline_width * self.scale * 0.8 / 2),
        y = self.position.y - (self.outline_height * self.scale / 2),
        width = self.outline_width * 0.8 * self.scale,
        height = self.outline_height * self.scale
    }
    self.speed = 800
end

function player:update(dt)
    self:handle_input(dt)
    self:update_animation(dt)
end

function player:handle_input(dt)
    if (love.keyboard.isDown("d") or love.keyboard.isDown("a")) then
        if self.state ~= "running" then
            self.state = "running"
            self:change_animation()
        end
    elseif self.state ~= "idle" then
        self.state = "idle"
        self:change_animation()
    end

    if love.keyboard.isDown("d") then
        self.facing_direction = "right"
        self.position.x = self.position.x + self.speed * dt
    elseif love.keyboard.isDown("a") then
        self.facing_direction = "left"
        self.position.x = self.position.x - self.speed * dt
    end

    if love.keyboard.isDown("s") then
        self.position.y = self.position.y + self.speed * dt
    elseif love.keyboard.isDown("w") then
        self.position.y = self.position.y - self.speed * dt
    end

    self.outline_rect.x = self.position.x - (self.outline_width * self.scale * 0.8 / 2)
    self.outline_rect.y = self.position.y - (self.outline_height * self.scale / 2)
end

function player:update_animation(dt)
    self.frame_time = self.frame_time - dt
    if self.frame_time < 0.0 then
        self.frame_number = self.frame_number + 1
        if self.frame_number == self.frame_count then
            self.frame_number = 0
        end
        self.frame_time = 0.100
    end
    self.frame_quad:setViewport(self.frame_width * self.frame_number, 0, self.frame_width, self.frame_height)
end

function player:change_animation()
    if self.state == "idle" then
        self.current_texture = self.idle_texture
        self.frame_count = 4
        self.frame_number = 0
        self.frame_time = 0.100
        self.frame_width = self.current_texture:getWidth() / 4
        self.frame_height = self.current_texture:getHeight()
        self.frame_quad = love.graphics.newQuad(0, 0, self.frame_width, self.frame_height,
            self.current_texture:getWidth(),
            self.current_texture:getHeight())
    elseif self.state == "running" then
        self.current_texture = self.run_texture
        self.frame_count = 6
        self.frame_number = 0
        self.frame_time = 0.100
        self.frame_width = self.current_texture:getWidth() / 6
        self.frame_height = self.current_texture:getHeight()
        self.frame_quad = love.graphics.newQuad(0, 0, self.frame_width, self.frame_height,
            self.current_texture:getWidth(),
            self.current_texture:getHeight())
    end
end

function player:draw()
    love.graphics.draw(self.current_texture, self.frame_quad, self.position.x, self.position.y, 0,
        (self.facing_direction == "right" and 1 or -1) * self.scale, self.scale, self.origin.x, self.origin.y)
    love.graphics.rectangle("line", self.outline_rect.x, self.outline_rect.y, self.outline_rect.width,
        self.outline_rect.height)
end
