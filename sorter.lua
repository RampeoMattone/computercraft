-- script created by GiappoNylon

local routing = {}
os.run(routing, "routing.dat")

-- scan the inventory to get all item id's and inventory slots
-- returns 2 tables scan and scan_reverse
local function scan()
	local inv, map, i = {}, {}, 1
	while turtle.suckUp() do
		local item = string.gsub(turtle.getItemDetail(i).name, ":", "_")
		inv[i] = item
		if not map[item] then
			map[item] = {i}
		else
			table.insert(map[item], i)
		end
		i = i + 1
	end
	return inv, map
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

local steps, pos = 0, 0
local scan_f, scan_r = scan()
for _, item in ipairs(route(scan_f)) do
	print(item)
	steps = routing[item] - pos -- calculate how many steps to take
	pos = routing[item]
	print(steps, pos) 
	for t=1, steps do repeat until turtle.forward() end -- take the steps
	turtle.turnRight()
	turtle.select(table.remove(item_reverse[item]))
	while not turtle.drop() and turtle.up do end
	repeat until not turtle.down()
	turtle.turnLeft()
end
for t=1, pos do repeat until turtle.back() end -- go back to the input chest
