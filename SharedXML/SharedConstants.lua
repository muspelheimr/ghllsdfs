enum:E_DEFAULT_CLIENT_EVENTS {
	[240] = "LANGUAGE_LIST_CHANGED"
}

SIRUS_ROLE_FLAG_DAMAGER = 1
SIRUS_ROLE_FLAG_HEAL = 2
SIRUS_ROLE_FLAG_TANK = 4

MIN_CHARACTER_SEARCH = 3

BATTLEGROUND_ARATHI_BASIN = 462
BATTLEGROUND_WARSONG_GULCH = 444
BATTLEGROUND_ISLE_OF_CONQUEST = 541
BATTLEGROUND_ALTERAC_VALLEY = 402
BATTLEGROUND_SILVERSHARD_MINES = 861
BATTLEGROUND_EYE_OF_THE_STORM = 483
BATTLEGROUND_SLAVERY_VALLEY = 611
BATTLEGROUND_TEMPLE_OF_KOTMGU = 917
BATTLEGROUND_ARATHI_BLIZZARD = 958
BATTLEGROUND_THE_MAGNIFICENT_FIVE = 960
BATTLEGROUND_GRAVITY_LAPSE = 961

LE_EXPANSION_LEVEL_CURRENT = 2

LE_EXPANSION_CLASSIC = 0
LE_EXPANSION_BURNING_CRUSADE = 1
LE_EXPANSION_WRATH_OF_THE_LICH_KING = 2
LE_EXPANSION_CATACLYSM = 3
LE_EXPANSION_MISTS_OF_PANDARIA = 4
LE_EXPANSION_WARLORDS_OF_DRAENOR = 5
LE_EXPANSION_LEGION = 6
LE_EXPANSION_BATTLE_FOR_AZEROTH = 7
LE_EXPANSION_SHADOWLANDS = 8

LE_ITEM_QUALITY_COMMON = 1
LE_ITEM_QUALITY_EPIC = 4
LE_ITEM_QUALITY_HEIRLOOM = 7
LE_ITEM_QUALITY_LEGENDARY = 5
LE_ITEM_QUALITY_POOR = 0
LE_ITEM_QUALITY_RARE = 3
LE_ITEM_QUALITY_UNCOMMON = 2
LE_ITEM_QUALITY_WOW_TOKEN = 8
LE_ITEM_QUALITY_ARTIFACT = 6

LE_ITEM_FILTER_TYPE_HEAD = 1
LE_ITEM_FILTER_TYPE_NECK = 2
LE_ITEM_FILTER_TYPE_SHOULDER = 3
LE_ITEM_FILTER_TYPE_CLOAK = 16
LE_ITEM_FILTER_TYPE_CHEST = 5
LE_ITEM_FILTER_TYPE_WRIST = 9
LE_ITEM_FILTER_TYPE_HAND = 10
LE_ITEM_FILTER_TYPE_WAIST = 6
LE_ITEM_FILTER_TYPE_LEGS = 7
LE_ITEM_FILTER_TYPE_FEET = 8
LE_ITEM_FILTER_TYPE_MAIN_HAND = 21
LE_ITEM_FILTER_TYPE_OFF_HAND = 22
LE_ITEM_FILTER_TYPE_2HWEAPON = 32
LE_ITEM_FILTER_TYPE_HWEAPON = 33
LE_ITEM_FILTER_TYPE_FINGER = 11
LE_ITEM_FILTER_TYPE_TRINKET = 12
LE_ITEM_FILTER_TYPE_ARTIFACT_RELIC = 30
LE_ITEM_FILTER_TYPE_RANGED = 31

S_RESET_FRAME_STATE_TIME = 30

S_GENDER_FILESTRING = {[0] = "MALE", [1] = "FEMALE", [2] = "NONE"}
S_GENDER_FILESTRING_INVERT = tInvert(S_GENDER_FILESTRING)

NORMAL_FONT_COLOR			= CreateColor(1.0, 0.82, 0.0)
HIGHLIGHT_FONT_COLOR		= CreateColor(1.0, 1.0, 1.0)
RED_FONT_COLOR				= CreateColor(1.0, 0.1, 0.1)
DIM_RED_FONT_COLOR			= CreateColor(0.8, 0.1, 0.1)
GREEN_FONT_COLOR			= CreateColor(0.1, 1.0, 0.1)
GRAY_FONT_COLOR				= CreateColor(0.5, 0.5, 0.5)
YELLOW_FONT_COLOR			= CreateColor(1.0, 1.0, 0.0)
BLUE_FONT_COLOR				= CreateColor(0, 0.749, 0.953)
LIGHTYELLOW_FONT_COLOR		= CreateColor(1.0, 1.0, 0.6)
ORANGE_FONT_COLOR			= CreateColor(1.0, 0.5, 0.25)
PASSIVE_SPELL_FONT_COLOR	= CreateColor(0.77, 0.64, 0.0)
BATTLENET_FONT_COLOR 		= CreateColor(0.510, 0.773, 1.0)
TRANSMOGRIFY_FONT_COLOR		= CreateColor(1, 0.5, 1)
DISABLED_FONT_COLOR			= CreateColor(0.498, 0.498, 0.498)
LIGHTBLUE_FONT_COLOR		= CreateColor(0.53, 0.67, 1.0)
BLUEHELP_FONT_COLOR			= CreateColor(0, 0.8, 1)
WHITE_FONT_COLOR			= CreateColor(1, 1, 1)
PANEL_BACKGROUND_COLOR		= CreateColor(0.784, 0.651, 0.992)

LOOT_FONT_COLOR 	= CreateColor(0, 0.666, 0)
SYSTEM_FONT_COLOR 	= CreateColor(1, 1, 0)

-- faction
PLAYER_FACTION_GROUP = { [0] = "Horde", [1] = "Alliance", [2] = "Renegade", [3] = "Neutral", Horde = 0, Alliance = 1, Renegade = 2, Neutral = 3 };
SERVER_PLAYER_FACTION_GROUP = { [0] = "Alliance", [1] = "Horde", [2] = "Renegade", [3] = "Neutral", Alliance = 0, Horde = 1, Renegade = 2, Neutral = 3 }
SERVER_PLAYER_TEAM = { [469] = "Alliance", [67] = "Horde", [1187] = "Renegade", [0] = "Neutral", Alliance = 469, Horde = 67, Renegade = 1187, Neutral = 0 }
PLAYER_FACTION_COLORS = {
	[PLAYER_FACTION_GROUP.Horde] = CreateColor(0.90, 0.05, 0.07),
	[PLAYER_FACTION_GROUP.Alliance] = CreateColor(0.29, 0.33, 0.91),
	[PLAYER_FACTION_GROUP.Renegade] = CreateColor(1, 0.44, 0),
	[PLAYER_FACTION_GROUP.Neutral] = CreateColor(1, 1, 1),
}

SERVER_FACTION_TO_GAME_FACTION = {
	[SERVER_PLAYER_FACTION_GROUP.Horde] = PLAYER_FACTION_GROUP.Horde,
	[SERVER_PLAYER_FACTION_GROUP.Alliance] = PLAYER_FACTION_GROUP.Alliance,
	[SERVER_PLAYER_FACTION_GROUP.Renegade] = PLAYER_FACTION_GROUP.Renegade,
	[SERVER_PLAYER_FACTION_GROUP.Neutral] = PLAYER_FACTION_GROUP.Neutral,
}

GAME_FACTION_TO_SERVER_FACTION = {
	[PLAYER_FACTION_GROUP.Horde] = SERVER_PLAYER_FACTION_GROUP.Horde,
	[PLAYER_FACTION_GROUP.Alliance] = SERVER_PLAYER_FACTION_GROUP.Alliance,
	[PLAYER_FACTION_GROUP.Renegade] = SERVER_PLAYER_FACTION_GROUP.Renegade,
	[PLAYER_FACTION_GROUP.Neutral] = SERVER_PLAYER_FACTION_GROUP.Neutral,
}

SERVER_PLAYER_TEAM_TO_GAME_FACTION = {
	[SERVER_PLAYER_TEAM.Horde] = PLAYER_FACTION_GROUP.Horde,
	[SERVER_PLAYER_TEAM.Alliance] = PLAYER_FACTION_GROUP.Alliance,
	[SERVER_PLAYER_TEAM.Renegade] = PLAYER_FACTION_GROUP.Renegade,
	[SERVER_PLAYER_TEAM.Neutral] = PLAYER_FACTION_GROUP.Neutral,
}

PLAYER_FACTION_LANGUAGE = {
	[PLAYER_FACTION_GROUP.Horde] = LANGUAGE_HORDE,
	[PLAYER_FACTION_GROUP.Alliance] = LANGUAGE_ALLIANCE,
	[PLAYER_FACTION_GROUP.Renegade] = LANGUAGE_RENEGADE,
}

BAG_ITEM_QUALITY_COLORS = {
	[LE_ITEM_QUALITY_COMMON] = CreateColor(0.65882, 0.65882, 0.65882),
	[LE_ITEM_QUALITY_UNCOMMON] = CreateColor(0.08235, 0.70196, 0),
	[LE_ITEM_QUALITY_RARE] = CreateColor(0, 0.56863, 0.94902),
	[LE_ITEM_QUALITY_EPIC] = CreateColor(0.78431, 0.27059, 0.98039),
	[LE_ITEM_QUALITY_LEGENDARY] = CreateColor(1, 0.50196, 0),
	[LE_ITEM_QUALITY_ARTIFACT] = CreateColor(0.90196, 0.8, 0.50196),
	[LE_ITEM_QUALITY_HEIRLOOM] = CreateColor(0.90196, 0.8, 0.50196),
	[LE_ITEM_QUALITY_WOW_TOKEN] = CreateColor(0, 0.8, 1),
}

BLACK_MARKET_ITEM_QUALITY_COLORS = {
	[LE_ITEM_QUALITY_POOR] = CreateColor(0.65882, 0.65882, 0.65882),
	[LE_ITEM_QUALITY_COMMON] = CreateColor(1, 1, 1),
	[LE_ITEM_QUALITY_UNCOMMON] = CreateColor(0.08235, 0.70196, 0),
	[LE_ITEM_QUALITY_RARE] = CreateColor(0, 0.56863, 0.94902),
	[LE_ITEM_QUALITY_EPIC] = CreateColor(0.78431, 0.27059, 0.98039),
	[LE_ITEM_QUALITY_LEGENDARY] = CreateColor(1, 0.50196, 0),
	[LE_ITEM_QUALITY_ARTIFACT] = CreateColor(0.90196, 0.8, 0.50196),
	[LE_ITEM_QUALITY_HEIRLOOM] = CreateColor(0.90196, 0.8, 0.50196),
	[LE_ITEM_QUALITY_WOW_TOKEN] = CreateColor(0, 0.8, 1),
}

MAX_PLAYER_LEVEL_TABLE = {}
MAX_PLAYER_LEVEL_TABLE[LE_EXPANSION_CLASSIC] = 60
MAX_PLAYER_LEVEL_TABLE[LE_EXPANSION_BURNING_CRUSADE] = 70
MAX_PLAYER_LEVEL_TABLE[LE_EXPANSION_WRATH_OF_THE_LICH_KING] = 80
MAX_PLAYER_LEVEL_TABLE[LE_EXPANSION_CATACLYSM] = 85
MAX_PLAYER_LEVEL_TABLE[LE_EXPANSION_MISTS_OF_PANDARIA] = 90
MAX_PLAYER_LEVEL_TABLE[LE_EXPANSION_WARLORDS_OF_DRAENOR] = 100
MAX_PLAYER_LEVEL_TABLE[LE_EXPANSION_LEGION] = 110

