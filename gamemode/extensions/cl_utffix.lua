--[[
	Спасибо, UnkN. Самому писать нет желания.
	
	https://github.com/UnkN56/gmodutf8fix
]]--

UTF8 = UTF8 or {}
UTF8.ASCIICAPS = {"À","Á","Â","Ã","Ä","Å","¨","Æ","Ç","È","É","Ê","Ë","Ì","Í","Î","Ï","Ð","Ñ","Ò","Ó","Ô","Õ","Ö","×","Ø","Ù","Ú","Û","Ü","Ý","Þ","ß"}
UTF8.ASCIISMALL = {"à","á","â","ã","ä","å","¸","æ","ç","è","é","ê","ë","ì","í","î","ï","ð","ñ","ò","ó","ô","õ","ö","÷","ø","ù","ú","û","ü","ý","þ","ÿ"}

function UTF8:Generate()
	self.RepConv = {}
	for k,v in pairs(self.CAPS) do
		self.RepConv[ v ] = self.ASCIICAPS[ k ]
	end
	for k,v in pairs(self.SMALL) do
		self.RepConv[ v ] = self.ASCIISMALL[ k ]
	end
	self.RepCaps = {}
	for k,v in pairs(self.CAPS) do
		self.RepCaps[ v ] = self.SMALL[ k ]
	end
	self.RepSmall = {}
	for k,v in pairs(self.SMALL) do
		self.RepSmall[ v ] = self.CAPS[ k ]
	end
end

UTF8.CAPS = {"А","Б","В","Г","Д","Е","Ё","Ж","З","И","Й","К","Л","М","Н","О","П","Р","С","Т","У","Ф","Х","Ц","Ч","Ш","Щ","Ъ","Ы","Ь","Э","Ю","Я"}
UTF8.SMALL = {"а","б","в","г","д","е","ё","ж","з","и","й","к","л","м","н","о","п","р","с","т","у","ф","х","ц","ч","ш","щ","ъ","ы","ь","э","ю","я"}
UTF8:Generate( )

function UTF8:ConvertUTF8ToASCII( txt )
	local output = ""
	for w in string.gmatch( txt, utf8.charpattern ) do
		output = output .. ""..( UTF8.RepConv[w] or w )
	end
	return output
end

UTF8.stringlower = UTF8.stringlower or string.lower
function string.lower( txt )
	local output = ""
	for w in string.gmatch( txt, utf8.charpattern ) do
		output = output .. ""..( UTF8.RepCaps[w] or w )
	end
	return UTF8.stringlower( output )
end

UTF8.stringupper = UTF8.stringupper or string.upper
function string.upper( txt )
	local output = ""
	for w in string.gmatch( txt, utf8.charpattern ) do
		output = output .. ""..( UTF8.RepSmall[w] or w )
	end
	return UTF8.stringupper( output )
end

OldSetClipboardText = OldSetClipboardText or SetClipboardText
function SetClipboardText( txt )
	txt = UTF8:ConvertUTF8ToASCII( txt )
	return OldSetClipboardText( txt )
end