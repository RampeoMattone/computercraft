-- script created by GiappoNylon

local routing = {}

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
	local a, b = routing[i1], routing[i2]
	return a < b
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
os.run(routing, "routing.dat")
local mt = {__index = function () return 10 end}
setmetatable(routing, mt)
while true do
	local steps, pos = 0, 0
	local inventory_list, inventory_map = scan()
	for _, item in ipairs(route(inventory_list)) do
		steps = routing[item] - pos -- calculate how many steps to take
		pos = routing[item]
		for t=1, steps do repeat until turtle.forward() end -- take the steps
		turtle.turnRight()
		for _,slot in pairs(inventory_map[item]) do
			turtle.select(slot)
			while
				not turtle.detectUp() and
				not turtle.drop()
			do
				turtle.up()
			end
		end
		repeat until not turtle.down()
		turtle.turnLeft()
	end
	for t=1, pos do repeat until turtle.back() end -- go back to the input chest
	for t=16, 1, -1 do
		turtle.select(t)
		turtle.dropDown()
	end
	sleep(30)
end
