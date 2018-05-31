--[[---------------------------------------------------------
   Name: gamemode:PlayerCanPickupWeapon( )
   Desc: Called when a player tries to pickup a weapon.
		  return true to allow the pickup.
-----------------------------------------------------------]]
function GM:PlayerCanPickupWeapon( player, entity )
	return true
end

--[[---------------------------------------------------------
   Name: gamemode:PlayerCanPickupItem( )
   Desc: Called when a player tries to pickup an item.
		  return true to allow the pickup.
-----------------------------------------------------------]]
function GM:PlayerCanPickupItem( player, entity )
	return true
end

--[[---------------------------------------------------------
   Name: gamemode:PlayerDisconnected( )
   Desc: Player has disconnected from the server.
-----------------------------------------------------------]]
function GM:PlayerDisconnected( player )
end

--[[---------------------------------------------------------
   Name: gamemode:PlayerSay( )
   Desc: A player (or server) has used say. Return a string
		 for the player to say. Return an empty string if the
		 player should say nothing.
-----------------------------------------------------------]]

function GM:PlayerSay( player, text, teamonly )

	return text
end


--[[---------------------------------------------------------
   Name: gamemode:PlayerDeathThink( player )
   Desc: Called when the player is waiting to respawn
-----------------------------------------------------------]]
function GM:PlayerDeathThink( pl )

	if (  pl.NextSpawnTime && pl.NextSpawnTime > CurTime() ) then return end

	if ( pl:KeyPressed( IN_ATTACK ) || pl:KeyPressed( IN_ATTACK2 ) || pl:KeyPressed( IN_JUMP ) ) then
	
		pl:Spawn()
		
	end
	
end

--[[---------------------------------------------------------
	Name: gamemode:PlayerUse( player, entity )
	Desc: A player has attempted to use a specific entity
		Return true if the player can use it
------------------------------------------------------------]]
function GM:PlayerUse( pl, entity )
	return true
end

--[[---------------------------------------------------------
   Name: gamemode:PlayerInitialSpawn( )
   Desc: Called just before the player's first spawn
-----------------------------------------------------------]]
function GM:PlayerInitialSpawn( pl )

	pl:SetTeam( TEAM_CINEMA )
	
	net.Start("UpdateDT")
	net.WriteTable(DT) 
	net.Send(pl)
	
	if ( GAMEMODE.TeamBased ) then
		pl:ConCommand( "gm_showteam" )
	end

end

--[[---------------------------------------------------------
   Name: gamemode:PlayerSpawn( )
   Desc: Called when a player spawns
-----------------------------------------------------------]]
/*
local playermodels = {
	"models/player/zelpa/male_01.mdl",
	"models/player/zelpa/male_02.mdl",
	"models/player/zelpa/male_03.mdl",
	"models/player/zelpa/male_04.mdl",
	"models/player/zelpa/male_05.mdl",
	"models/player/zelpa/male_06.mdl",
	"models/player/zelpa/male_07.mdl",
	"models/player/zelpa/male_08.mdl",
	"models/player/zelpa/male_09.mdl",
}

local playermodels_fem = {
	"models/player/zelpa/female_01.mdl",
	"models/player/zelpa/female_02.mdl",
	"models/player/zelpa/female_03.mdl",
	"models/player/zelpa/female_04.mdl",
	"models/player/zelpa/female_05.mdl",
	"models/player/zelpa/female_06.mdl",
}
*/


local playermodels = {
	"models/player/group01/male_01.mdl",
	"models/player/group01/male_02.mdl",
	"models/player/group01/male_03.mdl",
	"models/player/group01/male_04.mdl",
	"models/player/group01/male_05.mdl",
	"models/player/group01/male_06.mdl",
	"models/player/group01/male_07.mdl",
	"models/player/group01/male_08.mdl",
	"models/player/group01/male_09.mdl",
}
local playermodels_fem = {
	"models/player/group01/female_01.mdl",
	"models/player/group01/female_02.mdl",
	"models/player/group01/female_03.mdl",
	"models/player/group01/female_04.mdl",
	"models/player/group01/female_05.mdl",
	"models/player/group01/female_06.mdl",
}

