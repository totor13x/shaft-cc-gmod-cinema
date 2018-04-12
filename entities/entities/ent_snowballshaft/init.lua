AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self.Coll = false
	self.Entity:SetModel("models/weapons/w_snowball.mdl");
	self.Entity:PhysicsInit(SOLID_VPHYSICS);
	//self.Entity:SetMoveType(MOVETYPE_VPHYSICS);
	self.Entity:SetSolid(SOLID_VPHYSICS);
	self.Entity:SetCollisionGroup(COLLISION_GROUP_NONE)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:EnableGravity(true);
	end
	self.Trail = util.SpriteTrail(self.Entity, 0, currentcolor, false, 15, 1, 0.2, 1/(15+1)*0.5, "trails/laser.vmt") 
end

function ENT:Think()
end

function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 16;
	local ent = ents.Create("ent_snowballshaft");
	ent:SetPos(SpawnPos);
	ent:Spawn();
	ent:Activate();
	ent:SetOwner(ply)
	return ent;
end

function ENT:PhysicsCollide(data)
	local pos = self.Entity:GetPos() --Get the position of the snowball
	local effectdata = EffectData()
	data.HitObject:ApplyForceCenter(self:GetPhysicsObject():GetVelocity() * 40)
	effectdata:SetStart( pos )
	effectdata:SetOrigin( pos )
	effectdata:SetScale( 1.5 )
	self:EmitSound("hit.wav")
	//util.Effect( "watersplash", effectdata ) -- effect
	//util.Effect( "inflator_magic", effectdata ) -- effect
	util.Effect( "WheelDust", effectdata ) -- effect
	util.Effect( "GlassImpact", effectdata ) -- effect
	self.Coll = true

end 


if SERVER then
function ENT:Think()

	if self.Coll then
		self:Remove()
	end

end
end
