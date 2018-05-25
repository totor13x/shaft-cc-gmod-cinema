AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self:SetModel( "models/hunter/plates/plate4x4.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:DrawShadow( false )
	self:SetType('minigame1')
	self:SetUseType( SIMPLE_USE )
	
	
end

function ENT:Use(activator, caller)
	if !IsFirstTimePredicted() then return end
	simonsays.AddPlayer(caller)
	simonsays.RemovePlayer(caller)
end