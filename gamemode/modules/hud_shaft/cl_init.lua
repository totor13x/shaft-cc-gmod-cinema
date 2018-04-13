surface.CreateFont( "TextNumbers", { size = 40, weight = 200 } )

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
end


function PANEL:Paint(w,h)
	if (self.LerpedColorAlphaBlock != 0) then
		self.LerpedColorAlphaBlock = Lerp(FrameTime()*20, self.LerpedColorAlphaBlock, 0 )
	end
	if (!self.entered && self.LerpedColorAlphaBorders != 0) then
		self.LerpedColorAlphaBorders = Lerp(FrameTime()*17, self.LerpedColorAlphaBorders, 0 )
	end
	
	local tempborders = table.Copy(self.LerpedColor) //Для блока
	tempborders.a = self.LerpedColorAlphaBorders//Для блока
	
	local tempblock = table.Copy(self.LerpedColor) //Для блока
	tempblock.a = self.LerpedColorAlphaBlock//Для блока
	
	local temptext = Color(255,255,255)
	temptext.a = 255 - (120-self.LerpedColorAlphaBorders)
	
	draw.RoundedBox( 0, 0, 0, w, h, tempblock )
	
	draw.RoundedBox( 0, 0, 0, w, 2, tempborders )
	draw.RoundedBox( 0, 0, 0, 2, h, tempborders )
	draw.RoundedBox( 0, w-2, 0, 2, h, tempborders )
	draw.RoundedBox( 0, 0, h-2, w, 2, tempborders )
	
	draw.SimpleText( self.Text, self.Font, w/2, h/2, temptext, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

function PANEL:OnCursorEntered()
	self.LerpedColorAlphaBorders = 120 
	self.entered = true 
end

function PANEL:OnCursorExited()
	self.entered = false 
end

function PANEL:DoClick()
	self.LerpedColorAlphaBlock = 255
	print("asdasd")
end

vgui.Register( "SButton", PANEL, "DButton" )

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

gui.EnableScreenClicker( false )

concommand.Add("asdasd", function()

asd1 = vgui.Create("SButton")
asd1:SetFont("TextNumbers")
asd1:SetSize(50,50)
asd1.Text = "1"
asd1:Center()
local x,y = asd1:GetPos()
asd1:SetPos(x-55,y-55)

asd2 = vgui.Create("SButton")
asd2:SetFont("TextNumbers")
asd2:SetSize(50,50)
asd2.Text = "2"
asd2:Center()
local x,y = asd2:GetPos()
asd2:SetPos(x-0,y-55)

asd3 = vgui.Create("SButton")
asd3:SetFont("TextNumbers")
asd3:SetSize(50,50)
asd3.Text = "3"
asd3:Center()
local x,y = asd3:GetPos()
asd3:SetPos(x+55,y-55)

asd4 = vgui.Create("SButton")
asd4:SetFont("TextNumbers")
asd4:SetSize(50,50)
asd4.Text = "4"
asd4:Center()
local x,y = asd4:GetPos()
asd4:SetPos(x-55,y-0)

asd5 = vgui.Create("SButton")
asd5:SetFont("TextNumbers")
asd5:SetSize(50,50)
asd5.Text = "5"
asd5:Center()
local x,y = asd5:GetPos()
asd5:SetPos(x-0,y-0)

asd7 = vgui.Create("SButton")
asd7:SetFont("TextNumbers")
asd7:SetSize(50,50)
asd7.Text = "7"
asd7:Center()
local x,y = asd7:GetPos()
asd7:SetPos(x-55,y+55)

asd8 = vgui.Create("SButton")
asd8:SetFont("TextNumbers")
asd8:SetSize(50,50)
asd8.Text = "8"
asd8:Center()
local x,y = asd8:GetPos()
asd8:SetPos(x-0,y+55)

asd9 = vgui.Create("SButton")
asd9:SetFont("TextNumbers")
asd9:SetSize(50,50)
asd9.Text = "9"
asd9:Center()
local x,y = asd9:GetPos()
asd9:SetPos(x+55,y+55)

asd6 = vgui.Create("SButton")
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

gui.EnableScreenClicker( true )

end)