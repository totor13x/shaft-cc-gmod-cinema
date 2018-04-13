include('shared.lua')

ENT.Rotation = Angle(0,0,0);
ENT.Offset = Vector(-23,23,1.6)
ENT.WindowSize = {x = 46, y = 46}
ENT.BorderSize = 1

ENT.Buttons = {	s1 = { x = 2,y = 2,w = 8, t = 8},
				s2 = {x = 10,y = 2, w = 8, t = 8},
				s3 = {x = 18,y = 2, w = 8, t = 8},
				s4 = {x = 2,y = 10, w = 8, t = 8},
				s5 = {x = 10,y = 10, w = 8, t = 8},
				s6 = {x = 18,y = 10, w = 8, t = 8},
				s7 = {x = 2,y = 18, w = 8, t = 8},
				s8 = {x = 10,y = 18, w = 8, t = 8},
				s9 = {x = 18,y = 18, w = 8, t = 8},
				s0 = {x = 2,y = 26, w = 24, t = 8}}

function ENT:DrawButton(x,y,w,t,num)
	surface.SetDrawColor(Color(50,50,50))
	surface.DrawRect(x,y,w,t)
	if (self.X <=  x + w) and (self.X >= x) and (self.Y <= y + t) and (self.Y >= y) then surface.SetDrawColor(Color(150,150,230))
	else surface.SetDrawColor(Color(230,230,230)) end
	surface.DrawRect(x+self.BorderSize,y+self.BorderSize,w-2*self.BorderSize,t-2*self.BorderSize)
	surface.SetFont( "HUDHintTextSmall" )
	surface.SetTextColor( 255, 255, 255 )
	surface.SetTextPos( 4, 4 )
	surface.DrawText("1")
end

function ENT:Draw()
		
	self.Entity:DrawModel();
	if LocalPlayer():GetPos():Distance(self.Entity:GetPos()) < 300 then
		cam.Start3D2D(self.Position,self.Ang,1)
			surface.SetDrawColor(Color(50,50,50))
			surface.DrawRect(0,0,self.WindowSize["x"],self.WindowSize["y"])
			surface.SetDrawColor(Color(250,250,250))
			surface.DrawRect(self.BorderSize,self.BorderSize,self.WindowSize["x"]-2*self.BorderSize,self.WindowSize["y"]-2*self.BorderSize)
			surface.SetDrawColor(Color(50,50,50))
			self.X = (self.Entity:WorldToLocal(self.trace["HitPos"])-self.Offset)["x"];
			self.Y = -(self.Entity:WorldToLocal(self.trace["HitPos"])-self.Offset)["y"];
			chat.AddText("X = "..tostring(math.floor(self.X)).." Y = " .. tostring(math.floor(self.Y)))
			for k,v in pairs(self.Buttons) do
				self:DrawButton(v["x"],v["y"],v["w"],v["t"])
			end
			surface.SetDrawColor(Color(100,100,200))
			surface.DrawRect(self.X,self.Y,1,1)
		cam.End3D2D()
	end
end

function ENT:Think()
	self.trace = LocalPlayer():GetEyeTrace()
	self.Position = self.Entity:LocalToWorld(self.Offset)
	self.Ang = self.Entity:LocalToWorldAngles(self.Rotation)

end