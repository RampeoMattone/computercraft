-- script created by GiappoNylon
-- this is a filter
-- the setup is as follows:
-- left -> output
-- right -> input
-- top -> filter input
-- bottom -> disk

local filter_path = "disk/filter.dat"

local function getFilter()
	if not fs.exists(filter_path) then
		local file = fs.open(filter_path, "w")
		file.writeLine("return {\n}")
		file.close()		
	end
	local filter = os.run({}, filter_path)
	print(filter)	
end

local function appendFilter(item)

end
