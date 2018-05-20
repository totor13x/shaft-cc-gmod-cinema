local SERVICE = {}

SERVICE.Name 	= "Stormo.tv"
SERVICE.IsTimed = true
SERVICE.Hidden = true

function SERVICE:Match( url )
	return string.match( url.host, "stormo.tv" )
end

function SERVICE:GetURLInfo( url )
	local info = {}
	info.Data =  url.encoded
	return info
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )
	local onReceive = function( body, length, headers, code )
		local info = {}
		
		info = DTS['StormoParse'](body, info)
		
		if onSuccess then
			pcall(onSuccess, info)
		end		
	end
	self:Fetch( data, onReceive, onFailure )
end

if CLIENT then
	function SERVICE:LoadVideo( Video, panel )

			
			local startTime = CurTime() - Video:StartTime()
			local tt = util.Base64Encode( data )
			
			panel:OpenURL(string.format(DT['StardartHref'], tt, startTime))
			
			local str = string.format(
				"theater.setVolume(%s)", theater.GetVolume() )
			panel:QueueJavascript( str )
		
	end
end

theater.RegisterService( 'stormo', SERVICE )
