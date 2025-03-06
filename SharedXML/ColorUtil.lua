local function ExtractColorValueFromHex(str, index)
	return tonumber(str:sub(index, index + 1), 16) / 255;
end

function CreateColorFromHexString(hexColor)
	if #hexColor == 8 then
		local a, r, g, b = ExtractColorValueFromHex(hexColor, 1), ExtractColorValueFromHex(hexColor, 3), ExtractColorValueFromHex(hexColor, 5), ExtractColorValueFromHex(hexColor, 7);
		return CreateColor(r, g, b, a);
	else
		GMError("CreateColorFromHexString input must be hexadecimal digits in this format: AARRGGBB.");
	end
end

function CreateColorFromBytes(r, g, b, a)
	return CreateColor(r / 255, g / 255, b / 255, a / 255);
end

function AreColorsEqual(left, right)
	if left and right then
		return left:IsEqualTo(right);
	end
	return left == right;
end

local RAID_CLASS_COLORS = {
	["HUNTER"] = CreateColor(0.67, 0.83, 0.45),
	["WARLOCK"] = CreateColor(0.58, 0.51, 0.79),
	["PRIEST"] = CreateColor(1.0, 1.0, 1.0),
	["PALADIN"] = CreateColor(0.96, 0.55, 0.73),
	["MAGE"] = CreateColor(0.41, 0.8, 0.94),
	["ROGUE"] = CreateColor(1.0, 0.96, 0.41),
	["DRUID"] = CreateColor(1.0, 0.49, 0.04),
	["SHAMAN"] = CreateColor(0.0, 0.44, 0.87),
	["WARRIOR"] = CreateColor(0.78, 0.61, 0.43),
	["DEATHKNIGHT"] = CreateColor(0.77, 0.12 , 0.23),
	["MONK"] = CreateColor(0.0, 1.00 , 0.59),
	["DEMONHUNTER"] = CreateColor(0.64, 0.19, 0.79),
};
do
	for _, v in pairs(RAID_CLASS_COLORS) do
		v.colorStr = v:GenerateHexColor()
	end
end

for k, v in pairs(RAID_CLASS_COLORS) do
	v.colorStr = v:GenerateHexColor();
end

function GetClassColor(classFilename)
	local color = RAID_CLASS_COLORS[classFilename];
	if color then
		return color.r, color.g, color.b, color.colorStr;
	end

	return 1, 1, 1, "ffffffff";
end

function GetClassColorObj(classFilename)
	return RAID_CLASS_COLORS[classFilename] or RAID_CLASS_COLORS.PRIEST;
end

function GetClassColoredTextForUnit(unit, text)
	local classFilename = select(2, UnitClass(unit));
	local color = GetClassColorObj(classFilename);
	return color:WrapTextInColorCode(text);
end

function GetFactionColor(factionGroupTag)
	return PLAYER_FACTION_COLORS[PLAYER_FACTION_GROUP[factionGroupTag]];
end

local ITEM_LEVEL_COLORS = {
	[1] = CreateColor(0.65882, 0.65882, 0.65882),
	[2] = CreateColor(0.08235, 0.70196, 0),
	[3] = CreateColor(0, 0.56863, 0.94902),
	[4] = CreateColor(0.78431, 0.27059, 0.98039),
	[5] = CreateColor(1, 0.50196, 0),
	[6] = CreateColor(1, 0, 0),
}

function GetItemLevelColor(itemLevel)
	if itemLevel < 150 then
		return ITEM_LEVEL_COLORS[1]
	elseif WithinRange(itemLevel, 150, 185) then
		return ITEM_LEVEL_COLORS[2]
	elseif WithinRange(itemLevel, 185, 200) then
		return ITEM_LEVEL_COLORS[3]
	elseif WithinRange(itemLevel, 200, 277) then
		return ITEM_LEVEL_COLORS[4]
	elseif WithinRange(itemLevel, 277, 296) then
		return ITEM_LEVEL_COLORS[5]
	else
		return ITEM_LEVEL_COLORS[6]
	end
end

function RGB255To1(r, g, b)
	return r / 255, g / 255, b / 255
end