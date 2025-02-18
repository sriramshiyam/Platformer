background = {}

function background:load()
    self.background0 = love.graphics.newImage("res/image/background_0.png")
    self.background1 = love.graphics.newImage("res/image/background_1.png")
    self.background2 = love.graphics.newImage("res/image/background_2.png")
    self.x_spring = {
        rest_length = 0,
        damping = 0.7,
        velocity = 0.0,
        force = 0,
        k = 0.1,
    }
    self.y_spring = {
        rest_length = 0,
        damping = 0.7,
        velocity = 0.0,
        force = 0,
        k = 0.1,
    }
    self.x = 0
    self.y = 0
end

function background:update(dt)
    local x_spring = self.x_spring
    local x = self.x - x_spring.rest_length
    x_spring.force = -x_spring.k * x;
    x_spring.velocity = x_spring.velocity + x_spring.force
    self.x = self.x + x_spring.velocity
    x_spring.velocity = x_spring.velocity * x_spring.damping

    local y_spring = self.y_spring
    x = self.y - y_spring.rest_length
    y_spring.force = -y_spring.k * x;
    y_spring.velocity = y_spring.velocity + y_spring.force
    self.y = self.y + y_spring.velocity
    y_spring.velocity = y_spring.velocity * y_spring.damping
end

function background:draw()
    love.graphics.draw(self.background0, self.x, self.y, 0, virtual_width / self.background0:getWidth(),
        virtual_height / self.background0:getHeight())
    love.graphics.draw(self.background1, self.x, self.y, 0, virtual_width / self.background1:getWidth(),
        virtual_height / self.background1:getHeight())
    love.graphics.draw(self.background2, self.x, self.y, 0, virtual_width / self.background2:getWidth(),
        virtual_height / self.background2:getHeight())
end

function background:add_shake_effect()
    self.x = self.x + 40
    self.y = self.y + 40
end
