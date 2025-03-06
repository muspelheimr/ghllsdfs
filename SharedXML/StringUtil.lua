function ConfirmationStringMatches(userInput, expectedText)
	return strupper(userInput) == strupper(expectedText);
end

function ConfirmationEditBoxMatches(editBox, expectedText)
	return ConfirmationStringMatches(editBox:GetText(), expectedText);
end

function UserInputNonEmpty(userInput)
	return strtrim(userInput) ~= "";
end

function UserEditBoxNonEmpty(editBox)
	return UserInputNonEmpty(editBox:GetText());
end

function StringSplitIntoTable(sep, string)
	return { strsplit(sep, string) };
end

function StringStartsWith(str, stringStart, caseInsensitive)
	if caseInsensitive then
		str = string.lower(str)
		stringStart = string.lower(stringStart)
	end

	return string.sub(str, 1, string.len(stringStart)) == stringStart
end

function StringEndsWith(str, stringEnd, caseInsensitive)
	if caseInsensitive then
		str = string.lower(str)
		stringEnd = string.lower(stringEnd)
	end

	return string.sub(str, -(string.len(stringEnd))) == stringEnd
end

function StringSplitEx(delimiter, str, pieces)
	str = string.gsub(str, strconcat(delimiter, "$"), "")
	if str ~= "" then
		return string.split(delimiter, str, pieces)
	end
end