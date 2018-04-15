include('shared.lua')

ENT.Rotation = Angle(0,0,0);
ENT.WindowSize = {x = 54, y = 90}
ENT.Offset = Vector(ENT.WindowSize.x*0.25*-1,ENT.WindowSize.y*0.25,1.6)
ENT.BorderSize = 0
ENT.NoDrawDistance = 200
ENT.TextScale = 0.05
ENT.SelfScaled = 4 //Это для рамок. Чтобы были жирными/тонкими

ENT.LerpedColor = Color(170,20,20)
ENT.NLerpedColor = Vector(230,230,230)
ENT.UsedColor = Vector(100,230,120)
ENT.Pass = ""


surface.CreateFont( "TextNumbersKeyPad", { size = 4*(1/ENT.TextScale), weight = 100 } )
surface.CreateFont( "TextNumbersDotPad", { size = 8*(1/ENT.TextScale), weight = 100 } )

ENT.Buttons = {	b1 = { x = 2,y = 18+2,w = 16, t = 16, num = 1, customLerpColor=Color(255,255,255),colblock = Vector(),  colborder = Vector(), alphaborders = 0, alphablock = 0, FakeActivated = false, isborder = false},
				b2 = {x = 16+1+2,y = 18+2, w = 16, t = 16, num = 2, customLerpColor=Color(255,255,255), colblock = Vector(),  colborder = Vector(), alphaborders = 0, alphablock = 0, FakeActivated = false, isborder = false},
				b3 = {x = 16+1+16+1+2,y = 18+2, w = 16, t = 16, num = 3, customLerpColor=Color(255,255,255), colblock = Vector(),  colborder = Vector(), alphaborders = 0, alphablock = 0, FakeActivated = false, isborder = false},
				b4 = {x = 2,y = 18+16+1+2, w = 16, t = 16, num = 4, customLerpColor=Color(255,255,255), colblock = Vector(),  colborder = Vector(), alphaborders = 0, alphablock = 0, FakeActivated = false, isborder = false},
				b5 = {x = 16+1+2,y = 18+16+1+2, w = 16, t = 16, num = 5, customLerpColor=Color(255,255,255), colblock = Vector(),  colborder = Vector(), alphaborders = 0, alphablock = 0, FakeActivated = false, isborder = false},
				b6 = {x = 16+1+16+1+2,y = 18+16+1+2, w = 16, t = 16, num = 6, customLerpColor=Color(255,255,255), colblock = Vector(),  colborder = Vector(), alphaborders = 0, alphablock = 0, FakeActivated = false, isborder = false},
				b7 = {x = 2,y = 18+16+1+2+16+1, w = 16, t = 16, num = 7, customLerpColor=Color(255,255,255), colblock = Vector(),  colborder = Vector(), alphaborders = 0, alphablock = 0, FakeActivated = false, isborder = false},
				b8 = {x = 16+1+2,y = 18+16+1+2+16+1, w = 16, t = 16, num = 8, customLerpColor=Color(255,255,255), colblock = Vector(),  colborder = Vector(), alphaborders = 0, alphablock = 0, FakeActivated = false, isborder = false},
				b9 = {x = 16+1+16+1+2,y = 18+16+1+2+16+1, w = 16, t = 16, num = 9, customLerpColor=Color(255,255,255), colblock = Vector(),  colborder = Vector(), alphaborders = 0, alphablock = 0, FakeActivated = false, isborder = false},
				b0 = {x = 2,y = 18+16+1+2+16+1+16+1, w = 16+16+16+2, t = 16, num = 0, customLerpColor=Color(255,255,255), colblock = Vector(),  colborder = Vector(), alphaborders = 0, alphablock = 0, FakeActivated = false, isborder = false},
				//bOK = {x = 2,y = 2+21+21+21, w = 20+20, t = 20, num = "OK", customLerpColor = Color(23, 120, 120), colblock = Vector(),  colborder = Vector(), alphaborders = 0, alphablock = 0, FakeActivated = true, isborder = false},
				/*
				b4 = {x = 2,y = 10, w = 9, t = 9, num = 4, col = Vector()},
				b5 = {x = 10,y = 10, w = 9, t = 9, num = 5, col = Vector()},
				b6 = {x = 18,y = 10, w = 9, t = 9, num = 6, col = Vector()},
				b7 = {x = 2,y = 18, w = 9, t = 9, num = 7, col = Vector()},
				b8 = {x = 10,y = 18, w = 9, t = 9, num = 8, col = Vector()},
				b9 = {x = 18,y = 18, w = 9, t = 9, num = 9, col = Vector()},
				b0 = {x = 2,y = 26, w = 24, t = 9, num = 0, col = Vector()}
				*/
				}
