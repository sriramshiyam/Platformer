json = require "lib.json"

tilemap = {}

function tilemap:load()
    self.texture = love.graphics.newImage("res/image/tileset.png")
    self.tiles = {}

    local tile_source = json.decode(love.filesystem.read("res/tilemap/tilemap.json"))

    for i = 1, #tile_source do
        local tile_number = tile_source[i]

        if tile_number > 0 then
            local x_offset = 0;
            local y_offset = 0;
            local tile = 0;

            while true do
                tile = tile + 1
                if tile == tile_number then
                    break;
                end
                x_offset = x_offset + 72
                if x_offset == self.texture:getWidth() then
                    x_offset = 0
                    y_offset = y_offset + 72
                end
            end

            local x = 0;
            local y = 0;
            tile_number = i - 1

            while tile_number >= 30 do
                tile_number = tile_number - 30
                y = y + 72
            end
            x = x + (tile_number * 72)

            table.insert(self.tiles, {
                rectangle = { x = x, y = y, width = 72, height = 72 },
                quad = love.graphics.newQuad(x_offset, y_offset, 72, 72, self.texture:getWidth(),
                    self.texture:getHeight())
            })
        end
    end
end

function tilemap:update(dt)
end

function tilemap:draw()
    for i = 1, #self.tiles do
        local tile = self.tiles[i];
        love.graphics.draw(self.texture, tile.quad, tile.rectangle.x, tile.rectangle.y);
        love.graphics.rectangle("line", tile.rectangle.x, tile.rectangle.y, tile.rectangle.width, tile.rectangle.height)
    end
end
