
function TabardFrame_OnLoad(self)
	self:RegisterEvent("OPEN_TABARD_FRAME");
	self:RegisterEvent("CLOSE_TABARD_FRAME");
	self:RegisterEvent("TABARD_CANSAVE_CHANGED");
	self:RegisterEvent("TABARD_SAVE_PENDING");
	self:RegisterEvent("UNIT_MODEL_CHANGED");
	self:RegisterEvent("DISPLAY_SIZE_CHANGED");
	self:RegisterEvent("UI_SCALE_CHANGED");

	TabardFrameCostFrame:SetBackdropBorderColor(0.4, 0.4, 0.4);
	TabardFrameCostFrame:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b);
	MoneyFrame_Update("TabardFrameCostMoneyFrame",GetTabardCreationCost());

	SetParentFrameLevel(TabardFrameMoneyFrame)
	
	local backgroundAlpha = 0.40;
	TabardFrameEmblemTopRight:SetAlpha(backgroundAlpha);
	TabardFrameEmblemTopLeft:SetAlpha(backgroundAlpha);
	TabardFrameEmblemBottomRight:SetAlpha(backgroundAlpha);
	TabardFrameEmblemBottomLeft:SetAlpha(backgroundAlpha);

	MoneyFrame_SetMaxDisplayWidth(TabardFrameMoneyFrame, 160);
end

function TabardCharacterModelFrame_OnLoad(self)
	self.rotation = 0;
	TabardModel:SetRotation(self.rotation);
end

function TabardFrame_OnEvent(self, event, ...)
	local unit = ...;
	if ( event == "OPEN_TABARD_FRAME" ) then
		TabardModel:SetUnit("player", true);
		SetPortraitTexture(TabardFramePortrait,"npc");
		TabardFrameNameText:SetText(UnitName("npc"));
		TabardModel:InitializeTabardColors();
		TabardFrame_UpdateTextures();
		TabardFrame_UpdateButtons();
		ShowUIPanel(TabardFrame);
		if ( not TabardFrame:IsShown() ) then
			CloseTabardCreation();
		end
	elseif ( event == "CLOSE_TABARD_FRAME" ) then
		HideUIPanel(TabardFrame);
	elseif ( event == "TABARD_CANSAVE_CHANGED" or event == "TABARD_SAVE_PENDING" ) then
		TabardFrame_UpdateButtons();
	elseif ( event == "UNIT_MODEL_CHANGED" ) then
		if ( unit == "player" ) then
			TabardModel:SetUnit("player", true);
		end
	elseif ( event == "DISPLAY_SIZE_CHANGED" or event == "UI_SCALE_CHANGED" ) then
		TabardModel:SetUnit("player", true);
	end
end

function TabardCharacterModelRotateLeftButton_OnClick(self)
	Model_RotateLeft(self:GetParent());
end

function TabardCharacterModelRotateRightButton_OnClick(self)
	Model_RotateRight(self:GetParent());
end

function TabardCharacterModelFrame_OnUpdate(self, elapsedTime)
	Model_OnUpdate(self, elapsedTime, nil, TabardCharacterModelRotateLeftButton, TabardCharacterModelRotateRightButton);
end

function TabardCustomization_Left(id)
	PlaySound("gsCharacterCreationLook");
	TabardModel:CycleVariation(id,-1);
	TabardFrame_UpdateTextures();
end

function TabardCustomization_Right(id)
	PlaySound("gsCharacterCreationLook");
	TabardModel:CycleVariation(id,1);
	TabardFrame_UpdateTextures();
end

function TabardFrame_UpdateTextures()
	TabardModel:GetUpperEmblemTexture(TabardFrameEmblemTopLeft);
	TabardModel:GetUpperEmblemTexture(TabardFrameEmblemTopRight);
	TabardModel:GetLowerEmblemTexture(TabardFrameEmblemBottomLeft);
	TabardModel:GetLowerEmblemTexture(TabardFrameEmblemBottomRight);
end

function TabardFrame_UpdateButtons()
	local guildName, rankName, rank = GetGuildInfo("player");
	if ( guildName == nil or rankName == nil or ( rank > 0 ) ) then
		TabardFrameGreetingText:SetText(TABARDVENDORNOGUILDGREETING);
		TabardFrameAcceptButton:Disable();
	else
		TabardFrameGreetingText:SetText(TABARDVENDORGREETING);
		if( TabardModel:CanSaveTabardNow() ) then
			TabardFrameAcceptButton:Enable();
		else
			TabardFrameAcceptButton:Disable();
		end
	end
end