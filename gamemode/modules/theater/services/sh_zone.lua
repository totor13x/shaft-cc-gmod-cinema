local SERVICE = {}

SERVICE.Name 	= "ZONA"
SERVICE.IsTimed = true

function SERVICE:Match( url )
	return string.match( url.encoded, DT['ZonaDomain'] ) && string.match (url.path, "^/movies/([%w_-]+)")
end

function SERVICE:GetURLInfo( url )
	local info = {}
	info.Data = string.match( url.path, "/movies/([%w_-]+)" )
	return info
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )
	local onReceive = function( body, length, headers, code )
	
		local info = {}
		
		info = DTS['ZonaParse'](body, info)
		
		if onSuccess then
			pcall(onSuccess, info)
		end
	end
	local url = string.format( DT['ZonaAPI'], data )
	self:Fetch( url, onReceive, onFailure )
end

if CLIENT then
	function SERVICE:LoadVideo( Video, panel )
		local onFailure = function( str,url )
			error("ZONA Service: "..str..".\n"..Video:Data())
		end
		local onReceive = function( body, length, headers, code )
			
			if !body then
				return onFailure("Данные не получены.")
			end
			body = util.JSONToTable(body)
			if !body then
				return onFailure("Ошибка в разборе JSON.")
			end
						
			local startTime = CurTime() - Video:StartTime()
			
			local tt = util.Base64Encode( body['url'] )
			panel:OpenURL(string.format(DT['StardartHref'], tt, startTime))
			local str = string.format("if (window.theater) theater.setVolume(%s)", theater.GetVolume() )
			panel:QueueJavascript( str )
		end
		
		self:Fetch( Video:Data(), onReceive, onFailure )
	end
end

theater.RegisterService( 'zona', SERVICE )
