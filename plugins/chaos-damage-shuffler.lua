local plugin = {}

plugin.name = "Battletoads+ Chaos Damage Shuffler"
plugin.author = "Phiggle, Rogue_Millipede"
plugin.minversion = "2.6.3"
plugin.settings =
{
	{ name='InfiniteLives', type='boolean', label='Infinite* Lives (see notes)' },
	{ name='ClingerSpeed', type='boolean', label='BT NES: Auto-Clinger-Winger (unpatched ONLY)' },
	{ name='BTSNESRash', type='boolean', label='BT SNES: I want Rash, pick 2P, give Pimple 1 HP'},
	{ name='SuppressLog', type='boolean', label='Suppress "ROM unrecognized"/"on Level 1" logs'},
	{ name='grace', type='number', label='Grace period between swaps (minimum 10 frames)', default=10 },
}

plugin.description =
[[
	Get swapped to a different level whenever a Battletoad takes damage. Additional games shuffle on 'damage', see below. Multiplayer shuffling supported. If your ROM is not recognized, no damage swap will occur.
	
	See instructions to have multiple Battletoads games that start (or continue) at the level you specify.
	
	This is a mod of the excellent Mega Man Damage Shuffler plugin by authorblues and kalimag.
	Additional ideas from the TownEater fork have been implemented.
	Thank you to Diabetus and Smight for extensive playthroughs that tracked down bugs!
	
	Currently supports (ALL NTSC-U):
	
	BATTLETOADS BLOCK
	-Battletoads (NES), 1p or 2p - also works with the bugfix patch by Ti: https://www.romhacking.net/hacks/2528/
	-Battletoads in Battlemaniacs (SNES), 1p or 2p
	-Battletoads-Double Dragon (NES), 1p or 2p
	-Battletoads-Double Dragon (SNES), 1p or 2p, including if patched to use level select by default (see instructions)
	
	MARIO BLOCK
	-Mario Bros. (NES), 1-2p
	-Super Mario Bros. (NES), 1-2p
	-Super Mario Bros. 2 JP ("Lost Levels"), NES version, 1p
	-Super Mario Bros. 2 USA (NES), 1p
	-Super Mario Bros. 3 (NES), 1-2p (includes battle mode)
	-Somari (NES, unlicensed), 1p
	-Super Mario World (SNES), 1-2p
	-Super Mario World 2: Yoshi's Island, 1p
	-Super Mario All-Stars (SNES), 1-2p, with or without World (includes SMB3 battle mode)
	-Super Mario Land (GB or GBC DX patch), 1p
	-Super Mario Land 2: 6 Golden Coins (GB or GBC DX patch), 1p
	-Super Mario 64 (N64), 1p
	
	CASTLEVANIA BLOCK
	-Castlevania (NES), 1p
	-Castlevania II (NES), 1p
	-Castlevania III (NES, or Famicom with translation patch), 1p
	-Super Castlevania IV (SNES), 1p
	-Castlevania: Dracula X (SNES), 1p
	-Castlevania: Bloodlines (Genesis/Mega Drive), 1p
	-Castlevania: Rondo of Blood (TG16-CD), 1p
	-Castlevania: Symphony of the Night (PSX), 1p
	-Castlevania: Aria of Sorrow (GBA), 1p
	-Castlevania: Dawn of Sorrow (DS), 1p
	-Castlevania: Portrait of Ruin (DS), 1p
	-Castlevania: Order of Ecclesia (DS), 1p

	METROID BLOCK
	-Metroid (NES), 1p
	-Metroid II (GB), 1p
	-Metroid Fusion (GBA), 1p
	-Metroid Zero Mission (GBA), 1p

	ZELDA BLOCK
	-The Legend of Zelda (NES), 1p
	
	ADDITIONAL GOODIES
	-Anticipation (NES), up to 4 players, shuffles on incorrect player answers, correct CPU answers, and running out of time.
	-Bubsy in Claws Encounters of the Furred Kind (aka Bubsy 1) (SNES)
	-Captain Novolin (SNES)
	-Chip and Dale Rescue Rangers 1 (NES), 1p or 2p
	-Demon's Crest (SNES), 1p
	-F-Zero (SNES), 1p
	-Family Feud (SNES), 1p or 2p
	-Kirby's Adventure (SNES), 1p
	-Mario Paint (SNES), joystick hack, Gnat Attack, 1p
	-Monopoly (NES), 1-8p (on one controller), shuffles on any human player going bankrupt, going or failing to roll out of jail, and losing money (not when buying, trading, or setting up game)
	-Super Dodge Ball (NES), 1p or 2p, all modes
	-Super Mario Kart (SNES), 1p or 2p - shuffles on collisions with other karts (lost coins or have 0 coins), falls
	
	THE LINK/SAMUS BLOCK
	-The Legend of Zelda: A Link to the Past (SNES) - 1p, US or JP 1.0
	-Super Metroid (SNES) - 1p, US/JP version - does not shuffle on losing health from being "drained" by acid, heat, shinesparking, certain enemies
	-Super Metroid x LTTP Crossover Randomizer, aka SMZ3 (SNES)
	
	These three should work with various revisions INCLUDING RANDOMIZERS if you replace the hash in the .lua file where instructed.
	This will likely be broken out into its own plugin in the near future!
	
	
	----PREPARATION----
	-Set Min and Max Seconds VERY HIGH, assuming you don't want time swaps in addition to damage swaps.
	
	-Non-Battletoads games: just put your game in the games folder.
	
	-Battletoads games:
	-Put multiple copies of your ROM into the games folder - one for every starting level you want to include.
	-Rename those files to START with two-digit numbers, like 01, 02, 03, etc., as below.
	
	Battletoads (NES):
	-Level range: 01 to 13
	-How to level select: Automatically enabled.
	
	Battletoads in Battlemaniacs (SNES):
	-Level range: 01 to 08
	-How to level select: Pimple will start with 1 HP and no lives if you specify a level higher than 1, OR if you click the "I want Rash" option. Let Pimple die, and then continue (if using Pimple - it gets refunded) or don't (if playing 2P/using Rash). You get an on-screen reminder to do this, and it is gone when you shuffle back.
	
	Battletoads-Double Dragon (NES):
	-Level range: 01 to 14
	-How to level select: Level select screen is automatically enabled. A message on screen the first time will tell you which level to pick after character select.
	
	Battletoads-Double Dragon (SNES):
	-Level range: 01 to 14
	-How to level select: A message on screen the first time will tell you what level to pick after you choose characters. But, for now, you have to enable level select yourself :(
	--OPTION ONE: just enter the cheat code at the character select screen. The screen blinks when it's entered correctly.
	--OPTION TWO: Patch your ROM(s) with the Game Genie code DD6F-1923. Here is a patcher! https://www.romhacking.net/utilities/1054/
	

	----EXAMPLES AND TIPS----
	To shuffle every single level of Battletoads NES, make 13 copies with filenames starting with 01 through 13.
	
	You can include one copy each of all these Battletoads games, with no special naming, to simply have damage shuffling starting from level 1.
	
	If you want a Battletoads-Double Dragon run without mid-level checkpoints (1-1, 2-1, 3-1, ... 7-1), then only add files that start with: 01, 03, 06, 09, 11, 13, 14.
	
	You could do an "all Turbo Tunnels" run with BT NES = 03, BTDD (either/both) = 05, and BT SNES = 04. Throw in Surf City (BT NES 05), Volkmire's Inferno (BT NES 07), Roller Coaster (BT SNES 06), the awful spaceship levels (BTDD 09 and 10)...
	
	Mark a ROM "cleared" whenever you want! I recommend you do so after completing a level.
	
	----OPTIONS----
	
	Infinite* Lives will make it far easier to reach and defeat bosses.
	-- It's not quite infinite. Lives refill ON SWAP. On your LAST game, you're done swapping, so be careful!
	-- If you truly need infinite lives on your last game, consider applying cheats in Bizhawk, or re-add a game to get a lives refill.
	-- Infinite* lives do not activate for the second player on NES Clinger-Winger on an unpatched ROM, since they can't move. Use the patch if you want 2P Clinger-Winger for some reason!
	-- Several games do not have 'lives' to make infinite, such as Anticipation, Super Metroid, Link to the Past, Super Dodge Ball, original Mario Bros. Nothing will change in these games with this option.
	
	Auto-Clinger-Winger NES: You can enable max speed and auto-clear the maze (level 11).
	-- You MUST use an unpatched ROM. The second player will not be able to move, so only Rash can get to the boss in 2p. Infinite Lives are disabled in this scenario.
	-- You still have to beat the boss. If you use Infinite* Lives, this could make Clinger-Winger fairly trivial.
	
	Rash 1-player mode in Battlemaniacs (SNES): see above! Start in 2p, let Pimple die to deathwarp, and make sure your 2p controller is mapped the same as 1p aside from Start.
	
	Suppress Logs: if you do not want the lua console log to tell you about file naming errors, or unrecognized ROMs. This can help keep the log cleaner if you are also using the Mega Man Damage Shuffler or other plugins!
	
	Grace period: 10 frames is the default minimum frames between swaps. Adjust up as needed. This idea originated in the TownEater fork of the damage shuffler!
	
	Enjoy? Send bug reports?
	
]]

local NO_MATCH = 'NONE'

local tags = {}
local prevdata
local swap_scheduled
local shouldSwap

if checkversion("2.6.2") then
	prevdata = {}
	swap_scheduled = false
	shouldSwap = function()
		return false
	end
end

bt_nes_level_names = { "Ragnarok's Canyon",
	"Wookie Hole",
	"Turbo Tunnel",
	"Arctic Caverns",
	"Surf City",
	"Karnath's Lair",
	"Volkmire's Inferno",
	"Intruder Excluder",
	"Terra Tubes",
	"Rat Race",
	"Clinger-Winger",
	"The Revolution",
	"Armageddon"}

btdd_level_names = { "1-1", "1-2", "2-1", "2-2", "2-3", "3-1", "3-2", "3-3", "4-1", "4-2", "5-1", "5-2", "6-1", "7-1"}

bt_snes_level_names = { "Khaos Mountains",
	"Hollow Tree",
	"Bonus Stage 1",
	"Turbo Tunnel Rematch",
	"Karnath's Revenge",
	"Roller Coaster",
	"Bonus Stage 2",
	"Dark Tower"}

bt_snes_level_recoder = { 0, 1, 2, 3, 4, 6, 8, 7 } -- THIS GAME DOESN'T STORE LEVELS IN THE ORDER YOU PLAY THEM, COOL
---------------

-- update value in prevdata and return whether the value has changed, new value, and old value
-- value is only considered changed if it wasn't nil before
local function update_prev(key, value)
	local prev_value = prevdata[key]
	prevdata[key] = value
	local changed = prev_value ~= nil and value ~= prev_value
	return changed, value, prev_value
end

local function sml1_swap(gamemeta)
	return function()
		local size_changed, shrinking, prev_shrinking = update_prev('shrinking', gamemeta.getsmlsize())
		-- when this variable is 3, Mario is shrinking
		local lives_changed, lives, prev_lives = update_prev('lives', gamemeta.getlives())
		-- usual lives counter idea
		local game_over_changed, game_over_bar, prev_game_over_bar = update_prev('game_over_bar', gamemeta.getgameover() ~= 57)
		-- this variable goes to 57 to show the GAME OVER bar
		return
			(size_changed and shrinking == 3) or
			(lives_changed and lives < prev_lives) or
			(game_over_changed and game_over_bar)
	end
end

local function somari_swap(gamemeta)
	return function()
		local sprite_changed, sprite, prev_sprite = update_prev('sprite', gamemeta.getsprite())
		local shield_changed, shield, prev_shield = update_prev('shield', gamemeta.getshield())
		return
			(sprite_changed and sprite == 10 and shield_changed == false) or -- when this variable is 9, Somari hurt sprite is on
			(sprite_changed and prev_sprite == 09) -- we just transitioned from the "you died" sprite
	end
end

local function demonscrest_swap(gamemeta)
	return function()
		local hp_changed, hp, prev_hp = update_prev('hp', gamemeta.p1gethp())
		local living_changed, living, prev_living = update_prev('living', gamemeta.p1getliving())
		local scene_changed, scene, prev_scene = update_prev('scene', gamemeta.p1getscene())
		return
			((hp_changed and hp < prev_hp and living == 1) or -- Firebrand just took damage
			(living_changed and living == 45 and prev_living == 1 and hp == 0)) -- Firebrand just died
			and
			scene ~= 37 -- 37 is the start of the credits for the Good and True endings, and HP drops to 2 there for some reason.
	end
end

local function FamilyFeud_SNES_swap(gamemeta)
	return function()
		local strike_changed, strike, prev_strike = update_prev('strike', gamemeta.getstrike())
		local player_changed, player, prev_player = update_prev('player', gamemeta.getwhichplayer())
		return
			(strike_changed and strike == 1) and  -- we just got a strike or 0
			(player < 2) -- It's player 1 or 2, not the CPU
	end
end

-- This is the generic_swap from the Mega Man Damage Shuffler, modded to cover 2 potential players.
-- You can play as Rash, Zitz, or both in Battletoads NES, so the shuffler needs to monitor both toads.
-- They have the same max HP.
-- In BT NES, this should only swap when a "box" of health is taken away. That is taken care of by the ceil function.
-- In BT SNES, damage should register even if a pip of health is not eliminated by an attack there.
local function battletoads_swap(gamemeta)
	return function(data)
		local tag = get_game_tag()

		local p1currhp = gamemeta.p1gethp()
		local p1currlc = gamemeta.p1getlc()
		local p1currcont = gamemeta.p1getcont()
		local p1currsprite = gamemeta.p1getsprite()
		local p2currhp = gamemeta.p2gethp()
		local p2currlc = gamemeta.p2getlc()
		local p2currcont = gamemeta.p2getcont()
		local p2currsprite = gamemeta.p2getsprite()
		
		-- togglechecks handle when health/lives drop because of a sudden change in game mode (like a level change)
		currtogglecheck = false
		if gamemeta.gettogglecheck ~= nil then
			currtogglecheck = gamemeta.gettogglecheck()
		end

		local maxhp = gamemeta.maxhp()
		local minhp = gamemeta.minhp or 0

		-- health must be within an acceptable range to count
		-- ON ACCOUNT OF ALL THE GARBAGE VALUES BEING STORED IN THESE ADDRESSES
		if p1currhp < minhp or p1currhp > maxhp then
			return false
		elseif p2currhp < minhp or p2currhp > maxhp then
			return false
		end
		
		-- retrieve previous health and lives before backup
		local p1prevhp = data.p1prevhp
		local p1prevlc = data.p1prevlc
		local p1prevcont = data.p1prevcont
		local p1prevsprite = data.p1prevsprite
		local p2prevhp = data.p2prevhp
		local p2prevlc = data.p2prevlc
		local p2prevsprite = data.p2prevsprite
		local prevtogglecheck = data.prevtogglecheck

		data.p1prevhp = p1currhp
		data.p1prevlc = p1currlc
		data.p1prevcont = p1currcont
		data.p1prevsprite = p1currsprite
		data.p2prevhp = p2currhp
		data.p2prevlc = p2currlc
		data.p2prevcont = p2currcont
		data.p2prevsprite = p2currsprite
		data.prevtogglecheck = currtogglecheck
		
		
		-- if we have found a toggle flag, that changes at the same time as a junk hp/lives change, then don't swap.
		if prevtogglecheck ~= nil and prevtogglecheck ~= currtogglecheck then
			return false
		end
		
		-- BT SNES likes to do a full 0-out of some memory values when you load a level.
		-- That should NOT shuffle!
		-- Return false if that is happening.
		
		if tag == "BT_SNES" and
			p1currhp == 0 and p2currhp == 0 and -- values dropped to 0
			p1currsprite == 0 and p2currsprite == 0 -- if both are 0, neither player is even on screen
		then
			return false
		end

		-- this delay ensures that when the game ticks away health for the end of a level,
		-- we can catch its purpose and hopefully not swap, since this isnt damage related
		if data.p1hpcountdown ~= nil and data.p1hpcountdown > 0 then
			data.p1hpcountdown = data.p1hpcountdown - 1
			if data.p1hpcountdown == 0 and p1currhp > minhp then
				return true
			end
		end
		
		if data.p2hpcountdown ~= nil and data.p2hpcountdown > 0 then
			data.p2hpcountdown = data.p2hpcountdown - 1
			if data.p2hpcountdown == 0 and p2currhp > minhp then
				return true
			end
		end

		-- if the health goes to 0, we will rely on the life count to tell us whether to swap
		if p1prevhp ~= nil and p1currhp < p1prevhp then
			data.p1hpcountdown = gamemeta.delay or 3
		elseif p2prevhp ~= nil and p2currhp < p2prevhp then
			data.p2hpcountdown = gamemeta.delay or 3
		end
		
		-- check to see if the life count went down
		
		-- In Battletoads NES, when you're in 1P mode, the other toad's life counter is set to 255. When they join, lives are set to 0.
		-- Thus, we ignore lives transitions from 255, to prevent unnecessary swaps when a toad "joins"
		-- Similarly, some garbage values above 255 exist for BTDD SNES, and swaps occur when 2p is dropped to 0 HP/lives in 1p mode.
		
		-- TODO: maxlc, like maxhp?
		
		if p1prevlc ~= nil and p1currlc == (p1prevlc - 1) and p1prevlc < 255 then
			return true
		elseif p2prevlc ~= nil and p2currlc == (p2prevlc - 1) and p2prevlc < 255 then
			return true
		end
		
		-- In Battletoads SNES bonus levels, your pins/domino count can go down without your health going down.
		-- BUT NO, WE NEED TO SHUFFLE ON THOSE!!
		-- but not once you're dead. That countdown shouldn't count.
		-- I CANNOT IMAGINE WHY, but this does not count up in a linear fashion.
		
		-- To simplify things, we will just swap when the "I've been hit" sprite is called.
		
		if tag == "BT_SNES" then
			if memory.read_u8(0x00002C, "WRAM") == 2 or memory.read_u8(0x00002C, "WRAM") == 8 then
				-- we are in the proper level, 2 (Pins) or 8 (Dominoes)
				if p1prevsprite ~= p1currsprite and p1currsprite == 128 then
					-- p1 was JUST hit (prior value was not the same)
					return true
				elseif p2prevsprite ~= p2currsprite and p2currsprite == 236 then
					-- p1 was JUST hit (prior value was not the same)
					return true
				end
			end
		end
		
		-- In Battletoads NES, we want to swap on a continue.
		-- In Battletoads NES, you use a continue joining the game, so we should not swap when using the first continue (when continues = 3).
		
		if tag == "BT_NES" or tag == "BT_NES_patched" then
			if p1prevcont ~= nil and p1prevcont < 3 and p1currcont < p1prevcont then
				return true
			elseif p2prevcont ~= nil and p2prevcont < 3 and p2currcont < p2prevcont then
				return true
			end
		end
		
		-- might be wise to separate NES and SNES functions in future release

		return false
	end
end

local function singleplayer_withlives_swap(gamemeta)
	return function(data)
		-- if a method is provided and we are not in normal gameplay, don't ever swap
		if gamemeta.gmode and not gamemeta.gmode() then
			return false
		end
		
		local p1currhp = gamemeta.p1gethp()
		local p1currlc = gamemeta.p1getlc()
		local currtogglecheck = 0
		if gamemeta.gettogglecheck ~= nil then
			currtogglecheck = gamemeta.gettogglecheck()
		end
		
		local maxhp = gamemeta.maxhp()
		local minhp = gamemeta.minhp or 0

		-- health must be within an acceptable range to count
		-- ON ACCOUNT OF ALL THE GARBAGE VALUES BEING STORED IN THESE ADDRESSES
		if p1currhp < minhp or p1currhp > maxhp then
			return false
		end

		-- retrieve previous health and lives before backup
		local p1prevhp = data.p1prevhp
		local p1prevlc = data.p1prevlc
		local prevtogglecheck = data.prevtogglecheck

		data.p1prevhp = p1currhp
		data.p1prevlc = p1currlc
		data.prevtogglecheck = currtogglecheck
		
		-- if we have found a toggle flag, that changes at the same time as a junk hp/lives change, then don't swap.
		if prevtogglecheck ~= nil and prevtogglecheck ~= currtogglecheck then
			return false
		end
		
		-- this delay ensures that when the game ticks away health for the end of a level,
		-- we can catch its purpose and hopefully not swap, since this isnt damage related
		if data.p1hpcountdown ~= nil and data.p1hpcountdown > 0 then
			data.p1hpcountdown = data.p1hpcountdown - 1
			if data.p1hpcountdown == 0 and p1currhp > minhp then
				return true
			end
		end
		
		-- if the health goes to 0, we will rely on the life count to tell us whether to swap
		if p1prevhp ~= nil and p1currhp < p1prevhp then
			data.p1hpcountdown = gamemeta.delay or 3
		end

		-- check to see if the life count went down
		
		if p1prevlc ~= nil and p1currlc == p1prevlc - 1 then
			-- MUST CHECK THAT LIVES ALWAYS GO DOWN BY 1. BUT THIS SHOULD HELP REMOVE NONSENSE SWAPS
			return true
		end

		return false
	end
end

local function supermetroid_swap(gamemeta)
	return function()
		local hp_changed, currhp, prev_hp = update_prev('hp', gamemeta.gethp())

		local invuln_changed, invuln, prev_invuln = update_prev('invuln', gamemeta.getinvuln())
		-- when this variable is over 0, i-frames are on

		local samusstate_changed, samusstate, prevsamusstate = update_prev('samusstate', gamemeta.getsamusstate())
		-- this variable covers Samus states like saving, dying, normal gameplay, etc.

		return
			(invuln_changed and prev_invuln == 0 and currhp > 0 and hp_changed)
			-- i-frames just started, and we lost health on getting bumped (so, not for steam)
			or (samusstate_changed and samusstate == 25)
			-- Samus death animation just ended
	end
end

local function SMZ3_swap(gamemeta)
	return function(data)
		-- if a method is provided and we are not in normal gameplay, don't ever swap
		if gamemeta.gmode and not gamemeta.gmode() then
			return false
		end
		
		local currlinkhp = gamemeta.getlinkhp()
		local currlinklc = gamemeta.getlinklc()
		local currwhichgame = gamemeta.getwhichgame()

		local samushp_changed, currsamushp, samusprev_hp = update_prev('samushp', gamemeta.getsamushp())

		local invuln_changed, invuln, prev_invuln = update_prev('invuln', gamemeta.getinvuln())
		-- when this variable is over 0, i-frames are on

		local samusstate_changed, samusstate, prevsamusstate = update_prev('samusstate', gamemeta.getsamusstate())
		-- this variable covers Samus states like saving, dying, normal gameplay, etc.	
		
		local maxhp = gamemeta.maxhp()
		local minhp = gamemeta.minhp or 0
		
		-- Samus swaps
		if currwhichgame == 255 and
			((invuln_changed and prev_invuln == 0 and currsamushp > 0 and samushp_changed)
			-- i-frames just started and lost health
			or (samusstate_changed and samusstate == 25))
			-- Samus death animation just ended
		then
			return true
		end

		-- other swaps are geared toward LTTP specifically

		-- health must be within an acceptable range to count
		-- ON ACCOUNT OF ALL THE GARBAGE VALUES BEING STORED IN THESE ADDRESSES
		if currwhichgame == 0 and (currlinkhp < minhp or currlinkhp > maxhp) then
			return false
		end

		-- retrieve previous health and lives before backup
		local prevlinkhp = data.prevlinkhp
		local prevlinklc = data.prevlinklc
		local prevwhichgame = data.prevwhichgame
		
		data.prevlinkhp = currlinkhp
		data.prevlinklc = currlinklc
		data.prevwhichgame = currwhichgame

		-- DO NOT SWAP ON GAME CHANGE
		if prevwhichgame ~= nil and prevwhichgame ~= currwhichgame then
			return false
		end

		-- this delay ensures that when the game ticks away health for the end of a level,
		-- we can catch its purpose and hopefully not swap, since this isnt damage related
		if currwhichgame == 0 then
			if data.p1hpcountdown ~= nil and data.p1hpcountdown > 0 then
				data.p1hpcountdown = data.p1hpcountdown - 1
				if data.p1hpcountdown == 0 and currlinkhp > minhp then
					return true
				end
			end
			
			-- if the health goes to 0, we will rely on the life count to tell us whether to swap
			if prevlinkhp ~= nil and currlinkhp < prevlinkhp then
				data.p1hpcountdown = gamemeta.delay or 3
			end

			-- check to see if the life count went down
			
			if prevlinklc ~= nil and currlinklc < prevlinklc then
				return true
			end

		end
		
		return false
	end
end

local function twoplayers_withlives_swap(gamemeta)
	return function(data)
		-- if a method is provided and we are not in normal gameplay, don't ever swap
		if gamemeta.gmode and not gamemeta.gmode() then
			return false
		end

		local p1currhp = gamemeta.p1gethp()
		local p1currlc = gamemeta.p1getlc()
		local p2currhp = gamemeta.p2gethp()
		local p2currlc = gamemeta.p2getlc()
		local currtogglecheck = 0
		if gamemeta.gettogglecheck ~= nil then
			currtogglecheck = gamemeta.gettogglecheck()
		end
		
		-- we should now be able to use the typical shuffler functions normally.

		local maxhp = gamemeta.maxhp()
		local minhp = gamemeta.minhp or 0

		-- health must be within an acceptable range to count
		-- ON ACCOUNT OF ALL THE GARBAGE VALUES BEING STORED IN THESE ADDRESSES
		if p1currhp < minhp or p1currhp > maxhp then
			return false
		elseif p2currhp < minhp or p2currhp > maxhp then
			return false
		end

		-- retrieve previous health and lives before backup
		local p1prevhp = data.p1prevhp
		local p1prevlc = data.p1prevlc
		local p2prevhp = data.p2prevhp
		local p2prevlc = data.p2prevlc
		local prevtogglecheck = data.prevtogglecheck

		data.p1prevhp = p1currhp
		data.p1prevlc = p1currlc
		data.p2prevhp = p2currhp
		data.p2prevlc = p2currlc
		data.prevtogglecheck = currtogglecheck
		
		
		-- if we have found a toggle flag, that changes at the same time as a junk hp/lives change, then don't swap.
		if prevtogglecheck ~= nil and prevtogglecheck ~= currtogglecheck then
			return false
		end

		-- this delay ensures that when the game ticks away health for the end of a level,
		-- we can catch its purpose and hopefully not swap, since this isnt damage related
		if data.p1hpcountdown ~= nil and data.p1hpcountdown > 0 then
			data.p1hpcountdown = data.p1hpcountdown - 1
			if data.p1hpcountdown == 0 and p1currhp > minhp then
				return true
			end
		end

		if data.p2hpcountdown ~= nil and data.p2hpcountdown > 0 then
			data.p2hpcountdown = data.p2hpcountdown - 1
			if data.p2hpcountdown == 0 and p2currhp > minhp then
				return true
			end
		end

		-- if the health goes to 0, we will rely on the life count to tell us whether to swap
		if p1prevhp ~= nil and p1currhp < p1prevhp then
			data.p1hpcountdown = gamemeta.delay or 3
		end
		
		if p2prevhp ~= nil and p2currhp < p2prevhp then
			data.p2hpcountdown = gamemeta.delay or 3
		end

		-- check to see if the life count went down
		
		if p1prevlc ~= nil and p1currlc == p1prevlc - 1 then
			return true
		end
		
		if p2prevlc ~= nil and p2currlc == p2prevlc - 1 then
			return true
		end

		return false
	end
end

local function SMAS_swap(gamemeta)
	return function(data)
		-- if a method is provided and we are not in normal gameplay, don't ever swap
		if gamemeta.gmode and not gamemeta.gmode() then
			return false
		end
		
		if gamemeta.getsmb3skip and gamemeta.getsmb3skip() == true then
			return false
		end

		local p1currhp = gamemeta.p1gethp()
		local p1currlc = gamemeta.p1getlc()
		local p2currhp = gamemeta.p2gethp()
		local p2currlc = gamemeta.p2getlc()
		local currsmb2mode = gamemeta.getsmb2mode()
		local currtogglecheck = 0
		if gamemeta.gettogglecheck ~= nil then
			currtogglecheck = gamemeta.gettogglecheck()
		end
		
		-- we should now be able to use the typical shuffler functions normally.

		local maxhp = gamemeta.maxhp()
		local minhp = gamemeta.minhp or 0

		-- health must be within an acceptable range to count
		-- ON ACCOUNT OF ALL THE GARBAGE VALUES BEING STORED IN THESE ADDRESSES
		if p1currhp < minhp or p1currhp > maxhp then
			return false
		elseif p2currhp < minhp or p2currhp > maxhp then
			return false
		end

		-- retrieve previous health and lives before backup
		local p1prevhp = data.p1prevhp
		local p1prevlc = data.p1prevlc
		local p2prevhp = data.p2prevhp
		local p2prevlc = data.p2prevlc
		local prevsmb2mode = data.prevsmb2mode
		local prevtogglecheck = data.prevtogglecheck
		
		data.p1prevhp = p1currhp
		data.p1prevlc = p1currlc
		data.p2prevhp = p2currhp
		data.p2prevlc = p2currlc
		data.prevsmb2mode = currsmb2mode
		data.prevtogglecheck = currtogglecheck
		
		-- DON'T SWAP WHEN WE JUST CAME OUT OF SMB2 SLOTS OR MENU
		if currsmb2mode ~= prevsmb2mode then
			return false
		end
		
		--if we have found a toggle flag, that changes at the same time as a junk hp/lives change, then don't swap.
		if prevtogglecheck ~= nil and prevtogglecheck ~= currtogglecheck then
			return false
		end

		-- this delay ensures that when the game ticks away health for the end of a level,
		-- we can catch its purpose and hopefully not swap, since this isnt damage related
		if data.p1hpcountdown ~= nil and data.p1hpcountdown > 0 then
			data.p1hpcountdown = data.p1hpcountdown - 1
			if data.p1hpcountdown == 0 and p1currhp > minhp then
				return true
			end
		end

		if data.p2hpcountdown ~= nil and data.p2hpcountdown > 0 then
			data.p2hpcountdown = data.p2hpcountdown - 1
			if data.p2hpcountdown == 0 and p2currhp > minhp then
				return true
			end
		end

		-- if the health goes to 0, we will rely on the life count to tell us whether to swap
		if p1prevhp ~= nil and p1currhp < p1prevhp then
			data.p1hpcountdown = gamemeta.delay or 3
		end
		
		if p2prevhp ~= nil and p2currhp < p2prevhp then
			data.p2hpcountdown = gamemeta.delay or 3
		end

		-- check to see if the life count went down
		
		if p1prevlc ~= nil and p1currlc == p1prevlc - 1 then
			return true
		end
		
		if p2prevlc ~= nil and p2currlc == p2prevlc - 1 then
			return true
		end

		return false
	end
end

local function sdbnes_swap(gamemeta)
	return function(data)
		-- if a method is provided and we are not in normal gameplay, don't ever swap
		if gamemeta.gmode and not gamemeta.gmode() then
			return false
		end

		local currhowmanyplayers = gamemeta.gethowmanyplayers()
		local currmode = gamemeta.getmode()
		local p1currhp1 = gamemeta.p1gethp1()
		local p1currhp2 = gamemeta.p1gethp2()
		local p1currhp3 = gamemeta.p1gethp3()
		local p2currhp1 = gamemeta.p2gethp1()
		local p2currhp2 = gamemeta.p2gethp2()
		local p2currhp3 = gamemeta.p2gethp3()
		local p1currbbplayer = gamemeta.p1getbbplayer()
		local p2currbbplayer = gamemeta.p2getbbplayer()
		
		local maxhp = gamemeta.maxhp()
		local minhp = gamemeta.minhp or 0
		
		-- health must be within an acceptable range to count
		-- ON ACCOUNT OF ALL THE GARBAGE VALUES BEING STORED IN THESE ADDRESSES
		
		-- NOTE: IN SDB, ONLY p1currhp1 and p1currbbplayer seem to inherit garbage values
		
		if p1currhp1 < minhp or (p1currhp1 > maxhp and currmode < 2) then
			return false
		elseif p1currbbplayer > 33 and currmode == 2 then
			-- highest value for this is 33
			return false
		end
		
		local p1currhp = p1currhp1 + p1currhp2 + p1currhp3 -- team 1
		local p2currhp = p2currhp1 + p2currhp2 + p2currhp3 -- team 2
		
		-- consider transforming the player to 1-6 to make this easy to look up.
		
		local beanballplayerhps = {
		memory.read_u8(0x0323, "RAM"),
		memory.read_u8(0x0393, "RAM"),
		memory.read_u8(0x0403, "RAM"),
		memory.read_u8(0x035B, "RAM"),
		memory.read_u8(0x03CB, "RAM"),
		memory.read_u8(0x043B, "RAM"),
		}
		
		-- 0 for 1, 16 for 2, 32 for 3, 1 for 4, 17 for 5, 33 for 6
		local p1currhpbb= beanballplayerhps[p1currbbplayer]
		local p2currhpbb= beanballplayerhps[p2currbbplayer]
		-- sub in the bb healths if we are in bb
		
		if currmode == 2 then
			p1currhp = p1currhpbb
			if currhowmanyplayers == 2 then
				p2currhp = p2currhpbb
			else
				p2currhp = 0
			end
		end

		-- retrieve previous health and mode/player info from before backup
		
		local prevhowmanyplayers = data.prevhowmanyplayers
		local prevmode = data.prevmode
		local p1prevhp = data.p1prevhp
		local p2prevhp = data.p2prevhp
		local p1prevbbplayer = data.p1prevbbplayer
		local p2prevbbplayer = data.p2prevbbplayer

		data.prevhowmanyplayers = currhowmanyplayers
		data.prevmode = currmode
		data.p1prevhp = p1currhp
		data.p2prevhp = p2currhp
		data.p1prevbbplayer = p1currbbplayer
		data.p2prevbbplayer = p2currbbplayer

		-- this delay ensures that when the game ticks away health for the end of a level,
		-- we can catch its purpose and hopefully not swap, since this isnt damage related
		if data.p1hpcountdown ~= nil and data.p1hpcountdown > 0 then
			data.p1hpcountdown = data.p1hpcountdown - 1
			if data.p1hpcountdown == 0 and p1currhp > minhp then
				return true
			end
		end

		if data.p2hpcountdown ~= nil and data.p2hpcountdown > 0 then
			data.p2hpcountdown = data.p2hpcountdown - 1
			if data.p2hpcountdown == 0 and p2currhp > minhp and currhowmanyplayers == 2
			then
				return true
			end
		end

		-- if the health goes to 0, we will rely on the life count to tell us whether to swap
		if p1prevhp ~= nil and p1currhp ~= nil and p1currhp < p1prevhp then
			data.p1hpcountdown = gamemeta.delay or 3
		end
		
		if p2prevhp ~= nil and p2currhp ~= nil and p2currhp < p2prevhp and currhowmanyplayers == 2
		then
			data.p2hpcountdown = gamemeta.delay or 3
		end

		return false
	end
end

local function antic_swap(gamemeta)
	return function(data)
		-- We will swap on 3 scenarios. They work across all players.
		-- 1. There is a specific address that goes to 192 when a human player gets a letter wrong,
		-- then ticks down frame by frame to 0 or 16. Never moves up otherwise.
		-- 2. There is an address that counts down the die from 6 to 0.
		-- When you run out of time, this value hits 0, and you should swap.
		-- 3. There is an address that counts down the time to type in a guess.
		-- A CPU player will always provide a correct answer when this activates.
		-- However, when a human player runs out of time, this hits 0, then goes to 255.
		-- This should swap on 255, IGNORING the title screen.
		-- THESE VARIABLES ARE SHARED IN MULTIPLAYER YAY
		
		-- 4. We can now swap on a correct computer answer.
		-- Found value that is "who buzzed in"
		-- Found value for "faded out with correct answer," rolls up from 0 to 31
		-- if the computer rang in, and that value increases to 31, SWAP
		
		-- human player value 00AC can be 1, 2, 3, 4
		
		-- when who buzzed in > than 00AC, then we should swap if they get it right

		local _, currbotchedletter, prevbotchedletter = update_prev('botched_letter', gamemeta.getbotchedletter())
		local _, currbuzzintime, prevbuzzintime = update_prev('buzz_in_time', gamemeta.getbuzzintime())
		local _, currtypetime, prevtypetime = update_prev('type_time', gamemeta.gettypetime())
		local _, curranswerright, prevanswerright = update_prev('answer_right', gamemeta.getanswerright())

		-- wrong letter
		if prevbotchedletter ~= nil and currbotchedletter > prevbotchedletter then
			-- remember, only goes up when a wrong answer is guessed.
			return true
		end
		
		-- ran out of time to buzz in (ranges from 0-6, resets to 6 once the die appears, shuffle on drop to 0)
		if memory.read_u8(0x046E, "RAM") <= -- who rang in, defaults to 0
			memory.read_u8(0x00AC, "RAM") -- how many humans, defaults to 1 - so, not a computer player being award spaces
			and prevbuzzintime ~= nil and prevbuzzintime ~= 255
			and currbuzzintime < prevbuzzintime -- it'll stay on 0 for a while.
			and currbuzzintime == 0
		then
			-- NOTE: will reset to 0 also when all human players are out of guesses and no one else can answer.
			-- We don't want a second swap in those cases.
			-- In this case, currbotchedletter will == 0 or 16, and guess time will be < 25.
			if currtypetime < 25 and (currbotchedletter == 0 or currbotchedletter == 16) then
				return false
			end
			
			return true
		end
		
		-- ran out of time to type answer (ranges from 0-25, goes to 255 when timer is completely done)
		if prevtypetime ~= nil and prevtypetime == 0 and currtypetime == 255 then
			-- it'll stay on 255 for a while.
			return true
		end
		
		-- CPU correct answer swap
		if memory.read_u8(0x046E, "RAM") > -- who rang in, defaults to 0
			memory.read_u8(0x00AC, "RAM") -- how many humans, defaults to 1
			and prevanswerright ~= nil
			and curranswerright > prevanswerright -- this value rolls up when a card is awarded
			and curranswerright == 31 -- and hits 31 at max
		then
			return true -- swap!
		end

		return false
	end
end

local function smb3_swap(gamemeta)
	return function()
		-- if this address goes up from 0, invuln frames just got triggered.
		local invuln_changed, invuln_curr, invuln_prev = update_prev('invuln_curr', gamemeta.getinvuln())
		local boot_changed, boot = update_prev('boot', gamemeta.getboot()) -- Kuribo's shoe status
		local statue_changed, statue = update_prev('statue', gamemeta.getstatue()) -- tanooki statue status
		
		local p1_lives_changed, p1_lives_curr, p1_lives_prev = update_prev('p1_lives_curr', gamemeta.p1getlc())
		local p2_lives_changed, p2_lives_curr, p2_lives_prev = update_prev('p2_lives_curr', gamemeta.p2getlc())
			
		-- this will return whether we are in the 2p card battle (true/false)
		local smb3battling_changed, smb3battling_curr, smb3battling_prev = update_prev('smb3battling_curr', gamemeta.getsmb3battling())
			
		return (smb3battling_changed -- mode changed to/from active gameplay
				and smb3battling_prev == true) -- we were just in battle mode)
			or (invuln_changed and invuln_prev == 0 and not boot_changed and statue == 0)
			-- boot_changed if we dropped out of boot status, statue > 0 if statue timer counting down
			or (p1_lives_changed and p1_lives_curr < p1_lives_prev)
			or (p2_lives_changed and p2_lives_curr < p2_lives_prev)
	end
