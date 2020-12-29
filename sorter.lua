-- script created by GiappoNylon

local routing = {}
local function getRouting()
	os.run(routing, "routing.dat")
end

-- scan the inventory to get all item id's and inventory slots
-- returns 2 tables scan and scan_reverse
local function scan()
	local scan, scan_reverse = {}, {}
	for i=1, 16 do
		scan[i] = string.gsub(turtle.getItemDetail().name, ":", "_")
	end
	for k,v in pairs(scan) do
		if not scan_reverse[v] then scan_reverse[v] = {k}
		else table.insert(scan_reverse[v], k)
		end
	end
	return scan, scan_reverse
end

-- returns true if and only if the first item is closer to the starting point than the second
local function compare(i1, i2)
	if routing[i1] and routing[i2] then return routing[i1] < routing[i2]
	else return false
	end
end

-- generate a "route" i.e. generate an ordered list of items
local function route()
	local route, reverse = scan() -- route will be ordered from nearest to furthest from the turtle. reverse is a reverse table to match item id's with inv. slots
	table.sort(route, compare)
	return route
end

getRouting()
print(route())
