DT = {}
DTS = {}
DT['API_KEY_VK'] = '4f515d0bf72ecb3aa6a10345e564ab2a22f6d6b5b5be5b59766abb5e9613690a0611dbe18a01cd258d7ce' // Api ключ от VK
DT['VKHref'] = 'http://api.shaft.im/lidi/cinema/vk/video.php?url=%s&time=%s' // Хз, не помню что это за файл. Похоже флешплеер.
DT['VKAPI'] = "https://api.vk.com/method/video.get?videos=%s&access_token=%s" // Ссылка на необходимое API VK
DT['StardartHref'] = 'https://shaft.im/apps/cinema/videoplayer.php?url=%s&time=%s' //Стандартная маска-ссылка на плеер
DT['SibnetAPI'] = "http://video.sibnet.ru/shell.php?videoid=%s" //Данные со Sibnet
DT['SibnetHref'] = 'https://shaft.im/apps/cinema/videoplayer.sibnet.php?url=%s&time=%s' //Специальная маска-ссылка на плеер для sibnet
DT['youtubeAPIKEY'] = "AIzaSyDxIgu2n-aIMsc2IhKqDrvkJCxkhApevoc" //API Ключ от ютуба 
DT['ZonaDomain'] = "https://w1.zona.plus" //Ссылка на Zona (потому что блокируется роскомнадзором)
DT['ZonaAPI'] = DT['ZonaDomain'].."/movies/%s" //Парс зоны
DT['HTTP_AJAX_ZONA'] = DT['ZonaDomain']..'/ajax/video/' // Только ID нужен. Есть защита от парса по IP. Ссылка выдается по IP. 30.12.2017
DT['24videoDomain'] = "24video.sexy" //Ссылка на 24video
DT['24videoAPI'] = 'http://'..DT['24videoDomain']..'/video/downloadZonaUrl?id=%s' //Парс 24video


util.AddNetworkString( "UpdateDT" )

if #player.GetAll() > 0 then
	net.Start("UpdateDT")
	net.WriteTable(DT) 
	net.Broadcast()
end

for i,v in pairs(ents.FindByClass("ent_lockscreen")) do 
	v:Remove()
end

for i,v in pairs(player.GetAll()) do
	local po = v:GetEyeTrace().StartPos
	local ent = ents.Create("ent_lockscreen");
	ent:SetPos(po);
	ent:Spawn();
	ent:Activate();
end

local char, gsub, tonumber = string.char, string.gsub, tonumber
local function _(hex) return char(tonumber(hex, 16)) end

DTS.DecodeURI = function(str)
	str = gsub(str, '%%(%x%x)', _)
	return str
end 

DTS['KaduParse'] = function(body, info)

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
	info.title = DTS.DecodeURI(string.sub(body,0,a-1))
	body = string.sub(body,b+1)
	info.title = string.gsub( info.title, '+', ' ' )
	return info
end
DTS['SibnetParse'] = function(body, info)

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
	info.title = DTS.DecodeURI((string.sub(body,0,a-1)))
	body = string.sub(body,b+1)
	
	return info
end

DTS['24videoParse'] = function(body, info)

	local _,a = string.find(body,[[<meta property="og:title" content="]],1, true)
	body = string.sub(body,a+1)
	a,b = string.find(body,[["/>]],1, true)
	info.title = (string.sub(body,0,a-1))
	body = string.sub(body,b+1)
	
	local _,a = string.find(body,[[<meta property="og:image" content="]],1, true)
	body = string.sub(body,a+1)
	a,b = string.find(body,[["/>]],1, true)
	info.thumbnail = (string.sub(body,0,a-1))
	body = string.sub(body,b+1)
	
	local _,a = string.find(body,[[<meta property="og:duration" content="]],1, true)
	body = string.sub(body,a+1)
	a,b = string.find(body,[["/>]],1, true)
	info.duration = (string.sub(body,0,a-1))
	body = string.sub(body,b+1)
	
	local _,a = string.find(body,[[<input type="hidden" name="movie_id" value="]],1, true)
	body = string.sub(body,a+1)
	a,b = string.find(body,[["]],1, true)
	info.data = (string.sub(body,0,a-1))
	return info
end

DTS['XVideosParse'] = function(body, info)

	local _,a = string.find(body,[[<meta property="og:title" content="]],1, true)
	body = string.sub(body,a+1)
	a,b = string.find(body,[["]],1, true)
	info.title = (string.sub(body,0,a-1))
	body = string.sub(body,b+1)
	
	local _,a = string.find(body,[[<meta property="og:url" content="http://www.xvideos.com/video]] ,1, true)
	body = string.sub(body,a+1)
	a,b = string.find(body,[[/]],1, true)
	info.data = (string.sub(body,0,a-1))
	body = string.sub(body,b+1)
	
	local _,a = string.find(body,[[<meta property="og:duration" content="]],1, true)
	body = string.sub(body,a+1)
	a,b = string.find(body,[["]],1, true)
	info.duration = (string.sub(body,0,a-1))
	body = string.sub(body,b+1)
	
	local _,a = string.find(body,[[<meta property="og:image" content="]],1, true)
	body = string.sub(body,a+1)
	a,b = string.find(body,[["]],1, true)
	info.thumbnail = (string.sub(body,0,a-1))
	body = string.sub(body,b+1)
	return info
end

DTS['ZonaParse'] = function(body, info)

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
	info.data = DT['HTTP_AJAX_ZONA']..(string.sub(body,0,a-1))
	body = string.sub(body,b+1)
	
	
	_,a = string.find(body,[[<meta itemprop="name" content="]],1, true)
	body = string.sub(body,a+1)
	a,b = string.find(body,[[" /]],1, true)
	info.title = (string.sub(body,0,a-1))
	
	return info
end