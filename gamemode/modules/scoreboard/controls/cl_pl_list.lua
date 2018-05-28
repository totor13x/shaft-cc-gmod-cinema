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

	//self.BaseClass.Init(self)

	self:SetTall( 28 )
	self:SetFont( "LabelFont" )

end


function PANEL:Paint( w, h )
	surface.SetDrawColor( self.BackgroundColor )
	surface.DrawRect( 0, 0, w, h )

end

function PANEL:UpdateColours( skin )
    return self:SetTextStyleColor( self.TextColor )
end

function PANEL:IsMouseOver()

	local x,y = self:CursorPos()
	return x >= 0 and y >= 0 and x <= self:GetWide() and y <= self:GetTall()

end

derma.DefineControl( "TheaterPlayerList", "", PANEL, "DComboBox" )