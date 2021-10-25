local outro = {}
local Player = Player or require "player"
local Npc = Npc or require "npc"

local position = 0

alagard = love.graphics.newFont("assets/alagard.ttf", 80)
alagard_small = love.graphics.newFont("assets/alagard.ttf", 40)
alagard_extra_small = love.graphics.newFont("assets/alagard.ttf", 30)
upheav = love.graphics.newFont("assets/upheav.ttf", 25)
upheav_small = love.graphics.newFont("assets/upheav.ttf", 17)
moonflake = love.graphics.newFont("assets/fipps.otf", 30)

background = love.graphics.newImage("assets/menu.png")
background:setWrap('repeat', 'clampzero')
cs50 = love.graphics.newImage("assets/cs50.png")

function outro:init()
    main_music:setLooping(false)
end

function outro:update(dt)
    position = position - 1
    myQuad = love.graphics.newQuad(-position,
        0,
        background:getWidth() * 2,
        background:getHeight() * 2,
        background:getWidth(),
        background:getHeight())
end

function love.keypressed(key)
        if key == "return" then
            Gamestate.switch(menu)
        end
end

function outro:draw()
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    sx = love.graphics:getWidth() / background:getWidth()
    sy = love.graphics:getHeight() / background:getHeight()

    love.graphics.draw(background, myQuad, 0, 0, 0, sx, sy)
    love.graphics.setFont(alagard)
    love.graphics.setColor(24/255, 20/255, 37/255)
    love.graphics.printf( "The End", 0,155, ww,"center")
    love.graphics.printf( "The End", 0,145, ww,"center")
    love.graphics.printf( "The End", 5,150, ww,"center")
    love.graphics.printf( "The End", -5,150, ww,"center")
    love.graphics.setColor(24/255, 20/255, 37/255, 0.7)
    love.graphics.printf( "The End", 0,160, ww,"center")
    love.graphics.setColor(190/255, 74/255, 47/255)
    love.graphics.printf( "The End", 0,150, ww,"center")
    love.graphics.setColor(24/255, 20/255, 37/255)
    love.graphics.setFont(alagard_small)
    love.graphics.printf( "Thank you for playing our game", 1,260, ww,"center")
    love.graphics.printf( "Thank you for playing our game", 2,262, ww,"center")
    love.graphics.setColor(146/255, 232/255, 192/255)
    love.graphics.printf( "Thank you for playing our game", 0,260, ww,"center")
    love.graphics.setColor(1, 1, 1, 0.7)

    love.graphics.setFont(moonflake)
    love.graphics.setColor(24/255, 20/255, 37/255)
    love.graphics.printf("Moonflake", 0, wh - 397, ww,"center")
    love.graphics.printf("Moonflake", 3, wh - 400, ww,"center")
    love.graphics.setColor(146/255, 232/255, 192/255)
    love.graphics.printf("Moonflake", 0, wh - 400, ww,"center")
    love.graphics.setFont(upheav)
    love.graphics.setColor(24/255, 20/255, 37/255)
    love.graphics.printf("Ayberk Karakas - Programmer", 0, wh - 317, ww,"center")
    love.graphics.printf("Berfin Ceylan - Programmer, Pixel Artist", 0, wh - 282, ww,"center")
    love.graphics.printf("Ayberk Karakas - Programmer", 2, wh - 320, ww,"center")
    love.graphics.printf("Berfin Ceylan - Programmer, Pixel Artist", 2, wh - 285, ww,"center")
    love.graphics.setColor(146/255, 232/255, 192/255)
    love.graphics.printf("Ayberk Karakas - Programmer", 0, wh - 320, ww,"center")
    love.graphics.printf("Berfin Ceylan - Programmer, Pixel Artist", 0, wh - 285, ww,"center")
    love.graphics.setColor(24/255, 20/255, 37/255)
    love.graphics.printf("MasterofRevels - Music", 0, wh - 247, ww,"center")
    love.graphics.printf("MasterofRevels - Music", 2, 2 - 250, ww,"center")
    love.graphics.setColor(146/255, 232/255, 192/255)
    love.graphics.printf("MasterofRevels - Music", 0, wh - 250, ww,"center")
    love.graphics.setFont(alagard_extra_small)
    love.graphics.printf( "Made for", -65,675, ww,"center")
    love.graphics.draw(cs50, 687,670, 0,0.05,0.05)
    love.graphics.setColor(1, 1, 1)
end

return outro