REQUIRED_REST_HOURS = 5;

function PlayerFrame_OnLoad(self)
	self.showCategoryInfo = C_Service.IsStrengthenStatsRealm();
	self.borderTexture = PlayerFrameTexture
	self.PVPTooltipTitle = nil
	self.PVPTooltipText = nil

	PlayerFrameHealthBar.LeftText = PlayerFrameHealthBarTextLeft;
	PlayerFrameHealthBar.RightText = PlayerFrameHealthBarTextRight;
	PlayerFrameManaBar.LeftText = PlayerFrameManaBarTextLeft;
	PlayerFrameManaBar.RightText = PlayerFrameManaBarTextRight;

	UnitFrame_Initialize(self, "player", PlayerName, PlayerPortrait,
						 PlayerFrameHealthBar, PlayerFrameHealthBarText,
						 PlayerFrameManaBar, PlayerFrameManaBarText,
						 PlayerFrameFlash);

	self.statusCounter = 0;
	self.statusSign = -1;
	CombatFeedback_Initialize(self, PlayerHitIndicator, 30);
	PlayerFrame_Update();
	self:RegisterEvent("UNIT_LEVEL");
	self:RegisterEvent("UNIT_COMBAT");
	self:RegisterEvent("UNIT_FACTION");
	self:RegisterEvent("UNIT_MAXMANA");
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("PLAYER_ENTER_COMBAT");
	self:RegisterEvent("PLAYER_LEAVE_COMBAT");
	self:RegisterEvent("PLAYER_REGEN_DISABLED");
	self:RegisterEvent("PLAYER_REGEN_ENABLED");
	self:RegisterEvent("PLAYER_UPDATE_RESTING");
	self:RegisterEvent("PARTY_MEMBERS_CHANGED");
	self:RegisterEvent("PARTY_LEADER_CHANGED");
	self:RegisterEvent("PARTY_LOOT_METHOD_CHANGED");
	self:RegisterEvent("RAID_ROSTER_UPDATE");
	self:RegisterEvent("READY_CHECK");
	self:RegisterEvent("READY_CHECK_CONFIRM");
	self:RegisterEvent("READY_CHECK_FINISHED");
	self:RegisterEvent("UNIT_ENTERED_VEHICLE");
	self:RegisterEvent("UNIT_ENTERING_VEHICLE");
	self:RegisterEvent("UNIT_EXITING_VEHICLE");
	self:RegisterEvent("UNIT_EXITED_VEHICLE");
	self:RegisterEvent("PLAYER_FLAGS_CHANGED");
	self:RegisterEvent("PLAYER_ROLES_ASSIGNED");
	self:RegisterEvent("VARIABLES_LOADED");

	-- Chinese playtime stuff
	self:RegisterEvent("PLAYTIME_CHANGED");

	PlayerAttackBackground:SetVertexColor(0.8, 0.1, 0.1);
	PlayerAttackBackground:SetAlpha(0.4);

	self:SetClampRectInsets(20, 0, 0, 0);

	local showmenu = function()
		ToggleDropDownMenu(1, nil, PlayerFrameDropDown, "PlayerFrame", 106, 27);
	end
	UIParent_UpdateTopFramePositions();
	SecureUnitButton_OnLoad(self, "player", showmenu);

	C_FactionManager:RegisterFactionOverrideCallback(PlayerFrame_UpdatePvPStatus, false, true)
end

function PlayerFrame_Update ()
	if ( UnitExists("player") ) then
		PlayerLevelText:SetText(UnitLevel(PlayerFrame.unit));
		PlayerFrame_UpdatePartyLeader();
		PlayerFrame_UpdatePvPStatus();
		PlayerFrame_UpdateStatus();
		PlayerFrame_UpdatePlaytime();
		PlayerFrame_UpdateLayout();
	end
end

function PlayerFrame_UpdatePartyLeader()
	if ( IsPartyLeader() ) then
		if ( HasLFGRestrictions() ) then
			PlayerGuideIcon:Show();
			PlayerLeaderIcon:Hide();
		else
			PlayerLeaderIcon:Show()
			PlayerGuideIcon:Hide();
		end
	else
		PlayerLeaderIcon:Hide();
		PlayerGuideIcon:Hide();
	end

	local lootMethod;
	local lootMaster;
	lootMethod, lootMaster = GetLootMethod();
	if ( lootMaster == 0 and ((GetNumPartyMembers() > 0) or (GetNumRaidMembers() > 0)) ) then
		PlayerMasterIcon:Show();
	else
		PlayerMasterIcon:Hide();
	end
