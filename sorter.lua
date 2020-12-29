-- script created by GiappoNylon
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
local function route(inv)
	table.sort(inv, compare) -- order each item based on distance from origin
	local i = 1
	while i < #inv do -- this loop will remove any duplicates in the ordered inventory scan, making it a list of items to deliver
		if inv[i] == inv[i+1] then table.remove(inv, i)
		else i = i+1
		end
	end
	return inv
end

turtle.select(1)
local routing = {}
os.run(routing, "routing.dat")
local steps, pos = 0, 0
local inventory_list, inventory_map = scan()
inventory_map = setmetatable(inventory_map, {
   __index = function(table, key)	
      if table[key] then return table[key]
      else return 10
      end
   end
})
for _, item in ipairs(route(inventory_list)) do
	steps = routing[item] - pos -- calculate how many steps to take
	pos = routing[item]
	for t=1, steps do repeat until turtle.forward() end -- take the steps
	turtle.turnRight()
	for _,slot in pairs(inventory_map[item]) do
		turtle.select(slot)
		while not turtle.drop() and turtle.up() do end
	end
	repeat until not turtle.down()
	turtle.turnLeft()
end
for t=1, pos do repeat until turtle.back() end -- go back to the input chest
