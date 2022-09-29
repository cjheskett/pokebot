PokéBot
=======
An automated computer program that speedruns Pokémon.

Try it out
==========
Running the PokéBot on your own machine is easy. You will need a Windows environment (it runs great in VM's on Mac too). First, clone this repository (or download and unzip it) to your computer. Install the [BizHawk 2.8](https://tasvideos.org/Bizhawk) emulator, and procure a ROM file of Pokémon Red (you should personally own the game).

Open the ROM file with BizHawk, and Pokémon Red should start up. Then, under the 'Tools' menu, select 'Lua Console'. Click the open folder button, and navigate to the PokéBot folder you downloaded. Select 'main.lua' and press open. The bot should start running!

Seeds
=====
PokéBot comes with a built-in run recording feature that takes advantage of random number seeding to reproduce runs in their entirety. Any time the bot resets or beats the game, it will log a number to the Lua console that is the seed for the run. If you set 'CUSTOM_SEED' in main.lua to that number, the bot will reproduce your run, allowing you to share your times with others. Note that making any other modifications will prevent this from working. So if you want to make changes to the bot and share your time, be sure to fork the repo and push your changes.

Credits
=======
### Developers
Kyle Coburn: Original concept, Red routing

Michael Jondahl: Combat algorithm, Java bridge for connecting the bot to Twitch chat, Livesplit, Twitter, etc

Chris Heskett: Updates for 2022 beginner route

### Special thanks
To Livesplit for providing custom component for integrating in-game time splits.

To the Pokémon speedrunning community members who inspired the idea, and shared ways to improve the bot.