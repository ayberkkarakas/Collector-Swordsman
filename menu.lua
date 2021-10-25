local menu = {}
local game = require "game"
local Player = Player or require "player"
local Npc = Npc or require "npc"

local sound_effect = love.audio.newSource("sounds/menu.wav", "static")
sound_effect:setVolume(0.5)
local choose = love.audio.newSource("sounds/choose.wav", "static")
choose:setVolume(0.4)
main_music = love.audio.newSource("sounds/main.mp3", "static")
main_music:setVolume(0.4)

local position = 0
local in_menu = true

alagard = love.graphics.newFont("assets/alagard.ttf", 80)
upheav = love.graphics.newFont("assets/upheav.ttf", 25)
upheav_small = love.graphics.newFont("assets/upheav.ttf", 17)
fipps = love.graphics.newFont("assets/fipps.otf", 20)
fipps_small = love.graphics.newFont("assets/fipps.otf", 10)

background = love.graphics.newImage("assets/menu.png")
background:setWrap('repeat', 'clampzero')
play = love.graphics.newImage("assets/play.png")
exit = love.graphics.newImage("assets/exit.png")

button_width = play:getWidth()
button_height = play:getHeight()

play_hot = true
exit_hot = false

function menu:init()
    main_music:setLooping(true)
    main_music:play()
end

function menu:update(dt)
    position = position - 1
    myQuad = love.graphics.newQuad(-position,
        0,
        background:getWidth() * 2,
        background:getHeight() * 2,
        background:getWidth(),
        background:getHeight())
end

function love.keypressed(key)
    if in_menu == true then
        if key == "escape" then
            love.event.quit()
        end
        if key == "return" or key == "x" then
            if play_hot == true then
                choose:play()
                Gamestate.switch(game)
                in_menu = false
            else
                love.event.quit()
            end
        end
        if key == "down" or key == "up" then
            if play_hot == true then
                sound_effect:play()
                exit_hot = true
                play_hot = false
            else
                sound_effect:play()
                exit_hot = false
                play_hot = true
            end
        end
    end
end

function menu:draw()
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    play_button_scale = 1
    exit_button_scale = 1

    if play_hot then
        play_button_scale = 1.1
    end
    if exit_hot then
        exit_button_scale = 1.1
    end

    sx = love.graphics:getWidth() / background:getWidth()
    sy = love.graphics:getHeight() / background:getHeight()

    love.graphics.draw(background, myQuad, 0, 0, 0, sx, sy)
    love.graphics.setFont(alagard)
    love.graphics.setColor(24/255, 20/255, 37/255)
    love.graphics.printf( "Collector Swordsman", 0,155, ww,"center")
    love.graphics.printf( "Collector Swordsman", 0,145, ww,"center")
    love.graphics.printf( "Collector Swordsman", 5,150, ww,"center")
    love.graphics.printf( "Collector Swordsman", -5,150, ww,"center")
    love.graphics.setColor(24/255, 20/255, 37/255, 0.7)
    love.graphics.printf( "Collector Swordsman", 0,160, ww,"center")
    love.graphics.setColor(190/255, 74/255, 47/255)
    love.graphics.printf( "Collector Swordsman", 0,150, ww,"center")
    love.graphics.setFont(upheav)
    love.graphics.setColor(24/255, 20/255, 37/255)
    love.graphics.printf( "Arrow keys to navigate, 'x' to choose", 2,280, ww,"center")
    love.graphics.printf( "Arrow keys to navigate, 'x' to choose", 4,283, ww,"center")
    love.graphics.setColor(146/255, 232/255, 192/255)
    love.graphics.printf( "Arrow keys to navigate, 'x' to choose", 0,280, ww,"center")
    love.graphics.setColor(1, 1, 1, 0.7)
    love.graphics.draw(play, ww / 2 - button_width / 2 + 100, wh / 2 - button_height / 2 + 75,math.rad(0),play_button_scale,play_button_scale,100,50)
    love.graphics.draw(exit, ww / 2 - button_width / 2 + 100, wh / 2 - button_height / 2 + (button_height + 65) + 50,math.rad(0),exit_button_scale,exit_button_scale,100,50)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(play, ww / 2 - button_width / 2 + 100, wh / 2 - button_height / 2 + 70,0,play_button_scale,play_button_scale,100,50)
    love.graphics.draw(exit, ww / 2 - button_width / 2 + 100, wh / 2 - button_height / 2 + (button_height + 60) + 50,math.rad(0),exit_button_scale,exit_button_scale,100,50)

    love.graphics.setFont(fipps)
    love.graphics.setColor(24/255, 20/255, 37/255)
    love.graphics.printf("Moonflake", 0, wh - 117, ww,"center")
    love.graphics.printf("Moonflake", 3, wh - 120, ww,"center")
    love.graphics.setColor(146/255, 232/255, 192/255)
    love.graphics.printf("Moonflake", 0, wh - 120, ww,"center")
    love.graphics.setFont(upheav_small)
    love.graphics.setColor(24/255, 20/255, 37/255)
    love.graphics.printf("Ayberk Karakas - Programmer", 0, wh - 67, ww,"center")
    love.graphics.printf("Berfin Ceylan - Programmer, Pixel Artist", 0, wh - 42, ww,"center")
    love.graphics.printf("Ayberk Karakas - Programmer", 2, wh - 70, ww,"center")
    love.graphics.printf("Berfin Ceylan - Programmer, Pixel Artist", 2, wh - 45, ww,"center")
    love.graphics.setColor(146/255, 232/255, 192/255)
    love.graphics.printf("Ayberk Karakas - Programmer", 0, wh - 70, ww,"center")
    love.graphics.printf("Berfin Ceylan - Programmer, Pixel Artist", 0, wh - 45, ww,"center")
    love.graphics.setColor(1, 1, 1)
end

return menu