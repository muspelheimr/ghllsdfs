-- Set to false in some locale specific files.
TIME_UTIL_WHITE_SPACE_STRIPPABLE = true;

SECONDS_PER_MIN = 60;
SECONDS_PER_HOUR = 60 * SECONDS_PER_MIN;
SECONDS_PER_DAY = 24 * SECONDS_PER_HOUR;
SECONDS_PER_MONTH = 30 * SECONDS_PER_DAY;
SECONDS_PER_YEAR = 12 * SECONDS_PER_MONTH;

function SecondsToMinutes(seconds)
	return seconds / SECONDS_PER_MIN;
end

function MinutesToSeconds(minutes)
	return minutes * SECONDS_PER_MIN;
end

function HasTimePassed(testTime, amountOfTime)
	return ((time() - testTime) >= amountOfTime);
end

SecondsFormatter = {};
SecondsFormatter.Abbreviation =
{
	None = 1, -- seconds, minutes, hours...
	Truncate = 2, -- sec, min, hr...
	OneLetter = 3, -- s, m, h...
}

SecondsFormatter.Interval = {
	Seconds = 1,
	Minutes = 2,
	Hours = 3,
	Days = 4,
}

SecondsFormatter.IntervalDescription = {
	[SecondsFormatter.Interval.Seconds] = {seconds = 1, formatString = { D_SECONDS, SECONDS_ABBR, SECOND_ONELETTER_ABBR}},
	[SecondsFormatter.Interval.Minutes] = {seconds = SECONDS_PER_MIN, formatString = {D_MINUTES, MINUTES_ABBR, MINUTE_ONELETTER_ABBR}},
	[SecondsFormatter.Interval.Hours] = {seconds = SECONDS_PER_HOUR, formatString = {D_HOURS, HOURS_ABBR, HOUR_ONELETTER_ABBR}},
	[SecondsFormatter.Interval.Days] = {seconds = SECONDS_PER_DAY, formatString = {D_DAYS, DAYS_ABBR, DAY_ONELETTER_ABBR}},
}

