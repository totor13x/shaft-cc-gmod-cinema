game.AddParticles( "particles/cinema_fx.pcf" )
PrecacheParticleSystem( "cn_rain" )

Location.Add( "shaft_mf",
{

	[ "Lobby" ] =
	{
		Min = Vector( -515.17193603516, -1427.5533447266, -20.195838928223 ),
		Max = Vector( 521.00085449219, 4.4969038963318, 410.99740600586 ),
		ShortName = "Холл",
		FullName = "Холл",
	},


	[ "Theater #1" ] =
	{
		Min = Vector( -2034.5607910156, 1006.8955688477, -80.47876739502 ),
		Max = Vector( -691.22741699219, 1941.6989746094, 538.93444824219 ),
		ShortName = "Зал #1",
		FullName = "Зал #1",
	},

	[ "Theater #2" ] =
	{
		Min = Vector( 622.73846435547, 779.41314697266, -119.10536956787 ),
		Max = Vector( 1993.6649169922, 1902.1906738281, 600.06420898438 ),
		ShortName = "Зал #1",
		FullName = "Зал #1",
	},

	[ "Left Wing" ] =
	{
		Min = Vector( -1529.9309082031, -447.18112182617, -5.1717448234558 ),
		Max = Vector( -516.01611328125, 128.62678527832, 148.8177947998 ),
		ShortName = "Левое крыло",
		FullName = "Левое крыло",
	},

	[ "Right Wing" ] =
	{
		Min = Vector( 514.36254882813, -391.40307617188, -13.028125762939 ),
		Max = Vector( 1550.673828125, 134.18215942383, 198.708984375 ),
		ShortName = "Правое крыло",
		FullName = "Правое крыло",
	},

	[ "Men's Bathroom" ] =
	{
		Min = Vector( 518.7890625, -1028.9625244141, -22.301418304443 ),
		Max = Vector( 906.95074462891, -496.02767944336, 141.60182189941 ),
		ShortName = "Муж. туалет",
		FullName = "Мужской туалет",
	},

	[ "Women's Bathroom" ] =
	{
		Min = Vector( -906.80114746094, -1027.4053955078, -14.880827903748 ),
		Max = Vector( -510.84283447266, -505.12573242188, 139.19288635254 ),
		ShortName = "Жен. туалет",
		FullName = "Женский туалет",
	},

	[ "Concessions" ] =
	{
		Min = Vector( -414.78909301758, 5.2761745452881, -27.878173828125 ),
		Max = Vector( 388.34725952148, 345.86242675781, 133.07136535645 ),
		ShortName = "Лобби",
		FullName = "Лобби",
	},

	[ "Private Theater #1" ] =
	{
		Min = Vector( -1734.1312255859, -1136.4696044922, -40.398372650146 ),
		Max = Vector( -1013.1742553711, -650.52453613281, 279.88903808594 ),
		ShortName = "Приват #1",
		FullName = "Приват #1",
	},

	[ "Private Theater #2" ] =
	{
		Min = Vector( -2739.845703125, -1136.3590087891, -50.352893829346 ),
		Max = Vector( -2008.2265625, -662.44708251953, 296.28726196289 ),
		ShortName = "Приват #2",
		FullName = "Приват #2",
	},

	[ "Private Theater #3" ] =
	{
		Min = Vector( 913.95922851563, -1117.9099121094, -47.429630279541 ),
		Max = Vector( 1648.2966308594, -635.8330078125, 298.12783813477 ),
		ShortName = "Приват #3",
		FullName = "Приват #3",
	},

	[ "Private Theater #4" ] =
	{
		Min = Vector( 1918.5902099609, -1107.4350585938, -41.656314849854 ),
		Max = Vector( 2640.4851074219, -630.02233886719, 292.02615356445 ),
		ShortName = "Приват #4",
		FullName = "Приват #4",
	},

	[ "Unknown" ] =
	{
		Min = Vector( 1244.9357910156, -2546.5344238281, -843.10437011719 ),
		Max = Vector( 2210.9982910156, -1666.1209716797, -459.64486694336 ),
		ShortName = "Неизвестно",
		FullName = "Неизвестно",
	},
	[ "Ночной клуб" ] =
	{
		Min = Vector( -2467.1735839844, -4255.6845703125, -2090.3044433594 ),
		Max = Vector( -767.18127441406, -2735.5051269531, -1273.3291015625 ),
		ShortName = "Клуб",
		FullName = "Ночной клуб",
	},
	[ "Simon Says" ] =
	{
		Min = Vector( 38.755420684814, -4088.0229492188, -2505.0295410156 ),
		Max = Vector( 897.01574707031, -2762.3527832031, -1344.5073242188 ),
		ShortName = "Simon Says",
		FullName = "Simon Says",
	},


} )

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

	hook.Add("InitPostEntity", "InitializeCustomEntities", function()
		local ent = ents.Create("theater_changelog3d");
		ent:SetPos(Vector(445, -0.01, 60))
		ent:SetAngles(Angle(0, 0, 90))
		ent:Spawn();
		

		local ent = ents.Create("nightclub_sound_panel")   
		ent:SetPos(Vector(-1534, -4000, -1890)) 
		ent:SetAngles(Angle(0,0,-90)) 
		ent:Spawn() 

		local ent = ents.Create("minigame_queue")   
		ent:SetPos(Vector(448, -3619, -1554))
		ent:SetAngles(Angle(0,0,-90))
		ent:Spawn() 
	end)

end