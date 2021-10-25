local Stone = Object:extend()

stones = {}

function Stone:new(x,y,width,height)
	self.x = x
	self.y = y
	self.r = 0
	self.img = love.graphics.newImage("assets/stone.png")
	self.width = width
	self.height = height
	self.physics = {}
	self.physics.body = love.physics.newBody(world, self.x, self.y, "dynamic")
	self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
	self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
	self.physics.body:setMass(10)

	table.insert(stones, self)
end

function Stone.removeAll()
	for i,v in ipairs(stones) do
		v.physics.body:destroy()
	end

	stones = {}
end

function Stone:update()
	self.x, self.y = self.physics.body:getPosition()
	self.r = self.physics.body:getAngle()
end



function Stone:draw()
	love.graphics.draw(self.img, self.x, self.y, self.r, 1, 1, self.width /2, self.width / 2)
end


return Stone