--[[ Seconds formatter to standardize representations of seconds. When adding a new formatter
please consider if a prexisting formatter suits your needs, otherwise, before adding a new formatter,
consider adding it to a file appropriate to it's intended use. For example, "WorldQuestsSecondsFormatter"
could be added to QuestUtil.h so it's immediately apparent the scenarios the formatter is appropriate.]]

SecondsFormatterMixin = {}
-- defaultAbbreviation: the default abbreviation for the format. Can be overrridden in SecondsFormatterMixin:Format()
-- approximationSeconds: threshold for representing the seconds as an approximation (ex. "< 2 hours").
-- roundUpLastUnit: determines if the last unit in the output format string is ceiled (floored by default).
-- convertToLower: converts the format string to lowercase.
function SecondsFormatterMixin:Init(approximationSeconds, defaultAbbreviation, roundUpLastUnit, convertToLower, minValue)
	self.approximationSeconds = approximationSeconds or 0;
	self.defaultAbbreviation = defaultAbbreviation or SecondsFormatter.Abbreviation.None;
	self.roundUpLastUnit = roundUpLastUnit or false;
	self.stripIntervalWhitespace = false;
	self.convertToLower = convertToLower or false;
	self.minValue = minValue or 0;
end

function SecondsFormatterMixin:SetStripIntervalWhitespace(strip)
	self.stripIntervalWhitespace = strip;
end

function SecondsFormatterMixin:GetStripIntervalWhitespace()
	return self.stripIntervalWhitespace;
end

function SecondsFormatterMixin:GetMaxInterval()
	return #SecondsFormatter.IntervalDescription;
end

function SecondsFormatterMixin:GetIntervalDescription(interval)
	return SecondsFormatter.IntervalDescription[interval];
end

function SecondsFormatterMixin:GetIntervalSeconds(interval)
	local intervalDescription = self:GetIntervalDescription(interval);
	return intervalDescription and intervalDescription.seconds or nil;
end

function SecondsFormatterMixin:CanApproximate(seconds)
	return (seconds > 0 and seconds < self:GetApproximationSeconds());
end

function SecondsFormatterMixin:GetDefaultAbbreviation()
	return self.defaultAbbreviation;
end

function SecondsFormatterMixin:GetApproximationSeconds()
	return self.approximationSeconds;
end

function SecondsFormatterMixin:CanRoundUpLastUnit()
	return self.roundUpLastUnit;
end

function SecondsFormatterMixin:GetDesiredUnitCount(seconds)
	return 2;
end

function SecondsFormatterMixin:GetMinInterval(seconds)
	return SecondsFormatter.Interval.Seconds;
end

function SecondsFormatterMixin:GetMinValue()
	return self.minValue;
end

function SecondsFormatterMixin:GetFormatString(interval, abbreviation, convertToLower)
	local intervalDescription = self:GetIntervalDescription(interval);
	local formatString = intervalDescription.formatString[abbreviation];
	if convertToLower then
		formatString = formatString:lower();
	end
	local strip = TIME_UTIL_WHITE_SPACE_STRIPPABLE and self:GetStripIntervalWhitespace();
	return strip and formatString:gsub(" ", "") or formatString;
end

function SecondsFormatterMixin:FormatZero(abbreviation, toLower)
	local minInterval = self:GetMinInterval();
	local formatString = self:GetFormatString(minInterval, abbreviation);
	return formatString:format(self:GetMinValue());
end

function SecondsFormatterMixin:FormatMillseconds(millseconds, abbreviation)
	return self:Format(millseconds/1000, abbreviation);
end

function SecondsFormatterMixin:Format(seconds, abbreviation)
	if (seconds == nil) then
		return "";
	end

	seconds = math.ceil(seconds);
	abbreviation = abbreviation or self:GetDefaultAbbreviation();

	if (seconds <= 0) then
		return self:FormatZero(abbreviation);
	end

	local minInterval = self:GetMinInterval(seconds);
	local maxInterval = self:GetMaxInterval();

	if (self:CanApproximate(seconds)) then
		local interval = math.max(minInterval, SecondsFormatter.Interval.Minutes);
		while (interval < maxInterval) do
			local nextInterval = interval + 1;
			if (seconds > self:GetIntervalSeconds(nextInterval)) then
				interval = nextInterval;
			else
				break;
			end
		end

		local formatString = self:GetFormatString(interval, abbreviation, self.convertToLower);
		local unit = formatString:format(math.ceil(seconds / self:GetIntervalSeconds(interval)));
		return string.format(LESS_THAN_OPERAND, unit);
	end

	local output = "";
	local appendedCount = 0;
	local desiredCount = self:GetDesiredUnitCount(seconds);
	local convertToLower = self.convertToLower;

	local currentInterval = maxInterval;
	while ((appendedCount < desiredCount) and (currentInterval >= minInterval)) do
		local intervalDescription = self:GetIntervalDescription(currentInterval);
		local intervalSeconds = intervalDescription.seconds;
		if (seconds >= intervalSeconds) then
			appendedCount = appendedCount + 1;
			if (output ~= "") then
				output = output..TIME_UNIT_DELIMITER;
			end

			local formatString = self:GetFormatString(currentInterval, abbreviation, convertToLower);
			local quotient = seconds / intervalSeconds;
			if (quotient > 0) then
				if (self:CanRoundUpLastUnit() and ((minInterval == currentInterval) or (appendedCount == desiredCount))) then
					output = output..formatString:format(math.ceil(quotient));
				else
					output = output..formatString:format(math.floor(quotient));
				end
			else
				break;
			end

			seconds = math.fmod(seconds, intervalSeconds);
		end

		currentInterval = currentInterval - 1;
	end

	-- Return the zero format if an acceptable representation couldn't be formed.
	if (output == "") then
		return self:FormatZero(abbreviation);
	end

	return output;
end

function ConvertSecondsToUnits(timestamp)
	timestamp = math.max(timestamp, 0);
	local days = math.floor(timestamp / SECONDS_PER_DAY);
	timestamp = timestamp - (days * SECONDS_PER_DAY);
	local hours = math.floor(timestamp / SECONDS_PER_HOUR);
	timestamp = timestamp - (hours * SECONDS_PER_HOUR);
	local minutes = math.floor(timestamp / SECONDS_PER_MIN);
	timestamp = timestamp - (minutes * SECONDS_PER_MIN);
	local seconds = math.floor(timestamp);
	local milliseconds = timestamp - seconds;
	return {
		days=days,
		hours=hours,
		minutes=minutes,
		seconds=seconds,
		milliseconds=milliseconds,
	}
end

function SecondsToClock(seconds, displayZeroHours)
	local hours = math.floor(seconds / SECONDS_PER_HOUR);
	local minutes = math.floor(seconds / SECONDS_PER_MIN);
	if hours > 0 or displayZeroHours then
		return format(HOURS_MINUTES_SECONDS, hours, minutes % 60, seconds % SECONDS_PER_MIN);
	else
		return format(MINUTES_SECONDS, minutes % 60, seconds % SECONDS_PER_MIN);
	end
end

function SecondsToTime(seconds, noSeconds, notAbbreviated, maxCount, roundUp)
	local time = "";
	local count = 0;
	local tempTime;
	seconds = roundUp and ceil(seconds) or floor(seconds);
	maxCount = maxCount or 2;
	if ( seconds >= SECONDS_PER_DAY  ) then
		count = count + 1;
		if ( count == maxCount and roundUp ) then
			tempTime = ceil(seconds / SECONDS_PER_DAY);
		else
			tempTime = floor(seconds / SECONDS_PER_DAY);
		end
		if ( notAbbreviated ) then
			time = D_DAYS:format(tempTime);
		else
			time = DAYS_ABBR:format(tempTime);
		end
		seconds = mod(seconds, SECONDS_PER_DAY);
	end
	if ( count < maxCount and seconds >= SECONDS_PER_HOUR  ) then
		count = count + 1;
		if ( time ~= "" ) then
			time = time..TIME_UNIT_DELIMITER;
		end
		if ( count == maxCount and roundUp ) then
			tempTime = ceil(seconds / SECONDS_PER_HOUR);
		else
			tempTime = floor(seconds / SECONDS_PER_HOUR);
		end
		if ( notAbbreviated ) then
			time = time..D_HOURS:format(tempTime);
		else
			time = time..HOURS_ABBR:format(tempTime);
		end
		seconds = mod(seconds, SECONDS_PER_HOUR);
	end
	if ( count < maxCount and seconds >= SECONDS_PER_MIN  ) then
		count = count + 1;
		if ( time ~= "" ) then
			time = time..TIME_UNIT_DELIMITER;
		end
		if ( count == maxCount and roundUp ) then
			tempTime = ceil(seconds / SECONDS_PER_MIN);
		else
			tempTime = floor(seconds / SECONDS_PER_MIN);
		end
		if ( notAbbreviated ) then
			time = time..D_MINUTES:format(tempTime);
		else
			time = time..MINUTES_ABBR:format(tempTime);
		end
		seconds = mod(seconds, SECONDS_PER_MIN);
	end
	if ( count < maxCount and seconds > 0 and not noSeconds ) then
		if ( time ~= "" ) then
			time = time..TIME_UNIT_DELIMITER;
		end
		if ( notAbbreviated ) then
			time = time..D_SECONDS:format(seconds);
		else
			time = time..SECONDS_ABBR:format(seconds);
		end
	end
	return time;
end

function MinutesToTime(mins, hideDays)
	local time = "";
	local count = 0;
	local tempTime;
	-- only show days if hideDays is false
	if ( mins > 1440 and not hideDays ) then
		tempTime = floor(mins / 1440);
		time = TIME_UNIT_DELIMITER .. format(DAYS_ABBR, tempTime);
		mins = mod(mins, 1440);
		count = count + 1;
	end
	if ( mins > 60  ) then
		tempTime = floor(mins / 60);
		time = time .. TIME_UNIT_DELIMITER .. format(HOURS_ABBR, tempTime);
		mins = mod(mins, 60);
		count = count + 1;
	end
	if ( count < 2 ) then
		tempTime = mins;
		time = time .. TIME_UNIT_DELIMITER .. format(MINUTES_ABBR, tempTime);
		count = count + 1;
	end
	return time;
end

function SecondsToTimeAbbrev(seconds)
	local tempTime;
	if ( seconds >= SECONDS_PER_DAY ) then
		tempTime = ceil(seconds / SECONDS_PER_DAY);
		return DAY_ONELETTER_ABBR, tempTime;
	end
	if ( seconds >= SECONDS_PER_HOUR ) then
		tempTime = ceil(seconds / SECONDS_PER_HOUR);
		return HOUR_ONELETTER_ABBR, tempTime;
	end
	if ( seconds >= SECONDS_PER_MIN ) then
		tempTime = ceil(seconds / SECONDS_PER_MIN);
		return MINUTE_ONELETTER_ABBR, tempTime;
	end
	return SECOND_ONELETTER_ABBR, seconds;
end

function FormatShortDate(day, month, year)
	if (year) then
		if (LOCALE_enGB) then
			return SHORTDATE_EU:format(day, month, year);
		else
			return SHORTDATE:format(day, month, year);
		end
	else
		if (LOCALE_enGB) then
			return SHORTDATENOYEAR_EU:format(day, month);
		else
			return SHORTDATENOYEAR:format(day, month);
		end
	end
end

function GetRemainingTime(seconds, daysformat)
	if daysformat then
		if seconds >= SECONDS_PER_DAY then
			return string.format(D_DAYS_FULL, math.floor(seconds / SECONDS_PER_DAY))
		else
			return date("!%X", seconds)
		end
	else
		if seconds >= SECONDS_PER_DAY then
			local days = string.format(DAY_ONELETTER_ABBR_SHORT, math.floor(seconds / SECONDS_PER_DAY))
			return string.format("%s %s", days, date("!%X", seconds % SECONDS_PER_DAY))
		else
			return date("!%X", seconds)
		end
	end
end

function GetTimezoneOffset(timestamp)
	local utcdate = date("!*t", timestamp)
	local localdate = date("*t", timestamp)
	localdate.isdst = false
	return difftime(time(localdate), time(utcdate))
end

local localTimezone
function GetLocalTimezoneOffset()
	if not localTimezone then
		localTimezone = GetTimezoneOffset()
	end
	return localTimezone
end

local TIME_DIFF_GROUP = {
	{1, TIME_RELATIVE_NOW},
	{SECONDS_PER_MIN, TIME_RELATIVE_SECOND, function(x) return x end},
	{SECONDS_PER_HOUR, TIME_RELATIVE_MINUT, function(x) return math.floor(x / SECONDS_PER_MIN) end},
	{SECONDS_PER_DAY, TIME_RELATIVE_HOUR, function(x) return math.floor(x / SECONDS_PER_HOUR) end},
	{SECONDS_PER_MONTH, TIME_RELATIVE_DAY, function(x) return math.floor(x / SECONDS_PER_DAY) end},
	{SECONDS_PER_YEAR, TIME_RELATIVE_MONTH, function(x) return math.floor(x / SECONDS_PER_MONTH) end},
	{SECONDS_PER_YEAR * 10, TIME_RELATIVE_YEAR, function(x) return math.floor(x / SECONDS_PER_YEAR) end},
}

function FormatRelativeDate(unixTimestamp, offsetSeconds, fromTime, addAgoSuffix, timeDiffGroup)
	if not fromTime then
		fromTime = time()
	end

	if not timeDiffGroup then
		timeDiffGroup = TIME_DIFF_GROUP
	end

	local timestamp = unixTimestamp + (offsetSeconds or 0)
	local diff = difftime(fromTime, timestamp)
	local diffString

	if diff >= 0 then -- ignore diff from future
		local index = 1
		local diffInfo = timeDiffGroup[index]
		while diffInfo do
			if diff < diffInfo[1] then
				if diffInfo[3] then
					diffString = string.format(diffInfo[2], diffInfo[3](diff))
				else
					diffString = diffInfo[2]
				end
				break
			end

			index = index + 1
			diffInfo = TIME_DIFF_GROUP[index]
		end
	end

	if addAgoSuffix and diffString then
		diffString = string.format(TIME_RELATIVE_AGO, diffString)
	end

	return diffString
end

function ParseTimeISO8061(timeString, suppressErrors)
	if type(timeString) ~= "string" then
		if suppressErrors then
			GMError(string.format("bad argument #1 to 'ParseTimeISO8061' (string expected, got %s)", type(timeString)))
			return timeString
		else
			error(string.format("bad argument #1 to 'ParseTimeISO8061' (string expected, got %s)", type(timeString)), 2)
		end
	end

	local year, month, day, offsetType, hour, minute, second, milisecond, offsetSign, offsetHour, offsetMinute = string.match(timeString, "(%d%d%d%d)%-?(%d%d)%-?(%d%d)([TZ])(%d%d):(%d%d):(%d%d)%.?(%d*)([%+%-]?)(%d?%d?):?(%d?%d?)")

	if not (year and month and day and hour and minute and second) then
		if suppressErrors then
			GMError(string.format("Parsing TimeISO8061 error: %s", timeString))
			return timeString
		else
			error(string.format("Parsing TimeISO8061 error: %s", timeString), 2)
		end
	end

	local offsetSecond = 0
	if offsetType ~= 'Z' then
		offsetSecond = ((tonumber(offsetHour) or 0) * 60 + (tonumber(offsetMinute) or 0)) * 60
		if offsetSign == "-" and offsetSecond ~= 0 then
			offsetSecond = -offsetSecond
		end
	end

	local timeInfo = {
		year = year,
		month = month,
		day = day,
		hour = hour,
		min = minute,
		sec = second,
--[[
		milisecond = milisecond,

		offsetType = offsetType,
		offsetHour = offsetHour,
		offsetMinute = offsetMinute,
		offsetSecond = offsetSecond,
--]]
	}

	local timestamp = time(timeInfo)
	local unixTimestamp = timestamp - offsetSecond

	return timestamp, unixTimestamp
end