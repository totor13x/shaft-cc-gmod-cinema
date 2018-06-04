local SERVICE = {}

SERVICE.Name 	= "kadu.ru"
SERVICE.IsTimed = true

function SERVICE:Match( url )
	return string.match( url.host, "kadu.ru" ) && string.match (url.encoded, "kadu.ru/video/(%d+)")
end

function SERVICE:GetURLInfo( url )
	local info = {}
	info.Data = url.encoded
	return info
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )
	local onReceive = function( body, length, headers, code )
	
		local info = {}

		info = DTS['KaduParse'](body, info, data)
		
		if onSuccess then
			pcall(onSuccess, info)
		end		
	end
	self:Fetch( data, onReceive, onFailure )
end

if CLIENT then
	function SERVICE:LoadVideo( Video, panel )
		local onFailure = function( str,url )
			error("Kadu Service: "..str..".\n"..Video:Data())
		end
		local onReceive = function( body, length, headers, code )
		

			local _,a = string.find(body,[[url':']],1, true)
			body = string.sub(body,a+1)
			a,b = string.find(body,[[',]],1, true)
			mp41 = string.sub(body,0,a-1)
			body = string.sub(body,b+1)

			local _,a = string.find(body,[[url2':']],1, true)
			body = string.sub(body,a+1)
			a,b = string.find(body,[[',]],1, true)
			mp42 = string.sub(body,0,a-1)
			body = string.sub(body,b+1)

			local startTime = CurTime() - Video:StartTime()
			local mp4 = string.find(mp41, '.mp4') and mp41 or mp42
			local tt = util.Base64Encode( mp4 )
			
			panel:OpenURL(string.format(DT['StardartHref'], tt, startTime))
			local str = string.format("if (window.theater) theater.setVolume(%s)", theater.GetVolume() )
			panel:QueueJavascript( str )
				
		end
		self:Fetch( Video:DataExtra(), onReceive, onFailure )
		
	end
end

theater.RegisterService( 'kadu', SERVICE )
