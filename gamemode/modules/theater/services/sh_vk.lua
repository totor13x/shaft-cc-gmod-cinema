local SERVICE = {}

SERVICE.Name 	= "VK"
SERVICE.IsTimed = true

function SERVICE:Match( url )
	return string.match( url.encoded, "/vk.com/.*video([-|%d]%d+_%d+).*" )
end

function SERVICE:GetURLInfo( url )
	local info = {}
	info.Data = string.match( url.encoded, "/vk.com/.*video([-|%d]%d+_%d+).*" )
	return info
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )
	local onReceive = function( body, length, headers, code )
		local receive = util.JSONToTable(body)
		if !receive then
			return pcall(onFailure,"Данные не получены.")
		end
		local erro = receive["error"]
		if erro then
			local txt = "Произошла ошибка."
			if erro.error_code then
				txt = txt .. " Код ошибки: "..erro.error_code
			end
			if erro.error_msg then
				txt = txt .. " - " .. erro.error_msg 
			end
			return pcall(onFailure,txt)
		end
		
		local media = receive["response"]['items'][1]
		
		if not media then
			return pcall(onFailure,"Видеозапись не найдена.")
		end
		
		local info = {}
		info.title = media.title
		info.thumbnail = media.photo_320
		info.duration = media.duration
		info.data = "https://vk.com/video"..data
		info.dataextra = media.player
		
		if not string.match( info.dataextra , "/vk.com/" ) then
			return pcall(onFailure,"Ошибка - медиафайл не использует плеер VK. Оригинал: "..info.data)
		end
		
		if onSuccess then
			pcall(onSuccess, info)
		end
	end
	local url = string.format( DT['VKAPI'], data, DT['API_KEY_VK'] )
	self:Fetch( url, onReceive, onFailure )
end

if CLIENT then
	function SERVICE:LoadVideo( Video, panel )
		local onFailure = function( str,url )
			error("VK Service: "..str..".\n"..Video:Data())
		end
		local onReceive = function( body, length, headers, code )
			if !body then
				return onFailure("Данные не получены.")
			end
			
			local err = string.match(body,[[<div id="video_ext_msg">(.-)</div>]])
			
			if err then
				return onFailure("Ошибка. "..err)
			end
			
			local sources = {}
			for i in string.gmatch(body,[[<source src="(.-)"]]) do
				local qual = string.match(i,"(%d+).mp4")
				if !qual then continue end
				sources[qual] = i
			end
			
			if table.Count( sources ) == 0 then
				return onFailure("Не найдены досутпные медиафайлы.")
			end
			
			local low = sources['240']
			local high = sources['240']
			
			if sources['1080'] then
				high = sources['1080'] 
				low = sources['480'] 
			end
			if sources['720'] then
				high = sources['720'] 
				low = sources['360'] 
			end
			if sources['480'] then
				high = sources['480']
				low = sources['480'] 
			end
			if sources['360'] then
				high = sources['360']
				low = sources['360'] 
			end
			
			if !high and !low then
				return onFailure("Не могу получить ссылку на видео.")
			end
			
			if GetConVar("cinema_hd"):GetBool() then
				data = high
			else
				data = low
			end
			
			local startTime = CurTime() - Video:StartTime()
			
			data = string.Explode("?",data)[1] 
			local startTime = CurTime() - Video:StartTime()
			
			local tt = util.Base64Encode( data )
			panel:OpenURL(string.format(DT['StardartHref'], tt, startTime))
			local str = string.format("if (window.theater) theater.setVolume(%s)", theater.GetVolume() )
			panel:QueueJavascript( str )
			/*
			panel:OpenURL(string.format(DT['VKHref'], data, startTime))
			local str = string.format("theater.setVolume(%s)", theater.GetVolume() )
			panel:QueueJavascript( str )
			*/
		end
		print(Video:DataExtra())
		self:Fetch( Video:DataExtra(), onReceive, onFailure )
	end

end

theater.RegisterService( 'vk', SERVICE )