local FetchAsset = require("../../Lib/FetchAsset")

local LoadExample = {}

function LoadExample.Map(id: number): ()
	local asset = FetchAsset(id)
	asset.Name = "Map"
	asset.Parent = workspace
end

function LoadExample.Gamemode(id: number): ()
	local asset = FetchAsset(id)
	asset.Parent = workspace
end

return LoadExample