end

local function smk_swap(gamemeta)
	return function()
		local p1bumping, p1currbump, p1prevbump = update_prev('p1currbump', gamemeta.p1getbump())
		-- if > 0, p1 is colliding with something
		local p1coinschanged, p1currcoins, p1prevcoins = update_prev('p1currcoins', gamemeta.p1getcoins())
		-- coin count p1 - if goes down on bump, we'll swap (NOT ON LAKITU FEE)
		local p1spinningout, p1currspinout, p1prevspinout = update_prev('p1currspinout',
			-- if we start spinning out after a collision, swap (NOT ON BAD DRIFT)
			(gamemeta.p1getspinout() == 12 or -- crash
			gamemeta.p1getspinout() == 14 or -- spin out left
			gamemeta.p1getspinout() == 16 or -- spin out right
			gamemeta.p1getspinout() == 26)) -- also crash
		local p1falling, p1currfall, p1prevfall = update_prev('p1currfall', gamemeta.p1getfall() > 2)
		-- >2 means you fell, 4 for pit, 6 for lava, 8 for water
		local p1shrinking, p1currshrink, p1prevshrink = update_prev('p1currshrink', gamemeta.p1getshrink())
		-- if > 0, you are shrinking, then it counts down to 0
		local p1moled, p1currmoled, p1prevmoled = update_prev('p1currmoled', gamemeta.p1getmoled() >= 152)
		-- if >= 152, a mole just hopped on you, when off it drops to 24, then 0
		
		local p2bumping, p2currbump, p2prevbump = update_prev('p2currbump', gamemeta.p2getbump())
		-- if > 0, p2 is colliding with something
		local p2coinschanged, p2currcoins, p2prevcoins = update_prev('p2currcoins', gamemeta.p2getcoins())
		-- coin count p2 - if goes down on bump, we'll swap (NOT ON LAKITU FEE)
		local p2spinningout, p2currspinout, p2prevspinout = update_prev('p2currspinout',
			-- if we start spinning out after a collision, swap (NOT ON BAD DRIFT)
			(gamemeta.p2getspinout() == 12 or -- crash
			gamemeta.p2getspinout() == 14 or -- spin out left
			gamemeta.p2getspinout() == 16 or -- spin out right
			gamemeta.p2getspinout() == 26)) -- also crash
		local p2falling, p2currfall, p2prevfall = update_prev('p2currfall', gamemeta.p2getfall() > 2)
		-- >2 means you fell, 4 for pit, 6 for lava, 8 for water
		local p2shrinking, p2currshrink, p2prevshrink = update_prev('p2currshrink', gamemeta.p2getshrink())
		-- if > 0, you are shrinking, then it counts down to 0
		local p2moled, p2currmoled, p2prevmoled = update_prev('p2currmoled', gamemeta.p2getmoled() >= 152)
		-- if >= 152, a mole just hopped on you, when off it drops to 24, then 0
		
		local p2IsActive = gamemeta.p2getIsActive()
		-- 2p variables still get updated even if 2p is CPU, so we have to ignore all of those unless we are in 2p mode.
		
		return
			(p1falling and p1currfall) -- p1 just started falling into pit, lava, water
			-- or (p1shrinking and p1prevshrink == 0) -- p1 just started shrinking, or got run over so frame timer dropped more than 1 unit
			or (p1moled and p1currmoled) -- p1 just started shrinking
			or (p1bumping and -- p1 just started colliding AND EITHER
				((p1coinschanged and p1currcoins < p1prevcoins) -- coins dropped or
				or (p1currcoins == 0 and p1spinningout)) -- no coins and we just started spinning out
				or p1prevbump == 0 and p1currbump > 200) -- bump value goes this high when squished
			or
			p2IsActive == true and (
			(p2falling and p2currfall) -- p2 just started falling into pit, lava, water
			-- or (p2shrinking and p2prevshrink == 0) -- p2 just started shrinking, or got run over so frame timer dropped more than 1 unit
			or (p2moled and p2currmoled) -- p2 just started shrinking
			or (p2bumping and -- p2 just started colliding AND EITHER
				((p2coinschanged and p2currcoins < p2prevcoins) -- coins dropped or
				or (p2currcoins == 0 and p2spinningout)) -- no coins and we just started spinning out
				or p2prevbump == 0 and p2currbump > 200) -- bump value goes this high when squished
			)
	end
