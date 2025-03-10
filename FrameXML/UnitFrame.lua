﻿
PowerBarColor = {};
PowerBarColor["MANA"] = { r = 0.00, g = 0.00, b = 1.00 };
PowerBarColor["RAGE"] = { r = 1.00, g = 0.00, b = 0.00 };
PowerBarColor["FOCUS"] = { r = 1.00, g = 0.50, b = 0.25 };
PowerBarColor["ENERGY"] = { r = 1.00, g = 1.00, b = 0.00 };
PowerBarColor["HAPPINESS"] = { r = 0.00, g = 1.00, b = 1.00 };
PowerBarColor["RUNES"] = { r = 0.50, g = 0.50, b = 0.50 };
PowerBarColor["RUNIC_POWER"] = { r = 0.00, g = 0.82, b = 1.00 };
PowerBarColor["DEMON_RAGE"] = { r = 0.788, g = 0.259, b = 0.992 };
-- vehicle colors
PowerBarColor["AMMOSLOT"] = { r = 0.80, g = 0.60, b = 0.00 };
PowerBarColor["FUEL"] = { r = 0.0, g = 0.55, b = 0.5 };

-- these are mostly needed for a fallback case (in case the code tries to index a power token that is missing from the table,
-- it will try to index by power type instead)
PowerBarColor[0] = PowerBarColor["MANA"];
PowerBarColor[1] = PowerBarColor["RAGE"];
PowerBarColor[2] = PowerBarColor["FOCUS"];
PowerBarColor[3] = PowerBarColor["ENERGY"];
PowerBarColor[4] = PowerBarColor["HAPPINESS"];
PowerBarColor[5] = PowerBarColor["RUNES"];
PowerBarColor[6] = PowerBarColor["RUNIC_POWER"];
PowerBarColor[7] = PowerBarColor["DEMON_RAGE"];

local CUSTOM_TARGETING_TEXTURES = {
	["Interface\\TargetingFrame\\UI-TARGETINGFRAME-EMERALD"] = true,
	["Interface\\TargetingFrame\\UI-TARGETINGFRAME-RUBY"] = true,
	["Interface\\TargetingFrame\\UI-TARGETINGFRAME-SAPPHIRE"] = true,
}

function GetPowerBarColor(powerType)
	return PowerBarColor[powerType];
end

--[[
	This system uses "update" functions as OnUpdate, and OnEvent handlers.
	This "Initialize" function registers the events to handle.
	The "update" function is set as the OnEvent handler (although they do not parse the event),
	as well as run from the parent's update handler.

	TT: I had to make the spellbar system differ from the norm.
	I needed a seperate OnUpdate and OnEvent handlers. And needed to parse the event.
]]--

function UnitFrame_Initialize (self, unit, name, portrait, healthbar, healthtext, manabar, manatext, threatIndicator, threatFeedbackUnit, threatNumericIndicator)
	self.unit = unit;
	self.name = name;
	self.portrait = portrait;
	self.healthbar = healthbar;
	self.manabar = manabar;
	self.threatIndicator = threatIndicator;
	self.threatNumericIndicator = threatNumericIndicator;
	if (self.healthbar) then
		self.healthbar.capNumericDisplay = true;
	end
	if (self.manabar) then
		self.manabar.capNumericDisplay = true;
	end

	UnitFrameHealthBar_Initialize(unit, healthbar, healthtext, true);
	UnitFrameManaBar_Initialize(unit, manabar, manatext, (unit == "player" or unit == "pet" or unit == "vehicle" or unit == "target" or unit == "focus"));
	UnitFrameThreatIndicator_Initialize(unit, self, threatFeedbackUnit);
	UnitFrame_Update(self);
	self:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	self:RegisterEvent("UNIT_NAME_UPDATE");
	self:RegisterEvent("UNIT_DISPLAYPOWER");
	self:RegisterEvent("UNIT_PORTRAIT_UPDATE")

	if unit == "player" or unit == "target" or unit == "focus" then
		hooksecurefunc(self.borderTexture, "SetTexture", function(texture, texturePath)
			if not texture.useCustomTexture and CUSTOM_TARGETING_TEXTURES[texturePath] then
				if unit == "player" then
					texture:SetPoint("TOPLEFT", -16, 0)
					texture:SetTexCoord(1.0, 0.02734375, 0, 0.78125)
				else
					texture:SetSize(248, 100)
					texture:SetTexCoord(0.02734375, 1.0, 0, 0.78125)
				end

				texture.useCustomTexture = true
			elseif texture.useCustomTexture and not CUSTOM_TARGETING_TEXTURES[texturePath] then
				if unit == "player" then
					texture:SetPoint("TOPLEFT", 0, 0)
					texture:SetTexCoord(1.0, 0.09375, 0, 0.78125)
				else
					texture:SetSize(232, 100)
					texture:SetTexCoord(0.09375, 1.0, 0, 0.78125)
				end

				texture.useCustomTexture = false
			end
		end)
	end
