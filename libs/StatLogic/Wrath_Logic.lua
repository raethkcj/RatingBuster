local addonName = ...
local StatLogic = LibStub:GetLibrary(addonName)

--[[---------------------------------
	:GetNormalManaRegenFromSpi(spi, [int], [level])
-------------------------------------
Notes:
	* Formula and BASE_REGEN values derived by Whitetooth (hotdogee [at] gmail [dot] com)
	* Calculates the mana regen per 5 seconds from spirit when out of 5 second rule for given intellect and level.
	* Player class is no longer a parameter
	* ManaRegen(SPI, INT, LEVEL) = (0.001+SPI*BASE_REGEN[LEVEL]*(INT^0.5))*5
Arguments:
	number - Spirit
	[optional] number - Intellect. Default: player's intellect
	[optional] number - Level used in calculations. Default: player's level
Returns:
	; mp5o5sr : number - Mana regen per 5 seconds when out of 5 second rule
	; statid : string - "MANA_REG_NOT_CASTING"
Example:
	local mp5o5sr = StatLogic:GetNormalManaRegenFromSpi(1) -- GetNormalManaRegenPerSpi
	local mp5o5sr = StatLogic:GetNormalManaRegenFromSpi(10, 15)
	local mp5o5sr = StatLogic:GetNormalManaRegenFromSpi(10, 15, 70)
-----------------------------------]]

-- Numbers reverse engineered by Whitetooth (hotdogee [at] gmail [dot] com)
local BaseManaRegenPerSpi = {
	[1] =  0.020979,
	[2] =  0.020515,
	[3] =  0.020079,
	[4] =  0.019516,
	[5] =  0.018997,
	[6] =  0.018646,
	[7] =  0.018314,
	[8] =  0.017997,
	[9] =  0.017584,
	[10] = 0.017197,
	[11] = 0.016551,
	[12] = 0.015729,
	[13] = 0.015229,
	[14] = 0.014580,
	[15] = 0.014008,
	[16] = 0.013650,
	[17] = 0.013175,
	[18] = 0.012832,
	[19] = 0.012475,
	[20] = 0.012073,
	[21] = 0.011840,
	[22] = 0.011494,
	[23] = 0.011292,
	[24] = 0.010990,
	[25] = 0.010761,
	[26] = 0.010546,
	[27] = 0.010321,
	[28] = 0.010151,
	[29] = 0.009949,
	[30] = 0.009740,
	[31] = 0.009597,
	[32] = 0.009425,
	[33] = 0.009278,
	[34] = 0.009123,
	[35] = 0.008974,
	[36] = 0.008847,
	[37] = 0.008698,
	[38] = 0.008581,
	[39] = 0.008457,
	[40] = 0.008338,
	[41] = 0.008235,
	[42] = 0.008113,
	[43] = 0.008018,
	[44] = 0.007906,
	[45] = 0.007798,
	[46] = 0.007713,
	[47] = 0.007612,
	[48] = 0.007524,
	[49] = 0.007430,
	[50] = 0.007340,
	[51] = 0.007268,
	[52] = 0.007184,
	[53] = 0.007116,
	[54] = 0.007029,
	[55] = 0.006945,
	[56] = 0.006884,
	[57] = 0.006805,
	[58] = 0.006747,
	[59] = 0.006667,
	[60] = 0.006600,
	[61] = 0.006421,
	[62] = 0.006314,
	[63] = 0.006175,
	[64] = 0.006072,
	[65] = 0.005981,
	[66] = 0.005885,
	[67] = 0.005791,
	[68] = 0.005732,
	[69] = 0.005668,
	[70] = 0.005596,
	[71] = 0.005316,
	[72] = 0.005049,
	[73] = 0.004796,
	[74] = 0.004555,
	[75] = 0.004327,
	[76] = 0.004110,
	[77] = 0.003903,
	[78] = 0.003708,
	[79] = 0.003522,
	[80] = 0.003345,
}

function StatLogic:GetNormalManaRegenFromSpi(spi, int, level)
	-- argCheck for invalid input
	self:argCheck(spi, 2, "number")
	self:argCheck(int, 3, "nil", "number")
	self:argCheck(level, 4, "nil", "number")

	-- if level is invalid input, default to player level
	if type(level) ~= "number" or level < 1 or level > 80 then
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
