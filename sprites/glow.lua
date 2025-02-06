glow = {}

function glow:load()
    self.canvas = love.graphics.newCanvas(200, 200);
    self.decoration_positions = {}
    self.fireball_positions = {}
    self.shader = love.graphics.newShader [[
        vec4 effect(vec4 color, Image texture, vec2 textureCoords, vec2 screenCoords) {
            number distance = sqrt(pow(textureCoords.x - 0.5, 2) + pow(textureCoords.y - 0.5, 2));
            number alpha = 0.35 * (1.0 - (distance / 0.5));
            if(distance <= 0.5) {
                return vec4(0.99, 0.90, 0.42, alpha);
            } else {
                return vec4(0.0, 0.0, 0.0, 0.0);
            }
        }
    ]]
end

function glow:update(dt)

end

function glow:draw()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear(0, 0, 0, 0)
    love.graphics.setCanvas()
end

function glow:draw_in_game()
    love.graphics.setShader(self.shader)
    for i = 1, #self.decoration_positions do
        love.graphics.draw(self.canvas, self.decoration_positions[i].x, self.decoration_positions[i].y, 0, 1, 1,
            self.canvas:getWidth() / 2, self.canvas:getHeight() / 2)
    end
    love.graphics.setShader()
end
