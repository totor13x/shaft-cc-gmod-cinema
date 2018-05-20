include('shared.lua')
ENT.SizeX = 80
ENT.SizeY = 80
ENT.RenderGroup 	= RENDERGROUP_TRANSLUCENT
ENT.Offset = Vector(ENT.SizeX,-ENT.SizeX,2)
ENT.Rotation = Angle(0,-180,0);

surface.CreateFont( "TextOpovechenieHARD", { size = 80, weight = 100 } )
surface.CreateFont( "TextOpovechenie", { size = 40, weight = 100 } )

function ENT:Draw()
	//self:DrawModel()
	cam.Start3D2D(self.Position,self.Ang,0.25)
		local h,w  = self.SizeX*8, self.SizeY*8
		draw.RoundedBox( 0, 0, 0, self.SizeX*8, self.SizeY*8, Color(255,255,255) )
		draw.SimpleText("В РАЗРАБОТКЕ", "TextOpovechenieHARD", w/2,(h/2)-200, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		draw.SimpleText("Данная локация", "TextOpovechenie", w/2,(h/2)-100, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		draw.SimpleText("находится в разработке", "TextOpovechenie", w/2,(h/2)-60, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		draw.SimpleText("с 18.05.2018 00:55 по МСК.", "TextOpovechenie", w/2,(h/2)-20, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		draw.SimpleText("Приблизительной даты открытия", "TextOpovechenie", w/2,(h/2)+40, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		draw.SimpleText("не имеется, но хотелось бы", "TextOpovechenie", w/2,(h/2)+80, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		draw.SimpleText("сделать в максимально короткие сроки", "TextOpovechenie", w/2,(h/2)+120, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		draw.SimpleText("Будет поддержка soundcloud", "TextOpovechenie", w/2,(h/2)+200, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		draw.SimpleText("", "TextOpovechenie", w/2,(h/2)+240, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
	cam.End3D2D()
end

function ENT:Think()
	self.Position = self:LocalToWorld(self.Offset)
	self.Ang = self.Entity:LocalToWorldAngles(self.Rotation)
end