end

function PlayerFrame_UpdatePvPStatus()
	if not UnitIsUnit("player", PlayerFrame.unit) then
		PlayerPVPIcon:Hide()
		PlayerRenegadeIcon:Hide()
		RatedBattlegroundRankFrame:Hide()
		return
	end

	local factionID, _, factionGroup, factionName = C_Unit.GetFactionInfo("player")

	if factionID == PLAYER_FACTION_GROUP.Neutral then
		PlayerPVPIcon:Hide()
		PlayerRenegadeIcon:Hide()
		RatedBattlegroundRankFrame:Hide()
		return
	end

	local _, curRankID, curRankIconCoord, rankBackgroundTexCoord, isBattlegroundRanked

	if GetRatedBattlegroundRankInfo then
		_, _, curRankID, curRankIconCoord, _, _, _, _, _, _, _, _, _, _, rankBackgroundTexCoord = GetRatedBattlegroundRankInfo()
		isBattlegroundRanked = curRankID ~= 0
	end

	local unitIsPlayer = UnitIsPlayer("player")

	PlayerPVPIcon:SetShown(factionID ~= PLAYER_FACTION_GROUP.Renegade and unitIsPlayer)
	PlayerRenegadeIcon:SetShown(factionID == PLAYER_FACTION_GROUP.Renegade and unitIsPlayer)
	RatedBattlegroundRankFrame:SetShown(isBattlegroundRanked and unitIsPlayer)
	RatedBattlegroundRankFrame.Icons:SetShown(curRankIconCoord)

	PVPIconFrame:ClearAllPoints()

	if isBattlegroundRanked then
		PVPIconFrame:SetPoint("TOPRIGHT", 32, 0)
	else
		PVPIconFrame:SetPoint("CENTER", RatedBattlegroundRankFrame, "CENTER", 10, -10)
	end

	if curRankIconCoord then
		RatedBattlegroundRankFrame.Icons:SetTexCoord(unpack(curRankIconCoord))
	end

	if UnitIsPVPFreeForAll("player") then
		PlayerPVPIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA")

		if rankBackgroundTexCoord then
			RatedBattlegroundRankFrame.Background:SetTexCoord(unpack(rankBackgroundTexCoord["Neutral"]))
		end

		PlayerFrame.PVPTooltipTitle = PVPFFA
		PlayerFrame.PVPTooltipText = NEWBIE_TOOLTIP_PVPFFA

		PlayerPVPTimerText:Hide()
		PlayerPVPTimerText.timeLeft = nil
	elseif factionGroup then
		PlayerPVPIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..factionGroup)

		if rankBackgroundTexCoord and rankBackgroundTexCoord[factionGroup] then
			RatedBattlegroundRankFrame.Background:SetTexCoord(unpack(rankBackgroundTexCoord[factionGroup]))
		end

		PlayerFrame.PVPTooltipTitle = factionName
		PlayerFrame.PVPTooltipText = _G["NEWBIE_TOOLTIP_"..strupper(factionGroup)]
	end
end

function PlayerFrame_OnEvent(self, event, ...)
	UnitFrame_OnEvent(self, event, ...);

	local arg1, arg2, arg3, arg4, arg5 = ...;
	if ( event == "UNIT_LEVEL" ) then
		if ( arg1 == "player" ) then
			PlayerLevelText:SetText(UnitLevel(self.unit));
			PlayerFrame_UpdatePvPStatus()
		end
	elseif ( event == "UNIT_COMBAT" ) then
		if ( arg1 == self.unit ) then
			CombatFeedback_OnCombatEvent(self, arg2, arg3, arg4, arg5);
			PlayerFrame_UpdatePvPStatus()
		end
	elseif ( event == "UNIT_FACTION" ) then
		if ( arg1 == "player" ) then
			PlayerFrame_UpdatePvPStatus();
		end
	elseif ( event == "UNIT_AURA" ) then
		if ( arg1 == "player" ) then
			UnitFrameCategory_Update(self)
			UnitFrameVip_Update(self)
		end
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		PlayerFrame_ResetPosition(self);
		PlayerFrame_UpdatePvPStatus()
		PlayerFrame_ToPlayerArt(self);
