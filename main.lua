require "utils.game"
require "utils.menu"

virtual_height = 1080
virtual_width = 1872

local canvas
local vignette_canvas
local vignette_shader

canvas_offset_x = 0
canvas_offset_y = 0

function draw_canvas()
    local window_width, window_height = love.graphics.getDimensions()

    local scale = math.min(window_width / virtual_width, window_height / virtual_height)

    canvas_offset_x = (window_width - virtual_width * scale) / 2
    canvas_offset_y = (window_height - virtual_height * scale) / 2
    love.graphics.draw(canvas, canvas_offset_x, canvas_offset_y, 0, scale, scale)
    love.graphics.setShader(vignette_shader)
    love.graphics.draw(vignette_canvas, canvas_offset_x, canvas_offset_y, 0, scale, scale)
    love.graphics.setShader()
    -- print_memory_usage()
end

function love.load(arg)
    default_font = love.graphics.getFont()
    love.window.setTitle("HAUNTED HEAT!")
    love.window.setMode(800, 600, { resizable = true })
    for i = 1, #arg do
        if arg[i] == "monitor-2" then
            love.window.setPosition(0, 0, 2)
        end
    end
    love.window.maximize()
    love.graphics.setDefaultFilter("nearest", "nearest")
    canvas = love.graphics.newCanvas(virtual_width, virtual_height)
    vignette_canvas = love.graphics.newCanvas(virtual_width, virtual_height)
    local shader_src = love.filesystem.read("res/shaders/vignette.glsl")
    vignette_shader = love.graphics.newShader(shader_src)
    state = "menu"
    menu:load()
    game:load()
end

function love.update(dt)
    if state == "menu" then
        menu:update(dt)
    elseif state == "game" then
        game:update(dt)
    end
end

function love.draw()
    love.graphics.clear()
    love.graphics.setCanvas(canvas)
    love.graphics.clear(0, 0, 0, 1)
    if state == "menu" then
        menu:draw()
    elseif state == "game" then
        game:draw()
    end
    love.graphics.setCanvas()
    draw_canvas()
end

function print_memory_usage()
    love.graphics.setFont(default_font)
    local luaMemory = collectgarbage("count") / 1024
    local stats = love.graphics.getStats()
    local textureMemory = stats.texturememory / 1024 / 1024

    love.graphics.print(string.format("RAM Memory: %.2f MB", luaMemory), 10, 10)
    love.graphics.print(string.format("GPU Memory: %.2f MB", textureMemory), 10, 30)
end
