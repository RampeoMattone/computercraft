-- script created by GiappoNylon
-- this is a filter
-- the setup is as follows:
-- left -> output
-- right -> input
-- top -> filter input
-- bottom -> disk

local filter_path = "disk/filter.dat"

local function getFilter()
	local filter = {} -- the filter is a long list of 
	os.run(filter, filter_path)
end

local function appendFilter(item)

end
