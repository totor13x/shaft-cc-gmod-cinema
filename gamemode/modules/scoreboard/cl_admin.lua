surface.CreateFont( "ScoreboardVidTitle", { font = "Open Sans Light", size = 20, weight = 200 } )
surface.CreateFont( "ScoreboardVidDuration", { font = "Open Sans Light", size = 14, weight = 200 } )
surface.CreateFont( "ScoreboardVidVotes", { font = "Open Sans Light", size = 18, weight = 200 } )

local ADMIN = {}
ADMIN.TitleHeight = 64
ADMIN.VidHeight = 32 // 48

local PlyTab
local PlayerList

local refreshPlayerList = function()
	PlayerList:Clear()
	PlayerList:SetText( 'Выбрать зрителя' )
	for k,v in pairs(PlyTab) do
		PlayerList:AddChoice(v:Nick())
	end
end

function ADMIN:Init()
	
	
	local Theater = LocalPlayer():GetTheater()

	self:SetZPos( 1 )
	self:SetSize( 256, 512 )
	self:SetPos( ScrW() - (256 + 8), ScrH() / 2 - ( self:GetTall() / 2 ) )

	self.Title = Label( "", self )
	self.Title:SetFont( "ScoreboardTitle" )
	self.Title:SetColor( Color( 255, 255, 255 ) )

	self.NextUpdate = 0.0

	self.Options = vgui.Create( "DPanelList", self )
	self.Options:DockMargin(0, self.TitleHeight + 2, 0, 0)
	self.Options:SetDrawBackground(false)
	self.Options:SetPadding( 4 )
	self.Options:SetSpacing( 4 )

	-- Skip the current video
	local VoteSkipButton = vgui.Create( "TheaterButton" )
	VoteSkipButton:SetText( T'Theater_Skip' )
	VoteSkipButton.DoClick = function(self)
		RunConsoleCommand( "cinema_forceskip" )
	end
	self.Options:AddItem(VoteSkipButton)

	-- Seek
	local SeekButton = vgui.Create( "TheaterButton" )
	SeekButton:SetText( T'Theater_Seek' )
	SeekButton.DoClick = function(self)

		Derma_StringRequest( T'Theater_Seek', 
			T'Theater_SeekQuery', 
			"0",
			function( strTextOut ) RunConsoleCommand( "cinema_seek", strTextOut ) end,
			function( strTextOut ) end,
			T'Theater_Seek', 
			T'Cancel' )

	end
	self.Options:AddItem(SeekButton)

	-- Admin-only options
	if LocalPlayer():IsAdmin() then
		
		-- Reset the theater
		local ResetButton = vgui.Create( "TheaterButton" )
		ResetButton:SetText( T'Theater_Reset' )
		ResetButton.DoClick = function(self)
			RunConsoleCommand( "cinema_reset" )
		end
		self.Options:AddItem(ResetButton)

	end

	-- Private theater options
	if Theater and Theater:IsPrivate() then

		local NameButton = vgui.Create( "TheaterButton" )
		NameButton:SetText( T'Theater_ChangeName' )
		NameButton.DoClick = function(self)
			Derma_StringRequest( T'Theater_ChangeName', 
				"",
				Theater:Name(),
				function( strTextOut ) RunConsoleCommand( "cinema_name", strTextOut ) end,
				function( strTextOut ) end,
				T'Set',
				T'Cancel' )
		end
		self.Options:AddItem(NameButton)


	end
	
	if Theater and Theater:IsPrivate() then

		local NameButton = vgui.Create( "TheaterButton" )
		NameButton:SetText( 'Установка пароля' )
		NameButton.DoClick = function(self)
			Derma_StringRequest( 'Какой код?', 
				"Для работы пароля необходимо 4 цифры",
				'1234',
				function( strTextOut ) RunConsoleCommand( "cinema_pass", strTextOut ) end,
				function( strTextOut ) end,
				T'Set',
				T'Cancel' )
		end
		self.Options:AddItem(NameButton)

	end
	
	if Theater and Theater:IsPrivate() then
		PlayerList = vgui.Create( "TheaterPlayerList" )
		
		PlyTab = Location.GetPlayersInLocation(LocalPlayer():GetLocation())
		
		refreshPlayerList()
		
		self.Options:AddItem(PlayerList)

		
		local KickButton = vgui.Create( "TheaterButton" )
		KickButton:SetText( 'Выгнать зрителя' )
		KickButton.DoClick = function(self)
			net.Start("KickRequest")
				net.WriteEntity(PlyTab[PlayerList:GetSelectedID()])
			net.SendToServer()
		end
		self.Options:AddItem(KickButton)
		
	end
	
	if Theater and Theater:IsPrivate() then

		local HideOption = vgui.Create( "TheaterCheckBoxLabel" )
		HideOption:SetText("Скрыть просматриваемый контент")
		HideOption:SetChecked(false)
		HideOption.OnChange = function( _, val )
			print(val)
			RunConsoleCommand("cinema_hide",tostring(val))
		end
		self.Options:AddItem(HideOption)
	end
	
end

function ADMIN:Update()
	
	PlyTab = Location.GetPlayersInLocation(LocalPlayer():GetLocation())
	refreshPlayerList()
	
	local Theater = LocalPlayer():GetTheater() // get player's theater from their location
	if !Theater then return end

	-- Change title text
	if Theater:IsPrivate() and Theater:GetOwner() == LocalPlayer() then
		self.Title:SetText( T'Theater_Owner' )
	elseif LocalPlayer():IsAdmin() then
		self.Title:SetText( T'Theater_Admin' )
	end

end

function ADMIN:Think()

	if RealTime() > self.NextUpdate then
		self:Update()
		self:InvalidateLayout()
		self.NextUpdate = RealTime() + 4.0
	end

end

local Background = Material( "theater/banner.png" )

function ADMIN:Paint( w, h )

	// Background
	surface.SetDrawColor( 26, 30, 38, 255 )
	surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )

	// Title
	surface.SetDrawColor( 141, 38, 33, 255 )
	surface.DrawRect( 0, 0, self:GetWide(), self.Title:GetTall() )

	// Title Background
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( Background )
	surface.DrawTexturedRect( 0, -1, 512, self.Title:GetTall() + 1 )

end

function ADMIN:PerformLayout()

	self.Title:SizeToContents()
	self.Title:SetTall( self.TitleHeight )
	self.Title:CenterHorizontal()

	if self.Title:GetWide() > self:GetWide() and self.Title:GetFont() != "ScoreboardTitleSmall" then
		self.Title:SetFont( "ScoreboardTitleSmall" )
	end

	self.Options:Dock( FILL )
	self.Options:SizeToContents()

end

vgui.Register( "ScoreboardAdmin", ADMIN )