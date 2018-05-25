include('shared.lua')
ENT.SizeX = 80
ENT.SizeY = 80
ENT.RenderGroup 	= RENDERGROUP_TRANSLUCENT
ENT.Offset = Vector(-ENT.SizeX,-ENT.SizeX+20,-10)
ENT.Rotation = Angle(180,180,0);

surface.CreateFont( "QueueCount", { size = 80, weight = 100 } )
surface.CreateFont( "QueueCountButton", { size = 70, weight = 100 } )
surface.CreateFont( "QueueCountText", { size = 40, weight = 100 } )
surface.CreateFont( "QueueHeader", { size = 35, weight = 100 } )
surface.CreateFont( "QueueText", { size = 30, weight = 100 } )

function ENT:DrawTranslucent()
	cam.Start3D2D(self.Position,self.Ang,0.25)
		local h,w  = self.SizeX*8, self.SizeY*6
		draw.RoundedBox( 0, 0, 0, self.SizeX*8, self.SizeY*6, Color(35,35,35) )
		local text = ""
		local viewcount = true
		if Minigame1.NetworkData.IsPlay then
			text = "Находятся в игре"
			viewcount = false
		else
			text = "Желают поиграть"
		end
		
		draw.SimpleText(text, "S_Regular_40", 10, 5, Color(255, 250, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		if Minigame1.NetworkData.Prepare then
				local secs = Minigame1.NetworkData.PrepareTime+Minigame1.NetworkData.PrepareDelay-CurTime()
				if secs < 0 then
				secs = 0
				end
				secs = string.Explode(".", secs)[1]
				
				draw.SimpleText(secs, "S_Bold_80", 450, (self.SizeY*3)-25, Color(255, 250, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("секунд", "S_Regular_40", 450, (self.SizeY*3)+25, Color(255, 250, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		elseif Minigame1.NetworkData.IsPlay then
			draw.SimpleText("Ждите", "S_Bold_80", 450, (self.SizeY*3)-25, Color(255, 250, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("игра скоро закончится", "S_Regular_40", 450, (self.SizeY*3)+35, Color(255, 250, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText("[E]", "S_Bold_80", 450, (self.SizeY*3)-25, Color(255, 250, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("чтобы начать играть", "S_Regular_40", 450, (self.SizeY*3)+25, Color(255, 250, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		local xa = 10+35
		local tab = Minigame1.NetworkData.PrepareNames or {}
		for i,v in pairs(tab) do
			if i > 6 then draw.SimpleText("и еще "..#tab-(i-1), "S_Italic_35", 20, xa*i, Color(250, 128, 128), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) return end
			draw.SimpleText(v, "S_Italic_35", 20, xa*i, Color(250, 128, 128), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
		if #tab == 0 then
			draw.SimpleText("Нет игроков", "S_Italic_35", 20, xa, Color(250, 250, 250), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
	cam.End3D2D()
end

function ENT:Think()
	self.Position = self:LocalToWorld(self.Offset)
	self.Ang = self.Entity:LocalToWorldAngles(self.Rotation)
end