--		if ( UnitHasVehicleUI("player") ) then
--			UnitFrame_SetUnit(self, "vehicle", PlayerFrameHealthBar, PlayerFrameManaBar);
--		else
--			UnitFrame_SetUnit(self, "player", PlayerFrameHealthBar, PlayerFrameManaBar);
--		end
		self.inCombat = nil;
		self.onHateList = nil;
		PlayerFrame_Update();
		PlayerFrame_UpdateStatus();
		PlayerFrame_UpdateRolesAssigned();

		if ( IsPVPTimerRunning() ) then
			PlayerPVPTimerText:Show();
			PlayerPVPTimerText.timeLeft = GetPVPTimer();
		else
			PlayerPVPTimerText:Hide();
			PlayerPVPTimerText.timeLeft = nil;
		end
	elseif ( event == "PLAYER_ENTER_COMBAT" ) then
		self.inCombat = 1;
		PlayerFrame_UpdateStatus();
	elseif ( event == "PLAYER_LEAVE_COMBAT" ) then
		self.inCombat = nil;
		PlayerFrame_UpdateStatus();
	elseif ( event == "PLAYER_REGEN_DISABLED" ) then
		self.onHateList = 1;
		PlayerFrame_UpdateStatus();
	elseif ( event == "PLAYER_REGEN_ENABLED" ) then
		self.onHateList = nil;
		PlayerFrame_UpdateStatus();
	elseif ( event == "PLAYER_UPDATE_RESTING" ) then
		PlayerFrame_UpdateStatus();
	elseif ( event == "PARTY_MEMBERS_CHANGED" or event == "PARTY_LEADER_CHANGED" or event == "RAID_ROSTER_UPDATE" ) then
		PlayerFrame_UpdateGroupIndicator();
		PlayerFrame_UpdatePartyLeader();
		PlayerFrame_UpdateReadyCheck();
		PlayerFrame_UpdatePvPStatus()
	elseif ( event == "PARTY_LOOT_METHOD_CHANGED" ) then
		local lootMethod;
		local lootMaster;
		lootMethod, lootMaster = GetLootMethod();
		if ( lootMaster == 0 and ((GetNumPartyMembers() > 0) or (GetNumRaidMembers() > 0)) ) then
			PlayerMasterIcon:Show();
		else
			PlayerMasterIcon:Hide();
		end
		PlayerFrame_UpdatePvPStatus()
	elseif ( event == "PLAYTIME_CHANGED" ) then
		PlayerFrame_UpdatePlaytime();
	elseif ( event == "READY_CHECK" or event == "READY_CHECK_CONFIRM" ) then
		PlayerFrame_UpdateReadyCheck();
	elseif ( event == "READY_CHECK_FINISHED" ) then
		ReadyCheck_Finish(PlayerFrameReadyCheck);
	elseif ( event == "UNIT_ENTERING_VEHICLE" ) then
		if ( arg1 == "player" ) then
			if ( arg2 ) then
				PlayerFrame_AnimateOut(self);
			else
				if ( PlayerFrame.state == "vehicle" ) then
					PlayerFrame_AnimateOut(self);
				end
			end
		end
	elseif ( event == "UNIT_ENTERED_VEHICLE" ) then
		if ( arg1 == "player" ) then
			self.inSeat = true;
			PlayerFrame_UpdateArt(self);
		end
	elseif ( event == "UNIT_EXITING_VEHICLE" ) then
		if ( arg1 == "player" ) then
			if ( self.state == "vehicle" ) then
				PlayerFrame_AnimateOut(self);
			end
		end
	elseif ( event == "UNIT_EXITED_VEHICLE" ) then
		if ( arg1 == "player" ) then
			self.inSeat = true;
			PlayerFrame_UpdateArt(self);
		end
	elseif ( event == "PLAYER_FLAGS_CHANGED" ) then
		if ( IsPVPTimerRunning() ) then
			PlayerPVPTimerText:Show();
			PlayerPVPTimerText.timeLeft = GetPVPTimer();
		else
			PlayerPVPTimerText:Hide();
			PlayerPVPTimerText.timeLeft = nil;
		end
		PlayerFrame_UpdatePvPStatus()
	elseif ( event == "PLAYER_ROLES_ASSIGNED" ) then
		PlayerFrame_UpdateRolesAssigned();
	elseif ( event == "VARIABLES_LOADED" ) then
		PlayerFrame_SetLocked(not PLAYER_FRAME_UNLOCKED);
		if ( PLAYER_FRAME_CASTBARS_SHOWN ) then
			PlayerFrame_AttachCastBar();
		end
	end
