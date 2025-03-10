EQUIPPED_FIRST = 1;
EQUIPPED_LAST = 19;

NUM_RESISTANCE_TYPES = 5;
NUM_STATS = 5;
NUM_SHOPPING_TOOLTIPS = 2;
MAX_SPELL_SCHOOLS = 7;

CR_WEAPON_SKILL = 1;
CR_DEFENSE_SKILL = 2;
CR_DODGE = 3;
CR_PARRY = 4;
CR_BLOCK = 5;
CR_HIT_MELEE = 6;
CR_HIT_RANGED = 7;
CR_HIT_SPELL = 8;
CR_CRIT_MELEE = 9;
CR_CRIT_RANGED = 10;
CR_CRIT_SPELL = 11;
CR_HIT_TAKEN_MELEE = 12;
CR_HIT_TAKEN_RANGED = 13;
CR_HIT_TAKEN_SPELL = 14;
CR_CRIT_TAKEN_MELEE = 15;
CR_CRIT_TAKEN_RANGED = 16;
CR_CRIT_TAKEN_SPELL = 17;
CR_HASTE_MELEE = 18;
CR_HASTE_RANGED = 19;
CR_HASTE_SPELL = 20;
CR_WEAPON_SKILL_MAINHAND = 21;
CR_WEAPON_SKILL_OFFHAND = 22;
CR_WEAPON_SKILL_RANGED = 23;
CR_EXPERTISE = 24;
CR_ARMOR_PENETRATION = 25;

ATTACK_POWER_MAGIC_NUMBER = 14;
BLOCK_PER_STRENGTH = 0.5;
HEALTH_PER_STAMINA = 10;
ARMOR_PER_AGILITY = 2;
MANA_PER_INTELLECT = 15;
MANA_REGEN_PER_SPIRIT = 0.2;
DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE = 0.04;
RESILIENCE_CRIT_CHANCE_TO_DAMAGE_REDUCTION_MULTIPLIER = 2.2;
RESILIENCE_CRIT_CHANCE_TO_CONSTANT_DAMAGE_REDUCTION_MULTIPLIER = 2.0;

local tutorialData = {}

PAPERDOLL_SIDEBARS = {
	{
		name=PAPERDOLLFRAME_TITLES;
		frame="PaperDollTitlesPane";
		icon = "Interface\\PaperDollInfoFrame\\PaperDollSidebarTabs";
		texCoords = {0.01562500, 0.53125000, 0.32421875, 0.46093750};
	},
	{
		name=EQUIPMENT_MANAGER;
		frame="GearManagerDialog";
		icon = "Interface\\PaperDollInfoFrame\\PaperDollSidebarTabs";
		texCoords = {0.01562500, 0.53125000, 0.46875000, 0.60546875};
	},
};

--Pet scaling:
HUNTER_PET_BONUS = {};
HUNTER_PET_BONUS["PET_BONUS_RAP_TO_AP"] = 0.22;
HUNTER_PET_BONUS["PET_BONUS_RAP_TO_SPELLDMG"] = 0.1287;
HUNTER_PET_BONUS["PET_BONUS_STAM"] = 0.3;
HUNTER_PET_BONUS["PET_BONUS_RES"] = 0.4;
HUNTER_PET_BONUS["PET_BONUS_ARMOR"] = 0.35;
HUNTER_PET_BONUS["PET_BONUS_SPELLDMG_TO_SPELLDMG"] = 0.0;
HUNTER_PET_BONUS["PET_BONUS_SPELLDMG_TO_AP"] = 0.0;
HUNTER_PET_BONUS["PET_BONUS_INT"] = 0.0;

WARLOCK_PET_BONUS = {};
WARLOCK_PET_BONUS["PET_BONUS_RAP_TO_AP"] = 0.0;
WARLOCK_PET_BONUS["PET_BONUS_RAP_TO_SPELLDMG"] = 0.0;
WARLOCK_PET_BONUS["PET_BONUS_STAM"] = 0.3;
WARLOCK_PET_BONUS["PET_BONUS_RES"] = 0.4;
WARLOCK_PET_BONUS["PET_BONUS_ARMOR"] = 0.35;
WARLOCK_PET_BONUS["PET_BONUS_SPELLDMG_TO_SPELLDMG"] = 0.15;
WARLOCK_PET_BONUS["PET_BONUS_SPELLDMG_TO_AP"] = 0.57;
WARLOCK_PET_BONUS["PET_BONUS_INT"] = 0.3;

PLAYERSTAT_DROPDOWN_OPTIONS = {
	"PLAYERSTAT_BASE_STATS",
	"PLAYERSTAT_MELEE_COMBAT",
	"PLAYERSTAT_RANGED_COMBAT",
	"PLAYERSTAT_SPELL_COMBAT",
	"PLAYERSTAT_DEFENSES",
};

PLAYER_DISPLAYED_TITLES = 6;
PLAYER_TITLE_HEIGHT = 16;

local BONUS_STAT_VALUES = {}
local BONUS_STAT_MULTIPLIERS = {}

local InspectSlotButton = {
	"InspectHeadSlot",
	"InspectNeckSlot",
	"InspectShoulderSlot",
	"InspectBackSlot",
	"InspectChestSlot",
	"InspectShirtSlot",
	"InspectTabardSlot",
	"InspectWristSlot",
	"InspectHandsSlot",
	"InspectWaistSlot",
	"InspectLegsSlot",
	"InspectFeetSlot",
	"InspectFinger0Slot",
	"InspectFinger1Slot",
	"InspectTrinket0Slot",
	"InspectTrinket1Slot",
	"InspectMainHandSlot",
	"InspectSecondaryHandSlot",
	"InspectRangedSlot",
}

local itemSlotButtons = {};

local StrengthenStats = {SPELL_STAT1_NAME, SPELL_STAT2_NAME, SPELL_STAT3_NAME, SPELL_STAT4_NAME, SPELL_STAT5_NAME, PAPERDOLLFRAME_UPS_SPELL_POWER, ATTACK_POWER}

local CastSpell = CastSpell

function PaperDollFrame_OnLoad (self)
	self.equipmentItemsList = {}

	StrengthenFrame = {}
	for i = 1, #StrengthenStats do
		StrengthenFrame[i] = CreateFrame("Frame", string.format("$parentStat%i", i), PaperDollFrameStrengthenFrame, "CharacterStrengthenFrameTemplate")
		local frame = StrengthenFrame[i]
		if i == 1 then
			frame:SetPoint("TOP", -8, -57)
		else
			frame:SetPoint("TOP", StrengthenFrame[i - 1], "BOTTOM", 0, -5)
		end
		frame:SetID(i)
		frame.Label:SetText(StrengthenStats[i])
		frame.Value:SetText(0)
		if (i % 2) == 1 then
			frame.Background:Hide()
		end
	end

	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("CHARACTER_POINTS_CHANGED");
	self:RegisterEvent("UNIT_MODEL_CHANGED");
	self:RegisterEvent("UNIT_LEVEL");
	self:RegisterEvent("UNIT_RESISTANCES");
	self:RegisterEvent("UNIT_STATS");
	self:RegisterEvent("UNIT_DAMAGE");
	self:RegisterEvent("UNIT_RANGEDDAMAGE");
	self:RegisterEvent("PLAYER_DAMAGE_DONE_MODS");
	self:RegisterEvent("UNIT_ATTACK_SPEED");
	self:RegisterEvent("UNIT_ATTACK_POWER");
	self:RegisterEvent("UNIT_RANGED_ATTACK_POWER");
	self:RegisterEvent("UNIT_ATTACK");
	self:RegisterEvent("PLAYER_GUILD_UPDATE");
	self:RegisterEvent("SKILL_LINES_CHANGED");
	self:RegisterEvent("VARIABLES_LOADED");
	self:RegisterEvent("COMBAT_RATING_UPDATE");
	self:RegisterEvent("KNOWN_TITLES_UPDATE");
	self:RegisterEvent("UNIT_NAME_UPDATE");
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("PLAYER_TARGET_CHANGED");
	self:RegisterEvent("PARTY_MEMBERS_CHANGED");
	self:RegisterEvent("UNIT_INVENTORY_CHANGED");
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

	-- flyout settings
	PaperDollFrameEquipInset.flyoutSettings = {
		onClickFunc = PaperDollFrameItemFlyoutButton_OnClick,
		getItemsFunc = PaperDollFrameItemFlyout_GetItems,
		postGetItemsFunc = PaperDollFrameItemFlyout_PostGetItems,
		hasPopouts = true,
		parent = PaperDollFrame,
		anchorX = 0,
		anchorY = -3,
		verticalAnchorX = 0,
		verticalAnchorY = 0,
	};

	self.isDisabledStrengthenFrame = not C_Service.IsStrengthenStatsRealm()

	if self.isDisabledStrengthenFrame then
		PaperDollFrame_DisableStrengthenFrame(self)
	end
end

function PaperDoll_IsEquippedSlot (slot)
	if ( slot ) then
		slot = tonumber(slot);
		if ( slot ) then
			return slot >= EQUIPPED_FIRST and slot <= EQUIPPED_LAST;
		end
	end
	return false;
end

function CharacterModelFrame_OnMouseUp (self, button)
	if ( button == "LeftButton" ) then
		AutoEquipCursorItem();
	end
end

function EventHandler:UPS_INFO( msg )
	local total, max, current = strsplit(":", msg)

	current = tonumber(current)

	if PaperDollFrameStrengthenFrame.StrengthenTittle.Current and current ~= PaperDollFrameStrengthenFrame.StrengthenTittle.Current and current > PaperDollFrameStrengthenFrame.StrengthenTittle.Current then
		LevelUpDisplay.level = nil
		LevelUpDisplay.ups = current - PaperDollFrameStrengthenFrame.StrengthenTittle.Current
		LevelUpDisplay:Show()
		LevelUpDisplaySide:Hide()
	end

	PaperDollFrameStrengthenFrame.StrengthenTittle.Total = total
	PaperDollFrameStrengthenFrame.StrengthenTittle.Maximum = max
	PaperDollFrameStrengthenFrame.StrengthenTittle.Current = current
	PaperDollFrameStrengthenFrame.StrengthenTittle.Text:SetFormattedText(PAPERDOLLFRAME_UPS_AVAILABLE, current)
	for i = 1, #StrengthenStats do
		if current == 0 then
			StrengthenFrame[i].Plus:Disable()
			StrengthenFrame[i].Plus:GetDisabledTexture():SetDesaturated(true)
		else
			StrengthenFrame[i].Plus:Enable()
			StrengthenFrame[i].Plus:GetDisabledTexture():SetDesaturated(false)
		end
	end

	if PaperDollFrameStrengthenFrame.StrengthenTittle:IsMouseOver() and GameTooltip:GetOwner() == PaperDollFrameStrengthenFrame.StrengthenTittle then
		PaperDollFrameStrengthenFrame.StrengthenTittle:GetScript("OnEnter")(PaperDollFrameStrengthenFrame.StrengthenTittle)
	end
end

function EventHandler:BONUS_STATS(msg)
	local statValues = {strsplit(";", msg)}

	table.wipe(BONUS_STAT_VALUES)

	for index, value in ipairs(statValues) do
		value = RoundToSignificantDigits(tonumber(value), 2)
		BONUS_STAT_VALUES[index] = value

		local multiplier = BONUS_STAT_MULTIPLIERS[index] or 1
		StrengthenFrame[index].Value:SetFormattedText("%s (+|cff00FF00%s|r)", RoundToSignificantDigits(value / multiplier, 2), value)
	end
end

function EventHandler:ASMSG_UPS_INFO(msg)
	local statMultipliers = {strsplit(";", msg)}

	table.wipe(BONUS_STAT_MULTIPLIERS)

	for index, multiplier in ipairs(statMultipliers) do
		multiplier = RoundToSignificantDigits(tonumber(multiplier), 2)
		BONUS_STAT_MULTIPLIERS[index] = multiplier

		local value = BONUS_STAT_VALUES[index] or 0
		StrengthenFrame[index].Value:SetFormattedText("%s (+|cff00FF00%s|r)", RoundToSignificantDigits(value / multiplier, 2), value)
	end
end

local ONSLAUGHT_RATING = 0;

function EventHandler:ASMSG_CR_41(msg)
	local onslaughtRating = tonumber(msg);
	if onslaughtRating then
		ONSLAUGHT_RATING = onslaughtRating;
		FireClientEvent("UNIT_STATS", "player")
	end
end

function GetOnslaughtRating()
	return ONSLAUGHT_RATING;
end

function PaperDollFrame_OnEvent (self, event, ...)
	local unit = ...;

	if event == "PLAYER_ENTERING_WORLD" then
		RequestInventoryTransmogInfo()
	end

	if event == "PLAYER_ENTERING_WORLD"
	or (event == "UNIT_INVENTORY_CHANGED" and unit == "player")
	then
		table.wipe(self.equipmentItemsList)

		for slotID = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
			local link = GetInventoryItemLink("player", slotID)
			if link then
				local itemName = GetItemInfo(link)
				if itemName then
					self.equipmentItemsList[itemName:lower()] = link
				end
			end
		end
	end

	if event == "PLAYER_EQUIPMENT_CHANGED" then
		RequestInventoryTransmogInfo(true)
	end

	if ( event == "ADDON_LOADED" ) then
		if ... == "Blizzard_InspectUI" then
			hooksecurefunc("InspectPaperDollItemSlotButton_OnEnter", InspectTransmogTooltipAddLine)
			self:UnregisterEvent(event)
		end
	end
	if ( event == "PLAYER_TARGET_CHANGED" or event == "PARTY_MEMBERS_CHANGED" or event == "UNIT_INVENTORY_CHANGED") then
		if (InspectFrame) and InspectFrame:IsShown() then
			local unit = InspectFrame.unit
			if ( CanInspect(unit) and InspectFrame.ilvlframe ) then
				ItemLevelMixIn:Request( unit )
			end
		end
	end
	if ( event == "PLAYER_ENTERING_WORLD" or
		event == "UNIT_MODEL_CHANGED" and unit == "player" ) then
		PaperDollFrame_SetLevel()
		CharacterModelFrame:SetUnit("player");
		return;
	elseif ( event == "VARIABLES_LOADED" ) then
		-- Set defaults if no settings for the dropdowns
		if ( GetCVar("playerStatLeftDropdown") == "" or GetCVar("playerStatRightDropdown") == "" ) then
			local temp, classFileName = UnitClass("player");
			classFileName = strupper(classFileName);
			SetCVar("playerStatLeftDropdown", "PLAYERSTAT_BASE_STATS");
			if ( classFileName == "MAGE" or classFileName == "PRIEST" or classFileName == "WARLOCK" or classFileName == "DRUID" ) then
				SetCVar("playerStatRightDropdown", "PLAYERSTAT_SPELL_COMBAT");
			elseif ( classFileName == "HUNTER" ) then
				SetCVar("playerStatRightDropdown", "PLAYERSTAT_RANGED_COMBAT");
			else
				SetCVar("playerStatRightDropdown", "PLAYERSTAT_MELEE_COMBAT");
			end
		end
		PaperDollFrame_UpdateStats(self);
	elseif ( event == "KNOWN_TITLES_UPDATE" or (event == "UNIT_NAME_UPDATE" and unit == "player")) then
		PlayerTitleFrame_UpdateTitles();
		-- CharacterNamesText:SetText(UnitPVPName("player"))
	end

	if ( not self:IsVisible() ) then
		return;
	end

	if ( unit == "player" ) then
		if ( event == "UNIT_LEVEL" ) then
			PaperDollFrame_SetLevel();
		elseif ( event == "UNIT_DAMAGE" or event == "PLAYER_DAMAGE_DONE_MODS" or event == "UNIT_ATTACK_SPEED" or event == "UNIT_RANGEDDAMAGE" or event == "UNIT_ATTACK" or event == "UNIT_STATS" or event == "UNIT_RANGED_ATTACK_POWER" ) then
			PaperDollFrame_UpdateStats();
		elseif ( event == "UNIT_RESISTANCES" ) then
			PaperDollFrame_SetResistances();
			PaperDollFrame_UpdateStats();
		elseif ( event == "UNIT_RANGED_ATTACK_POWER" ) then
			PaperDollFrame_SetRangedAttack();
		end
	end

	if ( event == "COMBAT_RATING_UPDATE" ) then
		PaperDollFrame_UpdateStats();
	end
