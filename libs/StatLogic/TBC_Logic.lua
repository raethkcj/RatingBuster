local addonName = ...
local StatLogic = LibStub:GetLibrary(addonName)

--[[---------------------------------
{	:GetNormalManaRegenFromSpi(spi, [int], [level])
-------------------------------------
-- Description
	Calculates the mana regen per 5 seconds while NOT casting from spirit.
-- Args
	spi
			number - spirit
	[int] - (defaults: PlayerInt)
			number - intellect
	[level] - (defaults: PlayerLevel)
			number - player level used for calculation
-- Returns
	[mp5nc]
		number - mana regen per 5 seconds when out of combat
	[statid]
		string - "MANA_REG_NOT_CASTING"
-- Remarks
	Player class is no longer a parameter
	ManaRegen(SPI, INT, LEVEL) = (0.001+SPI*BASE_REGEN[LEVEL]*(INT^0.5))*5
-- Examples
	StatLogic:GetNormalManaRegenFromSpi(1) -- GetNormalManaRegenPerSpi
	StatLogic:GetNormalManaRegenFromSpi(10, 15)
	StatLogic:GetNormalManaRegenFromSpi(10, 15, 70)
}
-----------------------------------]]

-- Numbers reverse engineered by Whitetooth@Cenarius(US) (hotdogee [at] gmail [dot] com)
local BaseManaRegenPerSpi = {
	[1] = 0.034965,
	[2] = 0.034191,
	[3] = 0.033465,
	[4] = 0.032526,
	[5] = 0.031661,
	[6] = 0.031076,
	[7] = 0.030523,
	[8] = 0.029994,
	[9] = 0.029307,
	[10] = 0.028661,
	[11] = 0.027584,
	[12] = 0.026215,
	[13] = 0.025381,
	[14] = 0.0243,
	[15] = 0.023345,
	[16] = 0.022748,
	[17] = 0.021958,
	[18] = 0.021386,
	[19] = 0.02079,
	[20] = 0.020121,
	[21] = 0.019733,
	[22] = 0.019155,
	[23] = 0.018819,
	[24] = 0.018316,
	[25] = 0.017936,
	[26] = 0.017576,
	[27] = 0.017201,
	[28] = 0.016919,
	[29] = 0.016581,
	[30] = 0.016233,
	[31] = 0.015994,
	[32] = 0.015707,
	[33] = 0.015464,
	[34] = 0.015204,
	[35] = 0.014956,
	[36] = 0.014744,
	[37] = 0.014495,
	[38] = 0.014302,
	[39] = 0.014094,
	[40] = 0.013895,
	[41] = 0.013724,
	[42] = 0.013522,
	[43] = 0.013363,
	[44] = 0.013175,
	[45] = 0.012996,
	[46] = 0.012853,
	[47] = 0.012687,
	[48] = 0.012539,
	[49] = 0.012384,
	[50] = 0.012233,
	[51] = 0.012113,
	[52] = 0.011973,
	[53] = 0.011859,
	[54] = 0.011714,
	[55] = 0.011575,
	[56] = 0.011473,
	[57] = 0.011342,
	[58] = 0.011245,
	[59] = 0.01111,
	[60] = 0.010999,
	[61] = 0.0107,
	[62] = 0.010522,
	[63] = 0.01029,
	[64] = 0.010119,
	[65] = 0.009968,
	[66] = 0.009808,
	[67] = 0.009651,
	[68] = 0.009553,
	[69] = 0.009445,
	[70] = 0.009327,
}

function StatLogic:GetNormalManaRegenFromSpi(spi, int, level)
	-- argCheck for invalid input
	self:argCheck(spi, 2, "number")
	self:argCheck(int, 3, "nil", "number")
	self:argCheck(level, 4, "nil", "number")

	-- if level is invalid input, default to player level
	if type(level) ~= "number" or level < 1 or level > 70 then
		level = UnitLevel("player")
	end

	-- if int is invalid input, default to player int
	if type(int) ~= "number" then
		local _
		_, int = UnitStat("player",4)
	end
	-- Calculate
	return (0.001 + spi * BaseManaRegenPerSpi[level] * (int ^ 0.5)) * 5, "MANA_REG_NOT_CASTING"
end
