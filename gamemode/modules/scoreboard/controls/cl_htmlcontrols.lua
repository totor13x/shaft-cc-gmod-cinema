--[[__                                       _     
 / _| __ _  ___ ___ _ __  _   _ _ __   ___| |__  
| |_ / _` |/ __/ _ \ '_ \| | | | '_ \ / __| '_ \ 
|  _| (_| | (_|  __/ |_) | |_| | | | | (__| | | |
|_|  \__,_|\___\___| .__/ \__,_|_| |_|\___|_| |_|
                   |_| 2010 | Updated: 2015 --]]

local PANEL = {}

--[[---------------------------------------------------------
	
-----------------------------------------------------------]]
function PANEL:Init()

	local ButtonSize = 32
	local Margins = 2
	local Spacing = 0

	self.BackButton = vgui.Create( "DImageButton", self )
	self.BackButton:SetSize( ButtonSize, ButtonSize )
	self.BackButton:SetMaterial( "gui/HTML/back" )
	self.BackButton:Dock( LEFT )
	self.BackButton:DockMargin( Spacing*3, Margins, Spacing, Margins )
	self.BackButton.DoClick = function()
		self.BackButton:SetDisabled( true )
		self.Cur = self.Cur - 1
		self.HTML:OpenURL(self.History[self.Cur])
		self.Navigating = true
	end
	
	self.ForwardButton = vgui.Create( "DImageButton", self )
	self.ForwardButton:SetSize( ButtonSize, ButtonSize )
	self.ForwardButton:SetMaterial( "gui/HTML/forward" )
	self.ForwardButton:Dock( LEFT )
	self.ForwardButton:DockMargin( Spacing, Margins, Spacing, Margins )
	self.ForwardButton.DoClick = function()
		self.ForwardButton:SetDisabled( true )
		self.Cur = self.Cur + 1
		self.HTML:OpenURL(self.History[self.Cur])
		self.Navigating = true
	end
	
	self.RefreshButton = vgui.Create( "DImageButton", self )
	self.RefreshButton:SetSize( ButtonSize, ButtonSize )
	self.RefreshButton:SetMaterial( "gui/HTML/refresh" )
	self.RefreshButton:Dock( LEFT )
	self.RefreshButton:DockMargin( Spacing, Margins, Spacing, Margins )
	self.RefreshButton.DoClick = function()
		self.RefreshButton:SetDisabled( true )
		self.Refreshing = true
		self.HTML:OpenURL( self.HTML:GetURL() )
	end
	
	self.HomeButton = vgui.Create( "DImageButton", self )
	self.HomeButton:SetSize( ButtonSize, ButtonSize )
	self.HomeButton:SetMaterial( "gui/HTML/home" )
	self.HomeButton:Dock( LEFT )
	self.HomeButton:DockMargin( Spacing, Margins, Spacing*3, Margins )
	self.HomeButton.DoClick = function()
		self.HTML:Stop()
		self.HTML:OpenURL( self.HomeURL )
		self.Cur = 1
	end
	
	self.AddressBar = vgui.Create( "DTextEntry", self )
	self.AddressBar:Dock( FILL )
	self.AddressBar:DockMargin( Spacing, Margins * 3, Spacing, Margins * 3 )
	self.AddressBar.OnEnter = function()
		self.HTML:Stop()
		self.HTML:OpenURL( self.AddressBar:GetValue() )
	end
	
	self.RequestButton = vgui.Create( "TheaterButton", self )
	self.RequestButton:SetSize( ButtonSize*8, ButtonSize )
	self.RequestButton:SetText( T'Request_Url' )
	self.RequestButton:SetTooltip( T'Request_Url_Tooltip' )
	self.RequestButton:SetDisabled( true )
	self.RequestButton:Dock( RIGHT )
	self.RequestButton:DockMargin( 8, 4, 8, 4 )
	self.RequestButton.BackgroundColor = Color(123, 32, 29)
	self.RequestButton.DoClick = function()
		RequestVideoURL( self.HTML.URL )
	end
	
	self:SetHeight( ButtonSize + Margins * 2 )
	
	self.NavStack = 0;
	self.History = {}
	self.Cur = 1
	
	-- This is the default look, feel free to change it on your created control :)
	self:SetButtonColor( Color( 250, 250, 250, 200 ) )
	self.BorderSize = 4
	self.BackgroundColor = Color( 33, 33, 33, 255 )
	self.HomeURL = "http://www.google.com"

end

function PANEL:SetHTML( html )

	self.HTML = html
	
	if ( html.URL ) then
		self.HomeURL = self.HTML.URL
	end
	
	self.AddressBar:SetText( self.HomeURL )
	self:UpdateHistory( self.HomeURL )
	
	
	self.HTML:AddFunction( "console", "htmlout", function( str )
		self.HTML.HTMLCode = str
	end )

	self.HTML.OnFinishLoading = function( panel )

		local url = self.HTML:GetURL()

		self.AddressBar:SetText( url )
		self:FinishedLoading()
		
		if IsValid(self.DComboBox) then self.DComboBox:Remove() end
		if IsValid(self.DButton) then self.DButton:Remove() end
		
		self.RequestButton:SetVisible(true)
		
		local aa = theater.ChechIfSerialsService(self.HTML.HTMLCode, url, Theater)

		if aa && aa.isSerials then
			//self.RequestButton:SetDisabled( false )
			//self.RequestButton.BackgroundColor = Color(32, 123, 29)
			aa.Type = nil
			aa.isSerials = nil
			local func = nil
			local text = aa.specText == nil and 'Выбор серии' or aa.specText
			if isfunction(aa.extraParser) then
				func = aa.extraParser
			end
			aa.extraParser = nil
			aa.specText = nil
			
			local ButtonSize = 32
			self.RequestButton:SetVisible(false)
			
			self.DButton = vgui.Create( "TheaterButton", self )
			self.DButton:Dock( RIGHT )
			self.DButton:SetDisabled( true )
			self.DButton:SetSize( 120, ButtonSize )
			self.DButton:DockMargin( 4, 4, 8, 4 )
			self.DButton:SetText( "Выбрать" )	
			self.DButton:SetTooltip( T'Request_Url_Tooltip' )
			self.DButton.BackgroundColor = Color(123, 32, 29)
			self.DButton.DoClick = function()
				local x,y = self.DComboBox:GetSelected()
				if func then
					func(_, y)
				else
					RequestVideoURL(y)
				end
			end
			
			self.DComboBox = vgui.Create( "DComboBox", self )
			self.DComboBox:Dock( RIGHT )
			self.DComboBox:SetSize( (ButtonSize*8)-120, ButtonSize )
			self.DComboBox:DockMargin( 8, 4, 4, 4 )
			self.DComboBox:SetSortItems( false )
			self.DComboBox:SetValue( text )
			self.DComboBox.OnSelect = function( panel, index, value )	
				self.DButton:SetDisabled( false )
			end
			
			//https://online.anidub.com/anime/full/8498-koshechka-iz-sakuraso-sakurasou-no-pet-na-kanojo-24-iz-24.html
			for i,v in pairs( aa ) do
				self.DComboBox:AddChoice( v['name'], v['url'] )
			end
		end
	end

	self.HTML.OnURLChanged = function ( panel, url )

		self.AddressBar:SetText( url )
		self.NavStack = self.NavStack + 1
		self:StartedLoading()
		self:UpdateHistory( url )
		self.HTML:RunJavascript( "console.htmlout(document.body.innerHTML)" )
		local Theater = LocalPlayer():GetTheater()
		
		if IsValid(self.DComboBox) then self.DComboBox:Remove() end
		if IsValid(self.DButton) then self.DButton:Remove() end
		
		self.RequestButton:SetVisible(true)
		-- Check for valid URL
		if theater.ExtractURLData( url, Theater ) then
			self.RequestButton:SetDisabled( false )
		else
			self.RequestButton:SetDisabled( true )
		end
	end
end

function PANEL:UpdateHistory( url )

	--print( "PANEL:UpdateHistory", url )
	self.Cur = math.Clamp( self.Cur, 1, table.Count( self.History ) )
	
	if ( self.Refreshing ) then
	
		self.Refreshing = false
		self.RefreshButton:SetDisabled( false )
		return
		
	end
		
	if ( self.Navigating ) then
			
		self.Navigating = false
		self:UpdateNavButtonStatus()
		return

	end
	
	-- We were back in the history queue, but now we're navigating
	-- So clear the front out so we can re-write history!!
	if ( self.Cur < table.Count( self.History ) ) then
	
		for i=self.Cur+1, table.Count( self.History ) do
			self.History[i] = nil
		end
	
	end
	
	if !table.HasValue(self.History, url) then -- It spams the same entry multiple times...
		self.Cur = table.insert( self.History, url )
	end

	self:UpdateNavButtonStatus()

end

function PANEL:FinishedLoading()

	self.RefreshButton:SetDisabled( false )

end

function PANEL:StartedLoading()

	self.RefreshButton:SetDisabled( true )

end

function PANEL:UpdateNavButtonStatus()

	--print( self.Cur, table.Count( self.History ) )
	
	self.ForwardButton:SetDisabled( self.Cur >= table.Count( self.History ) )
	self.BackButton:SetDisabled( self.Cur == 1 )

end

function PANEL:SetButtonColor( col )

	self.BackButton:SetColor( col )
	self.ForwardButton:SetColor( col )
	self.RefreshButton:SetColor( col )
	self.HomeButton:SetColor( col )

end

function PANEL:Paint()

	draw.RoundedBoxEx( self.BorderSize, 0, 0, self:GetWide(), self:GetTall(), self.BackgroundColor, true, true, false, false )

end

derma.DefineControl( "TheaterHTMLControls", "", PANEL, "Panel" )
