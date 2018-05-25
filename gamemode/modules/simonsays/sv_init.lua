module( "simonsays", package.seeall )
util.AddNetworkString( "Minigame1_NetworkDataUpdate" )

local randomless = {
"Back", "Black", "Blue", "Yellow", "Right", "Red", "Purple", "Orange", "Middle", "Left", "Green", "Front", "Crouch", "Brown"
}
//"Black", "Blue", Green, Front
local IsSay5Second = false
local LastSay = 0 
local E_Delay = 0.15
local SaturPos = Vector(448, -3453, -2085)

//Да-да, проще сделать sh_init.lua. Нет, мне лень.
//Я пишу этот код ночью нахуй.
//Я сижу за этим ебанным компьютером уже 15 часов.
//Мне похуй. Сейчас главное сделать рабочую версию Саймона.

Minigame1 = {}
Minigame1.NetworkData = {}
Minigame1.NetworkData.IsPlay = false
Minigame1.NetworkData.GameStarted = 0 
Minigame1.NetworkData.Prepare = false 
Minigame1.NetworkData.PrepareTime = 0
Minigame1.NetworkData.PrepareDelay = 10
Minigame1.NetworkData.PrepareNames = {}
Minigame1.MinusTime = 5
Minigame1.PlayerNow = {} //Играющие 
Minigame1.PlayerPrepareToPlay = {} //Подготовка к игре
Minigame1.PlayerWantPlay = {} //Желающие играть
Minigame1.InTable = {} //Находящиеся в таблице
Minigame1.IfHurted = Vector(448, -3453, -1604)

hook.Add("PlayerDisconnect", "SimonSaysDisconnected", function(ply)
	if Minigame1.PlayerNow[ply] then
		Minigame1.PlayerNow[ply] = nil 
	end
	if Minigame1.PlayerPrepareToPlay[ply] then
		Minigame1.PlayerPrepareToPlay[ply] = nil 
	end
	if Minigame1.PlayerWantPlay[ply] then
		Minigame1.PlayerWantPlay[ply] = nil 
	end
	UpdatePlayers()
end)

hook.Add("Think", "SimonSaysGameplay", function()
	if Minigame1.NetworkData.IsPlay then
		CheckForPlayer()
		
		if !IsSay5Second && (LastSay+Minigame1.MinusTime)-CurTime() <= 5 then
			IsSay5Second = true
			
			local ms = ChatText()
				ms:Add("[", Color(255, 255, 255))
				ms:Add("Simon Says", Color(255, 50, 50))
				ms:Add("] ", Color(255, 255, 255))
				ms:Add("До начала раунда 5 секунд.", Color(255, 255, 255))
			ms:Send(Location.GetPlayersInLocation(Location.GetLocationByName( "Simon Says").Index ))
		end
		
		if ((LastSay+Minigame1.MinusTime)< CurTime()) then
			LastSay = CurTime()
			SelectBlock(table.Random(randomless))
			//SelectBlock("Middle")
			Minigame1.MinusTime = Minigame1.MinusTime - 0.2
			if Minigame1.MinusTime < 2 then Minigame1.MinusTime = 2 end
		end
	else
		if !Minigame1.NetworkData.Prepare then
			PregameStart()
		else
			//print(Minigame1.NetworkData.PrepareTime+Minigame1.NetworkData.PrepareDelay-CurTime())
			if Minigame1.NetworkData.PrepareTime+Minigame1.NetworkData.PrepareDelay < CurTime() then
				StartPlay()
			end
		end
	end
end)	

hook.Add("PlayerInitialSpawn","PlayerInitialSpawn_Minigame1_Updater", function(ply)
	Update(ply)
end)	

hook.Add("PlayerChangeLocation","ChangeLocationMinigame1", function(ply, loc, oldloc)	
	if Minigame1.PlayerNow[ply] then
		Minigame1.PlayerNow[ply] = nil 
	end
	if Minigame1.PlayerPrepareToPlay[ply] then
		Minigame1.PlayerPrepareToPlay[ply] = nil 
	end
	if Minigame1.PlayerWantPlay[ply] then
		Minigame1.PlayerWantPlay[ply] = nil 
	end
	UpdatePlayers()
end)

