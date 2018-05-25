AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Type")
	self:NetworkVar("String", 0, "Type")
end

function ENT:KeyValue(key, value)
   if key == "type" then
		self:SetType(value)
   end
end

if SERVER then
	game.CleanUpMap()
end

function ENT:Initialize()
	if self:GetType() == 'Hurt_Back' then
		self:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	end
	self:PhysicsInit(SOLID_BSP)
end
