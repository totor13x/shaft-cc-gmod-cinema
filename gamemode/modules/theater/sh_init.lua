THEATER_NONE = 0 		-- Default theater
THEATER_PRIVATE = 1 	-- Private theater which can be rented
THEATER_REPLICATED = 2 	-- Theater that should be networked
THEATER_PRIVILEGED = 4 	-- Theater restricted to privileged players

QUEUE_VOTEUPDOWN = 1
QUEUE_CHRONOLOGICAL = 2

hook.Add( "Think", "TheaterThink", function()
	for _, Theater in pairs(theater.GetTheaters()) do
		Theater:Think()
	end
end)

local url2 = url -- keep reference for extracting url data

-- Heuristic to fix old privileged theater flags prior to
-- THEATER_PRIVILEGED flag being changed from 3 to 4.
local function fixOldFlags(theaterInfo)
	local name = theaterInfo.Name
	local flags = theaterInfo.Flags

	if flags == 3 and name:lower():find("vip") then
		print("Fixed '"..name.."' privileged flag [https://goo.gl/hLOUu7]")
		return THEATER_PRIVILEGED
	else
		return flags
	end
end

-- Initialize the database table

-- sql.Query("DROP TABLE IF EXISTS cinema_history_shaft") -- Для удаления таблицы.

-- Проще сделать одну бд с одной структурой для клиента и сервера. 
sql.Query([[CREATE TABLE IF NOT EXISTS cinema_history_shaft ( 
	id INTEGER PRIMARY KEY,
	type VARCHAR(32),
	url VARCHAR(1024),
	title VARCHAR(512),
	data VARCHAR(2048),
	dataextra VARCHAR(2048),
	duration NUMERIC NOT NULL DEFAULT 0, 
	thumbnail VARCHAR(256),
	count NUMERIC NOT NULL DEFAULT 0,
	lastRequest NUMERIC NOT NULL DEFAULT 0,
	theater VARCHAR(16) DEFAULT 0
)]])

module( "theater", package.seeall )

Theaters = {}

function GetTheaters()
	return Theaters
end

function GetByLocation( locId, setup )

	local Theater = Theaters[locId]

	if SERVER and !Theater and setup then

		local loc = Location.GetLocationByIndex( locId )

		-- Theater defined in location code
		local info = loc.Theater

		-- Attempt to find theater_screen entity within location
		if !info then
			-- Скрин
			local screen = nil
			local screens = ents.FindByClass( "theater_screen" )

			-- Search for theater_screen entity
			for _, ent in pairs( screens ) do
				if IsValid(ent) and ent:GetPos():InBox( loc.Min, loc.Max ) then
					screen = ent
					break
				end
			end
			
			-- Оппозитная входу дверь
			local door_inside = nil
			local door_insides = ents.FindByClass( "theater_door" )

			-- Search for theater_screen entity
			for _, ent in pairs( door_insides ) do
				if IsValid(ent) and ent:GetPos():InBox( loc.Min, loc.Max ) then
					door_inside = ent
					break
				end
			end

			-- Found screen entity
			if IsValid(screen) then
				
				-- Cache keyvalues
				local kv = screen.keyvalues

				info = {}
				info.Name = kv.Name or kv.name or "[Missing Name]"
				info.Flags = tonumber(kv.flags) or THEATER_NONE
				info.ScreenEntity = screen
				
				info.Opp_ScreenEntity = door_inside
				
				info.Pos = screen:GetPos()
				info.Ang = screen:GetAngles()
				info.Width = tonumber(kv.width)
				info.Height = tonumber(kv.height)

				-- Check if the screen has targetted a thumbnail entity
				if kv.target then
					local target = ents.FindByName(kv.target)
					if target and IsValid(target[1]) then
						info.ThumbEnt = target[1]
					end
				end
				
				if kv.door then
					local target = ents.FindByName(kv.door)
					if target and IsValid(target[1]) then
						info.DoorEnt = target[1]
					end
				end

				info.Flags = fixOldFlags(info)

			end

		end

		-- Valid theater info
		if info then
			Theater = THEATER:Init(locId, info)
			Theaters[locId] = Theater
		end

	end

	return Theater

end

function GetNameByLocation( locId )
	return Theaters[locId] and Theaters[locId]:Name() or "Unknown"
end

function IsVideoTimed(type)
	return Services[type] and Services[type].IsTimed or false
end

function IsFlagSupported( Theater, flag )
	return bit.band( Theater:GetFlags(), flag ) == flag
end

local function ServiceMatch( Theater, service, data, ifsearchserials, body )

	-- Make sure this service can be used in the theater
	if service.TheaterType and (!Theater or !IsFlagSupported(Theater, service.TheaterType)) then
		return
	end

	-- Check if url matches
	if service:Match( data ) then
	
		if service.isSerials then
			if ifsearchserials then
			-- Ага, интересный способ сделать поиск сериалов. Похуй. 
				return service:SeriesMatch( body )
			else 
				return 
			end
		end
		
		-- Get url info
		return service:GetURLInfo( data )

	end

end

local function GetURLInfo( url, Theater )

	-- Parse url
	local status, data = pcall( url2.parse2, url )
	if !status then
		print( "ERROR:\n" .. tostring(data) )
		return false
	end

	if !data then
		return false
	end

	-- Keep reference to original url
	data.encoded = url

	local info

	-- Iterate through each service to check if the url is a valid request
	for _, service in pairs( Services ) do

		-- Ignore certain services
		if service.Hidden then
			continue
		end

		info = ServiceMatch( Theater, service, data, false )
		if istable(info) then
			info.Type = service:GetClass()
			return info
		end

	end

	-- Check for valid URL request
	local URLService = Services.url
	if URLService then
		info = ServiceMatch( Theater, URLService, data )
		if istable(info) then
			info.Type = URLService:GetClass()
			return info
		end
	end

	return false

end

local function SerialsService( body, url, Theater )
	
	-- Parse url
	local status, data = pcall( url2.parse2, url )
	if !status then
		print( "ERROR:\n" .. tostring(data) )
		return false
	end

	if !data then
		return false
	end

	-- Keep reference to original url
	data.encoded = url

	local info

	-- Iterate through each service to check if the url is a valid request
	for _, service in pairs( Services ) do

		-- Ignore certain services
		if service.Hidden then
			continue
		end

		info = ServiceMatch( Theater, service, data, true, body )
		if istable(info) then
			info.Type = service:GetClass()
			info.isSerials = service.isSerials
			info.extraParser = service.ExtraParser
			info.specText = service.SpecialText
			return info
		end

	end

	return false

end

function ExtractURLData( url, Theater )

	-- Parse url info
	local status, info = pcall( GetURLInfo, url, Theater )
	if !status then
		print( "ERROR:\n" .. tostring(info) )
		return
	end

	return info
end

function ChechIfSerialsService( body, url, Theater )

	-- Parse url info
	local status, info = pcall( SerialsService, body, url, Theater )
	
	if !status then
		print( "ERROR:\n" .. tostring(info) )
		return
	end
	
	return info

end

function GetQueueMode()
	return GetConVar("cinema_queue_mode"):GetInt()
end