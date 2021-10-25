local player = Player or require"player"
local Tutorial = Object:extend()

tutorials = {}

function Tutorial:new(name, x, y)
	self.name = name
	self.text = {}
	self.x = x
	self.y = y
	self.r = 0
	self.width = 24
	self.height = 36
	self.speed = 0
	self.physics = {}
	self.font = love.graphics.newFont("assets/alagard.ttf",14)
	self.image = love.graphics.newImage("assets/dialog.png")
	self.open = false
	self.physics = {}

	table.insert(tutorials, self)
end

function Tutorial.removeAll()
	tutorials = {}
end

function Tutorial:getDistance(x1, y1, x2, y2)
    horizontal_distance = x1 - x2
    local vertical_distance = y1 - y2
    local a = horizontal_distance * horizontal_distance
    local b = vertical_distance ^2

    local c = a + b
    local distance = math.sqrt(c)
    return distance
end

function Tutorial:update(dt)
	print(self:getDistance(Player.x, Player.y, self.x, self.y))
	if self:getDistance(Player.x, Player.y, self.x, self.y) < 80 then
		self.open = true
	else
		self.open = false
	end
end

function Tutorial:draw()
	if self.open == true then
		love.graphics.setColor(0, 0, 0,0.5)
		love.graphics.setFont(self.font)
		love.graphics.draw(self.image, self.x, self.y - 150, 0,1.2,1.2)
		love.graphics.setColor(1, 1, 1,0.8)
		love.graphics.print(self.text, self.x+12,self.y - 140)
	end
end

return Tutorial