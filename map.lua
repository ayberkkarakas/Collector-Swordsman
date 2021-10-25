local Map = {}
local STI = require("sti")
local Coin = require "coin"
local Spike = require "spike"
local Stone = require "stone"
local Enemy = require "enemy"
local Npc = require "npc"
local Editor = require "editor"
local Tutorial = require "tutorial"
local outro = require "outro"
load = 0

function Map:load()
	self.currentLevel = 1
	world = love.physics.newWorld(0,2000)
	world:setCallbacks(beginContact, endContact)
	load = load + 1
	self:init()
end

function Map:init()
	self.level = STI("map/"..self.currentLevel..".lua", {"box2d"})
	self.level:box2d_init(world)
	self.solidLayer = self.level.layers.solid
	self.entityLayer = self.level.layers.entity
	self.groundLayer = self.level.layers.ground

	self.solidLayer.visible = false
	self.entityLayer.visible = false
	mapWidth = self.groundLayer.width * 16
	mapHeight = self.groundLayer.height * 16

	self:spawnEntities()
	Editor:load()
end

function Map:next()
	if self.currentLevel < 3 then
		self.clean()
		Player.state = "idle"
		self.currentLevel = self.currentLevel + 1
		self:init()
		Player:load()
		Player:resetPosition()
	else
		Gamestate.switch(outro)
	end
end

function Map:reset()
	self.clean()
	self:init()
	Player:load()
	Player:resetPosition()
end

function Map:clean()
	Map.level:box2d_removeLayer("solid")
	Coin.removeAll()
	Enemy.removeAll()
	Spike.removeAll()
	Stone.removeAll()
	Npc.removeAll()
	Tutorial.removeAll()
	Player:remove()
end

function Map:update(dt)
	if Player.x > mapWidth - 20 then
		if Player.coins >= 13 then
			self:next()
			print("next")
		end
	end
end	

function Map:spawnEntities()
	for i,v in ipairs(self.entityLayer.objects) do
		if v.type == "spike" then
			Spike(v.x + v.width / 2, v.y + v.height / 2)
		elseif v.type == "stone" then
			Stone(v.x + v.width / 2, v.y + v.height / 2, v.width, v.height)
		elseif v.type == "coin" then
			Coin(v.x, v.y)
		elseif v.type == "enemy" then
			Enemy(v.x + 26 / 2, v.y + 24 / 2)
		elseif v.type == "tutorial" then
			Tutorial(v.name, v.x, v.y)
		elseif v.type == "npc" then
			if v.name == "firstNpc" or v.name == "secondNpc" or v.name == "thirdfifthNpc" then
				Npc(v.name ,v.x + v.width / 2, v.y + v.height / 2, "assets/male-npc.png", 1)
			elseif v.name == "firstVillager" or v.name == "secondVillager" or v.name == "thirdVillager" then
				Npc(v.name ,v.x + v.width / 2, v.y + v.height / 2, "assets/female-npc.png", -1)
			end
		end
	end
end

return Map