end

function PlayerFrame_UpdateRolesAssigned()
	local frame = PlayerFrame;
	local icon = _G[frame:GetName().."RoleIcon"];
	local isTank, isHealer, isDamage = UnitGroupRolesAssigned("player");

	if ( isTank ) then
		icon:SetTexCoord(0, 19/64, 22/64, 41/64);
		icon:Show();
	elseif ( isHealer ) then
		icon:SetTexCoord(20/64, 39/64, 1/64, 20/64);
		icon:Show();
	elseif ( isDamage ) then
		icon:SetTexCoord(20/64, 39/64, 22/64, 41/64);
		icon:Show();
	else
		icon:Hide();
	end
end

local function PlayerFrame_AnimPos(self, fraction)
	return "TOPLEFT", UIParent, "TOPLEFT", -19, fraction*140-4;
end

function PlayerFrame_ResetPosition(self)
	CancelAnimations(PlayerFrame);
	self.isAnimatedOut = false;
	UIParent_UpdateTopFramePositions();
	self.inSequence = false;
	PetFrame_Update(PetFrame);
end

local PlayerFrameAnimTable = {
	totalTime = 0.3,
	updateFunc = "SetPoint",
	getPosFunc = PlayerFrame_AnimPos,
	}
function PlayerFrame_AnimateOut(self)
	self.inSeat = false;
	self.animFinished = false;
	self.inSequence = true;
	self.isAnimatedOut = true;
	if ( self:IsUserPlaced() ) then
		PlayerFrame_AnimFinished(PlayerFrame);
	else
		SetUpAnimation(PlayerFrame, PlayerFrameAnimTable, PlayerFrame_AnimFinished, false)
	end
end

function PlayerFrame_AnimFinished(self)
	self.animFinished = true;
	PlayerFrame_UpdateArt(self);
end

function PlayerFrame_IsAnimatedOut(self)
	return self.isAnimatedOut;
end

function PlayerFrame_UpdateArt(self)
	if ( self.inSeat ) then
		if ( self:IsUserPlaced() ) then
			PlayerFrame_SequenceFinished(PlayerFrame);
		elseif ( self.animFinished and self.inSequence ) then
			SetUpAnimation(PlayerFrame, PlayerFrameAnimTable, PlayerFrame_SequenceFinished, true)
		end
		if ( UnitHasVehicleUI("player") ) then
			PlayerFrame_ToVehicleArt(self, UnitVehicleSkin("player"));
			PlayerCategoryBox:Hide()
		else
			PlayerFrame_ToPlayerArt(self);
			PlayerCategoryBox:Show()
		end
	end
end

function PlayerFrame_SequenceFinished(self)
	self.isAnimatedOut = false;
	self.inSequence = false;
	PetFrame_Update(PetFrame);
end

