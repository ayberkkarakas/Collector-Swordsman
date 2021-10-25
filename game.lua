love.graphics.setDefaultFilter("nearest", "nearest")
Object = require "classic"
local tick = require 'tick'
local Player = require "player"
local Coin = require "coin"
local Spike = require "spike"
local Stone = require "stone"
local GUI = require "gui"
local Camera = require "camera"
local Enemy = require "enemy"
local Npc = require "npc"
local Map = require "map"
local Editor = require "editor"

local game = {}

function game:init()
	tick.framerate = 60
	Map:load()
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
	background = love.graphics.newImage("assets/background.png")
	GUI:load()
	Player:load()
	Editor:load()
end

function game:update(dt)
	world:update(dt)
	Player:update(dt)
	for i, coin in ipairs(coins) do 
		coin:update(dt)	
	end
	for i, stone in ipairs(stones) do 
		stone:update()	
	end	
	for i, enemy in ipairs(enemies) do 
		enemy:update(dt)	
	end

	for i, npc in ipairs(npcs) do 
		npc:update(dt)	
	end	
	for i, tutorial in ipairs(tutorials) do 
		tutorial:update()	
	end	
	GUI:update()
	Camera:setPosition(Player.x, Player.y + 100)
	Camera:update(dt)
	Map:update(dt)
end

function game:draw()
	love.graphics.draw(background,0,0,math.rad(0),1.5,1)

	Camera:apply()
	Player:draw()
	for i, spike in ipairs(spikes) do 
			spike:draw()	
	end
	Map.level:draw(-Camera.x,-Camera.y, Camera.scale, Camera.scale)
	for i, coin in ipairs(coins) do 
		coin:draw()	
	end

	for i, stone in ipairs(stones) do 
		stone:draw()	
	end

	for i, enemy in ipairs(enemies) do 
		enemy:draw()	
	end

	for i, npc in ipairs(npcs) do 
		npc:draw()	
	end
	for i, tutorial in ipairs(tutorials) do 
		tutorial:draw()	
	end
	Editor:draw()
	Camera:clear()

	love.graphics.push()
	love.graphics.scale(2, 2)
	GUI:draw()
	love.graphics.pop()
end

function game:keypressed(key)
	Player:jump(key)
	Player:attack(key)
end

function beginContact(a, b, collision)
	if Coin.beginContact(a, b, collision) then return end
	if Spike.beginContact(a, b, collision) then return end
	Player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
	Player:endContact(a, b, collision)
end

return game