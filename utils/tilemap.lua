json = require "lib.json"

tilemap = {}

function tilemap:load()
    self.texture = love.graphics.newImage("res/image/tileset.png")
    self.tiles = {}
    self.collision_rects = {}

    local tile_source = json.decode(love.filesystem.read("res/tilemap/tilemap.json"))
    local collision_rect = nil

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

            if collision_rect == nil then
                collision_rect = {
                    x = x,
                    y = y,
                    width = 72,
                    height = 72,
                    collides = false,
                    aabb_info = {
                        overlap_x = 0,
                        overlap_y = 0,
                        previous_overlap_x = 0,
                        previous_overlap_y = 0
                    }
                }
            else
                collision_rect.width = collision_rect.width + 72
            end

            table.insert(self.tiles, {
                rect = { x = x, y = y, width = 72, height = 72 },
                quad = love.graphics.newQuad(x_offset, y_offset, 72, 72, self.texture:getWidth(),
                    self.texture:getHeight()),
            })
        else
            if collision_rect ~= nil then
                table.insert(self.collision_rects, collision_rect)
                collision_rect = nil
            end
        end
    end

    table.remove(self.collision_rects, #self.collision_rects)
    local last_collision_rect = self.collision_rects[#self.collision_rects]
    last_collision_rect.height = last_collision_rect.height + 72
end

function tilemap:update(dt)
end

function tilemap:draw()
    for i = 1, #self.tiles do
        local tile = self.tiles[i];
        love.graphics.draw(self.texture, tile.quad, tile.rect.x, tile.rect.y);
    end

    -- for i = 1, #self.collision_rects do
    --     if self.collision_rects[i].collides then
    --         love.graphics.setColor(1, 0, 0, 1)
    --     else
    --         love.graphics.setColor(0, 1, 0, 1)
    --     end
    --     love.graphics.rectangle("line", self.collision_rects[i].x, self.collision_rects[i].y,
    --         self.collision_rects[i].width, self.collision_rects[i].height)
    --     love.graphics.setColor(1, 1, 1, 1)
    -- end
end
