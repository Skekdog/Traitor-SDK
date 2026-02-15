local FetchAsset = require("../../Lib/FetchAsset")
local Prompt = require("../../Lib/UI/Prompt")
local Widget = require("../Widget")
local LoadGamemode = require("./Load/LoadGamemode")
local LoadItems = require("./Load/LoadItems")
local LoadMap = require("./Load/LoadMap")
local LoadReference = require("./Load/LoadReference")

local LoadExample = {}

function LoadExample.Map(id: number): ()
	local response: "Cancel" | "OK"?
	Prompt(Widget.Widget, "Warning", "This will overwrite your entire game!", function(res)
		response = res
	end)

	while not response do
		task.wait()
	end

	if response ~= "OK" then
		return
	end

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