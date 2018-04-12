local SERVICE = {}

SERVICE.Name 	= "kadu.ru"
SERVICE.IsTimed = true
//http://kadu.ru/video/280884-Avatar_Legenda_ob_Aange-1_sezon_2_seriya
//http://kadu.ru/embed/280884?play
function SERVICE:Match( url )
	return string.match( url.host, "kadu.ru" ) && string.match (url.encoded, "kadu.ru/video/(%d+)")
end

function SERVICE:GetURLInfo( url )
	local info = {}
	//info.Data = string.match (url.encoded, "kadu.ru/video/(%d+)")
	info.Data = url.encoded
	return info
end

local char, gsub, tonumber = string.char, string.gsub, tonumber
local function _(hex) return char(tonumber(hex, 16)) end

local function decodeURI(s)
	s = gsub(s, '%%(%x%x)', _)
	return s
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )
	local onReceive = function( body, length, headers, code )
	
		local info = {}

		print(body)
		local _,a = string.find(body,[["og:image" content="]],1, true)
		body = string.sub(body,a+1)
		a,b = string.find(body,[[" /]],1, true)
		info.thumbnail = string.sub(body,0,a-1)
		body = string.sub(body,b+1)
		
		
		local _,a = string.find(body,[["og:video" content="]],1, true)
		body = string.sub(body,a+1)
		a,b = string.find(body,[[" /]],1, true)
		info.data = string.sub(body,0,a-1)
		body = string.sub(body,b+1)
				
		
		local _,a = string.find(body,[[og:duration" content="]],1, true)
		body = string.sub(body,a+1)
		a,b = string.find(body,[["]],1, true)
		info.duration = (string.sub(body,0,a-1))
		body = string.sub(body,b+1)

		local _,a = string.find(body,[[<a href='https://twitter.com/share]],1, true)
		body = string.sub(body,a+1)
		a,b = string.find(body,[[url=]],1, true)
		body = string.sub(body,b+1)
		
		local _,a = string.find(body,[[text=]],1, true)
		body = string.sub(body,a+1)
		a,b = string.find(body,[[' targe]],1, true)
		info.title = decodeURI(string.sub(body,0,a-1))
		body = string.sub(body,b+1)
		info.title = string.gsub( info.title, '+', ' ' )
		
		if onSuccess then
			pcall(onSuccess, info)
		end		
	end
	//local url = string.format( "http://kadu.ru/embed/%s?play", data )
	//print(url)
	self:Fetch( data, onReceive, onFailure )
end

if CLIENT then
	function SERVICE:LoadVideo( Video, panel )
		local onFailure = function( str,url )
			error("VK Service: "..str..".\n"..Video:Data())
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
			
			local tt = util.Base64Encode( mp41  )
			panel:OpenURL('https://shaft.im/apps/cinema/videoplayer.php?url='..tt..'&time='..startTime)
			local str = string.format("if (window.theater) theater.setVolume(%s)", theater.GetVolume() )
			panel:QueueJavascript( str )
				
		end
		self:Fetch( Video:Data(), onReceive, onFailure )
		
	end
end

theater.RegisterService( 'kadu', SERVICE )