end

function UnitFrame_SetUnit (self, unit, healthbar, manabar)
	self.unit = unit;
	UnitFrameHealthBar_SetUnit(healthbar, unit)
	if ( manabar ) then	--Party Pet frames don't have a mana bar.
		manabar.unit = unit;
	end
	self:SetAttribute("unit", unit);
	if ( (self==PlayerFrame or self==PetFrame) and unit=="player") then
		local _,class = UnitClass("player");
		if ( class=="DEATHKNIGHT" ) then
			if ( self==PlayerFrame ) then
				RuneFrame:SetScale(1)
				RuneFrame:ClearAllPoints()
				RuneFrame:SetPoint("TOP", self,"BOTTOM", 52, 34)
			elseif ( self==PetFrame ) then
				RuneFrame:SetScale(0.6)
				RuneFrame:ClearAllPoints()
				RuneFrame:SetPoint("TOP",self,"BOTTOM",25,20)
			end
			RuneFrame:Raise()
		end
	end
	securecall("UnitFrame_Update", self);
end

function UnitFrame_Update (self, isParty)
	if ( self.overrideName ) then
		self.name:SetText(GetUnitName(self.overrideName));
	else
		self.name:SetText(GetUnitName(self.unit));
	end

	UnitFrameCategory_Update(self)
	UnitFrameVip_Update(self)

	UnitFramePortrait_Update(self);
	UnitFrameHealthBar_Update(self.healthbar, self.unit);
	UnitFrameManaBar_Update(self.manabar, self.unit);
	UnitFrame_UpdateThreatIndicator(self.threatIndicator, self.threatNumericIndicator);
end

function UnitFrameCategory_Update( self )
	local frame

	if self == TargetFrame then
		frame = TargetCategoryBox
	elseif self == PlayerFrame then
		frame = PlayerCategoryBox
	elseif self == FocusFrame then
		frame 	= FocusFrameCategoryBox
	end

	if not frame or not self.unit then
		return
	end

	local categoryName = self.showCategoryInfo and C_Unit.GetCategoryInfo(self.unit)
	if categoryName then
		frame.categoryText:SetText(categoryName)
		frame.Name = categoryName
		frame:Show()
	else
		frame:Hide()
	end
end

local PLAYER_CATEGORY_INDEX = 0

function UnitFrameVip_Update( self )
	local frame, texture

	if self == TargetFrame then
		frame 	= TargetCategoryBox
		texture = self.borderTexture
	elseif self == PlayerFrame then
		frame 	= PlayerCategoryBox
		texture = PlayerFrameTexture
	elseif self == FocusFrame then
		frame 	= FocusFrameCategoryBox
		texture = self.borderTexture
	end

	if not frame or not texture or not self.unit then
		return
	end

	local vipInfo = C_Unit.GetClassification(self.unit)

	if vipInfo.vipCategory == 3 then
		texture:SetVertexColor(1, 1, 1)
	else
		texture:SetVertexColor(vipInfo.color.r, vipInfo.color.g, vipInfo.color.b)
	end

	frame.Border:SetVertexColor(vipInfo.color.r, vipInfo.color.g, vipInfo.color.b)

	if self.HeadHuntingWantedFrame then
		self.HeadHuntingWantedFrame.Background:SetVertexColor(vipInfo.color.r, vipInfo.color.g, vipInfo.color.b)
	end

	if self == PlayerFrame then
		if PLAYER_CATEGORY_INDEX ~= vipInfo.vipCategory then
			PLAYER_CATEGORY_INDEX = vipInfo.vipCategory
			UIParent_UpdateTopFramePositions()
		end

		texture:SetTexture("Interface\\TargetingFrame\\"..vipInfo.unitFrameTexture)
	else
		TargetFrame_CheckClassification(self)
	end
