local SERVICE = {}

SERVICE.Name 	= "online anidub"
SERVICE.IsTimed = true
SERVICE.isSerials = true

function SERVICE:Match( url )
	return string.match( url.host, "online.anidub.com" )// && string.match (url.encoded, "kadu.ru/video/(%d+)")
end

function SERVICE:SeriesMatch( body )
	local aas = 0
	local tab = {}
	local tables = {}	

	local _,a = string.find(body,[[id="mcode_block"]],1, true)
	if (!a) then return end
	body = string.sub(body,a+1)
	a,b = string.find(body,[[;">]],1, true)
	body = string.sub(body,b+1)
	a,b = string.find(body,[[</]],1, true)
	url1 = string.sub(body,0,a-1)
	body = string.sub(body,b+1)
	//print(url1)
	tables['name'] = '1'
	tables['url'] = url1
	tab[1] = tables
	while true do 
		local _,a = string.find(body,[[<option]],1, true)
		
		if !a then break end
		
		body = string.sub(body,a+1)
		
		if aas == 0 then aas = aas + 1 continue end
		
		a,b = string.find(body,[[</opt]],1, true)
		subbing = string.sub(body,0,a-1)
		
			local _,a = string.find(body,[[value="]],1, true)
			if !a then break end
			
			body = string.sub(body,a+1)
			a,b = string.find(body,[[">]],1, true)
			subbing = string.sub(body,0,a-1)
			//table.insert(tab, subbing)
			local x = string.Explode( "|", subbing )
			tables = {}
			tables['name'] = x[2]
			tables['url'] = x[1]
			tab[tonumber(x[2])] = tables
			
		aas = aas + 1
		if aas > 500 then break end
	end
	return tab
end

theater.RegisterService( 'anidub', SERVICE )