function PlayerFrame_ToVehicleArt(self, vehicleType)
	--Swap frame

	PlayerFrame.state = "vehicle";

	UnitFrame_SetUnit(self, "vehicle", PlayerFrameHealthBar, PlayerFrameManaBar);
	UnitFrame_SetUnit(PetFrame, "player", PetFrameHealthBar, PetFrameManaBar);
	PetFrame_Update(PetFrame);
	PlayerFrame_Update();
	BuffFrame_Update();
	ComboFrame_Update();

	PlayerFrameTexture:Hide();
	if ( vehicleType == "Natural" ) then
		PlayerFrameVehicleTexture:SetTexture("Interface\\Vehicles\\UI-Vehicle-Frame-Organic");
		PlayerFrameHealthBar:SetWidth(103);
		PlayerFrameHealthBar:SetPoint("TOPLEFT",116,-41);
		PlayerFrameManaBar:SetWidth(103);
		PlayerFrameManaBar:SetPoint("TOPLEFT",116,-52);
	else
		PlayerFrameVehicleTexture:SetTexture("Interface\\Vehicles\\UI-Vehicle-Frame");
		PlayerFrameHealthBar:SetWidth(100);
		PlayerFrameHealthBar:SetPoint("TOPLEFT",119,-41);
		PlayerFrameManaBar:SetWidth(100);
		PlayerFrameManaBar:SetPoint("TOPLEFT",119,-52);
	end
	PlayerFrameVehicleTexture:Show();

	PlayerName:SetPoint("CENTER",50,23);
	PlayerLeaderIcon:SetPoint("TOPLEFT",40,-12);
	-- PlayerMasterIcon:SetPoint("TOPLEFT",86,0);
	PlayerFrameGroupIndicator:SetPoint("BOTTOMLEFT", PlayerFrame, "TOPLEFT", 97, -13);

	PlayerFrameBackground:SetWidth(114);
	PlayerLevelText:Hide();
end

function PlayerFrame_ToPlayerArt(self)
	--Unswap frame

	PlayerFrame.state = "player";

	UnitFrame_SetUnit(self, "player", PlayerFrameHealthBar, PlayerFrameManaBar);
	UnitFrame_SetUnit(PetFrame, "pet", PetFrameHealthBar, PetFrameManaBar);
	PetFrame_Update(PetFrame);
	PlayerFrame_Update();
	BuffFrame_Update();
	ComboFrame_Update();

	PlayerFrameTexture:Show();
	PlayerFrameVehicleTexture:Hide();
	PlayerName:SetPoint("CENTER",50,19);
	PlayerLeaderIcon:SetPoint("TOPLEFT",40,-12);
	-- PlayerMasterIcon:SetPoint("TOPLEFT",80,-10);
	PlayerFrameGroupIndicator:SetPoint("BOTTOMLEFT", PlayerFrame, "TOPLEFT", 97, -20);
	PlayerFrameHealthBar:SetWidth(119);
	PlayerFrameHealthBar:SetPoint("TOPLEFT",106,-41);
	PlayerFrameManaBar:SetWidth(119);
	PlayerFrameManaBar:SetPoint("TOPLEFT",106,-52);
	PlayerFrameBackground:SetWidth(119);
	PlayerLevelText:Show();
end

function PlayerFrame_UpdateVoiceStatus (status)
	PlayerSpeakerFrame:Hide();
end

function PlayerFrame_UpdateReadyCheck ()
	local readyCheckStatus = GetReadyCheckStatus("player");
	if ( readyCheckStatus ) then
		if ( readyCheckStatus == "ready" ) then
			ReadyCheck_Confirm(PlayerFrameReadyCheck, 1);
		elseif ( readyCheckStatus == "notready" ) then
			ReadyCheck_Confirm(PlayerFrameReadyCheck, 0);
		else -- "waiting"
			ReadyCheck_Start(PlayerFrameReadyCheck);
		end
	else
		PlayerFrameReadyCheck:Hide();
	end
end

function PlayerFrame_OnUpdate (self, elapsed)
	if ( PlayerStatusTexture:IsShown() ) then
		local alpha = 255;
		local counter = self.statusCounter + elapsed;
		local sign    = self.statusSign;

		if ( counter > 0.5 ) then
			sign = -sign;
			self.statusSign = sign;
		end
		counter = mod(counter, 0.5);
		self.statusCounter = counter;

		if ( sign == 1 ) then
			alpha = (55  + (counter * 400)) / 255;
		else
			alpha = (255 - (counter * 400)) / 255;
		end
		PlayerStatusTexture:SetAlpha(alpha);
		PlayerStatusGlow:SetAlpha(alpha);
	end

	if ( PlayerPVPTimerText.timeLeft ) then
		PlayerPVPTimerText.timeLeft = PlayerPVPTimerText.timeLeft - elapsed*1000;
		local timeLeft = PlayerPVPTimerText.timeLeft;
		if ( timeLeft < 0 ) then
			PlayerPVPTimerText:Hide()
		end
		PlayerPVPTimerText:SetFormattedText(SecondsToTimeAbbrev(floor(timeLeft/1000)));
	else
		PlayerPVPTimerText:Hide();
	end
	CombatFeedback_OnUpdate(self, elapsed);