end

function PaperDollFrame_SetLevel()
	local classDisplayName, class = UnitClass("player");
	local classColorString = GetClassColorObj(class).colorStr;
	local level = UnitLevel("player");
	local race = UnitRace("player")
	local _, faction = UnitFactionGroup("player")

	CharacterLevelText:SetFormattedText(PAPERDOLLFRAME_PLAYER_INFO, level, classColorString, classDisplayName, race, faction)
end

function PaperDollFrame_SetGuild()
	local guildName;
	local title;
	local rank;
	guildName, title, rank = GetGuildInfo("player");
	if ( guildName ) then
		CharacterGuildText:Show();
		CharacterGuildText:SetFormattedText(GUILD_TITLE_TEMPLATE, title, guildName);
		-- Set it for the honor frame while we're at it
		HonorGuildText:Show();
		HonorGuildText:SetFormattedText(GUILD_TITLE_TEMPLATE, title, guildName);
	else
		CharacterGuildText:Hide();

		HonorGuildText:Hide();
	end
end

function PaperDollFrame_SetStat(statFrame, statIndex)
	local label = _G[statFrame:GetName().."Label"];
	local text = _G[statFrame:GetName().."StatText"];
	local stat;
	local effectiveStat;
	local posBuff;
	local negBuff;
	stat, effectiveStat, posBuff, negBuff = UnitStat("player", statIndex);
	local statName = _G["SPELL_STAT"..statIndex.."_NAME"];
	label:SetText(format(STAT_FORMAT, statName));

	-- Set the tooltip text
	local tooltipText = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, statName).." ";

	if ( ( posBuff == 0 ) and ( negBuff == 0 ) ) then
		text:SetText(effectiveStat);
		statFrame.tooltip = tooltipText..effectiveStat..FONT_COLOR_CODE_CLOSE;
	else
		tooltipText = tooltipText..effectiveStat;
		if ( posBuff > 0 or negBuff < 0 ) then
			tooltipText = tooltipText.." ("..(stat - posBuff - negBuff)..FONT_COLOR_CODE_CLOSE;
		end
		if ( posBuff > 0 ) then
			tooltipText = tooltipText..FONT_COLOR_CODE_CLOSE..GREEN_FONT_COLOR_CODE.."+"..posBuff..FONT_COLOR_CODE_CLOSE;
		end
		if ( negBuff < 0 ) then
			tooltipText = tooltipText..RED_FONT_COLOR_CODE.." "..negBuff..FONT_COLOR_CODE_CLOSE;
		end
		if ( posBuff > 0 or negBuff < 0 ) then
			tooltipText = tooltipText..HIGHLIGHT_FONT_COLOR_CODE..")"..FONT_COLOR_CODE_CLOSE;
		end
		statFrame.tooltip = tooltipText;

		-- If there are any negative buffs then show the main number in red even if there are
		-- positive buffs. Otherwise show in green.
		if ( negBuff < 0 ) then
			text:SetText(RED_FONT_COLOR_CODE..effectiveStat..FONT_COLOR_CODE_CLOSE);
		else
			text:SetText(GREEN_FONT_COLOR_CODE..effectiveStat..FONT_COLOR_CODE_CLOSE);
		end
	end
	statFrame.tooltip2 = _G["DEFAULT_STAT"..statIndex.."_TOOLTIP"];
	local _, unitClass = UnitClass("player");
	unitClass = strupper(unitClass);

	if ( statIndex == 1 ) then
		local attackPower = GetAttackPowerForStat(statIndex,effectiveStat);
		statFrame.tooltip2 = format(statFrame.tooltip2, attackPower);
		if ( unitClass == "WARRIOR" or unitClass == "SHAMAN" or unitClass == "PALADIN" ) then
			statFrame.tooltip2 = statFrame.tooltip2 .. "\n" .. format( STAT_BLOCK_TOOLTIP, max(0, effectiveStat*BLOCK_PER_STRENGTH-10) );
		end
	elseif ( statIndex == 3 ) then
		local baseStam = min(20, effectiveStat);
		local moreStam = effectiveStat - baseStam;
		statFrame.tooltip2 = format(statFrame.tooltip2, (baseStam + (moreStam*HEALTH_PER_STAMINA))*GetUnitMaxHealthModifier("player"));
		local petStam = ComputePetBonus("PET_BONUS_STAM", effectiveStat );
		if( petStam > 0 ) then
			statFrame.tooltip2 = statFrame.tooltip2 .. "\n" .. format(PET_BONUS_TOOLTIP_STAMINA,petStam);
		end
	elseif ( statIndex == 2 ) then
		local attackPower = GetAttackPowerForStat(statIndex,effectiveStat);
		if ( attackPower > 0 ) then
			statFrame.tooltip2 = format(STAT_ATTACK_POWER, attackPower) .. format(statFrame.tooltip2, GetCritChanceFromAgility("player"), effectiveStat*ARMOR_PER_AGILITY);
		else
			statFrame.tooltip2 = format(statFrame.tooltip2, GetCritChanceFromAgility("player"), effectiveStat*ARMOR_PER_AGILITY);
		end
	elseif ( statIndex == 4 ) then
		local baseInt = min(20, effectiveStat);
		local moreInt = effectiveStat - baseInt
		if ( UnitHasMana("player") ) then
			statFrame.tooltip2 = format(statFrame.tooltip2, baseInt + moreInt*MANA_PER_INTELLECT, GetSpellCritChanceFromIntellect("player"));
		else
			statFrame.tooltip2 = nil;
		end
		local petInt = ComputePetBonus("PET_BONUS_INT", effectiveStat );
		if( petInt > 0 ) then
			if ( not statFrame.tooltip2 ) then
				statFrame.tooltip2 = "";
			end
			statFrame.tooltip2 = statFrame.tooltip2 .. "\n" .. format(PET_BONUS_TOOLTIP_INTELLECT,petInt);
		end
	elseif ( statIndex == 5 ) then
		-- All mana regen stats are displayed as mana/5 sec.
		statFrame.tooltip2 = format(statFrame.tooltip2, GetUnitHealthRegenRateFromSpirit("player"));
		if ( UnitHasMana("player") ) then
			local regen = GetUnitManaRegenRateFromSpirit("player");
			regen = floor( regen * 5.0 );
			statFrame.tooltip2 = statFrame.tooltip2.."\n"..format(MANA_REGEN_FROM_SPIRIT, regen);
		end
	end
	statFrame:Show();
end

function PaperDollFrame_SetRating(statFrame, ratingIndex)
	local label = _G[statFrame:GetName().."Label"];
	local text = _G[statFrame:GetName().."StatText"];
	local statName = _G["COMBAT_RATING_NAME"..ratingIndex];
	label:SetText(format(STAT_FORMAT, statName));
	local rating = GetCombatRating(ratingIndex);
	local ratingBonus = GetCombatRatingBonus(ratingIndex);
	text:SetText(rating);

	-- Set the tooltip text
	statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, statName).." "..rating..FONT_COLOR_CODE_CLOSE;
	-- Can probably axe this if else tree if all rating tooltips follow the same format
	if ( ratingIndex == CR_HIT_MELEE ) then
		statFrame.tooltip2 = format(CR_HIT_MELEE_TOOLTIP, UnitLevel("player"), ratingBonus, GetCombatRating(CR_ARMOR_PENETRATION), GetArmorPenetration());
	elseif ( ratingIndex == CR_HIT_RANGED ) then
		statFrame.tooltip2 = format(CR_HIT_RANGED_TOOLTIP, UnitLevel("player"), ratingBonus, GetCombatRating(CR_ARMOR_PENETRATION), GetArmorPenetration());
	elseif ( ratingIndex == CR_DODGE ) then
		statFrame.tooltip2 = format(CR_DODGE_TOOLTIP, ratingBonus);
	elseif ( ratingIndex == CR_PARRY ) then
		statFrame.tooltip2 = format(CR_PARRY_TOOLTIP, ratingBonus);
	elseif ( ratingIndex == CR_BLOCK ) then
		statFrame.tooltip2 = format(CR_PARRY_TOOLTIP, ratingBonus);
	elseif ( ratingIndex == CR_HIT_SPELL ) then
		local spellPenetration = GetSpellPenetration();
		statFrame.tooltip2 = format(CR_HIT_SPELL_TOOLTIP, UnitLevel("player"), ratingBonus, spellPenetration, spellPenetration);
	elseif ( ratingIndex == CR_CRIT_SPELL ) then
		local holySchool = 2;
		local minCrit = GetSpellCritChance(holySchool);
		statFrame.spellCrit = {};
		statFrame.spellCrit[holySchool] = minCrit;
		local spellCrit;
		for i=(holySchool+1), MAX_SPELL_SCHOOLS do
			spellCrit = GetSpellCritChance(i);
			minCrit = min(minCrit, spellCrit);
			statFrame.spellCrit[i] = spellCrit;
		end
		minCrit = format("%.2f%%", minCrit);
		statFrame.minCrit = minCrit;
	elseif ( ratingIndex == CR_EXPERTISE ) then
		statFrame.tooltip2 = format(CR_EXPERTISE_TOOLTIP, ratingBonus);
	else
		statFrame.tooltip2 = HIGHLIGHT_FONT_COLOR_CODE.._G["COMBAT_RATING_NAME"..ratingIndex].." "..rating;
	end

	statFrame:Show();
end

function PaperDollFrame_SetResistances()
	for i=1, NUM_RESISTANCE_TYPES, 1 do
		local resistance;
		local positive;
		local negative;
		local resistanceLevel
		local base;
		local text = _G["MagicResText"..i];
		local frame = _G["MagicResFrame"..i];

		base, resistance, positive, negative = UnitResistance("player", frame:GetID());
		local petBonus = ComputePetBonus( "PET_BONUS_RES", resistance );

		local resistanceName = _G["RESISTANCE"..(frame:GetID()).."_NAME"];
		frame.tooltip = format(PAPERDOLLFRAME_TOOLTIP_FORMAT, resistanceName).." "..resistance;

		-- resistances can now be negative. Show Red if negative, Green if positive, white otherwise
		if( abs(negative) > positive ) then
			text:SetText(RED_FONT_COLOR_CODE..resistance..FONT_COLOR_CODE_CLOSE);
		elseif( abs(negative) == positive ) then
			text:SetText(resistance);
		else
			text:SetText(GREEN_FONT_COLOR_CODE..resistance..FONT_COLOR_CODE_CLOSE);
		end

		if ( positive ~= 0 or negative ~= 0 ) then
			-- Otherwise build up the formula
			frame.tooltip = frame.tooltip.. " ( "..HIGHLIGHT_FONT_COLOR_CODE..base;
			if( positive > 0 ) then
				frame.tooltip = frame.tooltip..GREEN_FONT_COLOR_CODE.." +"..positive;
			end
			if( negative < 0 ) then
				frame.tooltip = frame.tooltip.." "..RED_FONT_COLOR_CODE..negative;
			end
			frame.tooltip = frame.tooltip..FONT_COLOR_CODE_CLOSE.." )";
		end
		local unitLevel = UnitLevel("player");
		unitLevel = max(unitLevel, 20);
		local magicResistanceNumber = resistance/unitLevel;
		if ( magicResistanceNumber > 5 ) then
			resistanceLevel = RESISTANCE_EXCELLENT;
		elseif ( magicResistanceNumber > 3.75 ) then
			resistanceLevel = RESISTANCE_VERYGOOD;
		elseif ( magicResistanceNumber > 2.5 ) then
			resistanceLevel = RESISTANCE_GOOD;
		elseif ( magicResistanceNumber > 1.25 ) then
			resistanceLevel = RESISTANCE_FAIR;
		elseif ( magicResistanceNumber > 0 ) then
			resistanceLevel = RESISTANCE_POOR;
		else
			resistanceLevel = RESISTANCE_NONE;
		end
		frame.tooltipSubtext = format(RESISTANCE_TOOLTIP_SUBTEXT, _G["RESISTANCE_TYPE"..frame:GetID()], unitLevel, resistanceLevel);

		if unitLevel == 80 then
			frame.tooltipSubtext = frame.tooltipSubtext .. "\n" .. format(RESISTANCE_TOOLTIP_SUBTEXT2, 100 / ((((unitLevel * 675.5) / 83) + unitLevel) / resistance + 1));
		end

		if( petBonus > 0 ) then
			frame.tooltipSubtext = frame.tooltipSubtext .. "\n" .. format(PET_BONUS_TOOLTIP_RESISTANCE, petBonus);
		end
	end
end

function PaperDollFrame_SetArmor(statFrame, unit)
	if ( not unit ) then
		unit = "player";
	end
	local base, effectiveArmor, armor, posBuff, negBuff = UnitArmor(unit);
	_G[statFrame:GetName().."Label"]:SetText(format(STAT_FORMAT, ARMOR));
	local text = _G[statFrame:GetName().."StatText"];

	PaperDollFormatStat(ARMOR, base, posBuff, negBuff, statFrame, text);
	local armorReduction = PaperDollFrame_GetArmorReduction(effectiveArmor, UnitLevel(unit));
	statFrame.tooltip2 = format(DEFAULT_STATARMOR_TOOLTIP, armorReduction);

	if ( unit == "player" ) then
		local petBonus = ComputePetBonus("PET_BONUS_ARMOR", effectiveArmor );
		if( petBonus > 0 ) then
			statFrame.tooltip2 = statFrame.tooltip2 .. "\n" .. format(PET_BONUS_TOOLTIP_ARMOR, petBonus);
		end
	end

	statFrame:Show();
end

function PaperDollFrame_SetDefense(statFrame, unit)
	if ( not unit ) then
		unit = "player";
	end
	local base, modifier = UnitDefense(unit);
	local posBuff = 0;
	local negBuff = 0;
	if ( modifier > 0 ) then
		posBuff = modifier;
	elseif ( modifier < 0 ) then
		negBuff = modifier;
	end
	_G[statFrame:GetName().."Label"]:SetText(format(STAT_FORMAT, DEFENSE));
	local text = _G[statFrame:GetName().."StatText"];

	PaperDollFormatStat(DEFENSE, base, posBuff, negBuff, statFrame, text);
	local defensePercent = GetDodgeBlockParryChanceFromDefense();
	statFrame.tooltip2 = format(DEFAULT_STATDEFENSE_TOOLTIP, GetCombatRating(CR_DEFENSE_SKILL), GetCombatRatingBonus(CR_DEFENSE_SKILL), defensePercent, defensePercent);
	statFrame:Show();
end

function PaperDollFrame_SetDodge(statFrame)
	local chance = GetDodgeChance();
	PaperDollFrame_SetLabelAndText(statFrame, STAT_DODGE, chance, 1);
	statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, DODGE_CHANCE).." "..string.format("%.02f", chance).."%"..FONT_COLOR_CODE_CLOSE;
	statFrame.tooltip2 = format(CR_DODGE_TOOLTIP, GetCombatRating(CR_DODGE), GetCombatRatingBonus(CR_DODGE));
	statFrame:Show();
end

function PaperDollFrame_SetBlock(statFrame)
	local chance = GetBlockChance();
	PaperDollFrame_SetLabelAndText(statFrame, STAT_BLOCK, chance, 1);
	statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, BLOCK_CHANCE).." "..string.format("%.02f", chance).."%"..FONT_COLOR_CODE_CLOSE;
	statFrame.tooltip2 = format(CR_BLOCK_TOOLTIP, GetCombatRating(CR_BLOCK), GetCombatRatingBonus(CR_BLOCK), GetShieldBlock());
	statFrame:Show();
end

function PaperDollFrame_SetParry(statFrame)
	local chance = GetParryChance();
	PaperDollFrame_SetLabelAndText(statFrame, STAT_PARRY, chance, 1);
	statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, PARRY_CHANCE).." "..string.format("%.02f", chance).."%"..FONT_COLOR_CODE_CLOSE;
	statFrame.tooltip2 = format(CR_PARRY_TOOLTIP, GetCombatRating(CR_PARRY), GetCombatRatingBonus(CR_PARRY));
	statFrame:Show();
end

