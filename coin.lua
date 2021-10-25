local Coin = Object:extend()

coin_sound = love.audio.newSource("sounds/coin.wav", "static")
coin_sound:setVolume(0.5)

coins = {}

function Coin:new(x,y)
	self.x = x
	self.y = y
	self.width = 11
	self.height = 11
	self.scaleX = 1
	self.randomTime = math.random(0, 100)
	self.toBeRemoved = false
	self.physics = {}
	self.physics.body = love.physics.newBody(world, self.x, self.y, "static")
	self.physics.shape = love.physics.newRectangleShape(self.width -2, self.height -2)
	self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
	self.physics.fixture:setSensor(true)
	self.frames = {}

    self.image = love.graphics.newImage("assets/coin-animation.png")
    local wwidth = 88
    local hheight = 11

    frame_width = 11
    frame_height = 11
    for i=0,7 do
        table.insert(self.frames, love.graphics.newQuad(i * frame_width, 0, frame_width, frame_height, wwidth, hheight))
    end
    self.current_frame = 1
	table.insert(coins, self)
end

function Coin:remove()
	for i, coin in ipairs(coins) do 
		if coin == self then
			Player:incrementCoins()
			self.physics.body:destroy()
			table.remove(coins, i)
		end	
	end
end

function Coin.removeAll()
	for i,v in ipairs(coins) do
		v.physics.body:destroy()
	end
	coins = {}
end

function Coin:update(dt)
	self:spin()
	self:checkRemove()
	self.current_frame = self.current_frame + 6 * dt
	if self.current_frame >= 8 then
        self.current_frame = 1
    end
end

function Coin:checkRemove()
	if self.toBeRemoved then
		self:remove()
	end
end

function Coin:spin(dt)
	self.scaleX = math.sin(love.timer.getTime() * 2 + self.randomTime)
end

function Coin:draw()
	love.graphics.draw(self.image, self.frames[math.floor(self.current_frame)], self.x, self.y, 0, 1.5, 1.5, frame_width / 2,
		frame_height / 2)
end

function Coin.beginContact(a, b, collision)
	for i, coin in ipairs(coins) do
		if a == coin.physics.fixture or b == coin.physics.fixture then
			if a == Player.physics.fixture or b == Player.physics.fixture then
				coin_sound:play()
				coin.toBeRemoved = true
				return true 
			end
		end
	end
end

return Coin