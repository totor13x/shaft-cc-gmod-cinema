local lua = [[
	/*
	RunConsoleCommand("stopsound")
	 
	timer.Simple(7, function()
		//if true then return end
		//sound.PlayURL( "https://shaft.im/uploads/music/36f88640fe05be69f9c16ad5aaf1d78d_1511626691_305.mp3", "stereo", function( station )
		sound.PlayURL( "https://shaft.im/uploads/music/36f88640fe05be69f9c16ad5aaf1d78d_1511626691_305.mp3", "3d", function( station )
			if ( IsValid( station ) ) then

				if (IsValid(NightClubMusic)) then
					NightClubMusic:Stop()
				end 
				 
				station:Play()
				NightClubMusic = station
			else

				LocalPlayer():ChatPrint( "Invalid URL!" )

			end
		end )
	end)
	*/
	
local getpos = nil
hook.Add("Think", "NightClubMusicThinking", function()
GetLocationPos = LocalPlayer():GetLocationName()
if !IsValid(getpos) && IsValid(ents.FindByClass("nightclub_danceblocks")[1]) then
	getpos = ents.FindByClass("nightclub_danceblocks")[1]:GetPos()+Vector(0,0,5)
end
	if IsValid(NightClubMusic) then
		if (GetLocationPos == 'Ночной клуб' or GetLocationPos == 'Simon Says') then
			NightClubMusic:SetVolume(1)
			NightClubMusic:Set3DFadeDistance( 1000, 1000000 )
			NightClubMusic:SetPos(LocalPlayer():GetPos())
		else
			if Vector(0,320,0.25):Distance(EyePos()) < 300 then
				NightClubMusic:SetVolume(0.2)
				NightClubMusic:Set3DFadeDistance( 128, 256 )
				NightClubMusic:SetPos(Vector(0,320,0.25))
			else
				NightClubMusic:SetVolume(0)
			end
		end
	end
end )
hook.Add("InitPostEntity", "nightclub", function()
	load_nightclub_blocks()
end )

function load_nightclub_blocks()
local mat2 = Material( "totor/cinema/pulse" ) -- Для рендера пульсирующих элементов
local mat = Material( "cs_havana/white" ) -- Для панелей

musictable = {}
NightClubMusic = NightClubMusic or nil
GetLocationPos = GetLocationPos or nil

local wave = true
local idl = 0
trap = {}
local xy, step, size, limitcolor = 48, 10, 24, 0
local minus = true
local runsun = false
for i=step, 0, -1 do
	trap[i] = trap[i] or limitcolor 
end

timer.Remove( "PulseDoom" )

timer.Create( "PulseDoom", 0.05, 0, function() 	
	if !wave then
		idl = idl + 0.01
		if idl > 1 then 
			idl = 0
			wave = true
			runsun = false
		end  
		for i=step, 0, -1 do
			local key = i-1
			if key < 0 then
				key = 0
			end
			trap[key] = trap[key] or limitcolor
			trap[key+1] = trap[key+1] or limitcolor
			
			trap[key+1] = trap[key]
			trap[key] = trap[key] - 20
			
			if trap[key] < limitcolor then 
				trap[key] = limitcolor
			end
		end
	else 
		for i=step, 0, -1 do
			local key = i-1
			if key < 0 then
				key = 0
			end
			trap[key] = trap[key] or limitcolor
			trap[key+1] = trap[key+1] or limitcolor
			local udd =1
			if minus then
				udd = -1
			end
			trap[key+1] = trap[key]
			trap[key] = trap[key] - udd
			
			if trap[key] > 230 then
				if key == 0 then runsun = true end
				trap[key] = 230
				minus = !minus
			end
			if trap[key] < limitcolor then
				trap[key] = limitcolor
				minus = !minus
			end
		end
		if runsun then
			for i,v in pairs(ents.FindByClass("nightclub_lightspot")) do
				v.LightColor = Color(trap[0],0,0)
			end
		end
	end
end) 
hook.Add( "PostDrawOpaqueRenderables", "FFTBlocks", function() 
	if (GetLocationPos == 'Ночной клуб' or GetLocationPos == 'Simon Says' ) then
		if IsValid(NightClubMusic) then
			NightClubMusic:FFT( musictable, FFT_256 )
		end
		render.SetMaterial( mat )
		for y=0,step do
			for i=0,step do
		
				local id = i
				local half = step/2
				if i < half then
					id = step - (id + y)
				end
				if y >= half and i < half then id = y - i end
				if y <= half and i >= half then	id = i - y end
				if y > half and i >= half then id = - step + (i + y) end
				if y != half and i != half then	id = id - 1 end
				if (musictable[2] or 0) > 0.4 then
					wave = false
					runsun = false
					idl = 0
					trap[0] = 255
					for i,v in pairs(ents.FindByClass("nightclub_lightspot")) do
						v.LightWidth = 400
						v.LightColor = Color(255,0,0)
					end
				end	
				local col2, stolb = Color(255,255 - (trap[id] or limitcolor ),255 - (trap[id] or limitcolor )), trap[id]/50
				col2 = Vector(col2.r/255, col2.g/255, col2.b/255)
				local col3, stolb = Color(255,255 - (trap[0] or limitcolor ),255 - (trap[0] or limitcolor )), trap[0]/50
				col3 = Vector(col3.r/255, col3.g/255, col3.b/255) 
				mat:SetVector( "$color", col2) 
				mat2:SetVector( "$color", col3) 
				if getpos then
				render.DrawBox( getpos - Vector(-xy*y,-xy*i,0) - Vector(xy*step/2,xy*step/2,0), Angle(90,0,0), Vector(0-stolb,-size,-size), Vector(0,size,size), Color(255,255,255), false )
				end
			end
		end
	end
end )

end
//load_nightclub_blocks() 
]]
 
util.AddNetworkString( "LoadPulseHernya" )

if #player.GetAll() > 0 then
	net.Start("LoadPulseHernya")
	net.WriteString(lua) 
	net.Broadcast()
end

hook.Add("PlayerInitialSpawn", "LoadPulseHernya", function( pl )
	
	net.Start("LoadPulseHernya")
	net.WriteString(lua) 
	net.Send(pl) 

end)
