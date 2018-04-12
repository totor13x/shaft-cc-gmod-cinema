Location.Add( "cinema_shaftim_beta",
{

	[ "Name" ] =
	{
		Min = Vector( -1622.7907714844, -912.48352050781, 2.5987091064453 ),
		Max = Vector( 165.20408630371, 467.9182434082, 774.90936279297 ),
	},



} )

ChairOffsets = {
	["models/totor/chairs/hall_chair.mdl"] = {
		{ Pos = Vector(-1.5, 7.5, -2.9), Ang = Angle(0, 180, 0) }
	},
	["models/totor/cinema/bench.mdl"] = {
		{ Pos = Vector(0, 0, -1), Ang = Angle(0, 180, 0) },
		{ Pos = Vector(-35, 0, -1), Ang = Angle(0, 180, 0) },
		{ Pos = Vector(35, 0, -1), Ang = Angle(0, 180, 0) }
	},
	["models/totor/restoran/chair.mdl"] = {
		{ Pos = Vector(0, -2.0, 17), Ang = Angle(0, -180, 0) }
	},
}
if CLIENT then
hook.Remove("Think", 'CheckLight')
end