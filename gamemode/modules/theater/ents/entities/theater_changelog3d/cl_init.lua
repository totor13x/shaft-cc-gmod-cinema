include('shared.lua')

ENT.BoxSize = 1024
ENT.WindowSize = {x = 120, y = 120}
ENT.Offset = Vector(ENT.WindowSize.x*0.25*-1,ENT.WindowSize.y*0.25,1.6)

function ENT:Initialize()
	local bound = Vector(1,1,1) * self.BoxSize
	self:SetRenderBounds( -bound, bound )
end

function ENT:Draw() end

function ENT:DrawSign()
	if !self.ChangelogMat then
		if !IsValid(self.HTML) then
			self.HTML = vgui.Create( "DHTML" )
			self.HTML:SetSize( self.BoxSize, self.BoxSize )
			self.HTML:SetKeyBoardInputEnabled(false)
			self.HTML:SetMouseInputEnabled(false)
			self.HTML:SetPaintedManually(true)
			self.HTML:OpenURL( "https://shaft.im/apps/cinema/changelog.php" )
		elseif !self.HTML:IsLoading() then
			timer.Simple(1, function()
				if !IsValid(self) then return end
				if !IsValid(self.HTML) then return end
				
				self.HTML:UpdateHTMLTexture()
				self.ChangelogMat = self.HTML:GetHTMLMaterial()
				
				self.HTML:Remove()
			end)
		end
	else
		surface.SetDrawColor( 40, 40, 40, 230 )
		surface.DrawRect( 0, 0, self.BoxSize, self.BoxSize )

		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( self.ChangelogMat )
		surface.DrawTexturedRect( 0, 0, self.BoxSize - 1, self.BoxSize - 1 )
	end
end

function ENT:DrawTranslucent()
	cam.Start3D2D(self:LocalToWorld(self.Offset), self:GetAngles(), 0.06)
		pcall(self.DrawSign, self)
	cam.End3D2D()
end