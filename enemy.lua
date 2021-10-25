local Enemy = Object:extend()
Coin = require "coin"

local hit_sound = love.audio.newSource("sounds/hit.wav", "static")
hit_sound:setVolume(0.4)

enemies = {}

function Enemy:new(x,y)
	self.xOrigin = x
	self.yOrigin = y
	self.x = x
	self.y = y
	self.r = 0
	self.width = 26
	self.height = 24
	self.damage = 1
	self.speed = 100
	self.speedMod = 1
	self.timer = 0
	self.chasing = false
	self.xVel = self.speed
	self.direction = "right"
	self.physics = {}
	self.physics.body = love.physics.newBody(world, self.x, self.y, "dynamic")
	self.physics.body:setFixedRotation(true)
	self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
	self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
	self.physics.body:setMass(25)
	self.health = 20
	self.healthbar_full = love.graphics.newImage("assets/healthbar-full.png")
	self.healthbar_half = love.graphics.newImage("assets/healthbar-half.png")
	self.died = false
	self.alive = true
	self.attacking = false
	self.range = 50
	self.attack_timer = 1

	self.color_red = 1
	self.color_green = 1
	self.color_blue = 1
	self.color_speed = 3

	self.frames = {}

    self.run_image = love.graphics.newImage("assets/enemy-run.png")
    self.frames.run = {}
    local run_width = self.run_image:getWidth()
    local run_height = self.run_image:getHeight()
    run_frame_width = 26
    run_frame_height = 30
    for i=0,5 do
        table.insert(self.frames.run, love.graphics.newQuad(i * run_frame_width, 0, run_frame_width, run_frame_height, run_width, run_height))
    end

    self.death_image = love.graphics.newImage("assets/enemy-death.png")
    self.frames.death = {}
    local death_width = self.death_image:getWidth()
    local death_height = self.death_image:getHeight()
    death_frame_width = 22
    death_frame_height = 30
    for i=0,6 do
        table.insert(self.frames.death, love.graphics.newQuad(i * death_frame_width, 0, death_frame_width, death_frame_height, death_width, death_height))
    end

    self.attack_image = love.graphics.newImage("assets/enemy-attack.png")
    self.frames.attack = {}
    local attack_width = self.attack_image:getWidth()
    local attack_height = self.attack_image:getHeight()
    attack_frame_width = 30
    attack_frame_height = 30
    for i=0,3 do
        table.insert(self.frames.attack, love.graphics.newQuad(i * attack_frame_width, 0, attack_frame_width, attack_frame_height, attack_width, attack_height))
    end

    self.state = "run"

    current_run_frame = 1
    current_death_frame = 1
    current_attack_frame = 1

	table.insert(enemies, self)
end

function Enemy:update(dt)
	self:untint(dt)
	self.x, self.y = self.physics.body:getPosition()
	self.r = self.physics.body:getAngle()
	self:syncPhysics()
	current_run_frame = current_run_frame + 2 * dt
	if self.state == "death" then
		current_death_frame = current_death_frame + 12 * dt
	end
	if self.state == "attack" then
		current_attack_frame = current_attack_frame + 10 * dt
	end
    if current_run_frame >= 7 then
        current_run_frame = 1
    end
    if current_death_frame > 6 then
    	self.alive = false
        current_death_frame = 1
    end
    if current_attack_frame > 4 then
        current_attack_frame = 1
        self:attack()
        self.state = "run"
    end
    self:checkAttack()
    self.timer = self.timer + dt
    self.attack_timer = self.attack_timer + dt
    if self.timer >= 1.5 then
		self:flipDirection()
		self.timer = 0
	end
	self:chase() 
	if self.health <= 0 then
		self.died = true
	end
	if self.alive == false then
    	for i, enemy in ipairs(enemies) do 
			if enemy == self then
				table.remove(enemies, i)
				enemy.physics.body:destroy()
				Coin:new(self.x, self.y)
			end	
		end
	end
	if self.died == true then
		self.xVel = self.xVel / 100000000
		self.state = "death"
	end
	if self.xVel > 0 then 
		self.direction = "right"
	elseif self.xVel < 0 then 
		self.direction = "left"
	end
end

function Enemy:getDistance(x1, y1, x2, y2)
    horizontal_distance = x1 - x2
    local vertical_distance = y1 - y2
    local a = horizontal_distance ^2
    local b = vertical_distance ^2

    local c = a + b
    local distance = math.sqrt(c)
    return distance
end

function Enemy:checkAttack()
	if self:getDistance(self.x, self.y, Player.x, Player.y) < 60 then
		if self.attack_timer > 1 then
			self.state = "attack"
			self.attack_timer = 0
		end
	end
end

function Enemy:attack()
	if self:getDistance(self.x, self.y, Player.x, Player.y) < self.range then
		if horizontal_distance < 0 then
    		attack_side = "right"
    	elseif horizontal_distance > 0 then
    		attack_side = "left"
    	else 
    		attack_side = "center"
    	end
		if self.direction == attack_side or attack_side == "center" then
			Player:takeDamage(self.damage)
		end
	end
end

function Enemy.removeAll()
	for i,v in ipairs(enemies) do
		v.physics.body:destroy()
	end

	enemies = {}
end

function Enemy:tintRed()
	self.color_green = 0
	self.color_blue = 0
end

function Enemy:untint(dt)
	self.color_red = math.min(self.color_red + self.color_speed * dt, 1)
	self.color_green = math.min(self.color_green + self.color_speed * dt, 1)
	self.color_blue = math.min(self.color_blue + self.color_speed * dt, 1)
end

function Enemy:chase()
	if math.sqrt((Player.x - self.x)^2 + (Player.y - self.y)^2) < 60 then
		self.chasing = true
		self.speedMod = 1.2
		local side = Player.x - self.x
		if side <  0 then
			self.xVel = -self.speed
		else 
			self.xVel = self.speed
		end
	else
		self.speedMod = 1
		self.chasing = false
	end
end

function Enemy:flipDirection()
	if self.chasing == false then 
		self.xVel = -self.xVel
	end
end

function Enemy:syncPhysics()
	self.x, self.y = self.physics.body:getPosition()
	self.physics.body:setLinearVelocity(self.xVel * self.speedMod, 100)
end

function Enemy:draw()
	local scaleX = 1
	if self.xVel < 0 then
		scaleX = -1
	end
	love.graphics.setColor(self.color_red, self.color_green, self.color_blue)
	if self.state == "run" or self.state == "pushed" then
		love.graphics.draw(self.run_image, self.frames.run[math.floor(current_run_frame)], self.x, self.y, 0, scaleX, 1, run_frame_width / 2,
		run_frame_height / 2)
	elseif self.state == "death" then
		love.graphics.draw(self.death_image, self.frames.death[math.floor(current_death_frame)], self.x, self.y, 0, scaleX, 1, death_frame_width / 2,
		death_frame_height / 2)
	elseif self.state == "attack" then
		love.graphics.draw(self.attack_image, self.frames.attack[math.floor(current_attack_frame)], self.x, self.y, 0, scaleX, 1, attack_frame_width / 2 - 20,
		attack_frame_height / 2 -2)	
	end
	if self.health == 20 then
		love.graphics.draw(self.healthbar_full, self.x - self.width / 2 + 3, self.y - 33)
	elseif self.health == 10 then
		love.graphics.draw(self.healthbar_half, self.x - self.width / 2 + 3, self.y - 33)
	end
	love.graphics.setColor(1, 1, 1)
end


return Enemy