function UpdatePlayers()
	Minigame1.NetworkData.PrepareNames = {}
	Minigame1.InTable = {}
	if Minigame1.NetworkData.Prepare then
		for i,v in pairs(Minigame1.PlayerPrepareToPlay) do
			if !IsValid(i) then Minigame1.PlayerPrepareToPlay[i] = nil continue end
			table.insert(Minigame1.NetworkData.PrepareNames, i:Nick())
			Minigame1.InTable[i] = true
		end
	elseif Minigame1.NetworkData.IsPlay then
		for i,v in pairs(Minigame1.PlayerNow) do
			if !IsValid(i) then Minigame1.PlayerNow[i] = nil continue end
			table.insert(Minigame1.NetworkData.PrepareNames, i:Nick())
			Minigame1.InTable[i] = true
		end
	else
		for i,v in pairs(Minigame1.PlayerWantPlay) do
			if !IsValid(i) then Minigame1.PlayerWantPlay[i] = nil continue end
			table.insert(Minigame1.NetworkData.PrepareNames, i:Nick())
			Minigame1.InTable[i] = true
		end
	end
	
	Update()
end

function TimerGame()
	UpdatePlayers()
	if !Minigame1.NetworkData.IsPlay then
		local Boxed = InPlayedNow()
		for i,v in pairs(Boxed) do
			i:SetPos(Minigame1.IfHurted)
		end
	end
end
timer.Create( "Timer.Minigame1", 1, 0, TimerGame)

function AddPlayer(caller)
	if (caller.E_Delay or 0) > CurTime() then return end
	if Minigame1.InTable[caller] then return end
	if Minigame1.NetworkData.IsPlay then return end
	
	if Minigame1.NetworkData.Prepare then
		if !Minigame1.PlayerPrepareToPlay[caller] then
			Minigame1.PlayerPrepareToPlay[caller] = true 
		end
	end 
	if !Minigame1.PlayerWantPlay[caller] then
		Minigame1.PlayerWantPlay[caller] = true 
	end 
	
	caller.E_Delay = CurTime()+E_Delay
	UpdatePlayers()
end 

function RemovePlayer(caller)
	if (caller.E_Delay or 0) > CurTime() then return end
	
	if !Minigame1.InTable[caller] then return end
	if Minigame1.NetworkData.IsPlay then return end
	
	if Minigame1.PlayerPrepareToPlay[caller] then
		Minigame1.PlayerPrepareToPlay[caller] = nil 
	end
	if Minigame1.PlayerWantPlay[caller] then
		Minigame1.PlayerWantPlay[caller] = nil 
	end
	
	caller.E_Delay = CurTime()+E_Delay
	UpdatePlayers()
end

function SelectBlock( trigger ) //Да, я знаю что можно сделать это дерьмо через какой-нибудь энтити. Нет, нельзя. Впадлу.
	local entsfinded = ents.FindByName("SS_*_"..trigger)   
	for i,v in pairs(entsfinded) do 
		if !IsValid(v) then continue end
		if string.find(v:GetName(), "ToggleSay") then v:Fire("Toggle") end
		timer.Simple((Minigame1.MinusTime/2)+0.5, function()
			if !IsValid(v) then return end
			if string.find(v:GetName(), "ToggleWall") then v:Fire("Toggle") 
			elseif string.find(v:GetName(), "Hurt") then v:Fire("Enable") end
		end) 
		
		timer.Simple((Minigame1.MinusTime/2)+1, function()
			if !IsValid(v) then return end
			if string.find(v:GetName(), "Toggle") then v:Fire("Toggle")
			else v:Fire("Disable") end
		end)
	end   
end 

function InPlayedNow()
	local tEntities = ents.FindInBox( Vector( 185.00987243652, -3694.8850097656, -2200.2873535156 ), Vector( 676.20172119141, -3233.7749023438, -2033.2576904297 ) )
	local tPlayers = {}

	for i = 1, #tEntities do
		if ( tEntities[ i ]:IsPlayer() ) then
			tPlayers[ tEntities[ i ] ] = true
		end
	end
	
	return tPlayers
end

hook.Add("PlayerShouldTakeDamage", "ASD", function( ply, attacker )
	//print(ply, simonsays.Minigame1.PlayerNow[ply])
	if (ply:GetLocationName() == "Simon Says") then
		//ply:DeathEffect()
		ply:SetPos(simonsays.Minigame1.IfHurted)
	end
	//if simonsays.Minigame1.PlayerNow[ply] then //Здесь был Саймон.
	//	ply:SetPos(simonsays.Minigame1.IfHurted)
	//end
	return false
end)

