/*
function AddFootstep(ply, pos, ang)
	ang.p = 0
	ang.r = 0
	local fpos = pos
	if ply.LastFoot then
		fpos = fpos + ang:Right() * 5
	else
		fpos = fpos + ang:Right() * -5
	end
	ply.LastFoot = !ply.LastFoot

	local trace = {}
	trace.start = fpos
	trace.endpos = trace.start + Vector(0,0,-10)
	trace.filter = ply
	local tr = util.TraceLine(trace)
	print( tr.HitPos )
	if tr.Hit then
		ParticleEffect( 'halloween_boss_foot_impact', tr.HitPos+Vector(0,0,5), ang )
	end
end

net.Receive("add_footstep", function ()
	local ply = net.ReadEntity()
	local pos = net.ReadVector()
	local ang = net.ReadAngle()

	if !IsValid(ply) then return end

	//if ply == LocalPlayer() then return end

	//if !GAMEMODE:CanSeeFootsteps() then return end

	AddFootstep(ply, pos, ang)
end)
*/



local function RemoveParticleEffect(ply)

	if ply.CurParticle then

		if IsValid(ply.CurParticle) then

			if ply.CurParticle.RemoveEffect then

				ply.CurParticle:RemoveEffect()

			elseif ply.CurParticle.StopEmissionAndDestroyImmediately then

				ply.CurParticle:StopEmissionAndDestroyImmediately()

			end

		end

		ply.CurParticle = nil

	end

end

hook.Add("PostPlayerDraw", "Inventory.HandleParticleEffects", function(ply)

	if not IsValid(ply) then return end

	if not ply:Alive() then return end
	
	local renderDist = 1024//math.Clamp(51, 0, 1024)

	if renderDist == 0 then

		RemoveParticleEffect(ply)

		return

	elseif ply == LocalPlayer() then 
	
		if ( LocalPlayer():Alive() or ( LocalPlayer().IsGhosted and LocalPlayer():IsGhosted() ) ) and
			-- !Legs:CheckDrawVehicle() and
			GetViewEntity() == LocalPlayer() and
			!LocalPlayer():ShouldDrawLocalPlayer() and
			!LocalPlayer():GetObserverTarget() and
			!LocalPlayer().ShouldDisableLegs then

			RemoveParticleEffect(ply)

			return

		end

	elseif (ply:GetPos() - LocalPlayer():GetPos()):LengthSqr() >= renderDist*renderDist then

		RemoveParticleEffect(ply)

		return

	end
	if !IsValid(ply.CurParticle) then
		ply.CurParticle = ply:CreateParticleEffect("unusual_eyes_purple_parent", 0, {attachtype = PATTACH_ABSORIGIN, entity = ply})	
		ply.CurParticle:AddControlPoint( 0, ply, PATTACH_ABSORIGIN, 0, Vector( 0, 0, 70 ) ) 
	end
end)