end

local function fzero_snes_swap(gamemeta)
	-- alternative option for F-Zero swapping, currently testing this out
	-- 0x00F5 is "collided with a wall", pops up to 9 then drops by 1 every frame back down to 0.
	-- We don't want a swap on just being "in" the wall or grazing it, necessarily.
	-- 0x00E9 is "hitting a guardrail" and is separate from colliding with the wall.
	-- So, you can say "no swaps" on hitting a guardrail == true when colliding with wall == false.
	-- can experiment with "invuln frames just popped from 0" AND either wall bump or other bump?
	return function()
		if 	memory.read_u8(0x0054, "WRAM") == 2 -- gamestate = "racing," and
			and memory.read_u8(0x0055, "WRAM") == 3 -- the race has started, and
			and memory.read_u8(0x00C8, "WRAM") == 0 -- invulnerability frames are done (0)
		then
			return false -- don't swap when all of those are true	
		end
		
		local hitwall_changed, hittingwall, prev_hittingwall = update_prev('hittingwall', gamemeta.gethittingwall())
		-- when this variable pops up from 0, you're hitting a wall.
		local invuln_changed, invuln, prev_invuln = update_prev('invuln', gamemeta.getinvuln())
		-- this pops up from 0 if you get i-frames, only goes up slightly for being in a wall
		local bump_changed, bump, prev_bump = update_prev('bump', gamemeta.getbump())
		-- this variable pops up if you are bounced by another car, a mine, etc.

		return
			(hitwall_changed and prev_hittingwall == 0) or
			(invuln_changed and invuln > prev_invuln and invuln >6) or
			(bump_changed and prev_bump == 0)
	end
end

local function Monopoly_NES_swap(gamemeta)
	-- goals: swap when you lose money, go to jail, or go bankrupt
	-- don't swap if: setting options at start of game, buying a property, winning an auction, trading, building on a property	
	return function(data)

		local _, currInEditor, prevInEditor = update_prev('in_editor', gamemeta.getInEditor())

		-- this needs cleanup with a table or something
		
		local _, p1currHuman, p1prevHuman = update_prev('p1_human', gamemeta.getp1Human())
		local _, p2currHuman, p2prevHuman = update_prev('p2_human', gamemeta.getp2Human())
		local _, p3currHuman, p3prevHuman = update_prev('p3_human', gamemeta.getp3Human())
		local _, p4currHuman, p4prevHuman = update_prev('p4_human', gamemeta.getp4Human())
		local _, p5currHuman, p5prevHuman = update_prev('p5_human', gamemeta.getp5Human())
		local _, p6currHuman, p6prevHuman = update_prev('p6_human', gamemeta.getp6Human())
		local _, p7currHuman, p7prevHuman = update_prev('p7_human', gamemeta.getp7Human())
		local _, p8currHuman, p8prevHuman = update_prev('p8_human', gamemeta.getp8Human())
		
		local _, p1currInJail, p1prevInJail = update_prev('p1_in_jail', gamemeta.getp1InJail())
		local _, p2currInJail, p2prevInJail = update_prev('p2_in_jail', gamemeta.getp2InJail())
		local _, p3currInJail, p3prevInJail = update_prev('p3_in_jail', gamemeta.getp3InJail())
		local _, p4currInJail, p4prevInJail = update_prev('p4_in_jail', gamemeta.getp4InJail())
		local _, p5currInJail, p5prevInJail = update_prev('p5_in_jail', gamemeta.getp5InJail())
		local _, p6currInJail, p6prevInJail = update_prev('p6_in_jail', gamemeta.getp6InJail())
		local _, p7currInJail, p7prevInJail = update_prev('p7_in_jail', gamemeta.getp7InJail())
		local _, p8currInJail, p8prevInJail = update_prev('p8_in_jail', gamemeta.getp8InJail())
		
		local _, p1currBankrupt, p1prevBankrupt = update_prev('p1_bankrupt', gamemeta.getp1Bankrupt())
		local _, p2currBankrupt, p2prevBankrupt = update_prev('p2_bankrupt', gamemeta.getp2Bankrupt())
		local _, p3currBankrupt, p3prevBankrupt = update_prev('p3_bankrupt', gamemeta.getp3Bankrupt())
		local _, p4currBankrupt, p4prevBankrupt = update_prev('p4_bankrupt', gamemeta.getp4Bankrupt())
		local _, p5currBankrupt, p5prevBankrupt = update_prev('p5_bankrupt', gamemeta.getp5Bankrupt())
		local _, p6currBankrupt, p6prevBankrupt = update_prev('p6_bankrupt', gamemeta.getp6Bankrupt())
		local _, p7currBankrupt, p7prevBankrupt = update_prev('p7_bankrupt', gamemeta.getp7Bankrupt())
		local _, p8currBankrupt, p8prevBankrupt = update_prev('p8_bankrupt', gamemeta.getp8Bankrupt())
		
		local _, p1currMoney, p1prevMoney = update_prev('p1_money', gamemeta.getp1Money())
		local _, p2currMoney, p2prevMoney = update_prev('p2_money', gamemeta.getp2Money())
		local _, p3currMoney, p3prevMoney = update_prev('p3_money', gamemeta.getp3Money())
		local _, p4currMoney, p4prevMoney = update_prev('p4_money', gamemeta.getp4Money())
		local _, p5currMoney, p5prevMoney = update_prev('p5_money', gamemeta.getp5Money())
		local _, p6currMoney, p6prevMoney = update_prev('p6_money', gamemeta.getp6Money())
		local _, p7currMoney, p7prevMoney = update_prev('p7_money', gamemeta.getp7Money())
		local _, p8currMoney, p8prevMoney = update_prev('p8_money', gamemeta.getp8Money())
		
		-- check all the property statuses
		-- each byte includes "owned," "owned by whom," "in a monopoly," "has buildings," "mortgaged," etc.
		-- these also, critically, change on the same frame as money changes
		
		local changedSpace01, currSpace01, prevSpace01 = update_prev('space_01', gamemeta.getSpace01())
		local changedSpace03, currSpace03, prevSpace03 = update_prev('space_03', gamemeta.getSpace03())
		local changedSpace05, currSpace05, prevSpace05 = update_prev('space_05', gamemeta.getSpace05())
		local changedSpace06, currSpace06, prevSpace06 = update_prev('space_06', gamemeta.getSpace06())
		local changedSpace08, currSpace08, prevSpace08 = update_prev('space_08', gamemeta.getSpace08())
		local changedSpace09, currSpace09, prevSpace09 = update_prev('space_09', gamemeta.getSpace09())
		local changedSpace11, currSpace11, prevSpace11 = update_prev('space_11', gamemeta.getSpace11())
		local changedSpace12, currSpace12, prevSpace12 = update_prev('space_12', gamemeta.getSpace12())
		local changedSpace13, currSpace13, prevSpace13 = update_prev('space_13', gamemeta.getSpace13())
		local changedSpace14, currSpace14, prevSpace14 = update_prev('space_14', gamemeta.getSpace14())
		local changedSpace15, currSpace15, prevSpace15 = update_prev('space_15', gamemeta.getSpace15())
		local changedSpace16, currSpace16, prevSpace16 = update_prev('space_16', gamemeta.getSpace16())
		local changedSpace18, currSpace18, prevSpace18 = update_prev('space_18', gamemeta.getSpace18())
		local changedSpace19, currSpace19, prevSpace19 = update_prev('space_19', gamemeta.getSpace19())
		local changedSpace21, currSpace21, prevSpace21 = update_prev('space_21', gamemeta.getSpace21())
		local changedSpace23, currSpace23, prevSpace23 = update_prev('space_23', gamemeta.getSpace23())
		local changedSpace24, currSpace24, prevSpace24 = update_prev('space_24', gamemeta.getSpace24())
		local changedSpace25, currSpace25, prevSpace25 = update_prev('space_25', gamemeta.getSpace25())
		local changedSpace26, currSpace26, prevSpace26 = update_prev('space_26', gamemeta.getSpace26())
		local changedSpace27, currSpace27, prevSpace27 = update_prev('space_27', gamemeta.getSpace27())
		local changedSpace28, currSpace28, prevSpace28 = update_prev('space_28', gamemeta.getSpace28())
		local changedSpace29, currSpace29, prevSpace29 = update_prev('space_29', gamemeta.getSpace29())
		local changedSpace31, currSpace31, prevSpace31 = update_prev('space_31', gamemeta.getSpace31())
		local changedSpace32, currSpace32, prevSpace32 = update_prev('space_32', gamemeta.getSpace32())
		local changedSpace34, currSpace34, prevSpace34 = update_prev('space_34', gamemeta.getSpace34())
		local changedSpace35, currSpace35, prevSpace35 = update_prev('space_35', gamemeta.getSpace35())
		local changedSpace37, currSpace37, prevSpace37 = update_prev('space_37', gamemeta.getSpace37())
		local changedSpace39, currSpace39, prevSpace39 = update_prev('space_39', gamemeta.getSpace39())
		
		-- start by ruling out times to swap
		if
			-- you are manually editing money before game
			currInEditor == 1 or
			-- any of the property values changed on the same frame
			changedSpace01 or changedSpace03 or
			changedSpace05 or changedSpace06 or
			changedSpace08 or changedSpace09 or
			changedSpace11 or changedSpace12 or
			changedSpace13 or changedSpace14 or
			changedSpace15 or changedSpace16 or
			changedSpace18 or changedSpace19 or
			changedSpace21 or changedSpace23 or
			changedSpace24 or changedSpace25 or
			changedSpace26 or changedSpace27 or
			changedSpace28 or changedSpace29 or
			changedSpace31 or changedSpace32 or
			changedSpace34 or changedSpace35 or
			changedSpace37 or changedSpace39 or
			-- there are no active players, like on final screen or menus
			((p1currBankrupt + p2currBankrupt + p3currBankrupt + p4currBankrupt +
				p5currBankrupt + p6currBankrupt + p7currBankrupt + p8currBankrupt) == 255*8)
		then
			return false
		end -- don't swap when any of those are true
		
		-- Now, we assume that money going down, player going bankrupt, player jail counter going up for a human means we swap

		-- implement delay so that we can catch the cause of the swap
		if data.p1countdown ~= nil and data.p1countdown > 0 then
			data.p1countdown = data.p1countdown - 1
			if data.p1countdown == 0 then
				return true
			end
		end
		
		if data.p2countdown ~= nil and data.p2countdown > 0 then
			data.p2countdown = data.p2countdown - 1
			if data.p2countdown == 0 then
				return true
			end
		end
	
		if data.p3countdown ~= nil and data.p3countdown > 0 then
			data.p3countdown = data.p3countdown - 1
			if data.p3countdown == 0 then
				return true
			end
		end
		
		if data.p4countdown ~= nil and data.p4countdown > 0 then
			data.p4countdown = data.p4countdown - 1
			if data.p4countdown == 0 then
				return true
			end
		end
		
		if data.p5countdown ~= nil and data.p5countdown > 0 then
			data.p5countdown = data.p5countdown - 1
			if data.p5countdown == 0 then
				return true
			end
		end
		
		if data.p6countdown ~= nil and data.p6countdown > 0 then
			data.p6countdown = data.p6countdown - 1
			if data.p6countdown == 0 then
				return true
			end
		end
		
		if data.p7countdown ~= nil and data.p7countdown > 0 then
			data.p7countdown = data.p7countdown - 1
			if data.p7countdown == 0 then
				return true
			end
		end
		
		if data.p8countdown ~= nil and data.p8countdown > 0 then
			data.p8countdown = data.p8countdown - 1
			if data.p8countdown == 0 then
				return true
			end
		end
		
		-- if money goes down, or jail counter goes up, or bankrupt hits true for a human, start the countdown
		if
			p1prevHuman ~= nil and p1currHuman == 0 and
			((p1prevMoney ~= nil and p1currMoney < p1prevMoney) or
			(p1prevInJail ~= nil and p1currInJail > p1prevInJail) or
			(p1prevBankrupt ~= nil and p1currBankrupt == 255 and p1prevBankrupt == 0)) == true
		then
			data.p1countdown = gamemeta.delay
		elseif
			p2prevHuman ~= nil and p2currHuman == 0 and
			((p2prevMoney ~= nil and p2currMoney < p2prevMoney) or
			(p2prevInJail ~= nil and p2currInJail > p2prevInJail) or
			(p2prevBankrupt ~= nil and p2currBankrupt == 255 and p2prevBankrupt == 0)) == true
		then
			data.p2countdown = gamemeta.delay
		elseif
			p3prevHuman ~= nil and p3currHuman == 0 and
			((p3prevMoney ~= nil and p3currMoney < p3prevMoney) or
			(p3prevInJail ~= nil and p3currInJail > p3prevInJail) or
			(p3prevBankrupt ~= nil and p3currBankrupt == 255 and p3prevBankrupt == 0)) == true
		then
			data.p3countdown = gamemeta.delay
		elseif
			p4prevHuman ~= nil and p4currHuman == 0 and
			((p4prevMoney ~= nil and p4currMoney < p4prevMoney) or
			(p4prevInJail ~= nil and p4currInJail > p4prevInJail) or
			(p4prevBankrupt ~= nil and p4currBankrupt == 255 and p4prevBankrupt == 0)) == true
		then
			data.p4countdown = gamemeta.delay
		elseif
			p5prevHuman ~= nil and p5currHuman == 0 and
			((p5prevMoney ~= nil and p5currMoney < p5prevMoney) or
			(p5prevInJail ~= nil and p5currInJail > p5prevInJail) or
			(p5prevBankrupt ~= nil and p5currBankrupt == 255 and p5prevBankrupt == 0)) == true
		then
			data.p5countdown = gamemeta.delay
		elseif
			p6prevHuman ~= nil and p6currHuman == 0 and
			((p6prevMoney ~= nil and p6currMoney < p6prevMoney) or
			(p6prevInJail ~= nil and p6currInJail > p6prevInJail) or
			(p6prevBankrupt ~= nil and p6currBankrupt == 255 and p6prevBankrupt == 0)) == true
		then
			data.p6countdown = gamemeta.delay
		elseif
			p7prevHuman ~= nil and p7currHuman == 0 and
			((p7prevMoney ~= nil and p7currMoney < p7prevMoney) or
			(p7prevInJail ~= nil and p7currInJail > p7prevInJail) or
			(p7prevBankrupt ~= nil and p7currBankrupt == 255 and p7prevBankrupt == 0)) == true
		then
			data.p7countdown = gamemeta.delay
		elseif
			p8prevHuman ~= nil and p8currHuman == 0 and
			((p8prevMoney ~= nil and p8currMoney < p8prevMoney) or
			(p8prevInJail ~= nil and p8currInJail > p8prevInJail) or
			(p8prevBankrupt ~= nil and p8currBankrupt == 255 and p8prevBankrupt == 0)) == true
		then
			data.p8countdown = gamemeta.delay
		end
	end
