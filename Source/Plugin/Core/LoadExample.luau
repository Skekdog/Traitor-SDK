local FetchAsset = require("../../Lib/FetchAsset")
local LoadGamemode = require("./Load/LoadGamemode")
local LoadItems = require("./Load/LoadItems")
local LoadMap = require("./Load/LoadMap")
local LoadReference = require("./Load/LoadReference")

local LoadExample = {}

function LoadExample.Map(id: number): ()
	local map = FetchAsset(id)
	assert(map, "Invalid map")
	LoadMap(map)
end

function LoadExample.Gamemode(id: number): ()
	local gamemode = FetchAsset(id)
	assert(gamemode, "Invalid gamemode")
	LoadGamemode(gamemode)
end

function LoadExample.Items(id: number): ()
	local items = FetchAsset(id)
	assert(items, "Invalid items")
	LoadItems(items)
end

function LoadExample.API(id: number): ()
	local api = FetchAsset(id)
	assert(api, "Invalid reference")
	LoadReference(api)
end

return LoadExample