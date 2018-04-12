local SERVICE = {}

SERVICE.Name 	= "Sibnet"
SERVICE.IsTimed = true

function SERVICE:Match( url )
	return string.match( url.host, "video.sibnet.ru" ) && string.match (url.encoded, "shell.*videoid=(.*)")
end

function SERVICE:GetURLInfo( url )
	local info = {}
	info.Data = string.match( url.encoded, "shell.*videoid=(.*)" )
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
		
		local _,a = string.find(body,[[og:image" content="]],1, true)
		body = string.sub(body,a+1)
		a,b = string.find(body,[["]],1, true)
		info.thumbnail = (string.sub(body,0,a-1))
		body = string.sub(body,b+1)
		
		local _,a = string.find(body,[[og:duration" content="]],1, true)
		body = string.sub(body,a+1)
		a,b = string.find(body,[["]],1, true)
		info.duration = (string.sub(body,0,a-1))
		body = string.sub(body,b+1)
				
		local _,a = string.find(body,[[player.src([{src: "]],1, true)
		body = string.sub(body,a+1)
		a,b = string.find(body,[[",]],1, true)
		info.data = (string.sub(body,0,a-1))
		body = string.sub(body,b+1)
		
		local _,a = string.find(body,[[videoname=]],1, true)
		body = string.sub(body,a+1)
		a,b = string.find(body,[[",]],1, true)
		info.title = decodeURI((string.sub(body,0,a-1)))
		body = string.sub(body,b+1)

		if onSuccess then
			pcall(onSuccess, info)
		end		
	end
	local url = string.format( "http://video.sibnet.ru/shell.php?videoid=%s", data )
	self:Fetch( url, onReceive, onFailure )
end

if CLIENT then
	function SERVICE:LoadVideo( Video, panel )
		local startTime = CurTime() - Video:StartTime()
		
		local tt = util.Base64Encode( Video:Data()  )
		panel:OpenURL('https://shaft.im/apps/cinema/videoplayer.sibnet.php?url='..tt..'&time='..startTime)
		local str = string.format("if (window.theater) theater.setVolume(%s)", theater.GetVolume() )
		panel:QueueJavascript( str )
		
	end
end

theater.RegisterService( 'sibnet', SERVICE )
