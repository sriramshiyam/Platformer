glow = {}

function glow:load()
    self.time = 0
    self.canvas = love.graphics.newCanvas(200, 200);
    self.decoration_positions = {}
    self.fireball_positions = {}
    local shader_src = love.filesystem.read("res/shaders/glow.glsl")
    self.shader = love.graphics.newShader(shader_src)
end

function glow:update(dt)
    self.time = self.time + dt
    self.shader:send("time", self.time)
end

function glow:draw()
    love.graphics.setShader(self.shader)
    self.shader:send("glow_color", { 0.99, 0.90, 0.42 })

    for i = 1, #self.decoration_positions do
        love.graphics.draw(self.canvas, self.decoration_positions[i].x, self.decoration_positions[i].y, 0, 1, 1,
            self.canvas:getWidth() / 2, self.canvas:getHeight() / 2)
    end

    self.shader:send("glow_color", { 0.91, 0.46, 0.14 })

    for i = 1, #self.fireball_positions do
        love.graphics.draw(self.canvas, self.fireball_positions[i].x, self.fireball_positions[i].y, 0, 1.25, 1.25,
            self.canvas:getWidth() / 2, self.canvas:getHeight() / 2)
    end

    love.graphics.setShader()
end
