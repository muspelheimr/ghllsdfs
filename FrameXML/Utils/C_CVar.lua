local SetCVar = SetCVar;
local TRACKED_CVARS = TRACKED_CVARS

local EVENT_TRIGGER_CVAR = "readContest";

CUSTOM_SESSION_KEYS = {}

local eventHandler = CreateFrame("Frame")
eventHandler:RegisterEvent("VARIABLES_LOADED")
eventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
eventHandler:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		local isInitialLogin, isReloadingUI = ...
		if isInitialLogin then
			self.isInitialLogin = true
			table.wipe(CUSTOM_SESSION_KEYS)
		end
	elseif event == "VARIABLES_LOADED" then
		self.VARIABLES_LOADED = true
	end

	self:UnregisterEvent(event)

	if self.VARIABLES_LOADED and self.isInitialLogin then
		FireCustomClientEvent("VARIABLES_LOADED_INITIAL")
	end
end)

C_CVar = {}

C_CVar._cache = C_Cache("C_CVAR_STORAGE")
C_CVar._defaultValue = {}
C_CVar._globalValues = {}

function C_CVar:SetValue( key, value, raiseEvent )
    self._cache:Set(key, value, 0, self._globalValues[key])

	local trackedIndex = tIndexOf(TRACKED_CVARS, key)
	if trackedIndex then
		SendServerMessage("ACMSG_I_S", string.format("%i:%i", trackedIndex, tonumber(value) or 0))
	end

    if raiseEvent then
        SetCVar(EVENT_TRIGGER_CVAR, value, raiseEvent);
        SetCVar(EVENT_TRIGGER_CVAR, "0");
    end

    Hook:FireEvent("C_SETTINGS_UPDATE_STORAGE")
end

function C_CVar:GetValue( key, defaultValue )
    return self._cache:Get(key, nil, 0, self._globalValues[key]) or ( defaultValue or self:GetDefaultValue(key) )
end

function C_CVar:RegisterDefaultValue( key, value, global )
    self._defaultValue[key] = value

    if global then
        self._globalValues[key] = true
    end
end

function C_CVar:GetDefaultValue( key )
    return self._defaultValue[key]
end

function C_CVar:GetCVarBitfield(name, index)
	if type(name) == "number" then
		name = tostring(name);
	end
	if type(index) == "string" then
		index = tonumber(index);
	end
	if type(name) ~= "string" or type(index) ~= "number" then
		error("Usage: local value = C_CVar:GetCVarBitfield(name, index)", 2);
	end

    if self._defaultValue[name] then
		return bit.band(tonumber(self._cache:Get(name, nil, 0, self._globalValues[name]) or self._defaultValue[name]) or 0, bit.lshift(1, index - 1)) ~= 0;
	end
end

function C_CVar:SetCVarBitfield(name, index, value, scriptCVar)
	if type(name) == "number" then
		name = tostring(name);
	end
	if type(index) == "string" then
		index = tonumber(index);
	end
	if type(name) ~= "string" or type(index) ~= "number" or type(value) ~= "boolean" then
		error("Usage: local success = C_CVar:SetCVarBitfield(name, index, value [, scriptCVar]", 2);
	end

	if self._defaultValue[name] then
		if self:GetCVarBitfield(name, index) == value then
			return false;
		end

		local currentValue = tonumber(self._cache:Get(name, nil, 0, self._globalValues[name]) or self._defaultValue[name]) or 0

		if value then
			value = bit.bor(currentValue, bit.lshift(1, index - 1))
		else
			value = bit.band(currentValue, bit.bnot(bit.lshift(1, index - 1)))
		end

		self._cache:Set(name, value, 0, self._globalValues[name])

		local trackedIndex = tIndexOf(TRACKED_CVARS, name)
		if trackedIndex then
			SendServerMessage("ACMSG_I_S", string.format("%i:%i", trackedIndex, value))
		end

		if scriptCVar then
			SetCVar(EVENT_TRIGGER_CVAR, value, scriptCVar);
			SetCVar(EVENT_TRIGGER_CVAR, "0");
		end

		return true;
	end
end

function C_CVar:SetSessionCVar(name, value)
	CUSTOM_SESSION_KEYS[name] = value
end