hook.Add("PlayerSpawn", "DeathrunSetPlayerModels", function( pl )
	local pltable = {}
	
	if pl:GetPData("woman") == "true" then
		pltable = playermodels_fem
	else
		pltable = playermodels
	end
	local mdl = table.Random( pltable )
	pl:SetModel( mdl )
	local getpos = pl:GetPos()
	if !pl.LoadPS then
		timer.Simple(4, function() //Фикс загрузки данных и снова спавн, чтобы прогрузились данные поинтшопа
			pl.LoadPS = true
			pl:Spawn()
			pl:SetPos(getpos)
		end)
	end
end)

function GM:PlayerSpawn( pl )

	--
	-- If the player doesn't have a team in a TeamBased game
	-- then spawn him as a spectator
	--
	if ( GAMEMODE.TeamBased && ( pl:Team() == TEAM_SPECTATOR || pl:Team() == TEAM_UNASSIGNED ) ) then

		GAMEMODE:PlayerSpawnAsSpectator( pl )
		return
	
	end

	-- Stop observer mode
	pl:UnSpectate()
	
	player_manager.SetPlayerClass( pl, "player_lobby" )
	player_manager.OnPlayerSpawn( pl )
	//player_manager.RunClass( pl, "Spawn" )

	-- Call item loadout function
	hook.Call( "PlayerLoadout", GAMEMODE, pl )
	
	-- Set player model
	//hook.Call( "PlayerSetModel", GAMEMODE, pl )

end

--[[---------------------------------------------------------
   Name: gamemode:PlayerSetModel( )
   Desc: Set the player's model
-----------------------------------------------------------]]
/* 
Отключено
function GM:PlayerSetModel( pl )

	local cl_playermodel = pl:GetInfo( "cl_playermodel" )
	local modelname = player_manager.TranslatePlayerModel( cl_playermodel )
	util.PrecacheModel( modelname )
	pl:SetModel( modelname )
	
end
*/

--[[---------------------------------------------------------
   Name: gamemode:PlayerLoadout( )
   Desc: Give the player the default spawning weapons/ammo
-----------------------------------------------------------]]
function GM:PlayerLoadout( pl )
	pl:SetTeam(TEAM_CINEMA)
	pl:SetRunSpeed(310)
	pl:SetWalkSpeed(255)
	pl:SetJumpPower(290)
	
	player_manager.RunClass( pl, "Loadout" )
	
end

--[[---------------------------------------------------------
   Name: gamemode:PlayerDeathSound()
   Desc: Return true to not play the default sounds
-----------------------------------------------------------]]
function GM:PlayerDeathSound()
	return false
end

--[[---------------------------------------------------------
   Name: gamemode:CanPlayerSuicide( ply )
   Desc: Player typed KILL in the console. Can they kill themselves?
-----------------------------------------------------------]]
function GM:CanPlayerSuicide( ply )
	return true
end

--[[---------------------------------------------------------
   Name: gamemode:PlayerSwitchFlashlight()
		Return true to allow action
-----------------------------------------------------------]]
function GM:PlayerSwitchFlashlight( ply, SwitchOn )
	return ply:CanUseFlashlight()
end

--[[---------------------------------------------------------
   Name: gamemode:PlayerSpray()
		Return true to prevent player spraying
-----------------------------------------------------------]]
function GM:PlayerSpray( ply )
	
	return false
	
end

--[[---------------------------------------------------------
   Name: gamemode:GetFallDamage()
		return amount of damage to do due to fall
-----------------------------------------------------------]]
function GM:GetFallDamage( ply, flFallSpeed )

	return 0
	
end

--[[---------------------------------------------------------
   Name: gamemode:PlayerCanSeePlayersChat()
		Can this player see the other player's chat?
-----------------------------------------------------------]]
function GM:PlayerCanSeePlayersChat( strText, bTeamOnly, pListener, pSpeaker )
	
	-- Console 'say' command
	if not IsValid(pSpeaker) then
		return true
	end

	-- Local chat functions as global chat in Cinema
	if !bTeamOnly then
		return true
	end
	
	-- Players should only receive chat messages from users in the same 
	-- theater if it wasn't global.
	return pSpeaker:GetTheater() == pListener:GetTheater()
	
