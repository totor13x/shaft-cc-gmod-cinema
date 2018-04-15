AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

util.AddNetworkString("SendPassword")
util.AddNetworkString("PassReply")

net.Receive("SendPassword", function(len,ply)
	a=net.ReadString()
	e=net.ReadEntity()
	
	local result = e.ConnectedTheater:GetPass() == a
	if result then
		e.GrantedDoor[ply:SteamID()] = true
	end
	
	net.Start("PassReply")
		net.WriteBool(result)
		net.WriteEntity(e)
	net.Send(ply)
end)

function ENT:Initialize()
	self.Entity:SetModel("models/hunter/plates/plate1x1.mdl");
	self.Entity:PhysicsInit(SOLID_VPHYSICS);
	self.Entity:SetMoveType(MOVETYPE_NONE);
	self.Entity:SetSolid(SOLID_VPHYSICS);
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:DrawShadow(false)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:EnableGravity(true);
	end
end


function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 16;
	local ent = ents.Create("ent_lockscreen");
	ent:SetPos(SpawnPos);
	ent:Spawn();
	ent:Activate();
	return ent;
end

function ENT:PhysicsCollide(data)
end