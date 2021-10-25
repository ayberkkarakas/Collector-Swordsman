local GUI  = {}
local Player = require "player"

function GUI:load()
	self.coins = {}
	self.coins.img = love.graphics.newImage("assets/coin.png")
	self.coins.width = self.coins.img:getWidth()
	self.coins.height = self.coins.img:getHeight()
	self.coins.x = love.graphics.getWidth() - 740
	self.coins.y = 10

	self.hearts = {}
	self.hearts.img = love.graphics.newImage("assets/heart.png")
	self.hearts.width = self.hearts.img:getWidth()
	self.hearts.height = self.hearts.img:getHeight()
	self.hearts.x = 0
	self.hearts.y = 10
	self.hearts.scale =1.5
	self.hearts.spacing = self.hearts.width * self.hearts.scale + 5

	self.font = love.graphics.newFont("assets/alagard.ttf", 16)
	self.fps_font = love.graphics.newFont("assets/alagard.ttf", 12)
end

function GUI:update()

end

function GUI:draw()
	self:displayCoins()
	self:displayCoinText()
	self:displayHearts()
end

function GUI:displayHearts()
	for i = 1,Player.health.current do
		local x = self.hearts.x + self.hearts.spacing * i
		love.graphics.setColor(0,0,0,0.5)
		love.graphics.draw(self.hearts.img, x + 2, self.hearts.y + 2,0,self.hearts.scale,self.hearts.scale)
		love.graphics.setColor(1,1,1,1)
		love.graphics.draw(self.hearts.img, x, self.hearts.y,0,self.hearts.scale,self.hearts.scale)
	end
end

function GUI:displayCoins()
	love.graphics.setColor(0,0,0,0.5)
	love.graphics.draw(self.coins.img, self.coins.x + 1, self.coins.y + 1, 0,1.2,1.2)
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(self.coins.img, self.coins.x, self.coins.y, 0,1.2,1.2)
end

function GUI:displayCoinText()
	love.graphics.setFont(self.font)
	local x = self.coins.x + self.coins.width
	local y = self.coins.y + self.coins.height / 2 - self.font:getHeight() / 2 + 1
	love.graphics.setColor(0,0,0,0.5)
	love.graphics.print(" : "..Player.coins, x + 2, y + 2)
	love.graphics.setColor(1,1,1,1)
	love.graphics.print(" : "..Player.coins, x, y)
end

return GUI