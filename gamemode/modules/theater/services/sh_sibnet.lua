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
		
		info = DTS['SibnetParse'](body, info)
		
		if onSuccess then
			pcall(onSuccess, info)
		end		
	end
	local url = string.format( DT['SibnetAPI'], data )
	self:Fetch( url, onReceive, onFailure )
end

if CLIENT then
	function SERVICE:LoadVideo( Video, panel )
		local startTime = CurTime() - Video:StartTime()
		
		local tt = util.Base64Encode( Video:Data()  )
		
		panel:OpenURL(string.format(DT['SibnetHref'], tt, startTime))
		local str = string.format("if (window.theater) theater.setVolume(%s)", theater.GetVolume() )
		panel:QueueJavascript( str )
		
	end
end

theater.RegisterService( 'sibnet', SERVICE )
