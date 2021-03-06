# Collector-Swordsman
Collector Swordsman is a little action-platformer game made with **LÖVE2D**.  
This is first finished project of two newbie programmer. We did this game as our final project for **CS50x**.  
In Collector Swordsman, there are 3 levels where you need to kill all goblins and collect all coins to move to the next level.
  
![thumbnail](https://user-images.githubusercontent.com/70853421/142256766-3e1bff43-9aaa-41c1-93e1-ee1c7f91b8fa.PNG)

## Tutorial
### Controls
- Move with W, A, S, D (You can also use arrow keys but since you have to use X to attack, it will be diffucult)
- Attack with X
- Jump with Space
- Mouse is not active in game

### Gameplay 
- Due to the goblin attack to the villages, gates to the villages are closed. You'll learn that if you have enough coin, villagers will let you in.
- You have to kill all goblins to collect all the coins in the level. There are 13 coins in every level. Some of them are placed in the level and others will drop from goblins you killed.
- Villagers at the end of every level tell you if you can move to next village according your coin amount.
- If you die, you'll spawn at the beginnig of the level you're in with zero coins and full health.

### Tips
- Try to get the best from double jump by pressing space again when you are at the highest point of your jump.
- Combat's core is about using range advantage against goblins. Try to attack when you are able to reach them but they are not.
- Attacking once, running back and attacking again or attacking once, jumping above the goblin and attacking again are the useful tactics.
- You can push stones to make your way up.

![ss1](https://user-images.githubusercontent.com/70853421/142256850-4f95dfd9-3ec7-4642-a844-993dfaf7da6b.PNG)

## Known Problems
- Sometimes game crashes if space is spammed against a goblin.
- Jump amount may vary according to your system's FPS.  
We would like know if you find new bug or problem. Also, hearing some ideas and critics about or game would be great.

## Our Approach
- We used class system thanks to Classic library to maintain organized and clean code. Each class file contains codes for particular part of the game.
- To solve a problem we faced about delta time, we used Tick library to limit the framerate. Our goal was to make game run at every frame rate in every system so players wouldn't experience different gameplays.
- We used Hump's gamestate linbrary to split game into 3 parts: menu, game, endscreen.
- We used Tiled and STI to create our tilemaps and implement them into our game.

## Used Libraries and Frameworks
- [Tiled](https://www.mapeditor.org/) (Tilemap editor)
- [STI](https://love2d.org/forums/viewtopic.php?t=76983) (Tile Implementation Library)
- [Classic](https://github.com/rxi/classic) (Class Module)
- [Hump Gamestate](https://github.com/vrld/hump) (Game state library)
- [Tick](https://github.com/bjornbytes/tick) (Fixed framerate library)

### Credits
- Programmer [Ayberk Karakaş](https://www.linkedin.com/in/ayberkkarakas/)  
- Programmer / Pixel Artist [Berfin Ceylan](https://www.linkedin.com/in/berfin-ceylan/)  
- Music [AndrewJL](https://pages.github.com/)  
- All sound effects are made with Bfxr.
- All art assets made in Aseprite.
