music = {}

function music:load()
    self.game_music = love.audio.newSource("res/music/game.ogg", "stream")
    self.game_music:setVolume(0.7)
    self.game_music:setLooping(true)
    self.game_music:play()
end
