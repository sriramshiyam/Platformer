sound = {}

function sound:load()
    self.attacked = love.audio.newSource("res/sound/attacked.wav", "static")
    self.attacked:setVolume(0.5)
    self.player_crouch = love.audio.newSource("res/sound/player_crouch.wav", "static")
    self.player_jump = love.audio.newSource("res/sound/player_jump.wav", "static")
end