end

local function iframe_health_swap(gamemeta)
	return function()
		local iframes_changed, iframes_curr, iframes_prev = update_prev('iframes', gamemeta.get_iframes())
		local health_changed, health_curr, health_prev = false, 0, 0
		if gamemeta.get_health then
			health_changed, health_curr, health_prev = update_prev('health', gamemeta.get_health())
		end
		local iframe_minimum = 0
		if gamemeta.iframe_minimum then
			iframe_minimum = gamemeta.iframe_minimum()
		end
		-- check if we're in a valid gamestate
		if not gamemeta.is_valid_gamestate() then
			return false
		end
		-- assumptions: by default, the iframe counter is at 0
		-- if iframes > 0, you got hit
		-- some games will let you take damage on 1 iframe left
		-- (presumably, iframes go down to 0, then it checks for damage, then sets iframes back to max)
		-- certain games do damage over time using a short iframe timer, so check a minimum iframe count to shuffle
		local iframes_valid = iframes_changed and iframes_curr > iframes_prev and iframes_prev <= 1 and iframes_curr >= iframe_minimum
		if gamemeta.get_health then
			-- check 0 health for games that don't set iframes on death
			if (iframes_valid or health_curr == 0) and health_changed and health_curr < health_prev then
				return true
			end
		elseif iframes_valid then
			return true
		end
		-- sometimes you want to swap for things that don't give iframes and change health, like non-standard game overs
		return gamemeta.other_swaps()
	end
end

local function health_swap(gamemeta)
	return function()
		-- for games where iframes are unhelpful
		local health_changed, health_curr, health_prev = update_prev('health', gamemeta.get_health())
		-- check if we're in a valid gamestate
		if not gamemeta.is_valid_gamestate() then
			return false
		end
		if health_changed and health_curr < health_prev then
			return true
		end
		-- sometimes you want to swap for things that don't reduce health
		return gamemeta.other_swaps()
	end
end

local function sotn_swap(gamemeta)
	return function ()
		-- richter's iframes are stored elsewhere than alucard's, couldn't find where
		local iframes_changed, iframes_curr, iframes_prev = update_prev('iframes', gamemeta.get_iframes())
		local health_changed, health_curr, health_prev = update_prev('health', gamemeta.get_health())
		-- check if we're in a valid gamestate
		if not gamemeta.is_valid_gamestate() then
			return false
		end
		if ((iframes_changed and iframes_prev == 0) or health_curr == 0 or gamemeta.is_richter())
			and health_changed and health_curr < health_prev
		then
			return true
		end
	end
end

local function jonathan_charlotte_swap(gamemeta)
	return function ()
		-- wow! two iframe counters!
		local j_iframes_changed, j_iframes_curr, j_iframes_prev = update_prev('jonathan iframes', gamemeta.get_jonathan_iframes())
		local c_iframes_changed, c_iframes_curr, c_iframes_prev = update_prev('charlotte iframes', gamemeta.get_charlotte_iframes())
		local health_changed, health_curr, health_prev = update_prev('health', gamemeta.get_health())
		if not gamemeta.is_valid_gamestate() then
			return false
		end
		-- unlike Symphony, Portrait sets iframes on death, don't need to check for that
		if gamemeta.is_jonathan() and j_iframes_changed and j_iframes_prev <= 1
			and health_changed and health_curr < health_prev
		then
			-- jonathan!
			return true
		elseif not gamemeta.is_jonathan() and c_iframes_changed and c_iframes_prev <= 1
			and health_changed and health_curr < health_prev
		then
			-- charlotte!
			return true
		end
	end
end

