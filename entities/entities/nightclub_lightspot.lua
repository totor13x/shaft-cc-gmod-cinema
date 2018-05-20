AddCSLuaFile()

ENT.Type 		= "anim"
ENT.Base 		= "base_entity" 
ENT.PrintName		= ""
ENT.Author			= ""
ENT.Category		= ""

ENT.Editable		= true
ENT.Spawnable		= true
ENT.AdminOnly		= true

ENT.Model = "models/maxofs2d/lamp_projector.mdl" 

function ENT:SetupDataTables()
	self:NetworkVar("Vector", 0, "MidPos")
end

function ENT:Initialize()
	self:DrawShadow(false)
	if SERVER then
		self:SetModel(self.Model)
		self:PhysicsInit(SOLID_NONE)
	end 
	if CLIENT then
		self.OrigAngles = self:GetAngles()
	end
end

ENT.RenderGroup = RENDERGROUP_BOTH

if CLIENT then
	function ENT:RotBurst(str)
		self.BaseAngles = self.BaseAngles or self:GetAngles()

		local velStr = math.max(math.Rand(str*5, str*20), 3)
		if math.random() < 0.5 then velStr = -velStr end

		self.LightVel = Vector(velStr, velStr, 0)
		self:ShuffleLightTarg(str)
	end
	local minBounds, maxBounds = Vector(-170, -170, 0), Vector(200, 170, 0)

	function ENT:ShuffleLightTarg(str)
		local oldtarg = self.LightTarg or Vector(0, 0, 0)

		local mulx = Vector((oldtarg.x - minBounds.x) / (maxBounds.x - minBounds.x),
							(oldtarg.y - minBounds.y) / (maxBounds.y - minBounds.y),
							0)

		local sig1, sig2 = (math.random() > math.Remap(mulx.x, 0, 1, 0.35, 0.65) and 1 or -1),
						   (math.random() > math.Remap(mulx.y, 0, 1, 0.35, 0.65) and 1 or -1)

		local newtarg = Vector(oldtarg.x + sig1*str*100,
								oldtarg.y + sig2*str*100,
								0)

		--newtarg.x = math.Clamp(newtarg.x, minBounds.x, maxBounds.x)
		--newtarg.y = math.Clamp(newtarg.y, minBounds.y, maxBounds.y)
		newtarg.x = math.Rand(minBounds.x, maxBounds.x)
		newtarg.y = math.Rand(minBounds.y, maxBounds.y)

		self.LightTarg = newtarg
		self.LightSpeed = str*500
	end
	function ENT:OnBeat(str)
		local h, s, v = ColorToHSV(self.LightColor or Color(255, 255, 255))

		local dir = math.random() > 0.5 and 1 or -1
		h = h + math.random(30, 90)*dir*str

		s = 0.5
		v = 0.95

		self.LightColor = HSVToColor(h, s, v)
		--self.LightWidth = self.LightWidth + str*10

		self:RotBurst(str)
	end
	function ENT:Think()
		--[[
		local bdetect = self:GetMediaBeatDetector()
		local media = self:GetMedia()


		if bdetect then
			bdetect:addPeakListener("discolight." .. self:EntIndex(), function(str)
				local h, s, v = ColorToHSV(self.LightColor or Color(255, 255, 255))

				local dir = math.random() > 0.5 and 1 or -1
				h = h + math.random(30, 90)*dir*str

				s = 0.5
				v = 0.95

				self.LightColor = HSVToColor(h, s, v)
				self.LightWidth = self.LightWidth + str*10

				self:RotBurst(str)
			end)
		end]]