DRESSUPMODEL_CAMERA_POSITION = {
	["Human2"]			= {0.691, 1.018, 0.999},
	["Human3"]			= {0.487, 0.985, 0.999},
	["Dwarf2"]			= {1.767, 0.993, 0.845},
	["Dwarf3"]			= {0.794, 0.960, 1.050},
	["NightElf2"]		= {0.341, 0.996, 0.999},
	["NightElf3"]		= {1.255, 0.981, 1.000},
	["Gnome2"]			= {0.948, 1.000, 0.896},
	["Gnome3"]			= {0.794, 0.997, 0.894},
	["Draenei2"]		= {1.348, 1.000, 1.049},
	["Draenei3"]		= {0.743, 0.971, 0.999},
	["Worgen2"]			= {1, 1, 1},
	["Worgen3"]			= {1, 1, 1},
	["Queldo2"]			= {1.101, 1.013, 1.000},
	["Queldo3"]			= {0.640, 1.101, 0.971},
	["VoidElf2"]		= {1.000, 1.000, 1.000},
	["VoidElf3"]		= {1.000, 1.000, 1.000},
	["DarkIronDwarf2"]	= {1.000, 1.000, 1.000},
	["DarkIronDwarf3"]	= {1.000, 1.000, 1.000},
	["Lightforged2"]	= {1.000, 1.000, 1.000},
	["Lightforged3"]	= {1.000, 1.000, 1.000},

	["Orc2"]			= {0.743, 1.044, 1.000},
	["Orc3"]			= {0.743, 0.988, 1.000},
	["Scourge2"]		= {0.896, 1.024, 1.000},
	["Scourge3"]		= {1.767, 1.019, 1.050},
	["Tauren2"]			= {1.665, 0.996, 0.948},
	["Tauren3"]			= {0.691, 1.031, 0.896},
	["Troll2"]			= {1.050, 0.958, 1.000},
	["Troll3"]			= {0.794, 0.930, 0.999},
	["Goblin2"]			= {0.691, 1.003, 0.794},
	["Goblin3"]			= {0.896, 1.000, 0.896},
	["Naga2"]			= {1.357, 1.063, 1.101},
	["Naga3"]			= {1.562, 1.057, 1.050},
	["BloodElf2"]		= {1.101, 1.013, 1.000},
	["BloodElf3"]		= {0.640, 1.101, 0.971},
	["Nightborne2"]		= {1.000, 1.000, 1.000},
	["Nightborne3"]		= {1.000, 1.000, 1.000},
	["Eredar2"]			= {1.000, 1.000, 1.000},
	["Eredar3"]			= {1.000, 1.000, 1.000},
	["ZandalariTroll2"]	= {1.000, 1.000, 1.000},
	["ZandalariTroll3"]	= {1.000, 1.000, 1.000},

	["Pandaren2"]		= {0.480, 1.060, 0.950},
	["Pandaren3"]		= {0.480, 0.980, 1.000},
	["Vulpera2"]		= {1.400, 1.000, 0.880},
	["Vulpera3"]		= {1.400, 1.000, 0.880},
	["Dracthyr2"]		= {1.100, 0.870, 0.950},
	["Dracthyr3"]		= {0.485, 0.985, 1.000},
}

TABARDMODEL_CAMERA_POSITION = {
	["Human2"]			= {-0.310, -0.170, 0.100},
	["Human3"]			= {-0.510, -0.200, 0.170},
	["Dwarf2"]			= {0.770, -0.160, -0.080},
	["Dwarf3"]			= {-0.210, -0.120, 0.110},
	["NightElf2"]		= {-1.000, -0.140, 0.260},
	["NightElf3"]		= {0.260, -0.430, 0.070},
	["Gnome2"]			= {-0.100, -0.095, 0.040},
	["Gnome3"]			= {-0.210, -0.090, -0.020},
	["Draenei2"]		= {0.340, -0.180, 0.100},
	["Draenei3"]		= {0.340, -0.360, 0.100},
	["Worgen2"]			= {-0.750, 0.090, 0.030},
	["Worgen3"]			= {-0.470, -0.170, 0.170, 15},
	["Queldo2"]			= {0.100, -0.280, 0.040},
	["Queldo3"]			= {-0.360, -0.280, 0.070},
	["VoidElf2"]		= {0.000, -0.290, 0.020, 10},
	["VoidElf3"]		= {0.000, -0.250, 0.150},
	["DarkIronDwarf2"]	= {-0.180, -0.110, -0.130},
	["DarkIronDwarf3"]	= {-0.840, -0.120, 0.010},
	["Lightforged2"]	= {0.000, -0.200, 0.030},
	["Lightforged3"]	= {-0.300, -0.420, 0.120},

	["Orc2"]			= {-0.550, -0.010, 0.000},
	["Orc3"]			= {-0.260, -0.180, 0.170},
	["Scourge2"]		= {-0.100, -0.110, 0.150},
	["Scourge3"]		= {0.770, -0.300, 0.070},
	["Tauren2"]			= {0.670, -0.130, 0.080},
	["Tauren3"]			= {-0.360, -0.180, 0.090},
	["Troll2"]			= {0.050, -0.250, 0.150},
	["Troll3"]			= {-0.200, -0.320, 0.230},
	["Goblin2"]			= {-0.310, -0.140, -0.190},
	["Goblin3"]			= {-0.100, -0.150, -0.090},
	["Naga2"]			= {0.360, -0.010, 0.160},
	["Naga3"]			= {0.560, -0.240, 0.030},
	["BloodElf2"]		= {0.000, -0.290, 0.020},
	["BloodElf3"]		= {-0.360, -0.280, 0.070},
	["Nightborne2"]		= {0.000, -0.350, 0.040},
	["Nightborne3"]		= {0.000, -0.330, 0.000},
	["Eredar2"]			= {0.000, -0.190, 0.030},
	["Eredar3"]			= {0.000, -0.390, 0.180},
	["ZandalariTroll2"]	= {0.000, -0.310, 0.120},
	["ZandalariTroll3"]	= {0.000, -0.380, 0.120},

	["Pandaren2"]		= {-0.800, 0.020, -0.070},
	["Pandaren3"]		= {-0.800, -0.130, 0.180},
	["Vulpera2"]		= {0.300, -0.190, -0.120},
	["Vulpera3"]		= {0.500, -0.170, -0.120},
	["Dracthyr2"]		= {0.000, -0.290, 0.020},
	["Dracthyr3"]		= {-0.510, -0.200, 0.170},
}

SHARED_CONSTANTS_SPECIALIZATION = {
	["HUNTER"] = {
		{
			name = "Повелитель зверей",
			icon = "Interface\\Icons\\ABILITY_HUNTER_BESTIALDISCIPLINE",
			role = "DAMAGER",
			description = "Знаток зверей, который умеет приручать животных разных видов и использовать их в сражении."
		},
		{
			name = "Стрельба",
			icon = "Interface\\Icons\\Ability_Marksmanship",
			role = "DAMAGER",
			description = "Меткий стрелок, с которым никто не сравнится в стрельбе с большого расстояния."
		},
		{
			name = "Выживание",
			icon = "Interface\\Icons\\Ability_Hunter_SwiftStrike",
			role = "DAMAGER",
			description = "Следопыт, который предпочитает использовать яды, взрывчатку и ловушки."
		},
	},
	["WARRIOR"] = {
		{
			name = "Оружие",
			icon = "Interface\\Icons\\ability_warrior_savageblow",
			role = "DAMAGER",
			description = "Закаленный в битвах мастер владения двуручным оружием. В бою полагается на скорость и мощные удары."
		},
		{
			name = "Неистовство",
			icon = "Interface\\Icons\\ability_warrior_innerrage",
			role = "DAMAGER",
			description = "Неистовый берсерк, воюющий с оружием в каждой руке. Обрушивает на врага шквал ударов, способных изрубить его на куски."
		},
		{
			name = "Защита",
			icon = "Interface\\Icons\\ability_warrior_defensivestance",
			role = "TANK",
			description = "Выносливый защитник, который использует щит для защиты себя и своих союзников от вражеских атак."
		},
	},
	["PALADIN"] = {
		{
			name = "Свет",
			icon = "Interface\\Icons\\spell_holy_holybolt",
			role = "HEALER",
			description = "Искусный рыцарь, который призывает силы Света для защиты и исцеления."
		},
		{
			name = "Защита",
			icon = "Interface\\Icons\\ability_paladin_shieldofthetemplar",
			role = "TANK",
			description = "Бесстрашный хранитель, который использует магию Света для защиты себя и своих союзников от вражеских атак."
		},
		{
			name = "Воздаяние",
			icon = "Interface\\Icons\\spell_holy_auraoflight",
			role = "DAMAGER",
			description = "Борец за справедливость, который вершит правосудие над врагами при помощи оружия и магии Света."
		},
	},
	["ROGUE"] = {
		{
			name = "Ликвидация",
			icon = "Interface\\Icons\\ability_rogue_eviscerate",
			role = "DAMAGER",
			description = "Опаснейший знаток ядов, который расправляется с противниками ударами отравленных кинжалов."
		},
		{
			name = "Бой",
			icon = "Interface\\Icons\\ability_backstab",
			role = "DAMAGER",
			description = "Ловкий и коварный головорез, мастер ближнего боя."
		},
		{
			name = "Скрытность",
			icon = "Interface\\Icons\\ability_stealth",
			role = "DAMAGER",
			description = "Мастер скрытности, в совершенстве владеющий искусством незаметного передвижения, внезапных и смертельных атак."
		},
	},
	["PRIEST"] = {
		{
			name = "Послушание",
			icon = "Interface\\Icons\\spell_holy_powerwordshield",
			role = "HEALER",
			description = "Использует магию для защиты союзников и исцеления их ран."
		},
		{
			name = "Свет",
			icon = "Interface\\Icons\\spell_holy_guardianspirit",
			role = "HEALER",
			description = "Универсальный лекарь, который исцеляет одиночные цели и группы и может лечить даже после смерти."
		},
		{
			name = "Тьма",
			icon = "Interface\\Icons\\spell_shadow_shadowwordpain",
			role = "DAMAGER",
			description = "Для уничтожения врагов пользуется магией Тьмы, предпочитая заклинания, наносящие периодический урон."
		},
	},
	["DEATHKNIGHT"] = {
		{
			name = "Кровь",
			icon = "Interface\\Icons\\spell_deathknight_bloodpresence",
			role = "DAMAGER",
			description = "Темный покоритель, который сдерживает натиск врагов, поглощая их жизненную энергию и усиливая ею свои атаки."
		},
		{
			name = "Лед",
			icon = "Interface\\Icons\\spell_deathknight_frostpresence",
			role = "DAMAGER",
			description = "Безжалостный вестник рока, использующий силу рун и наносящий молниеносные удары оружием."
		},
		{
			name = "Нечестивость",
			icon = "Interface\\Icons\\spell_deathknight_unholypresence",
			role = "DAMAGER",
			description = "Повелитель смерти и разложения, распространяющий болезни и управляющий прислужниками-нежитью."
		},
		{
			name = "Защитник",
			icon = "Interface\\Icons\\spell_deathknight_bloodpresence",
			iconDesaturate = true,
			role = "TANK",
			description = "Страж смерти, использующий против противников физическую мощь, магию тьмы или льда, а также обращающий их жизненную силу себе на пользу.\nСпособен обращаться к заклинаниям для укрепления своей защиты. Использует в ближнем бою двуручное оружие либо парное одноручное оружие.",
		},
	},
	["SHAMAN"] = {
		{
			name = "Стихии",
			icon = "Interface\\Icons\\spell_nature_lightning",
			role = "DAMAGER",
			description = "Заклинатель, который подчиняет себе разрушительные силы стихий."
		},
		{
			name = "Совершенствование",
			icon = "Interface\\Icons\\spell_nature_lightningshield",
			role = "DAMAGER",
			description = "Боец, использующий тотемы и разящий врагов оружием, усиленным духами стихий."
		},
		{
			name = "Исцеление",
			icon = "Interface\\Icons\\spell_nature_magicimmunity",
			role = "HEALER",
			description = "Лекарь, который взывает к духам предков и очистительной силе воды, чтобы исцелить раны союзников."
		},
	},
	["MAGE"] = {
		{
			name = "Тайная магия",
			icon = "Interface\\Icons\\spell_holy_magicalsentry",
			role = "DAMAGER",
			description = "Управляет энергией тайной магии, повелевая временем и пространством."
		},
		{
			name = "Огонь",
			icon = "Interface\\Icons\\spell_fire_firebolt02",
			role = "DAMAGER",
			description = "Испепеляет врагов огненными шарами и дыханием драконов."
		},
		{
			name = "Лед",
			icon = "Interface\\Icons\\spell_frost_frostbolt02",
			role = "DAMAGER",
			description = "Используя магию льда, замораживает врагов и разбивает их вдребезги."
		},
	},
	["WARLOCK"] = {
		{
			name = "Колдовство",
			icon = "Interface\\Icons\\spell_shadow_deathcoil",
			role = "DAMAGER",
			description = "Знаток темной магии, умеющий устрашать врагов, вытягивать из них силы и наносить периодический урон."
		},
		{
			name = "Демонология",
			icon = "Interface\\Icons\\spell_shadow_metamorphosis",
			role = "DAMAGER",
			description = "Одинаково хорошо владеет магией огня и Тьмы, пользуется поддержкой могущественных демонов."
		},
		{
			name = "Разрушение",
			icon = "Interface\\Icons\\spell_shadow_rainoffire",
			role = "DAMAGER",
			description = "Призывает демоническое пламя, опаляющее и уничтожающее врагов."
		},
	},
	["DRUID"] = {
		{
			name = "Баланс",
			icon = "Interface\\Icons\\spell_nature_starfall",
			role = "DAMAGER",
			description = "Обращается в мудрого совуха, и, балансируя между силами тайной магии и магии природы, уничтожает врагов на расстоянии."
		},
		{
			name = "Сила зверя",
			icon = "Interface\\Icons\\Ability_druid_catform",
			role = "DAMAGER",
			description = "Обращается в кошку, чтобы царапать и кусать врагов, заставляя истекать их кровью, или в могучего медведя, чтобы защищать союзников."
		},
		{
			name = "Исцеление",
			icon = "Interface\\Icons\\spell_nature_healingtouch",
			role = "HEALER",
			description = "Использует целительные заклинания периодического действия, чтобы поддерживать союзников. \nМожет обратиться в дерево, чтобы лечить еще эффективнее."
		},
		{
			name = "Страж",
			icon = "Interface\\Icons\\ability_racial_bearform",
			role = "TANK",
			description = "Принимает облик могучего медведя, в котором поглощает урон и защищает союзников."
		},
	},
}