function GetDodgeBlockParryChanceFromDefense()
	local base, modifier = UnitDefense("player");
	--local defensePercent = DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE * modifier;
	local defensePercent = DODGE_PARRY_BLOCK_PERCENT_PER_DEFENSE * ((base + modifier) - (UnitLevel("player")*5));
	defensePercent = max(defensePercent, 0);
	return defensePercent;
end

function PaperDollFrame_SetResilience(statFrame)
	local melee = GetCombatRating(CR_CRIT_TAKEN_MELEE);
	local ranged = GetCombatRating(CR_CRIT_TAKEN_RANGED);
	local spell = GetCombatRating(CR_CRIT_TAKEN_SPELL);

	local minResilience = min(melee, ranged);
	minResilience = min(minResilience, spell);

	local lowestRating = CR_CRIT_TAKEN_MELEE;
	if ( melee == minResilience ) then
		lowestRating = CR_CRIT_TAKEN_MELEE;
	elseif ( ranged == minResilience ) then
		lowestRating = CR_CRIT_TAKEN_RANGED;
	else
		lowestRating = CR_CRIT_TAKEN_SPELL;
	end

	local maxRatingBonus = GetMaxCombatRatingBonus(lowestRating);
	local lowestRatingBonus = GetCombatRatingBonus(lowestRating);

	PaperDollFrame_SetLabelAndText(statFrame, STAT_RESILIENCE, minResilience);
	statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_RESILIENCE).." "..minResilience..FONT_COLOR_CODE_CLOSE;
	statFrame.tooltip2 = format(RESILIENCE_TOOLTIP, lowestRatingBonus, min(lowestRatingBonus * RESILIENCE_CRIT_CHANCE_TO_DAMAGE_REDUCTION_MULTIPLIER, maxRatingBonus), lowestRatingBonus * RESILIENCE_CRIT_CHANCE_TO_CONSTANT_DAMAGE_REDUCTION_MULTIPLIER);

	local onslaughtRating = GetOnslaughtRating();
	if onslaughtRating < 0 then
		statFrame.tooltip2 = statFrame.tooltip2 .. "\n\n" .. format(CR_ONSLAUGHT_RATING_INCREASE_TOOLTIP, onslaughtRating, onslaughtRating);
	else
		statFrame.tooltip2 = statFrame.tooltip2 .. "\n\n" .. format(CR_ONSLAUGHT_RATING_REDUSE_TOOLTIP, onslaughtRating, onslaughtRating);
	end

	statFrame:Show();
end

function PaperDollFrame_SetDamage(statFrame, unit)
	if ( not unit ) then
		unit = "player";
	end
	_G[statFrame:GetName().."Label"]:SetText(format(STAT_FORMAT, DAMAGE));
	local text = _G[statFrame:GetName().."StatText"];
	local speed, offhandSpeed = UnitAttackSpeed(unit);

	local minDamage;
	local maxDamage;
	local minOffHandDamage;
	local maxOffHandDamage;
	local physicalBonusPos;
	local physicalBonusNeg;
	local percent;
	minDamage, maxDamage, minOffHandDamage, maxOffHandDamage, physicalBonusPos, physicalBonusNeg, percent = UnitDamage(unit);
	local displayMin = max(floor(minDamage),1);
	local displayMax = max(ceil(maxDamage),1);

	minDamage = (minDamage / percent) - physicalBonusPos - physicalBonusNeg;
	maxDamage = (maxDamage / percent) - physicalBonusPos - physicalBonusNeg;

	local baseDamage = (minDamage + maxDamage) * 0.5;
	local fullDamage = (baseDamage + physicalBonusPos + physicalBonusNeg) * percent;
	local totalBonus = (fullDamage - baseDamage);
	local damagePerSecond = (max(fullDamage,1) / speed);
	local damageTooltip = max(floor(minDamage),1).." - "..max(ceil(maxDamage),1);

	local colorPos = "|cff20ff20";
	local colorNeg = "|cffff2020";

	-- epsilon check
	if ( totalBonus < 0.1 and totalBonus > -0.1 ) then
		totalBonus = 0.0;
	end

	if ( totalBonus == 0 ) then
		if ( ( displayMin < 100 ) and ( displayMax < 100 ) ) then
			text:SetText(displayMin.." - "..displayMax);
		else
			text:SetText(displayMin.."-"..displayMax);
		end
	else

		local color;
		if ( totalBonus > 0 ) then
			color = colorPos;
		else
			color = colorNeg;
		end
		if ( ( displayMin < 100 ) and ( displayMax < 100 ) ) then
			text:SetText(color..displayMin.." - "..displayMax.."|r");
		else
			text:SetText(color..displayMin.."-"..displayMax.."|r");
		end
		if ( physicalBonusPos > 0 ) then
			damageTooltip = damageTooltip..colorPos.." +"..physicalBonusPos.."|r";
		end
		if ( physicalBonusNeg < 0 ) then
			damageTooltip = damageTooltip..colorNeg.." "..physicalBonusNeg.."|r";
		end
		if ( percent > 1 ) then
			damageTooltip = damageTooltip..colorPos.." x"..floor(percent*100+0.5).."%|r";
		elseif ( percent < 1 ) then
			damageTooltip = damageTooltip..colorNeg.." x"..floor(percent*100+0.5).."%|r";
		end

	end
	statFrame.damage = damageTooltip;
	statFrame.attackSpeed = speed;
	statFrame.dps = damagePerSecond;

	-- If there's an offhand speed then add the offhand info to the tooltip
	if ( offhandSpeed ) then
		minOffHandDamage = (minOffHandDamage / percent) - physicalBonusPos - physicalBonusNeg;
		maxOffHandDamage = (maxOffHandDamage / percent) - physicalBonusPos - physicalBonusNeg;

		local offhandBaseDamage = (minOffHandDamage + maxOffHandDamage) * 0.5;
		local offhandFullDamage = (offhandBaseDamage + physicalBonusPos + physicalBonusNeg) * percent;
		local offhandDamagePerSecond = (max(offhandFullDamage,1) / offhandSpeed);
		local offhandDamageTooltip = max(floor(minOffHandDamage),1).." - "..max(ceil(maxOffHandDamage),1);
		if ( physicalBonusPos > 0 ) then
			offhandDamageTooltip = offhandDamageTooltip..colorPos.." +"..physicalBonusPos.."|r";
		end
		if ( physicalBonusNeg < 0 ) then
			offhandDamageTooltip = offhandDamageTooltip..colorNeg.." "..physicalBonusNeg.."|r";
		end
		if ( percent > 1 ) then
			offhandDamageTooltip = offhandDamageTooltip..colorPos.." x"..floor(percent*100+0.5).."%|r";
		elseif ( percent < 1 ) then
			offhandDamageTooltip = offhandDamageTooltip..colorNeg.." x"..floor(percent*100+0.5).."%|r";
		end
		statFrame.offhandDamage = offhandDamageTooltip;
		statFrame.offhandAttackSpeed = offhandSpeed;
		statFrame.offhandDps = offhandDamagePerSecond;
	else
		statFrame.offhandAttackSpeed = nil;
	end
	statFrame:Show();
end

function PaperDollFrame_SetAttackSpeed(statFrame, unit)
	if ( not unit ) then
		unit = "player";
	end
	local speed, offhandSpeed = UnitAttackSpeed(unit);
	speed = format("%.2f", speed);
	if ( offhandSpeed ) then
		offhandSpeed = format("%.2f", offhandSpeed);
	end
	local text;
	if ( offhandSpeed ) then
		text = speed.." / "..offhandSpeed;
	else
		text = speed;
	end
	PaperDollFrame_SetLabelAndText(statFrame, WEAPON_SPEED, text);

	statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, ATTACK_SPEED).." "..text..FONT_COLOR_CODE_CLOSE;
	statFrame.tooltip2 = format(CR_HASTE_RATING_TOOLTIP, GetCombatRating(CR_HASTE_MELEE), GetCombatRatingBonus(CR_HASTE_MELEE));

	statFrame:Show();
end

function PaperDollFrame_SetAttackPower(statFrame, unit)
	if ( not unit ) then
		unit = "player";
	end
	_G[statFrame:GetName().."Label"]:SetText(format(STAT_FORMAT, ATTACK_POWER));
	local text = _G[statFrame:GetName().."StatText"];
	local base, posBuff, negBuff = UnitAttackPower(unit);

	PaperDollFormatStat(MELEE_ATTACK_POWER, base, posBuff, negBuff, statFrame, text);
	statFrame.tooltip2 = format(MELEE_ATTACK_POWER_TOOLTIP, max((base+posBuff+negBuff), 0)/ATTACK_POWER_MAGIC_NUMBER);
	statFrame:Show();
end

function PaperDollFrame_SetAttackBothHands(statFrame, unit)
	if ( not unit ) then
		unit = "player";
	end
	local mainHandAttackBase, mainHandAttackMod, offHandAttackBase, offHandAttackMod = UnitAttackBothHands(unit);

	_G[statFrame:GetName().."Label"]:SetText(format(STAT_FORMAT, COMBAT_RATING_NAME1));
	local text = _G[statFrame:GetName().."StatText"];

	if( mainHandAttackMod == 0 ) then
		text:SetText(mainHandAttackBase);
	else
		local color = RED_FONT_COLOR_CODE;
		if( mainHandAttackMod > 0 ) then
			color = GREEN_FONT_COLOR_CODE;
		end
		text:SetText(color..(mainHandAttackBase + mainHandAttackMod)..FONT_COLOR_CODE_CLOSE);
	end

	if( mainHandAttackMod == 0 ) then
		statFrame.weaponSkill = COMBAT_RATING_NAME1.." "..mainHandAttackBase;
	else
		local color = RED_FONT_COLOR_CODE;
		statFrame.weaponSkill = COMBAT_RATING_NAME1.." "..(mainHandAttackBase + mainHandAttackMod).." ("..mainHandAttackBase..color.." "..mainHandAttackMod..")";
		if( mainHandAttackMod > 0 ) then
			color = GREEN_FONT_COLOR_CODE;
			statFrame.weaponSkill = COMBAT_RATING_NAME1.." "..(mainHandAttackBase + mainHandAttackMod).." ("..mainHandAttackBase..color.." +"..mainHandAttackMod..FONT_COLOR_CODE_CLOSE..")";
		end
	end

	local total = GetCombatRating(CR_WEAPON_SKILL) + GetCombatRating(CR_WEAPON_SKILL_MAINHAND);
	statFrame.weaponRating = format(WEAPON_SKILL_RATING, total);
	if ( total > 0 ) then
		statFrame.weaponRating = statFrame.weaponRating..format(WEAPON_SKILL_RATING_BONUS, GetCombatRatingBonus(CR_WEAPON_SKILL) + GetCombatRatingBonus(CR_WEAPON_SKILL_MAINHAND));
	end

	local speed, offhandSpeed = UnitAttackSpeed(unit);
	if ( offhandSpeed ) then
		if( offHandAttackMod == 0 ) then
			statFrame.offhandSkill = COMBAT_RATING_NAME1.." "..offHandAttackBase;
		else
			local color = RED_FONT_COLOR_CODE;
			statFrame.offhandSkill = COMBAT_RATING_NAME1.." "..(offHandAttackBase + offHandAttackMod).." ("..offHandAttackBase..color.." "..offHandAttackMod..")";
			if( offHandAttackMod > 0 ) then
				color = GREEN_FONT_COLOR_CODE;
				statFrame.offhandSkill = COMBAT_RATING_NAME1.." "..(offHandAttackBase + offHandAttackMod).." ("..offHandAttackBase..color.." +"..offHandAttackMod..FONT_COLOR_CODE_CLOSE..")";
			end
		end

		total = GetCombatRating(CR_WEAPON_SKILL) + GetCombatRating(CR_WEAPON_SKILL_OFFHAND);
		statFrame.offhandRating = format(WEAPON_SKILL_RATING, total);
		if ( total > 0 ) then
			statFrame.offhandRating = statFrame.offhandRating..format(WEAPON_SKILL_RATING_BONUS, GetCombatRatingBonus(CR_WEAPON_SKILL) + GetCombatRatingBonus(CR_WEAPON_SKILL_OFFHAND));
		end
	else
		statFrame.offhandSkill = nil;
	end

	statFrame:Show();
end

function PaperDollFrame_SetRangedAttack(statFrame, unit)
	if ( not unit ) then
		unit = "player";
	elseif ( unit == "pet" ) then
		return;
	end

	local hasRelic = UnitHasRelicSlot(unit);
	local rangedAttackBase, rangedAttackMod = UnitRangedAttack(unit);
	_G[statFrame:GetName().."Label"]:SetText(format(STAT_FORMAT, COMBAT_RATING_NAME1));
	local text = _G[statFrame:GetName().."StatText"];

	-- If no ranged texture then set stats to n/a
	local rangedTexture = GetInventoryItemTexture("player", 18);
	if ( rangedTexture and not hasRelic ) then
		PaperDollFrame.noRanged = nil;
	else
		text:SetText(NOT_APPLICABLE);
		PaperDollFrame.noRanged = 1;
		statFrame.tooltip = nil;
	end
	if ( not rangedTexture or hasRelic ) then
		return;
	end

	if( rangedAttackMod == 0 ) then
		text:SetText(rangedAttackBase);
		statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, COMBAT_RATING_NAME1).." "..rangedAttackBase..FONT_COLOR_CODE_CLOSE;
	else
		local color = RED_FONT_COLOR_CODE;
		if( rangedAttackMod > 0 ) then
	  		color = GREEN_FONT_COLOR_CODE;
			statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, COMBAT_RATING_NAME1).." "..(rangedAttackBase + rangedAttackMod).." ("..rangedAttackBase..color.." +"..rangedAttackMod..FONT_COLOR_CODE_CLOSE..HIGHLIGHT_FONT_COLOR_CODE..")";
		else
			statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, COMBAT_RATING_NAME1).." "..(rangedAttackBase + rangedAttackMod).." ("..rangedAttackBase..color.." "..rangedAttackMod..FONT_COLOR_CODE_CLOSE..HIGHLIGHT_FONT_COLOR_CODE..")";
		end
		text:SetText(color..(rangedAttackBase + rangedAttackMod)..FONT_COLOR_CODE_CLOSE);
	end
	local total = GetCombatRating(CR_WEAPON_SKILL) + GetCombatRating(CR_WEAPON_SKILL_RANGED);
	statFrame.tooltip2 = format(WEAPON_SKILL_RATING, total);
	if ( total > 0 ) then
		statFrame.tooltip2 = statFrame.tooltip2..format(WEAPON_SKILL_RATING_BONUS, GetCombatRatingBonus(CR_WEAPON_SKILL) + GetCombatRatingBonus(CR_WEAPON_SKILL_RANGED));
	end
	statFrame:Show();
end

