local SERVICE = {}

SERVICE.Name 	= "ZONA"
SERVICE.IsTimed = true
//https://zona.video/movies/lesnaya-bratva
function SERVICE:Match( url )
	return string.match( url.host, "w1.zona.plus" ) && string.match (url.path, "^/movies/([%w_-]+)")
end

function SERVICE:GetURLInfo( url )
	local info = {}
	info.Data = string.match( url.path, "/movies/([%w_-]+)" )
	return info
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )
	local onReceive = function( body, length, headers, code )
	
		local info = {}
		
		
		local _,a = string.find(body,[[<meta itemprop="image" content="]],1, true)
		body = string.sub(body,a+1)
		a,b = string.find(body,[[">]],1, true)
		info.thumbnail = (string.sub(body,0,a-1))
		body = string.sub(body,b+1)
		
		_,a = string.find(body,[[<time datetime="PT]],1, true)
		body = string.sub(body,a+1)
		a,b = string.find(body,[[M">]],1, true)
		info.duration = tonumber(string.sub(body,0,a-1) or 0)*60
		body = string.sub(body,b+1)
		
		_,a = string.find(body,[[class="entity-player" data-id="]],1, true)
		body = string.sub(body,a+1)
		a,b = string.find(body,[["]],1, true)
		info.data = HTTP_AJAX_ZONA..(string.sub(body,0,a-1))
		body = string.sub(body,b+1)
		
		
		_,a = string.find(body,[[<meta itemprop="name" content="]],1, true)
		body = string.sub(body,a+1)
		a,b = string.find(body,[[" /]],1, true)
		info.title = (string.sub(body,0,a-1))
		
		//PrintTable(info)
		
		if onSuccess then
			pcall(onSuccess, info)
		end
		//https://zona.video/ajax/video/1
		//info.data = media.player
		
		//if not string.match( info.data , "/vk.com/" ) then
			//return pcall(onFailure,"Ошибка - медиафайл не использует плеер VK. Оригинал: "..info.data)
		//end
		
	end
	local url = string.format( "https://w1.zona.plus/movies/%s", data )
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
			panel:OpenURL('https://shaft.im/apps/cinema/videoplayer.php?url='..tt..'&time='..startTime)
			local str = string.format("if (window.theater) theater.setVolume(%s)", theater.GetVolume() )
			panel:QueueJavascript( str )
		end
		
		self:Fetch( Video:Data(), onReceive, onFailure )
	end
end

theater.RegisterService( 'zona', SERVICE )
