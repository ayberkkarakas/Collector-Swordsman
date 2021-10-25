love.graphics.setDefaultFilter("nearest", "nearest")
Object = require "classic"
Gamestate = require "gamestate"
local game = require "game"
local menu = require "menu"
local outro = require "outro"
local Player = require "player"
local Npc = Npc or require "npc"
local Coin = require "coin"
local Spike = require "spike"
local Stone = require "stone"
local GUI = require "gui"
local Camera = require "camera"
local Enemy = require "enemy"
local Map = require "map"
local outro = require "outro"

function love.load()
	Gamestate.registerEvents()
    Gamestate.switch(menu)
end

function love.update(dt)
	
end

function love.draw()
	
end

