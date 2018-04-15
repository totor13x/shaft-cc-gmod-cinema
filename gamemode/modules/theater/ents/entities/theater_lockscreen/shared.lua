ENT.Type			= "anim"
ENT.Base			= "base_gmodentity"
ENT.PrintName		= "Lockscreen"
ENT.Author			= "Xerton"
ENT.Purpose 		= ""
ENT.Category		= "Screens"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true 

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "ParentDoor")
end