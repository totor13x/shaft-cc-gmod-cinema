//game.AddParticles( "particles/cinema_fx.pcf" )
//PrecacheParticleSystem( "cn_rain" )

Location.Add( "cinema_lidisu",
{

	[ "Public" ] =
	{	
		Min = Vector( 616.63525390625, 3133.8029785156, 225.04273986816 ),
		Max = Vector( 2765.7429199219, 5501.3447265625, 1210.7485351563 ),
	},

	[ "Красный зал" ] =
	{
		Min = Vector( 4030.8947753906, 3250.0244140625, 220.61395263672 ),
		Max = Vector( 6033.1728515625, 5251.9663085938, 1051.0014648438 ),
	},
	
	[ "Private 2" ] =
	{	
		Min = Vector( 399.22497558594, 545.28662109375, 416.85485839844 ),
		Max = Vector( 817.06805419922, 1057.0484619141, 623.94140625 ),

	},
	[ "Private 1" ] =
	{
		Min = Vector( 821.70611572266, 543.46118164063, 454.26913452148 ),
		Max = Vector( 1230.3583984375, 1063.3333740234, 620.04437255859 ),
	},
	[ "Private 3" ] =
	{
		Min = Vector( 1349.5164794922, 550.91375732422, 450.15026855469 ),
		Max = Vector( 1758.3541259766, 1033.0888671875, 629.87481689453 ),
	},
	[ "Private 4" ] =
	{	
		Min = Vector( 1765.0411376953, 548.75567626953, 409.70733642578 ),
		Max = Vector( 2193.5832519531, 1050.5006103516, 615.62512207031 ),

	},


} )
/*
if SERVER then
	
	local UseCooldown = 0.3 -- seconds
	hook.Add( "PlayerUse", "PrivateTheaterLightSwitch", function( ply, ent )

		if ply.LastUse and ply.LastUse + UseCooldown > CurTime() then
			return false
		end

		-- Always admit admins
		if ply:IsAdmin() then return true end

		-- Only private theater owners can switch the lights
		local Theater = ply:GetTheater()
		if Theater and Theater:IsPrivate() and ent:GetClass() == "func_button" then

			ply.LastUse = CurTime()

			if Theater:GetOwner() != ply then
				Theater:AnnounceToPlayer( ply, 'Theater_OwnerUseOnly' )
				return false
			end

		end

		return true

	end )

end
*/