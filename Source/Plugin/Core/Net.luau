local HttpService = game:GetService("HttpService")
local Key = require("../Key")

local Net = {}

local BASE_URL = "https://traitor-uploader.gurkz.me/"

export type Response<T = nil> = {
	Success: true,
	Result: T,
} | {
	Success: false,
	Result: string,
}

function Net.MakeRequest<T>(endpoint: string, method: "POST" | "PATCH" | "GET", contentType: string?, body: string?, t: T): Response<T>
	local key = Key.Get()
	if not key then
		return {Success = false, Result = "Please provide a key"}
	end

	assert(endpoint:sub(1, 1) ~= "/", "endpoint must not start with a slash")

	local success, response = pcall(HttpService.RequestAsync, HttpService, {
		Url = BASE_URL .. endpoint,
		Method = method,
		Body = body,
		Headers = {
			Authorization = "Bearer " .. key,
			["Content-Type"] = contentType :: string
		},
		Compress = Enum.HttpCompression.None,
	})

	if not success or not response.Success then
		return {
			Success = false,
			Result =
				if success then
					response.StatusCode .. " " .. (response.Body or response.StatusMessage)
				else (response :: any) :: string,
		}
	end

	local success2, result = pcall(HttpService.JSONDecode, HttpService, response.Body or "")
	return {
		Success = true,
		Result = if success2 then result else response.Body or ""
	}
end

function Net.GetAvailableAssets(): {private: {string}, public: {string}}
	local response = Net.MakeRequest("assets", "GET", nil, nil, (nil :: any) :: {private: {string}, public: {string}})

	if not response.Success then
		warn("Failed to fetch assets: " .. response.Result)
		return {private = {}, public = {}}
	end

	return response.Result
end

function Net.CreateAsset(asset: buffer): Response<string>
	return Net.MakeRequest("assets", "POST", "application/octet-stream", buffer.tostring(asset), (nil :: any) :: string)
end

function Net.UpdateAsset(asset: buffer, assetId: string): Response<>
	local request = buffer.create(buffer.len(asset) + 8 + 1)
	buffer.writef64(request, 0, tonumber(assetId) or 0)
	buffer.copy(request, 8, asset)

	return Net.MakeRequest("assets", "PATCH", "application/octet-stream", buffer.tostring(request), nil)
end

function Net.FetchAssetContent(assetId: string): Response<string>
	return Net.MakeRequest("asset-content/" .. assetId, "GET", nil, nil, (nil :: any) :: string)
end

return Net