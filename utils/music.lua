music = {}

function music:load()
    self.game_music = love.audio.newSource("res/music/game.ogg", "stream")
    self.game_music:setVolume(0.7)
    self.game_music:setLooping(true)
    self.menu_music = love.audio.newSource("res/music/menu.ogg", "stream")
    self.menu_music:setVolume(0.7)
    self.menu_music:setLooping(true)
    self.menu_music:play()
end