SHARED_BARTENDER4_MICROMENU_BUTTONS = {
	"CharacterMicroButton",
	"SpellbookMicroButton",
	"TalentMicroButton",
	"AchievementMicroButton",
	"QuestLogMicroButton",
	"SocialsMicroButton",
	"GuildMicroButton",
	"LFDMicroButton",
	"CollectionsMicroButton",
	"EncounterJournalMicroButton",
	"StoreMicroButton",
	"MainMenuMicroButton",
}

SHARED_MICROMENU_BUTTONS = SHARED_BARTENDER4_MICROMENU_BUTTONS

GUILD_TABARD_EMBLEM_COLOR = {
	[0] = CreateColor(0.40392156862745, 0, 0.12941176470588),
	[1] = CreateColor(0.40392156862745, 0.13725490196078, 0),
	[2] = CreateColor(0.38823529411765, 0.40392156862745, 0),
	[3] = CreateColor(0.31764705882353, 0.40392156862745, 0),
	[4] = CreateColor(0.55686274509804, 0.5921568627451, 0),
	[5] = CreateColor(0.55686274509804, 0.5921568627451, 0),
	[6] = CreateColor(0.2156862745098, 0.40392156862745, 0),
	[7] = CreateColor(0, 0.40392156862745, 0.12156862745098),
	[8] = CreateColor(0, 0.40392156862745, 0.34117647058824),
	[9] = CreateColor(0, 0.28235294117647, 0.40392156862745),
	[10] = CreateColor(0.035294117647059, 0.16470588235294, 0.36470588235294),
	[11] = CreateColor(0.42745098039216, 0, 0.46666666666667),
	[12] = CreateColor(0.36470588235294, 0.035294117647059, 0.30980392156863),
	[13] = CreateColor(0.32941176470588, 0.2156862745098, 0.03921568627451),
	[14] = CreateColor(1, 1, 1),
	[15] = CreateColor(0.062745098039216, 0.082352941176471, 0.090196078431373),
	[16] = CreateColor(0.87450980392157, 0.64705882352941, 0.35294117647059),
}

GUILD_TABARD_BORDER_COLOR = {
	["ALL"] = GUILD_TABARD_EMBLEM_COLOR,
	[1] = {
		[0] = CreateColor(0.40392156862745, 0, 0.12941176470588),
		[1] = CreateColor(0.40392156862745, 0.13725490196078, 0),
		[2] = CreateColor(0.38823529411765, 0.40392156862745, 0),
		[3] = CreateColor(0.76078431372549, 0.63137254901961, 0.3921568627451),
		[4] = CreateColor(0.76470588235294, 0.76470588235294, 0.76470588235294),
		[5] = CreateColor(0, 0.40392156862745, 0.34117647058824),
		[6] = CreateColor(0.082352941176471, 0.72549019607843, 1),
		[7] = CreateColor(0.2, 0.67450980392157, 0.95686274509804),
		[8] = CreateColor(0.50196078431373, 0.50196078431373, 1),
		[9] = CreateColor(0.1843137254902, 0.22352941176471, 0.34901960784314),
		[10] = CreateColor(0.37647058823529, 0.24705882352941, 0.41176470588235),
		[11] = CreateColor(0.42745098039216, 0.13725490196078, 0.32941176470588),
		[12] = CreateColor(0.37254901960784, 0.12156862745098, 0.29019607843137),
		[13] = CreateColor(0.77647058823529, 0.4156862745098, 0.14901960784314),
		[14] = CreateColor(0.64313725490196, 0.57647058823529, 0.45882352941176),
		[15] = CreateColor(0.27843137254902, 0.41176470588235, 0.43921568627451),
		[16] = CreateColor(0.83921568627451, 0.81960784313725, 0.094117647058824),
	}
}

GUILD_TABARD_BACKGROUND_COLOR = {
	[0] = CreateColor(1, 0.21960784313725, 0.98039215686275),
	[1] = CreateColor(1, 0.12549019607843, 0.53333333333333),
	[2] = CreateColor(0.40392156862745, 0, 0.12941176470588),
	[3] = CreateColor(1, 0.53725490196078, 0.10588235294118),
	[4] = CreateColor(0.88235294117647, 0.27058823529412, 0),
	[5] = CreateColor(0.69411764705882, 0, 0.18039215686275),
	[6] = CreateColor(0.76862745098039, 0.6078431372549, 0),
	[7] = CreateColor(1, 0.53725490196078, 0.10588235294118),
	[8] = CreateColor(0.68235294117647, 0.29411764705882, 0),
	[9] = CreateColor(0.95294117647059, 0.7921568627451, 0),
	[10] = CreateColor(0.76862745098039, 0.6078431372549, 0),
	[11] = CreateColor(0.5843137254902, 0.42352941176471, 0),
	[12] = CreateColor(1, 1, 0.07843137254902),
	[13] = CreateColor(0.8156862745098, 0.8156862745098, 0.07843137254902),
	[14] = CreateColor(0.63137254901961, 0.63137254901961, 0.07843137254902),
	[15] = CreateColor(0.73725490196078, 0.96470588235294, 0.10588235294118),
	[16] = CreateColor(0.55686274509804, 0.5921568627451, 0),
	[17] = CreateColor(0.34509803921569, 0.50196078431373, 0),
	[18] = CreateColor(0.53333333333333, 0.72941176470588, 0.011764705882353),
	[19] = CreateColor(0.38823529411765, 0.63921568627451, 0),
	[20] = CreateColor(0, 0.50980392156863, 0.058823529411765),
	[21] = CreateColor(0.11764705882353, 1, 0.4078431372549),
	[22] = CreateColor(0.015686274509804, 0.76470588235294, 0.27843137254902),
	[23] = CreateColor(0, 0.40392156862745, 0.12156862745098),
	[24] = CreateColor(0.11764705882353, 0.96862745098039, 0.75686274509804),
	[25] = CreateColor(0.015686274509804, 0.71764705882353, 0.56078431372549),
	[26] = CreateColor(0, 0.56470588235294, 0.38039215686275),
	[27] = CreateColor(0.12941176470588, 0.86274509803922, 1),
	[28] = CreateColor(0, 0.6156862745098, 0.77254901960784),
	[29] = CreateColor(0, 0.38823529411765, 0.56862745098039),
	[30] = CreateColor(0.30196078431373, 0.55686274509804, 0.85490196078431),
	[31] = CreateColor(0.17254901960784, 0.4156862745098, 0.68235294117647),
	[32] = CreateColor(0, 0.2078431372549, 0.50980392156863),
	[33] = CreateColor(0.82745098039216, 0.29019607843137, 0.7843137254902),
	[34] = CreateColor(0.67843137254902, 0.16078431372549, 0.67450980392157),
	[35] = CreateColor(0.52549019607843, 0.058823529411765, 0.60392156862745),
	[36] = CreateColor(0.9921568627451, 0, 0.65098039215686),
	[37] = CreateColor(0.82745098039216, 0, 0.52941176470588),
	[38] = CreateColor(0.63921568627451, 0, 0.4078431372549),
	[39] = CreateColor(1, 0.12549019607843, 0.53333333333333),
	[40] = CreateColor(0.61960784313725, 0, 0.21176470588235),
	[41] = CreateColor(0.40392156862745, 0, 0.12941176470588),
	[42] = CreateColor(0.52941176470588, 0.33333333333333, 0.074509803921569),
	[43] = CreateColor(0.32941176470588, 0.2156862745098, 0.03921568627451),
	[44] = CreateColor(0.30980392156863, 0.13725490196078, 0),
	[45] = CreateColor(0.13725490196078, 0.13725490196078, 0.13725490196078),
	[46] = CreateColor(0.50196078431373, 0.50196078431373, 0.50196078431373),
	[47] = CreateColor(0.70588235294118, 0.73333333333333, 0.65882352941176),
	[48] = CreateColor(0.84313725490196, 0.86666666666667, 0.79607843137255),
	[49] = CreateColor(1, 1, 1),
	[50] = CreateColor(0.98823529411765, 0.4078431372549, 0.56862745098039),
}

