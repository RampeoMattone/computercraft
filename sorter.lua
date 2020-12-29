-- script created by GiappoNylon

local routing = {}
os.run(routing, "routing.dat")

-- scan the inventory to get all item id's and inventory slots
-- returns 2 tables scan and scan_reverse
local function scan()
	local scan, scan_reverse, i = {}, {}, 1
	while turtle.suckUp() do
		scan[i] = string.gsub(turtle.getItemDetail(i).name, ":", "_")
		i = i + 1
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
	elseif routing[i1] then return true
	else return false
	end
end

-- generate a "route" i.e. generate an ordered list of items
local function route(inventory)
	table.sort(inventory, compare)
	return inventory
end

local function drop(item, item_reverse)
	for slot in item_reverse[item] do
		turtle.select(slot)
		while not turtle.drop() and turtle.up do end
	end
	repeat until not turtle.down()
end

local steps, pos = 0, 0
local scan_f, scan_r = scan()
for _, item in pairs(route(scan_f)) do
	steps = routing[item] - pos -- calculate how many steps to take
	pos = routing[item] 
	for t=1, steps do repeat until turtle.forward() end -- take the steps
	turtle.turnRight()
	drop(item)
	turtle.turnLeft()
end
for t=1, pos do repeat until turtle.back() end -- go back to the input chest
