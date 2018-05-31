local dist = 40
local wantdist = 40 
local IsThirdPerson = false
function ZoomCam(ply, bind, pressed)
	local amt = 20

	local ball = ply

	if !IsValid(ball) then return end

	local distmin = ball:BoundingRadius()

	if dist == 0 then
		dist = distmin * 2
		wantdist = dist
	end

	if bind == "invnext" then
		wantdist = dist + amt
	elseif bind == "invprev" then
		wantdist = dist - amt
	end
	
	wantdist = math.Clamp(wantdist, distmin, 200)
end

function ZoomThink()
	dist = math.Approach(dist, wantdist, 500 * FrameTime())
	if dist < 50 then
		IsThirdPerson = false
	else
		IsThirdPerson = true
	end
	
end

hook.Add("PlayerBindPress", "ZoomCam", ZoomCam)
hook.Add("Think", "ZoomThink", ZoomThink)

local ThirdpersonOn = CreateClientConVar("deathrun_thirdperson_enabled", 0, true, false)

local function CalcViewThirdPerson( ply, pos, ang, fov, nearz, farz )
		-- test for thirdperson scoped weapons

	if ThirdpersonOn:GetBool() == true && IsThirdPerson and ply:Alive() and (ply:Team() ~= TEAM_SPECTATOR) then
		local view = {}

		local newpos = Vector(0,0,0)
		local nije = 9
		
		local vR = 0
		local vF = 0
		local iai = false
		/* First */
		if iai then
			dist = -100
			nije = -9
			vR = 180
			vF = 180
		end
		local tr = util.TraceHull(
			{
			start = pos, 
			endpos = pos + ang:Forward()*-dist + Vector(0,0,nije) + ang:Right()+ ang:Up(),
			mins = Vector(-5,-5,-5),
			maxs = Vector(5,5,5),
			filter = player.GetAll(),
			mask = MASK_SHOT_HULL
			
		})

		newpos = tr.HitPos
		view.origin = newpos

		local newang = ang
		newang:RotateAroundAxis( ply:EyeAngles():Right(), vR )
		newang:RotateAroundAxis( ply:EyeAngles():Up(), 0 )
		newang:RotateAroundAxis( ply:EyeAngles():Forward(), vF )

		view.angles = newang
		view.fov = fov

		--print( tracedist )

		return view
	end

end
hook.Add("CalcView", "deathrun_thirdperson_script", CalcViewThirdPerson )
local function DrawLocalPlayerThirdPerson()
	local ply = LocalPlayer()
	if ThirdpersonOn:GetBool() == true && IsThirdPerson and ply:Alive() and (ply:Team() ~= TEAM_SPECTATOR) then
		return true
	end
	return false
end
hook.Add("ShouldDrawLocalPlayer", "deathrun_thirdperson_script_shoild", DrawLocalPlayerThirdPerson)