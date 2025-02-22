sound = {}

function sound:load()
    self.attacked = love.audio.newSource("res/sound/attacked.wav", "static")
    self.attacked:setVolume(0.5)
    self.player_crouch = love.audio.newSource("res/sound/player_crouch.wav", "static")
    self.player_jump = love.audio.newSource("res/sound/player_jump.wav", "static")
    self.ghost = love.audio.newSource("res/sound/ghost.wav", "static")
    self.ghost:setVolume(0.8)
    self.start_sound = {
        love.audio.newSource("res/sound/3.mp3", "static"),
        love.audio.newSource("res/sound/2.mp3", "static"),
        love.audio.newSource("res/sound/1.mp3", "static"),
        love.audio.newSource("res/sound/go.mp3", "static"),
    }
    self:init()
    self.start_sound[1]:setPitch(1.1)
    self.start_sound[2]:setPitch(1.1)
    self.start_sound[3]:setPitch(1.1)
    self.start_sound[4]:setPitch(1.1)
    self.select = love.audio.newSource("res/sound/select.wav", "static")
end

function sound:init()
    self.start_sound.played = false
    self.start_sound.timer = 0.0
    self.start_sound.index = 1
end

function sound:update(dt)
    if self.start_sound.index <= 4 then
        if not self.start_sound.played then
            self.start_sound[self.start_sound.index]:play()
            self.start_sound.played = true
        end
        self.start_sound.timer = self.start_sound.timer + dt
        if self.start_sound.timer > (self.start_sound[self.start_sound.index]:getDuration("seconds") + 0.5) then
            self.start_sound.timer = 0.0
            self.start_sound.played = false
            self.start_sound.index = self.start_sound.index + 1
        end
    end
end