SHARED_TABARD_EMBLEM_COLOR = {
	[0] = {103, 0, 33},
	[1] = {103, 35, 0},
	[2] = {99, 103, 0},
	[3] = {81, 103, 0},
	[4] = {142, 151, 0},
	[5] = {142, 151, 0},
	[6] = {55, 103, 0},
	[7] = {0, 103, 31},
	[8] = {0, 103, 87},
	[9] = {0, 72, 103},
	[10] = {9, 42, 93},
	[11] = {109, 0, 119},
	[12] = {93, 9, 79},
	[13] = {84, 55, 10},
	[14] = {255, 255, 255},
	[15] = {16, 21, 23},
	[16] = {223, 165, 90}
}

SHARED_TABARD_BORDER_COLOR = {
	["ALL"] = {
		[0] = {103, 0, 33},
		[1] = {103, 35, 0},
		[2] = {99, 103, 0},
		[3] = {81, 103, 0},
		[4] = {142, 151, 0},
		[5] = {142, 151, 0},
		[6] = {55, 103, 0},
		[7] = {0, 103, 31},
		[8] = {0, 103, 87},
		[9] = {0, 72, 103},
		[10] = {9, 42, 93},
		[11] = {109, 0, 119},
		[12] = {93, 9, 79},
		[13] = {84, 55, 10},
		[14] = {255, 255, 255},
		[15] = {16, 21, 23},
		[16] = {223, 165, 90}
	},
	[1] = {
		[0] = {103, 0, 33},
		[1] = {103, 35, 0},
		[2] = {99, 103, 0},
		[3] = {194, 161, 100},
		[4] = {195, 195, 195},
		[5] = {0, 103, 87},
		[6] = {21, 185, 255},
		[7] = {51, 172, 244},
		[8] = {128, 128, 255},
		[9] = {47, 57, 89},
		[10] = {96, 63, 105},
		[11] = {109, 35, 84},
		[12] = {95, 31, 74},
		[13] = {198, 106, 38},
		[14] = {164, 147, 117},
		[15] = {71, 105, 112},
		[16] = {214, 209, 24},
	}
}

SHARED_TABARD_BACKGROUND_COLOR = {
	[50] = {252, 104, 145},
	[49] = {255, 255, 255},
	[48] = {215, 221, 203},
	[47] = {180, 187, 168},
	[46] = {128, 128, 128},
	[45] = {35, 35, 35},
	[44] = {79, 35, 0},
	[43] = {84, 55, 10},
	[42] = {135, 85, 19},
	[41] = {103, 0, 33},
	[40] = {158, 0, 54},
	[39] = {255, 32, 136},
	[38] = {163, 0, 104},
	[37] = {211, 0, 135},
	[36] = {253, 0, 166},
	[35] = {134, 15, 154},
	[34] = {173, 41, 172},
	[33] = {211, 74, 200},
	[32] = {0, 53, 130},
	[31] = {44, 106, 174},
	[30] = {77, 142, 218},
	[29] = {0, 99, 145},
	[28] = {0, 157, 197},
	[27] = {33, 220, 255},
	[26] = {0, 144, 97},
	[25] = {4, 183, 143},
	[24] = {30, 247, 193},
	[23] = {0, 103, 31},
	[22] = {4, 195, 71},
	[21] = {30, 255, 104},
	[20] = {0, 130, 15},
	[19] = {99, 163, 0},
	[18] = {136, 186, 3},
	[17] = {88, 128, 0},
	[16] = {142, 151, 0},
	[15] = {188, 246, 27},
	[14] = {161, 161, 20},
	[13] = {208, 208, 20},
	[12] = {255, 255, 20},
	[11] = {149, 108, 0},
	[10] = {196, 155, 0},
	[9] = {243, 202, 0},
	[8] = {174, 75, 0},
	[7] = {255, 137, 27},
	[6] = {196, 155, 0},
	[5] = {177, 0, 46},
	[4] = {225, 69, 0},
	[3] = {255, 137, 27},
	[2] = {103, 0, 33},
	[1] = {255, 32, 136},
	[0] = {255, 56, 250}
}

SHARED_INVTYPE_BY_ID = {
	[0] = "",
	[1] = "INVTYPE_HEAD",
	[2] = "INVTYPE_NECK",
	[3] = "INVTYPE_SHOULDER",
	[4] = "INVTYPE_BODY",
	[5] = "INVTYPE_CHEST",
	[6] = "INVTYPE_WAIST",
	[7] = "INVTYPE_LEGS",
	[8] = "INVTYPE_FEET",
	[9] = "INVTYPE_WRIST",
	[10] = "INVTYPE_HAND",
	[11] = "INVTYPE_FINGER",
	[12] = "INVTYPE_TRINKET",
	[13] = "INVTYPE_WEAPON",
	[14] = "INVTYPE_SHIELD",
	[15] = "INVTYPE_RANGED",
	[16] = "INVTYPE_CLOAK",
	[17] = "INVTYPE_2HWEAPON",
	[18] = "INVTYPE_BAG",
	[19] = "INVTYPE_TABARD",
	[20] = "INVTYPE_ROBE",
	[21] = "INVTYPE_WEAPONMAINHAND",
	[22] = "INVTYPE_WEAPONOFFHAND",
	[23] = "INVTYPE_HOLDABLE",
	[24] = "INVTYPE_AMMO",
	[25] = "INVTYPE_THROWN",
	[26] = "INVTYPE_RANGEDRIGHT",
	[27] = "INVTYPE_QUIVER",
	[28] = "INVTYPE_RELIC",
}

