decorations = {}

function decorations:load()
    self.decs = {}

    self.textures = {
        lamp = love.graphics.newImage("res/image/lamp.png"),
        rock1 = love.graphics.newImage("res/image/rock_1.png"),
        rock2 = love.graphics.newImage("res/image/rock_2.png"),
        rock3 = love.graphics.newImage("res/image/rock_3.png"),
        sign = love.graphics.newImage("res/image/sign.png"),
        grass1 = love.graphics.newImage("res/image/grass_1.png"),
        grass2 = love.graphics.newImage("res/image/grass_2.png"),
        grass3 = love.graphics.newImage("res/image/grass_3.png"),
        pumpkin = love.graphics.newImage("res/image/fireball.png")
    }

    self.textures.lampx = self.textures.lamp
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

            local dec_texture = self.textures[dec]
            local scale

            if dec == "lampx" then
                x = x + dec_texture:getWidth() * 2.5 + 50
                y = y - dec_texture:getHeight() * 2.5
                scale = 2.5
            elseif dec == "pumpkin" then
                x = x + 50
                y = y - dec_texture:getHeight() * 2.5
                scale = 2.5
            elseif string.find(dec, "grass") then
                x = x + 50
                y = y - dec_texture:getHeight() * 4.5
                scale = 4.5
            else
                x = x + 50
                y = y - dec_texture:getHeight() * 2.5
                scale = 2.5
            end

            table.insert(self.decs,
                {
                    tex_type = dec,
                    position = { x = x, y = y },
                    scale = scale,
                    texture = dec_texture,
                    x_spring = {
                        rest_length = x,
                        damping = 0.7,
                        velocity = 0.0,
                        force = 0,
                        k = 0.1,
                    },
                    y_spring = {
                        rest_length = y,
                        damping = 0.7,
                        velocity = 0.0,
                        force = 0,
                        k = 0.1,
                    }
                })
        end
    end
end

function decorations:update(dt)
    for i = 1, #self.decs do
        local x_spring = self.decs[i].x_spring
        local x = self.decs[i].position.x - x_spring.rest_length
        x_spring.force = -x_spring.k * x;
        x_spring.velocity = x_spring.velocity + x_spring.force
        self.decs[i].position.x = self.decs[i].position.x + x_spring.velocity
        x_spring.velocity = x_spring.velocity * x_spring.damping

        local y_spring = self.decs[i].y_spring
        x = self.decs[i].position.y - y_spring.rest_length
        y_spring.force = -y_spring.k * x;
        y_spring.velocity = y_spring.velocity + y_spring.force
        self.decs[i].position.y = self.decs[i].position.y + y_spring.velocity
        y_spring.velocity = y_spring.velocity * y_spring.damping
    end
end

function decorations:draw()
    for i = 1, #self.decs do
        local dec = self.decs[i]
        if dec.tex_type == "lampx" then
            love.graphics.draw(dec.texture, dec.position.x, dec.position.y, 0, -dec.scale, dec.scale)
        else
            love.graphics.draw(dec.texture, dec.position.x, dec.position.y, 0, dec.scale)
        end
    end
end

function decorations:get_pumpkin_positions()
    local pumpkin_positions = {}
    for i = 1, #self.decs do
        local dec = self.decs[i]
        if dec.tex_type == "pumpkin" then
            table.insert(pumpkin_positions, {
                x = dec.position.x + (dec.texture:getWidth() * dec.scale) / 2,
                y = dec.position.y + (dec.texture:getHeight() * dec.scale) / 2
            })
        end
    end
    return pumpkin_positions
end

function decorations:add_shake_effect()
    for i = 1, #self.decs do
        self.decs[i].position.x = self.decs[i].position.x + 12.5
        self.decs[i].position.y = self.decs[i].position.y + 12.5
    end
end