end

function PlayerFrame_OnReceiveDrag ()
	if ( CursorHasItem() ) then
		AutoEquipCursorItem();
	end
end

function PlayerFrame_UpdateStatus()
	if ( UnitHasVehicleUI("player") ) then
		PlayerStatusTexture:Hide()
		PlayerRestIcon:Hide()
		PlayerAttackIcon:Hide()
		PlayerRestGlow:Hide()
		PlayerAttackGlow:Hide()
		PlayerStatusGlow:Hide()
		PlayerAttackBackground:Hide()
	elseif ( IsResting() ) then
		PlayerStatusTexture:SetVertexColor(1.0, 0.88, 0.25, 1.0);
		PlayerStatusTexture:Show();
		PlayerRestIcon:Show();
		PlayerAttackIcon:Hide();
		PlayerRestGlow:Show();
		PlayerAttackGlow:Hide();
		PlayerStatusGlow:Show();
		PlayerAttackBackground:Hide();
	elseif ( PlayerFrame.inCombat ) then
		PlayerStatusTexture:SetVertexColor(1.0, 0.0, 0.0, 1.0);
		PlayerStatusTexture:Show();
		PlayerAttackIcon:Show();
		PlayerRestIcon:Hide();
		PlayerAttackGlow:Show();
		PlayerRestGlow:Hide();
		PlayerStatusGlow:Show();
		PlayerAttackBackground:Show();
	elseif ( PlayerFrame.onHateList ) then
		PlayerAttackIcon:Show();
		PlayerRestIcon:Hide();
		PlayerStatusGlow:Hide();
		PlayerAttackBackground:Hide();
	else
		PlayerStatusTexture:Hide();
		PlayerRestIcon:Hide();
		PlayerAttackIcon:Hide();
		PlayerStatusGlow:Hide();
		PlayerAttackBackground:Hide();
	end
end

function PlayerFrame_UpdateGroupIndicator()
	PlayerFrameGroupIndicator:Hide();
--[[
	local name, rank, subgroup;
	if ( GetNumRaidMembers() == 0 ) then
		PlayerFrameGroupIndicator:Hide();
		return;
	end
	local numRaidMembers = GetNumRaidMembers();
	for i=1, MAX_RAID_MEMBERS do
		if ( i <= numRaidMembers ) then
			name, rank, subgroup = GetRaidRosterInfo(i);
			-- Set the player's group number indicator
			if ( name == UnitName("player") ) then
				PlayerFrameGroupIndicatorText:SetText(GROUP.." "..subgroup);
				PlayerFrameGroupIndicator:SetWidth(PlayerFrameGroupIndicatorText:GetWidth()+40);
				PlayerFrameGroupIndicator:Show();
			end
		end
	end
--]]
end

function PlayerFrameDropDown_OnLoad (self)
	UIDropDownMenu_SetInitializeFunction(self, PlayerFrameDropDown_Initialize);
	UIDropDownMenu_SetDisplayMode(self, "MENU");
end

function PlayerFrameDropDown_Initialize ()
	if ( PlayerFrame.unit == "vehicle" ) then
		UnitPopup_ShowMenu(PlayerFrameDropDown, "VEHICLE", "vehicle");
	else
		UnitPopup_ShowMenu(PlayerFrameDropDown, "SELF", "player");
	end
end

function PlayerFrame_UpdatePlaytime()
	if ( PartialPlayTime() ) then
		PlayerPlayTimeIcon:SetTexture("Interface\\CharacterFrame\\UI-Player-PlayTimeTired");
		PlayerPlayTime.tooltip = format(PLAYTIME_TIRED, REQUIRED_REST_HOURS - floor(GetBillingTimeRested()/60));
		PlayerPlayTime:Show();
	elseif ( NoPlayTime() ) then
		PlayerPlayTimeIcon:SetTexture("Interface\\CharacterFrame\\UI-Player-PlayTimeUnhealthy");
		PlayerPlayTime.tooltip = format(PLAYTIME_UNHEALTHY, REQUIRED_REST_HOURS - floor(GetBillingTimeRested()/60));
		PlayerPlayTime:Show();
	else
		PlayerPlayTime:Hide();
	end
