local textcolor_pulsed = Vector(1,1,1)

function DrawHUD()
	if !Fullscreen then
		local hudpulse = Vector(1,1,1)
		
		if (GetLocationPos == 'Ночной клуб' or GetLocationPos == 'Simon Says') then
		
			local col2 = Color(255,255 - (trap[0] or 0 ),255 - (trap[0] or 0 ))
			hudpulse = Vector(col2.r/255, col2.g/255, col2.b/255)
			
		end
		
		textcolor_pulsed = LerpVector(FrameTime()*9, textcolor_pulsed, hudpulse )
		
		
		draw.RoundedBox( 4, 20, ScrH()-60, 150, 40, Color(0,0,0,200) )
		draw.SimpleText( string.upper(LocalPlayer():GetLocationFullName()), "S_Regular_20", (150)/2+20, ScrH()-40, textcolor_pulsed:ToColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
end
hook.Add( "HUDPaint", "DrawShaftHUD", DrawHUD )

surface.CreateFont( "TextNumbers", { size = 40, weight = 100 } )
surface.CreateFont( "TextFr", { font = "default", size = 40 } )

local PANEL = {}

function PANEL:Init()
	self.LerpedColor = Color(170,20,20)
	self.LerpedColorAlphaBorders = 0
	self.LerpedColorAlphaBlock = 0
	self.Text = ""
	self:SetText("")
	self.Font = "TextNumbers"
	self.LastClick = CurTime()
	self.entered = false
	self.special = false
	self.onclick = false
	self.isborder = true
	self.FakeActivated = false
end


function PANEL:Paint(w,h)

	if ( self.Depressed || self:IsSelected() || self:GetToggle() ) then
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

function PANEL:DoClick()
end

vgui.Register( "SButton", PANEL, "DButton" )

local blur = Material( "pp/blurscreen" )
local PANEL = {}

function PANEL:Init()
	
end

function PANEL:Paint(w,h)

	
	local x, y = self:LocalToScreen(0, 0)

	surface.SetMaterial( blur )

	for i = 1, 3 do
		blur:SetFloat( "$blur", ( i / 10 ) * 20 )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
	end
	surface.SetDrawColor( 35, 35, 35, 230 )
	surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
end

vgui.Register( "SPanel", PANEL, "DPanel" )

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

gui.EnableScreenClicker( false )
concommand.Add("asdAsd", function()
end)
/*
concommand.Add("asdAsd", function()


asd = vgui.Create("SPanel")
asd:SetSize(200,200)
asd:Center()
asd:SetSize(200,325)

asd1 = vgui.Create("SButton", asd)
asd1:SetFont("TextNumbers")
asd1:SetSize(50,50)
asd1.Text = "1"
asd1:Center()
local x,y = asd1:GetPos()
asd1:SetPos(x-55,y-55)

asd2 = vgui.Create("SButton", asd)
asd2:SetFont("TextNumbers")
asd2:SetSize(50,50)
asd2.Text = "2"
asd2:Center()
local x,y = asd2:GetPos()
asd2:SetPos(x-0,y-55)

asd3 = vgui.Create("SButton", asd)
asd3:SetFont("TextNumbers")
asd3:SetSize(50,50)
asd3.Text = "3"
asd3:Center()
local x,y = asd3:GetPos()
asd3:SetPos(x+55,y-55)

asd4 = vgui.Create("SButton", asd)
asd4:SetFont("TextNumbers")
asd4:SetSize(50,50)
asd4.Text = "4"
asd4:Center()
local x,y = asd4:GetPos()
asd4:SetPos(x-55,y-0)

asd5 = vgui.Create("SButton", asd)
asd5:SetFont("TextNumbers")
asd5:SetSize(50,50)
asd5.Text = "5"
asd5:Center()
local x,y = asd5:GetPos()
asd5:SetPos(x-0,y-0)

asd7 = vgui.Create("SButton", asd)
asd7:SetFont("TextNumbers")
asd7:SetSize(50,50)
asd7.Text = "7"
asd7:Center()
local x,y = asd7:GetPos()
asd7:SetPos(x-55,y+55)

asd8 = vgui.Create("SButton", asd)
asd8:SetFont("TextNumbers")
asd8:SetSize(50,50)
asd8.Text = "8"
asd8:Center()
local x,y = asd8:GetPos()
asd8:SetPos(x-0,y+55)

asd9 = vgui.Create("SButton", asd)
asd9:SetFont("TextNumbers")
asd9:SetSize(50,50)
asd9.Text = "9"
asd9:Center()
local x,y = asd9:GetPos()
asd9:SetPos(x+55,y+55)

asd6 = vgui.Create("SButton", asd)
asd6:SetFont("TextNumbers")
asd6:SetSize(50,50)
asd6.Text = "6"
asd6:Center()
local x,y = asd6:GetPos()
asd6:SetPos(x+55,y+0)

local olddo = asd6.DoClick
asd6.DoClick = function(s)
	if olddo then 
		olddo(s)
	end
	print('a')
end

button = vgui.Create("SButton", asd)
button:SetFont("TextNumbers")
button:SetSize(55+55+50,50)
button.Font = "TextFr"
button.Text = "Кнопка"
button.FakeActivated = true
button.LerpedColor = Color(5,120,50)
button:Center()
local x,y = button:GetPos()
button:SetPos(x+0,y+55+55)

local olddo = button.DoClick
button.DoClick = function(s)
	if olddo then 
		olddo(s)
	end
	print('a')
end

gui.EnableScreenClicker( true )
end)