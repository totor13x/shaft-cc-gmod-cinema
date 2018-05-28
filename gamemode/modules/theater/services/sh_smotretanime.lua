local SERVICE = {}

SERVICE.Name 	= "Anime365"
SERVICE.IsTimed = true

//https://smotret-anime.ru/catalog/boku-no-hero-academia-3rd-season-18171/1-seriya-172538/ozvuchka-1787905
//https://smotret-anime.ru/translations/embed/1787905
//https://smotret-anime.ru/catalog/boku-no-hero-academia-3rd-season-18171/2-seriya-172890/ozvuchka-1799382
//https://smotret-anime.ru/translations/embed/1799382
/*
authority	=	w1.zona.plus
encoded	=	https://w1.zona.plus/movies/pervomu-igroku-prigotovitsya
host	=	w1.zona.plus
path	=	/movies/pervomu-igroku-prigotovitsya
scheme	=	https
*/
/*
local url = {}
url.encoded = 'https://smotret-anime.ru/catalog/boku-no-hero-academia-3rd-season-18171/2-seriya-172890/ozvuchka-1799382'
url.host = 'smotret-anime.ru'
url.path = '/catalog/boku-no-hero-academia-3rd-season-18171/2-seriya-172890/ozvuchka-1799382'
*/

function SERVICE:Match( url )
	return string.match( url.encoded, 'smotret.anime.ru' ) && string.match (url.path, ".*ozvuchka.(%d+)")
end

function SERVICE:GetURLInfo( url )
	local info = {}
	info.Data = url.encoded
	return info
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )
	local onReceive = function( body, length, headers, code )
	
		local info = {}
		
		local _,a = string.find(body,[["og:image" content="]],1, true)
		body = string.sub(body,a+1)
		a,b = string.find(body,[[" /]],1, true)
		info.thumbnail = string.sub(body,0,a-1)
		body = string.sub(body,b+1)	

		local _,a = string.find(body,[["og:video" content="]],1, true)
		body = string.sub(body,a+1)
		a,b = string.find(body,[[" /]],1, true)
		info.dataextra = string.sub(body,0,a-1)
		body = string.sub(body,b+1)
	
		local _,a = string.find(body,[[video:duration" content="]],1, true)
		body = string.sub(body,a+1)
		a,b = string.find(body,[["]],1, true)
		info.duration = (string.sub(body,0,a-1))
		body = string.sub(body,b+1)

		local _,a = string.find(body,[[<title>]],1, true)
		body = string.sub(body,a+1)
		a,b = string.find(body,[[</title>]],1, true)
		info.title = (string.sub(body,0,a-1))
		body = string.sub(body,b+1)

		info.data = data//string.format( DT['Anime365API'], data )
				
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
			error("Anime365 Service: "..str..".\n"..Video:Data())
		end
		local onReceive = function( body, length, headers, code )
			local _,a = string.find(body,[[data-sources="]],1, true)
			body = string.sub(body,a+1)
			a,b = string.find(body,[["]],1, true)
			json = (string.sub(body,0,a-1))
			body = string.sub(body,b+1)
			
			json = decodeURI(json)
			json = url.htmlentities_decode(json)
			
			if !json then
				return onFailure("Данные не получены.")
			end
			json = util.JSONToTable(json)
			if !json then
				return onFailure("Ошибка в разборе JSON.")
			end
				
			//TODO: 1080 ?
			local low, high = nil, nil
			
			for i,v in pairs(json) do
				if v.height == 720 then
					high = v.urls[1]
				end
				if v.height == 360 then
					low = v.urls[1]
				end
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
			local tt = util.Base64Encode( data )
			panel:OpenURL(string.format(DT['StardartHref'], tt, startTime))
			local str = string.format("if (window.theater) theater.setVolume(%s)", theater.GetVolume() )
			panel:QueueJavascript( str )
			
		end
		
		self:Fetch( Video:DataExtra(), onReceive, onFailure )
	end
end

theater.RegisterService( 'smotretanime', SERVICE )