SIRUS_TALENT_INFO = {
	["default"] = {
		[1] = {
			color = {r=1.0, g=0.72, b=0.1},
		},
		[2] = {
			color = {r=1.0, g=0.0, b=0.0},
		},
		[3] = {
			color = {r=0.3, g=0.5, b=1.0},
		}
	},
	["PET_409"] = {
		-- Tenacity
		[1] = {
			color = {r=1.0, g=0.1, b=1.0},
		}
	},

	["PET_410"] = {
		-- Ferocity
		[1] = {
			color = {r=1.0, g=0.0, b=0.0},
		}
	},

	["PET_411"] = {
		-- Cunning
		[1] = {
			color = {r=0.0, g=0.6, b=1.0},
		}
	},
	["DEATHKNIGHT"] = {
		[1] = {
			-- Blood
			ActiveBonus = {55262},
			PassiveBonus = {50029, 49395, 53138},
			Description = "Темный защитник, который сдерживает натиск врагов, или поражает их неистовыми атаками, подпитывая себя за счет их жизненной энергии.",
			color = {r=1.0, g=0.0, b=0.0},
			role = 5 -- Damager + Tank
		},
		[2] = {
			-- Frost
			ActiveBonus = {55268},
			PassiveBonus = {54637, 66192, 51130},
			Description = "Безжалостный вестник рока, использующий силу рун и наносящий молниеносные удары оружием.",
			color = {r=0.3, g=0.5, b=1.0},
			role = 5 -- Damager + Tank
		},
		[3] = {
			-- Unholy
			ActiveBonus = {55271},
			PassiveBonus = {51161, 56835, 49655},
			Description = "Повелитель смерти и разложения, распространяющий болезни и управляющий прислужниками-нежитью.",
			color = {r=0.2, g=0.8, b=0.2},
			role = 1 -- Damager
		}
	},

	["DRUID"] = {
		[1] = {
			-- Balance
			ActiveBonus = {53201},
			PassiveBonus = {48525, 33607, 48393},
			Description = "Обращается в мудрого совуха, и, балансируя между силами тайной магии и магии природы, уничтожает врагов на расстоянии.",
			color = {r=0.8, g=0.3, b=0.8},
			role = 1 -- Damager
		},
		[2] = {
			-- Feral
			ActiveBonus = {50334},
			PassiveBonus = {51269, 33856, 24894},
			Description = "Обращается в кошку, чтобы царапать и кусать врагов, заставляя истекать их кровью, или в могучего медведя, чтобы защищать союзников.",
			color = {r=1.0, g=0.0, b=0.0},
			role = 5 -- Damager+Tank
		},
		[3] = {
			-- Restoration
			ActiveBonus = {18562},
			PassiveBonus = {48537, 51183, 34153},
			Description = "Использует целительные заклинания периодического действия, чтобы поддерживать союзников. Может обратиться в дерево, чтобы лечить еще эффективнее.",
			color = {r=0.4, g=0.8, b=0.2},
			role = 2 -- Heal
		}
	},

	["HUNTER"] = {
		[1] = {
			-- Beast Mastery
			ActiveBonus = {19574},
			PassiveBonus = {19556, 19620, 34470},
			Description = "Знаток зверей, который умеет приручать животных разных видов и использовать их в сражении.",
			color = {r=1.0, g=0.0, b=0.3},
			role = 1 -- Damager
		},
		[2] = {
			-- Marksmanship
			ActiveBonus = {49050},
			PassiveBonus = {53217, 53224, 53238},
			Description = "Меткий стрелок, с которым никто не сравнится в стрельбе с большого расстояния.",
			color = {r=0.3, g=0.6, b=1.0},
			role = 1 -- Damager
		},
		[3] = {
			-- Survival
			ActiveBonus = {60053},
			PassiveBonus = {56341, 56344, 53304},
			Description = "Следопыт, который предпочитает использовать яды, взрывчатку и ловушки.",
			color = {r=1.0, g=0.6, b=0.0},
			role = 1 -- Damager
		}
	},

	["MAGE"] = {
		[1] = {
			-- Arcane
			ActiveBonus = {12042},
			PassiveBonus = {31588, 54490, 31583},
			Description = "Управляет энергией тайной магии, повелевая временем и пространством.",
			color = {r=0.7, g=0.2, b=1.0},
			role = 1 -- Damager
		},
		[2] = {
			-- Fire
			ActiveBonus = {42891},
			PassiveBonus = {44448, 34296, 31658},
			Description = "Испепеляет врагов огненными шарами и дыханием драконов.",
			color = {r=1.0, g=0.5, b=0.0},
			role = 1 -- Damager
		},
		[3] = {
			-- Frost
			ActiveBonus = {44572},
			PassiveBonus = {44549, 44545, 28593},
			Description = "Используя магию льда, замораживает врагов и разбивает их вдребезги.",
			color = {r=0.3, g=0.6, b=1.0},
			role = 1 -- Damager
		}
	},

	["PALADIN"] = {
		[1] = {
			-- Holy
			ActiveBonus = {48825},
			PassiveBonus = {53576, 31841, 31836},
			Description = "Призывает силы Света для защиты и исцеления.",
			color = {r=1.0, g=0.5, b=0.0},
			role = 2 -- Heal
		},
		[2] = {
			-- Protection
			ActiveBonus = {48827},
			PassiveBonus = {53592, 53585, 33776},
			Description = "Использует магию Света для защиты себя и своих союзников от вражеских атак.",
			color = {r=0.3, g=0.5, b=1.0},
			role = 4 -- Tank
		},
		[3] = {
			-- Retribution
			ActiveBonus = {53385},
			PassiveBonus = {53503, 53488, 31878},
			Description = "Борец за справедливость, который вершит правосудие над врагами при помощи оружия и магии Света.",
			color = {r=1.0, g=0.0, b=0.0},
			role = 1 -- Damager
		}
	},

	["PRIEST"] = {
		[1] = {
			-- Discipline
			ActiveBonus = {53007},
			PassiveBonus = {33202, 47515, 14777},
			Description = "Использует магию для защиты союзников и исцеления их ран.",
			color = {r=1.0, g=0.5, b=0.0},
			role = 2 -- Heal
		},
		[2] = {
			-- Holy
			ActiveBonus = {48089},
			PassiveBonus = {47560, 63543, 15031},
			Description = "Универсальный лекарь, который исцеляет одиночные цели и группы и может лечить даже после смерти.",
			color = {r=0.6, g=0.6, b=1.0},
			role = 2 -- Heal
		},
		[3] = {
			-- Shadow
			ActiveBonus = {48156},
			PassiveBonus = {15332, 33371, 27840},
			Description = "Для уничтожения врагов пользуется магией Тьмы, предпочитая заклинания, наносящие периодический урон.",
			color = {r=0.7, g=0.4, b=0.8},
			role = 1 -- Damager
		}
	},

	["ROGUE"] = {
		[1] = {
			-- Assassination
			ActiveBonus = {48666},
			PassiveBonus = {51636, 51669, 58410},
			Description = "Опаснейший знаток ядов, который расправляется с противниками ударами отравленных кинжалов.",
			color = {r=0.5, g=0.8, b=0.5},
			role = 1 -- Damager
		},
		[2] = {
			-- Combat
			ActiveBonus = {13877},
			PassiveBonus = {61329, 35553, 32601},
			Description = "Ловкий и коварный головорез, мастер ближнего боя.",
			color = {r=1.0, g=0.5, b=0.0},
			role = 1 -- Damager
		},
		[3] = {
			-- Subtlety
			ActiveBonus = {36554},
			PassiveBonus = {31223, 31220},
			Description = "Мастер скрытности, в совершенстве владеющий искусством незаметного передвижения, внезапных и смертельных атак.",
			color = {r=0.3, g=0.5, b=1.0},
			role = 1 -- Damager
		}
	},

	["SHAMAN"] = {
		[1] = {
			-- Elemental
			ActiveBonus = {59159},
			PassiveBonus = {60188, 62101, 51486},
			Description = "Заклинатель, который подчиняет себе разрушительные силы стихий.",
			color = {r=0.8, g=0.2, b=0.8},
			role = 1 -- Damager
		},
		[2] = {
			-- Enhancement
			ActiveBonus = {60103},
			PassiveBonus = {30798, 30814, 30809},
			Description = "Боец, использующий тотемы и разящий врагов оружием, усиленным духами стихий.",
			color = {r=0.3, g=0.5, b=1.0},
			role = 1 -- Damager
		},
		[3] = {
			-- Restoration
			ActiveBonus = {49284},
			PassiveBonus = {16213, 51558, 51566},
			Description = "Лекарь, который взывает к духам предков и очистительной силе воды, чтобы исцелить раны союзников.",
			color = {r=0.2, g=0.8, b=0.4},
			role = 2 -- Heal
		}
	},

	["WARLOCK"] = {
		[1] = {
			-- Affliction
			ActiveBonus = {47843},
			PassiveBonus = {17814, 18829, 63108},
			Description = "Знаток темной магии, умеющий устрашать врагов, вытягивать из них силы и наносить периодический урон.",
			color = {r=0.0, g=1.0, b=0.6},
			role = 1 -- Damager
		},
		[2] = {
			-- Demonology
			ActiveBonus = {30146},
			PassiveBonus = {23825, 18768},
			Description = "Одинаково хорошо владеет магией огня и Тьмы, пользуется поддержкой могущественных демонов.",
			color = {r=1.0, g=0.0, b=0.0},
			role = 1 -- Damager
		},
		[3] = {
			-- Destruction
			ActiveBonus = {17962},
			PassiveBonus = {63245, 17834},
			Description = "Призывает демоническое пламя, опаляющее и уничтожающее врагов.",
			color = {r=1.0, g=0.5, b=0.0},
			role = 1 -- Damager
		}
	},

	["WARRIOR"] = {
		[1] = {
			-- Arms
			ActiveBonus = {47486},
			PassiveBonus = {12712, 46855},
			Description = "Закаленный в битвах мастер владения двуручным оружием. В бою полагается на скорость и мощные удары.",
			color = {r=1.0, g=0.72, b=0.1},
			role = 1 -- Damager
		},
		[2] = {
			-- Fury
			ActiveBonus = {23881},
			PassiveBonus = {23588, 46917},
			Description = "Неистовый берсерк, воюющий с оружием в каждой руке. Обрушивает на врага шквал ударов, способных изрубить его на куски.",
			color = {r=1.0, g=0.0, b=0.0},
			role = 1 -- Damager
		},
		[3] = {
			-- Protection
			ActiveBonus = {23922},
			PassiveBonus = {29144, 12727, 47296},
			Description = "Использует щит для защиты себя и своих союзников от вражеских атак.",
			color = {r=0.3, g=0.5, b=1.0},
			role = 4 -- Tank
		}
	},
	["DEMONHUNTER"] = {
		[1] = {
			-- Сокрушение
			ActiveBonus = {302405},
			PassiveBonus = {302452, 302455, 302468},
			Description = "PH_DemonHunter_description_1.",
			color = {r=50 / 255, g=205 / 255, b=50/255},
			role = 1 -- Damager
		},
		[2] = {
			-- Месть
			ActiveBonus = {302620},
			PassiveBonus = {302618, 302612, 302631},
			Description = "PH_DemonHunter_description_2.",
			color = {r=105 / 255, g=105 / 255, b=105 / 255},
			role = 4 -- Tank
		},
		[3] = {
			-- Одержимость
			ActiveBonus = {302585},
			PassiveBonus = {302511, 302551, 302581},
			Description = "Фанатичный борец с демонами, искусно владеющий как клинками, так и темной магией. Поражая душу и тело противника, он призывает могущественных слуг.",
			color = {r=147 / 255, g=112 / 255, b=219 / 255},
			role = 1 -- Damager
		}
	},
}

CLASS_ID_WARRIOR = 1
CLASS_ID_PALADIN = 2
CLASS_ID_HUNTER = 3
CLASS_ID_ROGUE = 4
CLASS_ID_PRIEST = 5
CLASS_ID_DEATHKNIGHT = 6
CLASS_ID_SHAMAN = 7
CLASS_ID_MAGE = 8
CLASS_ID_WARLOCK = 9
CLASS_ID_DEMONHUNTER = 10
CLASS_ID_DRUID = 11

S_SPECIALIZATION_ROLE_DAMAGER_FLAG = 0x1
S_SPECIALIZATION_ROLE_TANK_FLAG = 0x2
S_SPECIALIZATION_ROLE_HEAL_FLAG = 0x4

S_SPECIALIZATION_FLAG_SPEC1 = 0x1
S_SPECIALIZATION_FLAG_SPEC2 = 0x2
S_SPECIALIZATION_FLAG_SPEC3 = 0x4

S_CLASS_SORT_ORDER = {
	[1] = {1, "WARRIOR"},
	[2] = {2, "PALADIN"},
	[3] = {4, "HUNTER"},
	[4] = {8, "ROGUE"},
	[5] = {16, "PRIEST"},
	[6] = {32, "DEATHKNIGHT"},
	[7] = {64, "SHAMAN"},
	[8] = {128, "MAGE"},
	[9] = {256, "WARLOCK"},
	[10] = {512, "DEMONHUNTER"},
	[11] = {1024, "DRUID"},
}

S_CLASS_DATA_LOCALIZATION_ASSOC = {}

do
	for index, classData in pairs(S_CLASS_SORT_ORDER) do
		local keyMale = _G["SHARED_"..classData[2].."_MALE"]
		local keyFemale = _G["SHARED_"..classData[2].."_FEMALE"]

		classData[3] = index
		classData[4] = keyMale
		classData[5] = keyFemale

		S_CLASS_DATA_LOCALIZATION_ASSOC[keyMale] = classData
		S_CLASS_DATA_LOCALIZATION_ASSOC[keyFemale] = classData
	end
end

S_MAX_CLASSES = #S_CLASS_SORT_ORDER