end

function UnitFramePortrait_Update (self)
	if ( self.portrait ) then
		SetPortraitTexture(self.portrait, self.unit);
	end
end

function UnitFrame_OnEvent(self, event, ...)
	local eventUnit = ...

	local unit = self.unit;
	if ( eventUnit == unit ) then
		if ( event == "UNIT_NAME_UPDATE" ) then
			self.name:SetText(GetUnitName(unit));
		elseif ( event == "UNIT_PORTRAIT_UPDATE" ) then
			UnitFramePortrait_Update(self);
		elseif ( event == "UNIT_DISPLAYPOWER" ) then
			UnitFrameManaBar_UpdateType(self.manabar);
		end
	end
end

--WARNING: This function is very similar to the function CompactUnitFrameUtil_UpdateFillBar in CompactUnitFrame.lua.
--If you are making changes here, it is possible you may want to make changes there as well.
function UnitFrameUtil_UpdateFillBarBase(frame, realbar, previousTexture, bar, amount, barOffsetXPercent)
	if ( amount == 0 ) then
		bar:Hide();
		if ( bar.overlay ) then
			bar.overlay:Hide();
		end
		return previousTexture;
	end

	local barOffsetX = 0;
	if ( barOffsetXPercent ) then
		local realbarSizeX = realbar:GetWidth();
		barOffsetX = realbarSizeX * barOffsetXPercent;
	end

	bar:SetPoint("TOPLEFT", previousTexture, "TOPRIGHT", barOffsetX, 0);
	bar:SetPoint("BOTTOMLEFT", previousTexture, "BOTTOMRIGHT", barOffsetX, 0);

	local totalWidth, totalHeight = realbar:GetSize();
	local _, totalMax = realbar:GetMinMaxValues();

	local barSize = (amount / totalMax) * totalWidth;
	bar:SetWidth(barSize);
	bar:Show();
	if ( bar.overlay ) then
		bar.overlay:SetTexCoord(0, barSize / bar.overlay.tileSize, 0, totalHeight / bar.overlay.tileSize);
		bar.overlay:Show();
	end
	return bar;
end

function UnitFrameUtil_UpdateFillBar(frame, previousTexture, bar, amount, barOffsetXPercent)
	return UnitFrameUtil_UpdateFillBarBase(frame, frame.healthbar, previousTexture, bar, amount, barOffsetXPercent);
end

function UnitFrameUtil_UpdateManaFillBar(frame, previousTexture, bar, amount, barOffsetXPercent)
	return UnitFrameUtil_UpdateFillBarBase(frame, frame.manabar, previousTexture, bar, amount, barOffsetXPercent);
end

function UnitFrame_OnEnter (self)
	-- If showing newbie tips then only show the explanation
	if ( SHOW_NEWBIE_TIPS == "1" ) then
		if ( self == PlayerFrame ) then
			GameTooltip_SetDefaultAnchor(GameTooltip, self);
			GameTooltip_AddNewbieTip(self, PARTY_OPTIONS_LABEL, 1.0, 1.0, 1.0, NEWBIE_TOOLTIP_PARTYOPTIONS);
			return;
		elseif ( self == TargetFrame and UnitPlayerControlled("target") and not UnitIsUnit("target", "player") and not UnitIsUnit("target", "pet") ) then
			GameTooltip_SetDefaultAnchor(GameTooltip, self);
			GameTooltip_AddNewbieTip(self, PLAYER_OPTIONS_LABEL, 1.0, 1.0, 1.0, NEWBIE_TOOLTIP_PLAYEROPTIONS);
			return;
		end
	end
	UnitFrame_UpdateTooltip(self);
end

function UnitFrame_OnLeave (self)
	self.UpdateTooltip = nil;
	if ( SHOW_NEWBIE_TIPS == "1" ) then
		GameTooltip:Hide();
	else
		GameTooltip:FadeOut();
	end
end

function UnitFrame_UpdateTooltip (self)
	GameTooltip_SetDefaultAnchor(GameTooltip, self);
	if ( GameTooltip:SetUnit(self.unit, self.hideStatusOnTooltip) ) then
		self.UpdateTooltip = UnitFrame_UpdateTooltip;
	else
		self.UpdateTooltip = nil;
	end

	local r, g, b = GameTooltip_UnitColor(self.unit);
	GameTooltipTextLeft1:SetTextColor(r, g, b);
