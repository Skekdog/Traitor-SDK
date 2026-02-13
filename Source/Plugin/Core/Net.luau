local HttpService = game:GetService("HttpService")

local Net = {}

local BASE_URL = "http://localhost:31352/"

export type Response<T = nil> = {
	Success: true,
	Result: T,
} | {
	Success: false,
	Result: string,
}

local key = "abc"

function Net.SetKey(newKey: string): ()
	key = newKey
end

function Net.MakeRequest<T>(endpoint: string, method: "POST" | "PATCH" | "GET", contentType: string?, body: string?): Response<T>
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

function Net.GetAvailableAssets(): {number}
	local response = Net.MakeRequest<<{number}>>("assets", "GET")

	if not response.Success then
		warn("Failed to fetch assets: " .. response.Result)
		return {}
	end

	return response.Result
end

function Net.CreateAsset(asset: buffer): Response<number>
	return Net.MakeRequest<<number>>("assets", "POST", "application/octet-stream", buffer.tostring(asset))
end

function Net.UpdateAsset(asset: buffer, assetId: number): Response<>
	local request = buffer.create(buffer.len(asset) + 8 + 1)
	buffer.writef64(request, 0, assetId)
	buffer.copy(request, 8, asset)

	return Net.MakeRequest<<nil>>("assets", "PATCH", "application/octet-stream", buffer.tostring(request))
end

function Net.FetchAssetContent(assetId: number): Response<any>
	return Net.MakeRequest<<any>>("asset-content/" .. assetId, "GET")
end

return Net