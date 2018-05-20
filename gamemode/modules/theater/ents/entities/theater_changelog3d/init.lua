AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self:SetModel( "models/hunter/plates/plate2x2.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:DrawShadow( false )
end

function ENT:OnTakeDamage(dmg)
	return false
end
