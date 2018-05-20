module( "theater", package.seeall )


function Query( command )
	//print(command)
	if command then
		local a = sql.Query( command )
		//print(sql.LastError())
		return a
	end

end

function ClearRequestHistory()
	return Query( "DROP TABLE cinema_history_shaft" )
end

function RemoveRequestById( id )
	if !id then return end
	return Query( "DELETE FROM cinema_history_shaft WHERE id=" .. id )
end

history_cached = history_cached or {}

net.Receive("update_history", function()
	history_cached = {}
	history_cached = net.ReadTable()
	
	if GlobalFunction.ClearListVideo then GlobalFunction:ClearListVideo() end
	if GlobalFunction.RefreshList then GlobalFunction:RefreshList(history_cached) end
end)


function GetRequestHistory()

	local results =  {}
	if not(LocalPlayer():GetTheater():IsPrivate()) then
		//print("Getting history ...")
		net.Start("ReqHistory")
		net.SendToServer()
		results = history_cached
	else
		results = Query( "SELECT * FROM cinema_history_shaft" ) or {}
	end
	
	if #results > 0 then
		results.duration = tonumber(results.duration)
		results.count = tonumber(results.count)
		results.lastRequest = tonumber(results.lastRequest)
	end

	return results
	
end

local function CheckDuplicates(url, title, duration, vtype, data)
	local str = "SELECT id,count FROM cinema_history_shaft WHERE " .. -- Run it again, in case a New Entry was just added
		string.format("type=%s AND ", vtype) ..
		string.format("data=%s", data)

	local results = Query(str)
	local count = 0
	
	if results and #results > 1 then -- Check for multiple entries for same video type and data
		print("Duplicate entries in 'cinema_history_shaft' for type=" ..vtype.. " and data=" ..data.. ", fixing...")
		for vidkey, vid in pairs(results) do
			count = count + vid.count
			if vidkey > 1 then -- Don't delete the first entry!
				RemoveRequestById( vid.id )
			end
		end
		
		-- Update request count, duplicate detected
		str = "UPDATE cinema_history_shaft SET " ..
			string.format("lastRequest='%s', ", os.time()) ..
			string.format("title=%s, ", title) ..
			string.format("url=%s, ", url) ..
			string.format("count='%s' WHERE ", count) ..
			string.format("type=%s AND ", vtype) ..
			string.format("data=%s", data)
			
		Query(str)
	end
end

local function CheckOldSystem(url, title, duration, vtype, data)
	local str = "SELECT count FROM cinema_history_shaft WHERE " ..
		string.format("url=%s", url)
		
	local oldsyscheck = Query(str)
		
	if type(oldsyscheck) == "table" then
		local count = tonumber(oldsyscheck[1].count) + 1
		
		-- Update request count and make video entry compatible with new history system
		str = "UPDATE cinema_history_shaft SET " ..
			string.format("lastRequest='%s', ", os.time()) ..
			string.format("title=%s, ", title) ..
			string.format("type=%s, ", vtype) ..
			string.format("data=%s, ", data) ..
			string.format("count='%s' WHERE ", count) ..
			string.format("url=%s", url)

	else
		-- Insert new entry into the table
		str = "INSERT INTO cinema_history_shaft " ..
			"(title,url,duration,type,data,count,lastRequest) " ..
			string.format("VALUES (%s, ", title) ..
			string.format("%s, ", url) ..
			string.format("'%s', ", duration) ..
			string.format("%s, ", vtype) ..
			string.format("%s, ", data) ..
			string.format("'%s', ", 1) ..
			string.format("'%s')", os.time())
	end
	
	Query(str)
	
	CheckDuplicates(url, title, duration, vtype, data)
	
	return nil
end

function LogRequest()

	local url = net.ReadString()
	local title = net.ReadString()
	local duration = net.ReadInt(32)
	local vtype = net.ReadString()
	local data = net.ReadString()

	-- Notify player of video added to queue
	AddAnnouncement( {
		"Theater_VideoAddedToQueue",
		title
	} )

	-- Escape strings
	url = sql.SQLStr(url)
	title = sql.SQLStr(title)
	vtype = sql.SQLStr(vtype)
	data = sql.SQLStr(data)

	local str = "SELECT count,url FROM cinema_history_shaft WHERE " ..
		string.format("type=%s AND ", vtype) ..
		string.format("data=%s", data)

	local results = Query(str)
	
	if type(results) == "table" then
		local count = tonumber(results[1].count) + 1
		
		if results[1].url != url then
			str = CheckOldSystem(url, title, duration, vtype, data)
		else
			-- Update request count, url does not suggest duplicates
			str = "UPDATE cinema_history_shaft SET " ..
				string.format("lastRequest='%s', ", os.time()) ..
				string.format("title=%s, ", title) ..
				string.format("url=%s, ", url) ..
				string.format("count='%s' WHERE ", count) ..
				string.format("type=%s AND ", vtype) ..
				string.format("data=%s", data)
		
		end
	else -- Check if video exists in old history system
		str = CheckOldSystem(url, title, duration, vtype, data)
	end

	return Query(str)

end
net.Receive( "PlayerVideoQueued", theater.LogRequest )
