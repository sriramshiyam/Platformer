background = {}

function background:load()
    self.background0 = love.graphics.newImage("res/image/background_0.png")
    self.background1 = love.graphics.newImage("res/image/background_1.png")
    self.background2 = love.graphics.newImage("res/image/background_2.png")
end

function background:update(dt)
end

function background:draw()
    love.graphics.draw(self.background0, 0, 0, 0, virtual_width / self.background0:getWidth(), virtual_height / self.background0:getHeight())
    love.graphics.draw(self.background1, 0, 0, 0, virtual_width / self.background1:getWidth(), virtual_height / self.background1:getHeight())
    love.graphics.draw(self.background2, 0, 0, 0, virtual_width / self.background2:getWidth(), virtual_height / self.background2:getHeight())
end
