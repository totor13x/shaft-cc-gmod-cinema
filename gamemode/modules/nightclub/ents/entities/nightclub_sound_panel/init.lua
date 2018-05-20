AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')


function ENT:Initialize()
	self:SetModel( "models/hunter/plates/plate4x4.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:DrawShadow( false )
end
/*
function ENT:Initialize()
	self:SetModel( "models/hunter/plates/plate4x4.mdl" )
	self:SetMoveType(MOVETYPE_NONE)
	self:SetUseType(SIMPLE_USE)	
	self:DrawShadow( false )
	//self:PhysicsInit(SOLID_NONE)
end
*/
function ENT:Use(activator, caller)

end
/*
function ENT:Think()
	if self.Pos != self:GetPos() or self.Ang != self:GetAngles() then
		print(self:GetPos(), self:GetAngles())
		self.Pos = self:GetPos()
		self.Ang = self:GetAngles()
	end
end
*/