local Spike = Object:extend()

spikes = {}

function Spike:new(x,y)
	self.x = x
	self.y = y
	self.img = love.graphics.newImage("assets/spike.png")
	self.width = self.img:getWidth()
	self.height = self.img:getHeight()
	self.physics = {}
	self.physics.body = love.physics.newBody(world, self.x, self.y, "static")
	self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
	self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
	self.physics.fixture:setSensor(true)
	self.damage = 1
	table.insert(spikes, self)
end

function Spike.removeAll()
	for i,v in ipairs(spikes) do
		v.physics.body:destroy()
	end

	spikes = {}
end

function Spike:update(dt)
	
end


function Spike:draw()
	love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, self.width /2, self.width / 2)
end

function Spike.beginContact(a, b, collision)
	for i, spike in ipairs(spikes) do
		if a == spike.physics.fixture or b == spike.physics.fixture then
			if a == Player.physics.fixture or b == Player.physics.fixture then
				Player:takeDamage(spike.damage)
				return true 
			end
		end
	end
end

return Spike