loading = {}

function loading:load()
    self.canvas = love.graphics.newCanvas(virtual_width, virtual_height)
    local shader_src = love.filesystem.read("res/shaders/loading.glsl")
    self.loading_shader = love.graphics.newShader(shader_src)
    self.enabled = false
    self.min = 0.0
    self.max = 0.0
    self.draw_timer = 0.0
    self.state_to_change = ""
    self.music_to_stop = {}
    self.music_to_play = {}
    self.direction = "right"
end

function loading:update(dt)
    if self.enabled then
        self.draw_timer = self.draw_timer + dt
        if self.direction == "right" then
            if self.max >= 1.0 then
                self.direction = "left"
                state = self.state_to_change
                self.music_to_stop:stop()
                self.music_to_play:play()
                self.draw_timer = 0.0
            end
            if self.draw_timer > 0.1 then
                self.draw_timer = 0.0
                self.max = self.max + 0.1
            end
        elseif self.direction == "left" then
            if self.min >= 1.0 and self.draw_timer > 0.1 then
                self.enabled = false
                self.min = 0.0
                self.max = 0.0
                self.draw_timer = 0.0
                self.state_to_change = ""
                self.direction = "right"
                return
            end
            if self.draw_timer > 0.1 then
                self.draw_timer = 0.0
                self.min = self.min + 0.1
            end
        end
    end
end

function loading:draw()
    if self.enabled then
        love.graphics.setShader(self.loading_shader)
        self.loading_shader:send("min", self.min)
        self.loading_shader:send("max", self.max)
        love.graphics.draw(self.canvas, 0, 0)
        love.graphics.setShader()
    end
end