function C_CVar:GetSessionCVar(name)
	return CUSTOM_SESSION_KEYS[name]
end

C_CVar:RegisterDefaultValue("C_CVAR_AUTOJOIN_TO_LFG", "1")
C_CVar:RegisterDefaultValue("C_CVAR_LOSS_OF_CONTROL_SCALE", "1")
C_CVar:RegisterDefaultValue("C_CVAR_WHISPER_MODE", "inline")
C_CVar:RegisterDefaultValue("C_CVAR_STATUS_TEXT_DISPLAY", "NUMERIC")
C_CVar:RegisterDefaultValue("C_CVAR_STORE_SHOW_ALL_TRANSMOG_ITEMS", "1")
C_CVar:RegisterDefaultValue("C_CVAR_HIDE_PARTY_INTERFACE_IN_RAID", "1")
C_CVar:RegisterDefaultValue("C_CVAR_USE_COMPACT_PARTY_FRAMES", "0")
C_CVar:RegisterDefaultValue("C_CVAR_USE_COMPACT_SOLO_FRAMES", "0")
C_CVar:RegisterDefaultValue("C_CVAR_SET_ACTIVE_CUF_PROFILE", "0")
C_CVar:RegisterDefaultValue("C_CVAR_SHOW_ACHIEVEMENT_TOOLTIP", "0")
C_CVar:RegisterDefaultValue("C_CVAR_BLOCK_GUILD_INVITES", "0")
C_CVar:RegisterDefaultValue("C_CVAR_AUCTION_HOUSE_DURATION_DROPDOWN", "1")
C_CVar:RegisterDefaultValue("C_CVAR_ROULETTE_SKIP_ANIMATION", 0)
C_CVar:RegisterDefaultValue("C_CVAR_FL_GUILD_SETTINGS2", 0)
C_CVar:RegisterDefaultValue("C_CVAR_FL_GUILD_COMMENT", "")
C_CVar:RegisterDefaultValue("C_CVAR_PET_JOURNAL_TAB", "1", true)
C_CVar:RegisterDefaultValue("C_CVAR_PET_JOURNAL_FILTERS", "0", true)
C_CVar:RegisterDefaultValue("C_CVAR_PET_JOURNAL_TYPE_FILTERS", "0", true)
C_CVar:RegisterDefaultValue("C_CVAR_PET_JOURNAL_SOURCE_FILTERS", "0", true)
C_CVar:RegisterDefaultValue("C_CVAR_PET_JOURNAL_EXPANSION_FILTERS", "0", true)
C_CVar:RegisterDefaultValue("C_CVAR_PET_JOURNAL_SORT", "1", true)
C_CVar:RegisterDefaultValue("C_CVAR_MOUNT_JOURNAL_GENERAL_FILTERS", "0", true)
C_CVar:RegisterDefaultValue("C_CVAR_MOUNT_JOURNAL_ABILITY_FILTER", "0", true)
C_CVar:RegisterDefaultValue("C_CVAR_MOUNT_JOURNAL_SOURCE_FILTER", "0", true)
C_CVar:RegisterDefaultValue("C_CVAR_MOUNT_JOURNAL_TRAVELING_MERCHANT_FILTER", "0", true)
C_CVar:RegisterDefaultValue("C_CVAR_MOUNT_JOURNAL_FACTION_FILTER", "0", true)

C_CVar:RegisterDefaultValue("C_CVAR_WARDROBE_SHOW_COLLECTED", "1", true)
C_CVar:RegisterDefaultValue("C_CVAR_WARDROBE_SHOW_UNCOLLECTED", "1", true)
C_CVar:RegisterDefaultValue("C_CVAR_WARDROBE_SOURCE_FILTERS", "0", true)
C_CVar:RegisterDefaultValue("C_CVAR_LAST_TRANSMOG_OUTFIT_ID", "")

C_CVar:RegisterDefaultValue("C_CVAR_HIDE_HELPTIPS", "0", true)
C_CVar:RegisterDefaultValue("C_CVAR_CLOSED_INFO_FRAMES", "0")
C_CVar:RegisterDefaultValue("C_CVAR_CLOSED_INFO_FRAMES_ACCOUNT_WIDE", "0", true)

