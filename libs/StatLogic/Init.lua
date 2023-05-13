local addonName = ...

--[[
Name: StatLogic-1.0
Description: A Library for stat conversion, calculation and summarization.
Author: Whitetooth
Email: hotdogee [at] gmail [dot] com
Website:
Documentation:
License: LGPL v2.1
Features:
	StatConversion -
		Ratings -> Effect
		Str -> AP, Block
		Agi -> Crit, Dodge, AP, RAP, Armor
		Sta -> Health, SpellDmg(Talant)
		Int -> Mana, SpellCrit
		Spi -> MP5, HP5
		and more!
	StatMods - Get stat mods from talants and buffs for every class
	BaseStats - for all classes and levels
	ItemStatParser - Fast multi level indexing algorithm instead of calling strfind for every stat
]]

-- This library is still in early development, please consider not using this library until the documentation is writen on wowace.
-- Unless you don't mind putting up with breaking changes that may or may not happen during early development.

--[===[@non-debug@
-- Add 80000 to always supercede Whitetooth's revisions
local MINOR_VERSION = 80000 + @project-revision@
--@end-non-debug@]===]
--@debug@
local MINOR_VERSION = 2 ^ 32 -- LibStub doesn't accept math.huge as a number
--@end-debug@

---@class StatLogic
local StatLogic = LibStub:NewLibrary(addonName, MINOR_VERSION)