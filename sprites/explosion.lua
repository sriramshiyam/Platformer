explosion = {}

function explosion:load()
    self.texture = love.graphics.newImage("res/image/explosion_sheet.png")
    self.position = {}
    self.frame_count = 12
    self.frame_width = self.texture:getWidth() / 12
    self.frame_height = self.texture:getHeight()
    self.frame_quad = love.graphics.newQuad(0, 0, self.frame_width, self.frame_height, self.texture:getWidth(),
        self.texture:getHeight())
    self.origin = { x = self.frame_width / 2, y = self.frame_height / 2 }
    self.can_animate = false
end

function explosion:update(dt)
    if self.can_animate then
        self.frame_time = self.frame_time - dt
        if self.frame_time < 0.0 then
            self.frame_number = self.frame_number + 1
            if self.frame_number == self.frame_count then
                self.can_animate = false
            end
            self.frame_time = 0.05
            self.frame_quad:setViewport(self.frame_width * self.frame_number, 0, self.frame_width,
                self.frame_height)
        end
    end
end

function explosion:draw()
    if self.can_animate then
        love.graphics.draw(self.texture, self.frame_quad, self.position.x, self.position.y, 0, 1, 1,
            self.origin.x, self.origin.y)
    end
end

function explosion:spawn(x, y)
    self.position.x = x
    self.position.y = y
    self.frame_number = 0
    self.frame_time = 0.10
    self.frame_quad:setViewport(0, 0, self.frame_width, self.frame_height)
    self.can_animate = true
end