function PaperDollFrame_SetRangedDamage(statFrame, unit)
	if ( not unit ) then
		unit = "player";
	elseif ( unit == "pet" ) then
		return;
	end
	_G[statFrame:GetName().."Label"]:SetText(format(STAT_FORMAT, DAMAGE));
	local text = _G[statFrame:GetName().."StatText"];

	-- If no ranged attack then set to n/a
	local hasRelic = UnitHasRelicSlot(unit);
	local rangedTexture = GetInventoryItemTexture("player", 18);
	if ( rangedTexture and not hasRelic ) then
		PaperDollFrame.noRanged = nil;
	else
		text:SetText(NOT_APPLICABLE);
		PaperDollFrame.noRanged = 1;
		statFrame.damage = nil;
		return;
	end

	local rangedAttackSpeed, minDamage, maxDamage, physicalBonusPos, physicalBonusNeg, percent = UnitRangedDamage(unit);

	-- Round to the third decimal place (i.e. 99.9 percent)
	percent = math.floor(percent  * 10^3 + 0.5) / 10^3
	local displayMin = max(floor(minDamage),1);
	local displayMax = max(ceil(maxDamage),1);

	local baseDamage;
	local fullDamage;
	local totalBonus;
	local damagePerSecond;
	local tooltip;

	if ( HasWandEquipped() ) then
		baseDamage = (minDamage + maxDamage) * 0.5;
		fullDamage = baseDamage * percent;
		totalBonus = 0;
		if( rangedAttackSpeed == 0 ) then
			damagePerSecond = 0;
		else
			damagePerSecond = (max(fullDamage,1) / rangedAttackSpeed);
		end
		tooltip = max(floor(minDamage),1).." - "..max(ceil(maxDamage),1);
	else
		minDamage = (minDamage / percent) - physicalBonusPos - physicalBonusNeg;
		maxDamage = (maxDamage / percent) - physicalBonusPos - physicalBonusNeg;

		baseDamage = (minDamage + maxDamage) * 0.5;
		fullDamage = (baseDamage + physicalBonusPos + physicalBonusNeg) * percent;
		totalBonus = (fullDamage - baseDamage);
		if( rangedAttackSpeed == 0 ) then
			damagePerSecond = 0;
		else
			damagePerSecond = (max(fullDamage,1) / rangedAttackSpeed);
		end
		tooltip = max(floor(minDamage),1).." - "..max(ceil(maxDamage),1);
	end

	if ( totalBonus == 0 ) then
		if ( ( displayMin < 100 ) and ( displayMax < 100 ) ) then
			text:SetText(displayMin.." - "..displayMax);
		else
			text:SetText(displayMin.."-"..displayMax);
		end
	else
		local colorPos = "|cff20ff20";
		local colorNeg = "|cffff2020";
		local color;
		if ( totalBonus > 0 ) then
			color = colorPos;
		else
			color = colorNeg;
		end
		if ( ( displayMin < 100 ) and ( displayMax < 100 ) ) then
			text:SetText(color..displayMin.." - "..displayMax.."|r");
		else
			text:SetText(color..displayMin.."-"..displayMax.."|r");
		end
		if ( physicalBonusPos > 0 ) then
			tooltip = tooltip..colorPos.." +"..physicalBonusPos.."|r";
		end
		if ( physicalBonusNeg < 0 ) then
			tooltip = tooltip..colorNeg.." "..physicalBonusNeg.."|r";
		end
		if ( percent > 1 ) then
			tooltip = tooltip..colorPos.." x"..floor(percent*100+0.5).."%|r";
		elseif ( percent < 1 ) then
			tooltip = tooltip..colorNeg.." x"..floor(percent*100+0.5).."%|r";
		end
		statFrame.tooltip = tooltip.." "..format(DPS_TEMPLATE, damagePerSecond);
	end
	statFrame.attackSpeed = rangedAttackSpeed;
	statFrame.damage = tooltip;
	statFrame.dps = damagePerSecond;
	statFrame:Show();
end

function PaperDollFrame_SetRangedAttackSpeed(statFrame, unit)
	if ( not unit ) then
		unit = "player";
	elseif ( unit == "pet" ) then
		return;
	end
	local text;
	-- If no ranged attack then set to n/a
	if ( PaperDollFrame.noRanged ) then
		text = NOT_APPLICABLE;
		statFrame.tooltip = nil;
	else
		text = UnitRangedDamage(unit);
		text = format("%.2f", text);
		statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, ATTACK_SPEED).." "..text..FONT_COLOR_CODE_CLOSE;
	end
	PaperDollFrame_SetLabelAndText(statFrame, WEAPON_SPEED, text);
	statFrame.tooltip2 = format(CR_HASTE_RATING_TOOLTIP, GetCombatRating(CR_HASTE_RANGED), GetCombatRatingBonus(CR_HASTE_RANGED));
	statFrame:Show();
end

function PaperDollFrame_SetRangedAttackPower(statFrame, unit)
	if ( not unit ) then
		unit = "player";
	end
	_G[statFrame:GetName().."Label"]:SetText(format(STAT_FORMAT, ATTACK_POWER));
	local text = _G[statFrame:GetName().."StatText"];
	local base, posBuff, negBuff = UnitRangedAttackPower(unit);

	PaperDollFormatStat(RANGED_ATTACK_POWER, base, posBuff, negBuff, statFrame, text);
	local totalAP = base+posBuff+negBuff;
	statFrame.tooltip2 = format(RANGED_ATTACK_POWER_TOOLTIP, max((totalAP), 0)/ATTACK_POWER_MAGIC_NUMBER);
	local petAPBonus = ComputePetBonus( "PET_BONUS_RAP_TO_AP", totalAP );
	if( petAPBonus > 0 ) then
		statFrame.tooltip2 = statFrame.tooltip2 .. "\n" .. format(PET_BONUS_TOOLTIP_RANGED_ATTACK_POWER, petAPBonus);
	end

	local petSpellDmgBonus = ComputePetBonus( "PET_BONUS_RAP_TO_SPELLDMG", totalAP );
	if( petSpellDmgBonus > 0 ) then
		statFrame.tooltip2 = statFrame.tooltip2 .. "\n" .. format(PET_BONUS_TOOLTIP_SPELLDAMAGE, petSpellDmgBonus);
	end

	statFrame:Show();
end

function PaperDollFrame_SetSpellBonusDamage(statFrame)
	_G[statFrame:GetName().."Label"]:SetText(format(STAT_FORMAT, BONUS_DAMAGE));
	local text = _G[statFrame:GetName().."StatText"];
	local holySchool = 2;
	-- Start at 2 to skip physical damage
	local minModifier = GetSpellBonusDamage(holySchool);
	statFrame.bonusDamage = {};
	statFrame.bonusDamage[holySchool] = minModifier;
	local bonusDamage;
	for i=(holySchool+1), MAX_SPELL_SCHOOLS do
		bonusDamage = GetSpellBonusDamage(i);
		minModifier = min(minModifier, bonusDamage);
		statFrame.bonusDamage[i] = bonusDamage;
	end
	text:SetText(minModifier);
	statFrame.minModifier = minModifier;
	statFrame:Show();
end

function PaperDollFrame_SetSpellCritChance(statFrame)
	_G[statFrame:GetName().."Label"]:SetText(format(STAT_FORMAT, SPELL_CRIT_CHANCE));
	local text = _G[statFrame:GetName().."StatText"];
	local holySchool = 2;
	-- Start at 2 to skip physical damage
	local minCrit = GetSpellCritChance(holySchool);
	statFrame.spellCrit = {};
	statFrame.spellCrit[holySchool] = minCrit;
	local spellCrit;
	for i=(holySchool+1), MAX_SPELL_SCHOOLS do
		spellCrit = GetSpellCritChance(i);
		minCrit = min(minCrit, spellCrit);
		statFrame.spellCrit[i] = spellCrit;
	end
	-- Add agility contribution
	--minCrit = minCrit + GetSpellCritChanceFromIntellect();
	minCrit = format("%.2f%%", minCrit);
	text:SetText(minCrit);
	statFrame.minCrit = minCrit;
	statFrame:Show();
end

function PaperDollFrame_SetMeleeCritChance(statFrame)
	_G[statFrame:GetName().."Label"]:SetText(format(STAT_FORMAT, MELEE_CRIT_CHANCE));
	local text = _G[statFrame:GetName().."StatText"];
	local critChance = GetCritChance();-- + GetCritChanceFromAgility();
	critChance = format("%.2f%%", critChance);
	text:SetText(critChance);
	statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, MELEE_CRIT_CHANCE).." "..critChance..FONT_COLOR_CODE_CLOSE;
	statFrame.tooltip2 = format(CR_CRIT_MELEE_TOOLTIP, GetCombatRating(CR_CRIT_MELEE), GetCombatRatingBonus(CR_CRIT_MELEE));
end

function PaperDollFrame_SetRangedCritChance(statFrame)
	_G[statFrame:GetName().."Label"]:SetText(format(STAT_FORMAT, RANGED_CRIT_CHANCE));
	local text = _G[statFrame:GetName().."StatText"];
	local critChance = GetRangedCritChance();-- + GetCritChanceFromAgility();
	critChance = format("%.2f%%", critChance);
	text:SetText(critChance);
	statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, RANGED_CRIT_CHANCE).." "..critChance..FONT_COLOR_CODE_CLOSE;
	statFrame.tooltip2 = format(CR_CRIT_RANGED_TOOLTIP, GetCombatRating(CR_CRIT_RANGED), GetCombatRatingBonus(CR_CRIT_RANGED));
end

function PaperDollFrame_SetSpellBonusHealing(statFrame)
	_G[statFrame:GetName().."Label"]:SetText(format(STAT_FORMAT, BONUS_HEALING));
	local text = _G[statFrame:GetName().."StatText"];
	local bonusHealing = GetSpellBonusHealing();
	text:SetText(bonusHealing);
	statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. BONUS_HEALING .. FONT_COLOR_CODE_CLOSE;
	statFrame.tooltip2 =format(BONUS_HEALING_TOOLTIP, bonusHealing);
	statFrame:Show();
end

function PaperDollFrame_SetSpellPenetration(statFrame)
	_G[statFrame:GetName().."Label"]:SetText(format(STAT_FORMAT, SPELL_PENETRATION));
	local text = _G[statFrame:GetName().."StatText"];
	text:SetText(GetSpellPenetration());
	statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE ..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, SPELL_PENETRATION).. FONT_COLOR_CODE_CLOSE;
	statFrame.tooltip2 = SPELL_PENETRATION_TOOLTIP;
	statFrame:Show();
end

function PaperDollFrame_SetSpellHaste(statFrame)
	_G[statFrame:GetName().."Label"]:SetText(format(STAT_FORMAT, SPELL_HASTE));
	local text = _G[statFrame:GetName().."StatText"];
	text:SetText(GetCombatRating(CR_HASTE_SPELL));
	statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. SPELL_HASTE .. FONT_COLOR_CODE_CLOSE;
	statFrame.tooltip2 = format(SPELL_HASTE_TOOLTIP, GetCombatRatingBonus(CR_HASTE_SPELL));
	statFrame:Show();
end

function PaperDollFrame_SetManaRegen(statFrame)
	_G[statFrame:GetName().."Label"]:SetText(format(STAT_FORMAT, MANA_REGEN));
	local text = _G[statFrame:GetName().."StatText"];
	if ( not UnitHasMana("player") ) then
		text:SetText(NOT_APPLICABLE);
		statFrame.tooltip = nil;
		return;
	end

	local base, casting = GetManaRegen();
	-- All mana regen stats are displayed as mana/5 sec.
	base = floor( base * 5.0 );
	casting = floor( casting * 5.0 );
	text:SetText(base);
	statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. MANA_REGEN .. FONT_COLOR_CODE_CLOSE;
	statFrame.tooltip2 = format(MANA_REGEN_TOOLTIP, base, casting);
	statFrame:Show();
end

function PaperDollFrame_SetExpertise(statFrame, unit)
	if ( not unit ) then
		unit = "player";
	end
	local expertise, offhandExpertise = GetExpertise();
	local speed, offhandSpeed = UnitAttackSpeed(unit);
	local text;
	if( offhandSpeed ) then
		text = expertise.." / "..offhandExpertise;
	else
		text = expertise;
	end
	PaperDollFrame_SetLabelAndText(statFrame, STAT_EXPERTISE, text);

	statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, _G["COMBAT_RATING_NAME"..CR_EXPERTISE]).." "..text..FONT_COLOR_CODE_CLOSE;

	local expertisePercent, offhandExpertisePercent = GetExpertisePercent();
	expertisePercent = format("%.2f", expertisePercent);
	if( offhandSpeed ) then
		offhandExpertisePercent = format("%.2f", offhandExpertisePercent);
		text = expertisePercent.."% / "..offhandExpertisePercent.."%";
	else
		text = expertisePercent.."%";
	end
	statFrame.tooltip2 = format(CR_EXPERTISE_TOOLTIP, text, GetCombatRating(CR_EXPERTISE), GetCombatRatingBonus(CR_EXPERTISE));

	statFrame:Show();
end

