include('shared.lua')

ENT.Rotation = Angle(0,0,0);
ENT.Offset = Vector(-23,23,1.6)
ENT.WindowSize = {x = 46, y = 46}
ENT.BorderSize = 1
ENT.NoDrawDistance = 200
ENT.TextScale = 0.035

ENT.LerpedColor = Vector(240,150,150)
ENT.NLerpedColor = Vector(230,230,230)
ENT.UsedColor = Vector(100,230,120)
ENT.Pass = ""


surface.CreateFont( "TextNumbers", { size = 4*(1/ENT.TextScale), weight = 600 } )

ENT.Buttons = {	b1 = { x = 2,y = 2,w = 8, t = 8, num = 1, col = Vector()},
				b2 = {x = 10,y = 2, w = 8, t = 8, num = 2, col = Vector()},
				b3 = {x = 18,y = 2, w = 8, t = 8, num = 3, col = Vector()},
				b4 = {x = 2,y = 10, w = 8, t = 8, num = 4, col = Vector()},
				b5 = {x = 10,y = 10, w = 8, t = 8, num = 5, col = Vector()},
				b6 = {x = 18,y = 10, w = 8, t = 8, num = 6, col = Vector()},
				b7 = {x = 2,y = 18, w = 8, t = 8, num = 7, col = Vector()},
				b8 = {x = 10,y = 18, w = 8, t = 8, num = 8, col = Vector()},
				b9 = {x = 18,y = 18, w = 8, t = 8, num = 9, col = Vector()},
				b0 = {x = 2,y = 26, w = 24, t = 8, num = 0, col = Vector()}}

function ENT:DrawButton(x,y,w,t,num)
	
	surface.SetDrawColor(Color(50,50,50))
	surface.DrawRect(x,y,w,t)
	goal = nil
	if (self.X <=  x + w) and (self.X >= x) and (self.Y <= y + t) and (self.Y >= y) then
		goal = self.LerpedColor
		if LocalPlayer():KeyDown(IN_USE) and (not(pressed)) then
			print(num)
			pressed = true
			self.Buttons["b" .. tostring(num)]["col"] = self.UsedColor
			if string.len(self.Pass) == 4 then
				net.Start("SendPassword")
					net.WriteString(self.Pass)
				net.SendToServer()
				self.Pass = ""
			else
				self.Pass = self.Pass .. tostring(num)
			end
		else
			if not(LocalPlayer():KeyDown(IN_USE)) and pressed then pressed = false end
		end
	else goal = self.NLerpedColor end
	
	
	self.Buttons["b" .. tostring(num)]["col"] = Lerp(FrameTime()*4,self.Buttons["b" .. tostring(num)]["col"],goal)
	surface.SetDrawColor(Color(	self.Buttons["b" .. tostring(num)]["col"]["x"],
								self.Buttons["b" .. tostring(num)]["col"]["y"],
								self.Buttons["b" .. tostring(num)]["col"]["z"]
								))
	
	surface.DrawRect(x+self.BorderSize,y+self.BorderSize,w-2*self.BorderSize,t-2*self.BorderSize)
	cam.Start3D2D(self.Position,self.Ang,self.TextScale)
		draw.DrawText(num, "TextNumbers", (w/2+x)*(1/self.TextScale), (y + t/2 - 2)*(1/self.TextScale), Color(70, 70, 70, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
	cam.End3D2D()
end

function ENT:Draw()
		
	self.Entity:DrawModel();
	if (LocalPlayer():GetPos():Distance(self.Entity:GetPos()) < self.NoDrawDistance)
	and (self.Entity:WorldToLocal(LocalPlayer():GetPos())["z"]>2)
	and (self.Entity == LocalPlayer():GetEyeTrace()["Entity"]) then
		cam.Start3D2D(self.Position,self.Ang,1)
			surface.SetDrawColor(Color(50,50,50))//border
			surface.DrawRect(0,0,self.WindowSize["x"],self.WindowSize["y"])
			surface.SetDrawColor(Color(250,250,250))//canvas
			surface.DrawRect(self.BorderSize,self.BorderSize,self.WindowSize["x"]-2*self.BorderSize,self.WindowSize["y"]-2*self.BorderSize)
			surface.SetDrawColor(Color(50,50,50))
			//cursor point
			self.X = (self.Entity:WorldToLocal(self.trace["HitPos"])-self.Offset)["x"];
			self.Y = -(self.Entity:WorldToLocal(self.trace["HitPos"])-self.Offset)["y"];
			//debug
			//chat.AddText("X = "..tostring(math.floor(self.X)).." Y = " .. tostring(math.floor(self.Y)))
			for k,v in pairs(self.Buttons) do // buttons
				self:DrawButton(v["x"],v["y"],v["w"],v["t"],v["num"])
			end
			surface.SetDrawColor(Color(100,100,200)) // Cursor
			surface.DrawRect(self.X,self.Y,1,1)
		cam.End3D2D()
	end
end

function ENT:Think()
	self.trace = LocalPlayer():GetEyeTrace()
	self.Position = self.Entity:LocalToWorld(self.Offset)
	self.Ang = self.Entity:LocalToWorldAngles(self.Rotation)

end