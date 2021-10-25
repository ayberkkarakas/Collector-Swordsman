Player = {}
local Camera = require "camera"
local Npc = Npc or require "npc"
local Map = require "map"
local Enemy = require "enemy"

local damage_sound = love.audio.newSource("sounds/damage.wav", "static")
damage_sound:setVolume(0.4)
local jump_sound = love.audio.newSource("sounds/jump.wav", "static")
jump_sound:setVolume(0.4)
local hit_sound = love.audio.newSource("sounds/hit.wav", "static")
hit_sound:setVolume(0.5)

function Player:load()
	self.x = 100
	self.y = 600
	self.startX = self.x
	self.startY = self.y
	self.width = 28
	self.height = 36
	self.xVel = 0
	self.yVel = 0
	self.maxSpeed = 200
	self.acceleration = 4000
	self.friction = 3500
	self.walkable = true
	self.gravity = 1500
	self.jumpAmount = -12000
	self.doubleJump = true
	self.coins = 0
	self.health = {current = 10, max = 10}
	self.damage = 10
	self.range = 65
	self.timer = 0
	self.attacking = false
	self.died = false

	self.color = {
		red = 1,
		blue = 1,
		green = 1,
		speed = 3
	}

	self.alive = true
	self.graceTime = 0
	self.graceDuration = 0.1

	self.grounded = false

	self.physics = {}
	self.physics.body = love.physics.newBody(world, self.x, self.y, "dynamic")
	self.physics.body:setFixedRotation(true)
	self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
	self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
	self.physics.body:setGravityScale(0)

    self.frames = {}
    self.frames.idle = {}
    self.frames.run = {}
    self.frames.attack = {}
    self.frames.death = {}

    self.idle_image = love.graphics.newImage("assets/idle.png")
    local idle_width = self.idle_image:getWidth()
    local idle_height = self.idle_image:getHeight()

    idle_frame_width = 28
    idle_frame_height = 38
    for i=0,3 do
        table.insert(self.frames.idle, love.graphics.newQuad(i * idle_frame_width, 0, idle_frame_width, idle_frame_height, idle_width, idle_height))
    end

    self.run_image = love.graphics.newImage("assets/run.png")
    local run_width = self.run_image:getWidth()
    local run_height = self.run_image:getHeight()

    run_frame_width = 28
    run_frame_height = 38
    for i=0,7 do
        table.insert(self.frames.run, love.graphics.newQuad(i * run_frame_width, 0, run_frame_width, run_frame_height, run_width, run_height))
    end

    self.attack_image = love.graphics.newImage("assets/attack.png")
    local attack_width = self.attack_image:getWidth()
    local attack_height = self.attack_image:getHeight()

    attack_frame_width = 64
    attack_frame_height = 42
    for i=0,5 do
        table.insert(self.frames.attack, love.graphics.newQuad(i * attack_frame_width, 0, attack_frame_width, attack_frame_height, attack_width, attack_height))
    end

    self.death_image = love.graphics.newImage("assets/death.png")
    local death_width = self.death_image:getWidth()
    local death_height = self.death_image:getHeight()

    death_frame_width = 28
    death_frame_height = 36
    for i=0,6 do
        table.insert(self.frames.death, love.graphics.newQuad(i * death_frame_width, 0, death_frame_width, death_frame_height, death_width, death_height))
    end

    self.jump_image = love.graphics.newImage("assets/jump.png")
    jump_frame_width = 28
    jump_frame_height = 42

    self.direction = "right"
    self.state = "idle"

    self.current_idle_frame = 1
    self.current_run_frame = 1
    self.current_attack_frame = 1
    self.current_death_frame = 1
end

function Player:remove()
	Player.physics.body:destroy()
end

function Player:takeDamage(amount)
	self:tintRed()
	if self.health.current - amount > 0 then
		self.health.current = self.health.current - amount 
		Camera.shakeDuration = 0.3
		damage_sound:play()
		print(self.health)
	else 
		self.health.current = 0
		damage_sound:play() 
		self:die()
	end
end

function Player:die()
	self.died = true
	self.xVel = 0
end

function Player:respawn()
	if not self.alive then
		self:resetPosition()
		Map:reset()
		self.coins = 0
		self.health.current = self.health.max
		self.alive = true
		self.died = false
	end
end

function Player:resetPosition()
	self.physics.body:setPosition(self.startX, self.startY)
end

function Player:tintRed()
	self.color.green = 0
	self.color.blue = 0
end

function Player:untint(dt)
	self.color.red = math.min(self.color.red + self.color.speed * dt, 1)
	self.color.green = math.min(self.color.green + self.color.speed * dt, 1)
	self.color.blue = math.min(self.color.blue + self.color.speed * dt, 1)
end

function Player:incrementCoins()
	self.coins = self.coins + 1
end

function Player:update(dt)
	self:untint(dt)
	self:respawn()
	self:decreaseGraceTime (dt)
	self:syncPhysics()
	self:move(dt)
	self:applyGravity(dt)
	self:dialog()
	self.current_idle_frame = self.current_idle_frame + 3 * dt
	self.current_run_frame = self.current_run_frame + 12 * dt
	if self.state == "attack" then
		self.current_attack_frame = self.current_attack_frame + 12 * dt
	end
	if self.state == "death" then
		self.current_death_frame = self.current_death_frame + 6 * dt
	end
    if self.current_idle_frame >= 4 then
        self.current_idle_frame = 1
    end
    if self.current_run_frame >= 8 then
        self.current_run_frame = 1
    end
    if self.current_attack_frame > 6 then
    	self.attacking = false
        self.current_attack_frame = 1
    end
    if self.current_death_frame > 6 then
    	self.alive = false
        self.current_death_frame = 1
    end
    self:setState()
    self.timer = self.timer + dt
    delta_time = dt
    jump_delta = self.jumpAmount * delta_time
