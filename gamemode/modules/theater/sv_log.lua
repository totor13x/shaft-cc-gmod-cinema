module( "theater", package.seeall )

util.AddNetworkString("update_history")
util.AddNetworkString("ReqHistory")

function Query( command )
	//print(command)
	if command then
		local a = sql.Query( command )
		//print(sql.LastError())
		return a
	end

end

function GetVideoLog( data, type )
	
	
	local str = "SELECT * FROM cinema_history_shaft WHERE " .. 
		string.format("type='%s' AND ", type) ..
		string.format("data='%s'", data) .. " LIMIT 10"
		
	return Query(str)
	
	
end

function RemoveVideoLog( data, type )

	
	local str = "DELETE FROM cinema_history_shaft WHERE " .. 
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
	local dataextra = sql.SQLStr(Video:DataExtra())

	local str = "SELECT count FROM cinema_history_shaft WHERE " ..
		string.format("type='%s' AND ", Type) ..
		string.format("data=%s AND ", data) .. 
		string.format("theater='%s'", Theater["Id"])

	local results = Query(str)
	
	-- Video exists in history
	if type(results) == "table" then

		local count = tonumber(results[1].count) + 1

		-- Increment count
		str = "UPDATE cinema_history_shaft SET " ..
			string.format("lastRequest='%s', ", os.time()) ..
			string.format("count='%s' WHERE ", count) ..
			string.format("type='%s' AND ", Type) ..
			string.format("data=%s AND ", data) ..
			string.format("theater='%s'", Theater["Id"])

	else

		-- Insert new entry into the table
		str = "INSERT INTO cinema_history_shaft " ..
			"(type,title,data,duration,thumbnail,count,lastRequest,dataextra,theater) " ..
			string.format( "VALUES ('%s', ", Type ) ..
			string.format( "%s, ", title ) ..
			string.format( "%s, ", data ) ..
			string.format( "'%s', ", duration ) ..
			string.format( "%s, ", thumbnail ) ..
			string.format( "'%s', ", 0 ) ..
			string.format( "'%s', ", os.time() ) ..
			string.format( "%s, ",dataextra ) ..
			string.format("'%s')", Theater["Id"])
	end
	
	return Query(str)

end

net.Receive("ReqHistory", function(len,ply)
	local db = Query("SELECT * FROM cinema_history_shaft WHERE theater = " .. ply:GetTheater()["Id"] ) or {}
	//PrintTable(db)
	net.Start("update_history")
	net.WriteTable(db)
	net.Send(ply)
end)

hook.Add( "PostVideoQueued", "LogQueuedVideo", theater.LogVideo )