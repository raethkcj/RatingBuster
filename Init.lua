local _, addon = ...

--------------------
-- AceAddon Setup --
--------------------
---@class RatingBuster: AceAddon, AceConsole-3.0, AceEvent-3.0, AceBucket-3.0
RatingBuster = LibStub("AceAddon-3.0"):NewAddon("RatingBuster", "AceConsole-3.0", "AceEvent-3.0", "AceBucket-3.0")
RatingBuster.title = "Rating Buster"
--[===[@non-debug@
RatingBuster.version = "@project-version@"
--@end-non-debug@]===]
--@debug@
RatingBuster.version = "(development)"
--@end-debug@

addon.tocversion = select(4, GetBuildInfo())

---@class RatingBusterLocale
---@field numberPatterns table
---@field exclusions table
---@field separators table
---@field statPatterns { [Stat]: string[] }
---@field [string] string

---@class RatingBusterDefaultLocale : RatingBusterLocale
---@field [string] string|true