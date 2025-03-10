ezSpectator_Textures = {}
ezSpectator_Textures.__index = ezSpectator_Textures

function ezSpectator_Textures:Create()
    local self = {}
    setmetatable(self, ezSpectator_Textures)
	self.Mult = (PixelUtil.GetPixelToUIUnitFactor())
    return self
end



function ezSpectator_Textures:CreateShadow(Frame)
    local Shadow = CreateFrame('Frame', nil, Frame)
    Shadow:SetPoint('TOPLEFT', -4, 4)
    Shadow:SetPoint('BOTTOMRIGHT', 4, -4)
    Shadow:SetFrameStrata('BACKGROUND')
    Shadow:SetFrameLevel(1)
    Shadow:SetBackdrop({
        edgeFile = 'Interface\\AddOns\\IsengardSpectatorUI\\media\\glowTex', edgeSize = 5,
        insets = {left = 3, right = 3, top = 3, bottom = 3}
    })
    Shadow:SetBackdropBorderColor(0, 0, 0, 0.8)
end



function ezSpectator_Textures:GeneratePanel(Frame)
    Frame:SetBackdrop({
        bgFile =  "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        tile = false, tileSize = 0, edgeSize = self.Mult,
        insets = { left = -self.Mult , right = -self.Mult, top = -self.Mult, bottom = -self.Mult}
    })
    Frame:SetBackdropColor(.04, .04, .04)
    Frame:SetBackdropBorderColor(.18, .18, .18)
end



function ezSpectator_Textures:Load(Frame, Path, Style)
    Style = Style or 'BACKGROUND'

    local Texture = Frame.texture
    if not Texture then
        Texture = Frame:CreateTexture(nil, Style)
    end
    Texture:SetTexture(Path)

    return Texture
end



function ezSpectator_Textures:SmallFrame_Normal(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\SmallFrame_Normal')
    Texture:SetTexCoord(0.109375, 0.89453125, 0.2734375, 0.734375)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:SmallFrame_Backdrop(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\SmallFrame_Backdrop')
    Texture:SetTexCoord(0.109375, 0.89453125, 0.2734375, 0.734375)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:SmallFrame_Highlight(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\SmallFrame_Highlight')
    Texture:SetTexCoord(0.109375, 0.89453125, 0.2734375, 0.734375)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:TargetFrame_Normal(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\TargetFrame_Normal')
    Texture:SetTexCoord(0.109375, 0.89453125, 0.2734375, 0.625)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:TargetFrame_Backdrop(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\TargetFrame_Backdrop')
    Texture:SetTexCoord(0.109375, 0.89453125, 0.2734375, 0.625)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:CastFrame_Normal(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\CastFrame_Normal')
    Texture:SetTexCoord(0.109375, 0.890625, 0.3125, 0.703125)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:CastFrame_Backdrop(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\CastFrame_Backdrop.png')
    Texture:SetTexCoord(0.109375, 0.890625, 0.3125, 0.703125)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:CastFrame_Glow(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\CastFrame_Glow.png')
    Texture:SetTexCoord(0.109375, 0.890625, 0.3125, 0.703125)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:TeamFrame_Normal(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\TeamFrame_Normal')
    Texture:SetTexCoord(0.029296875, 0.97265625, 0.1015625, 0.453125)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:HealthBar_Backdrop(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\HealthBar_Backdrop')
    Texture:SetTexCoord(0, 1, 0, 1)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:EnrageOrb_Backdrop(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\EnrageOrb_Backdrop')
    Texture:SetTexCoord(0, 1, 0.3046875, 0.6875)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:EnrageOrb_Normal(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\EnrageOrb_Normal')
    Texture:SetTexCoord(0, 1, 0.3046875, 0.6875)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:EnrageOrb_Sections(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\EnrageOrb_Sections')
    Texture:SetTexCoord(0, 1, 0.3046875, 0.6875)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:PillowBar_Normal(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\PillowBar_Normal')
    Texture:SetTexCoord(0, 1, 0, 1)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:PillowBar_Glow(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\PillowBar_Glow')
    Texture:SetTexCoord(0, 1, 0, 1)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:HealthBar_Normal(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\HealthBar_Normal')
    Texture:SetTexCoord(0, 1, 0, 1)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:HealthBar_Overlay(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\HealthBar_Overlay')
    Texture:SetTexCoord(0, 1, 0, 1)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:Nameplate_Backdrop(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\Nameplate_Backdrop')
    Texture:SetTexCoord(0, 1, 0, 1)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:Nameplate_Normal(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\Nameplate_Normal')
    Texture:SetTexCoord(0, 1, 0, 1)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:Nameplate_Overlay(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\Nameplate_Overlay')
    Texture:SetTexCoord(0, 1, 0, 1)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:Nameplate_Effect(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\Nameplate_Effect')
    Texture:SetTexCoord(0, 1, 0, 1)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:Nameplate_Glow(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\Nameplate_Glow')
    Texture:SetTexCoord(0.23046875, 0.7734375, 0.296875, 0.71875)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:Nameplate_Castborder(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\Nameplate_Castborder')
    Texture:SetTexCoord(0.140625, 0.890625, 0.140625, 0.890625)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:SpellIcon_Normal(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\SpellIcon_Normal')
    Texture:SetTexCoord(0.21875, 0.7890625, 0.21875, 0.7890625)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:ClickIcon_Backdrop(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\ClickIcon_Backdrop')
    Texture:SetTexCoord(0.15625, 0.859375, 0.15625, 0.859375)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:ClickIcon_Normal_Gold(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\ClickIcon_Normal_Gold')
    Texture:SetTexCoord(0.15625, 0.859375, 0.15625, 0.859375)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end


function ezSpectator_Textures:ClickIcon_Normal_Silver(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\ClickIcon_Normal_Silver')
    Texture:SetTexCoord(0.15625, 0.859375, 0.15625, 0.859375)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:ClickIcon_Normal_Mild(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\ClickIcon_Normal_Mild')
    Texture:SetTexCoord(0.140625, 0.890625, 0.140625, 0.890625)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:ClickIcon_Highlight_Gold(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\ClickIcon_Highlight_Gold')
    Texture:SetTexCoord(0.15625, 0.859375, 0.15625, 0.859375)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:ClickIcon_Highlight_Silver(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\ClickIcon_Highlight_Silver')
    Texture:SetTexCoord(0.15625, 0.859375, 0.15625, 0.859375)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:ClickIcon_Highlight_Mild(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\ClickIcon_Highlight_Mild')
    Texture:SetTexCoord(0.140625, 0.890625, 0.140625, 0.890625)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:StatusBar_Spark(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\StatusBar_Spark')
    Texture:SetTexCoord(0, 1, 0, 1)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:AlphaPlus(Frame)
    local Texture = self:Load(Frame, 'Interface\\Custom\\ArenaSpectator\\AlphaPlus')
    Texture:SetTexCoord(0, 1, 0, 1)
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end



function ezSpectator_Textures:SetServerLogo(Frame)
	local Texture = self:Load(Frame)
	Texture:SetAtlas(C_RealmInfo.GetServerLogo(GetServerID()))
    Texture:SetAllPoints(Frame)
    Frame.texture = Texture
end