end

function UnitFrameManaBar_UpdateType (manaBar)
	if ( not manaBar ) then
		return;
	end
	local unitFrame = manaBar:GetParent();
	local powerType, powerToken, altR, altG, altB = UnitPowerType(manaBar.unit);
	local prefix = _G[powerToken];
	local info = PowerBarColor[powerToken];

	local _, class = UnitClass(manaBar.unit)
	if class == "DEMONHUNTER" then
		info = PowerBarColor["DEMON_RAGE"]
	end

	if ( info ) then
		if ( not manaBar.lockColor ) then
			manaBar:SetStatusBarColor(info.r, info.g, info.b);
		end
	else
		if ( not altR ) then
			-- couldn't find a power token entry...default to indexing by power type or just mana if we don't have that either
			info = PowerBarColor[powerType] or PowerBarColor["MANA"];
		else
			if ( not manaBar.lockColor ) then
				manaBar:SetStatusBarColor(altR, altG, altB);
			end
		end
	end
	manaBar.powerType = powerType;
	manaBar.powerToken = powerToken

	-- Update the manabar text
	if ( not unitFrame.noTextPrefix ) then
		SetTextStatusBarTextPrefix(manaBar, prefix);
	end
	TextStatusBar_UpdateTextString(manaBar);

	-- Setup newbie tooltip
	-- FIXME: Fix this to use powerToken instead of powerType
	if ( manaBar.unit ~= "pet" or powerToken == "HAPPINESS" ) then
	    if ( unitFrame:GetName() == "PlayerFrame" ) then
		    manaBar.tooltipTitle = prefix;
		    manaBar.tooltipText = _G["NEWBIE_TOOLTIP_MANABAR_"..powerType];
	    else
		    manaBar.tooltipTitle = nil;
		    manaBar.tooltipText = nil;
	    end
	end
end

function UnitFrameHealthBar_Initialize (unit, statusbar, statustext, frequentUpdates)
	if ( not statusbar ) then
		return;
	end

	statusbar.unit = unit;
	SetTextStatusBarText(statusbar, statustext);

	statusbar.frequentUpdates = frequentUpdates;
	if ( frequentUpdates ) then
		statusbar:RegisterEvent("VARIABLES_LOADED");
	end

	UnitFrameHealthBar_RefreshUpdateEvent(statusbar);

	statusbar:RegisterEvent("UNIT_MAXHEALTH");
	statusbar:SetScript("OnEvent", UnitFrameHealthBar_OnEvent);

	-- Setup newbie tooltip
	if ( statusbar and (statusbar:GetParent() == PlayerFrame) ) then
		statusbar.tooltipTitle = HEALTH;
		statusbar.tooltipText = NEWBIE_TOOLTIP_HEALTHBAR;
	else
		statusbar.tooltipTitle = nil;
		statusbar.tooltipText = nil;
	end
end

function UnitFrameHealthBar_RefreshUpdateEvent(self)
	if ( GetCVarBool("predictedHealth") and self.frequentUpdates ) then
		self:SetScript("OnUpdate", UnitFrameHealthBar_OnUpdate);
		self:UnregisterEvent("UNIT_HEALTH");
	else
		self:SetScript("OnUpdate", nil);
		self:RegisterEvent("UNIT_HEALTH");
	end
end

function UnitFrameHealthBar_SetUnit(self, unit)
	self.unit = unit;
	UnitFrameHealthBar_RefreshUpdateEvent(self);
end

function UnitFrameHealthBar_OnEvent(self, event, ...)
	if ( event == "CVAR_UPDATE" ) then
		TextStatusBar_OnEvent(self, event, ...);
	elseif ( event == "VARIABLES_LOADED" ) then
		self:UnregisterEvent("VARIABLES_LOADED");
		UnitFrameHealthBar_RefreshUpdateEvent(self);
	elseif self:IsShown() then
		UnitFrameHealthBar_Update(self, ...);
	end
end

function UnitFrameHealthBar_OnUpdate(self)
	if ( not self.disconnected and not self.lockValues) then
		local currValue = UnitHealth(self.unit);
		if ( currValue ~= self.currValue ) then
			self:SetValue(currValue);
			self.currValue = currValue;
			TextStatusBar_UpdateTextString(self);
		end
	end
end

