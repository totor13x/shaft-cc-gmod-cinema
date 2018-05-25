ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true 

ENT.PrintName	 = "Queue"
ENT.Author		 = "Totor"
ENT.Contact		 = ""
ENT.Spawnable			= true
ENT.AdminSpawnable		= true 

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Type")
	self:NetworkVar("String", 1, "Players")
end