C_CVar:RegisterDefaultValue("C_CVAR_NUM_DISPLAY_SOCIAL_TOASTS", 1)
C_CVar:RegisterDefaultValue("C_CVAR_FLASH_CLIENT_ICON", "1")
C_CVar:RegisterDefaultValue("C_CVAR_SHOW_TOASTS", "1")
C_CVar:RegisterDefaultValue("C_CVAR_SHOW_SOCIAL_TOAST", "1")
--C_CVar:RegisterDefaultValue("C_CVAR_SHOW_HEAD_HUNTING_TOAST", "1")
C_CVar:RegisterDefaultValue("C_CVAR_SHOW_BATTLE_PASS_TOAST", "1")
C_CVar:RegisterDefaultValue("C_CVAR_SHOW_AUCTION_HOUSE_TOAST", "1")
C_CVar:RegisterDefaultValue("C_CVAR_SHOW_CALL_OF_ADVENTURE_TOAST", "1")
C_CVar:RegisterDefaultValue("C_CVAR_SHOW_MISC_TOAST", "1")

C_CVar:RegisterDefaultValue("C_CVAR_PLAY_TOAST_SOUND", "1")
C_CVar:RegisterDefaultValue("C_CVAR_SOCIAL_TOAST_SOUND", "1")
C_CVar:RegisterDefaultValue("C_CVAR_HEAD_HUNTING_TOAST_SOUND", "1")
C_CVar:RegisterDefaultValue("C_CVAR_BATTLE_PASS_TOAST_SOUND", "1")
C_CVar:RegisterDefaultValue("C_CVAR_QUEUE_TOAST_SOUND", "1")
C_CVar:RegisterDefaultValue("C_CVAR_AUCTION_HOUSE_TOAST_SOUND", "1")
C_CVar:RegisterDefaultValue("C_CVAR_CALL_OF_ADVENTURE_TOAST_SOUND", "1")
C_CVar:RegisterDefaultValue("C_CVAR_MISC_TOAST_SOUND", "1")

C_CVar:RegisterDefaultValue("C_CVAR_TOY_BOX_COLLECTED_FILTERS", "0", true)
C_CVar:RegisterDefaultValue("C_CVAR_TOY_BOX_SOURCE_FILTERS", "0", true)
C_CVar:RegisterDefaultValue("C_CVAR_HEIRLOOM_COLLECTED_FILTERS", "0", true)
C_CVar:RegisterDefaultValue("C_CVAR_HEIRLOOM_SOURCE_FILTERS", "0", true)
C_CVar:RegisterDefaultValue("C_CVAR_ILLUSION_SHOW_COLLECTED", "0", true)
C_CVar:RegisterDefaultValue("C_CVAR_ILLUSION_SHOW_UNCOLLECTED", "0", true)
C_CVar:RegisterDefaultValue("C_CVAR_ILLUSION_SOURCE_FILTERS", "0", true)

C_CVar:RegisterDefaultValue("C_CVAR_SHOW_HARDCORE_NOTIFICATION", C_Service.IsHardcoreCharacter() and "2" or "0")
C_CVar:RegisterDefaultValue("C_CVAR_SHOW_HARDCORE_NOTIFICATION_LEVEL", "2")
C_CVar:RegisterDefaultValue("C_CVAR_SHOW_HARDCORE_NOTIFICATION_SCALE", "1")
C_CVar:RegisterDefaultValue("C_CVAR_SHOW_HARDCORE_NOTIFICATION_SOUND", "1")

C_CVar:RegisterDefaultValue("C_CVAR_DRACTHYR_RETURN_MORTAL_FORM", "1")
C_CVar:RegisterDefaultValue("C_CVAR_ITEM_UPGRADE_LEFT_ITEM_LIST", "0")
C_CVar:RegisterDefaultValue("C_CVAR_WARMODE_PVP_ASSIST_ENABLED", "0")
C_CVar:RegisterDefaultValue("C_CVAR_LOOT_ALERT_THRESHOLD", "3")
C_CVar:RegisterDefaultValue("C_CVAR_BLOCK_GROUP_INVITES", "0")
C_CVar:RegisterDefaultValue("C_CVAR_AUTO_ACCEPT_GROUP_INVITES", "0")
