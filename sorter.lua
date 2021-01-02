-- script created by GiappoNylon

local routing = {}
local function setRoutes(default)
	os.run(routing, "disk/routing.dat") -- load specific routing
	local wildcards = {}
	os.run(wildcards, "disk/wildcards.dat") -- load wildcards
	for mod in pairs(wildcards) do
		if not routing[mod] then routing[mod] = {} end -- make sure the routing has every wildcarded mod mapped
		local wild_mt = {__index = function() return wildcards[mod] end}
		setmetatable(routing[mod], wild_mt) -- if an item is not found, we look at the route for its mod
	end
	-- if the mod is not found we need to return a default route.
	local default_route = {} -- because each mod is assigned a table of items, even the default route will need to have one
	setmetatable(default_route, {__index = function() return default end}) -- this is where the magic happens
	-- local general_mt = {__index = function() return default_route end} -- we assign the default route as the __index metamethod
	setmetatable(routing, default_route) -- this is where the magic happens pt 2
end

-- scan the inventory to get all item id's and inventory slots
-- returns 2 tables scan and scan_reverse
local function scan()
	local inv, map = {}, {}
	repeat turtle.suckUp() until turtle.getItemCount(15) ~= 0
	for i=1, 15 do
		local mod, item = string.match(turtle.getItemDetail(i).name, "(.+):(.+)")
		inv[i] = {["mod"] = mod, ["item"] = item}
		if not map[mod] then
			map[mod] = {[item] = {i}}
		elseif not map[mod][item] then
			map[mod][item] = {i}
		else
			table.insert(map[mod][item], i)
		end
	end
	return inv, map
end

-- returns true if and only if the first item is closer to the starting point than the second
local function compare(i1, i2)
	local pos1, pos2 = routing[i1.mod][i1.item], routing[i2.mod][i2.item]
	return pos1 < pos2
end

-- generate a "route" i.e. generate an ordered list of items
local function route(inv)
	table.sort(inv, compare) -- order each item based on distance from origin
	local i = 1
	while i < #inv do -- this loop will remove any duplicates in the ordered inventory scan, making it a list of items to deliver
		local slot = i + 1
		while slot <= #inv do
			if inv[i].mod == inv[slot].mod and inv[i].item == inv[slot].item then table.remove(inv, slot)
			else slot = slot + 1
			end
		end
		i = i + 1
	end
	return inv
end

-- refueler for the turtle. uses slot 16 to store the fuel ender chest
local function fuel()
	if turtle.getFuelLevel() == 0 then -- if we need to refuel because the level is critically low (aka 0)
		local slot = turtle.getSelectedSlot()
		turtle.select(16) -- we select the fuel ender chest
		turtle.turnLeft()
		repeat until turtle.place() -- make sure to free space above the turtle and place the chest
		repeat until turtle.suck() -- we wait until we get fuel and place it in slot 16
		turtle.refuel(turtle.getItemCount()) -- we refuel by the amount of items we sucked up from the chest
		turtle.dig() -- we remove the chest and place it in slot 16
		turtle.turnRight()
		turtle.select(slot)
	end
end


turtle.select(1)
setRoutes(1)
while true do
	local steps, pos = 0, 0
	local inventory_list, inventory_map = scan()
	local objects = route(inventory_list)
	for i=1, #objects do
		local obj = objects[i]
		print("depositing", obj.item)
		steps = routing[obj.mod][obj.item] - pos -- calculate how many steps to take
		pos = routing[obj.mod][obj.item]
		for t=1, steps do repeat fuel() until turtle.forward() end -- take the steps
		turtle.turnRight()
		for _,slot in pairs(inventory_map[obj.mod][obj.item]) do
			turtle.select(slot)
			repeat fuel() until turtle.drop() or not turtle.up()
		end
		repeat fuel() until not turtle.down()
		turtle.turnLeft()
	end
	for t=1, pos do
		repeat fuel() until turtle.back()
	end -- go back to the input chest
	for t=15, 1, -1 do
		turtle.select(t)
		turtle.dropDown()
	end
end
