-- Chat colors
ColDefault = Color( 200, 200, 200 )
ColHighlight = Color( 158, 37, 33 )

include( 'shared.lua' )

--[[
	Unsupported Notifications
]]

hook.Add( "InitPostEntity", "CheckMapSupport", function()

	if Location then

		hook.Run( "CinemaRegisterMap", Location )

		if not Location.GetLocations() then
			
			warning.Set(
				T'Warning_Unsupported_Line1',
				T'Warning_Unsupported_Line2'
			)

			control.Add( KEY_F1, function( enabled, held )
				if enabled and !held then
					steamworks.ViewFile( 119060917 )
				end
			end )

		end

	elseif system.IsOSX() then

		warning.Set(
			T'Warning_OSX_Line1',
			T'Warning_OSX_Line2'
		)

		control.Add( KEY_F1, function( enabled, held )
			if enabled and !held then
				gui.OpenURL( "http://pixeltailgames.com/cinema/help.php" )
				warning.Clear()
			end
		end )

	else
		warning.Clear()
	end

end )

/*
	HUD Elements to hide
*/
GM.HUDToHide = {
	"CHudHealth",
	"CHudSuitPower",
	"CHudBattery",
	"CHudCrosshair",
	"CHudAmmo",
	"CHudSecondaryAmmo",
	"CHudZoom"
}

--[[---------------------------------------------------------
   Name: gamemode:HUDShouldDraw( name )
   Desc: return true if we should draw the named element
-----------------------------------------------------------]]
function GM:HUDShouldDraw( name )

	-- Allow the weapon to override this
	local ply = LocalPlayer()
	if ( IsValid( ply ) ) then
	
		local wep = ply:GetActiveWeapon()
		
		if (wep && wep:IsValid() && wep.HUDShouldDraw != nil) then
		
			return wep.HUDShouldDraw( wep, name )
			
		end
		
	end

	return !table.HasValue(self.HUDToHide, name)

end

--[[---------------------------------------------------------
   Name: gamemode:HUDPaint( )
   Desc: Use this section to paint your HUD
-----------------------------------------------------------]]
function GM:HUDPaint()

	hook.Run( "HUDDrawTargetID" )
	-- hook.Run( "HUDDrawPickupHistory" )
	hook.Run( "DrawDeathNotice", 0.85, 0.04 )

end

--[[---------------------------------------------------------
   Name: gamemode:HUDPaint( )
   Desc: Use this section to paint your HUD
-----------------------------------------------------------]]
function GM:HUDDrawTargetID()
	return false
end

--[[---------------------------------------------------------
   Name: CalcView
   Allows override of the default view
-----------------------------------------------------------]]
function GM:CalcView( ply, origin, angles, fov, znear, zfar )
	
	local Vehicle	= ply:GetVehicle()
	local Weapon	= ply:GetActiveWeapon()
	
	local view = {}
	view.origin 		= origin
	view.angles			= angles
	view.fov 			= fov
	view.znear			= znear
	view.zfar			= zfar
	view.drawviewer		= false

	--
	-- Let the vehicle override the view
	--
	if ( IsValid( Vehicle ) ) then return hook.Run( "CalcVehicleView", Vehicle, ply, view ) end

	--
	-- Let drive possibly alter the view
	--
	if ( drive.CalcView( ply, view ) ) then return view end
	
	--
	-- Give the player manager a turn at altering the view
	--
	player_manager.RunClass( ply, "CalcView", view )

	-- Give the active weapon a go at changing the viewmodel position
	
	if ( IsValid( Weapon ) ) then
	
		local func = Weapon.GetViewModelPosition
		if ( func ) then
			view.vm_origin,  view.vm_angles = func( Weapon, origin*1, angles*1 ) -- Note: *1 to copy the object so the child function can't edit it.
		end
		
		local func = Weapon.CalcView
		if ( func ) then
			view.origin, view.angles, view.fov = func( Weapon, ply, origin*1, angles*1, fov ) -- Note: *1 to copy the object so the child function can't edit it.
		end
	
	end
	
	return view
	
end

