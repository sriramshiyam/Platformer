player = {}

function player:load()
    self.idle_texture = love.graphics.newImage("res/image/adventurer-idle-sheet.png")
    self.run_texture = love.graphics.newImage("res/image/adventurer-run-sheet.png")
    self.jump_texture = love.graphics.newImage("res/image/adventurer-jump-sheet.png")
    self.fall_texture = love.graphics.newImage("res/image/adventurer-fall-sheet.png")
    self.crouch_texture = love.graphics.newImage("res/image/adventurer-crouch-sheet.png")
    self:init()
    local shader_src = love.filesystem.read("res/shaders/attacked.glsl")
    self.attacked_shader = love.graphics.newShader(shader_src)
end

function player:init()
    self.state = "idle"
    self.facing_direction = "right"
    self.current_texture = self.idle_texture
    self.frame_count = 4
    self.frame_number = 0
    self.frame_time = 0.150
    self.frame_width = self.current_texture:getWidth() / 4
    self.frame_height = self.current_texture:getHeight()
    self.frame_quad = love.graphics.newQuad(0, 0, self.frame_width, self.frame_height, self.current_texture:getWidth(),
        self.current_texture:getHeight())
    self.scale = 3.5
    self.origin = { x = self.frame_width / 2, y = self.frame_height / 2 }
    self.position = { x = 880, y = 880 }
    self.outline_width = self.frame_width * 0.7 * self.scale
    self.outline_height = self.frame_height * self.scale
    self.collision_rect = {
        x = self.position.x - (self.outline_width * 0.4 / 2),
        y = self.position.y - (self.outline_height / 2),
        width = self.outline_width * 0.65,
        height = self.outline_height
    }
    self.collides = false
    self.speed = 500
    self.gravity = 50
    self.y_velocity = 0
    self.jump_velocity = 1250
    self.in_air = false
    self.can_animate = true
    self.attacked = false
    self.attacked_color_count = 0
    self.attacked_radian_value = 0.0
    self.can_increase_attacked_color_count = true
    self.attacked_velocity = 0.0
    self.attacked_direction = 0
    self.health = 3
    self.previous_x = 880
    self.after_image_list = {}
    self.after_image_timer = 0.1
end

function player:update(dt)
    if self.attacked then
        self:handle_attacked_state(dt)
    end

    if not self.collides and self.y_velocity > 0 then
        self.in_air = true
    end

    self.y_velocity = self.y_velocity + self.gravity
    self.position.y = self.position.y + self.y_velocity * dt

    if self.in_air and self.y_velocity > 0 and self.state ~= "falling" then
        self.state = "falling"
        self:change_animation()
    end

    if self.attacked_velocity ~= 0.0 then
        self.position.x = self.position.x + self.attacked_velocity * dt
        if self.attacked_velocity > 0.0 then
            self.attacked_velocity = self.attacked_velocity - 500 * dt
            if self.attacked_velocity < 0.0 then
                self.attacked_velocity = 0.0
            end
        else
            self.attacked_velocity = self.attacked_velocity + 500 * dt
            if self.attacked_velocity > 0.0 then
                self.attacked_velocity = 0.0
            end
        end
    end

    self:handle_input(dt)
    self:update_animation(dt)

    if (self.previous_x ~= self.position.x) or self.in_air then
        self.previous_x = self.position.x
        self.after_image_timer = self.after_image_timer - dt
        if self.after_image_timer < 0.0 then
            self.after_image_timer = 0.1
            self:add_after_image()
        end
    else
        self.after_image_timer = 0.1
    end

    self:handle_after_images(dt)
end

function player:handle_input(dt)
    if love.keyboard.isDown("s") and not self.in_air and self.state ~= "crouching" then
        sound.player_crouch:play()
        self.state = "crouching"
        self.collision_rect.height = self.collision_rect.height * 0.7
        self:change_animation()
    end

    if not love.keyboard.isDown("s") and self.state == "crouching" then
        self.collision_rect.height = self.outline_height
        self.state = "idle"
        self:change_animation()
    end

    if self.state ~= "crouching" then
        if love.keyboard.isDown("w") and not self.in_air then
            sound.player_jump:play()
            self.y_velocity = -self.jump_velocity
            self.in_air = true
            self.state = "jumping"
            self:change_animation()
        end

        if not self.in_air then
            if (love.keyboard.isDown("d") or love.keyboard.isDown("a")) then
                if self.state ~= "running" then
                    self.state = "running"
                    self:change_animation()
                end
            elseif self.state ~= "idle" then
                self.state = "idle"
                self:change_animation()
            end
        end

        if self.attacked_velocity == 0.0 then
            if love.keyboard.isDown("d") then
                self.facing_direction = "right"
                self.position.x = self.position.x + self.speed * dt
            elseif love.keyboard.isDown("a") then
                self.facing_direction = "left"
                self.position.x = self.position.x - self.speed * dt
            end
        end

        if self.position.x < (self.collision_rect.width / 2) then
            self.position.x = self.collision_rect.width / 2
        elseif self.position.x > (virtual_width - self.collision_rect.width / 2) then
            self.position.x = virtual_width - self.collision_rect.width / 2
        end
    end

    self.collision_rect.x = self.position.x - (self.collision_rect.width / 2)
    if self.state == "crouching" then
        self.collision_rect.y = self.position.y - (self.collision_rect.height * 0.2)
    else
        self.collision_rect.y = self.position.y - (self.collision_rect.height / 2)
    end
