local Message = require("../../Lib/Message")
local LoadGamemode = require("./Load/LoadGamemode")
local LoadItems = require("./Load/LoadItems")
local LoadMap = require("./Load/LoadMap")
local LoadReference = require("./Load/LoadReference")
local Net = require("./Net")

local LoadExample = {}

function LoadExample.Map(id: string): ()
	local asset = Net.FetchAssetContent(id, true)
	if typeof(asset) == "string" then
		return Message(asset, "error")
	end
	LoadMap(asset)
end

function LoadExample.Gamemode(id: string): ()
	local asset = Net.FetchAssetContent(id, true)
	if typeof(asset) == "string" then
		return Message(asset, "error")
	end
	LoadGamemode(asset)
end

function LoadExample.Items(id: string): ()
	local asset = Net.FetchAssetContent(id, true)
	if typeof(asset) == "string" then
		return Message(asset, "error")
	end
	LoadItems(asset)
end

function LoadExample.API(id: string): ()
	local asset = Net.FetchAssetContent(id, true)
	if typeof(asset) == "string" then
		return Message(asset, "error")
	end
	LoadReference(asset)
end

return LoadExample