S_CALSS_SPECIALIZATION_DATA = {
	[CLASS_ID_WARRIOR] = { -- WARRIOR
		{161, WARRIOR_SPEC_ARMS_TITLE, WARRIOR_SPEC_ARMS_DESC, "Interface\\Icons\\Ability_Rogue_Eviscerate", S_SPECIALIZATION_ROLE_DAMAGER_FLAG, false},
		{164, WARRIOR_SPEC_FURY_TITLE, WARRIOR_SPEC_FURY_DESC, "Interface\\Icons\\Ability_Warrior_InnerRage", S_SPECIALIZATION_ROLE_DAMAGER_FLAG, true},
		{163, WARRIOR_SPEC_PROTECTION_TITLE, WARRIOR_SPEC_PROTECTION_DESC, "Interface\\Icons\\INV_Shield_06", S_SPECIALIZATION_ROLE_TANK_FLAG, false},
	},
	[CLASS_ID_PALADIN] = { -- PALADIN
		{382, PALADIN_SPEC_HOLY_TITLE, PALADIN_SPEC_HOLY_DESC, "Interface\\Icons\\Spell_Holy_HolyBolt", S_SPECIALIZATION_ROLE_HEAL_FLAG, false},
		{383, PALADIN_SPEC_PROTECTION_TITLE, PALADIN_SPEC_PROTECTION_DESC, "Interface\\Icons\\Spell_Holy_DevotionAura", S_SPECIALIZATION_ROLE_TANK_FLAG, false},
		{381, PALADIN_SPEC_RETRIBUTION_TITLE, PALADIN_SPEC_RETRIBUTION_DESC, "Interface\\Icons\\Spell_Holy_AuraOfLight", S_SPECIALIZATION_ROLE_DAMAGER_FLAG, true},
	},
	[CLASS_ID_HUNTER] = { -- HUNTER
		{361, HUNTER_SPEC_BEASTMASTERY_TITLE, HUNTER_SPEC_BEASTMASTERY_DESC, "Interface\\Icons\\Ability_Hunter_BeastTaming", S_SPECIALIZATION_ROLE_DAMAGER_FLAG, true},
		{363, HUNTER_SPEC_MARKSMANSHIP_TITLE, HUNTER_SPEC_MARKSMANSHIP_DESC, "Interface\\Icons\\Ability_Marksmanship", S_SPECIALIZATION_ROLE_DAMAGER_FLAG, false},
		{362, HUNTER_SPEC_SURVIVAL_TITLE, HUNTER_SPEC_SURVIVAL_DESC, "Interface\\Icons\\Ability_Hunter_SwiftStrike", S_SPECIALIZATION_ROLE_DAMAGER_FLAG, false},
	},
	[CLASS_ID_ROGUE] = { -- ROGUE
		{182, ROGUE_SPEC_ASSASSINATION_TITLE, ROGUE_SPEC_ASSASSINATION_DESC, "Interface\\Icons\\Ability_Rogue_Eviscerate", S_SPECIALIZATION_ROLE_DAMAGER_FLAG, true},
		{181, ROGUE_SPEC_COMBAT_TITLE, ROGUE_SPEC_COMBAT_DESC, "Interface\\Icons\\Ability_BackStab", S_SPECIALIZATION_ROLE_DAMAGER_FLAG, false},
		{183, ROGUE_SPEC_SUBTLETY_TITLE, ROGUE_SPEC_SUBTLETY_DESC, "Interface\\Icons\\Ability_Stealth", S_SPECIALIZATION_ROLE_DAMAGER_FLAG, false},
	},
	[CLASS_ID_PRIEST] = { -- PRIEST
		{201, PRIEST_SPEC_DISCIPLINE_TITLE, PRIEST_SPEC_DISCIPLINE_DESC, "Interface\\Icons\\Spell_Holy_WordFortitude", S_SPECIALIZATION_ROLE_HEAL_FLAG, false},
		{202, PRIEST_SPEC_HOLY_TITLE, PRIEST_SPEC_HOLY_DESC, "Interface\\Icons\\Spell_Holy_HolyBolt", S_SPECIALIZATION_ROLE_HEAL_FLAG, false},
		{203, PRIEST_SPEC_SHADOW_TITLE, PRIEST_SPEC_SHADOW_DESC, "Interface\\Icons\\Spell_Shadow_ShadowWordPain", S_SPECIALIZATION_ROLE_DAMAGER_FLAG, true},
	},
	[CLASS_ID_DEATHKNIGHT] = { -- DEATHKNIGHT
		{398, DEATHKNIGHT_SPEC_BLOOD_TITLE,  DEATHKNIGHT_SPEC_BLOOD_DESC, "Interface\\Icons\\Spell_Deathknight_BloodPresence", bit.bor(S_SPECIALIZATION_ROLE_DAMAGER_FLAG, S_SPECIALIZATION_ROLE_TANK_FLAG), true},
		{399, DEATHKNIGHT_SPEC_FROST_TITLE,  DEATHKNIGHT_SPEC_FROST_DESC, "Interface\\Icons\\Spell_Deathknight_FrostPresence", bit.bor(S_SPECIALIZATION_ROLE_DAMAGER_FLAG, S_SPECIALIZATION_ROLE_TANK_FLAG), false},
		{400, DEATHKNIGHT_SPEC_UNHOLY_TITLE, DEATHKNIGHT_SPEC_UNHOLY_DESC, "Interface\\Icons\\Spell_Deathknight_UnholyPresence", bit.bor(S_SPECIALIZATION_ROLE_DAMAGER_FLAG, S_SPECIALIZATION_ROLE_TANK_FLAG), false},
	},
	[CLASS_ID_SHAMAN] = { -- SHAMAN
		{261, SHAMAN_SPEC_ELEMENTAL_TITLE,  SHAMAN_SPEC_ELEMENTAL_DESC, "Interface\\Icons\\Spell_Nature_Lightning", S_SPECIALIZATION_ROLE_DAMAGER_FLAG, true},
		{263, SHAMAN_SPEC_ENHANCEMENT_TITLE,  SHAMAN_SPEC_ENHANCEMENT_DESC, "Interface\\Icons\\Spell_Nature_LightningShield", S_SPECIALIZATION_ROLE_DAMAGER_FLAG, false},
		{262, SHAMAN_SPEC_RESTORATION_TITLE, SHAMAN_SPEC_RESTORATION_DESC, "Interface\\Icons\\Spell_Nature_MagicImmunity", S_SPECIALIZATION_ROLE_HEAL_FLAG, false},
	},
	[CLASS_ID_MAGE] = { -- MAGE
		{81, MAGE_SPEC_ARCANE_TITLE,  MAGE_SPEC_ARCANE_DESC, "Interface\\Icons\\Spell_Holy_MagicalSentry", S_SPECIALIZATION_ROLE_DAMAGER_FLAG, false},
		{41, MAGE_SPEC_FIRE_TITLE,  MAGE_SPEC_FIRE_DESC, "Interface\\Icons\\Spell_Fire_FireBolt02", S_SPECIALIZATION_ROLE_DAMAGER_FLAG, false},
		{61, MAGE_SPEC_FROST_TITLE, MAGE_SPEC_FROST_DESC, "Interface\\Icons\\Spell_Frost_FrostBolt02", S_SPECIALIZATION_ROLE_DAMAGER_FLAG, true},
	},
	[CLASS_ID_WARLOCK] = { -- WARLOCK
		{302, WARLOCK_AFFLICTION_TITLE,  WARLOCK_AFFLICTION_DESC, "Interface\\Icons\\Spell_Shadow_DeathCoil", S_SPECIALIZATION_ROLE_DAMAGER_FLAG, false},
		{303, WARLOCK_DEMONOLOGY_TITLE,  WARLOCK_DEMONOLOGY_DESC, "Interface\\Icons\\Spell_Shadow_Metamorphosis", S_SPECIALIZATION_ROLE_DAMAGER_FLAG, false},
		{301, WARLOCK_DESTRUCTION_TITLE, WARLOCK_DESTRUCTION_DESC, "Interface\\Icons\\Spell_Shadow_RainOfFire", S_SPECIALIZATION_ROLE_DAMAGER_FLAG, true},
	},
	[CLASS_ID_DEMONHUNTER] = { -- DEMONHUNTER
		{504, DEMONHUNTER_HAVOC_TITLE,  DEMONHUNTER_HAVOC_DESC, "Interface\\icons\\Ability_DemonHunter_SpecDPS_1", S_SPECIALIZATION_ROLE_DAMAGER_FLAG, true},
		{505, DEMONHUNTER_REVENGE_TITLE,  DEMONHUNTER_REVENGE_DESC, "Interface\\icons\\Ability_DemonHunter_SpecTank", S_SPECIALIZATION_ROLE_TANK_FLAG, false},
		{506, DEMONHUNTER_POSESSION_TITLE, DEMONHUNTER_POSESSION_DESC, "Interface\\icons\\Ability_DemonHunter_SpecDPS_2", S_SPECIALIZATION_ROLE_DAMAGER_FLAG, false},
	},
	[CLASS_ID_DRUID] = { -- DRUID
		{283, DRUID_BALANCE_TITLE,  DRUID_BALANCE_DESC, "Interface\\Icons\\Spell_Nature_StarFall", S_SPECIALIZATION_ROLE_DAMAGER_FLAG, false},
		{281, DRUID_FERAL_TITLE,  DRUID_FERAL_DESC, "Interface\\Icons\\Ability_Racial_BearForm", bit.bor(S_SPECIALIZATION_ROLE_DAMAGER_FLAG, S_SPECIALIZATION_ROLE_TANK_FLAG), true},
		{282, DRUID_RESTORATION_TITLE, DRUID_RESTORATION_DESC, "Interface\\Icons\\Spell_Nature_HealingTouch", S_SPECIALIZATION_ROLE_HEAL_FLAG, false},
	},
}

S_EXPANSION_DATA = {
	[LE_EXPANSION_CLASSIC] = "Classic",
	[LE_EXPANSION_BURNING_CRUSADE] = "The Burning Crusade",
	[LE_EXPANSION_WRATH_OF_THE_LICH_KING] = "Wrath of Lich King",
	[LE_EXPANSION_CATACLYSM] = "Cataclysm",
	[LE_EXPANSION_MISTS_OF_PANDARIA] = "Mists of Pandaria",
	[LE_EXPANSION_WARLORDS_OF_DRAENOR] = "Warlords of Draenor",
	[LE_EXPANSION_LEGION] = "Legion",
	[LE_EXPANSION_BATTLE_FOR_AZEROTH] = "Battle For Azeroth",
	[LE_EXPANSION_SHADOWLANDS] = "Shadowlands",
}

-- ##################################################################################

E_CHARACTER_RACES = Enum.CreateMirror({
	RACE_HUMAN				= 1,
	RACE_DWARF				= 2,
	RACE_NIGHTELF			= 3,
	RACE_GNOME				= 4,
	RACE_DRAENEI			= 5,
	RACE_WORGEN				= 6,
	RACE_PANDAREN_ALLIANCE	= 7,
	RACE_QUELDO				= 8,
	RACE_VOIDELF			= 9,
	RACE_VULPERA_ALLIANCE	= 10,
	RACE_VULPERA_NEUTRAL	= 11,
	RACE_PANDAREN_NEUTRAL	= 12,
	RACE_LIGHTFORGED		= 13,
	RACE_DARKIRONDWARF		= 14,
	RACE_DRACTHYR			= 15,

	RACE_ORC				= 16,
	RACE_SCOURGE			= 17,
	RACE_TAUREN				= 18,
	RACE_TROLL				= 19,
	RACE_GOBLIN				= 20,
	RACE_BLOODELF			= 21,
	RACE_NAGA				= 22,
	RACE_PANDAREN_HORDE		= 23,
	RACE_NIGHTBORNE			= 24,
	RACE_VULPERA_HORDE		= 25,
	RACE_ZANDALARITROLL		= 26,
	RACE_EREDAR				= 27,

	RACE_HUMAN_CREATURE		= 28,
	RACE_DWARF_CREATURE		= 29,
	RACE_NIGHTELF_CREATURE	= 30,
	RACE_GNOME_CREATURE		= 31,
	RACE_DRAENEI_CREATURE	= 32,
	RACE_FELORC				= 33,
	RACE_NAGA_				= 34,
	RACE_BROKEN				= 35,
	RACE_SKELETON			= 36,
	RACE_VRYKUL				= 37,
	RACE_TUSKARR			= 38,
	RACE_FORESTTROLL		= 39,
	RACE_TAUNKA				= 40,
	RACE_NORTHRENDSKELETON	= 41,
	RACE_ICETROLL			= 42,
	RACE_ORC_CREATURE		= 43,
	RACE_SCOURGE_CREATURE	= 44,
	RACE_TAUREN_CREATURE	= 45,
	RACE_TROLL_CREATURE		= 46,
	RACE_BLOODELF_CREATURE	= 47,
})