end

function player:update_animation(dt)
    if self.can_animate then
        self.frame_time = self.frame_time - dt

        if self.frame_time < 0.0 then
            self.frame_number = self.frame_number + 1

            if self.frame_number == self.frame_count then
                self.frame_number = 0

                if self.state == "jumping" and self.in_air then
                    self.can_animate = false
                    return
                end
            end

            self.frame_time = 0.150
            self.frame_quad:setViewport(self.frame_width * self.frame_number, 0, self.frame_width, self.frame_height)
        end
    end
end

function player:change_animation()
    if self.state == "idle" or self.state == "jumping" or self.state == "falling" or self.state == "crouching" then
        if self.state == "idle" or self.state == "crouching" then
            self.current_texture = (self.state == "idle" and self.idle_texture) or self.crouch_texture
            self.frame_count = 4
        elseif self.state == "jumping" then
            self.current_texture = self.jump_texture
            self.frame_count = 2
        elseif self.state == "falling" then
            self.current_texture = self.fall_texture
            self.frame_count = 2
        end
        self.frame_number = 0
        self.frame_time = 0.150
        self.frame_width = self.current_texture:getWidth() /
            (((self.state == "idle" or self.state == "crouching") and 4) or 2)
        self.frame_height = self.current_texture:getHeight()
        self.frame_quad = love.graphics.newQuad(0, 0, self.frame_width, self.frame_height,
            self.current_texture:getWidth(),
            self.current_texture:getHeight())
    elseif self.state == "running" then
        self.current_texture = self.run_texture
        self.frame_count = 6
        self.frame_number = 0
        self.frame_time = 0.150
        self.frame_width = self.current_texture:getWidth() / 6
        self.frame_height = self.current_texture:getHeight()
        self.frame_quad = love.graphics.newQuad(0, 0, self.frame_width, self.frame_height,
            self.current_texture:getWidth(),
            self.current_texture:getHeight())
    elseif self.state == "jumping" then
    end
end

function player:draw()
    self:draw_after_images()
    if self.attacked then
        love.graphics.setShader(self.attacked_shader)
    end
    love.graphics.draw(self.current_texture, self.frame_quad, self.position.x, self.position.y, 0,
        (self.facing_direction == "right" and 1 or -1) * self.scale, self.scale, self.origin.x, self.origin.y)
    if self.attacked then
        love.graphics.setShader()
    end
    -- if self.collides then
    --     love.graphics.setColor(1, 0, 0, 1)
    -- else
    --     love.graphics.setColor(0, 1, 0, 1)
    -- end
    -- love.graphics.rectangle("line", self.collision_rect.x, self.collision_rect.y, self.collision_rect.width,
    --     self.collision_rect.height)
    -- love.graphics.setColor(1, 1, 1, 1)
end

function player:handle_attacked_state(dt)
    self.attacked_radian_value = self.attacked_radian_value - dt * 5.0
    local value = math.abs(math.sin(self.attacked_radian_value))
    self.attacked_shader:send("red", value)

    if ((value > 0.99 or value < 0.1) and self.can_increase_attacked_color_count) then
        self.can_increase_attacked_color_count = false
        self.attacked_color_count = self.attacked_color_count + 1
    else
        self.can_increase_attacked_color_count = true
    end

    if self.attacked_color_count == 11 then
        self.attacked = false;
        self.attacked_color_count = 0
        self.attacked_radian_value = 0.0
        self.can_increase_attacked_color_count = true
    end
end

function player:add_after_image()
    local after_image = {}
    after_image.x = self.position.x
    after_image.y = self.position.y
    after_image.facing_direction = self.facing_direction
    after_image.texture = self.current_texture
    after_image.frame_quad = love.graphics.newQuad(self.frame_width * self.frame_number, 0, self.frame_width,
        self.frame_height, self.current_texture:getWidth(), self.current_texture:getHeight())
    after_image.opacity = 0.8
    table.insert(self.after_image_list, after_image)
end

function player:handle_after_images(dt)
    for i = #self.after_image_list, 1, -1 do
        local after_image = self.after_image_list[i]
        after_image.opacity = after_image.opacity - 1.5 * dt
        if after_image.opacity < 0.0 then
            table.remove(self.after_image_list, i)
        end
    end
end

function player:draw_after_images()
    for i = 1, #self.after_image_list do
        local after_image = self.after_image_list[i]
        love.graphics.setColor(1, 1, 1, after_image.opacity)
        love.graphics.draw(after_image.texture, after_image.frame_quad, after_image.x, after_image.y, 0,
            (after_image.facing_direction == "right" and 1 or -1) * self.scale, self.scale, self.origin.x, self.origin.y)
        love.graphics.setColor(1, 1, 1, 1)
    end
end