-- Modified version of the gamedata for Mega Man games on NES.
-- Battletoads NES shows 6 "boxes" that look like HP.
-- But, each toad actually has a max HP of 47. Each box is basically 8 HP.
-- If your health falls 40, you go from 6 boxes to 5. Anything from 41-47 will still show 6 boxes.
-- At 32, you have 4 boxes. At 24, 3 boxes. And so on - until a death at HP = 0.
-- We only want to shuffle when the # of HP on screen changes, because 'light' damage (say, of only 2 HP from a chop by one of the pigs at the beginning) gets partially refilled over time.
-- So, dividing the current HP value by 8, then rounding up, gives us the number of health boxes the toad has.
local gamedata = {
	['BT_NES']={ -- Battletoads NES
		func=battletoads_swap,
		p1gethp=function() return math.ceil(memory.read_u8(0x051A, "RAM")/8) end,
		p2gethp=function() return math.ceil(memory.read_u8(0x051B, "RAM")/8) end,
		p1getlc=function() return memory.read_u8(0x0011, "RAM") end,
		p2getlc=function() return memory.read_u8(0x0012, "RAM") end,
		p1getcont=function() return memory.read_u8(0x000E, "RAM") end,
		p2getcont=function() return memory.read_u8(0x000F, "RAM") end,
		p1getsprite=function() return nil end, -- N/A
		p2getsprite=function() return nil end, -- N/A
		maxhp=function() return 6 end,
	},
	['BT_NES_patched']={ -- Battletoads NES with bugfix patch
		-- identical to unpatched? probably can remove
		-- but test that first in case
		func=battletoads_swap,
		p1gethp=function() return math.ceil(memory.read_u8(0x051A, "RAM")/8) end,
		p2gethp=function() return math.ceil(memory.read_u8(0x051B, "RAM")/8) end,
		p1getlc=function() return memory.read_u8(0x0011, "RAM") end,
		p2getlc=function() return memory.read_u8(0x0012, "RAM") end,
		p1getcont=function() return memory.read_u8(0x000E, "RAM") end,
		p2getcont=function() return memory.read_u8(0x000F, "RAM") end,
		p1getsprite=function() return nil end, -- N/A
		p2getsprite=function() return nil end, -- N/A
		maxhp=function() return 6 end,
	},
	['BTDD_NES']={ -- Battletoads Double Dragon NES
		func=battletoads_swap,
		p1gethp=function() return math.ceil(memory.read_u8(0x051B, "RAM")/8) end,
		p2gethp=function() return math.ceil(memory.read_u8(0x051C, "RAM")/8) end,
		p1getlc=function() return memory.read_u8(0x0011, "RAM") end,
		p2getlc=function() return memory.read_u8(0x0012, "RAM") end,
		p1getcont=function() return memory.read_u8(0x000E, "RAM") end,
		p2getcont=function() return memory.read_u8(0x000F, "RAM") end,
		p1getsprite=function() return nil end, -- N/A
		p2getsprite=function() return nil end, -- N/A
		maxhp=function() return 6 end,
	},
	['BT_SNES']={ -- Battletoads in Battlemaniacs for SNES
		func=battletoads_swap,
		p1gethp=function() return memory.read_u8(0x000E5E, "WRAM") end,
		p2gethp=function() return memory.read_u8(0x000E60, "WRAM") end,
		p1getlc=function() return memory.read_u8(0x000028, "WRAM") end,
		p2getlc=function() return memory.read_u8(0x00002A, "WRAM") end,
		p1getcont=function() return memory.read_u8(0x00002E, "WRAM") end,
		p2getcont=function() return memory.read_u8(0x000030, "WRAM") end,
		p1getsprite=function() return memory.read_u8(0x000AEE, "WRAM") end, -- this is an address for the sprite called for p1
		p2getsprite=function() return memory.read_u8(0x000AF0, "WRAM") end, -- this is an address for the sprite called for p2
		gettogglecheck=function() return
			memory.read_u16_le(0x000F0A, "WRAM") == 65535
			and memory.read_u16_le(0x000F0C, "WRAM") == 65535
			and memory.read_u8(0x00002C, "WRAM") ~= 3 end,
		-- these addresses are the counters for # of pins/dominoes in bonus rounds
		-- they pop in or out of FFFF (65535) when entering/exiting a level, and health also drops to 0 at the same time
		-- so we won't swap on the frame that this toggles on/off!
		-- the exception is that we SHOULD swap when this drops to 0 upon reaching Turbo Tunnel Rematch (level == 3)!
		maxhp=function() return 16 end,
	},
	['BTDD_SNES']={ -- Battletoads Double Dragon SNES
		func=battletoads_swap,
		p1gethp=function() return math.ceil(memory.read_u8(0x00003A, "WRAM")/8) end,
		p2gethp=function() return math.ceil(memory.read_u8(0x00003C, "WRAM")/8) end,
		p1getlc=function() return memory.read_u8(0x000026, "WRAM") end,
		p2getlc=function() return memory.read_u8(0x000028, "WRAM") end,
		p1getcont=function() return memory.read_u8(0x000010, "WRAM") end,
		p2getcont=function() return memory.read_u8(0x000012, "WRAM") end,
		p1getsprite=function() return nil end, -- N/A
		p2getsprite=function() return nil end, -- N/A
		maxhp=function() return 6 end,
	},
	['BTDD_SNES_patched']={ -- Battletoads Double Dragon SNES
		-- unlike the nes bugfix patch, this patch affects things elsewhere
		-- so it stays for now
		func=battletoads_swap,
		p1gethp=function() return math.ceil(memory.read_u8(0x00003A, "WRAM")/8) end,
		p2gethp=function() return math.ceil(memory.read_u8(0x00003C, "WRAM")/8) end,
		p1getlc=function() return memory.read_u8(0x000026, "WRAM") end,
		p2getlc=function() return memory.read_u8(0x000028, "WRAM") end,
		p1getcont=function() return memory.read_u8(0x000010, "WRAM") end,
		p2getcont=function() return memory.read_u8(0x000012, "WRAM") end,
		p1getsprite=function() return nil end, -- N/A
		p2getsprite=function() return nil end, -- N/A
		maxhp=function() return 6 end,
	},
	['CNDRR1']={ -- Chip and Dale 1 (NES)
		func=twoplayers_withlives_swap,
		-- three addresses for hearts - if the heart is there, these == 24 (18 hex) , otherwise they == 248 (F8 hex).
		p1gethp=function()
			if memory.read_u8(0x0210, "RAM") == 24 then
				return 3
			elseif memory.read_u8(0x020C, "RAM") == 24 then
				return 2
			elseif memory.read_u8(0x0208, "RAM") == 24 then
				return 1
			else
				return 0
			end
		end,
		p2gethp=function()
			if memory.read_u8(0x0224, "RAM") == 24 then
				return 3
			elseif memory.read_u8(0x0220, "RAM") == 24 then
				return 2
			elseif memory.read_u8(0x021C, "RAM") == 24 then
				return 1
			else
				return 0
			end
		end,
		CanHaveInfiniteLives=true,
		LivesWhichRAM=function() return "RAM" end,
		p1livesaddr=function() return 0x05B6 end,
		p2livesaddr=function() return 0x05E6 end,
		maxlives=function() return 135 end, -- rescue rangers counts strangely
		p1getlc=function() return memory.read_u8(0x05B6, "RAM") end,
		p2getlc=function() return memory.read_u8(0x05E6, "RAM") end,
		ActiveP1=function() return memory.read_u8(0x05B6, "RAM") > 0 and memory.read_u8(0x05B6, "RAM") < 255 end,
		ActiveP2=function() return memory.read_u8(0x05E6, "RAM") > 0 and memory.read_u8(0x05E6, "RAM") < 255 end,
		maxhp=function() return 3 end,
	},
	['SuperDodgeBall']={ -- Super Dodge Ball (NES)
		func=sdbnes_swap,
		gethowmanyplayers=function() return memory.read_u8(0x006F, "RAM") end,
		-- # humans, 1 or 2, use this to tell whether to swap if 2p team takes damage
		getmode=function() return memory.read_u8(0x06B1, "RAM") end,
		-- mode: 0 for 1p, 1 for 2p vs, 2 for bean ball
		p1gethp1=function() return memory.read_u8(0x058B, "RAM") end,
		p1gethp2=function() return memory.read_u8(0x0553, "RAM") end,
		p1gethp3=function() return memory.read_u8(0x051B, "RAM") end,
		p2gethp1=function() return memory.read_u8(0x043B, "RAM") end,
		p2gethp2=function() return memory.read_u8(0x0403, "RAM") end,
		p2gethp3=function() return memory.read_u8(0x03CB, "RAM") end,
		p1getbbplayer=function() return (1 + math.floor(memory.read_u8(0x0587, "RAM")/16) + 3*(memory.read_u8(0x0587, "RAM") % 16)) end,
		-- transforming from 0, 16, 32, 1, 17, 33 format
		p2getbbplayer=function() return (1 + math.floor(memory.read_u8(0x0588, "RAM")/16) + 3*(memory.read_u8(0x0588, "RAM") % 16)) end,
		-- transforming from 0, 16, 32, 1, 17, 33 format
		gmode=function() return (memory.read_u8(0x0070, "RAM")%2) == 0 end,
		-- several potential values, but if it's ever odd, we're not in-game.
		maxhp=function() return 60 end,
	},
	['Novolin']={ -- Captain Novolin SNES
		func=singleplayer_withlives_swap,
		p1gethp=function() return memory.read_u8(0x0BDA, "WRAM") end,
		p1getlc=function() return memory.read_u8(0x06C3, "WRAM") end,
		maxhp=function() return 4 end,
		CanHaveInfiniteLives=true,
		p1livesaddr=function() return 0x06C3 end,
		LivesWhichRAM=function() return "WRAM" end,
		maxlives=function() return 3 end,
		ActiveP1=function() return memory.read_u8(0x06C3, "WRAM") > 1 and memory.read_u8(0x06C3, "WRAM") < 3 end,
	},
	['LTTP']={ -- LTTP SNES
		func=singleplayer_withlives_swap,
		p1gethp=function()
			if (memory.read_u8(0x0010, "WRAM") < 23 and memory.read_u8(0x0010, "WRAM") >5) then
				-- <=5 means we're on the title/menu, 23 means save/quit and >23 is credits, etc. Don't swap on those!
				return memory.read_u8(0xF36D, "WRAM")
			else
				return 0
			end
		end, -- single byte!
		maxhp=function() return 160 end, -- 8 hp per heart, 20 heart containers
		p1getlc=function()
			if memory.read_u8(0x0010, "WRAM") == 18 then
			-- this value is the "Link is in a death spiral" value - so it tells us Link hit 0 for real, not due to resets etc.
				return 1
			else
				return 2
			end
		end,
	},
	['SuperMetroid']={ -- Super Metroid SNES
		func=supermetroid_swap,
		getinvuln=function() return memory.read_u16_le(0x18A8, "WRAM") end,
		-- this value is 0 until i-frames are triggered
		getsamusstate=function() return memory.read_u8(0x0998, "WRAM") end,
		-- this value is the "game state" where the game is fading out after Samus dies.
		-- Tells us Samus hit 0 for real, not due to resets etc.
		gethp=function() return memory.read_u16_le(0x09C2, "WRAM") end,
	},
	['SMZ3']={ -- TESTING SMZ3
		func=SMZ3_swap,
		getinvuln=function() return memory.read_u16_le(0x18A8, "WRAM") end,
		-- this value is 0 until i-frames are triggered
		getsamusstate=function() return memory.read_u8(0x0998, "WRAM") end,
		-- this value is the "game state" where the game is fading out after Samus dies.
		-- Tells us Samus hit 0 for real, not due to resets etc.
		getsamushp=function() return memory.read_u8(0x09C2, "WRAM") end,
		getlinkhp=function()
			if memory.read_u8(0x33FE, "CARTRAM") == 0 then
				if (memory.read_u8(0x0010, "WRAM") < 23 and memory.read_u8(0x0010, "WRAM") >5)  then
					return memory.read_u8(0xF36D, "WRAM") -- Link health
				else
					return 0
				end
			else
				return 0
			end
		end,
		maxhp=function() return 160 end,
		getlinklc=function()
			if memory.read_u8(0x33FE, "CARTRAM") == 0 -- LTTP
				and memory.read_u8(0x0010, "WRAM") == 18
				-- this value is the "Link is in a death spiral" value - so it tells us Link hit 0 for real, not due to resets etc.
			then
				return 1
			else
				return 2
			end
		end,
		getwhichgame=function() return memory.read_u8(0x33FE, "CARTRAM") end,
	},
	['Anticipation']={ -- Anticipation NES
		func=antic_swap,
		getbotchedletter=function() return memory.read_u8(0x00C3, "RAM") end,
		getbuzzintime=function() return memory.read_u8(0x007F, "RAM") end,
		gettypetime=function() return memory.read_u8(0x0086, "RAM") end,
		getanswerright=function() return memory.read_u8(0x00A0, "RAM") end,
	},
	['SMK_SNES']={ -- Super Mario Kart
		func=smk_swap,
		p1getbump=function() return memory.read_u8(0x00105E, "WRAM") end, -- if > 0 then p1 is bumping/crashing
		p2getbump=function() return memory.read_u8(0x00115E, "WRAM") end, -- if > 0 then p2 is bumping/crashing
		p1getshrink=function() return memory.read_u16_be(0x001084, "WRAM") end, -- if > 0 then you're small and it's counting down
		p2getshrink=function() return memory.read_u16_be(0x001184, "WRAM") end, -- if > 0 then you're small and it's counting down
		p1getlava=function() return memory.read_u8(0x00010A, "WRAM") end, -- if == 16 then congrats, you're in lava
		p2getlava=function() return memory.read_u8(0x00010C, "WRAM") end, -- if == 16 then congrats, you're in lava
		p1getfall=function() return memory.read_u8(0x0010A0, "WRAM") end, -- if > 2 falling into pit (4), lava (6), deep water (8)
		p2getfall=function() return memory.read_u8(0x0011A0, "WRAM") end, -- if > 2 falling into pit (4), lava (6), deep water (8)
		p1getcoins=function() return memory.read_u8(0x000E00, "WRAM") end,
		p2getcoins=function() return memory.read_u8(0x000E02, "WRAM") end,
		p1getspinout=function() return memory.read_u8(0x0010A6, "WRAM") end, -- 12, 14, 16, and 26 should mean you spin out
		p2getspinout=function() return memory.read_u8(0x0011A6, "WRAM") end, -- 12, 14, 16, and 26 should mean you spin out
		p1getmoled=function() return memory.read_u8(0x001061, "WRAM") end, -- >=152 means a mole jumped on
		p2getmoled=function() return memory.read_u8(0x001161, "WRAM") end, -- >=152 means a mole jumped on
		p1getshrink2=function() return memory.read_u8(0x001030, "WRAM") end, -- if ==128 then you're shrunk
		p2getshrink2=function() return memory.read_u8(0x001130, "WRAM") end, -- if ==128 then you're shrunk
		p2getIsActive=function() return memory.read_u8(0x0011D2, "WRAM") == 2 end, -- if 2, you are in 2p mode
	},
	--MARIO BLOCK
	['SMB1_NES']={ -- SMB 1 NES
		func=singleplayer_withlives_swap,
		p1gethp=function() return memory.read_u8(0x0756, "RAM") + 1 end,
		-- add 1 because 'base health' is 0 and won't swap unless lives counter goes down
		p1getlc=function() return
			memory.read_u8(0x075A, "RAM") % 255
			-- mario if 1p, luigi if 2p, 255 = they game overed
			+ memory.read_u8(0x0761, "RAM") % 255
			-- mario if 2p, 255 = they game overed, stays at 2 if in 1p
		end,
		p2getlc=function() return memory.read_u8(0x0761, "RAM") end,
		maxhp=function() return 2 end,
		gmode=function() return memory.read_u8(0x0770, "RAM") == 1 end,
		-- demo == 0, end of world == 2, game over == 3
		CanHaveInfiniteLives=true,
		p1livesaddr=function() return 0x075A end,
		p2livesaddr=function() return 0x0761 end,
		maxlives=function() return 8 end,
		ActiveP1=function() return memory.read_u8(0x075A, "RAM") > 0 and memory.read_u8(0x075A, "RAM") < 255 end,
		ActiveP2=function() return memory.read_u8(0x0761, "RAM") > 0 and memory.read_u8(0x0761, "RAM") < 255 end,
		LivesWhichRAM=function() return "RAM" end,
	},
	['SMB2J_NES']={ -- SMB 2 JP, NES version (Lost Levels)
		func=singleplayer_withlives_swap,
		p1gethp=function() return memory.read_u8(0x0756, "RAM") + 1 end,
		-- add 1 because 'base health' is 0 and won't swap unless lives counter goes down
		p1getlc=function() return memory.read_u8(0x075A, "RAM") end,
		maxhp=function() return 2 end,
		gmode=function() return memory.read_u8(0x0770, "RAM") == 1 end,
		-- demo == 0, end of world == 2, game over == 3
		gettogglecheck=function() return memory.read_u8(0x075A) == 255 end,
		-- not in the ending or world 9 where you get 1 life no matter what (so lives are bumped to 255 arbitrarily)
		CanHaveInfiniteLives=true,
		p1livesaddr=function() return 0x075A end,
		maxlives=function() return 8 end,
		p1getlc=function() return memory.read_u8(0x075A, "RAM") end,
		ActiveP1=function() return memory.read_u8(0x075A, "RAM") > 0 and memory.read_u8(0x075A, "RAM") < 255 end,
		LivesWhichRAM=function() return "RAM" end,
	},
	['SMB2_NES']={ -- SMB2 USA NES
		func=singleplayer_withlives_swap,
		p1gethp=function() return memory.read_u8(0x04C2, "RAM") end,
		p1getlc=function() return memory.read_u8(0x04ED, "RAM") end,
		maxhp=function() return 63 end,
		gettogglecheck=function() return memory.read_u8(0x04C3, "RAM") end,
		-- this is the number of health bars - if it changes, as in goes back down to normal on slots
		CanHaveInfiniteLives=true,
		p1livesaddr=function() return 0x04ED end,
		maxlives=function() return 70 end,
		ActiveP1=function() return memory.read_u8(0x04ED, "RAM") > 0 and memory.read_u8(0x04ED, "RAM") < 255 end,
		LivesWhichRAM=function() return "RAM" end,
	},
	['MB_NES']={ -- Mario Bros. US NES
		func=twoplayers_withlives_swap,
		-- this game only uses lives
		p1gethp=function() return 0 end,
		p1getlc=function() return memory.read_u8(0x0048, "RAM") end,
		p2gethp=function() return 0 end,
		p2getlc=function() return memory.read_u8(0x004C, "RAM") end,
		maxhp=function() return 0 end,
	},
	['SOMARI']={ -- Somari (unlicensed) NES
		func=somari_swap,
		getsprite=function() return memory.read_u8(0x0016) end,
		getshield=function() return memory.read_u8(0x001A) == 2 or memory.read_u8(0x001A) == 6 end,
		CanHaveInfiniteLives=true,
		-- consider moving to on_frame version if can identify "dying" sprite
		p1livesaddr=function() return 0x033C end,
		maxlives=function() return 9 end,
		maxlives=function() return "RAM" end,
		ActiveP1=function() return memory.read_u8(0x033C, "RAM") > 0 and memory.read_u8(0x033C, "RAM") < 255 end,
		LivesWhichRAM=function() return "RAM" end,
	},
	['SMB3_NES']={ -- SMB3 NES
		func=smb3_swap,
		getsmb3battling=function() return memory.read_u8(0x001D, "RAM") == 18 end,
		-- 2p battle true/false
		getinvuln=function() return memory.read_u8(0x0552, "RAM") end,
		-- invuln frames, 0 unless triggered, then counts down by 1 per frame
		getstatue=function() return memory.read_u8(0x057A, "RAM") end,
		-- 0 until you go into tanooki statue form, then counts down by 1 per frame
		getboot=function() return memory.read_u8(0x0577, "RAM") end,
		-- boot flag, 1 means we're in the boot!
		p1getlc=function() return memory.read_u8(0x0736, "RAM") end,
		p2getlc=function() return memory.read_u8(0x0737, "RAM") end,
		gmode=function() return memory.read_u8(0x072B, "RAM") ~= 0 end,
		-- this value == number of players, == 0 on the title screen menu when cutscene is playing.
		CanHaveInfiniteLives=true,
		p1livesaddr=function() return 0x0736 end,
		p2livesaddr=function() return 0x0737 end,
		maxlives=function() return 69 end,
		ActiveP1=function() return memory.read_u8(0x0736, "RAM") > 0 and memory.read_u8(0x0736, "RAM") < 255 end,
		ActiveP2=function() return memory.read_u8(0x0737, "RAM") > 0 and memory.read_u8(0x0737, "RAM") < 255 end,
		LivesWhichRAM=function() return "RAM" end,
	},
	['SMW_SNES']={ -- Super Mario World SNES
		func=singleplayer_withlives_swap,
		p1gethp=function()
			if memory.read_u8(0x000071, "WRAM") == 9 then
			-- dying, so we need to use the lives counter
				return 0
			elseif memory.read_u8(0x000019, "WRAM") == 2 or memory.read_u8(0x000019, "WRAM") == 3 then
				return 3 -- fire (3) or cape (2), don't shuffle if you just change powerups
			else
				return memory.read_u8(0x000019, "WRAM") + 1
				-- 1 for big, 0 for small, adding 1 to help with swap on small not relying on life lost
			end
		end,
		p1getlc=function() return memory.read_u8(0x000DBE, "WRAM") end,
		-- active player's lives
		maxhp=function() return 3 end,
		gettogglecheck=function() return memory.read_u8(0x000DB3, "WRAM") end,
		-- which player - if we swap players, then do not shuffle
		gmode=function() return
			memory.read_u8(0x000100, "WRAM") == 11
			-- game mode value for fading to overworld, this is when the lives counter changes on death
			-- the mario/luigi lives count swaps ON the overworld (12-14) so don't count that!
			or (memory.read_u8(0x000100, "WRAM") > 15 and memory.read_u8(0x000100, "WRAM") <= 23)
			-- in a level, for HP checks
		end,
		CanHaveInfiniteLives=true,
		p1livesaddr=function() return 0x000DBE end,
		maxlives=function() return 68 end,
		LivesWhichRAM=function() return "WRAM" end,
		ActiveP1=function() return memory.read_u8(0x000DBE) > 0 and memory.read_u8(0x000DBE) < 255 end,
	},
	['SMAS_SNES']={ -- Super Mario All Stars (SNES)
		-- to do, function to define "which game"
		-- though I don't think that can go in this block and likely needs to go in the swap function instead
		SMAS_which_game=function()
			if memory.read_u8(0x01FF00, "WRAM") == 2 then
				return "SMB1"
			end
			if memory.read_u8(0x01FF00, "WRAM") == 4 then
				return "SMB2J"
			end
			if memory.read_u8(0x01FF00, "WRAM") == 6 and memory.read_u8(0x000547, "WRAM") < 128 then
				return "SMB2U" -- >128 means slots or menu
			end
			if memory.read_u8(0x01FF00, "WRAM") == 10 then
				return "SMW"
			end
			if memory.read_u8(0x01FF00, "WRAM") == 8 then
				if memory.read_u8(0x00072B, "WRAM") == 3 then
					return "SMB3Battle"
				else
					return "SMB3"
				end
			end
			return false
		end,
		func=SMAS_swap,
		gmode=function()
			if ((memory.read_u8(0x01FF00, "WRAM") == 2 or memory.read_u8(0x01FF00, "WRAM") == 4)
				and memory.read_u8(0x000770, "WRAM") ~= 1) -- demo == 0, end of world == 2, game over == 3 false
			then
				return false
			else
				return true
			end
		end,
		getsmb2mode=function()
			return memory.read_u8(0x0004C4, "WRAM")
			-- number of health bars available, changes on entering slots and can cause false swaps
		end,
		gettogglecheck=function()
			if memory.read_u8(0x01FF00, "WRAM") == 10 then
				return memory.read_u8(0x000DB3, "WRAM")
				-- tells us active character in SMW, so we know if we are switching
			elseif memory.read_u8(0x01FF00, "WRAM") == 8 then
				return memory.read_u8(0x000577, "WRAM")
				-- tells us if we have the boot in SMB3, to not swap when we get/lose it
			else
				return nil
			end
		end,
		p1gethp=function()
			if memory.read_u8(0x01FF00, "WRAM") == 8 then -- SMB3
				if memory.read_u8(0x00072B, "WRAM") == 3 then
					-- we are in battle mode
					if memory.read_u8(0x0001FB, "WRAM") == 7 then
						-- actively battling, not in results screen
						return memory.read_u8(0x019AB, "WRAM") + 1
						-- battle health, 0 = small so add 1
					else
						return 0
					end
				elseif memory.read_u8(0x0552, "WRAM") > 0 and memory.read_u8(0x057A, "WRAM") == 0 then
					return 1
				else
					return 2
					-- if invuln frames are activated, not due to tanooki suit statue timer counting down, then drop health from 2 to 1
				end
			elseif memory.read_u8(0x01FF00, "WRAM") == 6 then -- SMB2 USA
				return math.ceil(memory.read_u8(0x0004C3)/16)
			elseif memory.read_u8(0x01FF00, "WRAM") == 2 or memory.read_u8(0x01FF00, "WRAM") == 4 then -- SMB1 or SMB2j
				if memory.read_u8(0x0754, "WRAM") == 1 -- small
					and memory.read_u8(0x070B, "WRAM") == 1 -- animating a shrink/grow
				then
					return 1
				else
					return 2
				end
			elseif memory.read_u8(0x01FF00, "WRAM") == 10 then -- Super Mario World
				if memory.read_u8(0x000071, "WRAM") == 9 then
					-- dying, so we need to use the lives counter
					return 0
				elseif memory.read_u8(0x000019, "WRAM") == 2 or memory.read_u8(0x000019, "WRAM") == 3 then
					return 3 -- fire (3) or cape (2), don't shuffle if you just change powerups
				else
					return memory.read_u8(0x000019, "WRAM") + 1
					-- 1 for big, 0 for small, adding 1 to help with swap on small not relying on life lost
				end
			else
				return 0
			end
		end,
		p2gethp=function()
			if memory.read_u8(0x01FF00, "WRAM") == 8 then -- SMB3
				if memory.read_u8(0x00072B, "WRAM") == 3 then
					-- we are in battle mode
					if memory.read_u8(0x0001FB, "WRAM") == 7 then
						-- actively battling, not in results screen
						return memory.read_u8(0x019AC, "WRAM") + 1
						-- battle health, 0 = small so add 1
					else
						return 0
					end
				elseif memory.read_u8(0x0552, "WRAM") > 0 and memory.read_u8(0x057A, "WRAM") == 0 then
					return 1
				else
					return 2
					-- if invuln frames are activated, and not a tanooki statue, then drop health from 2 to 1
				end
			elseif memory.read_u8(0x01FF00, "WRAM") == 6 then -- SMB2 USA
				return 0
			elseif memory.read_u8(0x01FF00, "WRAM") == 2 or memory.read_u8(0x01FF00, "WRAM") == 4 then -- SMB1 or SMB2j
				if memory.read_u8(0x0754, "WRAM") == 1 -- small
					and memory.read_u8(0x070B, "WRAM") == 1 -- animating a shrink/grow
				then
					return 1
				else
					return 2
				end
			elseif memory.read_u8(0x01FF00, "WRAM") == 10 then -- Super Mario World
				if memory.read_u8(0x000071, "WRAM") == 9 then
					-- dying, so we need to use the lives counter
					return 0
				elseif memory.read_u8(0x000019, "WRAM") == 2 or memory.read_u8(0x000019, "WRAM") == 3 then
					return 3 -- fire (3) or cape (2), don't shuffle if you just change powerups
				else
					return memory.read_u8(0x000019, "WRAM") + 1
					-- 1 for big, 0 for small, adding 1 to help with swap on small not relying on life lost
				end
			else
				return 0
			end
		end,
		maxhp=function()
			if memory.read_u8(0x01FF00, "WRAM") == 8 then -- SMB3
				return 3
			elseif memory.read_u8(0x01FF00, "WRAM") == 6 then -- SMB2 USA
				return 63
			elseif memory.read_u8(0x01FF00, "WRAM") == 2 or memory.read_u8(0x01FF00, "WRAM") == 4 then
				-- SMB1 or SMB2j
				return 2 -- add 1 because 'base health' is 0 and won't swap unless lives counter goes down
			elseif memory.read_u8(0x01FF00, "WRAM") == 10 then -- Super Mario World
				return 3
			else
				return 0
			end
		end,
		p1getlc=function()
			if memory.read_u8(0x01FF00, "WRAM") == 8 then -- SMB3
				if memory.read_u8(0x00072B, "WRAM") == 3 then
					-- we are in battle mode
					return 5 - memory.read_u8(0x0002DB, "WRAM")
					-- luigi's victory count
				elseif memory.read_u8(0x00001D, "WRAM") == 18 then
					return memory.read_u8(0x000736, "WRAM") + 1
					-- we are in 2p battle mode when this == 18.
					-- Let's simply tack on a life for each player in that mode, and 'lose' it when the battle is lost.
				else
					return memory.read_u8(0x000736, "WRAM")
				end
			elseif memory.read_u8(0x01FF00, "WRAM") == 6 then -- SMB2 USA
				return memory.read_u8(0x0004EE, "WRAM")
			elseif memory.read_u8(0x01FF00, "WRAM") == 2 or memory.read_u8(0x01FF00, "WRAM") == 4 then -- SMB1 or SMB2j
				return memory.read_u8(0x00075A, "WRAM") % 255 -- mario if 1p, luigi if 2p, 255 = they game overed
					+ memory.read_u8(0x000761, "WRAM") % 255 -- mario if 2p, 255 = they game overed, stays at 2 if in 1p
			elseif memory.read_u8(0x01FF00, "WRAM") == 10 then -- Super Mario World
				return memory.read_u8(0x000DBE, "WRAM") -- active player's lives
			else
				return 0
			end
		end,
		p2getlc=function()
			if memory.read_u8(0x01FF00, "WRAM") == 8 then -- SMB3
				if memory.read_u8(0x00072B, "WRAM") == 3 then
					-- we are in battle mode
					return 5 - memory.read_u8(0x0002DA, "WRAM")
					-- mario's victory count
				elseif memory.read_u8(0x00001D, "WRAM") == 18 then
					return memory.read_u8(0x000736, "WRAM") + 1
					-- we are in 2p battle mode when this == 18.
					-- Let's simply tack on a life for each player in that mode, and 'lose' it when the battle is lost.
				else
					return memory.read_u8(0x000737, "WRAM")
				end
			elseif memory.read_u8(0x01FF00, "WRAM") == 6 then -- SMB2 USA
				return 0
			elseif memory.read_u8(0x01FF00, "WRAM") == 2 or memory.read_u8(0x01FF00, "WRAM") == 4 then -- SMB1 or SMB2j
				return memory.read_u8(0x00075A, "WRAM") % 255 -- mario if 1p, luigi if 2p, 255 = they game overed
					+ memory.read_u8(0x000761, "WRAM") % 255 -- mario if 2p, 255 = they game overed, stays at 2 if in 1p
			elseif memory.read_u8(0x01FF00, "WRAM") == 10 then -- Super Mario World
				return memory.read_u8(0x000DBE, "WRAM") -- active player's lives
			else
				return 0
			end
		end,
		CanHaveInfiniteLives=true,
		LivesWhichRAM=function() return "WRAM" end,
		maxlives=function()
			if memory.read_u8(0x01FF00, "WRAM") == 2 or memory.read_u8(0x01FF00, "WRAM") == 4 then
				return 68 -- SMB1, SMB2J
			elseif memory.read_u8(0x01FF00, "WRAM") == 6 then
				return 69 -- SMB2U
			elseif memory.read_u8(0x01FF00, "WRAM") == 8 then
				return 68 -- SMB3
			elseif memory.read_u8(0x01FF00, "WRAM") == 10 then
				return 68 -- SMW
			else
				return nil
			end
		end,
		p1livesaddr=function()
			if memory.read_u8(0x01FF00, "WRAM") == 2 or memory.read_u8(0x01FF00, "WRAM") == 4 then
				return 0x00075A -- SMB1, SMB2J
			elseif memory.read_u8(0x01FF00, "WRAM") == 6 then
				return 0x0004EE -- SMB2U
			elseif memory.read_u8(0x01FF00, "WRAM") == 8 then
				return 0x000736 -- SMB3
			elseif memory.read_u8(0x01FF00, "WRAM") == 10 then
				return 0x000DBE -- SMW
			else
				return nil
			end
		end,
		p2livesaddr=function()
			if memory.read_u8(0x01FF00, "WRAM") == 2 then
				return 0x000761 -- SMB1
			elseif memory.read_u8(0x01FF00, "WRAM") == 8 then
				return 0x000737 -- SMB3
			elseif memory.read_u8(0x01FF00, "WRAM") == 10 then
				return 0x000DB5 -- SMW
			else
				return nil
			end
		end,
		ActiveP1=function()
			if (memory.read_u8(0x01FF00, "WRAM") == 2 or memory.read_u8(0x01FF00, "WRAM") == 4) then
				return memory.read_u8(0x00075A, "WRAM") > 0 and memory.read_u8(0x00075A, "WRAM") < 255 -- SMB1, SMB2J
			elseif memory.read_u8(0x01FF00, "WRAM") == 6 then
				return memory.read_u8(0x0004EE, "WRAM") > 0 and memory.read_u8(0x0004EE, "WRAM") < 255 -- SMB2U
			elseif memory.read_u8(0x01FF00, "WRAM") == 8 then
				return memory.read_u8(0x000736, "WRAM") > 0 and memory.read_u8(0x000736, "WRAM") < 255 -- SMB3
			elseif memory.read_u8(0x01FF00, "WRAM") == 10 then
				return memory.read_u8(0x000DB4, "WRAM") > 0 and memory.read_u8(0x000DBE, "WRAM") < 255 -- SMW
			else
				return false
			end
		end,
		ActiveP2=function()
			if memory.read_u8(0x01FF00, "WRAM") == 2 then
				return memory.read_u8(0x000761, "WRAM") > 0 and memory.read_u8(0x000761, "WRAM") < 255 -- SMB1
			elseif memory.read_u8(0x01FF00, "WRAM") == 8 then
				return memory.read_u8(0x000737, "WRAM") > 0 and memory.read_u8(0x000737, "WRAM") < 255 -- SMB3
			elseif memory.read_u8(0x01FF00, "WRAM") == 10 then
				return memory.read_u8(0x000DB5, "WRAM") > 0 and memory.read_u8(0x000DB5, "WRAM") < 255 -- SMB3
			else
				return false
			end
		end,
	},
	['SML1_GB']={ -- Super Mario Land, including DX hack for Game Boy Color
		func=sml1_swap,
		getsmlsize=function() return memory.read_u8(0x19, "HRAM") end,
		getlives=function() return
			math.floor(memory.read_u8(0x1A15, "WRAM")/16)*10 +
			(memory.read_u8(0x1A15, "WRAM") % 16)
		end, -- this is actually a hex value that just skips A-F on screen. Transformed.
		getgameover=function() return memory.read_u8(0x00A4, "WRAM") end,
		CanHaveInfiniteLives=true,
		p1livesaddr=function() return 0x1A15 end,
		LivesWhichRAM=function() return "WRAM" end,
		maxlives=function() return 106 end,
		ActiveP1=function() return memory.read_u8(0x1A15, "WRAM") > 0 and memory.read_u8(0x033C, "WRAM") < 255 end,
	},
	['SML2_GB']={ -- SMB 1 NES
		func=singleplayer_withlives_swap,
		p1gethp = function()
			if memory.read_u8(0x0216, "CartRAM") < 4 and memory.read_u8(0x0216, "CartRAM") > 1 then
				-- bunny = 2, fire flower = 3
				return 3
			else
				return memory.read_u8(0x0216, "CartRAM") + 1
				-- 1 is Big Mario/Luigi, 0 is small, 4+ is junk data, adding 1 to help with swap on small not relying on life lost
			end
		end,
		p1getlc=function() return
			math.floor(memory.read_u8(0x022C, "CartRAM")/16)*10 +
			(memory.read_u8(0x022C, "CartRAM") % 16)
		end, -- this is actually a hex value that just skips A-F on screen. Transformed.
		maxhp=function() return 3 end,
		gettogglecheck=function() return memory.read_u8(0x0266, "CartRAM") == 192 end, -- did the "load the map" timer just kick in?
		-- If you died suddenly as >Small Mario, your health will drop to Small Mario. Don't double swap!
		CanHaveInfiniteLives=true,
		p1livesaddr=function() return 0x022C end,
		LivesWhichRAM=function() return "CartRAM" end,
		maxlives=function() return 105 end,
		ActiveP1=function() return memory.read_u8(0x022C, "CartRAM") > 0 and memory.read_u8(0x022C, "CartRAM") < 255 end,
	},
	['SMW2YI_SNES']={ -- Super Mario World 2: Yoshi's Island
		func=iframe_health_swap,
		is_valid_gamestate=function() return
			(memory.read_u16_le(0x000118, "WRAM") >= 15 and memory.read_u16_le(0x000118, "WRAM") <= 20 )
			-- actively in a level or on retry screen
			or (memory.read_u16_le(0x000118, "WRAM") == 48)
			-- in a mini battle
		end,
		get_iframes=function() return memory.read_u8(0x000CCC, "WRAM") end,
		-- technically this is the recoil timer and not iframes, but otherwise we'd shuffle twice from piranha plants
		-- actual iframes at 0x01D6 CARTRAM
		other_swaps=function()
			-- touching a bandit changes baby state but not recoil or iframes
			-- getting eaten by a piranha plant changes baby state
			-- getting spat out by a piranha plant sets iframes but not recoil
			-- known issue: getting eaten while baby mario is already freefloating won't shuffle
			-- it's that or shuffling twice from piranhas (once on eat, once on spit out)
			local baby_status = memory.read_u16_le(0x01B2, "CARTRAM")
			local _, baby_safe_curr, baby_safe_prev = update_prev("baby_safe", baby_status == 0x2000 or baby_status == 0x8000)
			-- 0x0000 freefloating, 0x2000 super star, 0x4000 held by bandit/frog/etc, 0x8000 on yoshi's back
			if not baby_safe_curr and baby_safe_prev then
				return true
			end
			local lives_changed, lives_curr, lives_prev = update_prev("lives", memory.read_u8(0x000379, "WRAM"))
			return lives_changed and lives_curr < lives_prev
		end,
		-- - piranha plant notes
		-- loaded sprite ids in CARTRAM table starting at 0x1360, 96 bytes long
		-- piranha plant/hootie swallow timer in CARTRAM table starting at 0x1AF6, 96 bytes long
		-- position in sprite table and timer table doesn't match?
		-- figuring out relation (pointer?) would allow shuffling when eaten without baby
		-- piranha plant id 0x066, hootie clockwise 0x06D, hootie anticlockwise 0x06E
		-- - bonus game notes, if i ever add shuffling on them
		-- WRAM 0x0212: bonus id
		-- 0 flip cards, 2 scratch and match, 4 drawing lots, 6 match cards, 8 roulette, 10 slot machine
		-- WRAM 0x03A7: mini battle id
		-- 0/2/4 throwing balloons, 8 gather coins, 10/12 popping balloons, 18 watermelon contest
		-- already shuffle from recoil in gather coins and watermelon contest
		-- - flip cards
		-- WRAM 0x10F3: contents of latest card (10 = kamek), updated on button press
		-- WRAM 0x10F4: card flip animation, 65528 when done
		-- WRAM 0x1100: item count
		-- 0x10F3 == 10 and 0x10F4 == 65528 and 0x1100 > 0
		-- hit kamek with items in reserve
		-- - roulette
		-- WRAM 0x1179-0x117B: lives won (one byte per digit)
		-- WRAM 0x117F: end flag
		-- 0x1179 == 0, 0x117A == 0, 0x117B == 0, 0x117F == 1
		-- roulette ended with 0 lives
		-- need to disable lives check while in roulette
		-- - throwing balloons
		-- WRAM 0x1154: always 16 after losing?
	},
	['SM64_N64']={ -- Super Mario 64
		func=singleplayer_withlives_swap,
		p1gethp=function()
			if memory.read_u16_be(0x33B17E, "RDRAM") == 6440 or
				memory.read_u16_be(0x33B17E, "RDRAM") == 6442 or
				memory.read_u16_be(0x33B17E, "RDRAM") == 6444
			then
				-- these RAM values for "mario state" apply when Mario's being thrown out of a painting after death
				-- Mario's health gets set to 1 if he dies from falling/quicksand, not 0,
				-- so there will be two swaps (hp lost + life lost) unless we account for that
				return 0
			else
				return memory.read_u8(0x33B21E, "RDRAM")
			end
		end,
		p1getlc=function() return memory.read_u8(0x33B21D, "RDRAM") end,
		maxhp=function() return 8 end,
		delay=10, -- handles health ticking down from big falls, hits for >1 hp, etc.
		gmode=function() return memory.read_u8(0x33B173, "RDRAM") > 0 end, -- "mario status" variable, 0 if game hasn't started
		gettogglecheck=function() return
			memory.read_u8(0x33B173, "RDRAM") > 0
			-- Mario is in water or haze
			and memory.read_u8(0x33B21F, "RDRAM") >= 252
			-- we just reset the air timer - this should ignore health drops on losing air
			-- (0->FF on losing health, x4 speed in haze, x3 in ice water).
		end,
		CanHaveInfiniteLives=true,
		p1livesaddr=function() return 0x33B21D end,
		LivesWhichRAM=function() return "RDRAM" end,
		maxlives=function() return 69 end,
		ActiveP1=function() return memory.read_u8(0x33B173, "RDRAM") > 0 end,
	},
	['FZERO_SNES']={ -- F-ZERO, SNES
		func=singleplayer_withlives_swap,
		p1gethp=function() return memory.read_s16_le(0x00C9, "WRAM") end,
		p1getlc=function() return 1 end,
		-- health function will take care of lives.
		-- health drops to 0 on loading from losing a life (like when you go over a cliff).
		maxhp=function() return 2048 end,
		minhp=-40, -- F-ZERO health value can be negative, who knew...
		delay=30,
		-- because F-ZERO can drain health continuously on every frame,
		-- you want to build in some kind of sane delay before swapping.
		gmode=function() return
			memory.read_u8(0x0054, "WRAM") == 2 -- gamestate = "racing,"
			and memory.read_u8(0x0055, "WRAM") == 3 -- and the race has started
			and memory.read_u8(0x00C8, "WRAM") == 0 -- and invulnerability frames are done (0)
		end,
		gettogglecheck=function() return memory.read_u8(0x0054, "WRAM") end,
		-- if gamestate is being changed, sometimes health drops to 0, so don't swap on that frame

		--FUTURE POSSIBLE REVISION
		--func=fzero_snes_swap,
		--gethittingwall=function() return memory.read_u8(0x00F5, "WRAM") end,
		--getinvuln=function() return memory.read_u8(0x00C8, "WRAM") end,
		--getbump=function() return memory.read_u8(0x00E0, "WRAM") end,
		--delay=30, -- because F-ZERO can drain health continuously on every frame, you want to build in some kind of sane delay before swapping. WILL REQUIRE IMPLEMENTING A COUNTDOWN
		CanHaveInfiniteLives=true,
		LivesWhichRAM=function() return "WRAM" end,
		p1livesaddr=function() return 0x0059 end,
		maxlives=function() return 8 end,
		ActiveP1=function() return true end, -- p1 is always active!
	},
	['CV1_NES']={ -- Castlevania I, NES
		func=singleplayer_withlives_swap,
		p1gethp=function() return memory.read_u8(0x0045, "RAM") end,
		p1getlc=function() return memory.read_u8(0x002A, "RAM") end,
		maxhp=function() return 64 end,
		CanHaveInfiniteLives=true,
		LivesWhichRAM=function() return "RAM" end,
		MustDoInfiniteLivesOnFrame=function() return false end,
		p1livesaddr=function() return 0x002A end,
		maxlives=function() return 70 end,
		ActiveP1=function() return memory.read_u8(0x0045, "RAM") == 0 or memory.read_u8(0x0045, "RAM") == 64 end,
	},
	['CV2_NES']={ -- Castlevania II, NES
		func=iframe_health_swap,
		is_valid_gamestate=function()
			local gamestate = memory.read_u8(0x0018, "RAM")
			return gamestate >= 5 and gamestate <= 7
			-- 5 main game, 6 one frame on death, 7 game over
		end,
		get_iframes=function() return memory.read_u8(0x04F8, "RAM") end,
		get_health = function() return memory.read_u8(0x0080, "RAM") end,
		other_swaps=function()
			local lives_changed, lives_curr, lives_prev = update_prev("lives", memory.read_u8(0x0031, "RAM"))
			-- for some reason, non-game over deaths from enemy damage tick lives down in gamestate 5,
			-- damage game overs tick lives down in gamestate 7, and pit deaths tick lives down in gamestate 6
			-- damage deaths shuffle already, so only shuffle on lives dropping from falling in a pit
			return lives_changed and lives_curr < lives_prev and memory.read_u8(0x0018, "RAM") == 6
		end,
		CanHaveInfiniteLives=true,
		LivesWhichRAM=function() return "RAM" end,
		MustDoInfiniteLivesOnFrame=function() return true end,
		p1livesaddr=function() return 0x0031 end,
		maxlives=function() return 9 end,
		ActiveP1=function() return true end, -- p1 is always active!
	},
	['CV3_NES']={ -- Castlevania III, NES
		func=singleplayer_withlives_swap,
		p1gethp=function() return memory.read_u8(0x003C, "RAM") end,
		p1getlc=function() return
			math.floor(memory.read_u8(0x0035, "RAM")/16)*10 +
			(memory.read_u8(0x0035, "RAM") % 16)
			-- this is actually a hex value that just skips A-F on screen. Transformed.
		end,
		maxhp=function() return 64 end,
		CanHaveInfiniteLives=true,
		LivesWhichRAM=function() return "RAM" end,
		p1livesaddr=function() return 0x0035 end,
		maxlives=function() return 105 end,
		ActiveP1=function() return true end, -- p1 is always active!
	},
	['CV3_FAMI']={ -- Castlevania III, Famicom or NES-JP with English translation patch
		func=singleplayer_withlives_swap,
		p1gethp=function() return memory.read_u8(0x004A, "RAM") end,
		p1getlc=function() return
			math.floor(memory.read_u8(0x0037, "RAM")/16)*10 +
			(memory.read_u8(0x0037, "RAM") % 16)
			-- this is actually a hex value that just skips A-F on screen. Transformed.
		end,
		maxhp=function() return 64 end,
		CanHaveInfiniteLives=true,
		LivesWhichRAM=function() return "RAM" end,
		p1livesaddr=function() return 0x0037 end,
		maxlives=function() return 105 end,
		ActiveP1=function() return true end, -- p1 is always active!
	},
	['CV4_SNES']={ -- Super Castlevania IV, SNES
		func=singleplayer_withlives_swap,
		p1gethp=function() return memory.read_u8(0x0013F4, "WRAM") end,
		p1getlc=function() return memory.read_u8(0x00007C, "WRAM") end,
		maxhp=function() return 16 end,
		CanHaveInfiniteLives=true,
		LivesWhichRAM=function() return "WRAM" end,
		p1livesaddr=function() return 0x00007C end,
		maxlives=function() return 106 end,
		ActiveP1=function() return true end, -- p1 is always active!
	},
	['BLOODLINES_GEN']={ -- Castlevania: Bloodlines, Genesis
		func=singleplayer_withlives_swap,
		p1gethp=function() return memory.read_u8(0x9C11, "68K RAM") end,
		p1getlc=function() return memory.read_u8(0x9075, "68K RAM") end,
		-- this goes to 1 when death sequence starts, then drops to 0
		maxhp=function() return 80 end,
		CanHaveInfiniteLives=true,
		LivesWhichRAM=function() return "68K RAM" end,
		MustDoInfiniteLivesOnFrame=function() return true end,
		p1livesaddr=function() return 0xFB2F end,
		maxlives=function() return 105 end,
		ActiveP1=function() return true end, -- p1 is always active!
	},
	['DRACULAX_SNES']={ -- Dracula X, SNES
		func=singleplayer_withlives_swap,
		p1gethp=function() return memory.read_u16_le(0x0000A8, "WRAM") end,
		p1getlc=function() return
			math.floor(memory.read_u8(0x00009E, "WRAM")/16)*10 +
			(memory.read_u8(0x00009E, "WRAM") % 16)
			-- this is actually a hex value that just skips A-F on screen. Transformed.
		end,
		maxhp=function() return 64 end,
		CanHaveInfiniteLives=true,
		LivesWhichRAM=function() return "WRAM" end,
		p1livesaddr=function() return 0x00009E end,
		maxlives=function() return 105 end,
		ActiveP1=function() return true end, -- p1 is always active!
	},
	['RONDO_TG16']={ -- Rondo of Blood, TG16 CD
		func=singleplayer_withlives_swap,
		p1gethp=function() return memory.read_u8(0x0098, "Main Memory") end,
		p1getlc=function() return memory.read_u8(0x008D, "Main Memory") end,
		maxhp=function() return 92 end,
		gmode=function() return memory.read_u8(0x029C, "Main Memory") == 1 end,
		CanHaveInfiniteLives=true,
		LivesWhichRAM=function() return "Main Memory" end,
		p1livesaddr=function() return 0x008D end,
		maxlives=function() return 105 end,
		ActiveP1=function() return true end, -- p1 is always active!
	},
	["CV_SotN"]={ -- Symphony of the Night, Playstation
		func=sotn_swap,
		is_valid_gamestate=function()
			return memory.read_u8(0x03C9A4, "MainRAM") == 1 -- in game, but also some other places like the konami logo?
				and memory.read_u16_le(0x097BA4, "MainRAM") ~= 0 -- max hp, this should prevent incorrect swaps
		end,
		get_iframes=function() return memory.read_u16_le(0x13B5E8, "MainRAM") end,
		get_health=function() return memory.read_u16_le(0x097BA0, "MainRAM") end,
		is_richter=function()
			return memory.read_u8(0x0974A0, "MainRAM") == 31 -- richter prologue
				or memory.read_u8(0x03C9A0, "MainRAM") == 1 -- richter mode
		end,
	},
	['CV_AoS']={ -- Aria of Sorrow, GBA
		-- touching enemy during invincibility from final guard soul, julius backdash etc gives iframes despite not doing damage
		-- dryad seed and succubus grab are weird about iframes
		-- so forget the iframes
		-- dryad and succubus will shuffle you repeatedly but stop on their own over time
		func=health_swap,
		is_valid_gamestate=function()
			return memory.read_u8(0x000010, "EWRAM") == 4 -- in game
				and memory.read_u16_le(0x000E3C, "EWRAM") == 0 -- not paused, so eating rotten food won't swap
				-- there are multiple addresses that seem tied to pausing
				-- and memory.read_u16_le(0x00055C, "EWRAM") ~= 1 -- picking up heart/money gives 1 iframe, don't shuffle there
		end,
		-- get_iframes=function() return memory.read_u16_le(0x00055C, "EWRAM") end,
		get_health=function() return memory.read_u16_le(0x01327A, "EWRAM") end,
		other_swaps=function() return false end,
	},
	['CV_DoS']={ -- Dawn of Sorrow, DS
		-- checking for iframes to not swap on devil soul use etc
		func=iframe_health_swap,
		is_valid_gamestate=function() return memory.read_u8(0x0C07E8, "Main RAM") == 2 end,
		-- hopefully this works for julius/boss rush mode too, bizhawk won't let me import saves for ds games
		get_iframes=function() return memory.read_u8(0x0CA9F3, "Main RAM") end,
		get_health=function() return memory.read_u16_le(0x0F7410, "Main RAM") end,
		other_swaps=function() return false end,
	},
	['CV_PoR']={ -- Portrait of Ruin, DS
		func=jonathan_charlotte_swap,
		is_valid_gamestate=function() return memory.read_u8(0x0F6284, "Main RAM") == 2 end,
		-- hopefully this works for richter/sisters/etc too, bizhawk won't let me import saves for ds games
		is_jonathan=function() return memory.read_u8(0x1120E2, "Main RAM") == 1 end,
		get_jonathan_iframes=function() return memory.read_u8(0x0FCB45, "Main RAM") end,
		get_charlotte_iframes=function() return memory.read_u8(0x0FCCA5, "Main RAM") end,
		get_health=function() return memory.read_u16_le(0x11216C, "Main RAM") end,
	},
	['CV_OoE']={ -- Order of Ecclesia, DS
		-- checking for iframes to not swap on dominus etc (except on death)
		func=iframe_health_swap,
		is_valid_gamestate=function() return memory.read_u8(0x12872A, "Main RAM") == 3 end,
		-- hopefully this works for albus/boss rush mode too, bizhawk won't let me import saves for ds games
		get_iframes=function() return memory.read_u8(0x1098E5, "Main RAM") end,
		get_health=function() return memory.read_u16_le(0x1002B4, "Main RAM") end,
		other_swaps=function() return false end,
	},
	['MetroidNes']={ -- Metroid, NES
		-- bomb jumping sets iframes, so must check health too
		-- but health decreases one frame before iframes are set
		-- so only check health, and instead of iframes, consider lava/metroid states invalid
		-- update zero mission's nes mode if you change this
		func=health_swap,
		is_valid_gamestate=function()
			return memory.read_u8(0x001D, "RAM") == 0 -- in game
				and memory.read_u8(0x001E, "RAM") == 3 -- in game
				and ((memory.read_u8(0x0064, "RAM") == 0 -- not in lava/acid
						and memory.read_u8(0x0092, "RAM") == 0) -- not being drained by a metroid
					or memory.read_u16_le(0x0106, "RAM") == 0) -- 0 hp, want to shuffle on lava/metroid death
		end,
		-- get_iframes=function() return memory.read_u8(0x0070, "RAM") end,
		get_health=function() return memory.read_u16_le(0x0106, "RAM") end,
		-- technically this isn't your *actual* health, it's stored in decimal mode, but for our comparison purposes it works
		other_swaps=function()
			-- shuffle if escape timer runs out
			local time_up_changed, time_up_curr, _ = update_prev('time up', memory.read_u16_le(0x010A, "RAM") == 0xFF00)
			-- set to 0xFFFF when timer is off, counts down in decimal mode from 0x9999 while on, set to 0xFF00 when time runs out
			return time_up_changed and time_up_curr
		end,
	},
	['Metroid2']={
		func=iframe_health_swap,
		is_valid_gamestate=function() return memory.read_u8(0x1B, "HRAM") == 4 end,
		get_iframes=function() return memory.read_u8(0x104F, "WRAM") end,
		get_health=function() return memory.read_u16_le(0x1051, "WRAM") end,
		-- like nes metroid, health is stored in decimal mode
		other_swaps=function() return false end,
		-- no escape sequence this game
	},
	['MetroidFusion']={ -- Metroid Fusion, GBA
		func=iframe_health_swap,
		is_valid_gamestate=function()
			return memory.read_u8(0x0BDE, "IWRAM") == 1
				-- don't shuffle on omega metroid forced hit
				and not (memory.read_u8(0x002C, "IWRAM") == 0 -- area id: main deck
					and memory.read_u8(0x002D, "IWRAM") == 63 -- room id: omega metroid room
					and memory.read_u16_le(0x1310, "IWRAM") == 1 -- hp: omega metroid forced hit takes hp to 1
					and memory.read_u8(0x1249, "IWRAM") == 48) -- iframes: you should still shuffle from time up while at 1 hp
		end,
		get_iframes=function() return memory.read_u8(0x1249, "IWRAM") end,
		get_health=function() return memory.read_u16_le(0x1310, "IWRAM") end,
		iframe_minimum=function() return 10 end,
		-- SRX amoebas, TRO leech boss, TRO plant boss flowers, electric water
		-- all do damage with short iframes rather than skipping iframes entirely like lava/heat
		other_swaps=function()
			-- check if we ran out of time (sector 3, secret lab, ending)
			local time_up_changed, time_up_curr, _ = update_prev('time up', memory.read_u8(0x08D7, "IWRAM") == 2)
			-- 0: no timer, 1: timer on, 2: timer just ran out
			return time_up_changed and time_up_curr, 65
			-- add extra delay so you get the whiteout animation before shuffling
		end,
	},
	['MetroidZero']={
		func=iframe_health_swap,
		is_valid_gamestate=function()
			return memory.read_u8(0x0C70, "IWRAM") == 4 -- main game
				or memory.read_u8(0x0C70, "IWRAM") == 7 -- nes metroid
		end,
		get_iframes=function()
			if memory.read_u8(0x0C70, "IWRAM") == 7 then -- nes metroid
				return 0 -- don't use the main shuffle function in nes metroid
			end
			return memory.read_u8(0x13DA, "IWRAM")
		end,
		get_health=function()
			if memory.read_u8(0x0C70, "IWRAM") == 7 then -- nes metroid
				return 1 -- don't use the main shuffle function in nes metroid
			end
			return memory.read_u16_le(0x1536, "IWRAM")
		end,
		iframe_minimum=function() return 16 end,
		-- hp-draining purple bugs do 15 iframes, metroids do 3
		other_swaps=function()
			-- check if we ran out of time (mother brain, mecha-ridley)
			local time_up_changed, time_up_curr, _ = update_prev('time up', memory.read_u8(0x095C, "IWRAM") == 2)
			-- 0: no timer, 1: timer on, 2: timer just ran out
			if time_up_changed and time_up_curr then
				return true, 65
				-- add extra delay so you get the whiteout animation before shuffling
			end
			-- nes metroid shuffle, ram offsets are +0x7200 from nes version
			-- update nes metroid section if you change this
			--local nes_health_changed, nes_health_curr, nes_health_prev
			--local nes_time_up_changed, nes_time_up_curr
			if memory.read_u8(0x0C70, "IWRAM") == 7 then
				local nes_health_changed, nes_health_curr, nes_health_prev = update_prev('nes health', memory.read_u16_le(0x7306, "IWRAM"))
				local nes_time_up_changed, nes_time_up_curr, _ = update_prev('nes time up', memory.read_u16_le(0x730A, "IWRAM") == 0xFF00)
				return memory.read_u8(0x721D, "IWRAM") == 0 -- in game
					and memory.read_u8(0x721E, "IWRAM") == 3 -- in game
					and ((memory.read_u8(0x7264, "IWRAM") == 0 -- not in lava/acid
							and memory.read_u8(0x7292, "IWRAM") == 0) -- not being drained by a metroid
						or memory.read_u16_le(0x7306, "IWRAM") == 0) -- 0 hp, want to shuffle on lava/metroid death
					and ((nes_health_changed and nes_health_curr < nes_health_prev) -- hp dropped
						or (nes_time_up_changed and nes_time_up_curr)) -- escape timer ran out
			end
			return false
		end,
	},
	['Zelda_1']={ -- The Legend of Zelda, NES
		func=iframe_health_swap,
		is_valid_gamestate=function()
			local gamestate = memory.read_u8(0x0012, "RAM")
			return gamestate == 5 or gamestate == 17
			-- 5: main game, 17: dying (set same frame as health reaching 0)
		end,
		get_iframes=function() return memory.read_u8(0x04F0, "RAM") end,
		get_health=function()
			local fullHearts = bit.band(memory.read_u8(0x066F, "RAM"), 0x0F)
			-- other half of this byte tracks max health
			local partialHeart = memory.read_u8(0x0670, "RAM")
			return fullHearts * 0x100 + partialHeart
		end,
		other_swaps=function() return false end,
	},
	['MPAINT_DPAD_SNES']={ -- Gnat Attack in Mario Paint for SNES
		-- (I tested this with a version that can use the dpad for movement and face buttons for clicks)
		func=singleplayer_withlives_swap,
		p1gethp=function() return 0 end, -- we will always rely on lives, unless I need to do a sprite thing.
		p1getlc=function() return memory.read_u8(0x010018, "WRAM") end, -- hands remaining
		maxhp=function() return 6 end,
		gmode=function() return memory.read_u8(0x000206, "WRAM") == 0 end, -- 1 for painting, 0 for Gnat Attack
		CanHaveInfiniteLives=true, -- MAYBE THIS SHOULD BE AN OPTION
		LivesWhichRAM=function() return "WRAM" end,
		p1livesaddr=function() return 0x010018 end,
		maxlives=function() return 6 end,
		ActiveP1=function() return true end, -- p1 is always active!
	},
	['KIRBY_NES']={ -- Kirby's Adventure, NES
		func=singleplayer_withlives_swap,
		p1gethp=function() return (math.ceil((memory.read_u8(0x0597, "RAM")) % 255/8)) end,
		-- aside from 255 == death, HP is like Battletoads (7, 15, 23 ... 47)
		p1getlc=function() return memory.read_u8(0x0599, "RAM") end,
		maxhp=function() return 6 end,
		CanHaveInfiniteLives=true,
		LivesWhichRAM=function() return "RAM" end,
		p1livesaddr=function() return 0x0599 end,
		maxlives=function() return 69 end,
		ActiveP1=function() return true end, -- p1 is always active!
	},
	['DemonsCrest']={ -- Demon's Crest (SNES)
		func=demonscrest_swap,
		p1gethp=function() return memory.read_u8(0x1062, "WRAM") end,
		p1getliving=function() return memory.read_u8(0x00E7, "WRAM") end,
		p1getscene=function() return memory.read_u8(0x01FFFC, "WRAM") end, -- value changes on scene changes
		CanHaveInfiniteLives=false
	},
	['FamilyFeud_SNES']={ -- Family Feud (SNES)
		func=FamilyFeud_SNES_swap,
		getstrike=function() return memory.read_u8(0x020E, "WRAM") end,
		getwhichplayer=function() return memory.read_u8(0x08DF, "WRAM") end,
		CanHaveInfiniteLives=false
	},
	['Monopoly_NES']={ -- Monopoly (NES)
		func=Monopoly_NES_swap,
		delay=120,
		getInEditor=function() return memory.read_u8(0x0067, "RAM") end,
		-- if 1, we are editing the game before starting, so don't swap when money values change
		
		-- literally grabbing all the properties to know if they are owned/mortgaged/built up or not...
		-- I am sure there is a better, mathematical way to do this
		getSpace01=function() return memory.read_u8(0x039E, "RAM") end, -- Mediterranean Ave
		getSpace03=function() return memory.read_u8(0x03A0, "RAM") end, -- Baltic Ave
		getSpace05=function() return memory.read_u8(0x03A2, "RAM") end, -- Reading RR
		getSpace06=function() return memory.read_u8(0x03A3, "RAM") end, -- Oriental Ave
		getSpace08=function() return memory.read_u8(0x03A5, "RAM") end, -- Vermont Ave
		getSpace09=function() return memory.read_u8(0x03A6, "RAM") end, -- Connecticut Ave
		getSpace11=function() return memory.read_u8(0x03A8, "RAM") end, -- St. Charles Pl
		getSpace12=function() return memory.read_u8(0x03A9, "RAM") end, -- Electric Co
		getSpace13=function() return memory.read_u8(0x03AA, "RAM") end, -- States Ave
		getSpace14=function() return memory.read_u8(0x03AB, "RAM") end, -- Virginia Ave
		getSpace15=function() return memory.read_u8(0x03AC, "RAM") end, -- Pennsylvania RR
		getSpace16=function() return memory.read_u8(0x03AD, "RAM") end, -- St. James Pl
		getSpace18=function() return memory.read_u8(0x03AF, "RAM") end, -- Tennessee Ave
		getSpace19=function() return memory.read_u8(0x03B0, "RAM") end, -- New York Ave
		getSpace21=function() return memory.read_u8(0x03B2, "RAM") end, -- Kentucky Ave
		getSpace23=function() return memory.read_u8(0x03B4, "RAM") end, -- Indiana Ave
		getSpace24=function() return memory.read_u8(0x03B5, "RAM") end, -- Illinois Ave
		getSpace25=function() return memory.read_u8(0x03B6, "RAM") end, -- B&O RR
		getSpace26=function() return memory.read_u8(0x03B7, "RAM") end, -- Atlantic Ave
		getSpace27=function() return memory.read_u8(0x03B8, "RAM") end, -- Ventnor Ave
		getSpace28=function() return memory.read_u8(0x03B9, "RAM") end, -- Water Works
		getSpace29=function() return memory.read_u8(0x03BA, "RAM") end, -- Marvin Gardens
		getSpace31=function() return memory.read_u8(0x03BC, "RAM") end, -- Pacific Ave
		getSpace32=function() return memory.read_u8(0x03BD, "RAM") end, -- North Carolina Ave
		getSpace34=function() return memory.read_u8(0x03BF, "RAM") end, -- Pennsylvania Ave
		getSpace35=function() return memory.read_u8(0x03C0, "RAM") end, -- Short Line
		getSpace37=function() return memory.read_u8(0x03C2, "RAM") end, -- Park Place
		getSpace39=function() return memory.read_u8(0x03C4, "RAM") end, -- Boardwalk
		
		--DON'T SWAP ON ANY OF THESE
		--DEPRECATED
		--getUnowned=function() return memory.read_u8(0x005A, "RAM") end, -- if 21, player has rolled onto an unowned property.
		--getAuctioning=function() return memory.read_u8(0x04D2, "RAM") end, -- if 2, an auction is in progress.
		--getTradeAccepted=function() return memory.read_u8(0x0576, "RAM") + memory.read_u8(0x0577, "RAM") end, -- if 1 and 1, both have accepted the deal
		--getBuildingTimer=function() return memory.read_u8(0x0593, "RAM") end, -- if 1, someone bought houses/hotels and the building scene is about to happen
		
		-- PLAYER CASH TOTALS
		getp1Money=function() return memory.read_u8(0x03C5, "RAM")*10000 + memory.read_u8(0x03C6, "RAM")*1000 + memory.read_u8(0x03C7, "RAM")*100 + memory.read_u8(0x03C8, "RAM")*10 + memory.read_u8(0x03C9, "RAM") end,
		getp2Money=function() return memory.read_u8(0x03CA, "RAM")*10000 + memory.read_u8(0x03CB, "RAM")*1000 + memory.read_u8(0x03CC, "RAM")*100 + memory.read_u8(0x03CD, "RAM")*10 + memory.read_u8(0x03CE, "RAM") end,
		getp3Money=function() return memory.read_u8(0x03CF, "RAM")*10000 + memory.read_u8(0x03D0, "RAM")*1000 + memory.read_u8(0x03D1, "RAM")*100 + memory.read_u8(0x03D2, "RAM")*10 + memory.read_u8(0x03D3, "RAM") end,
		getp4Money=function() return memory.read_u8(0x03D4, "RAM")*10000 + memory.read_u8(0x03D5, "RAM")*1000 + memory.read_u8(0x03D6, "RAM")*100 + memory.read_u8(0x03D7, "RAM")*10 + memory.read_u8(0x03D8, "RAM") end,
		getp5Money=function() return memory.read_u8(0x03D9, "RAM")*10000 + memory.read_u8(0x03DA, "RAM")*1000 + memory.read_u8(0x03DB, "RAM")*100 + memory.read_u8(0x03DC, "RAM")*10 + memory.read_u8(0x03DD, "RAM") end,
		getp6Money=function() return memory.read_u8(0x03DE, "RAM")*10000 + memory.read_u8(0x03DF, "RAM")*1000 + memory.read_u8(0x03E0, "RAM")*100 + memory.read_u8(0x03E1, "RAM")*10 + memory.read_u8(0x03E2, "RAM") end,
		getp7Money=function() return memory.read_u8(0x03E3, "RAM")*10000 + memory.read_u8(0x03E4, "RAM")*1000 + memory.read_u8(0x03E5, "RAM")*100 + memory.read_u8(0x03E6, "RAM")*10 + memory.read_u8(0x03E7, "RAM") end,
		getp8Money=function() return memory.read_u8(0x03E8, "RAM")*10000 + memory.read_u8(0x03E9, "RAM")*1000 + memory.read_u8(0x03EA, "RAM")*100 + memory.read_u8(0x03EB, "RAM")*10 + memory.read_u8(0x03EC, "RAM") end,
		
		-- IS PLAYER HUMAN
		getp1Human=function() return memory.read_u8(0x033C, "RAM") end,
		getp2Human=function() return memory.read_u8(0x033D, "RAM") end,
		getp3Human=function() return memory.read_u8(0x033E, "RAM") end,
		getp4Human=function() return memory.read_u8(0x033F, "RAM") end,
		getp5Human=function() return memory.read_u8(0x0340, "RAM") end,
		getp6Human=function() return memory.read_u8(0x0341, "RAM") end,
		getp7Human=function() return memory.read_u8(0x0342, "RAM") end,
		getp8Human=function() return memory.read_u8(0x0343, "RAM") end,
		
		-- IS PLAYER IN JAIL - this goes up 1, 2, 3 for # turns in jail, 0 if you're out
		getp1InJail=function() return memory.read_u8(0x042C, "RAM") end,
		getp2InJail=function() return memory.read_u8(0x042D, "RAM") end,
		getp3InJail=function() return memory.read_u8(0x042E, "RAM") end,
		getp4InJail=function() return memory.read_u8(0x042F, "RAM") end,
		getp5InJail=function() return memory.read_u8(0x0430, "RAM") end,
		getp6InJail=function() return memory.read_u8(0x0431, "RAM") end,
		getp7InJail=function() return memory.read_u8(0x0432, "RAM") end,
		getp8InJail=function() return memory.read_u8(0x0433, "RAM") end,
		
		-- IS PLAYER BANKRUPT - 255 means player is out of the game, if it wasn't 255 to start with, they just went bankrupt
		getp1Bankrupt=function() return memory.read_u8(0x032C, "RAM") end,
		getp2Bankrupt=function() return memory.read_u8(0x032D, "RAM") end,
		getp3Bankrupt=function() return memory.read_u8(0x032E, "RAM") end,
		getp4Bankrupt=function() return memory.read_u8(0x032F, "RAM") end,
		getp5Bankrupt=function() return memory.read_u8(0x0330, "RAM") end,
		getp6Bankrupt=function() return memory.read_u8(0x0331, "RAM") end,
		getp7Bankrupt=function() return memory.read_u8(0x0332, "RAM") end,
		getp8Bankrupt=function() return memory.read_u8(0x0333, "RAM") end,
		
		CanHaveInfiniteLives=false
	},
	['BUBSY1_SNES']={ -- Bubsy in Claws Encounters of the Furred Kind, SNES
		func=singleplayer_withlives_swap,
		p1gethp=function() return 0 end ,
		p1getlc=function() return
			math.floor(memory.read_u8(0x020D, "WRAM")/16)*10 +
			(memory.read_u8(0x020D, "WRAM") % 16)
			-- this is actually a hex value that just skips A-F on screen. Transformed.
			end,
		maxhp=function() return 69 end,
		CanHaveInfiniteLives=true,
		LivesWhichRAM=function() return "WRAM" end,
		p1livesaddr=function() return 0x020D end,
		maxlives=function() return 104 end,
		ActiveP1=function() return true end, -- p1 is always active!
	},
}