--
-- If return true: 		Will draw the local player
-- If return false: 	Won't draw the local player
-- If return nil:	 	Will carry out default action
--
function GM:ShouldDrawLocalPlayer( ply )
	return player_manager.RunClass( ply, "ShouldDrawLocal" )
end

--[[---------------------------------------------------------
   Name: gamemode:CreateMove( command )
   Desc: Allows the client to change the move commands 
			before it's send to the server
-----------------------------------------------------------]]
function GM:CreateMove( cmd )
	if ( player_manager.RunClass( LocalPlayer(), "CreateMove", cmd ) ) then return true end
end

function CreateOpenSansFonts(name, font, size)
	local params = {}
	params['font'] = font
	params['size'] = size
	params['antialias'] = true
	params['extended'] = true
	if string.find(name, "Italic") then
		params['italic'] = true
	end
	surface.CreateFont( name.."_"..size, params )
end

local sizes = {10,20,30,35,40,50,60,70,80,90,100,110,120,125,130,140,145,150}
local fonts = {}
fonts['OpenSans-BoldItalic-ShaftIM'] = "S_BoldItalic"
fonts['OpenSans-Bold-ShaftIM'] = "S_Bold"
fonts['OpenSans-ExtraBI-ShaftIM'] = "S_ExtraBoldItalic"
fonts['OpenSans-ExtraBold-ShaftIM'] = "S_ExtraBold"
fonts['OpenSans-Italic-ShaftIM'] = "S_Italic"
fonts['OpenSans-LightItalic-ShaftIM'] = "S_LightItalic"
fonts['OpenSans-Light-ShaftIM'] = "S_Light"
fonts['OpenSans-Regular-ShaftIM'] = "S_Regular"
fonts['OpenSans-SemiBI-ShaftIM'] = "S_SemiBoldItalic"
fonts['OpenSans-SemiBold-ShaftIM'] = "S_SemiBold"

for i,size in pairs(sizes) do
	for font, name in pairs(fonts) do
		CreateOpenSansFonts(name, font, size)
	end
end


hook.Add('AddTabsScoreboard', 'panelAdd', function(panel)
	/*
	local buttonchange = vgui.Create( "DButton", self.DermaPanelTextSidebar)
		buttonchange:SetPos( 0, self.DermaPanelTextSidebar:GetTall()-40 )
		buttonchange:SetSize(self.DermaPanelTextSidebar:GetWide(),38 + 2)
		buttonchange:SetText("")
		buttonchange.selected = false
		
		buttonchange.DoClick = function(s2)
			if GetConVar("deathrun_spectate_only"):GetInt() == 0 then
				LocalPlayer():ConCommand("deathrun_spectate_only 1")
			else
				LocalPlayer():ConCommand("deathrun_spectate_only 0")
			end
		end
		

		buttonchange.Paint = function( s2, w, h )
			draw.RoundedBox( 0, 0, 0, w-5, h-1, s2.asd )
			draw.RoundedBox( 0, w-5, 0, 5, h-1, s2.asd2 )
			draw.SimpleText(s2.trert, "Defaultfont", 20, h/2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)	

		end

		buttonchange.OnCursorEntered = function(s2) s2.s = true end
		buttonchange.OnCursorExited = function(s2) s2.s = false end
		buttonchange.Think = function(s2)
			if GetConVar("deathrun_spectate_only"):GetInt() == 0 then
				s2.trert = "Р’ РЅР°Р±Р»СЋРґР°С‚РµР»Рё"
			else
				s2.trert = "Р’ РёРіСЂРѕРєРё"
			end
		if s2.s then
			s2.asd = Color(0,0,0,150)
			s2.asd2 = Color(colorLocalPlayer.r,colorLocalPlayer.g,colorLocalPlayer.b,150)
		else
			s2.asd = Color(0,0,0,0)
			s2.asd2 = Color(0,0,0,0)
		end
	end
	*/
end)

hook.Add("AddInfoScoreboard", "LoadInfo", function(self)
	self:AddUser('string',TEAM_CINEMA)
	for _, ply in pairs(player.GetAll())do
		self:AddUser('ply',ply)
	end
end)