E_CHARACTER_RACES_DBC = Enum.CreateMirror({
	RACE_HUMAN				= 1,
	RACE_ORC				= 2,
	RACE_DWARF				= 3,
	RACE_NIGHTELF			= 4,
	RACE_SCOURGE			= 5,
	RACE_TAUREN				= 6,
	RACE_GNOME				= 7,
	RACE_TROLL				= 8,
	RACE_GOBLIN				= 9,
	RACE_BLOODELF			= 10,
	RACE_DRAENEI			= 11,
	RACE_WORGEN				= 12,
	RACE_NAGA				= 13,
	RACE_PANDAREN_ALLIANCE	= 14,
	RACE_QUELDO				= 15,
	RACE_PANDAREN_HORDE		= 16,
	RACE_NIGHTBORNE			= 17,
	RACE_VOIDELF			= 18,
	RACE_VULPERA_ALLIANCE	= 19,
	RACE_VULPERA_HORDE		= 20,
	RACE_VULPERA_NEUTRAL	= 21,
	RACE_PANDAREN_NEUTRAL	= 22,
	RACE_ZANDALARITROLL		= 23,
	RACE_LIGHTFORGED		= 24,
	RACE_EREDAR				= 25,
	RACE_DARKIRONDWARF		= 26,
	RACE_DRACTHYR			= 27,

	RACE_HUMAN_CREATURE		= 33,
	RACE_ORC_CREATURE		= 34,
	RACE_DWARF_CREATURE		= 35,
	RACE_NIGHTELF_CREATURE	= 36,
	RACE_SCOURGE_CREATURE	= 37,
	RACE_TAUREN_CREATURE	= 38,
	RACE_GNOME_CREATURE		= 39,
	RACE_TROLL_CREATURE		= 40,
	RACE_BLOODELF_CREATURE	= 41,
	RACE_DRAENEI_CREATURE	= 42,
	RACE_FELORC				= 43,
	RACE_NAGA_				= 44,
	RACE_BROKEN				= 45,
	RACE_SKELETON			= 46,
	RACE_VRYKUL				= 47,
	RACE_TUSKARR			= 48,
	RACE_FORESTTROLL		= 49,
	RACE_TAUNKA				= 50,
	RACE_NORTHRENDSKELETON	= 51,
	RACE_ICETROLL			= 52,
})

S_CHARACTER_RACES_INFO = {
	[E_CHARACTER_RACES.RACE_HUMAN]				= {raceID = E_CHARACTER_RACES.RACE_HUMAN,				clientFileString = "Human",				raceName = "RACE_HUMAN",				raceNameFemale = nil,								factionID = PLAYER_FACTION_GROUP.Alliance},
	[E_CHARACTER_RACES.RACE_DWARF]				= {raceID = E_CHARACTER_RACES.RACE_DWARF,				clientFileString = "Dwarf",				raceName = "RACE_DWARF",				raceNameFemale = nil,								factionID = PLAYER_FACTION_GROUP.Alliance},
	[E_CHARACTER_RACES.RACE_NIGHTELF]			= {raceID = E_CHARACTER_RACES.RACE_NIGHTELF,			clientFileString = "NightElf",			raceName = "RACE_NIGHTELF",				raceNameFemale = "RACE_NIGHTELF_FEMALE",			factionID = PLAYER_FACTION_GROUP.Alliance},
	[E_CHARACTER_RACES.RACE_GNOME]				= {raceID = E_CHARACTER_RACES.RACE_GNOME,				clientFileString = "Gnome",				raceName = "RACE_GNOME",				raceNameFemale = nil,								factionID = PLAYER_FACTION_GROUP.Alliance},
	[E_CHARACTER_RACES.RACE_DRAENEI]			= {raceID = E_CHARACTER_RACES.RACE_DRAENEI,				clientFileString = "Draenei",			raceName = "RACE_DRAENEI",				raceNameFemale = nil,								factionID = PLAYER_FACTION_GROUP.Alliance},
	[E_CHARACTER_RACES.RACE_WORGEN]				= {raceID = E_CHARACTER_RACES.RACE_WORGEN,				clientFileString = "Worgen",			raceName = "RACE_WORGEN",				raceNameFemale = "RACE_WORGEN_FEMALE",				factionID = PLAYER_FACTION_GROUP.Alliance},
	[E_CHARACTER_RACES.RACE_QUELDO]				= {raceID = E_CHARACTER_RACES.RACE_QUELDO,				clientFileString = "Queldo",			raceName = "RACE_QUELDO",				raceNameFemale = "RACE_QUELDO_FEMALE",				factionID = PLAYER_FACTION_GROUP.Alliance},
	[E_CHARACTER_RACES.RACE_VOIDELF]			= {raceID = E_CHARACTER_RACES.RACE_VOIDELF,				clientFileString = "VoidElf",			raceName = "RACE_VOIDELF",				raceNameFemale = "RACE_VOIDELF_FEMALE",				factionID = PLAYER_FACTION_GROUP.Alliance},
	[E_CHARACTER_RACES.RACE_DARKIRONDWARF]		= {raceID = E_CHARACTER_RACES.RACE_DARKIRONDWARF,		clientFileString = "DarkIronDwarf",		raceName = "RACE_DARKIRONDWARF",		raceNameFemale = "RACE_DARKIRONDWARF_FEMALE",		factionID = PLAYER_FACTION_GROUP.Alliance},
	[E_CHARACTER_RACES.RACE_LIGHTFORGED]		= {raceID = E_CHARACTER_RACES.RACE_LIGHTFORGED,			clientFileString = "Lightforged",		raceName = "RACE_LIGHTFORGED",			raceNameFemale = "RACE_LIGHTFORGED_FEMALE",			factionID = PLAYER_FACTION_GROUP.Alliance},

	[E_CHARACTER_RACES.RACE_ORC]				= {raceID = E_CHARACTER_RACES.RACE_ORC,					clientFileString = "Orc",				raceName = "RACE_ORC",					raceNameFemale = nil,								factionID = PLAYER_FACTION_GROUP.Horde},
	[E_CHARACTER_RACES.RACE_SCOURGE]			= {raceID = E_CHARACTER_RACES.RACE_SCOURGE,				clientFileString = "Scourge",			raceName = "RACE_SCOURGE",				raceNameFemale = "RACE_SCOURGE_FEMALE",				factionID = PLAYER_FACTION_GROUP.Horde},
	[E_CHARACTER_RACES.RACE_TAUREN]				= {raceID = E_CHARACTER_RACES.RACE_TAUREN,				clientFileString = "Tauren",			raceName = "RACE_TAUREN",				raceNameFemale = nil,								factionID = PLAYER_FACTION_GROUP.Horde},
	[E_CHARACTER_RACES.RACE_TROLL]				= {raceID = E_CHARACTER_RACES.RACE_TROLL,				clientFileString = "Troll",				raceName = "RACE_TROLL",				raceNameFemale = nil,								factionID = PLAYER_FACTION_GROUP.Horde},
	[E_CHARACTER_RACES.RACE_GOBLIN]				= {raceID = E_CHARACTER_RACES.RACE_GOBLIN,				clientFileString = "Goblin",			raceName = "RACE_GOBLIN",				raceNameFemale = nil,								factionID = PLAYER_FACTION_GROUP.Horde},
	[E_CHARACTER_RACES.RACE_NAGA]				= {raceID = E_CHARACTER_RACES.RACE_NAGA,				clientFileString = "Naga",				raceName = "RACE_NAGA",					raceNameFemale = "RACE_NAGA_FEMALE",				factionID = PLAYER_FACTION_GROUP.Horde},
	[E_CHARACTER_RACES.RACE_BLOODELF]			= {raceID = E_CHARACTER_RACES.RACE_BLOODELF,			clientFileString = "BloodElf",			raceName = "RACE_BLOODELF",				raceNameFemale = "RACE_BLOODELF_FEMALE",			factionID = PLAYER_FACTION_GROUP.Horde},
	[E_CHARACTER_RACES.RACE_NIGHTBORNE]			= {raceID = E_CHARACTER_RACES.RACE_NIGHTBORNE,			clientFileString = "Nightborne",		raceName = "RACE_NIGHTBORNE",			raceNameFemale = "RACE_NIGHTBORNE_FEMALE",			factionID = PLAYER_FACTION_GROUP.Horde},
	[E_CHARACTER_RACES.RACE_EREDAR]				= {raceID = E_CHARACTER_RACES.RACE_EREDAR,				clientFileString = "Eredar",			raceName = "RACE_EREDAR",				raceNameFemale = "RACE_EREDAR_FEMALE",				factionID = PLAYER_FACTION_GROUP.Horde},
	[E_CHARACTER_RACES.RACE_ZANDALARITROLL]		= {raceID = E_CHARACTER_RACES.RACE_ZANDALARITROLL,		clientFileString = "ZandalariTroll",	raceName = "RACE_ZANDALARITROLL",		raceNameFemale = "RACE_ZANDALARITROLL_FEMALE",		factionID = PLAYER_FACTION_GROUP.Horde},

	[E_CHARACTER_RACES.RACE_PANDAREN_ALLIANCE]	= {raceID = E_CHARACTER_RACES.RACE_PANDAREN_ALLIANCE,	clientFileString = "Pandaren",			raceName = "RACE_PANDAREN_ALLIANCE",	raceNameFemale = "RACE_PANDAREN_ALLIANCE_FEMALE",	factionID = PLAYER_FACTION_GROUP.Alliance},
	[E_CHARACTER_RACES.RACE_PANDAREN_HORDE]		= {raceID = E_CHARACTER_RACES.RACE_PANDAREN_HORDE,		clientFileString = "Pandaren",			raceName = "RACE_PANDAREN_HORDE",		raceNameFemale = "RACE_PANDAREN_HORDE_FEMALE",		factionID = PLAYER_FACTION_GROUP.Horde},
	[E_CHARACTER_RACES.RACE_PANDAREN_NEUTRAL]	= {raceID = E_CHARACTER_RACES.RACE_PANDAREN_NEUTRAL,	clientFileString = "Pandaren",			raceName = "RACE_PANDAREN_NEUTRAL",		raceNameFemale = nil,								factionID = PLAYER_FACTION_GROUP.Neutral},

	[E_CHARACTER_RACES.RACE_VULPERA_ALLIANCE]	= {raceID = E_CHARACTER_RACES.RACE_VULPERA_ALLIANCE,	clientFileString = "Vulpera",			raceName = "RACE_VULPERA_ALLIANCE",		raceNameFemale = "RACE_VULPERA_ALLIANCE_FEMALE",	factionID = PLAYER_FACTION_GROUP.Alliance},
	[E_CHARACTER_RACES.RACE_VULPERA_HORDE]		= {raceID = E_CHARACTER_RACES.RACE_VULPERA_HORDE,		clientFileString = "Vulpera",			raceName = "RACE_VULPERA_HORDE",		raceNameFemale = "RACE_VULPERA_HORDE_FEMALE",		factionID = PLAYER_FACTION_GROUP.Horde},
	[E_CHARACTER_RACES.RACE_VULPERA_NEUTRAL]	= {raceID = E_CHARACTER_RACES.RACE_VULPERA_NEUTRAL,		clientFileString = "Vulpera",			raceName = "RACE_VULPERA_NEUTRAL",		raceNameFemale = "RACE_VULPERA_NEUTRAL_FEMALE",		factionID = PLAYER_FACTION_GROUP.Neutral},

	[E_CHARACTER_RACES.RACE_DRACTHYR]			= {raceID = E_CHARACTER_RACES.RACE_DRACTHYR,			clientFileString = "Dracthyr",			raceName = "RACE_DRACTHYR",				raceNameFemale = "RACE_DRACTHYR_FEMALE",			factionID = PLAYER_FACTION_GROUP.Neutral},

	[E_CHARACTER_RACES.RACE_HUMAN_CREATURE]		= {raceID = E_CHARACTER_RACES.RACE_HUMAN_CREATURE,		clientFileString = "Human",				raceName = "RACE_HUMAN_CREATURE",		raceNameFemale = nil,								factionID = PLAYER_FACTION_GROUP.Alliance},
	[E_CHARACTER_RACES.RACE_DWARF_CREATURE]		= {raceID = E_CHARACTER_RACES.RACE_DWARF_CREATURE,		clientFileString = "Dwarf",				raceName = "RACE_DWARF_CREATURE",		raceNameFemale = nil,								factionID = PLAYER_FACTION_GROUP.Alliance},
	[E_CHARACTER_RACES.RACE_NIGHTELF_CREATURE]	= {raceID = E_CHARACTER_RACES.RACE_NIGHTELF_CREATURE,	clientFileString = "NightElf",			raceName = "RACE_NIGHTELF_CREATURE",	raceNameFemale = "RACE_NIGHTELF_CREATURE_FEMALE",	factionID = PLAYER_FACTION_GROUP.Alliance},
	[E_CHARACTER_RACES.RACE_GNOME_CREATURE]		= {raceID = E_CHARACTER_RACES.RACE_GNOME_CREATURE,		clientFileString = "Gnome",				raceName = "RACE_GNOME_CREATURE",		raceNameFemale = nil,								factionID = PLAYER_FACTION_GROUP.Alliance},
	[E_CHARACTER_RACES.RACE_DRAENEI_CREATURE]	= {raceID = E_CHARACTER_RACES.RACE_DRAENEI_CREATURE,	clientFileString = "Draenei",			raceName = "RACE_DRAENEI_CREATURE",		raceNameFemale = nil,								factionID = PLAYER_FACTION_GROUP.Alliance},

	[E_CHARACTER_RACES.RACE_ORC_CREATURE]		= {raceID = E_CHARACTER_RACES.RACE_ORC_CREATURE,		clientFileString = "Orc",				raceName = "RACE_ORC_CREATURE",			raceNameFemale = nil,								factionID = PLAYER_FACTION_GROUP.Horde},
	[E_CHARACTER_RACES.RACE_SCOURGE_CREATURE]	= {raceID = E_CHARACTER_RACES.RACE_SCOURGE_CREATURE,	clientFileString = "Scourge",			raceName = "RACE_SCOURGE_CREATURE",		raceNameFemale = "RACE_SCOURGE_CREATURE_FEMALE",	factionID = PLAYER_FACTION_GROUP.Horde},
	[E_CHARACTER_RACES.RACE_TAUREN_CREATURE]	= {raceID = E_CHARACTER_RACES.RACE_TAUREN_CREATURE,		clientFileString = "Tauren",			raceName = "RACE_TAUREN_CREATURE",		raceNameFemale = nil,								factionID = PLAYER_FACTION_GROUP.Horde},
	[E_CHARACTER_RACES.RACE_TROLL_CREATURE]		= {raceID = E_CHARACTER_RACES.RACE_TROLL_CREATURE,		clientFileString = "Troll",				raceName = "RACE_TROLL_CREATURE",		raceNameFemale = nil,								factionID = PLAYER_FACTION_GROUP.Horde},
	[E_CHARACTER_RACES.RACE_BLOODELF_CREATURE]	= {raceID = E_CHARACTER_RACES.RACE_BLOODELF_CREATURE,	clientFileString = "BloodElf",			raceName = "RACE_BLOODELF_CREATURE",	raceNameFemale = "RACE_BLOODELF_CREATURE_FEMALE",	factionID = PLAYER_FACTION_GROUP.Horde},

	[E_CHARACTER_RACES.RACE_FELORC]				= {raceID = E_CHARACTER_RACES.RACE_FELORC,				clientFileString = "FelOrc",			raceName = "RACE_FELORC",				raceNameFemale = nil,								factionID = PLAYER_FACTION_GROUP.Neutral},
	[E_CHARACTER_RACES.RACE_NAGA_]				= {raceID = E_CHARACTER_RACES.RACE_NAGA_,				clientFileString = "Naga_",				raceName = "RACE_NAGA_",				raceNameFemale = "RACE_NAGA_FEMALE_",				factionID = PLAYER_FACTION_GROUP.Neutral},
	[E_CHARACTER_RACES.RACE_BROKEN]				= {raceID = E_CHARACTER_RACES.RACE_BROKEN,				clientFileString = "Broken",			raceName = "RACE_BROKEN",				raceNameFemale = "RACE_BROKEN_FEMALE",				factionID = PLAYER_FACTION_GROUP.Neutral},
	[E_CHARACTER_RACES.RACE_SKELETON]			= {raceID = E_CHARACTER_RACES.RACE_SKELETON,			clientFileString = "Skeleton",			raceName = "RACE_SKELETON",				raceNameFemale = nil,								factionID = PLAYER_FACTION_GROUP.Neutral},
	[E_CHARACTER_RACES.RACE_VRYKUL]				= {raceID = E_CHARACTER_RACES.RACE_VRYKUL,				clientFileString = "Vrykul",			raceName = "RACE_VRYKUL",				raceNameFemale = nil,								factionID = PLAYER_FACTION_GROUP.Neutral},
	[E_CHARACTER_RACES.RACE_TUSKARR]			= {raceID = E_CHARACTER_RACES.RACE_TUSKARR,				clientFileString = "Tuskarr",			raceName = "RACE_TUSKARR",				raceNameFemale = nil,								factionID = PLAYER_FACTION_GROUP.Neutral},
	[E_CHARACTER_RACES.RACE_FORESTTROLL]		= {raceID = E_CHARACTER_RACES.RACE_FORESTTROLL,			clientFileString = "ForestTroll",		raceName = "RACE_FORESTTROLL",			raceNameFemale = nil,								factionID = PLAYER_FACTION_GROUP.Neutral},
	[E_CHARACTER_RACES.RACE_TAUNKA]				= {raceID = E_CHARACTER_RACES.RACE_TAUNKA,				clientFileString = "Taunka",			raceName = "RACE_TAUNKA",				raceNameFemale = "RACE_TAUNKA_FEMALE",				factionID = PLAYER_FACTION_GROUP.Neutral},
	[E_CHARACTER_RACES.RACE_NORTHRENDSKELETON]	= {raceID = E_CHARACTER_RACES.RACE_NORTHRENDSKELETON,	clientFileString = "NorthrendSkeleton", raceName = "RACE_NORTHRENDSKELETON",	raceNameFemale = nil,								factionID = PLAYER_FACTION_GROUP.Neutral},
	[E_CHARACTER_RACES.RACE_ICETROLL]			= {raceID = E_CHARACTER_RACES.RACE_ICETROLL,			clientFileString = "IceTroll",			raceName = "RACE_ICETROLL",				raceNameFemale = nil,								factionID = PLAYER_FACTION_GROUP.Neutral},
}