local backupchecks = {
}

local function get_game_tag()
	-- try to just match the rom hash first
	local tag = get_tag_from_hash_db(gameinfo.getromhash(), 'plugins/chaos-shuffler-hashes.dat')
	if tag ~= nil and gamedata[tag] ~= nil then
		return tag
	end

	-- check to see if any of the rom name samples match
	local name = gameinfo.getromname()
	for _,check in pairs(backupchecks) do
		if check.test() then
			return check.tag
		end
	end

	return nil
end

local function BT_NES_Zitz_Override()
	if get_game_tag() == "BT_NES" -- unpatched Battletoads NES
		and memory.read_u8(0x000D, "RAM") == 11 -- in Clinger-Winger
		and memory.read_u8(0x0011, "RAM") ~= 255 -- Rash is alive
	then
		return true -- if all of those are true, then don't give Zitz all those lives, it'll more or less softlock you!
	end
	
	return false
end

function plugin.on_game_load(data, settings)
	prevdata = {}
	swap_scheduled = false
	shouldSwap = function() return false end
	
	local tag = tags[gameinfo.getromhash()] or get_game_tag()
	tags[gameinfo.getromhash()] = tag or NO_MATCH
	
	-- returns the number of games left in the shuffler
	-- this will be key for how infinite lives are handled at the end!
	local gamesleft = #(get_games_list(true))

	---------------
	-- For Battletoads games to do level skip/select based on filename
	----

	-- Which level to patch into on game load?
	-- Grab the first two characters of the filename, turned into a number.
	local which_level_filename = string.sub((tostring(config.current_game)),1,2)
	local which_level = which_level_filename

	-- if file name starts with a number outside of the expected range, reset the level to 1
	-- TODO: recode to accommodate different min and max levels (Battletoads SNES requires 00-08)
	-- I sure am great at coding!!
	-- consider moving function elsewhere if needed

	if type(tonumber(which_level)) == "number" then
		which_level = tonumber(which_level)
		-- BT_NES
		if get_game_tag(current_game) == "BT_NES" or get_game_tag(current_game) == "BT_NES_patched" then
			if which_level >13 or which_level <1 then
				which_level = 1
			end
		end
		-- BT_SNES
		if get_game_tag(current_game) == "BT_SNES" then
			if which_level >8 or which_level <1 then
				which_level = 1
			end
		end
		-- BTDD (both)
		if get_game_tag(current_game) == "BTDD_NES"
			or get_game_tag(current_game) == "BTDD_SNES"
			or get_game_tag(current_game) == "BTDD_SNES_patched"
		then
			if which_level >14 or which_level <1 then
				which_level = 1
			end
		end
	else
		which_level = 1
	end

	local levelnumber = tonumber(which_level)
	
	-- ONLY APPLY THESE TO RECOGNIZED GAMES
	-- ONLY APPLY THESE TO RECOGNIZED GAMES
	-- ONLY APPLY THESE TO RECOGNIZED GAMES
	
	-- TODO: set min and max level variable by game
	
	-- BATTLETOADS NES AND BATTLETOADS DOUBLE DRAGON NES
	if tag == "BT_NES" or tag == "BT_NES_patched" or tag == "BTDD_NES" then
		-- enable Infinite* Lives for Rash (p1) if checked
		if settings.InfiniteLives == true -- is Infinite* Lives enabled?
			and memory.read_u8(0x0011, "RAM") > 0 and memory.read_u8(0x0011, "RAM") < 255 -- is Rash on?
		then
			memory.write_u8(0x0011, 69, "RAM") -- if so, set lives to 69. Nice.
		end
	
		-- enable Infinite* Lives for Zitz (p2) if checked
		-- DOES NOT APPLY IF LEVEL = 11 AND ROM IS UNPATCHED
		if settings.InfiniteLives == true -- is Infinite* Lives enabled?
			and memory.read_u8(0x0012, "RAM") > 0 and memory.read_u8(0x0012, "RAM") < 255 -- is Zitz on?
		then
			if
				BT_NES_Zitz_Override() == false -- are we outside of the 2P/unpatched/on level 11 scenario?
			then -- if so, set lives to 69. Nice.
				memory.write_u8(0x0012, 127, "RAM")	
			elseif memory.read_u8(0x000D, "RAM") == 11 then
				memory.write_u8(0x0012, 0, "RAM") -- Otherwise, get Zitz to 0 lives immediately if you arrived at Clinger-Winger
			end
		end
	end
	
	if tag == "BT_NES" or tag == "BT_NES_patched" then
		-- if game was just loaded, these two addresses will = 255
		-- after starting or continuing, they get set to 40 or 0, respectively, and stay that way
		-- we now set these on game load, to let the player press start without sitting through the intro every time
		if memory.read_u8(0x00FD, "RAM") == 255 then
			memory.write_u8(0x00FD, 40, "RAM")
		end
		if memory.read_u8(0x00FE, "RAM") == 255 then
			memory.write_u8(0x00FE, 0, "RAM")
		end
	end
	
	-- Battletoads Double Dragon (SNES)
	if tag == "BTDD_SNES" or tag == "BTDD_SNES_patched" then
		-- TODO: Improve storage system for hp/lives addresses
		-- enable Infinite* Lives for p1 if checked
		if settings.InfiniteLives == true -- is Infinite* Lives enabled?
			and memory.read_u8(0x000026, "WRAM") > 0 and memory.read_u8(0x000026, "WRAM") < 255 -- is p1 on?
		then
			memory.write_u8(0x000026, 69, "WRAM") -- if so, set lives to 69. Nice.
		end
		-- enable Infinite* Lives for p2 if checked
		if settings.InfiniteLives == true -- is Infinite* Lives enabled?
			and memory.read_u8(0x000028, "WRAM") > 0 and memory.read_u8(0x000028, "WRAM") < 255 -- is p2 on?
		then
			memory.write_u8(0x000028, 69, "WRAM") -- if so, set lives to 69. Nice.
		end
	end
	
	if tag == "BTDD_SNES_patched" then
		if memory.read_u8(0x00001A, "WRAM") == 85 then -- if game just started
			gui.drawText(0, 0, "Pick " .. btdd_level_names[which_level] .. "!")
		end
	end

	if tag == "BTDD_SNES" then
		if memory.read_u8(0x00001A, "WRAM") == 85 then -- if game just started
			gui.drawText(0, 0, "Up Down Down Up X B Y A on char select (flash = ON)")
			gui.drawText(0, 20, "Pick " .. btdd_level_names[which_level] .. "!")
		end
	end
	
	-- Battletoads in Battlemaniacs (SNES)
	if tag == "BT_SNES" then
		-- enable Infinite* Lives for P1 (Pimple) if checked
		if settings.InfiniteLives == true -- is Infinite* Lives enabled?
			and memory.read_u8(0x000028, "WRAM") > 0 and memory.read_u8(0x000028, "WRAM") < 255 -- have we started playing?
		then
			memory.write_u8(0x000028, 69, "WRAM") -- if so, set lives to 69. Nice.
		end
		-- enable Infinite* Lives for P2 (Rash) if checked
		if settings.InfiniteLives == true -- is Infinite* Lives enabled?
			and memory.read_u8(0x00002A, "WRAM") > 0 and memory.read_u8(0x00002A, "WRAM") < 255 -- have we started playing?
		then
			memory.write_u8(0x00002A, 69, "WRAM") -- if so, set lives to 69. Nice.
		end
	end

	-- first time through with a bad match, tag will be nil
	-- can use this to print a debug message only the first time
	
	if tag ~= nil and tag ~= NO_MATCH then
		local gamemeta = gamedata[tag]
		local func = gamemeta.func
		shouldSwap = func(gamemeta)
		
		-- Infinite* Lives - set lives to max on game load
		local CanHaveInfiniteLives = gamemeta.CanHaveInfiniteLives
		
		if settings.InfiniteLives == true -- is infinite lives enabled?
			and CanHaveInfiniteLives == true -- can this game can do infinite lives?
		then
			local ActiveP1 = false
			if gamemeta.ActiveP1 then
				ActiveP1 = gamemeta.ActiveP1()
			end
			local ActiveP2 = false
			if gamemeta.ActiveP2 then
				ActiveP2 = gamemeta.ActiveP2()
			end
			local p1livesaddr = nil
			if gamemeta.p1livesaddr then
				p1livesaddr = gamemeta.p1livesaddr()
			end
			local p2livesaddr = nil
			if gamemeta.p2livesaddr then
				p2livesaddr = gamemeta.p2livesaddr()
			end
			local maxlives = nil
			if gamemeta.maxlives then
				maxlives = gamemeta.maxlives()
			end
			local LivesWhichRAM = nil
			if gamemeta.LivesWhichRAM then
				LivesWhichRAM = gamemeta.LivesWhichRAM()
			end
			
			-- enable Infinite* Lives for p1 if checked and able
			if ActiveP1 == true -- is p1 on?
				and p1livesaddr ~= nil -- is an address specified for p1?
			then -- if so, set lives to max specified
				if LivesWhichRAM ~= nil then
					memory.writebyte(p1livesaddr, maxlives, LivesWhichRAM)
				end
			end
			
			-- enable Infinite* Lives for p2 if checked and able
			if ActiveP2 == true -- is p1 on?
				and p2livesaddr ~= nil -- is an address specified for p1?
			then -- if so, set lives to max specified
				if LivesWhichRAM ~= nil then
					memory.writebyte(p2livesaddr, maxlives, LivesWhichRAM)
				end
			end
		end
	end

	-- log stuff
	if tag == "BT_NES" or tag == "BT_NES_patched" then
		if tonumber(which_level_filename) == nil or which_level ~= tonumber(which_level_filename) then
			if settings.SuppressLog ~= true then
				log_console(string.format('OOPS. Double-check that your file names start with a two-digit number from 01 to 13. Starting you on Level 1. File name is ' .. tostring(config.current_game)))
			end
		else
			log_console('Level ' .. tostring(which_level) .. ': ' ..  bt_nes_level_names[which_level] .. ' (' .. tag .. ')')
		end
	elseif tag == "BTDD_NES" or tag == "BTDD_SNES" or tag == "BTDD_SNES_patched" then
		if tonumber(which_level_filename) == nil or which_level ~= tonumber(which_level_filename) then
			if settings.SuppressLog ~= true then
				log_console(string.format('OOPS. Double-check that your file names start with a two-digit number from 01 to 14. Starting you on Level 1. File name is ' .. tostring(config.current_game)))
			end
		else
			log_console('Level ' .. btdd_level_names[which_level] .. ' (' .. tag .. ')')
		end
	elseif tag == "BT_SNES" then
		if tonumber(bt_snes_level_recoder[tonumber(which_level_filename)]) == nil then
			if settings.SuppressLog ~= true then
				log_console(string.format('OOPS. Double-check that your file names start with a two-digit number from 01 to 08. Starting you on Level 1. File name is ' .. tostring(config.current_game)))
			end
		else
			log_console('Level ' .. tostring(which_level) .. ': ' ..  bt_snes_level_names[which_level] .. ' (' .. tag .. ')')
		end
	elseif tag == nil or tag == NO_MATCH then
		if settings.SuppressLog ~= true then
			log_console(string.format('Chaos Shuffler: unrecognized? %s (%s)',
			gameinfo.getromname(), gameinfo.getromhash()))
		end
	elseif tag ~= nil then
		log_console('Chaos Shuffler: recognized as ' .. string.format(tag))
	end
