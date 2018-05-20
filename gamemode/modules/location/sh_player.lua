local meta = FindMetaTable("Player")
if !meta then return end

function meta:GetLocation()
	return self:GetDTInt(0) or 0
end

function meta:GetLastLocation()
	return self.LastLocation or -1
end

function meta:GetLocationName()
	return Location.GetLocationNameByIndex( self:GetLocation() )
end
function meta:GetLocationShortName()
	local global = Location.GetLocationByIndex( self:GetLocation() ) 
	return ((global and global.ShortName ) ~= nil and global.ShortName or "Неизвестно")
end

function meta:SetLocation(locationId)
	self.LastLocation = self:GetLocation()
	return self:SetDTInt(0, locationId)
end