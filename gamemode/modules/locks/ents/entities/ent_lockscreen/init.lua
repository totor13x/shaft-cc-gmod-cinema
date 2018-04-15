AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

util.AddNetworkString("SendPassword")
util.AddNetworkString("PassReply")

net.Receive("SendPassword", function(len,ply)
		a=net.ReadString()
		e=net.ReadEntity()
		SendReply(ply,e.ConnectedTheater:GetPass() == a)
	end)

function SendReply(ply, bool)
	net.Start("PassReply")
		net.WriteBool(bool)
	net.Send(ply)
end

function ENT:Initialize()
	self.Entity:SetModel("models/hunter/plates/plate1x1.mdl");
	self.Entity:PhysicsInit(SOLID_VPHYSICS);
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS);
	self.Entity:SetSolid(SOLID_VPHYSICS);
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:EnableGravity(true);
	end
end

function ENT:Think()
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

function ENT:Think()

end