function UnitFrameHealthBar_Update(statusbar, unit)
	if ( not statusbar or statusbar.lockValues ) then
		return;
	end

	if ( unit == statusbar.unit ) then
		local maxValue = UnitHealthMax(unit);

		-- Safety check to make sure we never get an empty bar.
		statusbar.forceHideText = false;
		if ( maxValue == 0 ) then
			maxValue = 1;
			statusbar.forceHideText = true;
		end

		statusbar:SetMinMaxValues(0, maxValue);

		statusbar.disconnected = not UnitIsConnected(unit);
		if ( statusbar.disconnected ) then
			if ( not statusbar.lockColor ) then
				statusbar:SetStatusBarColor(0.5, 0.5, 0.5);
			end
			statusbar:SetValue(maxValue);
			statusbar.currValue = maxValue;
		else
			local currValue = UnitHealth(unit);
			if ( not statusbar.lockColor ) then
				statusbar:SetStatusBarColor(0.0, 1.0, 0.0);
			end
			statusbar:SetValue(currValue);
			statusbar.currValue = currValue;
		end
	end
	TextStatusBar_UpdateTextString(statusbar);
end

function UnitFrameHealthBar_OnValueChanged(self, value)
	TextStatusBar_OnValueChanged(self, value);
	HealthBar_OnValueChanged(self, value);
end

function UnitFrameManaBar_UnregisterDefaultEvents(self)
	self:UnregisterEvent("UNIT_MANA");
	self:UnregisterEvent("UNIT_RAGE");
	self:UnregisterEvent("UNIT_FOCUS");
	self:UnregisterEvent("UNIT_ENERGY");
	self:UnregisterEvent("UNIT_HAPPINESS");
	self:UnregisterEvent("UNIT_RUNIC_POWER");
end

function UnitFrameManaBar_RegisterDefaultEvents(self)
	self:RegisterEvent("UNIT_MANA");
	self:RegisterEvent("UNIT_RAGE");
	self:RegisterEvent("UNIT_FOCUS");
	self:RegisterEvent("UNIT_ENERGY");
	self:RegisterEvent("UNIT_HAPPINESS");
	self:RegisterEvent("UNIT_RUNIC_POWER");
end

function UnitFrameManaBar_Initialize (unit, statusbar, statustext, frequentUpdates)
	if ( not statusbar ) then
		return;
	end
	statusbar.unit = unit;
	statusbar.texture = statusbar:GetStatusBarTexture();
	SetTextStatusBarText(statusbar, statustext);

	statusbar.frequentUpdates = frequentUpdates;
	if ( frequentUpdates ) then
		statusbar:RegisterEvent("VARIABLES_LOADED");
	end
	if ( GetCVarBool("predictedPower") and frequentUpdates ) then
		statusbar:SetScript("OnUpdate", UnitFrameManaBar_OnUpdate);
	else
		UnitFrameManaBar_RegisterDefaultEvents(statusbar);
	end
	statusbar:RegisterEvent("UNIT_MAXMANA");
	statusbar:RegisterEvent("UNIT_MAXRAGE");
	statusbar:RegisterEvent("UNIT_MAXFOCUS");
	statusbar:RegisterEvent("UNIT_MAXENERGY");
	statusbar:RegisterEvent("UNIT_MAXHAPPINESS");
	statusbar:RegisterEvent("UNIT_MAXRUNIC_POWER");
	statusbar:RegisterEvent("UNIT_DISPLAYPOWER");
	if ( statusbar.unit == "player" ) then
		statusbar:RegisterEvent("PLAYER_DEAD");
		statusbar:RegisterEvent("PLAYER_ALIVE");
		statusbar:RegisterEvent("PLAYER_UNGHOST");
	end
	statusbar:SetScript("OnEvent", UnitFrameManaBar_OnEvent);
end

function UnitFrameManaBar_OnEvent(self, event, ...)
	if ( event == "CVAR_UPDATE" ) then
		TextStatusBar_OnEvent(self, event, ...);
	elseif ( event == "VARIABLES_LOADED" ) then
		self:UnregisterEvent("VARIABLES_LOADED");
		if ( GetCVarBool("predictedPower") and self.frequentUpdates ) then
			self:SetScript("OnUpdate", UnitFrameManaBar_OnUpdate);
			UnitFrameManaBar_UnregisterDefaultEvents(self);
		else
			UnitFrameManaBar_RegisterDefaultEvents(self);
			self:SetScript("OnUpdate", nil);
		end
	elseif ( event == "PLAYER_ALIVE"  or event == "PLAYER_DEAD" or event == "PLAYER_UNGHOST" ) then
		UnitFrameManaBar_UpdateType(self);
	else
		UnitFrameManaBar_Update(self, ...);
	end
