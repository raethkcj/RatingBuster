local addonName = ...
local StatLogic = LibStub:GetLibrary(addonName)

--[[---------------------------------
{	:GetNormalManaRegenFromSpi(spi, [class])
-------------------------------------
-- Description
	Calculates the mana regen per 5 seconds while NOT casting from spirit for any class.
-- Args
	spi
			number - spirit
	[class] - (defaults: PlayerClass)
			string - english class name
			number - class id
-- Returns
	[mp5nc]
		number - mana regen per 5 seconds when out of combat
	[statid]
		string - "MANA_REG_NOT_CASTING"
-- Remarks
	Player level does not effect mana regen per spirit.
-- Examples
	StatLogic:GetNormalManaRegenFromSpi(1) -- GetNormalManaRegenPerSpi
	StatLogic:GetNormalManaRegenFromSpi(10)
	StatLogic:GetNormalManaRegenFromSpi(10, "MAGE")
}
-----------------------------------]]

-- Numbers reverse engineered by Whitetooth@Cenarius(US) (hotdogee [at] gmail [dot] com)
local NormalManaRegenPerSpi = {
	0, 0.1, 0.1, 0, 0.125, 0.1, 0.125, 0.1, 0.1125,
	--["WARRIOR"] = 0,
	--["PALADIN"] = 0.1,
	--["HUNTER"] = 0.1,
	--["ROGUE"] = 0,
	--["PRIEST"] = 0.125,
	--["SHAMAN"] = 0.1,
	--["MAGE"] = 0.125,
	--["WARLOCK"] = 0.1,
	--["DRUID"] = 0.1125,
}

function StatLogic:GetNormalManaRegenFromSpi(spi, class)
	-- argCheck for invalid input
	self:argCheck(spi, 2, "number")
	self:argCheck(class, 3, "nil", "string", "number")
	-- if class is a class string, convert to class id
	if type(class) == "string" and ClassNameToID[strupper(class)] ~= nil then
		class = ClassNameToID[strupper(class)]
	-- if class is invalid input, default to player class
	elseif type(class) ~= "number" or class < 1 or class > 9 then
		class = ClassNameToID[playerClass]
	end
	-- Calculate
	return spi * NormalManaRegenPerSpi[class] * 5, "MANA_REG_NOT_CASTING"
end
