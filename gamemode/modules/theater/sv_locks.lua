concommand.Add("Spawn", function(ply,cmd,args)
	//local SpawnPos = ply:GetEyeTrace()["HitPos"] + ply:GetEyeTrace()["HitNormal"] * 16;
	local SpawnPos = ply:GetEyeTrace()
	local entg = SpawnPos.Entity
	/*
	print( "Entity position:", entg:GetPos() )
	
	for i,v in pairs(ents.FindByClass("theater_lockscreen")) do
		v:Remove()
	end
	local ent = ents.Create("theater_lockscreen");
	//ent:SetPos(SpawnPos);
	ent:Spawn();
	ent:SetAngles( entg:GetAngles() + Angle(0,90,75) )
	ent:SetPos( entg:GetPos() + Vector(0,40,40) )
	//ent:Activate();
	ent.ConnectedTheater = theater.GetTheaters()[9]
	ent.GrantedDoor = {}
	ent.GrantedDoor[ply:SteamID()] = true
	 
	entg:SetLocker( ent )
	ent:SetParentDoor( entg )
	*/
	//PrintTable(theater.GetByLocation(9))
end)

for i,v in pairs(player.GetAll()) do
	v:ConCommand("Spawn")
end

for i,v in pairs(ents.FindByClass("theater_door")) do
	print(v.TeleportName)
end