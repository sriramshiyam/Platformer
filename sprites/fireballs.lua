fireballs = {}

function fireballs:load()
    self.texture = love.graphics.newImage("res/image/fireball.png")
    self.list = {}

    table.insert(self.list, { position = { x = 200, y = 200 }, velocity = 500, fires = {} })
end

function fireballs:update(dt)
    for i = 1, #self.list do
        local fireball = self.list[i]
        fireball.position.x = fireball.position.x + fireball.velocity * dt
    end
end

function fireballs:draw()
    for i = 1, #self.list do
        local fireball = self.list[i]
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
