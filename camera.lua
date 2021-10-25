local Camera = {
	x = 0,
	y = 0,
	scale = 2,
	shakeDuration = 0,
	shakeMagnitude = 3
}

function Camera:apply()
	love.graphics.push()
	love.graphics.scale(self.scale, self.scale)
	love.graphics.translate(-self.x, -self.y)

	if self.shakeDuration > 0 then
		local dx = love.math.random(-self.shakeMagnitude, self.shakeMagnitude)
        local dy = love.math.random(-self.shakeMagnitude, self.shakeMagnitude)
        love.graphics.translate(dx, dy)
        self.x = self.x + dx
        self.y = self.y + dy
    end
end

function Camera:clear()
	love.graphics.pop()
end

function Camera:update(dt)
	if self.shakeDuration > 0 then
    	self.shakeDuration = self.shakeDuration - dt
    end
end

function Camera:setPosition(x, y)
	self.x = x - love.graphics.getWidth() / 2 / self.scale
	self.y = y - love.graphics.getWidth() / 2 / self.scale
	local RS = self.x + love.graphics.getWidth() / 2

	if self.x < 0 then
		self.x = 0
	elseif RS > mapWidth then
		self.x = mapWidth - love.graphics.getWidth() / 2
	end
end

return Camera