function CheckForPlayer() 
	
	local Boxed = InPlayedNow()
	for i,v in pairs(Minigame1.PlayerNow) do
		if !IsValid(i) then Minigame1.PlayerNow[i] = nil continue end
		if !Boxed[i] then 
			i:SetPos(Minigame1.IfHurted)
			Minigame1.PlayerNow[i] = nil 
		end 
	end
	
	local id = table.Count(Minigame1.PlayerNow)

	if id == 0 then
		
		local ms = ChatText()
			ms:Add("[", Color(255, 255, 255))
			ms:Add("Simon Says", Color(255, 50, 50))
			ms:Add("] ", Color(255, 255, 255))
			ms:Add("Нет победителя.", Color(255, 255, 255))
			ms:Send(Location.GetPlayersInLocation(Location.GetLocationByName( "Simon Says").Index ))
		EndRound()
		return
	end
	if id == 1 then
		local ms = ChatText()
			ms:Add("[", Color(255, 255, 255))
			ms:Add("Simon Says", Color(255, 50, 50))
			ms:Add("] ", Color(255, 255, 255))
			ms:Add("Победил ", Color(255, 255, 255))
			ms:Add(table.GetKeys(Minigame1.PlayerNow)[1]:Nick(), Color(255, 255, 255)) //TODO: CUSTOM COLOR
			ms:Add(".", Color(255, 255, 255))
			ms:Send(Location.GetPlayersInLocation(Location.GetLocationByName( "Simon Says").Index ))
		EndRound()
		return
	end
end 

function PregameStart()
	//print('pregame')
	local id = table.Count(Minigame1.PlayerWantPlay)
	
	if id < 2 then return end
		Minigame1.NetworkData.Prepare = true
		Minigame1.NetworkData.PrepareTime = CurTime()
		Minigame1.PlayerPrepareToPlay = {}
	
		for i,v in pairs(Minigame1.PlayerWantPlay) do
			Minigame1.PlayerPrepareToPlay[i] = true
		end
		
		Minigame1.PlayerWantPlay = {}
		
		Update()
	return
end

function StartPlay()
	IsSay5Second = false
	print('startgame')
	local id = table.Count(Minigame1.PlayerPrepareToPlay)
	if id < 2 then StopRounds() return end
	Minigame1.PlayerNow = {}
	Minigame1.PlayerWantPlay = {}
	Minigame1.NetworkData.Prepare = false
	Minigame1.NetworkData.PrepareNames = {}
	Minigame1.MinusTime = 5
	LastSay = CurTime()+7
	for i,v in pairs(Minigame1.PlayerPrepareToPlay) do
		Minigame1.PlayerNow[i] = true
		i:SetPos(SaturPos)
	end
		
	Minigame1.NetworkData.IsPlay = true
	Minigame1.PlayerPrepareToPlay = {}
	Update()
end

function StopRounds()

	Minigame1.NetworkData.IsPlay = false
	Minigame1.NetworkData.GameStarted = 0 
	Minigame1.NetworkData.Prepare = false 
	Minigame1.NetworkData.PrepareTime = 0
	Minigame1.NetworkData.PrepareDelay = 5
	Minigame1.NetworkData.PrepareNames = {}
	Minigame1.MinusTime = 5
	Minigame1.PlayerNow = {} //Играющие
	Minigame1.PlayerPrepareToPlay = {} //Подготовка к игре
	Minigame1.PlayerWantPlay = {} //Желающие играть
	
	IsSay5Second = false
	Update()
end

function EndRound(typ)
	Minigame1.NetworkData.PrepareNames = {}
	Minigame1.NetworkData.IsPlay = false
	Minigame1.PlayerNow = {}
	Minigame1.MinusTime = 5 //Рестарт времени
	
	local Boxed = InPlayedNow()
	for i,v in pairs(Boxed) do
		i:SetPos(Minigame1.IfHurted)
	end
	
	Update()
end

function Update(plys)
	net.Start( "Minigame1_NetworkDataUpdate" )
		net.WriteTable(Minigame1.NetworkData)
	if plys then
		net.Send(plys)
	else
		net.Broadcast()
	end
end