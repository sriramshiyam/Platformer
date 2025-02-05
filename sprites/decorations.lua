decorations = {}

function decorations:load()
    self.decs = {}
    self.lamp_texture = love.graphics.newImage("res/image/lamp.png")
    self.rock1_texture = love.graphics.newImage("res/image/rock_1.png")
    self.rock2_texture = love.graphics.newImage("res/image/rock_2.png")
    self.rock3_texture = love.graphics.newImage("res/image/rock_3.png")
    local dec_source = json.decode(love.filesystem.read("res/json/decorations.json"))

    for i = 1, #dec_source do
        local dec = dec_source[i]

        if type(dec) == "string" then
            local x = 0;
            local y = 0;
            local tile_number = i - 1

            while tile_number >= 30 do
                tile_number = tile_number - 30
                y = y + 72
            end
            x = x + (tile_number * 72)

            if dec == "lampx" then
                table.insert(self.decs,
                    {
                        tex_type = "lampx",
                        position = {
                            x = x + self.lamp_texture:getWidth() * 2.5 + 50,
                            y = y - self.lamp_texture:getHeight() * 2.5
                        },
                        scale = 2.5
                    })
            elseif dec == "lamp" then
                table.insert(self.decs,
                    {
                        tex_type = "lamp",
                        position = {
                            x = x + 50,
                            y = y - self.lamp_texture:getHeight() * 2.5
                        },
                        scale = 2.5
                    })
            elseif dec == "rock1" then
                table.insert(self.decs,
                    {
                        tex_type = "rock1",
                        position = {
                            x = x + 50,
                            y = y - self.rock1_texture:getHeight() * 2.5
                        },
                        scale = 2.5
                    })
            elseif dec == "rock2" then
                table.insert(self.decs,
                    {
                        tex_type = "rock2",
                        position = {
                            x = x + 50,
                            y = y - self.rock2_texture:getHeight() * 2.5
                        },
                        scale = 2.5
                    })
            elseif dec == "rock3" then
                table.insert(self.decs,
                    {
                        tex_type = "rock3",
                        position = {
                            x = x + 50,
                            y = y - self.rock3_texture:getHeight() * 2.5
                        },
                        scale = 2.5
                    })
            end
        end
    end
end

function decorations:draw()
    for i = 1, #self.decs do
        local dec = self.decs[i]
        if dec.tex_type == "lampx" then
            love.graphics.draw(self.lamp_texture, dec.position.x, dec.position.y, 0, -dec.scale, dec.scale)
        elseif dec.tex_type == "lamp" then
            love.graphics.draw(self.lamp_texture, dec.position.x, dec.position.y, 0, dec.scale)
        elseif dec.tex_type == "rock1" then
            love.graphics.draw(self.rock1_texture, dec.position.x, dec.position.y, 0, dec.scale)
        elseif dec.tex_type == "rock2" then
            love.graphics.draw(self.rock2_texture, dec.position.x, dec.position.y, 0, dec.scale)
        elseif dec.tex_type == "rock3" then
            love.graphics.draw(self.rock3_texture, dec.position.x, dec.position.y, 0, dec.scale)
        end
    end
end