S_CHARACTER_RACES_INFO_LOCALIZATION_ASSOC = {}
for _, data in pairs(S_CHARACTER_RACES_INFO) do
	local raceName = _G[data.raceName]
	if raceName then
		S_CHARACTER_RACES_INFO_LOCALIZATION_ASSOC[raceName] = data
	end

	if data.raceNameFemale then
		raceName = _G[data.raceNameFemale]
		if raceName then
			S_CHARACTER_RACES_INFO_LOCALIZATION_ASSOC[raceName] = data
		end
	end
end

-- ##################################################################################

FLYOUT_STORAGE = {}
FLYOUT_STORAGE[308230] = {308228, 308221, 308222, 308223, 308224, 308225, 308226, 308227, 313090, 313093}
FLYOUT_STORAGE[316451] = {316452, 316453}
FLYOUT_STORAGE[310801] = {310802, 310803, 310804, 310807, 310808, 310809}
FLYOUT_STORAGE[319875] = {316414, 319870, 319871, 319872, 319874}
FLYOUT_STORAGE[320544] = {320545, 320546, 320547, 320548, 320549, 320550}

S_CATEGORY_SPELL_ID = {
	[90036] = 0, [302100] = 0, [302101] = 0, [302102] = 0, [302103] = 0, [302104] = 0, [302105] = 0, [302106] = 0, [302107] = 0,
	[90028] = 1, [90029] = 1, [90030] = 1, [90031] = 1, [90032] = 1, [90033] = 1, [90034] = 1, [90035] = 1,
	[90021] = 2, [90022] = 2, [90023] = 2, [90024] = 2, [90025] = 2, [90026] = 2, [90027] = 2,
	[90015] = 3, [90016] = 3, [90017] = 3, [90018] = 3, [90019] = 3, [90020] = 3,
	[90010] = 4, [90011] = 4, [90012] = 4, [90013] = 4, [90014] = 4,
	[90006] = 5, [90007] = 5, [90008] = 5, [90009] = 5,
	[90003] = 6, [90004] = 6, [90005] = 6,
	[90001] = 7, [90002] = 7,
}

S_VIP_STATUS_DATA = {
	[308221] = {
		spellID 	= 308221,
		category 	= 1,
		color 		= CreateColor(0.80, 0.49, 0.19),
	},
	[308222] = {
		spellID 	= 308222,
		category 	= 1,
		color 		= CreateColor(1, 1, 1),
	},
	[308223] = {
		spellID 	= 308223,
		category 	= 1,
		color 		= CreateColor(1, 0.84, 0),
	},
	[308224] = {
		spellID 	= 308224,
		category 	= 2,
		color 		= CreateColor(0.80, 0.49, 0.19),
	},
	[308225] = {
		spellID 	= 308225,
		category 	= 2,
		color 		= CreateColor(1, 1, 1),
	},
	[308226] = {
		spellID 	= 308226,
		category 	= 2,
		color 		= CreateColor(1, 0.84, 0),
	},
	[308227] = {
		spellID 	= 308227,
		category 	= 3,
		color 		= CreateColor(0.47, 1, 0.47),
	},
	[313090] = {
		spellID 	= 313090,
		category 	= 3,
		color 		= CreateColor(0.38, 0.56, 1),
	},
	[313093] = {
		spellID 	= 313093,
		category 	= 3,
		color 		= CreateColor(1, 0.3, 0.34),
	},
}

enum:E_SEX {
	"NONE",
	"MALE",
	"FEMALE"
}

FACTION_OVERRIDE_BY_DEBUFFS = {
	[309327] = PLAYER_FACTION_GROUP.Alliance,
	[302906] = PLAYER_FACTION_GROUP.Alliance,
	[308184] = PLAYER_FACTION_GROUP.Alliance,
	[302904] = PLAYER_FACTION_GROUP.Alliance,
	[310063] = PLAYER_FACTION_GROUP.Alliance,
	[310065] = PLAYER_FACTION_GROUP.Alliance,

	[309328] = PLAYER_FACTION_GROUP.Horde,
	[302907] = PLAYER_FACTION_GROUP.Horde,
	[308185] = PLAYER_FACTION_GROUP.Horde,
	[302905] = PLAYER_FACTION_GROUP.Horde,
	[310064] = PLAYER_FACTION_GROUP.Horde,
	[310066] = PLAYER_FACTION_GROUP.Horde,

	[309329] = PLAYER_FACTION_GROUP.Renegade
}