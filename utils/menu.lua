menu = {}

function menu:load()
    self.background_texture = love.graphics.newImage("res/image/menu.png")
    self.title_font = love.graphics.newFont("res/fonts/upheavtt.ttf", 190)
    self.title_width = self.title_font:getWidth("HAUNTED HEAT!")
    self.title_y = 10
    self.title_direction = 1
    self.title_move_count = 0
    self.title_move_timer = 0.2
    self.font = love.graphics.newFont("res/fonts/upheavtt.ttf", 100)
    self.high_score = string.format("BEST TIME: %.2f", 0.0)
    self.high_score_width = self.font:getWidth(self.high_score)
end

function menu:update(dt)
    self.title_move_timer = self.title_move_timer - dt
    if self.title_move_timer < 0.0 then
        self.title_move_timer = 0.2
        self.title_move_count = self.title_move_count + 1
        self.title_y = self.title_y + 10 * self.title_direction
        if self.title_move_count == 4 then
            self.title_move_count = 0
            self.title_direction = self.title_direction * -1
        end
    end
end

function menu:draw()
    love.graphics.draw(self.background_texture, 0, 0, 0, virtual_width / self.background_texture:getWidth(),
        virtual_height / self.background_texture:getHeight())

    love.graphics.setFont(self.title_font)
    love.graphics.print("HAUNTED HEAT!", virtual_width / 2 - self.title_width / 2, self.title_y)


    love.graphics.setColor(0.92, 0.81, 0.20, 0.4)
    love.graphics.rectangle("fill", virtual_width / 2 - self.high_score_width / 2 - 10, 310, self.high_score_width + 20,
        self.font:getHeight() - 10)
    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)

    love.graphics.setLineWidth(5)
    love.graphics.setColor(0.92, 0.81, 0.20, 1.0)
    love.graphics.rectangle("line", virtual_width / 2 - self.high_score_width / 2 - 10, 310, self.high_score_width + 20,
        self.font:getHeight() - 10)
    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
    love.graphics.setLineWidth(1)

    love.graphics.setFont(self.font)
    love.graphics.print(self.high_score, virtual_width / 2 - self.high_score_width / 2, 300)
end
