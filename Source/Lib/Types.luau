
export type function Override(base: type, override: type): type
	assert(base:is("table"), "Base must be a table")
	assert(override:is("table"), "Override must be a table")

	local indexer = override:indexer()
	if indexer then
		base:setindexer(indexer.index, indexer.readresult)
	end

	for k, v in override:properties() do
		base:setproperty(k, v.read)
	end

	return base
end

return nil