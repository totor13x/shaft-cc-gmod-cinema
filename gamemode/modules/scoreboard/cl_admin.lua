surface.CreateFont( "ScoreboardVidTitle", { font = "Open Sans Light", size = 20, weight = 200 } )
surface.CreateFont( "ScoreboardVidDuration", { font = "Open Sans Light", size = 14, weight = 200 } )
surface.CreateFont( "ScoreboardVidVotes", { font = "Open Sans Light", size = 18, weight = 200 } )

local ADMIN = {}
ADMIN.TitleHeight = 64
ADMIN.VidHeight = 32 // 48

local PlyTab
local PlayerList

local refreshPlayerList = function()
	if IsValid(PlayerList) then
		PlayerList.Counted = PlayerList.Counted or 0
		if PlayerList.Counted != table.Count(PlyTab) then
			PlayerList:Clear()
			PlayerList.Counted = 0
			PlayerList.Text = 'Выбрать зрителя' 
			for k,v in pairs(PlyTab) do
				PlayerList.Counted = PlayerList.Counted + 1
				PlayerList:AddChoice(v:Nick())
			end
		end
	end
end

function ADMIN:Init()
	
	
	local Theater = LocalPlayer():GetTheater()

	self:SetZPos( 1 )
	self:SetSize( 256, 512 )
	self:SetPos( ScrW() - (256 + 8), ScrH() / 2 - ( self:GetTall() / 2 ) )

	self.Title = Label( "", self )
	self.Title:SetFont( "S_Light_40" )
	self.Title:SetColor( Color( 255, 255, 255 ) )

	self.NextUpdate = 0.0

	self.Options = vgui.Create( "DPanelList", self )
	self.Options:DockMargin(0, self.TitleHeight + 2, 0, 0)
	self.Options:SetDrawBackground(false)
	//self.Options:SetPadding( 4 )
	//self.Options:SetSpacing( 4 )

	-- Skip the current video
	local VoteSkipButton = vgui.Create( "SButton" )
	VoteSkipButton:SetBorders(false)
	VoteSkipButton.Font = "S_Light_20"
	VoteSkipButton.Text = T'Theater_Skip'
	VoteSkipButton:SetTall( 35 )
	
	VoteSkipButton.DoClick = function(self)
		RunConsoleCommand( "cinema_forceskip" )
	end
	self.Options:AddItem(VoteSkipButton)

	-- Seek
	local SeekButton = vgui.Create( "SButton" )
	SeekButton:SetBorders(false)
	SeekButton.Font = "S_Light_20"
	SeekButton.Text = T'Theater_Seek'
	SeekButton:SetTall( 35 )
	
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
		local ResetButton = vgui.Create( "SButton" )
		ResetButton:SetBorders(false)
		ResetButton.Font = "S_Light_20"
		ResetButton.Text = T'Theater_Reset'
		ResetButton:SetTall( 35 )
		
		ResetButton.DoClick = function(self)
			RunConsoleCommand( "cinema_reset" )
		end
		self.Options:AddItem(ResetButton)

	end

	-- Private theater options
	if Theater and Theater:IsPrivate() then

		local NameButton = vgui.Create( "SButton" )
		NameButton:SetBorders(false)
		NameButton.Font = "S_Light_20"
		NameButton.Text = T'Theater_ChangeName'
		NameButton:SetTall( 35 )
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

		local NameButton = vgui.Create( "SButton" )
		NameButton:SetBorders(false)
		NameButton.Font = "S_Light_20"
		NameButton.Text = 'Установка пароля'
		NameButton:SetTall( 35 )
		
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
			local DPanelw = vgui.Create( "DPanel" )
			DPanelw.Paint = function() end
			DPanelw:SetTall(35)
			//self.Options:AddItem(PlayerList)

			
			PlayerList = vgui.Create( "SDropDown", DPanelw )
			PlayerList:Dock( FILL )
			PlayerList.Counted = 0
			PlyTab = Location.GetPlayersInLocation(LocalPlayer():GetLocation())
			
			refreshPlayerList()
			
			local KickButton = vgui.Create( "SButton", DPanelw )
			KickButton:SetBorders(false)
			KickButton.Font = "S_Light_20"
			KickButton.Text = 'Kick'
			KickButton:SetTall( 35 )
			KickButton.DoClick = function(self)
				net.Start("KickRequest")
					net.WriteEntity(PlyTab[PlayerList:GetSelectedID()])
				net.SendToServer()
			end
			KickButton:Dock( RIGHT )
			
			
		self.Options:AddItem(DPanelw)
		
		//self.Options:AddItem(KickButton)
		
	end
	
	if Theater and Theater:IsPrivate() then
	
		local HideOption = vgui.Create( "SButton" )
		HideOption:SetBorders(false)
		HideOption.Font = "S_Light_20"
		HideOption.Text = ''
		HideOption.BoolT = false
		HideOption:SetTall( 35 )
		HideOption.DoClick = function(self)
			self.BoolT = !self.BoolT
			print(self.BoolT)
			RunConsoleCommand("cinema_hide",tostring(self.BoolT))
		end
		HideOption.Think = function(self)
			if IsValid(Theater) then self.BoolT = Theater._Hidden end
			if self.BoolT then self.Text = "Показать информацию из превью" else self.Text = "Скрыть информацию из превью" end
		end
		
		/* TODO: VIP
		local old_pa = HideOption.Paint
		HideOption.FakeActivated = true
		HideOption.Paint = function(self, w, h)
			old_pa(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, Color(255,0,0,255) )
			draw.SimpleText( "ФУНКЦИЯ ДОСТУПНА VIP", self.Font, w/2, h/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		HideOption.DoClick = function() end
		*/
		
		self.Options:AddItem(HideOption)
		/*
		local HideOption = vgui.Create( "SButton" )
		HideOption:SetBorders(false)
		HideOption.Font = "S_Light_20"
		HideOption.Text = 'Kick'
		HideOption:SetTall( 35 )
		HideOption.DoClick = function(self)
			net.Start("KickRequest")
				net.WriteEntity(PlyTab[PlayerList:GetSelectedID()])
			net.SendToServer()
		end
		HideOption.Think = function(self)
			net.Start("KickRequest")
				net.WriteEntity(PlyTab[PlayerList:GetSelectedID()])
			net.SendToServer()
		end
		self.Options:AddItem(HideOption)
		local HideOption = vgui.Create( "SCheckBoxLabel" )
		HideOption:SetText("Скрыть просматриваемый контент")
		HideOption:SetChecked(false)
		HideOption.OnChange = function( _, val )
			print(val)
			RunConsoleCommand("cinema_hide",tostring(val))
		end
		self.Options:AddItem(HideOption)
		*/
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
		self.NextUpdate = RealTime() + 3.0
	end

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

vgui.Register( "ScoreboardAdmin", ADMIN, "SPanel"  )