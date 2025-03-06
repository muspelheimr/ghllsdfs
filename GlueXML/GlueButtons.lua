SECONDS_PER_PULSE = 1;

function GlueButtonMaster_OnUpdate(self, elapsed)
	if ( _G[self:GetName().."Glow"]:IsShown() ) then
		local sign = self.pulseSign;
		local counter;
		
		if ( not self.pulsing ) then
			counter = 0;
			self.pulsing = 1;
			sign = 1;
		else
			counter = self.pulseCounter + (sign * elapsed);
			if ( counter > SECONDS_PER_PULSE ) then
				counter = SECONDS_PER_PULSE;
				sign = -sign;
			elseif ( counter < 0) then
				counter = 0;
				sign = -sign;
			end
		end
		
		local alpha = counter / SECONDS_PER_PULSE;
		_G[self:GetName().."Glow"]:SetVertexColor(1.0, 1.0, 1.0, alpha);

		self.pulseSign = sign;
		self.pulseCounter = counter;
	end
end

ShadowButtonMixin = {}

function ShadowButtonMixin:OnLoadStyle()
	self.normalTextureH = self:GetAttribute("normalTextureSizeH") or 190
	self.normalTextureW = self:GetAttribute("normalTextureSizeW") or 60

	self.highlightTextureSizeH = self:GetAttribute("highlightTextureSizeH") or 190
	self.highlightTextureSizeW = self:GetAttribute("highlightTextureSizeW") or 60

	self.normalTextureAtlas = self:GetAttribute("normalTextureAtlas") or "Glue-Shadow-Button-Normal"
	self.highlightTextureAtlas = self:GetAttribute("highlightTextureAtlas") or "Glue-Shadow-Button-Highlight"
	self.disableTextureAtlas = self:GetAttribute("disableTextureAtlas") or "Glue-Shadow-Button-Normal"
	self.pushedTextureAtlas = self:GetAttribute("pushedTextureAtlas")

	self.NormalTexture:SetAtlas(self.normalTextureAtlas)
	self.DisabledTexture:SetAtlas(self.disableTextureAtlas)
	self.HighlightTexture:SetAtlas(self.highlightTextureAtlas)
	if self.pushedTextureAtlas and self.PushedTexture then
		self.PushedTexture:SetAtlas(self.pushedTextureAtlas)
	end

	self.DisabledTexture:SetDesaturated(1)

	self.NormalTexture:SetSize(self.normalTextureH, self.normalTextureW)
	self.DisabledTexture:SetSize(self.normalTextureH, self.normalTextureW)
	self.HighlightTexture:SetSize(self.highlightTextureSizeH, self.highlightTextureSizeW)
end
