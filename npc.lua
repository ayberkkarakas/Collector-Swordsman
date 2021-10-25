local Editor = Editor or require("editor")
local Npc = Object:extend()

npcs = {}

function Npc:new(name, x, y, image, scaleX)
	self.name = name
	self.text = {}
	self.x = x
	self.y = y
	self.r = 0
	self.width = 24
	self.height = 36
	self.speed = 0
	self.scaleX = scaleX
	self.physics = {}
	self.font = love.graphics.newFont("assets/alagard.ttf",10)

	self.idle_image = love.graphics.newImage(image)
	frames = {}
	frames.idle = {}
    local idle_width = self.idle_image:getWidth()
    local idle_height = self.idle_image:getHeight()
	idle_frame_width = 24
    idle_frame_height = 38
    for i=0,3 do
        table.insert(frames.idle, love.graphics.newQuad(i * idle_frame_width, 0, idle_frame_width, idle_frame_height, idle_width, idle_height))
    end

    self.current_idle_frame = 1

	table.insert(npcs, self)
end

function Npc.removeAll()
	npcs = {}
end


function Npc:update(dt)
	self.current_idle_frame = self.current_idle_frame + 3 * dt
    if self.current_idle_frame >= 4 then
        self.current_idle_frame = 1
    end
end

function Npc:draw()
	love.graphics.draw(self.idle_image, frames.idle[math.floor(self.current_idle_frame)], self.x, self.y, 0, self.scaleX, 1, idle_frame_width / 2,
	idle_frame_height / 2)
	--love.graphics.rectangle( "line", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height )

	love.graphics.setColor(1, 1, 1)
end

return Npc