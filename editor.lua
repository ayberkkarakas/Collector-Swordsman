local Editor = {}
local Player = Player or require "player"
local Tutorial = Tutorial or require "tutorial"
local dialog = love.graphics.newImage("assets/dialog.png")

function Editor:load()
	for i, npc in ipairs(npcs) do
		if npc.name == "firstNpc" then
			npc.text[1] = "Hello, swordsman! Passages are\nclosed due to goblin attack but\nif you pay a good amount,\nI'm sure villagers will let you\npass. Don't forget to collect\ngoblins coins. Good luck!"
			npc.text[2] = "Hello again, swordsman! You\nkilled all goblins. Go and check\nif villagers will let you pass\nthrough their gates. Good luck!"
		elseif npc.name == "firstVillager" then
			npc.text[1] = "Hello, sir! I'm sorry but I can't\nlet you in. Gates are closed\nbecause of this green monsters.\nBut you seem like a good man.\nIf you have 13 coins, i can make\nan exception."
			npc.text[2] = "Oh, so you brought 13 coins.\nNice! You can pass now. I'm\nsure the other villagers will let\nyou pass for money too.\nGood luck on your adventure!"
		elseif npc.name == "secondVillager" then
			npc.text[1] = "Hi there traveller! If you are\nwilling to pass through here,\nyou have to make a small\npayment. 13 coins would work."
			npc.text[2] = "Welcome, traveller! I see\nyou collected all the coins of\nthat little idiots. I can let you\nin now. Come on in!"
		elseif npc.name == "thirdVillager" then
			npc.text[1] = "Oh, newcomer! Unfortunately,\nthis is not a good time to\nvisit the village. Gates are\nclosed due to possible goblin\nattack. Only if you can bring\nme 13 coins, I can let you pass."
			npc.text[2] = "Wow, you killed them all on\nyour own! Gates are open for\nyou now, swordsman. Thank\nyou for saving the region from\ngoblin invasion. All the people\nwill be grateful to you!"
		end
	end

	for i, tutorial in ipairs(tutorials) do
		if tutorial.name == "First" then
			tutorial.text = "Welcome to\n'Collector Swordsman'.\n\nYou can move with\narrow keys."
		elseif tutorial.name == "Second" then
			tutorial.text = "\n\nUse 'UP' arrow key\nto jump"
		elseif tutorial.name == "Third" then
			tutorial.text = "Attack goblins by\npressing 'X'. Your attack\nrange is more than them\nso try to use this in your\nadvantage."
		elseif tutorial.name == "Fourth" then
			tutorial.text = "\n\nWatch out for spikes!"
		elseif tutorial.name == "Fifth" then
			tutorial.text = "You can double jump by\npressing 'UP' arrow key\ntwo times. Don't forget\ntiming is important!"
		elseif tutorial.name == "Sixth" then
			tutorial.text = "\n\nUse stones to create new\npaths for yourself."
		end
	end
end

function Editor:draw()	
	for i, npc in ipairs(npcs) do
		if npc.dialog == true then
			love.graphics.setFont(npc.font)
			love.graphics.draw(dialog, npc.x - 75, npc.y - 120)
			love.graphics.setColor(1,1,1)
			if Player.coins >= 13 then
				love.graphics.print(""..npc.text[2], npc.x - 71, npc.y - 112)
			else 
				love.graphics.print(""..npc.text[1], npc.x - 71, npc.y - 112)
			end
		end
	end
end

return Editor