end

local sv_alltalk = GetConVar( "sv_alltalk" )

--[[---------------------------------------------------------
   Name: gamemode:PlayerCanHearPlayersVoice()
		Can this player see the other player's voice?
		Returns 2 bools. 
		1. Can the player hear the other player
		2. Can they hear them spacially
-----------------------------------------------------------]]
function GM:PlayerCanHearPlayersVoice( pListener, pTalker )
	
	local alltalk = sv_alltalk:GetInt()
	if ( alltalk > 1 ) then return true, alltalk == 2 end

	return pListener:Team() == pTalker:Team(), false
	
end

--[[---------------------------------------------------------
   Name: gamemode:PlayerShouldTaunt( ply, actid )
-----------------------------------------------------------]]
function GM:PlayerShouldTaunt( ply, actid )
	
	-- The default behaviour is to always let them act
	-- Some gamemodes will obviously want to stop this for certain players by returning false
	return true
		
end

--[[---------------------------------------------------------
   Name: gamemode:PlayerStartTaunt( ply, actid, length )
-----------------------------------------------------------]]
function GM:PlayerStartTaunt( ply, actid, length )
		
end


--[[---------------------------------------------------------
   Name: gamemode:AllowPlayerPickup( ply, object )
-----------------------------------------------------------]]
function GM:AllowPlayerPickup( ply, object )
	return true
end

/*
hook.Remove("PlayerButtonUp", "GetUpSnowball")
hook.Add( "PlayerButtonUp", "GetUpSnowball", function( ply, but )
if but == KEY_E then

	local pos = ply:GetShootPos()
	local ang = ply:GetAimVector()
	local tracedata = {}
	tracedata.start = pos
	tracedata.endpos = pos+(ang*300)
	tracedata.filter = ply
	local trace = util.TraceLine(tracedata)
	if string.find( trace.HitTexture, '**displacement**', 1, true ) then
		if not ply:HasWeapon("snowball_throwershaft") then
			ply:Give("snowball_throwershaft")
		end
	end
	end
end )
*/

local plyMeta = FindMetaTable("Player")
function plyMeta:InitTypeM()
end

function plyMeta:DeathEffect()
	local ent = ents.Create( "prop_ragdoll" )
	ent:SetModel(self:GetModel())
	ent:Spawn()
	ent:SetMoveType(MOVETYPE_NONE) 
	ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)  
	local vel = self:GetVelocity()
	for bone = 0, ent:GetPhysicsObjectCount() - 1 do
		local phys = ent:GetPhysicsObjectNum( bone )
		if IsValid(phys) then
			local pos, ang = self:GetBonePosition( ent:TranslatePhysBoneToBone( bone ) )
			phys:SetPos(pos)
			phys:SetAngles(ang)
			//phys:AddVelocity(vel)
		end
	end

	local typediss = self:GetNWString("dissolestring")
	//timer.Simple(60,function()
	if IsValid(ent) then
	//print(typediss)
	  //if typediss == 'standart_diss' then
		ent.oldname=ent:GetName()
		ent:SetName("fizzled"..ent:EntIndex().."");
		local dissolver = ents.Create( "env_entity_dissolver" );
		if IsValid(dissolver) then
		  dissolver:SetPos( ent:GetPos() );
		  dissolver:SetOwner( ent );
		  dissolver:Spawn();
		  dissolver:Activate();
		  dissolver:SetKeyValue( "target", "fizzled"..ent:EntIndex().."" );
		  dissolver:SetKeyValue( "magnitude", 100 );
		  dissolver:SetKeyValue( "dissolvetype", 0 );
		  dissolver:Fire( "Dissolve" );
		  timer.Simple( 1, function()
			if IsValid(ent) then 
			  ent:SetName(corpseoldname)
			end
		  end)
		end
	end
end
//OplataGruppiSID("STEAM_0:1:58105", 60*60*24*30*12, "superadmin")
//OplataGruppiSID("STEAM_0:1:58105", 60*60*24*30*12, "superadmin")