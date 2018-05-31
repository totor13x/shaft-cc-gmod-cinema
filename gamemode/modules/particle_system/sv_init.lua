util.AddNetworkString("add_footstep")
util.AddNetworkString("clear_footsteps")

function GM:PlayerFootstep(ply, pos, foot, sound, volume, filter)
	if ply:IsSuperAdmin() then
		net.Start("add_footstep")
		net.WriteEntity(ply)
		net.WriteVector(pos)
		net.WriteAngle(ply:GetAimVector():Angle())
		--[[
		local tab = {}
		for k, ply in pairs(player.GetAll()) do
			if self:CanSeeFootsteps(ply) then
				table.insert(tab, ply)
			end
		end
		]]--
		net.Broadcast()
	end
end
