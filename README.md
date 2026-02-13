# GKS Goodies - Extras and balancing for gamemodes

It's the main file that GKS Racing Server and GKS RS Revolution Server was using for Sonic Robo Blast 2, now serves for many purposes!

The point of this Sonic Robo Blast 2 addon is to overall make the gamemodes and netgame experience interesting and visually good with less intrusive features intended to be compatible with any kind of server such for custom gametypes or vanilla. And also some server utilities.

## What does it contain?

- **Interactive Menu** (made with [MenuLib](https://github.com/luigi-budd/MenuLib) by luigi budd) . can be opened with `gd_menu`
- **Bubbles status**. Each player will spawn a chat bubble or a settings icon depending if the player is on the menu or is chatting. Cool detail!
- **Tips**. You can set your own quantity of tip messages that helps new players to understand the advantages and functions in the server.
- **Team color variants.** Isn't that boring that your team carries a single color? well, not anymore! with this addon you can see your mates with red/blue variants.
- **Overtime and low time music.** on time limit or point limit gamemodes, the music will change according to the situation such as match point, 30 seconds left or overtime. Also applies on Race gametypes when a player finishes the race and the countdown shows up, makes an earthquake and changes the music. This is not available on BattleMod since already counts one.
- **Visual features** like flag carrying, score visuals on captured flag (from BattleMod), etc.
- **[Race] Non-spin headstart**. Kinda annoying when spin characters are the only ones who can do a headstart with spindash. let's give non-spin characters a chance! You can disable this feature if desired.
- **[Race] Character voices** for all vanilla characters, also supports custom characters via external script. you can turn on or off with `race_charactervoices` command.
- **[Race] start music** like in Mario Kart, a racing start music will be played on each map load.
- **[Race] Damage prevention on countdown.** If you don't like this feature, you can disable it with `race_countdowndamage`

## Commands

`gd_menu` opens an interactive menu that can be handled with the mouse only. here you can handle the rest of the commands through a menu. <br></br>
`race_charactervoices` toggles character voices when the player is on countdown or the player finishes the race. <br></br>
The following commands only applies on the next map load<br></br>
`match_timelimit` sets the timelimit for all ringslinger gametypes <br></br>
`match_pointlimit` sets the pointlimit for all ringslinger gametypes <br></br>
`tag_timelimit` sets the timelimit for all tag gametypes <br></br>
`tag_pointlimit` sets the pointlimit for all tag gametypes <br></br>
`hs_timelimit` sets the timelimit for all hide and seek gametypes <br></br>
`hs_pointlimit` sets the pointlimit for all hide and seek gametypes <br></br>
`hs_timelimit` sets the timelimit for all hide and seek gametypes <br></br>
`default_timelimit` sets the timelimit for all gametypes if available <br></br>
`default_pointlimit` sets the pointlimit for all hide and seek gametypes <br></br>

## How to build

- Open up [SLADE3](https://slade.mancubus.net/index.php?page=downloads)
- Go to File - Open Directory
- Navigate and open the **src** folder found in the repo
- Go to Archive - Build Archive
- Save the file as a **PK3** with a desired name
- **Ready to test it out!**
