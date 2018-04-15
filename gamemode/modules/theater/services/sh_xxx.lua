local SERVICE = {}

SERVICE.Name 			= "xxx"
SERVICE.IsTimed 		= true
SERVICE.Hidden 			= false

function SERVICE:Match( url )//   ^/movies/(.-).html
	return url.encoded and string.match(url.encoded, DT['24videoDomain']..'/video/view/(.-)$')  
end

function SERVICE:GetURLInfo( url )
	local info = {}
	info.Data = url.encoded
	return info

end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )
	local onReceive = function( body, length, headers, code )
	
		local info = {}
		
		info = DTS['24videoParse'](body, info)
		
		if onSuccess then
			pcall(onSuccess, info)
		end
		
	end
	
	self:Fetch( data, onReceive, onFailure )

end


if CLIENT then

	local char, gsub, tonumber = string.char, string.gsub, tonumber
	local function _(hex) return char(tonumber(hex, 16)) end

	function decodeURI(s)
		s = gsub(s, '%%(%x%x)', _)
		return s
	end

	function SERVICE:LoadVideo( Video, panel )
		//print(Video:Data())
		local onFailure = function( str,url )
			error("XXX Service: "..str..".\n"..Video:Data())
		end
		local onReceive = function( body, length, headers, code )
		
			local ip
			local ss
			local cover
			
			if (util.JSONToTable(body)['url'] == nil) then
				return onFailure("Ошибка. Выберите другое видео.")
			end
			
			local words = string.Explode( "&", decodeURI(util.JSONToTable(body)['url']) )
			for i,v in pairs(words) do
			
			if string.StartWith( v, 'url=' ) then
				ss = string.sub( v, 5 ) or "(Unknown)"
			end
			
			if string.StartWith( v, 'ip=' ) or string.StartWith( v, 'ttl=' ) then
				ip = v
			end
			
			if string.StartWith( v, 'cover=' ) then
				cover = v
			end
			 
			end
			
			local startTime = CurTime() - Video:StartTime()
			local tt = util.Base64Encode( ss.."%26"..ip )
			panel:OpenURL(string.format(DT['StardartHref'], tt, startTime))
			local str = string.format(
				"theater.setVolume(%s)", theater.GetVolume() )
			panel:QueueJavascript( str )
		end
		self:Fetch( string.format(DT['24videoAPI'], Video:Data()), onReceive, onFailure )
	end
end

theater.RegisterService( '24video', SERVICE )

SERVICE = {}

SERVICE.Name 			= "xxx"
SERVICE.IsTimed 		= true
SERVICE.Hidden 			= false

function SERVICE:Match( url )//   ^/movies/(.-).html
	return url.encoded and string.match(url.encoded, '://www.xvideos.com/video(.*)/.*$')  
end

function SERVICE:GetURLInfo( url )
	local info = {}
	info.Data = url.encoded
	return info

end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )
	local onReceive = function( body, length, headers, code )
	
		local info = {}
		
		info = DTS['XVideosParse'](body, info)
		
		if onSuccess then
			pcall(onSuccess, info)
		end
		
	end
	
	self:Fetch( data, onReceive, onFailure )

end


if CLIENT then

	local char, gsub, tonumber = string.char, string.gsub, tonumber
	local function _(hex) return char(tonumber(hex, 16)) end

	function decodeURI(s)
		s = gsub(s, '%%(%x%x)', _)
		return s
	end

	function SERVICE:LoadVideo( Video, panel )
		local onFailure = function( str,url )
			error("XXX Service: "..str..".\n"..Video:Data())
		end
		local onReceive = function( body, length, headers, code )
			local data
			local _,a = string.find(body,[[html5player.setVideoUrlLow(']],1, true)
			body = string.sub(body,a+1)
			a,b = string.find(body,[[']],1, true)
			local low = (string.sub(body,0,a-1))
			body = string.sub(body,b+1)
			
			local _,a = string.find(body,[[html5player.setVideoUrlHigh(']],1, true)
			body = string.sub(body,a+1)
			a,b = string.find(body,[[']],1, true)
			local high = (string.sub(body,0,a-1))
			body = string.sub(body,b+1)
			
			if GetConVar("cinema_hd"):GetBool() then
				data = high
			else
				data = low
			end
			
			local startTime = CurTime() - Video:StartTime()
			local tt = util.Base64Encode( data )
			
			panel:OpenURL(string.format(DT['StardartHref'], tt, startTime))
			
			local str = string.format(
				"theater.setVolume(%s)", theater.GetVolume() )
			panel:QueueJavascript( str )
			
		end
		self:Fetch( Video:Data(), onReceive, onFailure )

	end

end

theater.RegisterService( 'xvideos', SERVICE )