end

function PlayerFrame_SetupDeathKnightLayout ()
	PlayerFrame:SetHitRectInsets(0,0,0,35);
end

CustomClassLayouts = {
	["DEATHKNIGHT"] = PlayerFrame_SetupDeathKnightLayout,
}

local layoutUpdated = false;

function PlayerFrame_UpdateLayout ()
	if ( layoutUpdated ) then
		return;
	end
	layoutUpdated = true;

	local _, class = UnitClass("player");

	if ( CustomClassLayouts[class] ) then
		CustomClassLayouts[class]();
	end
end

local RUNICPOWERBARHEIGHT = 63;
local RUNICPOWERBARWIDTH = 64;

local RUNICGLOW_FADEALPHA = .050
local RUNICGLOW_MINALPHA = .40
local RUNICGLOW_MAXALPHA = .80
local RUNICGLOW_THROBINTERVAL = .8;

RUNICGLOW_FINISHTHROBANDHIDE = false;
local RUNICGLOW_THROBSTART = 0;

function PlayerFrame_SetRunicPower (runicPower)
	PlayerFrameRunicPowerBar:SetHeight(RUNICPOWERBARHEIGHT * (runicPower / 100));
	PlayerFrameRunicPowerBar:SetTexCoord(0, 1, (1 - (runicPower / 100)), 1);

	if ( runicPower >= 90 ) then
		-- Oh,  God help us for these function and variable names.
		RUNICGLOW_FINISHTHROBANDHIDE = false;
		if ( not PlayerFrameRunicPowerGlow:IsShown() ) then
			PlayerFrameRunicPowerGlow:Show();
		end
		PlayerFrameRunicPowerGlow:GetParent():SetScript("OnUpdate", DeathKnniggetThrobFunction);
	elseif ( PlayerFrameRunicPowerGlow:GetParent():GetScript("OnUpdate") ) then
		RUNICGLOW_FINISHTHROBANDHIDE = true;
	else
		PlayerFrameRunicPowerGlow:Hide();
	end
end

local firstFadeIn = true;
function DeathKnniggetThrobFunction (self, elapsed)
	if ( RUNICGLOW_THROBSTART == 0 ) then
		RUNICGLOW_THROBSTART = GetTime();
	elseif ( not RUNICGLOW_FINISHTHROBANDHIDE ) then
		local interval = RUNICGLOW_THROBINTERVAL - math.abs( .9 - (UnitPower("player") / 100));
		local animTime = GetTime() - RUNICGLOW_THROBSTART;
		if ( animTime >= interval ) then
			-- Fading out
			PlayerFrameRunicPowerGlow:SetAlpha(math.max(RUNICGLOW_MINALPHA, math.min(RUNICGLOW_MAXALPHA, RUNICGLOW_MAXALPHA * interval/animTime)));
			if ( animTime >= interval * 2 ) then
				self.timeSinceThrob = 0;
				RUNICGLOW_THROBSTART = GetTime();
			end
			firstFadeIn = false;
		else
			-- Fading in
			if ( firstFadeIn ) then
				PlayerFrameRunicPowerGlow:SetAlpha(math.max(RUNICGLOW_FADEALPHA, math.min(RUNICGLOW_MAXALPHA, RUNICGLOW_MAXALPHA * animTime/interval)));
			else
				PlayerFrameRunicPowerGlow:SetAlpha(math.max(RUNICGLOW_MINALPHA, math.min(RUNICGLOW_MAXALPHA, RUNICGLOW_MAXALPHA * animTime/interval)));
			end
		end
	elseif ( RUNICGLOW_FINISHTHROBANDHIDE ) then
		local currentAlpha = PlayerFrameRunicPowerGlow:GetAlpha();
		local animTime = GetTime() - RUNICGLOW_THROBSTART;
		local interval = RUNICGLOW_THROBINTERVAL;
		firstFadeIn = true;

		if ( animTime >= interval ) then
			-- Already fading out, just keep fading out.
			local alpha = math.min(PlayerFrameRunicPowerGlow:GetAlpha(), RUNICGLOW_MAXALPHA * (interval/(animTime*(animTime/2))));

			PlayerFrameRunicPowerGlow:SetAlpha(alpha);
			if ( alpha <= RUNICGLOW_FADEALPHA ) then
				self.timeSinceThrob = 0;
				RUNICGLOW_THROBSTART = 0;
				PlayerFrameRunicPowerGlow:Hide();
				self:SetScript("OnUpdate", nil);
				RUNICGLOW_FINISHTHROBANDHIDE = false;
				return;
			end
		else
			-- Was fading in, start fading out
			animTime = interval;
		end
	end
