local SERVICE = {}

SERVICE.Name 	= "Shikomori"
SERVICE.IsTimed = true
SERVICE.isSerials = true
SERVICE.SpecialText = "Выбор озвучки/cубтитров"

SERVICE.CanMatchServices = {}
SERVICE.CanMatchServices['vk.com'] = true
//SERVICE.CanMatchServices['smotret-anime.ru'] = true
SERVICE.CanMatchServices['sibnet.ru'] = true

SERVICE.MustBeValidate = {}
SERVICE.MustBeValidate['vk.com'] = true

local url2 = url -- keep reference for extracting url data

function SERVICE:Match( url )
	return string.match( url.host, "play.shikimori.org" )// && string.match (url.encoded, "kadu.ru/video/(%d+)")
end

function SERVICE:SeriesMatch( body )
	local aas = 0
	local tab = {}
	local tables = {}	
	
	//local _,a = string.find(body,[[data-kind="all"]],1, true)
		//body = string.sub(body,a+1)

	local _,a = string.find(body,[[class="video-variant-switcher" data-kind="all"]],1, true)
	body = string.sub(body,a+1)
	a,b = string.find(body,[[class="video-variant-group" data-kind="all"]],1, true)
	data = string.sub(body,0,a-1)
	body = string.sub(body,b+1)	
	
	while true do 
		local _,a = string.find(data,[[data-video_id="]],1, true)
		
		if (!a) then break end
		
		//print(string.sub(body,100))
		data = string.sub(data,a+1)
		
		local _,a = string.find(data,[[class="]],1, true)
		data = string.sub(data,a+1)
		a,b = string.find(data,[["]],1, true)
		rep = string.sub(data,0,a-1)
		data = string.sub(data,b+1)	
		
		
		local _,a = string.find(data,[[href="]],1, true)
		
		if (!a) then continue end
		
		data = string.sub(data,a+1)
		a,b = string.find(data,[["><span class="video-kind ]],1, true)
		
		if (!a) then continue end
		
		hreftoembed = string.sub(data,0,a-1)
		data = string.sub(data,b+1)	
		
		trans = (string.sub(data, 0, 7))
		
		local _,a = string.find(data,[[">]],1, true)
		data = string.sub(data,a+1)
		a,b = string.find(data,[[</span]],1, true)
		test = string.sub(data,0,a-1)
		data = string.sub(data,b+1)	
		local _,a = string.find(data,[[hosting">]],1, true)
		data = string.sub(data,a+1)
		a,b = string.find(data,[[</span>]],1, true)
		site = string.sub(data,0,a-1)
		data = string.sub(data,b+1)	
		
		if !self.CanMatchServices[site] then continue end
	
		local _,a = string.find(data,[[author">]],1, true)
		data = string.sub(data,a+1)
		a,b = string.find(data,[[</span>]],1, true)
		author = string.sub(data,0,a-1)
		data = string.sub(data,b+1)	
		
		if trans != 'russian' then continue end
		if rep != 'working' then continue end
	
		//tables = {}
		//tables['name'] = x[2]
		//tables['url'] = x[1]
		//tab[tonumber(x[2])] = tables
		
		//print('--------')
		--print(trans)//уже неактуально
		--print(rep)//уже неактуально
		--print(test)//Тип видео - озвучка/субтитры
		--print(hreftoembed)//Шикимори плеер
		--print(site, author)//Ссылка на Embed плеер и автор озвучки/cубтитров
		
		local name = test..' ('..site..') '..author
		tables = {}
		tables['name'] =name
		tables['url'] = hreftoembed
		
		table.insert(tab, tables)
		
		aas = aas + 1
		if aas > 500 then break end
	end
	
	return tab
end
//https://play.shikimori.org/animes/34612-saiki-kusuo-no-nan-tv-2/video_online/1
if CLIENT then
	local function unparseData(url)
		local status, data = pcall( url2.parse2, url )
		if !status then
			print( "ERROR:\n" .. tostring(data) )
			return false
		end

		if !data then
			return false
		end
		
		//PrintTable(data)
		
		if SERVICE.MustBeValidate[data.authority] then
			if data.authority == 'vk.com' then
				//https://vk.com/video-37468416_456243057
				return "https://vk.com/video"..data['query']['oid'].."_"..data['query']["amp;id"]
			end
		end
		return url
	end
	function SERVICE:ExtraParser( url )
		print(url, 'Data')
		local HttpHeaders = {
			["X-Requested-With"] = "XMLHttpRequest",
		}
		
		local request = {
			url			= url,
			method		= "GET",
			headers     = HttpHeaders,

			success = function( code, body, headers )
				code = tonumber( code ) or 0

				if code == 200 or code == 0 then
					//onReceive( body, body:len(), headers, code )			
					//print(body)
					
					local _,a = string.find(body,[[><iframe src="]],1, true)
					body = string.sub(body,a+1)
					a,b = string.find(body,[["]],1, true)
					href = string.sub(body,0,a-1)
					body = string.sub(body,b+1)	
					print("http:"..href, "URI")
					
					RequestVideoURL(unparseData("http:"..href))
				else
					print( "FAILURE: " .. code )
					pcall( onFailure, code )
				end
			end,

			failed = function( err )
				if isfunction( onFailure ) then
					pcall( onFailure, err )
				end
			end
		}

		HTTP( request )
	end
end

theater.RegisterService( 'shikimori', SERVICE )
