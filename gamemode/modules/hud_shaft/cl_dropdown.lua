PANEL = {}

local b = 20 // Brightness change of hover or depress

PANEL.BackgroundColor = Color( 38, 41, 49 )
PANEL.HoverColor = Color( 38 + b, 41 + b, 49 + b )
PANEL.DepressedColor = Color( 38 - b, 41 - b, 49 - b )
PANEL.DisabledColor = Color( 26, 30, 38 )
PANEL.TextColor = Color( 255, 255, 255 )

--[[---------------------------------------------------------

-----------------------------------------------------------]]
function PANEL:Init()

	self.LerpedColor = Color(170,20,20)
	self.LerpedColorAlphaBorders = 0
	self.LerpedColorAlphaBlock = 0
	self:SetTall( 35 )
	self.Text = ""
	self:SetText("")
	self.Font = "S_Light_20"
	self.LastClick = CurTime()
	self.entered = false
	self.special = false
	self.onclick = false
	self.isborder = true
	self.FakeActivated = false

end


function PANEL:Paint( w, h )

	if ( !self.m_bBackground ) then return end

	//if ( self.Depressed || IsValid(self.Menu) ) then
	
	if ( IsValid(self.Menu) ) then
		self.LerpedColorAlphaBlock = 255
	end
	
	if (self.LerpedColorAlphaBlock != 0) then
		self.LerpedColorAlphaBlock = Lerp(FrameTime()*20, self.LerpedColorAlphaBlock, 0 )
		if self.LerpedColorAlphaBorders > 120 then
			self.LerpedColorAlphaBorders = self.LerpedColorAlphaBlock
		end
	end
	if (!self.entered && self.LerpedColorAlphaBorders != 0) then
		self.LerpedColorAlphaBorders = Lerp(FrameTime()*17, self.LerpedColorAlphaBorders, 0 )
	end
	if self.FakeActivated && self.LerpedColorAlphaBorders < 70 then
		self.LerpedColorAlphaBorders = 70
	end
	local tempborders = table.Copy(self.LerpedColor) //Для блока
	tempborders.a = self.LerpedColorAlphaBorders//Для блока
	
	local tempblock = table.Copy(self.LerpedColor) //Для блока
	tempblock.a = self.LerpedColorAlphaBlock//Для блока
	
	local temptext = Color(255,255,255)
	temptext.a = 255 - (120-self.LerpedColorAlphaBorders)
	
	draw.RoundedBox( 0, 0, 0, w, h, tempblock )
	if self.isborder then
		draw.RoundedBox( 0, 2, 0, w-4, 2, tempborders )
		draw.RoundedBox( 0, 0, 0, 2, h, tempborders )
		draw.RoundedBox( 0, w-2, 0, 2, h, tempborders )
		draw.RoundedBox( 0, 2, h-2, w-4, 2, tempborders )
	else
		draw.RoundedBox( 0, 0, 0, w, h, tempborders )
	end
	draw.SimpleText( self.Text, self.Font, w/2, h/2, temptext, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

function PANEL:UpdateColours( skin )
    return self:SetTextStyleColor( self.TextColor )
end

function PANEL:OnCursorEntered()
	self.LerpedColorAlphaBorders = 120 
	self.entered = true 
end

function PANEL:SetBorders(bool)
	self.isborder = bool
end

function PANEL:OnCursorExited()
	self.entered = false 
end

function PANEL:ChooseOption( value, index )

	if ( self.Menu ) then
		self.Menu:Remove()
		self.Menu = nil
	end

	self.Text  = value

	self.selected = index
	self:OnSelect( index, value, self.Data[ index ] )

end

function PANEL:IsMouseOver()

	local x,y = self:CursorPos()
	return x >= 0 and y >= 0 and x <= self:GetWide() and y <= self:GetTall()

end

derma.DefineControl( "SDropDown", "", PANEL, "DComboBox" )