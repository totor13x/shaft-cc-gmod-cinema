net.Receive("LoadPulseHernya", function()
	RunString(net.ReadString())
end) 
/*
RunConsoleCommand("stopsound")
 
timer.Simple(5, function()
	//if true then return end
	//sound.PlayURL( "https://shaft.im/uploads/music/36f88640fe05be69f9c16ad5aaf1d78d_1511626691_305.mp3", "stereo", function( station )
	sound.PlayURL( "https://shaft.im/uploads/music/test2.mp3", "3d", function( station )
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

if IsValid(asd) then asd:Remove() end
if IsValid(asd1) then asd1:Remove() end
if IsValid(asd2) then asd2:Remove() end
if IsValid(asd3) then asd3:Remove() end
if IsValid(asd4) then asd4:Remove() end
if IsValid(asd5) then asd5:Remove() end
if IsValid(asd6) then asd6:Remove() end
if IsValid(asd7) then asd7:Remove() end
if IsValid(asd8) then asd8:Remove() end
if IsValid(asd9) then asd9:Remove() end
if IsValid(button) then button:Remove() end

surface.CreateFont( "TextAuthor", { font = "default", size = 23 } )
surface.CreateFont( "TextByAdded", { font = "default", size = 15 } )
surface.CreateFont( "TextName", { font = "default", size = 28 } )

asd = vgui.Create("SPanel")
asd:SetSize(300,200)
asd:Center()
local oldpaint = asd.Paint
asd.Paint = function(s,w,h)
	draw.RoundedBox( 0, 0, 0, w, h, Color(255,255,255,230) )
	draw.SimpleText( "MeVoV", "TextAuthor", 5, h-23-5, Color(230,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	draw.SimpleText( "Farewell, Ilyas", "TextName", 5, h-23-5-5-28, Color(230,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	local smooth = {}
	local aa = 0
	for i,v in pairs(musictable or {}) do
		if i%2 == 0 then continue end
		if i > 64 then continue end
		aa=aa+1
		smooth[aa] = smooth[aa] or 1
		smooth[aa] = Lerp(1, smooth[aa], v)
		local y = (smooth[aa]*128)
		draw.RoundedBox( 0, (w/2)+5+((aa-(68/2))*4), 60-y/2, 2, y, Color(230,0,0))
	end
end

gui.EnableScreenClicker( true )
 */