end

function Player:setState()
	if self.died == true then
		self.state = "death"
	elseif self.attacking == true then
		self.state = "attack"
	elseif not self.grounded then
		self.state = "air"
	elseif self.xVel == 0 then
		self.state = "idle"
	else
		self.state = "run"
	end
end

function Player:decreaseGraceTime (dt)
	if not self.grounded then
		self.graceTime = self.graceTime - dt
	end
end	

function Player:applyGravity(dt)
	if not self.grounded then
		self.yVel = self.yVel + self.gravity * dt
	end
end

function Player:move(dt)
	if not self.died then
		if love.keyboard.isDown("d", "right") then
			self.direction = "right"
			if self.xVel < self.maxSpeed then
				if self.xVel + self.acceleration * dt < self.maxSpeed then
			   	self.xVel = self.xVel + self.acceleration * dt
				else
					self.xVel = self.maxSpeed
				end 
			end
		elseif love.keyboard.isDown("a", "left") then
			self.direction = "left"
			if self.xVel > -self.maxSpeed then
				if self.xVel + self.acceleration * dt > -self.maxSpeed then
					self.xVel = self.xVel - self.acceleration * dt
				else
					self.xVel = -self.maxSpeed
				end 
			end
		else 
			self:applyFriction(dt)
		end
	end
end

function Player:applyFriction(dt)
	if self.xVel > 0 then
		if self.xVel - self.friction * dt > 0 then
			self.xVel = self.xVel - self.friction * dt
		else
			self.xVel = 0 
		end
	elseif self.xVel < 0 then
		if self.xVel + self.friction * dt < 0 then
			self.xVel = self.xVel + self.friction * dt
		else
			self.xVel = 0
		end
	end
end

function Player:syncPhysics()
	self.x, self.y = self.physics.body:getPosition()
	self.physics.body:setLinearVelocity(self.xVel, self.yVel)
end

function Player:beginContact(a, b, collision)
	if self.grounded == true then return end
	local nx, ny = collision:getNormal()
	if a == self.physics.fixture then
		if ny > 0 then
			self:land(collision)
		elseif ny < 0 then
			self.yVel = 0
		end
	elseif b == self.physics.fixture then
		if ny < 0 then
			self:land(collision)
		elseif ny > 0 then
			self.yVel = 0
		end
	end
end

function Player:land(collision)
	self.currentGroundCollision = collision
	self.yVel = 0
	self.grounded = true
	self.doubleJump = true
	self.graceTime = self.graceDuration 
end

function Player:jump(key)
	if (key == "w" or key == "up") then
		if not self.died then
			if self.grounded or self.graceTime > 0 then
				jump_sound:play()
				self.yVel = jump_delta
				self.gracetime = 0
			elseif self.doubleJump then
				jump_sound:play()
				self.doubleJump = false
				self.yVel = jump_delta * 0.8
			end
		end
	end
end

function Player:getDistance(x1, y1, x2, y2)
    horizontal_distance = x1 - x2
    local vertical_distance = y1 - y2
    local a = horizontal_distance ^ 2
    local b = vertical_distance ^2

    local c = a + b
    local distance = math.sqrt(c)
    return distance
end

function Player:dialog()
	for i, npc in ipairs(npcs) do
		if self:getDistance(Player.x, Player.y, npc.x, npc.y) < 50 then
			npc.dialog = true
		else
			npc.dialog = false
		end
	end
end

function Player:attack(key)
	if key == "x" then
		self.attacking = true
		for i, enemy in ipairs(enemies) do
			if self:getDistance(self.x, self.y, enemy.x, enemy.y) < self.range then
				if self.timer >= 0.6 then
					if horizontal_distance < 0 then
    					attack_side = "right"
    				elseif horizontal_distance > 0 then
    					attack_side = "left"
    				else 
    					attack_side = "center"
    				end
					if self.direction == attack_side or attack_side == "center" then
						hit_sound:play()
						enemy:tintRed()
						enemy.health = enemy.health - self.damage
						self.timer = 0
					end
				end
			end
		end
	end
end

function Player:endContact(a, b, collision)
	if a == self.physics.fixture or b == self.physics.fixture then
		if self.currentGroundCollision == collision then 
			self.grounded = false
		end
	end
end

function Player:draw() 
	local scaleX = 1
	if self.direction == "left" then
		scaleX = -1
	end
	love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
	if self.state == "idle" then
		love.graphics.draw(self.idle_image, self.frames.idle[math.floor(self.current_idle_frame)], self.x, self.y, 0, scaleX, 1, idle_frame_width / 2,
		idle_frame_height / 2)
	elseif self.state == "run" then
		love.graphics.draw(self.run_image, self.frames.run[math.floor(self.current_run_frame)], self.x, self.y, 0, scaleX, 1, run_frame_width / 2,
		run_frame_height / 2)
	elseif self.state == "air" then
		love.graphics.draw(self.jump_image, self.x, self.y, 0, scaleX, 1, jump_frame_width / 2,
		jump_frame_height / 2)
	elseif self.state == "attack" then
		love.graphics.draw(self.attack_image, self.frames.attack[math.floor(self.current_attack_frame)], self.x, self.y, 0, scaleX, 1, attack_frame_width / 2,
		(attack_frame_height / 2) + 1.8)
	elseif self.state == "death" then
		love.graphics.draw(self.death_image, self.frames.death[math.floor(self.current_death_frame)], self.x, self.y, 0, scaleX, 1, death_frame_width / 2,
		(death_frame_height / 2))
	end
	love.graphics.setColor(1, 1, 1)
end

return Player