local positiondot = {
	[1] = {
		[1] = 0
		},
	[2] = {
		[1] = -40,
		[2] = 40,
		},
	[3] = {
		[1] = -80,
		[2] = 0,
		[3] = 80,
		},
	[4] = {
		[1] = -120,
		[2] = -40,
		[3] = 40,
		[4] = 120,
		}
	}
function ENT:DrawButton(x,y,w,h,num)
	//surface.SetDrawColor(Color(50,50,50))
	//surface.DrawRect(x,y,w,t)
	/*
	goal = nil
	if num == 1 then
	print(self.X, x + w, x,w)
	end
	if (self.X <=  x + w) and (self.X >= x) and (self.Y <= y + t) and (self.Y >= y) then
		goal = self.LerpedColor
		if LocalPlayer():KeyDown(IN_USE) and (not(pressed)) then
			print(num)
			pressed = true
			self.Buttons["b" .. num]["col"] = self.UsedColor
			if string.len(self.Pass) == 4 then
				net.Start("SendPassword")
					net.WriteString(self.Pass)
				net.SendToServer()
				self.Pass = ""
			else
				self.Pass = self.Pass .. num
			end
		else
			if not(LocalPlayer():KeyDown(IN_USE)) and pressed then pressed = false end
		end
	else 
		goal = self.NLerpedColor
	end
	
	
	self.Buttons["b" .. num]["col"] = Lerp(FrameTime()*4,self.Buttons["b" .. num]["col"],goal)
	surface.SetDrawColor(Color(	self.Buttons["b" .. num]["col"]["x"],
								self.Buttons["b" .. num]["col"]["y"],
								self.Buttons["b" .. num]["col"]["z"]
								))
	surface.DrawRect(x,y,w,t)
	*/
	h = h*self.SelfScaled/2
	w = w*self.SelfScaled/2
	x = x*self.SelfScaled/2
	y = y*self.SelfScaled/2
	local data = self.Buttons["b" .. num]
	if (data.alphablock != 0) then
		data.alphablock = Lerp(FrameTime()*18, data.alphablock, 0 )
		if data.alphaborders > 120 then
			data.alphaborders = data.alphablock
		end
	end
	if (!data.entered && data.alphaborders != 0) then
		data.alphaborders = Lerp(FrameTime()*17, data.alphaborders, 0 )
	end
	if data.FakeActivated && data.alphaborders < 70 then
		data.alphaborders = 70
	end

	if (self.X <=  x + w) and (self.X >= x) and (self.Y <= y + h) and (self.Y >= y) then
		data.alphaborders = 120
		data.entered = true
		if LocalPlayer():KeyDown(IN_USE) and (not(pressed)) then
			pressed = true
			data.alphablock = 255
		else
			if not(LocalPlayer():KeyDown(IN_USE)) and pressed then
				pressed = false
			end
		end
	else
		data.entered = false
	end
	
	local tempborders = table.Copy(self.LerpedColor) //Для блока
	tempborders.a = data.alphaborders//Для блока
	
	
	local tempblock = table.Copy(self.LerpedColor) //Для блока
	
	if data.customLerpColor && !data.isborder then
		tempblock = table.Copy(data.customLerpColor) //Для блока
	end
	
	tempblock.a = data.alphablock//Для блока
	
	local temptext = Color(255,255,255)
	temptext.a = 255 - (120-data.alphaborders)
	
	data["colblock"] = tempblock
	data["colborder"] = tempborders
	
	draw.RoundedBox( 0, x,y,w,h, data["colblock"] )
	//draw.RoundedBox( 0, x+w/2,y,w/2,h, data["colborder"] )
	//draw.RoundedBox( 0, x,y+h/2,w,h/2, data["colborder"] )
	
	if data.isborder then
		draw.RoundedBox( 0, x+1, y, w-2, 1, tempborders )
		draw.RoundedBox( 0, x, y, 1, h, tempborders )
		draw.RoundedBox( 0, x+w-1, y, 1, h, tempborders )
		draw.RoundedBox( 0, x+1, y+ h-1, w-2, 1, tempborders )
	else
		draw.RoundedBox( 0, x,y,w,h, data["colborder"] )
	end
	
	cam.Start3D2D(self.Position,self.Ang,self.TextScale)
		draw.DrawText(num, "TextNumbersKeyPad", (w/self.SelfScaled/2+x/self.SelfScaled)*(1/self.TextScale), (y/self.SelfScaled + h/self.SelfScaled/2 - 2)*(1/self.TextScale), temptext, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
	cam.End3D2D()
end

function ENT:Draw()
	
	self.Entity:DrawModel();
	if (LocalPlayer():GetPos():Distance(self.Entity:GetPos()) < self.NoDrawDistance)
	and (self.Entity:WorldToLocal(LocalPlayer():GetPos())["z"]>2)
	and (self.Entity == LocalPlayer():GetEyeTrace()["Entity"]) then
		cam.Start3D2D(self.Position,self.Ang,1/self.SelfScaled)
			local w,h = self.WindowSize["x"]*self.SelfScaled/2,self.WindowSize["y"]*self.SelfScaled/2
			draw.RoundedBox( 0, 0, 0,w,h,Color( 35, 35, 35,200) )
			local curpos = self.Entity:WorldToLocal(self.trace["HitPos"])-self.Offset
			self.X = curpos.x*self.SelfScaled;
			self.Y = -curpos.y*self.SelfScaled; 
			//debug
			//chat.AddText("X = "..tostring(math.floor(self.X)).." Y = " .. tostring(math.floor(self.Y)))
			
			local tempc = table.Copy(self.LerpedColor)
			tempc.a = 120
			local iserror = false
			if iserror then // Панель будет "потухать" типа ошибки
				local frequency, time = 9, RealTime()
				local red = math.sin( frequency * time ) * 128 + 128
				tempc.a = red
			end
			
			draw.RoundedBox( 0, 4, 4, w-8, 2, tempc )
			draw.RoundedBox( 0, 4, 36, w-8, 2, tempc )
			draw.RoundedBox( 0, 4, 6, 2, 30, tempc )
			draw.RoundedBox( 0, w-6, 6, 2, 30, tempc )
			
				cam.Start3D2D(self.Position,self.Ang,self.TextScale)
					local pass = ""
					local count = string.len(pass or "")
					if count != 0 then
						for i=1,count do
							draw.DrawText("•", "TextNumbersDotPad", ((w/self.SelfScaled/2)*(1/self.TextScale))-positiondot[count][i],( (6+24)/self.SelfScaled/2 - 2)*(1/self.TextScale), Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER	);
						end
					end
				cam.End3D2D()
			//draw.RoundedBox( 0, x, y, 1, h, self.LerpedColor )
			//draw.RoundedBox( 0, x+w-1, y, 1, h, self.LerpedColor )
			//draw.RoundedBox( 0, x+1, y+ h-1, w-2, 1, self.LerpedColor )
			
			for k,v in pairs(self.Buttons) do // buttons
				self:DrawButton(v["x"],v["y"],v["w"],v["t"],v["num"])
			end
			/*
		
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
			*/
		cam.End3D2D()
	end
end

function ENT:Think()
	self.trace = LocalPlayer():GetEyeTrace()
	self.Position = self.Entity:LocalToWorld(self.Offset)
	self.Ang = self.Entity:LocalToWorldAngles(self.Rotation)

end