end

function UnitFrameManaBar_OnUpdate(self)
	if ( not self.disconnected and not self.lockValues ) then
		local currValue = UnitPower(self.unit, self.powerType);
		if ( currValue ~= self.currValue ) then
			self:SetValue(currValue);
			self.currValue = currValue;
			TextStatusBar_UpdateTextString(self);
		end
	end
end

function UnitFrameManaBar_Update(statusbar, unit)
	if ( not statusbar or statusbar.lockValues ) then
		return;
	end

	if ( unit == statusbar.unit ) then
		-- be sure to update the power type before grabbing the max power!
		UnitFrameManaBar_UpdateType(statusbar);

		local maxValue = UnitPowerMax(unit, statusbar.powerType);

		statusbar:SetMinMaxValues(0, maxValue);

		statusbar.disconnected = not UnitIsConnected(unit);
		if ( statusbar.disconnected ) then
			statusbar:SetValue(maxValue);
			statusbar.currValue = maxValue;
			if ( not statusbar.lockColor ) then
				statusbar:SetStatusBarColor(0.5, 0.5, 0.5);
			end
		else
			local currValue = UnitPower(unit, statusbar.powerType);
			statusbar:SetValue(currValue);
			statusbar.currValue = currValue;
		end
	end
	TextStatusBar_UpdateTextString(statusbar);
end

function UnitFrameThreatIndicator_Initialize(unit, unitFrame, feedbackUnit)
	local indicator = unitFrame.threatIndicator;
	if ( not indicator ) then
		return;
	end

	indicator.unit = unit;
	indicator.feedbackUnit = feedbackUnit or unit;

	unitFrame:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE");
	if ( unitFrame.OnEvent == nil ) then
		unitFrame.OnEvent = unitFrame:GetScript("OnEvent") or false;
	end
	unitFrame:SetScript("OnEvent", UnitFrameThreatIndicator_OnEvent);
end

function UnitFrameThreatIndicator_OnEvent(self, event, ...)
	if ( self.OnEvent ) then
		self.OnEvent(self, event, ...);
	end
	if ( event == "UNIT_THREAT_SITUATION_UPDATE" ) then
		UnitFrame_UpdateThreatIndicator(self.threatIndicator, self.threatNumericIndicator,...);
	end
end

function UnitFrame_UpdateThreatIndicator(indicator, numericIndicator, unit)
	if ( not indicator ) then
		return;
	end

	if ( not unit or unit == indicator.feedbackUnit ) then
		local status;
		if ( indicator.feedbackUnit ~= indicator.unit ) then
			status = UnitThreatSituation(indicator.feedbackUnit, indicator.unit);
		else
			status = UnitThreatSituation(indicator.feedbackUnit);
		end

		if ( IsThreatWarningEnabled() ) then
			if (status and status > 0) then
				indicator:SetVertexColor(GetThreatStatusColor(status));
				indicator:Show();
			else
				indicator:Hide();
			end

			if ( numericIndicator ) then
				if ( ShowNumericThreat() ) then
					local isTanking, status, percentage = UnitDetailedThreatSituation(indicator.feedbackUnit, indicator.unit);
					if ( percentage and percentage ~= 0 ) then
						numericIndicator.text:SetText(format("%1.0f", percentage).."%");
						numericIndicator.bg:SetVertexColor(GetThreatStatusColor(status));
						numericIndicator:Show();
					else
						numericIndicator:Hide();
					end
				else
					numericIndicator:Hide();
				end
			end
		else
			indicator:Hide();
			if ( numericIndicator ) then
				numericIndicator:Hide();
			end
		end
	end
end

function GetUnitName(unit, showServerName)
	local name, server = UnitName(unit);
	if ( server and server ~= "" ) then
		if ( showServerName ) then
			return name.." - "..server;
		else
			return name..FOREIGN_SERVER_LABEL;
		end
	else
		return name;
	end
end

function ShowNumericThreat()
	if ( GetCVar("threatShowNumeric") == "1" ) then
		return true;
	else
		return false;
	end
end
