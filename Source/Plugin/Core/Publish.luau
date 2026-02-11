local HttpService = game:GetService("HttpService")
local SerializationService = game:GetService("SerializationService")
local Message = require("../../Lib/Message")

local KEY = "abc"

local function createAsset(serialised: buffer)
	return HttpService:RequestAsync({
		Url = "http://localhost:31352/publish-map",
		Method = "POST",
		Body = buffer.tostring(serialised),
		Headers = {
			Authorization = "Bearer " .. KEY,
			["Content-Type"] = "application/octet-stream"
		},
		Compress = Enum.HttpCompression.None,
	})
end

local function updateAsset(serialised: buffer, assetId: number)
	local updateRequest = buffer.create(buffer.len(serialised) + 8)
	buffer.copy(updateRequest, 8, serialised)
	buffer.writef64(updateRequest, 0, assetId)

	return HttpService:RequestAsync({
		Url = "http://localhost:31352/publish-map",
		Method = "PATCH",
		Body = buffer.tostring(updateRequest),
		Headers = {
			Authorization = "Bearer " .. KEY,
			["Content-Type"] = "application/octet-stream"
		},
		Compress = Enum.HttpCompression.None,
	})
end

local function Publish(instance: Instance): ()
	local serialised = SerializationService:SerializeInstancesAsync({instance})

	local response
	if true then
		response = createAsset(serialised)
	else
		response = updateAsset(serialised, 104086335415869)
	end

	if not response.Success then
		return Message("Failed to upload map: " .. (response.Body or response.StatusMessage), "error")
	end

	Message("Map uploaded! You may load it in Labs.", "success")
end

return Publish