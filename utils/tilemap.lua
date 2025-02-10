json = require "lib.json"

tilemap = {}

function tilemap:load()
    self.texture = love.graphics.newImage("res/image/tileset.png")
    self.tiles = {}
    self.collision_rects = {}

    local tile_source = json.decode(love.filesystem.read("res/json/tilemap.json"))
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
                    },
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
                }
            else
                collision_rect.width = collision_rect.width + 72
            end

            table.insert(self.tiles, {
                rect = { x = x, y = y, width = 72, height = 72 },
                quad = love.graphics.newQuad(x_offset, y_offset, 72, 72, self.texture:getWidth(),
                    self.texture:getHeight()),
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
    for i = 1, #self.tiles do
        local x_spring = self.tiles[i].x_spring
        local x = self.tiles[i].rect.x - x_spring.rest_length
        x_spring.force = -x_spring.k * x;
        x_spring.velocity = x_spring.velocity + x_spring.force
        self.tiles[i].rect.x = self.tiles[i].rect.x + x_spring.velocity
        x_spring.velocity = x_spring.velocity * x_spring.damping

        local y_spring = self.tiles[i].y_spring
        x = self.tiles[i].rect.y - y_spring.rest_length
        y_spring.force = -y_spring.k * x;
        y_spring.velocity = y_spring.velocity + y_spring.force
        self.tiles[i].rect.y = self.tiles[i].rect.y + y_spring.velocity
        y_spring.velocity = y_spring.velocity * y_spring.damping
    end

    for i = 1, #self.collision_rects do
        local x_spring = self.collision_rects[i].x_spring
        local x = self.collision_rects[i].x - x_spring.rest_length
        x_spring.force = -x_spring.k * x;
        x_spring.velocity = x_spring.velocity + x_spring.force
        self.collision_rects[i].x = self.collision_rects[i].x + x_spring.velocity
        x_spring.velocity = x_spring.velocity * x_spring.damping

        local y_spring = self.collision_rects[i].y_spring
        x = self.collision_rects[i].y - y_spring.rest_length
        y_spring.force = -y_spring.k * x;
        y_spring.velocity = y_spring.velocity + y_spring.force
        self.collision_rects[i].y = self.collision_rects[i].y + y_spring.velocity
        y_spring.velocity = y_spring.velocity * y_spring.damping
    end
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

function tilemap:add_shake_effect()
    for i = 1, #self.tiles do
        self.tiles[i].rect.x = self.tiles[i].rect.x + 15
        self.tiles[i].rect.y = self.tiles[i].rect.y + 15
    end

    for i = 1, #self.collision_rects do
        self.collision_rects[i].x = self.collision_rects[i].x + 15
        self.collision_rects[i].y = self.collision_rects[i].y + 15
    end
end
