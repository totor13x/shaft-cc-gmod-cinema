concommand.Add("Spawn", function(ply,cmd,args)
	local SpawnPos = ply:GetEyeTrace()["HitPos"] + ply:GetEyeTrace()["HitNormal"] * 16;
	local ent = ents.Create("ent_lockscreen");
	ent:SetPos(SpawnPos);
	ent:Spawn();
	ent:Activate();
	ent.ConnectedTheater = theater.GetTheaters()[tonumber(args[1])]
end)