/*		
		local media = self:GetMedia()

		if not IsValid(media) then
			self.LightTarg = Vector(0, 0, 0)
			self.LightColor = nil
			self.LightSpeed = 25
		elseif media:getBaseService() ~= "bass" then
			self.LightColor = HSVToColor(((CurTime()*50) + self:EntIndex()*50)%360, 0.95, 0.5)

			local lpos = self.LightPos or Vector(0, 0, 0)
			local ltarg = self.LightTarg
			if ltarg and lpos:Distance(ltarg) < 10 then
				self.LightTarg = Vector(math.Rand(minBounds.x, maxBounds.x), math.Rand(minBounds.y, maxBounds.y), 0)
			end
			self.LightSpeed = 150
			self.LightWidth = 150 + math.sin(CurTime())*30
		end
*/
		local midpos = self:GetMidPos()

		--[[debugoverlay.Box(midpos, minBounds, maxBounds, 0.1, Color(255, 255, 255, 20), false)
		if self.LightTarg then
			debugoverlay.Box(midpos + self.LightTarg + Vector(0, 0, 10), Vector(-5, -5, -5), Vector(5, 5, 5), 0.1, Color(255, 127, 0), true)
		end
		if self.LightPos then
			debugoverlay.Box(midpos + self.LightPos + Vector(0, 0, 10), Vector(-5, -5, -5), Vector(5, 5, 5), 0.1, Color(0, 255, 0), true)
		end]]

		local ca = self:GetAngles()

		self.LightPos = self.LightPos or Vector(0, 0, 0)
		self.LightVel = self.LightVel or Vector(0, 0, 0)

		if self.LightTarg then
			local targAng = math.atan2(self.LightTarg.y - self.LightPos.y, self.LightTarg.x - self.LightPos.x)
			local lightDist = self.LightTarg:Distance(self.LightPos)
			self.LightVel = Vector(math.cos(targAng), math.sin(targAng), 0) * math.min((self.LightSpeed or 250), lightDist)
		end

		self.LightPos = self.LightPos + self.LightVel*FrameTime()

		self:SetAngles(((self.LightPos + midpos) - self:GetPos()):Angle())

		--[[self.LightWidth = self.LightWidth or 100
		local decr = (math.max(self.LightWidth-100, 0)/100)^2 * 40
		self.LightWidth = math.max(self.LightWidth-FrameTime()*decr, 100)]]
/*
		local bdetect = self:GetBeatDetector()
		if bdetect then
			self.LightWidth = 100 * math.max(bdetect:getCurrentRecentContextEnergy() ^ 1.5, 0.3)
		else
			self.LightWidth = self.LightWidth or 100
			self.LightWidth = self.LightWidth + (100 - self.LightWidth) / 50
		end
*/
		self.LightWidth = self.LightWidth or 100
		self.LightWidth = self.LightWidth + (100 - self.LightWidth) / 50
	end
end

if SERVER then
	function ENT:Think()
		self:SetMidPos(util.TraceLine{
			start = self:GetPos(), mask = MASK_SOLID_BRUSHONLY,
			endpos = self:GetPos()+self:GetForward()*99999, filter = self
		}.HitPos)
	end
end

local matLight = Material( "sprites/light_ignorez" )
local matBeam = Material( "effects/lamp_beam" )
function ENT:DrawTranslucent()
	self:DrawModel()
	self.LightWidth = self.LightWidth or 100

	local LightNrm = self:GetAngles():Forward()
	local ViewNormal = self:GetPos() - EyePos()
	local Distance = ViewNormal:Length()
	ViewNormal:Normalize()
	local ViewDot = ViewNormal:Dot( LightNrm * -1 )
	local LightPos = self:GetPos() + LightNrm * 8

	local r, g, b = 255, 255, 255
	if self.LightColor then
		r = self.LightColor.r
		g = self.LightColor.g
		b = self.LightColor.b
	end

	-- glow sprite
	render.SetMaterial( matBeam )
	render.StartBeam(2)
	render.AddBeam( LightPos + LightNrm * 1, self.LightWidth, 0.0, Color( r, g, b, 255) )
	render.AddBeam( LightPos + LightNrm * 450, self.LightWidth, 0.99, Color( r, g, b, 50) )
	render.EndBeam()

	if ( ViewDot >= 0 ) then
		   render.SetMaterial( matLight )

		self.PixVis = self.PixVis or util.GetPixelVisibleHandle()
		local Visibile = util.PixelVisible( LightPos, 16, self.PixVis )
		if (not Visibile) then return end

		local Size = math.Clamp( Distance * Visibile * ViewDot * 2, 64, 512 )
		Distance = math.Clamp( Distance, 32, 800 )
		local Alpha = math.Clamp( (1000 - Distance) * Visibile * ViewDot, 0, 100 )
		local Col = Color(r, g, b, Alpha)
		render.DrawSprite( LightPos, Size, Size, Col, Visibile * ViewDot )
		render.DrawSprite( LightPos, Size*0.4, Size*0.4, Color(255, 255, 255, Alpha), Visibile * ViewDot)
	end

	local tr = util.QuickTrace(self:GetPos(), LightNrm*9999, self)
	self:SetRenderBoundsWS(tr.StartPos, tr.HitPos)

	--[[local dlight = DynamicLight(self:EntIndex())
	if ( dlight ) then
		local dist = tr.HitPos:Distance(tr.StartPos)
		local dist = tr.HitPos:Distance(tr.StartPos)

		dlight.pos = tr.HitPos
		dlight.r = r
		dlight.g = g
		dlight.b = b
		dlight.brightness = 1
		dlight.Decay = 500
		dlight.Size = 2048
		dlight.DieTime = CurTime() + 0.5
	end]]
end