end

function plugin.on_frame(data, settings)
	
	-- we have to grab the game's tags to know whether to do level skipping, infinite lives on frame, etc.
	local tag = get_game_tag()
	local gamemeta = gamedata[tag]
	
	-- Which level to patch into on game load?
	-- Grab the first two characters of the filename, turned into a number.
	local which_level_filename = string.sub((tostring(config.current_game)),1,2)
	local which_level = tonumber(which_level_filename)

	-- run the check method for each individual game
	if swap_scheduled then return end
	
	-- AND NOW WE SWAP
	local schedule_swap, delay = shouldSwap(prevdata)
	if schedule_swap and frames_since_restart > math.max(settings.grace, 10) then -- avoiding super short swaps (<10) as a precaution
		swap_game_delay(delay or 3)
		swap_scheduled = true
	end
	
	if tag ~= nil and tag ~= NO_MATCH then
		-- Infinite* Lives ON FRAME - set lives to max on frame when we are either on the last game or in a game that requires it
		local MustDoInfiniteLivesOnFrame = false
		if gamemeta.MustDoInfiniteLivesOnFrame then MustDoInfiniteLivesOnFrame = gamemeta.MustDoInfiniteLivesOnFrame() end
		
		if settings.InfiniteLives == true -- is infinite lives enabled?
			and
				(MustDoInfiniteLivesOnFrame == true -- can this game can do infinite lives only on frame?
				or gamesleft == 1) -- are we in the last game left in the shuffler?
		then
			local ActiveP1 = false
			if gamemeta.ActiveP1 then
				ActiveP1 = gamemeta.ActiveP1()
			end
			local ActiveP2 = false
			if gamemeta.ActiveP2 then
				ActiveP2 = gamemeta.ActiveP2()
			end
			local p1livesaddr = nil
			if gamemeta.p1livesaddr then
				p1livesaddr = gamemeta.p1livesaddr()
			end
			local p2livesaddr = nil
			if gamemeta.p2livesaddr then
				p2livesaddr = gamemeta.p2livesaddr()
			end
			local maxlives = nil
			if gamemeta.maxlives then
				maxlives = gamemeta.maxlives()
			end
			local LivesWhichRAM = nil
			if gamemeta.LivesWhichRAM then
				LivesWhichRAM = gamemeta.LivesWhichRAM()
			end
		
			-- enable Infinite* Lives for p1 if checked and able
			if ActiveP1 == true -- is p1 on?
				and p1livesaddr ~= nil -- is an address specified for p1?
			then -- if so, let's figure out whether to set lives to max specified
				if LivesWhichRAM ~= nil then
					if memory.readbyte(p1livesaddr, LivesWhichRAM) < maxlives
						and not
						(memory.readbyte(p1livesaddr, LivesWhichRAM) ~= (maxlives - 1) and swap_scheduled == true)
						-- let 1 frame with lives < maxlives slip through so we swap on deaths
					then
						memory.writebyte(p1livesaddr, maxlives, LivesWhichRAM)
					end
				end
			end
	
			-- enable Infinite* Lives for p2 if checked and able
			if ActiveP2 == true -- is p1 on?
				and p2livesaddr ~= nil -- is an address specified for p1?
			then -- if so, let's figure out whether to set lives to max specified
				if LivesWhichRAM ~= nil then
					if memory.readbyte(p2livesaddr, LivesWhichRAM) < maxlives
						and not memory.readbyte(p2livesaddr, LivesWhichRAM) ~= (maxlives - 1)
						-- let 1 frame with lives < maxlives slip through so we swap on deaths
					then
						memory.writebyte(p2livesaddr, maxlives, LivesWhichRAM)
					end
				end
			end
		end

		-- Battletoads NES
		
		-- CLINGER-WINGER SPEED
		-- This enables the Game Genie code for always moving at max speed in Clinger Winger.
		-- The bugfix makes this not work! This will only work on an unpatched ROM. The proper, non-patched tag handles this.
		if tag == "BT_NES" then
			if settings.ClingerSpeed == true and memory.read_u8(0x000D, "RAM") == 11 and memory.read_u8(0xA706, "System Bus") == 5 then
				memory.write_u8(0xA706, 0, "System Bus")
			end
		end
		
		-- Set the memory value that represents the starting stage to the number specified by the file name.
		if tag == "BT_NES" or tag == "BT_NES_patched" then
			if which_level ~= nil and memory.read_u8(0x8320, "System Bus") ~= which_level then
				-- double check that less than/equal to gets desired effect
				memory.write_u8(0x8320, which_level, "System Bus")
			end
		end
		
		-- Battletoads Double Dragon NES
		
		-- Set the memory value that represents the starting stage to the number specified by the file name.
		if tag == "BTDD_NES" then
			if which_level ~= nil -- just started the game!
			then
				if memory.read_u8(0x0017, "RAM") == 0 then
					gui.drawText(0, 0, "Level select enabled, select " .. btdd_level_names[which_level] .. "!")
					-- give the level instruction
				end
				memory.write_u8(0x0017, 10, "RAM") -- then set Level Cheat Code to ON
			end
		end
		
		-- Battletoads in Battlemaniacs (SNES)
		
		-- Setting the level variable only works on a continue. Stupid but true! You'll just enter a glitched first level otherwise.
		-- So, time for Pimple to die ASAP if you chose a level other than the first one.
		
		if tag == "BT_SNES" then
			-- if current level < which_level, then
			-- set lives to 0
			-- set health to (if >1, 1, else don't touch)
			-- once a continue is used, set level to which_level
			
			-- set the value for level properly
			local BT_SNES_level_for_memory = bt_snes_level_recoder[which_level]
			
			if (which_level ~= nil and which_level > 1) or settings.BTSNESRash == true then
				-- if level specified and not the first level, or we want to play as Rash
				if memory.read_u8(0x00002C, "WRAM") == 0 then
					-- we are on the first level
					if memory.read_u8(0x000E5E, "WRAM") > 16 then
						gui.drawText(0, 0, "Deathwarp to " .. bt_snes_level_names[which_level] .. "!")
						-- write message only when Pimple hasn't yet game-overed, so there is a garbage number for health
					end
					if memory.read_u8(0x00002E, "WRAM") == 1 then
						-- Pimple just lost a continue
						memory.write_u8(0x00002C, BT_SNES_level_for_memory, "WRAM")
						-- overwrite level, and you're good to go.
						memory.write_u8(0x00002E, 3, "WRAM")
						-- bump the continue count above 2 to avoid an extra swap
					elseif memory.read_u8(0x00002E, "WRAM") == 2 then
						-- otherwise, if we just started the game and did specify a different level in the filename,
						memory.write_u8(0x000028, 0, "WRAM")
						-- set Pimple's lives to 0
						if memory.read_u8(0x000E5E, "WRAM") > 1 then
							memory.write_u8(0x000E5E, 0, "WRAM")
							-- set Pimple's health to 0
							swap_scheduled = false
							-- override the swap being scheduled for a health drop
						end
					end
				end
				
				if memory.read_u8(0x00002C, "WRAM") > 0
					and memory.read_u8(0x00002C, "WRAM") == BT_SNES_level_for_memory
					and memory.read_u8(0x00002E, "WRAM") > 2
				then
					memory.write_u8(0x00002E, 2, "WRAM")
					-- fix Pimple's continue count once you get into the correct level.
				end
			end
		end
		
		-- Super Mario Kart
		if tag == "SMK_SNES" then
			-- enable Infinite* continues for both players if checked
			if settings.InfiniteLives == true -- is Infinite* Lives enabled?
				and memory.read_u8(0x000154, "WRAM") > 0 and memory.read_u8(0x000154, "WRAM") < 4 -- have we started playing?
			then
				memory.write_u8(0x000154, 4, "WRAM") -- if so, set p1 continues to 4.
			end
			
			if settings.InfiniteLives == true -- is Infinite* Lives enabled?
				and memory.read_u8(0x000156, "WRAM") > 0 and memory.read_u8(0x000156, "WRAM") < 4 -- have we started playing?
			then
				memory.write_u8(0x000156, 4, "WRAM") -- if so, set p2 continues to 4.
			end
		end
		
		if tag == "MPAINT_DPAD_SNES" and memory.read_u8(0x000206) == 1 then
			-- give the player some Gnat Attack instructions!
			gui.drawText(0,0,"GNAT ATTACK! Dpad moves, face buttons click, hold one/both of L/R to go fast", "green")
		end
	end
end

return plugin