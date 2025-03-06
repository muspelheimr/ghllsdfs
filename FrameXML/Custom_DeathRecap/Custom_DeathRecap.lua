UIPanelWindows["DeathRecapFrame"] = { area = "center", pushable = 0, whileDead = 1, allowOtherPanels = 1}

DeathRecapMixin = {}

function DeathRecapMixin:OnLoad()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("PLAYER_DEAD")

	self.deathRecapData = {}
	self.deathRecapBuffer = {}
	self.deathRecapStorage = {}

	self.hyperLinkColor = CreateColor(0.443137, 0.835294, 1)
end

function DeathRecapMixin:OnEvent( event, ... )
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		self:OnCombatLogEvent(...)
	elseif event == "PLAYER_DEAD" then
		self:RegisterDeath()
	end
end

function DeathRecapMixin:OnHide()
	self.recapID = nil
end

function DeathRecapMixin:OnCombatLogEvent(timestamp, subEvent, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
	if bit.band(dstFlags, COMBATLOG_FILTER_ME) ~= COMBATLOG_FILTER_ME then
		return
	end

	if subEvent == "SWING_DAMAGE" then
		local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = ...
		self:InsertEvent(timestamp, subEvent, srcGUID, srcName, amount)
	elseif subEvent == "ENVIRONMENTAL_DAMAGE" then
		local environmentalType, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = ...
		self:InsertEvent(timestamp, subEvent, srcGUID, srcName, amount, nil, environmentalType)
	elseif subEvent == "SPELL_DAMAGE" or subEvent == "SPELL_PERIODIC_DAMAGE" or subEvent == "RANGE_DAMAGE" then
		local spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = ...
		self:InsertEvent(timestamp, subEvent, srcGUID, srcName, amount, spellId)
	elseif subEvent == "SPELL_INSTAKILL" then
		local spellId, spellName, spellSchool = ...
		self:InsertEvent(timestamp, subEvent, srcGUID, srcName, nil, spellId)
	end
end

function DeathRecapMixin:InsertEvent( timestamp, subEvent, casterGUID, casterName, damage, spellID, environmentalType )
	local spellName, texture = self:GetSpellInfoBySubEvent(subEvent, environmentalType)
	local unitHealth = UnitHealth("player")

	if (not spellName and not texture) and spellID then
		local _
		spellName, _, texture = GetSpellInfo(spellID)
		texture = string.gsub(texture:lower(), "interface\\icons\\", "")
	end

	if subEvent == "SPELL_INSTAKILL" then
		damage = unitHealth
	end

	if spellName and texture then
		if #self.deathRecapData > 0 and timestamp > self.deathRecapData[#self.deathRecapData].timestamp + 10 then
			table.wipe(self.deathRecapData)
		end

		table.insert(self.deathRecapData, {
			timestamp 	= timestamp,
			casterGUID 	= casterGUID,
			casterName 	= casterName,
			damage 		= damage,
			spellName 	= spellName,
			spellID 	= spellID,
			unitHealth 	= unitHealth,
			texture 	= texture
		})

		if #self.deathRecapData > 5 then
			table.remove(self.deathRecapData, 1)
		end
	end
end

function DeathRecapMixin:GetSpellInfoBySubEvent( subEvent, environmentalType )
	local spellName, texture

	if subEvent == "SWING_DAMAGE" then
		spellName = ACTION_SWING
		texture = "PetBattle_Attack"
	elseif subEvent == "RANGE_DAMAGE" then
		spellName = RANGED_ATTACK
		texture = "INV_Weapon_Bow_03"
	elseif subEvent == "ENVIRONMENTAL_DAMAGE" then
		environmentalType = string.upper(environmentalType)
		spellName = _G["ACTION_ENVIRONMENTAL_DAMAGE_"..environmentalType]

		if environmentalType == "DROWNING" then
			texture = "spell_shadow_demonbreath"
		elseif environmentalType == "FALLING" then
			texture = "ability_rogue_quickrecovery"
		elseif environmentalType == "FIRE" or environmentalType == "LAVA" then
			texture = "spell_fire_fire"
		elseif environmentalType == "SLIME" then
			texture = "inv_misc_slime_01"
		elseif environmentalType == "FATIGUE" then
			texture = "ability_creature_cursed_05"
		else
			texture = "ability_creature_cursed_05"
		end
	end

	return spellName, texture
end

function DeathRecapMixin:RegisterDeath()
	local deathRecapRegisterString = ""
	local unitMaxHealth = UnitHealthMax("player")
	local unitName = UnitName("player")

	for _, data in ipairs(self.deathRecapData) do
		deathRecapRegisterString = strconcat(deathRecapRegisterString, string.format("%s:%s:%s:%s:%s:%s:%d:%s:",
			data.timestamp 	or "",
			data.casterGUID or "",
			data.casterName or "",
			data.damage 	or "",
			data.spellName 	or "",
			data.spellID 	or "",
			data.unitHealth or "",
			data.texture 	or ""
		))
	end

	SendServerMessage("ACMSG_REGISTER_DEATH_REQUEST", string.format("%s|%s|%s",
		unitName,
		unitMaxHealth,
		deathRecapRegisterString
	))

	table.insert(self.deathRecapBuffer, {
		unitName 		= unitName,
		unitMaxHealth 	= unitMaxHealth,
		recapData		= CopyTable(self.deathRecapData)
	})

	table.wipe(self.deathRecapData)
	self.lastDeathRecapRegisterID = nil
end

function DeathRecapMixin:AssociationIDToData( deathRecapID )
	local bufferData = table.remove(self.deathRecapBuffer, #self.deathRecapBuffer)

	if bufferData then
		self.deathRecapStorage[deathRecapID] = bufferData
		self.lastDeathRecapRegisterID = deathRecapID
		FireCustomClientEvent("DEATH_RECAP_REGISTERED", deathRecapID)
	end

	self:PrintHyperlink(deathRecapID)
end

function DeathRecapMixin:PrintHyperlink( deathRecapID )
	DEFAULT_CHAT_FRAME:AddMessage(self.hyperLinkColor:WrapTextInColorCode(string.format(DEATH_RECAP_HYPERLINK_TEXT, deathRecapID)))
end

function DeathRecapMixin:OnHyperlinkClick( link )
	local deathRecapID = tonumber(string.match(link, "death:(%d+)"))
	local deathRecapData = self.deathRecapStorage[deathRecapID]

	if deathRecapData then
		self:OpenDeathRecap(deathRecapData, deathRecapID)
	else
		SendServerMessage("ACMSG_GET_DEATH_INFO_REQUEST", deathRecapID)
	end
end

function DeathRecapMixin:ConvertStringToDeathRecapData( deathRecapDataString )
	local splitData 		= C_Split(deathRecapDataString, "|")
	local splitRecapData 	= C_Split(splitData[4], ":")

	local deathRecapID 	= tonumber(splitData[1])
	local unitName 		= splitData[2]
	local unitMaxHealth = tonumber(splitData[3])
	local recapData 	= {}

	for i = 1, #splitRecapData, 8 do
		table.insert(recapData, {
			timestamp 	= tonumber(splitRecapData[i]),
			casterGUID 	= splitRecapData[i + 1],
			casterName 	= splitRecapData[i + 2],
			damage 		= tonumber(splitRecapData[i + 3]),
			spellName 	= splitRecapData[i + 4],
			spellID 	= tonumber(splitRecapData[i + 5]),
			unitHealth 	= tonumber(splitRecapData[i + 6]),
			texture 	= splitRecapData[i + 7]
		})
	end

	self.deathRecapStorage[deathRecapID] = {
		unitName 		= unitName,
		unitMaxHealth 	= unitMaxHealth,
		recapData 		= recapData
	}

	self:OpenDeathRecap(self.deathRecapStorage[deathRecapID], deathRecapID)
end

function DeathRecapMixin:OpenDeathRecap(deathRecapData, recapID)
	if not deathRecapData then
		deathRecapData = self.deathRecapStorage[self.lastDeathRecapRegisterID]
	end

	if type(deathRecapData) == "string" then
		self:ConvertStringToDeathRecapData(deathRecapData)
	elseif type(deathRecapData) == "table" then
		if self:IsShown() and recapID == self.recapID then
			self.recapID = nil
			HideUIPanel(self)
			return
		end

		self.recapID = recapID
		ShowUIPanel(self)

		local numRecapData 	= #deathRecapData.recapData
		local numRecapEntry = #self.DeathRecapEntry

		if numRecapData <= 0 then
			for i = 1, numRecapEntry do
				self.DeathRecapEntry[i]:Hide()
			end
			self.Unavailable:Show()
			return
		end

		self.Unavailable:Hide()

		local highestDamageIndex, highestDamageAmount = 1, 0

		table.sort(deathRecapData.recapData, function(a, b)
			return a.timestamp > b.timestamp
		end)

		local killOwnerData = {}
		local GUID = C_ObjectGUID:CreateGUID()

		for index, recapData in ipairs(deathRecapData.recapData) do
			local recapEntry = self.DeathRecapEntry[index]

			if recapData.damage then
				recapEntry.DamageInfo.Amount:SetText(-recapData.damage)
				recapEntry.DamageInfo.AmountLarge:SetText(-recapData.damage)
				recapEntry.DamageInfo.amount = recapData.damage

				if recapData.damage > highestDamageAmount then
					highestDamageIndex = index
					highestDamageAmount = recapData.damage
				end

				recapEntry.DamageInfo.Amount:Show()
				recapEntry.DamageInfo.AmountLarge:Hide()
			else
				recapEntry.DamageInfo.Amount:Hide()
				recapEntry.DamageInfo.amount = nil
				recapEntry.DamageInfo.dmgExtraStr = nil
			end

			recapEntry.DamageInfo.timestamp = recapData.timestamp
			recapEntry.DamageInfo.hpPercent = math.ceil(recapData.unitHealth / deathRecapData.unitMaxHealth * 100)
			recapEntry.DamageInfo.spellName = recapData.spellName
			recapEntry.DamageInfo.caster 	= recapData.casterName or COMBATLOG_UNKNOWN_UNIT
			recapEntry.SpellInfo.spellId 	= recapData.spellID

			recapEntry.SpellInfo.Name:SetText(recapEntry.DamageInfo.spellName)
			recapEntry.SpellInfo.Caster:SetText(recapEntry.DamageInfo.caster)

			local timestamp = math.abs(recapData.timestamp)

			recapEntry.SpellInfo.Time:SetFormattedText("%s.%d", date("%H:%M:%S", timestamp), string.match(timestamp, "%d%.(%d+)"))
			recapEntry.SpellInfo.Icon:SetTexture("Interface\\Icons\\"..recapData.texture)

			if not killOwnerData.GUID and recapData.casterGUID and recapData.casterGUID ~= UnitGUID("player") then
				GUID:SetGUID(recapData.casterGUID)

				if GUID:IsPlayer() then
					killOwnerData.name = recapData.casterName
					killOwnerData.GUID = GUID:GetRawValue()
				end
			end

			recapEntry:Show()
		end

		for i = numRecapData + 1, numRecapEntry do
			self.DeathRecapEntry[i]:Hide()
		end

		local recapEntry = self.DeathRecapEntry[highestDamageIndex]

		if recapEntry.DamageInfo.amount then
			recapEntry.DamageInfo.Amount:Hide()
			recapEntry.DamageInfo.AmountLarge:Show()
		end

		local deathEntry = self.DeathRecapEntry[1]

		if deathEntry == recapEntry then
			deathEntry.tombstone:SetPoint("RIGHT", deathEntry.DamageInfo.AmountLarge, "LEFT", -10, 0)
		else
			deathEntry.tombstone:SetPoint("RIGHT", deathEntry.DamageInfo.Amount, "LEFT", -10, 0)
		end

		if killOwnerData.GUID and C_Service.IsRenegadeRealm() then
			self.CloseButton:ClearAndSetPoint("BOTTOM", -80, 15)

			self.HeadHuntingButton.playerName = killOwnerData.name
			self.HeadHuntingButton.GUID = killOwnerData.GUID
			self.HeadHuntingButton:Show()

			EventRegistry:TriggerEvent("DeathRecap.DeathByOtherPlayer")
		else
			self.CloseButton:ClearAndSetPoint("BOTTOM", 0, 15)

			self.HeadHuntingButton.playerName = nil
			self.HeadHuntingButton.GUID = nil
			self.HeadHuntingButton:Hide()
		end

		self.Title:SetFormattedText(DEATH_RECAP_TITLE, deathRecapData.unitName or UNKNOWN, date("%H:%M:%S", deathEntry.DamageInfo.timestamp or 0))
		self.DeathTimeStamp = deathEntry.DamageInfo.timestamp
	end
end

function DeathRecapMixin:IsDeathLogEmpty()
	if type(self.deathRecapStorage[self.lastDeathRecapRegisterID]) == "table" then
		return not next(DeathRecapFrame.deathRecapStorage[DeathRecapFrame.lastDeathRecapRegisterID]), DeathRecapFrame.deathRecapStorage[DeathRecapFrame.lastDeathRecapRegisterID]
	end
	return true
end

function DeathRecapFrame_Amount_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:ClearLines()
	if self.amount then
		GameTooltip:AddLine(string.format(DEATH_RECAP_DAMAGE_TT, self.amount), 1, 0, 0, false)
	end

	if self.spellName then
		GameTooltip:AddLine(string.format(DEATH_RECAP_CAST_BY_TT, self.spellName, self.caster), 1, 1, 1, true)
	end

	local seconds = math.abs(self:GetParent():GetParent().DeathTimeStamp - self.timestamp)
	if seconds > 0 then
		GameTooltip:AddLine(string.format(DEATH_RECAP_CURR_HP_TT, string.format("%.1F", seconds), self.hpPercent), 1, 0.824, 0, true)
	else
		GameTooltip:AddLine(string.format(DEATH_RECAP_DEATH_TT, self.hpPercent), 1, 0.824, 0, true)
	end

	GameTooltip:Show()
end

function DeathRecapFrame_Spell_OnEnter(self)
	if self.spellId then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetHyperlink("spell:"..self.spellId)
		GameTooltip:Show()
	end
end

function EventHandler:ASMSG_REGISTER_DEATH_RESPONSE( msg )
	DeathRecapFrame:AssociationIDToData(tonumber(msg))
end

function EventHandler:ASMSG_GET_DEATH_INFO_RESPONSE( msg )
	DeathRecapFrame:OpenDeathRecap(msg)
end
