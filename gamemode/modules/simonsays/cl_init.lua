Minigame1 = {}
Minigame1.NetworkData = {}
Minigame1.NetworkData.IsPlay = false

net.Receive("Minigame1_NetworkDataUpdate", function()
	Minigame1.NetworkData = net.ReadTable()
end)

//Да, я знаю что можно сделать это все через прокси в самих текстурах.
//***В будущем надо будет сделать через прокси. 
local White = Vector(255/255,255/255,255/255)
local Black = Vector(30/255,30/255,30/255)
local Blue = Vector(0/255,0/255,255/255)
local Red = Vector(230/255,0/255,0/255)
local Yellow = Vector(230/255,230/255,0/255)
local Purple = Vector(170/255,0/255,230/255)
local Orange = Vector(150/255/255,25,55/255)
local Green = Vector(0/255,152/255,152/255)
local Brown = Vector(150/255,75/255,0/255)

local matWhite = Material("totor/cinema/white")
local matBlack = Material("totor/cinema/Black")
local matBlue = Material("totor/cinema/Blue")
local matRed = Material("totor/cinema/Red")
local matYellow = Material("totor/cinema/Yellow")
local matPurple = Material("totor/cinema/Purple")
local matOrange = Material("totor/cinema/Orange")
local matGreen = Material("totor/cinema/Green")
local matBrown = Material("totor/cinema/Brown")

local lastwave = Vector(0,0,0)

local waveWhite = nil
local waveBlack = nil
local waveBlue = nil
local waveRed = nil
local waveYellow = nil
local wavePurple = nil
local waveOrange = nil
local waveGreen = nil
local waveBrown = nil

hook.Add("PostDrawOpaqueRenderables", "FFTBlockMinigame1", function()
	if Minigame1.NetworkData.IsPlay then
	
	
		waveWhite = waveWhite or lastwave
		waveBlack = waveBlack or lastwave
		waveBlue = waveBlue or lastwave
		waveRed = waveRed or lastwave
		waveYellow = waveYellow or lastwave
		wavePurple = wavePurple or lastwave
		waveOrange = waveOrange or lastwave
		waveGreen = waveGreen or lastwave
		waveBrown = waveBrown or lastwave

		local frameTim = FrameTime()*0.9
		
		waveWhite = LerpVector(frameTim, waveWhite, White)
		waveBlack = LerpVector(frameTim, waveBlack, Black)
		waveBlue = LerpVector(frameTim, waveBlue, Blue)
		waveRed = LerpVector(frameTim, waveRed, Red)
		waveYellow = LerpVector(frameTim, waveYellow, Yellow)
		wavePurple = LerpVector(frameTim, wavePurple, Purple)
		waveOrange = LerpVector(frameTim, waveOrange, Orange)
		waveGreen = LerpVector(frameTim, waveGreen, Green)
		waveBrown = LerpVector(frameTim, waveBrown, Brown)
		
		matWhite:SetVector("$color", waveWhite)
		matBlack:SetVector("$color", waveBlack)
		matBlue:SetVector("$color", waveBlue) 
		matRed:SetVector("$color", waveRed)
		matYellow:SetVector("$color", waveYellow)
		matPurple:SetVector("$color", wavePurple)
		matOrange:SetVector("$color", waveOrange)
		matGreen:SetVector("$color", waveGreen)
		matBrown:SetVector("$color", waveBrown)
		
		/*
		matWhite:SetVector("$color", White)
		matBlack:SetVector("$color", Black)
		matBlue:SetVector("$color", Blue) 
		matRed:SetVector("$color", Red)
		matYellow:SetVector("$color", Yellow)
		matPurple:SetVector("$color", Purple)
		matOrange:SetVector("$color", Orange)
		matGreen:SetVector("$color", Green)
		matBrown:SetVector("$color", Brown)
		*/
	else
		waveWhite = nil
		waveBlack = nil
		waveBlue = nil
		waveRed = nil
		waveYellow = nil
		wavePurple = nil
		waveOrange = nil
		waveGreen = nil
		waveBrown = nil
		
		local col2 = Color(255,255 - (trap[0] or 0 ),255 - (trap[0] or 0 ))
		col2 = Vector(col2.r/255, col2.g/255, col2.b/255)

		lastwave = col2
		matWhite:SetVector("$color", col2)
		matBlack:SetVector("$color", col2)
		matBlue:SetVector("$color", col2)
		matRed:SetVector("$color", col2)
		matYellow:SetVector("$color", col2)
		matPurple:SetVector("$color", col2)
		matOrange:SetVector("$color", col2)
		matGreen:SetVector("$color", col2)
		matBrown:SetVector("$color", col2)
	end
end)