end

function PlayerFrame_OnDragStart(self)
	self:StartMoving();
	self:SetUserPlaced(true);
	self:SetClampedToScreen(true);
end

function PlayerFrame_OnDragStop(self)
	self:StopMovingOrSizing();
end

function PlayerFrame_SetLocked(locked)
	PLAYER_FRAME_UNLOCKED = not locked;
	if ( locked ) then
		PlayerFrame:RegisterForDrag();	--Unregister all buttons.
	else
		PlayerFrame:RegisterForDrag("LeftButton");
	end
end

function PlayerFrame_ResetUserPlacedPosition()
	PlayerFrame:ClearAllPoints();
	PlayerFrame:SetUserPlaced(false);
	PlayerFrame:SetClampedToScreen(false);
	PlayerFrame_SetLocked(true);
	UIParent_UpdateTopFramePositions();
end

--
-- Functions for having the cast bar underneath the player frame
--

function PlayerFrame_AttachCastBar()
	local castBar = CastingBarFrame;
	local petCastBar = PetCastingBarFrame;
	-- player
	castBar.ignoreFramePositionManager = true;
	castBar:SetAttribute("ignoreFramePositionManager", true);
	CastingBarFrame_SetLook(castBar, "UNITFRAME");
	castBar:ClearAllPoints();
	castBar:SetPoint("LEFT", PlayerFrame, 78, 0);
	-- pet
	CastingBarFrame_SetLook(petCastBar, "UNITFRAME");
	petCastBar:SetWidth(150);
	petCastBar:SetHeight(10);
	petCastBar:ClearAllPoints();
	petCastBar:SetPoint("TOP", castBar, "TOP", 0, 0);

	PlayerFrame_AdjustAttachments();
	UIParent_ManageFramePositions();
end

function PlayerFrame_DetachCastBar()
	local castBar = CastingBarFrame;
	local petCastBar = PetCastingBarFrame;
	-- player
	castBar.ignoreFramePositionManager = nil;
	castBar:SetAttribute("ignoreFramePositionManager", false);
	CastingBarFrame_SetLook(castBar, "CLASSIC");
	castBar:ClearAllPoints();
	-- pet
	CastingBarFrame_SetLook(petCastBar, "CLASSIC");
	petCastBar:SetWidth(195);
	petCastBar:SetHeight(13);
	petCastBar:ClearAllPoints();
	petCastBar:SetPoint("BOTTOM", castBar, "TOP", 0, 12);

	UIParent_ManageFramePositions();
end

function PlayerFrame_AdjustAttachments()
	if PetFrame and PetFrame:IsShown() then
		SetParentFrameLevel(PetFrame, 3)
	end

	if ( not PLAYER_FRAME_CASTBARS_SHOWN ) then
		return;
	end
	if ( PetFrame and PetFrame:IsShown() ) then
		CastingBarFrame:SetPoint("TOP", PetFrame, "BOTTOM", 0, -4);
	elseif ( TotemFrame and TotemFrame:IsShown() ) then
		CastingBarFrame:SetPoint("TOP", TotemFrame, "BOTTOM", 0, 2);
	else
		local _, class = UnitClass("player");
		if ( class == "DEATHKNIGHT" or class == "DRUID" ) then
			CastingBarFrame:SetPoint("TOP", PlayerFrame, "BOTTOM", 0, 5);
		elseif ( class == "SHAMAN" ) then
			CastingBarFrame:SetPoint("TOP", PlayerFrame, "BOTTOM", 0, -40);
		else
			CastingBarFrame:SetPoint("TOP", PlayerFrame, "BOTTOM", 0, 7);
		end
	end
end
