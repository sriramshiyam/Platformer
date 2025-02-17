hud = {}

function hud:load()
    self.font = love.graphics.newFont("res/fonts/upheavtt.ttf", 125)
    self.timer = {
        {
            text = "3",
            x = virtual_width / 2 - self.font:getWidth("3") / 2,
            y = 50
        },
        {
            text = "2",
            x = virtual_width / 2 - self.font:getWidth("2") / 2,
            y = 50
        },
        {
            text = "1",
            x = virtual_width / 2 - self.font:getWidth("1") / 2,
            y = 50
        },
        {
            text = "GO",
            x = virtual_width / 2 - self.font:getWidth("GO") / 2,
            y = 50
        },
        index = 1
    }
    self.health_texture = love.graphics.newImage("res/image/health.png")
    self.health_frame_width = self.health_texture:getWidth()
    self.health_frame_height = self.health_texture:getHeight() / 3
    self.health_frame_quad = love.graphics.newQuad(0, 0, self.health_frame_width, self.health_frame_height,
        self.health_texture:getWidth(), self.health_texture:getHeight())
    self.previous_health = -1
end

function hud:update(dt)
    self.timer.index = sound.start_sound.index
    if player.health > 0 and self.previous_health ~= player.health then
        self.previous_health = player.health
        self.health_frame_quad:setViewport(0, self.health_frame_height * (3 - player.health), self.health_frame_width,
            self.health_frame_height);
    end
end

function hud:draw()
    if self.timer.index <= 4 then
        love.graphics.setFont(self.font)
        local info = self.timer[self.timer.index]
        love.graphics.print(info.text, info.x, info.y)
    end
    if player.health > 0 then
        love.graphics.draw(self.health_texture, self.health_frame_quad, 50, 40, 0, 2, 2)
    end
end