function CharacterSpellBonusDamage_OnEnter (self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, BONUS_DAMAGE).." "..self.minModifier..FONT_COLOR_CODE_CLOSE);
	for i=2, MAX_SPELL_SCHOOLS do
		GameTooltip:AddDoubleLine(_G["DAMAGE_SCHOOL"..i], self.bonusDamage[i], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
		GameTooltip:AddTexture("Interface\\PaperDollInfoFrame\\SpellSchoolIcon"..i);
	end

	local petStr, damage;
	if( self.bonusDamage[6] > self.bonusDamage[3] ) then
		petStr = PET_BONUS_TOOLTIP_WARLOCK_SPELLDMG_SHADOW;
		damage = self.bonusDamage[6];
	else
		petStr = PET_BONUS_TOOLTIP_WARLOCK_SPELLDMG_FIRE;
		damage = self.bonusDamage[3];
	end

	local petBonusAP = ComputePetBonus("PET_BONUS_SPELLDMG_TO_AP", damage );
	local petBonusDmg = ComputePetBonus("PET_BONUS_SPELLDMG_TO_SPELLDMG", damage );
	if( petBonusAP > 0 or petBonusDmg > 0 ) then
		GameTooltip:AddLine("\n" .. format(petStr, petBonusAP, petBonusDmg), nil, nil, nil, 1 );
	end
	GameTooltip:Show();
end

function CharacterSpellCritChance_OnEnter (self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:SetText(HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, COMBAT_RATING_NAME11).." "..GetCombatRating(11)..FONT_COLOR_CODE_CLOSE);
	local spellCrit;
	for i=2, MAX_SPELL_SCHOOLS do
		spellCrit = format("%.2f", self.spellCrit[i]);
		spellCrit = spellCrit.."%";
		GameTooltip:AddDoubleLine(_G["DAMAGE_SCHOOL"..i], spellCrit, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
		GameTooltip:AddTexture("Interface\\PaperDollInfoFrame\\SpellSchoolIcon"..i);
	end
	GameTooltip:Show();
end

function PaperDollFrame_OnShow(self)
	PaperDollSidebarTab1.Hider:Show()
	PaperDollSidebarTab1.Highlights:Show()
	PaperDollSidebarTab1.TabBg:SetTexCoord(0.01562500, 0.79687500, 0.61328125, 0.78125000)

	PaperDollSidebarTab2.Hider:Show()
	PaperDollSidebarTab2.Highlights:Show()
	PaperDollSidebarTab2.TabBg:SetTexCoord(0.01562500, 0.79687500, 0.61328125, 0.78125000)

	PlayerTitleFrame_UpdateTitles()
	PlayerTitlePickerFrame:Hide()
	-- CharacterFramePortrait:Hide()
	-- SetPortraitTexture(PaperDollFrame.portrait, "player")
	-- CharacterFrameCloseButton2:Show()
	--PaperDollFrame_SetGuild();
	PaperDollFrame_SetLevel();
	PaperDollFrame_SetResistances();
	PaperDollFrame_UpdateStats();
	PaperDollFrame_SetBackground()
	if ( UnitHasRelicSlot("player") ) then
		CharacterAmmoSlot:Hide();
	else
		CharacterAmmoSlot:Show();
	end

	if not self.isDisabledStrengthenFrame then
		if UnitLevel("player") < 80 then
			DisableStrengthenFrame:Show()
		else
			DisableStrengthenFrame:Hide()
		end

		if not NPE_TutorialPointerFrame:GetKey("PaperDollFrame_Strengthen") then
			if tutorialData.Strengthen then
				NPE_TutorialPointerFrame:Hide(tutorialData.Strengthen)
				tutorialData.Strengthen = nil
				PaperDollFrameStrengthenFrame.TutorialGlow:Hide()
			end

			if PaperDollFrameStrengthenFrame.StrengthenTittle.Current and PaperDollFrameStrengthenFrame.StrengthenTittle.Current >= 1 then
				local onClose = function()
					NPE_TutorialPointerFrame:Hide(tutorialData.Strengthen)
					tutorialData.Strengthen = nil
					PaperDollFrameStrengthenFrame.TutorialGlow:Hide()
					NPE_TutorialPointerFrame:SetKey("PaperDollFrame_Strengthen", true)
				end
				tutorialData.Strengthen = NPE_TutorialPointerFrame:Show(PAPERDOLLFRAME_UPS_HELP_1, "RIGHT", PaperDollFrameStrengthenFrame, 0, 0, nil, nil, nil, nil, onClose)
				PaperDollFrameStrengthenFrame.TutorialGlow:Show()
			end
		end

		PaperDollFrameStrengthenFrame:Show();
	else
		PaperDollFrame.NewPanel.Stats:Show();
	end

	ButtonFrameTemplate_HideButtonBar(CharacterFrame)
	CharacterFrame.Inset:Hide()
	CharacterFrame_Expand()

	PaperDollFrame_UpdateSpellButtons()
	EventRegistry:RegisterFrameEventAndCallback("SPELLS_CHANGED", PaperDollFrame_UpdateSpellButtons, "PaperDollFrame")
end

function PaperDollFrame_OnHide(self)
	-- CharacterFrameCloseButton2:Hide()
	CharacterFramePortrait:Show()
	PlayerTitlePickerFrame:Hide();
	GearManagerDialog:Hide();

	CharacterFrame_Collapse()

	EventRegistry:UnregisterFrameEventAndCallback("SPELLS_CHANGED", "PaperDollFrame")
end

function PaperDollFrame_UpdateSpellButtons()
	local isSpellKnown = PaperDollFrame.ItemSetSwapButton:IsSpellKnown()
	PaperDollFrame.ItemSetSwapButton:SetShown(isSpellKnown)

	if isSpellKnown then
		CharacterLevelText:SetPoint("TOP", -36, -35)
	else
		CharacterLevelText:SetPoint("TOP", 0, -35)
	end
end

function PaperDollFrame_DisableStrengthenFrame()
	CHARACTERFRAME_EXPANDED_WIDTH = 614 - 55;

	PaperDollFrame.NewPanel:SetPoint("BOTTOMRIGHT", -6, 5);
	PaperDollFrame.NewPanel.Stats:Show();
	PaperDollFrame.NewPanel.ClassBackground:Show();

	PaperDollFrame.EquipInset:SetPoint("BOTTOMRIGHT", PaperDollFrame.NewPanel, "BOTTOMLEFT");

	PaperDollFrameStrengthenFrame:Hide();

	PlayerTitlePickerFrame:SetSize(175, 454);
	PlayerTitlePickerScrollFrame:SetSize(165, 342);

	HybridScrollFrame_CreateButtons(PlayerTitlePickerScrollFrame, "PlayerTitleButtonTemplate");

	for _, button in pairs(PlayerTitlePickerScrollFrame.buttons) do
		button:SetWidth(175);
		button.Check:SetPoint("LEFT", 2, 0);
	end

	CharacterItemLevelFrame:ClearAllPoints();
	CharacterItemLevelFrame:SetParent(PaperDollFrameStatsFrameItemLevelCategory);
	CharacterItemLevelFrame:SetPoint("TOP", PaperDollFrameStatsFrameItemLevelCategory, "BOTTOM", 0, 0);

	PaperDollFrame.StatsInset:Hide();

	for i = 1, 6 do
		local statFrameLeft = _G["PlayerStatFrameLeft"..i];
		local statFrameRight = _G["PlayerStatFrameRight"..i];
		statFrameLeft:SetSize(167, 15);
		statFrameRight:SetSize(167, 15);

		statFrameLeft:SetParent(PaperDollFrameStatsFrameLeftCategory);
		statFrameRight:SetParent(PaperDollFrameStatsFrameRightCategory);

		if i % 2 == 0 then
			statFrameLeft.Background:Show();
			statFrameRight.Background:Show();
		end

		if i == 1 then
			statFrameLeft:ClearAllPoints();
			statFrameLeft:SetPoint("TOP", PaperDollFrameStatsFrameLeftCategory, "BOTTOM", 0, -8);
			statFrameRight:ClearAllPoints();
			statFrameRight:SetPoint("TOP", PaperDollFrameStatsFrameRightCategory, "BOTTOM", 0, -8);
		end
	end
end

function PaperDollFrame_SetBackground()
	local texture = GetDressUpTexturePath("player")
	local overlayAlpha = GetDressUpTextureAlpha("player")

	local topLeft = CharacterModelFrameBackgroundTopLeft
	local topRight = CharacterModelFrameBackgroundTopRight
	local bottomLeft = CharacterModelFrameBackgroundBotLeft
	local bottomRight = CharacterModelFrameBackgroundBotRight

	topLeft:SetTexture(texture..1)
	topRight:SetTexture(texture..2)
	bottomLeft:SetTexture(texture..3)
	bottomRight:SetTexture(texture..4)

	topLeft:SetDesaturated(true)
	topRight:SetDesaturated(true)
	bottomLeft:SetDesaturated(true)
	bottomRight:SetDesaturated(true)

	CharacterModelFrameBackgroundOverlay:SetAlpha(overlayAlpha)
end

function PaperDollFrame_ClearIgnoredSlots ()
	EquipmentManagerClearIgnoredSlotsForSave();
	for k, button in next, itemSlotButtons do
		if ( button.ignored ) then
			button.ignored = nil;
			PaperDollItemSlotButton_Update(button);
		end
	end
end

function PaperDollFrame_IgnoreSlotsForSet (setName)
	local set = GetEquipmentSetItemIDs(setName);
	for slot, item in ipairs(set) do
		if ( item == EQUIPMENT_SET_IGNORED_SLOT ) then
			EquipmentManagerIgnoreSlotForSave(slot);
			itemSlotButtons[slot].ignored = true;
			PaperDollItemSlotButton_Update(itemSlotButtons[slot]);
		end
	end
end

function PaperDollItemSlotButton_OnLoad (self)
	self:RegisterForDrag("LeftButton");
	self:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	local slotName = self:GetName();
	local id, textureName, checkRelic = GetInventorySlotInfo(strsub(slotName,10));
	self:SetID(id);
	local texture = _G[slotName.."IconTexture"];
	texture:SetTexture(textureName);
	self.backgroundTextureName = textureName;
	self.checkRelic = checkRelic;
	self.UpdateTooltip = PaperDollItemSlotButton_OnEnter;
	itemSlotButtons[id] = self;
	self.verticalFlyout = VERTICAL_FLYOUTS[id];

	local popoutButton = self.popoutButton;
	if ( popoutButton ) then
		if ( self.verticalFlyout ) then
			popoutButton:SetHeight(16);
			popoutButton:SetWidth(38);

			popoutButton:GetNormalTexture():SetTexCoord(0.15625, 0.84375, 0.5, 0);
			popoutButton:GetHighlightTexture():SetTexCoord(0.15625, 0.84375, 1, 0.5);
			popoutButton:ClearAllPoints();
			popoutButton:SetPoint("TOP", self, "BOTTOM", 0, 4);
		else
			popoutButton:SetHeight(38);
			popoutButton:SetWidth(16);

			popoutButton:GetNormalTexture():SetTexCoord(0.15625, 0.5, 0.84375, 0.5, 0.15625, 0, 0.84375, 0);
			popoutButton:GetHighlightTexture():SetTexCoord(0.15625, 1, 0.84375, 1, 0.15625, 0.5, 0.84375, 0.5);
			popoutButton:ClearAllPoints();
			popoutButton:SetPoint("LEFT", self, "RIGHT", -8, 0);
		end
	end

	PaperDollItemSlotButton_Update(self)
end

function PaperDollItemSlotButton_OnShow (self)
	self:RegisterEvent("UNIT_INVENTORY_CHANGED");
	self:RegisterEvent("MERCHANT_UPDATE");
	self:RegisterEvent("PLAYERBANKSLOTS_CHANGED");
	self:RegisterEvent("ITEM_LOCK_CHANGED");
	self:RegisterEvent("CURSOR_UPDATE");
	self:RegisterEvent("BAG_UPDATE_COOLDOWN");
	self:RegisterEvent("SHOW_COMPARE_TOOLTIP");
	self:RegisterEvent("UPDATE_INVENTORY_ALERTS");

	PaperDollItemSlotButton_Update(self);
end

function PaperDollItemSlotButton_OnHide (self)
	self:UnregisterEvent("UNIT_INVENTORY_CHANGED");
	self:UnregisterEvent("MERCHANT_UPDATE");
	self:UnregisterEvent("PLAYERBANKSLOTS_CHANGED");
	self:UnregisterEvent("ITEM_LOCK_CHANGED");
	self:UnregisterEvent("CURSOR_UPDATE");
	self:UnregisterEvent("BAG_UPDATE_COOLDOWN");
	self:UnregisterEvent("SHOW_COMPARE_TOOLTIP");
	self:UnregisterEvent("UPDATE_INVENTORY_ALERTS");
end

function PaperDollItemSlotButton_OnEvent (self, event, ...)
	local arg1, arg2 = ...;
	if ( event == "UNIT_INVENTORY_CHANGED" ) then
		if ( arg1 == "player" ) then
			PaperDollItemSlotButton_Update(self);
		end
	elseif ( event == "ITEM_LOCK_CHANGED" ) then
		if ( not arg2 and arg1 == self:GetID() ) then
			PaperDollItemSlotButton_UpdateLock(self);
		end
	elseif ( event == "BAG_UPDATE_COOLDOWN" ) then
		PaperDollItemSlotButton_Update(self);
	elseif ( event == "CURSOR_UPDATE" ) then
		if ( CursorCanGoInSlot(self:GetID()) ) then
			self:LockHighlight();
		else
			self:UnlockHighlight();
		end
	elseif ( event == "SHOW_COMPARE_TOOLTIP" ) then
		if ( (arg1 ~= self:GetID()) or (arg2 > NUM_SHOPPING_TOOLTIPS) ) then
			return;
		end

		local tooltip = _G["ShoppingTooltip"..arg2];
		local anchor = "ANCHOR_RIGHT";
		if ( arg2 > 1 ) then
			anchor = "ANCHOR_BOTTOMRIGHT";
		end
		tooltip:SetOwner(self, anchor);
		local hasItem, hasCooldown = tooltip:SetInventoryItem("player", self:GetID());
		if ( not hasItem ) then
			tooltip:Hide();
		end
	elseif ( event == "UPDATE_INVENTORY_ALERTS" ) then
		PaperDollItemSlotButton_Update(self);
	elseif ( event == "MODIFIER_STATE_CHANGED" ) then
		if ( IsModifiedClick("SHOWITEMFLYOUT") and self:IsMouseOver() ) then
			PaperDollItemSlotButton_OnEnter(self);
		end
	end
end

function PaperDollItemSlotButton_OnClick (self, button)
	MerchantFrame_ResetRefundItem();
	if ( button == "LeftButton" ) then
		local type = GetCursorInfo();
		if ( type == "merchant" and MerchantFrame.extendedCost ) then
			MerchantFrame_ConfirmExtendedItemCost(MerchantFrame.extendedCost);
		else
			PickupInventoryItem(self:GetID());
			if ( CursorHasItem() ) then
				MerchantFrame_SetRefundItem(self, 1);
			end
		end
	else
		local id = self:GetID();

		if ( ItemUpgradeFrame and ItemUpgradeFrame:IsShown() ) then
			local itemLocation = ItemLocation:CreateFromEquipmentSlot(id);
			if C_ItemUpgrade.CanUpgradeItem(itemLocation) then
				C_ItemUpgrade.SetItemUpgradeFromLocation(itemLocation);
			end
			return;
		end

		UseInventoryItem(id);
	end
end

function PaperDollItemSlotButton_OnModifiedClick (self, button)
	if ( HandleModifiedItemClick(GetInventoryItemLink("player", self:GetID())) ) then
		return;
	end
	if ( IsModifiedClick("SOCKETITEM") ) then
		SocketInventoryItem(self:GetID());
	end
end

function PaperDollItemSlotButton_Update (self)
	local textureName = GetInventoryItemTexture("player", self:GetID());
	local cooldown = _G[self:GetName().."Cooldown"];

	if ( textureName ) then
		local link = GetInventoryItemLink("player", self:GetID())
		local quality, originalTexture, _

		if link then
			_, _, quality, _, _, _, _, _, _, originalTexture = GetItemInfo(link)
		end

		if quality and self:GetID() < 20 then
			SetItemButtonQuality(self, quality)
		end

		SetItemButtonTexture(self, originalTexture or textureName);
		SetItemButtonCount(self, GetInventoryItemCount("player", self:GetID()));
		if ( GetInventoryItemBroken("player", self:GetID()) ) then
			SetItemButtonTextureVertexColor(self, 0.9, 0, 0);
			SetItemButtonNormalTextureVertexColor(self, 0.9, 0, 0);
		else
			SetItemButtonTextureVertexColor(self, 1.0, 1.0, 1.0);
			SetItemButtonNormalTextureVertexColor(self, 1.0, 1.0, 1.0);
		end
		if ( cooldown ) then
			local start, duration, enable = GetInventoryItemCooldown("player", self:GetID());
			CooldownFrame_SetTimer(cooldown, start, duration, enable);
		end
		self.hasItem = 1;
		self.containerID = self:GetID()
	else
		if self.IconBorder and self.IconBorder:IsShown() then
			self.IconBorder:Hide()
		end
		if ( self.checkRelic and UnitHasRelicSlot("player") ) then
			textureName = "Interface\\Paperdoll\\UI-PaperDoll-Slot-Relic";
		else
			textureName = self.backgroundTextureName;
		end
		SetItemButtonTexture(self, textureName);
		SetItemButtonCount(self, 0);
		SetItemButtonTextureVertexColor(self, 1.0, 1.0, 1.0);
		SetItemButtonNormalTextureVertexColor(self, 1.0, 1.0, 1.0);
		if ( cooldown ) then
			cooldown:Hide();
		end
		self.hasItem = nil;
	end

	if ( GearManagerDialog and not GearManagerDialog:IsShown() ) then
		self.ignored = nil;
	end

	if ( self.ignored and self.ignoreTexture ) then
		self.ignoreTexture:Show();
	elseif ( self.ignoreTexture ) then
		self.ignoreTexture:Hide();
	end

	PaperDollItemSlotButton_UpdateLock(self);

	-- Update repair all button status
	if MerchantFrame_UpdateGuildBankRepair then
		MerchantFrame_UpdateGuildBankRepair();
	end

	if MerchantFrame_UpdateCanRepairAll then
		MerchantFrame_UpdateCanRepairAll();
	end
end

function PaperDollItemSlotButton_UpdateLock (self)
	if ( IsInventoryItemLocked(self:GetID()) ) then
		--this:SetNormalTexture("Interface\\Buttons\\UI-Quickslot");
		SetItemButtonDesaturated(self, 1, 0.5, 0.5, 0.5);
	else
		--this:SetNormalTexture("Interface\\Buttons\\UI-Quickslot2");
		SetItemButtonDesaturated(self, nil);
	end
end

function PaperDollItemSlotButton_OnEnter (self)
	self:RegisterEvent("MODIFIER_STATE_CHANGED");
	EquipmentFlyout_UpdateFlyout(self);
	if ( not EquipmentFlyout_SetTooltipAnchor(self) ) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	end

	local hasItem, hasCooldown, repairCost = GameTooltip:SetInventoryItem("player", self:GetID());
	if ( not hasItem ) then
		local text = _G[strupper(strsub(self:GetName(), 10))];
		if ( self.checkRelic and UnitHasRelicSlot("player") ) then
			text = RELICSLOT;
		end
		GameTooltip:SetText(text);
	end
	if ( InRepairMode() and repairCost and (repairCost > 0) ) then
		GameTooltip:AddLine(REPAIR_COST, "", 1, 1, 1);
		SetTooltipMoney(GameTooltip, repairCost);
		GameTooltip:Show();
	else
		CursorUpdate(self);
	end
end

function PaperDollItemSlotButton_OnLeave (self)
	self:UnregisterEvent("MODIFIER_STATE_CHANGED");
	GameTooltip:Hide();
	ResetCursor();
end

function PaperDollStatTooltip (self, unit)
	if ( not self.tooltip ) then
		return;
	end
	if ( not unit ) then
		unit = "player";
	end
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:SetText(self.tooltip);
	if ( self.tooltip2 ) then
		GameTooltip:AddLine(self.tooltip2, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
	end
	GameTooltip:Show();
end

function FormatPaperDollTooltipStat(name, base, posBuff, negBuff)
	local effective = max(0,base + posBuff + negBuff);
	local text = HIGHLIGHT_FONT_COLOR_CODE..name.." "..effective;
	if ( ( posBuff == 0 ) and ( negBuff == 0 ) ) then
		text = text..FONT_COLOR_CODE_CLOSE;
	else
		if ( posBuff > 0 or negBuff < 0 ) then
			text = text.." ("..base..FONT_COLOR_CODE_CLOSE;
		end
		if ( posBuff > 0 ) then
			text = text..FONT_COLOR_CODE_CLOSE..GREEN_FONT_COLOR_CODE.."+"..posBuff..FONT_COLOR_CODE_CLOSE;
		end
		if ( negBuff < 0 ) then
			text = text..RED_FONT_COLOR_CODE.." "..negBuff..FONT_COLOR_CODE_CLOSE;
		end
		if ( posBuff > 0 or negBuff < 0 ) then
			text = text..HIGHLIGHT_FONT_COLOR_CODE..")"..FONT_COLOR_CODE_CLOSE;
		end
	end
	return text;
end

function ColorPaperDollStat(base, posBuff, negBuff)
	local stat;
	local effective = max(0,base + posBuff + negBuff);
	if ( ( posBuff == 0 ) and ( negBuff == 0 ) ) then
		stat = effective;
	else

		-- if there is a negative buff then show the main number in red, even if there are
		-- positive buffs. Otherwise show the number in green
		if ( negBuff < 0 ) then
			stat = RED_FONT_COLOR_CODE..effective..FONT_COLOR_CODE_CLOSE;
		else
			stat = GREEN_FONT_COLOR_CODE..effective..FONT_COLOR_CODE_CLOSE;
		end
	end
	return stat;
end

function PaperDollFormatStat(name, base, posBuff, negBuff, frame, textString)
	local effective = max(0,base + posBuff + negBuff);
	local text = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT,name).." "..effective;
	if ( ( posBuff == 0 ) and ( negBuff == 0 ) ) then
		text = text..FONT_COLOR_CODE_CLOSE;
		textString:SetText(effective);
	else
		if ( posBuff > 0 or negBuff < 0 ) then
			text = text.." ("..base..FONT_COLOR_CODE_CLOSE;
		end
		if ( posBuff > 0 ) then
			text = text..FONT_COLOR_CODE_CLOSE..GREEN_FONT_COLOR_CODE.."+"..posBuff..FONT_COLOR_CODE_CLOSE;
		end
		if ( negBuff < 0 ) then
			text = text..RED_FONT_COLOR_CODE.." "..negBuff..FONT_COLOR_CODE_CLOSE;
		end
		if ( posBuff > 0 or negBuff < 0 ) then
			text = text..HIGHLIGHT_FONT_COLOR_CODE..")"..FONT_COLOR_CODE_CLOSE;
		end

		-- if there is a negative buff then show the main number in red, even if there are
		-- positive buffs. Otherwise show the number in green
		if ( negBuff < 0 ) then
			textString:SetText(RED_FONT_COLOR_CODE..effective..FONT_COLOR_CODE_CLOSE);
		else
			textString:SetText(GREEN_FONT_COLOR_CODE..effective..FONT_COLOR_CODE_CLOSE);
		end
	end
	frame.tooltip = text;
end

function CharacterAttackFrame_OnEnter (self)
	-- Main hand weapon
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:SetText(INVTYPE_WEAPONMAINHAND, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	GameTooltip:AddLine(self.weaponSkill);
	GameTooltip:AddLine(self.weaponRating);
	-- Check for offhand weapon
	if ( self.offhandSkill ) then
		GameTooltip:AddLine("\n");
		GameTooltip:AddLine(INVTYPE_WEAPONOFFHAND, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
		GameTooltip:AddLine(self.offhandSkill);
		GameTooltip:AddLine(self.offhandRating);
	end
	GameTooltip:Show();
end

function CharacterDamageFrame_OnEnter (self)
	-- Main hand weapon
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	if ( self == PetDamageFrame ) then
		GameTooltip:SetText(INVTYPE_WEAPONMAINHAND_PET, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	else
		GameTooltip:SetText(INVTYPE_WEAPONMAINHAND, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	end
	GameTooltip:AddDoubleLine(format(STAT_FORMAT, ATTACK_SPEED_SECONDS), format("%.2f", self.attackSpeed), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	GameTooltip:AddDoubleLine(format(STAT_FORMAT, DAMAGE), self.damage, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	GameTooltip:AddDoubleLine(format(STAT_FORMAT, DAMAGE_PER_SECOND), format("%.1f", self.dps), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	-- Check for offhand weapon
	if ( self.offhandAttackSpeed ) then
		GameTooltip:AddLine("\n");
		GameTooltip:AddLine(INVTYPE_WEAPONOFFHAND, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
		GameTooltip:AddDoubleLine(format(STAT_FORMAT, ATTACK_SPEED_SECONDS), format("%.2f", self.offhandAttackSpeed), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
		GameTooltip:AddDoubleLine(format(STAT_FORMAT, DAMAGE), self.offhandDamage, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
		GameTooltip:AddDoubleLine(format(STAT_FORMAT, DAMAGE_PER_SECOND), format("%.1f", self.offhandDps), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	end
	GameTooltip:Show();
end

function CharacterRangedDamageFrame_OnEnter (self)
	if ( not self.damage ) then
		return;
	end
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:SetText(INVTYPE_RANGED, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	GameTooltip:AddDoubleLine(format(STAT_FORMAT, ATTACK_SPEED_SECONDS), format("%.2f", self.attackSpeed), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	GameTooltip:AddDoubleLine(format(STAT_FORMAT, DAMAGE), self.damage, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	GameTooltip:AddDoubleLine(format(STAT_FORMAT, DAMAGE_PER_SECOND), format("%.1f", self.dps), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	GameTooltip:Show();
end

function PaperDollFrame_GetArmorReduction(armor, attackerLevel)
	local levelModifier = attackerLevel;
	if ( levelModifier > 59 ) then
		levelModifier = levelModifier + (4.5 * (levelModifier-59));
	end
	local temp = 0.1*armor/(8.5*levelModifier + 40);
	temp = temp/(1+temp);

	if ( temp > 0.75 ) then
		return 75;
	end

	if ( temp < 0 ) then
		return 0;
	end

	return temp*100;
end

-- Paperdoll stat selection functions
function PlayerStatFrameLeftDropDown_OnLoad (self)
	RaiseFrameLevel(self);
	UIDropDownMenu_Initialize(self, PlayerStatFrameLeftDropDown_Initialize);
	UIDropDownMenu_SetSelectedValue(self, GetCVar("playerStatLeftDropdown"));
	UIDropDownMenu_SetWidth(self, 99);
	UIDropDownMenu_JustifyText(self, "LEFT");
end

function PlayerStatFrameLeftDropDown_OnShow (self)
	UIDropDownMenu_Initialize(self, PlayerStatFrameLeftDropDown_Initialize);
	UIDropDownMenu_SetSelectedValue(self, GetCVar("playerStatLeftDropdown"));
end

function PlayerStatFrameLeftDropDown_Initialize (self)
	-- Setup buttons
	local info = UIDropDownMenu_CreateInfo();
	local checked;
	for i=1, getn(PLAYERSTAT_DROPDOWN_OPTIONS) do
		if ( PLAYERSTAT_DROPDOWN_OPTIONS[i] == GetCVar("playerStatLeftDropdown") ) then
			checked = 1;
		else
			checked = nil;
		end
		info.text = _G[PLAYERSTAT_DROPDOWN_OPTIONS[i]];
		info.func = PlayerStatFrameLeftDropDown_OnClick;
		info.value = PLAYERSTAT_DROPDOWN_OPTIONS[i];
		info.checked = checked;
		info.owner = UIDROPDOWNMENU_OPEN_MENU;
		UIDropDownMenu_AddButton(info);
	end
end

function PlayerStatFrameLeftDropDown_OnClick (self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	SetCVar("playerStatLeftDropdown", self.value);
	UpdatePaperdollStats("PlayerStatFrameLeft", self.value);
end

function PlayerStatFrameRightDropDown_OnLoad (self)
	UIDropDownMenu_Initialize(self, PlayerStatFrameRightDropDown_Initialize);
	UIDropDownMenu_SetSelectedValue(self, GetCVar("playerStatRightDropdown"));
	UIDropDownMenu_SetWidth(self, 99);
	UIDropDownMenu_JustifyText(self, "LEFT");
end

function PlayerStatFrameRightDropDown_OnShow (self)
	UIDropDownMenu_Initialize(self, PlayerStatFrameRightDropDown_Initialize);
	UIDropDownMenu_SetSelectedValue(self, GetCVar("playerStatRightDropdown"));
end

function PlayerStatFrameRightDropDown_Initialize (self)
	-- Setup buttons
	local info = UIDropDownMenu_CreateInfo();
	local checked;
	for i=1, getn(PLAYERSTAT_DROPDOWN_OPTIONS) do
		if ( PLAYERSTAT_DROPDOWN_OPTIONS[i] == GetCVar("playerStatRightDropdown") ) then
			checked = 1;
		else
			checked = nil;
		end
		info.text = _G[PLAYERSTAT_DROPDOWN_OPTIONS[i]];
		info.func = PlayerStatFrameRightDropDown_OnClick;
		info.value = PLAYERSTAT_DROPDOWN_OPTIONS[i];
		info.checked = checked;
		info.owner = UIDROPDOWNMENU_OPEN_MENU;
		UIDropDownMenu_AddButton(info);
	end
end

function PlayerStatFrameRightDropDown_OnClick (self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	SetCVar("playerStatRightDropdown", self.value);
	UpdatePaperdollStats("PlayerStatFrameRight", self.value);
end

function PaperDollFrame_UpdateStats()
	UpdatePaperdollStats("PlayerStatFrameLeft", GetCVar("playerStatLeftDropdown"));
	UpdatePaperdollStats("PlayerStatFrameRight", GetCVar("playerStatRightDropdown"));
end

function PaperDollFrame_SetLabelAndText(statFrame, label, text, isPercentage)
	_G[statFrame:GetName().."Label"]:SetText(format(STAT_FORMAT, label));
	if ( isPercentage ) then
		text = format("%.2f%%", text);
	end
	_G[statFrame:GetName().."StatText"]:SetText(text);
end

function UpdatePaperdollStats(prefix, index)
	local stat1 = _G[prefix..1];
	local stat2 = _G[prefix..2];
	local stat3 = _G[prefix..3];
	local stat4 = _G[prefix..4];
	local stat5 = _G[prefix..5];
	local stat6 = _G[prefix..6];

	-- reset any OnEnter scripts that may have been changed
	stat1:SetScript("OnEnter", PaperDollStatTooltip);
	stat2:SetScript("OnEnter", PaperDollStatTooltip);
	stat4:SetScript("OnEnter", PaperDollStatTooltip);

	stat6:Show();

	if ( index == "PLAYERSTAT_BASE_STATS" ) then
		PaperDollFrame_SetStat(stat1, 1);
		PaperDollFrame_SetStat(stat2, 2);
		PaperDollFrame_SetStat(stat3, 3);
		PaperDollFrame_SetStat(stat4, 4);
		PaperDollFrame_SetStat(stat5, 5);
		PaperDollFrame_SetArmor(stat6);
	elseif ( index == "PLAYERSTAT_MELEE_COMBAT" ) then
		PaperDollFrame_SetDamage(stat1);
		stat1:SetScript("OnEnter", CharacterDamageFrame_OnEnter);
		PaperDollFrame_SetAttackSpeed(stat2);
		PaperDollFrame_SetAttackPower(stat3);
		PaperDollFrame_SetRating(stat4, CR_HIT_MELEE);
		PaperDollFrame_SetMeleeCritChance(stat5);
		PaperDollFrame_SetExpertise(stat6);
	elseif ( index == "PLAYERSTAT_RANGED_COMBAT" ) then
		PaperDollFrame_SetRangedDamage(stat1);
		stat1:SetScript("OnEnter", CharacterRangedDamageFrame_OnEnter);
		PaperDollFrame_SetRangedAttackSpeed(stat2);
		PaperDollFrame_SetRangedAttackPower(stat3);
		PaperDollFrame_SetRating(stat4, CR_HIT_RANGED);
		PaperDollFrame_SetRangedCritChance(stat5);
		stat6:Hide();
	elseif ( index == "PLAYERSTAT_SPELL_COMBAT" ) then
		PaperDollFrame_SetSpellBonusDamage(stat1);
		stat1:SetScript("OnEnter", CharacterSpellBonusDamage_OnEnter);
		PaperDollFrame_SetSpellBonusHealing(stat2);
		PaperDollFrame_SetRating(stat3, CR_HIT_SPELL);
		PaperDollFrame_SetSpellCritChance(stat4);
		stat4:SetScript("OnEnter", CharacterSpellCritChance_OnEnter);
		PaperDollFrame_SetSpellHaste(stat5);
		PaperDollFrame_SetManaRegen(stat6);
	elseif ( index == "PLAYERSTAT_DEFENSES" ) then
		PaperDollFrame_SetArmor(stat1);
		PaperDollFrame_SetDefense(stat2);
		PaperDollFrame_SetDodge(stat3);
		PaperDollFrame_SetParry(stat4);
		PaperDollFrame_SetBlock(stat5);
		PaperDollFrame_SetResilience(stat6);
	end
end

function ComputePetBonus(stat, value)
	local temp, unitClass = UnitClass("player");
	unitClass = strupper(unitClass);
	if( unitClass == "WARLOCK" ) then
		if( WARLOCK_PET_BONUS[stat] ) then
			return value * WARLOCK_PET_BONUS[stat];
		else
			return 0;
		end
	elseif( unitClass == "HUNTER" ) then
		if( HUNTER_PET_BONUS[stat] ) then
			return value * HUNTER_PET_BONUS[stat];
		else
			return 0;
		end
	end

	return 0;
end

function PaperDollFrameItemFlyoutButton_OnClick(self)
	if ( self.location == EQUIPMENTFLYOUT_IGNORESLOT_LOCATION ) then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
		local slot = EquipmentFlyoutFrame.button;
		EquipmentManagerIgnoreSlotForSave(slot:GetID());
		slot.ignored = true;
		PaperDollItemSlotButton_Update(slot);
		EquipmentFlyout_Show(slot);
		GearManagerDialog.SaveSet:Enable();
	elseif ( self.location == EQUIPMENTFLYOUT_UNIGNORESLOT_LOCATION ) then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
		local slot = EquipmentFlyoutFrame.button;
		EquipmentManagerUnignoreSlotForSave(slot:GetID());
		slot.ignored = nil;
		PaperDollItemSlotButton_Update(slot);
		EquipmentFlyout_Show(slot);
		GearManagerDialog.SaveSet:Enable();
	elseif ( self.location == EQUIPMENTFLYOUT_PLACEINBAGS_LOCATION ) then
		if ( UnitAffectingCombat("player") and not INVSLOTS_EQUIPABLE_IN_COMBAT[EquipmentFlyoutFrame.button:GetID()] ) then
			UIErrorsFrame:AddMessage(ERR_CLIENT_LOCKED_OUT, 1.0, 0.1, 0.1, 1.0);
			return;
		end
		local action = EquipmentManager_UnequipItemInSlot(EquipmentFlyoutFrame.button:GetID());
		EquipmentManager_RunAction(action);
	elseif ( self.location ) then
		if ( UnitAffectingCombat("player") and not INVSLOTS_EQUIPABLE_IN_COMBAT[EquipmentFlyoutFrame.button:GetID()] ) then
			UIErrorsFrame:AddMessage(ERR_CLIENT_LOCKED_OUT, 1.0, 0.1, 0.1, 1.0);
			return;
		end
		local action = EquipmentManager_EquipItemByLocation(self.location, self.id);
		EquipmentManager_RunAction(action);
	end
end

function PaperDollFrameItemFlyout_GetItems(paperDollItemSlot, itemTable)
	GetInventoryItemsForSlot(paperDollItemSlot, itemTable);
end

function PaperDollFrameItemFlyout_PostGetItems(itemSlotButton, itemDisplayTable, numItems)
	if GearManagerDialog:IsShown() then
		if not itemSlotButton.ignored then
			tinsert(itemDisplayTable, 1, EQUIPMENTFLYOUT_IGNORESLOT_LOCATION);
		else
			tinsert(itemDisplayTable, 1, EQUIPMENTFLYOUT_UNIGNORESLOT_LOCATION);
		end
		numItems = numItems + 1;
	end

	if GetInventoryItemTexture("player", itemSlotButton:GetID()) ~= nil then
		tinsert(itemDisplayTable, 1, EQUIPMENTFLYOUT_PLACEINBAGS_LOCATION);
		numItems = numItems + 1;
	end
	return numItems;
end

NUM_GEARSETS_PER_ROW = 5;

function GearManagerDialog_OnLoad (self)
	self.title:SetText(EQUIPMENT_MANAGER);
	self.buttons = {};
	local name = self:GetName();
	local button;
	for i = 1, MAX_EQUIPMENT_SETS_PER_PLAYER do
		button = CreateFrame("CheckButton", "GearSetButton" .. i, self, "GearSetButtonTemplate");
		if ( i == 1 ) then
			button:SetPoint("TOPLEFT", self, "TOPLEFT", 16, -32);
		elseif ( mod(i, NUM_GEARSETS_PER_ROW) == 1 ) then
			button:SetPoint("TOP", "GearSetButton"..(i-NUM_GEARSETS_PER_ROW), "BOTTOM", 0, -10);
		else
			button:SetPoint("LEFT", "GearSetButton"..(i-1), "RIGHT", 13, 0);
		end
		button.icon = _G["GearSetButton" .. i .. "Icon"];
		button.text = _G["GearSetButton" .. i .. "Name"];
		tinsert(self.buttons, button);
	end
	self:RegisterEvent("VARIABLES_LOADED");
	self:RegisterEvent("EQUIPMENT_SWAP_FINISHED");
end

function GearManagerDialog_OnShow (self)
	CharacterFrame:SetAttribute("UIPanelLayout-defined", nil);
	GearManagerToggleButton:SetButtonState("PUSHED", 1);
	GearManagerDialog_Update();
	self:RegisterEvent("EQUIPMENT_SETS_CHANGED");
	EquipmentManagerClearIgnoredSlotsForSave();
	PlaySound("igBackPackOpen");

	EquipmentFlyoutPopoutButton_ShowAll();

	UpdateUIPanelPositions(CharacterFrame);
	GearManagerDialog:Raise();
end

function GearManagerDialog_OnHide (self)
	CharacterFrame:SetAttribute("UIPanelLayout-defined", nil);
	GearManagerDialogPopup:Hide();

	GearManagerToggleButton:SetButtonState("NORMAL");
	self:UnregisterEvent("EQUIPMENT_SETS_CHANGED");
	PlaySound("igBackPackClose");
	PaperDollFrame_ClearIgnoredSlots();

	EquipmentFlyoutPopoutButton_HideAll();

	UpdateUIPanelPositions();
end

function GearManagerDialog_OnEvent (self, event, ...)
	if ( event == "EQUIPMENT_SETS_CHANGED" ) then
		GearManagerDialog_Update();
	elseif ( event == "VARIABLES_LOADED" ) then
		if ( GetCVarBool("equipmentManager") ) then
			GearManagerToggleButton:Show();
		end
	elseif ( event == "EQUIPMENT_SWAP_FINISHED" ) then
		local completed, setName = ...;
		if ( completed ) then
			self.selectedSetName = setName;
			GearManagerDialog_Update();
			if ( self:IsShown() ) then
				PaperDollFrame_ClearIgnoredSlots();
				PaperDollFrame_IgnoreSlotsForSet(setName);
			end
		end
	end
end

function GearManagerDialog_Update ()
	local numSets = GetNumEquipmentSets();

	local dialog = GearManagerDialog;
	local buttons = dialog.buttons;

	local selectedName = dialog.selectedSetName;
	local name, texture, button;
	dialog.selectedSet = nil;
	for i = 1, numSets do
		name, texture = GetEquipmentSetInfo(i);
		button = buttons[i];
		button:Enable();
		button.name = name;
		button.text:SetText(name);
		if (texture) then
			button.icon:SetTexture(texture);
		else
			button.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");
		end
		if (selectedName and button.name == selectedName) then
			button:SetChecked(true);
			dialog.selectedSet = button;
		else
			button:SetChecked(false);
		end
	end
	if ( dialog.selectedSet ) then
		GearManagerDialogDeleteSet:Enable();
		GearManagerDialogEquipSet:Enable();
	else
		GearManagerDialogDeleteSet:Disable();
		GearManagerDialogEquipSet:Disable();
	end

	for i = numSets + 1, MAX_EQUIPMENT_SETS_PER_PLAYER do
		button = buttons[i];
		button:Disable();
		button:SetChecked(false);
		button.name = nil;
		button.text:SetText("");
		button.icon:SetTexture("");
	end
	if(GearManagerDialogPopup:IsShown()) then
		RecalculateGearManagerDialogPopup();		--Scroll so that the texture appears and Save is enabled
	end
end

function GearManagerDialogDeleteSet_OnClick (self)
	local selectedSet = GearManagerDialog.selectedSet;
	if ( selectedSet ) then
		local dialog = StaticPopup_Show("CONFIRM_DELETE_EQUIPMENT_SET", selectedSet.name);
		if ( dialog ) then
			dialog.data = selectedSet.name;
		else
			UIErrorsFrame:AddMessage(ERR_CLIENT_LOCKED_OUT, 1.0, 0.1, 0.1, 1.0);
		end
	end
end

function GearManagerDialogSaveSet_OnClick (self)
	local popup = GearManagerDialogPopup;
	local wasShown = popup:IsShown();
	popup:Show();
	if ( wasShown ) then	--If the dialog was already shown, the OnShow script will not run and the icon will not be updated (Bug 169523)
		GearManagerDialogPopup_Update();
	end
end

function GearManagerDialogEquipSet_OnClick (self)
	local selectedSet = GearManagerDialog.selectedSet;
	if ( selectedSet ) then
		local name = selectedSet.name;
		if ( name and name ~= "" ) then
			PlaySound("igCharacterInfoTab");			-- inappropriately named, but a good sound.
			EquipmentManager_EquipSet(name);
		end
	end
end

function GearSetButton_OnClick (self)
	--[[
	Select the new gear set
	]]
	if ( self.name and self.name ~= "" ) then
		PlaySound("igMainMenuOptionCheckBoxOn");		-- inappropriately named, but a good sound.
		local dialog = GearManagerDialog;
		dialog.selectedSetName = self.name;
		GearManagerDialog_Update();						--change selection, enable one equip button, disable rest.
	else
		self:SetChecked(false);
	end
end

function GearSetButton_OnEnter (self)
	if ( self.name and self.name ~= "" ) then
		GameTooltip_SetDefaultAnchor(GameTooltip, self);
		GameTooltip:SetEquipmentSet(self.name);
	end
end

NUM_GEARSET_ICONS_SHOWN = 20;
NUM_GEARSET_ICONS_PER_ROW = 5;
NUM_GEARSET_ICON_ROWS = 4;
GEARSET_ICON_ROW_HEIGHT = 36;

function GearManagerDialogPopup_OnLoad (self)
	self.buttons = {};
	self.searchResult = {};

	local rows = 0;

	local button = CreateFrame("CheckButton", "GearManagerDialogPopupButton1", GearManagerDialogPopup, "GearSetPopupButtonTemplate");
	button:SetPoint("TOPLEFT", 24, -95);
	button:SetID(1);
	tinsert(self.buttons, button);

	local lastPos;
	for i = 2, NUM_GEARSET_ICONS_SHOWN do
		button = CreateFrame("CheckButton", "GearManagerDialogPopupButton" .. i, GearManagerDialogPopup, "GearSetPopupButtonTemplate");
		button:SetID(i);

		lastPos = (i - 1) / NUM_GEARSET_ICONS_PER_ROW;
		if ( lastPos == math.floor(lastPos) ) then
			button:SetPoint("TOPLEFT", self.buttons[i-NUM_GEARSET_ICONS_PER_ROW], "BOTTOMLEFT", 0, -8);
		else
			button:SetPoint("TOPLEFT", self.buttons[i-1], "TOPRIGHT", 10, 0);
		end
		tinsert(self.buttons, button);
	end

	self.SetSelection = function(self, fTexture, Value)
		if(fTexture) then
			self.selectedTexture = Value;
			self.selectedIcon = nil;
		else
			self.selectedTexture = nil;
			self.selectedIcon = Value;
		end
	end
end

local _equippedItems = {};
local _numItems;
local _specialIcon;
local _TotalItems;

function GearManagerDialogPopup_OnShow (self)
	PlaySound("igCharacterInfoOpen");
	RecalculateGearManagerDialogPopup();
	GearManagerDialogSaveSet:Disable();
end

function GearManagerDialogPopup_OnHide (self)
	local popup = GearManagerDialogPopup;
	popup.name = nil;
	popup:SetSelection(true, nil);
	GearManagerDialogPopupEditBox:SetText("");
	GearManagerDialogSaveSet:Enable();
end

function RecalculateGearManagerDialogPopup()
	local popup = GearManagerDialogPopup;
	local selectedSet = GearManagerDialog.selectedSet;
	if ( selectedSet ) then
		popup:SetSelection(true, selectedSet.icon:GetTexture());
		local editBox = GearManagerDialogPopupEditBox;
		editBox:SetText(selectedSet.name);
		editBox:HighlightText(0);
	end
	--[[
	Scroll and ensure that any selected equipment shows up in the list.
	When we first press "save", we want to make sure any selected equipment set shows up in the list, so that
	the user can just make his changes and press Okay to overwrite.
	To do this, we need to find the current set (by icon) and move the offset of the GearManagerDialogPopup
	to display it. Issue ID: 171220
	]]
	RefreshEquipmentSetIconInfo();
	_TotalItems = GetNumMacroIcons() + _numItems;
	_specialIcon = nil;

	GearManagerDialogPopup_SearchUpdate();

	local texture, _;
	if(popup.selectedTexture) then
		local index = 1;
		local foundIndex = nil;
		for index=1, _TotalItems do
			texture, _ = GetEquipmentSetIconInfo(index);
			if ( texture == popup.selectedTexture ) then
				foundIndex = index;
				break;
			end
		end
		if (foundIndex == nil) then
			_specialIcon = popup.selectedTexture;
			_TotalItems = _TotalItems + 1;
			foundIndex = _TotalItems;
		else
			_specialIcon = nil;
		end
		-- now make it so we always display at least NUM_GEARSET_ICON_ROWS of data
		local offsetnumIcons = floor((_TotalItems-1)/NUM_GEARSET_ICONS_PER_ROW);
		local offset = floor((foundIndex-1) / NUM_GEARSET_ICONS_PER_ROW);
		offset = offset + min((NUM_GEARSET_ICON_ROWS-1), offsetnumIcons-offset) - (NUM_GEARSET_ICON_ROWS-1);
		if(foundIndex<=NUM_GEARSET_ICONS_SHOWN) then
			offset = 0;			--Equipment all shows at the same place.
		end
		FauxScrollFrame_OnVerticalScroll(GearManagerDialogPopupScrollFrame, offset*GEARSET_ICON_ROW_HEIGHT, GEARSET_ICON_ROW_HEIGHT, nil);
	end
	GearManagerDialogPopup_Update();
end

--[[
RefreshEquipmentSetIconInfo() counts how many uniquely textured inventory items the player has equipped.
]]
function RefreshEquipmentSetIconInfo ()
	_numItems = 0;
	for i = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
		_equippedItems[i] = GetInventoryItemTexture("player", i);
		if(_equippedItems[i]) then
			_numItems = _numItems + 1;
			--[[
			Currently checks all for duplicates, even though only rings, trinkets, and weapons may be duplicated.
			This version is clean and maintainable.
			]]
			for j=INVSLOT_FIRST_EQUIPPED, (i-1) do
				if(_equippedItems[i] == _equippedItems[j]) then
					_equippedItems[i] = nil;
					_numItems = _numItems - 1;
					break;
				end
			end
		end
	end
end


--[[
GetEquipmentSetIconInfo(index) determines the texture and real index of a regular index
	Input: 	index = index into a list of equipped items follows by the macro items. Only tricky part is the equipped items list keeps changing.
	Output: the associated texture for the item, and a index relative to the join point between the lists, i.e. negative for the equipped items
			and positive from the equipped items for the macro items//
]]
function GetEquipmentSetIconInfo(index)
	for i = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
		if (_equippedItems[i]) then
			index = index - 1;
			if ( index == 0 ) then
				return _equippedItems[i], -i;
			end
		end
	end
	if(index>GetNumMacroIcons()) then
		return _specialIcon, index;
	end
	return GetMacroIconInfo(index), index;
end

function GearManagerDialogPopup_SearchUpdate()
	local popup = GearManagerDialogPopup;
	local searchText = string.lower(popup.BorderBox.SearchBox:GetText() or "");
	if searchText == "" then
		popup.hasSearchResults = false;
	else
		table.wipe(popup.searchResult);

		for index = 1, _TotalItems do
			local texture = GetEquipmentSetIconInfo(index);
			if texture and string.find(string.lower(texture), searchText, 1, true) then
				popup.searchResult[#popup.searchResult + 1] = index;
			end
		end

		popup.hasSearchResults = true;
	end
end

function GearManagerDialogPopup_Update ()
	RefreshEquipmentSetIconInfo();

	local popup = GearManagerDialogPopup;
	local searchResults = popup.searchResult;
	local hasSearchResults = popup.hasSearchResults;
	local totalItems = hasSearchResults and #searchResults or _TotalItems;
	local buttons = popup.buttons;
	local offset = FauxScrollFrame_GetOffset(GearManagerDialogPopupScrollFrame) or 0;
	local button;
	-- Icon list
	local texture, index, textureIndex, realIndex, _;
	for i=1, NUM_GEARSET_ICONS_SHOWN do
		button = buttons[i];
		index = (offset * NUM_GEARSET_ICONS_PER_ROW) + i;
		textureIndex = hasSearchResults and (searchResults[index] or 0) or index;
		if ( index <= totalItems ) then
			texture, _ = GetEquipmentSetIconInfo(textureIndex);
			-- button.name:SetText(index); --dcw
			button.icon:SetTexture(texture);
			button.index = textureIndex;
			button:Show();
			if ( textureIndex == popup.selectedIcon ) then
				button:SetChecked(1);
			elseif ( texture == popup.selectedTexture ) then
				button:SetChecked(1);
				popup:SetSelection(false, textureIndex);
			else
				button:SetChecked(nil);
			end
		else
			button.icon:SetTexture("");
			button:Hide();
		end

	end

	-- Scrollbar stuff
	FauxScrollFrame_Update(GearManagerDialogPopupScrollFrame, ceil(totalItems / NUM_GEARSET_ICONS_PER_ROW) , NUM_GEARSET_ICON_ROWS, GEARSET_ICON_ROW_HEIGHT );
end

function GearManagerDialogPopupOkay_Update ()
	local popup = GearManagerDialogPopup;
	local button = GearManagerDialogPopupOkay;

	if ( popup.selectedIcon and popup.name ) then
		button:Enable();
	else
		button:Disable();
	end
end

function GearManagerDialogPopupOkay_OnClick (self, button, pushed)
	local popup = GearManagerDialogPopup;

	local _, iconIndex = GetEquipmentSetIconInfo(popup.selectedIcon);

	if ( GetEquipmentSetInfoByName(popup.name) ) then
		local dialog = StaticPopup_Show("CONFIRM_OVERWRITE_EQUIPMENT_SET", popup.name);
		if ( dialog ) then
			dialog.data = popup.name;
			dialog.selectedIcon = iconIndex;
		else
			UIErrorsFrame:AddMessage(ERR_CLIENT_LOCKED_OUT, 1.0, 0.1, 0.1, 1.0);
		end
		return;
	elseif ( GetNumEquipmentSets() >= MAX_EQUIPMENT_SETS_PER_PLAYER ) then
		UIErrorsFrame:AddMessage(EQUIPMENT_SETS_TOO_MANY, 1.0, 0.1, 0.1, 1.0);
		return
	end

	SaveEquipmentSet(popup.name, iconIndex);
	GearManagerDialogPopup:Hide();
end

function GearManagerDialogPopupCancel_OnClick ()
	GearManagerDialogPopup:Hide();
end

function GearSetPopupButton_OnClick (self, button)
	local popup = GearManagerDialogPopup;
	popup.selectedIcon = self.index;
 	popup.selectedTexture = nil;
	GearManagerDialogPopup_Update();
	GearManagerDialogPopupOkay_Update();
end

function PlayerTitlePickerScrollFrame_OnLoad(self)
	PlayerTitlePickerFrame:SetFrameLevel(self:GetParent():GetFrameLevel() + 2);
	-- PlayerTitlePickerScrollFrame:SetHeight(PLAYER_DISPLAYED_TITLES * PLAYER_TITLE_HEIGHT);
	HybridScrollFrame_OnLoad(self);
	self.update = PlayerTitlePickerScrollFrame_Update;
	HybridScrollFrame_CreateButtons(self, "PlayerTitleButtonTemplate");
end

function PlayerTitlePickerScrollFrame_Update()
	local buttons = PlayerTitlePickerScrollFrame.buttons;
	local playerTitles = PlayerTitleFrame.titles;
	local numButtons = #buttons;
	local scrollOffset = HybridScrollFrame_GetOffset(PlayerTitlePickerScrollFrame);
	local playerTitle;
	for i = 1, numButtons do
		playerTitle = playerTitles[i + scrollOffset];
		if ( playerTitle ) then
			buttons[i]:Show();
			buttons[i].text:SetText(playerTitle.name);
			buttons[i].titleId = playerTitle.id;
			if ( PlayerTitleFrame.selected == playerTitle.id ) then
				buttons[i].Check:Show();
				buttons[i].SelectedBar:Show();
			else
				buttons[i].Check:Hide();
				buttons[i].SelectedBar:Hide();
			end
			if ((i+scrollOffset)%2 == 0) then
				buttons[i].Stripe:Show();
			else
				buttons[i].Stripe:Hide();
			end
		else
			buttons[i]:Hide();
		end
	end
end

local function PlayerTitleSort(a, b) return a.name < b.name; end


function PlayerTitleFrame_UpdateTitles()
	local playerTitles = { };
	local currentTitle = GetCurrentTitle();
	local titleCount = 1;
	local buttons = PlayerTitlePickerScrollFrame.buttons;
	local fontstringText = buttons[1].text;
	local fontstringWidth;
	local playerTitle = false;
	local tempName = 0;
	PlayerTitleFrame.selected = -1;
	playerTitles[1] = { };
	-- reserving space for None so it doesn't get sorted out of the top position
	playerTitles[1].name = "       ";
	playerTitles[1].id = -1;
	for i = 1, GetNumTitles() do
		if ( IsTitleKnown(i) ~= 0 ) then
			titleCount = titleCount + 1;
			playerTitles[titleCount] = playerTitles[titleCount] or { };
			playerTitles[titleCount].name = strtrim(GetTitleName(i));
			playerTitles[titleCount].id = i;
			if ( i == currentTitle ) then
				PlayerTitleFrame.selected = i;
			end
			fontstringText:SetText(playerTitles[titleCount].name);
		end
	end

	if ( titleCount < 2 ) then
		PlayerTitleFrame:Hide();
		PlayerTitlePickerFrame:Hide();
		PaperDollSidebarTab1:Disable()
		PaperDollSidebarTab1.Icon:SetDesaturated(true)
	else
		PaperDollSidebarTab1:Enable()
		PaperDollSidebarTab1.Icon:SetDesaturated(false)
	end

	table.sort(playerTitles, PlayerTitleSort);
	playerTitles[1].name = PAPERDOLLFRAME_NO_TITLE;
	PlayerTitleFrame.titles = playerTitles;

	HybridScrollFrame_Update(PlayerTitlePickerScrollFrame, titleCount * 22, PlayerTitlePickerScrollFrame:GetHeight());
	PlayerTitlePickerScrollFrame_Update();
end

function PlayerTitlePickerFrame_Toggle()
	if ( PlayerTitlePickerFrame:IsShown() ) then
		PlaySound("igMainMenuOptionCheckBoxOff");
		PlayerTitlePickerFrame:Hide();

		if PaperDollFrame.isDisabledStrengthenFrame then
			PaperDollFrame.NewPanel.Stats:Show();
		else
			PaperDollFrameStrengthenFrame:Show();
		end

		PaperDollSidebarTab1.Hider:Show()
		PaperDollSidebarTab1.Highlights:Show()
		PaperDollSidebarTab1.TabBg:SetTexCoord(0.01562500, 0.79687500, 0.61328125, 0.78125000)
	else
		PlaySound("igMainMenuOptionCheckBoxOn");
		PlayerTitlePickerFrame:Show();

		if PaperDollFrame.isDisabledStrengthenFrame then
			PaperDollFrame.NewPanel.Stats:Hide();
		else
			PaperDollFrameStrengthenFrame:Hide();
		end

		PlayerTitlePickerScrollFrame_Update();
		PaperDollSidebarTab1.Hider:Hide()
		PaperDollSidebarTab1.Highlights:Hide()
		PaperDollSidebarTab1.TabBg:SetTexCoord(0.01562500, 0.79687500, 0.78906250, 0.95703125)
	end
end

function PlayerTitleButton_OnClick(self)
	PlaySound("igMainMenuOptionCheckBoxOff");
	PlayerTitleFrame.selected = self.titleId;
	SetCurrentTitle(self.titleId);
	PlayerTitleFrameText:SetText(self.text:GetText());
	PlayerTitlePickerFrame:Hide();

	if PaperDollFrame.isDisabledStrengthenFrame then
		PaperDollFrame.NewPanel.Stats:Show();
	else
		PaperDollFrameStrengthenFrame:Show();
	end

	PaperDollSidebarTab1.Hider:Show()
	PaperDollSidebarTab1.Highlights:Show()
	PaperDollSidebarTab1.TabBg:SetTexCoord(0.01562500, 0.79687500, 0.61328125, 0.78125000)
end

function SetTitleByName(name)
	name = strlower(name);
	for i = 1, GetNumTitles() do
		if ( IsTitleKnown(i) ~= 0 ) then
			local title = strlower(strtrim(GetTitleName(i)));
			if(title:find(name) == 1) then
				SetCurrentTitle(i);
				return true;
			end
		end
	end
	return false;
end

function InspectTransmogTooltipAddLine( self, ... )
	local unit = InspectFrame.unit
	local link = GetInventoryItemLink(unit, self:GetID())
	local ids = GetInventoryItemID(unit, self:GetID())
	if link and ids then
		local name, links = GetItemInfo(link)
		local tname, tlinks = GetItemInfo(ids)
		if links and tlinks then
			if string.match(links, "item:(%d+)") ~= string.match(tlinks, "item:(%d+)") then
				GameTooltip:SetTransmogrifyItem(ids)
			end
		end
	end
end

function RefreshInspectFrameHack()
	if not InspectFrame then return end
	if InspectFrame:IsShown() then
		local unit = InspectFrame.unit;
		for _, slot in pairs(InspectSlotButton) do
			local button = _G[slot]
			local link = GetInventoryItemLink(unit, button:GetID())
			local textureName = GetInventoryItemTexture(unit, button:GetID())
			if textureName then
				-- SetItemButtonTexture(button, textureName)
				if link then
					local name, links, quality, _, _, _, _, _, _, texture = GetItemInfo(link)
					SetItemButtonQuality(button, quality)
					SetItemButtonTexture(button, texture)
				end
				button.hasItem = 1
			else
				local textureName = button.backgroundTextureName
				SetItemButtonQuality(button, nil)
				SetItemButtonTexture(button, textureName)
				button.hasItem = nil
			end
		end

		local class, classfilename = UnitClass(unit)
		local _, _, _, hexcolor = GetClassColor(classfilename)
		InspectLevelText:ClearAllPoints()
		InspectLevelText:SetPoint("TOP", 0, -50)
		InspectLevelText:SetFormattedText(PAPERDOLLFRAME_PLAYER_INFO, hexcolor, class, UnitLevel(unit))
		InspectNameText:SetSize(209, 16)
		InspectNameText:SetText(UnitPVPName(unit))
	end
end

local RefreshInspectFrameH = CreateFrame("Frame")
-- RefreshInspectFrameH:SetScript("OnUpdate", RefreshInspectFrameHack)

function CharacterStrengthenButton_OnClick( self, ... )
	local id = self:GetParent():GetID()
	if IsModifiedClick("SHIFT") then
		SendServerMessage("INCREASE_STRENGTHENING_STAT", id..":10")
	elseif IsModifiedClick("CTRL") then
		SendServerMessage("INCREASE_STRENGTHENING_STAT", id..":100")
	else
		SendServerMessage("INCREASE_STRENGTHENING_STAT", id..":1")
	end

	if not NPE_TutorialPointerFrame:GetKey("PaperDollFrame_Strengthen") then
		if tutorialData.Strengthen then
			NPE_TutorialPointerFrame:Hide(tutorialData.Strengthen)
			tutorialData.Strengthen = nil
			PaperDollFrameStrengthenFrame.TutorialGlow:Hide()
			NPE_TutorialPointerFrame:SetKey("PaperDollFrame_Strengthen", true)
		end
	end
end

function CharacterStrengthenButton_OnEnter( self, ... )
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(PAPERDOLLFRAME_UPS, 1.0, 1.0, 1.0)

	local id = self:GetParent():GetID()
	local multiplier = BONUS_STAT_MULTIPLIERS[id]

	if not multiplier then
		if id == 3 then
			multiplier = 3
		elseif id == 7 then
			multiplier = 4
		else
			multiplier = 2
		end
	end

	GameTooltip:AddLine(string.format(PAPERDOLLFRAME_UPS_TOOLTIP_HELP_1, RoundToSignificantDigits(multiplier, 2)), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
	GameTooltip:AddLine(PAPERDOLLFRAME_UPS_TOOLTIP_HELP_2, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
	GameTooltip:AddLine(PAPERDOLLFRAME_UPS_TOOLTIP_HELP_3, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
	GameTooltip:AddLine(PAPERDOLLFRAME_UPS_TOOLTIP_HELP_4, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
	GameTooltip:Show()
end

PaperDollItemSlotButtonMixin = {};

function PaperDollItemSlotButtonMixin:GetItemContextMatchResult()
	return ItemButtonUtil.GetItemContextMatchResultForItem(ItemLocation:CreateFromEquipmentSlot(self:GetID()));
end

PaperDollSpellButtonMixin = {}

function PaperDollSpellButtonMixin:OnLoad()
	self:RegisterForDrag("LeftButton")
	self:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	self.UpdateTooltip = self.OnEnter
	self.dirty = true
	self:RegisterEvent("SPELLS_CHANGED")
end

function PaperDollSpellButtonMixin:OnEvent(event, ...)
	if event == "SPELLS_CHANGED" then
		self.dirty = true
	elseif event == "SPELL_UPDATE_COOLDOWN" then
		self:UpdateCooldown()
	elseif event == "CURRENT_SPELL_CAST_CHANGED"
--	or event == "TRADE_SKILL_SHOW"
--	or event == "TRADE_SKILL_CLOSE"
	then
		self:UpdateSelection()
	elseif event == "PET_BAR_UPDATE" then
		self.dirty = true
		self:UpdateInfo()
	end
end

function PaperDollSpellButtonMixin:OnShow()
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	self:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")
	self:RegisterEvent("TRADE_SKILL_SHOW")
	self:RegisterEvent("TRADE_SKILL_CLOSE")

	if self:GetBookType() == "pet" then
		self:RegisterEvent("PET_BAR_UPDATE")
	end

	self:UpdateInfo()
end

function PaperDollSpellButtonMixin:OnHide()
	self:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
	self:UnregisterEvent("CURRENT_SPELL_CAST_CHANGED")
	self:UnregisterEvent("TRADE_SKILL_SHOW")
	self:UnregisterEvent("TRADE_SKILL_CLOSE")
	self:UnregisterEvent("PET_BAR_UPDATE")
end

function PaperDollSpellButtonMixin:OnClick(button)
	local spellID = self:GetSpellID()
	if not spellID then
		return
	end

	if IsModifiedClick() then
		if IsModifiedClick("CHATLINK") then
			if MacroFrame and MacroFrame:IsShown() then
				local spellName, subSpellName = GetSpellInfo(spellID)
				if spellName and not IsPassiveSpell(spellName) then
					if subSpellName and subSpellName ~= "" then
						ChatEdit_InsertLink(spellName.."("..subSpellName..")")
					else
						ChatEdit_InsertLink(spellName)
					end
				end
				return
			else
				local spellLink, tradeSkillLink = GetSpellLink(spellID)
				if tradeSkillLink then
					ChatEdit_InsertLink(tradeSkillLink)
				elseif spellLink then
					ChatEdit_InsertLink(spellLink)
				end
				return
			end
		end
		if IsModifiedClick("PICKUPACTION") then
			local spellSlot = self:GetSpellSlot()
			if spellSlot then
				PickupSpell(spellSlot, self:GetBookType())
				return
			end
		end
		if IsModifiedClick("SELFCAST") then
			local spellSlot = self:GetSpellSlot()
			if spellSlot then
				CastSpell(spellSlot, self:GetBookType(), true)
				return
			end
		end
	else
		local bookType = self:GetBookType()
		if button ~= "LeftButton" and bookType == "pet" then
			local spellSlot = self:GetSpellSlot()
			if spellSlot then
				ToggleSpellAutocast(spellSlot, bookType)
			end
		else
			if GetFlyoutInfo(spellID) then
				SpellFlyout:Toggle(spellID, self, "RIGHT", 1, false, 0, true)
				SpellFlyout:SetBorderColor(0.70703125, 0.6328125, 0.3515625)
			else
				local spellSlot = self:GetSpellSlot()
				if spellSlot then
					CastSpell(spellSlot, self:GetBookType())
				end
			end
			self:UpdateSelection()
		end
	end
end

function PaperDollSpellButtonMixin:OnDragStart(button)
	local spellSlot = self:GetSpellSlot()
	if spellSlot then
		PickupSpell(spellSlot, self:GetBookType())
	end
end

function PaperDollSpellButtonMixin:OnReceiveDrag()
	self:OnDragStart()
end

function PaperDollSpellButtonMixin:OnEnter()
	local spellID = self:GetSpellID()
	if spellID then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetHyperlink(GetSpellLink(spellID))
	end
end

function PaperDollSpellButtonMixin:OnLeave()
	GameTooltip:Hide()
end

function PaperDollSpellButtonMixin:GetSpellID()
	return self:GetAttribute("spellid")
end

function PaperDollSpellButtonMixin:GetBookType()
	return self:GetAttribute("bookType")
end

function PaperDollSpellButtonMixin:IsSpellKnown()
	local spellID = self:GetSpellID()
	local bookType = self:GetBookType()
	if spellID and bookType then
		return IsSpellKnown(spellID, bookType == "pet")
	end
	return false
end

function PaperDollSpellButtonMixin:GetSpellSlot()
	if self.dirty then
		self.spellSlot = nil
		self.dirty = nil

		local spellID = self:GetSpellID()
		local bookType = self:GetBookType()
		if spellID and bookType then
			self.spellSlot = SpellBook_GetSpellIndex(spellID, bookType)
		end
	end

	return self.spellSlot
end

function PaperDollSpellButtonMixin:UpdateCooldown()
	local spellID = self:GetSpellID()
	if not spellID then
		return
	end

	local start, duration, enable = GetSpellCooldown(spellID)
	CooldownFrame_SetTimer(self.Cooldown, start, duration, enable)

	if enable == 1 then
		self.Icon:SetVertexColor(1.0, 1.0, 1.0)
	else
		self.Icon:SetVertexColor(0.4, 0.4, 0.4)
	end
end

function PaperDollSpellButtonMixin:UpdateSelection()
	local spellID = self:GetSpellID()
	if not spellID then
		return
	end

	local spellname = GetSpellInfo(spellID)
	if IsSelectedSpell(spellname) then
		self:SetChecked(true)
	else
		self:SetChecked(false)
	end
end

function PaperDollSpellButtonMixin:UpdateInfo()
	local spellID = self:GetSpellID()
	if not spellID then
		return
	end

	self:UpdateCooldown()
	self:UpdateSelection()

	local spellName, subSpellName, texture, cost, isFunnel, powerType, castTime, minRage, maxRange = GetSpellInfo(spellID)

	if not texture or texture == "" then
		texture = GetSpellTexture(spellName)
	end

	self.Icon:SetTexture(texture or [[Interface\ICONS\INV_Misc_QuestionMark]])

	self:SetEnabled(not IsPassiveSpell(spellName))

	if GetFlyoutInfo(spellID) then
		SetClampedTextureRotation(self.FlyoutArrow.Arrow, 90)
		self.FlyoutArrow:Show()
	else
		self.FlyoutArrow:Hide()
	end
end