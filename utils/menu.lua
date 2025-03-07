menu = {}

function menu:load()
    self.background_texture = love.graphics.newImage("res/image/menu.png")
    self.title = "HAUNTED HEAT!"
    self.title_font = love.graphics.newFont("res/fonts/upheavtt.ttf", 190)
    self.title_width = self.title_font:getWidth(self.title)
    self.title_y = 10
    self.title_direction = 1
    self.title_move_count = 0
    self.title_move_timer = 0.2
    self.font = love.graphics.newFont("res/fonts/upheavtt.ttf", 100)
    self.high_score = 0.0
    self.high_score_text = string.format("BEST TIME: %.2f", self.high_score)
    self.high_score_width = self.font:getWidth(self.high_score_text)
    self.type = "main"
    self.escape_pressed = false
    self.main_menu_options = {
        {
            text = "START",
            width = self.font:getWidth("START"),
            y = 500,
            x = virtual_width / 2 - self.font:getWidth("START") / 2,
            color = { r = 1.0, g = 1.0, b = 1.0 },
            hovered = false,
            action = function()
                sound.select:play()
                loading:init()
                loading.enabled = true
                loading.state_to_change = "game"
                game:init()
                music.game_music:setPitch(1.0)
                loading.music_to_play = music.game_music
                loading.music_to_stop = music.menu_music
            end
        },
        {
            text = "EXIT",
            width = self.font:getWidth("EXIT"),
            y = 625,
            x = virtual_width / 2 - self.font:getWidth("EXIT") / 2,
            color = { r = 1.0, g = 1.0, b = 1.0 },
            hovered = false,
            action = function()
                sound.select:play()
                love.event.quit()
            end
        }
    }
    self.pause_menu_options = {
        {
            text = "RESUME",
            width = self.font:getWidth("RESUME"),
            y = 500,
            x = virtual_width / 2 - self.font:getWidth("RESUME") / 2,
            color = { r = 1.0, g = 1.0, b = 1.0 },
            hovered = false,
            action = function()
                sound.select:play()
                state = "game"
                love.mouse.setVisible(false)
                music.game_music:setPitch(1.0)
            end
        },
        {
            text = "EXIT TO MENU",
            width = self.font:getWidth("EXIT TO MENU"),
            y = 625,
            x = virtual_width / 2 - self.font:getWidth("EXIT TO MENU") / 2,
            color = { r = 1.0, g = 1.0, b = 1.0 },
            hovered = false,
            action = function()
                sound.select:play()
                loading:init()
                loading.enabled = true
                loading.state_to_change = "menu"
                loading.music_to_play = music.menu_music
                loading.music_to_stop = music.game_music
            end
        }
    }
    self.mouse_x = 0
    self.mouse_y = 0
end

function menu:change_title(title)
    self.title = title
    self.title_width = self.title_font:getWidth(self.title)
end

function menu:change_highscore(score)
    if score > self.high_score then
        self.high_score = score
        self.high_score_text = string.format("BEST TIME: %.2f", self.high_score)
        self.high_score_width = self.font:getWidth(self.high_score_text)
    end
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

    self:track_mouse()

    if loading.enabled then
        return
    end

    local menu_options = (self.type == "main" and self.main_menu_options) or self.pause_menu_options

    for i = 1, #menu_options do
        local option = menu_options[i]

        local rectangle = {
            x = option.x - 15,
            y = option.y + 10,
            width = option.width + 20,
            height = self.font:getHeight() - 10
        }

        if (self.mouse_x > rectangle.x and self.mouse_x < (rectangle.x + rectangle.width)) and
            (self.mouse_y > rectangle.y and self.mouse_y < (rectangle.y + rectangle.height)) then
            option.color.r = 0.23
            option.color.g = 0.23
            option.color.b = 0.23
            option.hovered = true
        else
            option.color.r = 1.0
            option.color.g = 1.0
            option.color.b = 1.0
            option.hovered = false
        end

        if option.hovered and love.mouse.isDown(1) then
            option.action()
        end
    end
end

function menu:track_mouse()
    local window_width, window_height = love.graphics.getDimensions()

    local x, y = love.mouse.getPosition()

    if (y > canvas_offset_y and y < (window_height - canvas_offset_y)) and
        (x > canvas_offset_x and x < (window_width - canvas_offset_x)) then
        self.mouse_x = (((x - canvas_offset_x) / (window_width - canvas_offset_x * 2)) * 100) * virtual_width / 100
        self.mouse_y = (((y - canvas_offset_y) / (window_height - canvas_offset_y * 2)) * 100) * virtual_height / 100
    end
end

function menu:draw()
    love.graphics.draw(self.background_texture, 0, 0, 0, virtual_width / self.background_texture:getWidth(),
        virtual_height / self.background_texture:getHeight())

    love.graphics.setFont(self.title_font)
    love.graphics.print(self.title, virtual_width / 2 - self.title_width / 2, self.title_y)


    if self.type == "main" then
        love.graphics.setColor(0.92, 0.81, 0.20, 0.4)
        love.graphics.rectangle("fill", virtual_width / 2 - self.high_score_width / 2 - 10, 310,
            self.high_score_width + 20,
            self.font:getHeight() - 10)
        love.graphics.setColor(1.0, 1.0, 1.0, 1.0)

        love.graphics.setLineWidth(5)
        love.graphics.setColor(0.92, 0.81, 0.20, 1.0)
        love.graphics.rectangle("line", virtual_width / 2 - self.high_score_width / 2 - 10, 310,
            self.high_score_width + 20,
            self.font:getHeight() - 10)
        love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
        love.graphics.setLineWidth(1)

        love.graphics.setFont(self.font)
        love.graphics.print(self.high_score_text, virtual_width / 2 - self.high_score_width / 2, 300)
    end

    local menu_options = (self.type == "main" and self.main_menu_options) or self.pause_menu_options

    for i = 1, #menu_options do
        self:draw_option(menu_options[i])
    end
end

function menu:draw_option(option)
    love.graphics.setColor(option.color.r, option.color.g, option.color.b, 0.4)
    love.graphics.rectangle("fill", option.x - 15, option.y + 10,
        option.width + 20, self.font:getHeight() - 10)
    love.graphics.setColor(option.color.r, option.color.g, option.color.b, 1.0)

    love.graphics.setLineWidth(5)
    love.graphics.rectangle("line", option.x - 15, option.y + 10,
        option.width + 20, self.font:getHeight() - 10)
    love.graphics.setLineWidth(1)

    love.graphics.setFont(self.font)
    love.graphics.print(option.text, option.x, option.y)
    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
end
