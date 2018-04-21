module( "theater", package.seeall )

util.AddNetworkString("update_history")
util.AddNetworkString("ReqHistory")

function Query( command )
	-- Ensure the log table exists
	if !sql.TableExists("cinema_history9") then
		
		Msg("Creating 'cinema_history9' table...\n")

		-- Initialize the database table
		sql.Query([[CREATE TABLE cinema_history9 (
			id INTEGER PRIMARY KEY,
			type VARCHAR(32),
			title VARCHAR(512),
			data VARCHAR(2048),
			duration NUMERIC NOT NULL DEFAULT 0,
			thumbnail VARCHAR(256),
			count NUMERIC NOT NULL DEFAULT 0,
			lastRequest NUMERIC NOT NULL DEFAULT 0,
			theater NUMERIC NOT NULL DEFAULT 0
		)]])

	end
	
	if command then
		return sql.Query( command )
	end

end

function GetVideoLog( data, type )
	
	
	local str = "SELECT * FROM cinema_history9 WHERE " .. 
		string.format("type='%s' AND ", type) ..
		string.format("data='%s'", data) .. " LIMIT 10"
	/*PrintTable(Query("SELECT * FROM cinema_history9"))
	print("sas")*/
	return Query(str)
	
	
end

function RemoveVideoLog( data, type )

	
	local str = "DELETE FROM cinema_history9 WHERE " .. 
		string.format("type='%s' AND ", type) ..
		string.format("data='%s'", data)

	return Query(str)

end

function LogVideo( Video, Theater )
	local Type = Video:Type()

	-- Streams can be offline, so caching results isn't a good idea
	if !IsVideoTimed( Type ) then
		return
	end

	local title = sql.SQLStr(Video:Title())
	local data = sql.SQLStr(Video:Data())
	local duration = Video:Duration()
	local thumbnail = sql.SQLStr(Video:Thumbnail())

	local str = "SELECT count FROM cinema_history9 WHERE " ..
		string.format("type='%s' AND ", Type) ..
		string.format("data=%s AND ", data) .. 
		string.format("theater='%s'", Theater["Id"])

	local results = Query(str)
	
	-- Video exists in history
	if type(results) == "table" then

		local count = tonumber(results[1].count) + 1

		-- Increment count
		str = "UPDATE cinema_history9 SET " ..
			string.format("lastRequest='%s', ", os.time()) ..
			string.format("count='%s' WHERE ", count) ..
			string.format("type='%s' AND ", Type) ..
			string.format("data=%s AND ", data) ..
			string.format("theater='%s'", Theater["Id"])

	else

		-- Insert new entry into the table
		str = "INSERT INTO cinema_history9 " ..
			"(type,title,data,duration,thumbnail,count,lastRequest,theater) " ..
			string.format( "VALUES ('%s', ", Type ) ..
			string.format( "%s, ", title ) ..
			string.format( "%s, ", data ) ..
			string.format( "'%s', ", duration ) ..
			string.format( "%s, ", thumbnail ) ..
			string.format( "'%s', ", 0 ) ..
			string.format( "'%s', ", os.time() ) ..
			string.format("'%s')", Theater["Id"])
	end
	
	return Query(str)

end

net.Receive("ReqHistory", function(len,ply)
	local db = Query("SELECT * FROM cinema_history9 WHERE theater = " .. ply:GetTheater()["Id"]) or {}
	net.Start("update_history")
	net.WriteTable(db)
	net.Send(ply)
end)

hook.Add( "PostVideoQueued", "LogQueuedVideo", theater.LogVideo )