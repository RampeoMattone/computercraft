-- script created by GiappoNylon

local function bulk()
	local specific = {}
	if fs.exists("disk/routing.dat") then
		local file = fs.open("disk/routing.dat", "r")
		specific = textutils.unserialise(file.readAll())
		file.close()
	end
	turtle.select(1)
	print("type where you want all these items to go:")
	local destination
	repeat -- ask the user where to put the item on sort
			destination = tonumber(io.read())
	until destination
	while turtle.suckDown() do -- get an item from the chest
		local id = turtle.getItemDetail().name -- get the item name
		local mod, item = string.match(id, "(.+):(.+)")
		local destination -- mod name, item name, place to put the item
		local mod, item
		destination = math.floor(destination) -- make sure the number we received is an integer
		if not specific[mod] then -- generate an entry for the mod if it does not already exist
			specific[mod] = {}
		end
		specific[mod][item] = destination -- assign the item to a destination
		turtle.dropUp() -- release the item
	end
	local json = textutils.serialise(specific)
	local file = fs.open("disk/routing.dat", "w") -- file where we append all items and destinations
	if not file then return end
	-- serialize the routing table
	file.write(json)
	file.close()
end


local function specific()
	local specific = {}
	if fs.exists("disk/routing.dat") then
		local file = fs.open("disk/routing.dat", "r")
		specific = textutils.unserialise(file.readAll())
		file.close()
	end
	
	turtle.select(1)
	print("type next to each item where you want it to go")
	while turtle.suckDown() do -- get an item from the chest
		local id = turtle.getItemDetail().name -- get the item name
		local destination -- mod name, item name, place to put the item
		local mod, item = string.match(id, "(.+):(.+)")
		repeat -- ask the user where to put the item on sort
			print(mod, item, "will be sent to:")
			destination = tonumber(io.read())
		until destination
		destination = math.floor(destination) -- make sure the number we received is an integer
		if not specific[mod] then -- generate an entry for the mod if it does not already exist
			specific[mod] = {}
		end
		specific[mod][item] = destination -- assign the item to a destination
		turtle.dropUp() -- release the item
	end
	local json = textutils.serialise(specific)
	local file = fs.open("disk/routing.dat", "w") -- file where we append all items and destinations
	if not file then return end
	-- serialize the routing table
	file.write(json)
	file.close()
end

local function wildcards()
	local wildcards = {}
	if fs.exists("disk/wildcards.dat") then
		local file = fs.open("disk/wildcards.dat", "r")
		wildcards = textutils.unserialise(file.readAll())
		file.close()
	end
	--local wildcards = {}
	--os.run(wildcards, "disk/wildcards.dat") -- load the filter that has already been written to disk
	turtle.select(1)
	print("type next to each mod where you want it to go")
	while turtle.suckDown() do -- get an item from the chest
		local id = turtle.getItemDetail().name -- get the item name
		local destination -- mod name, item name, place to put the item
		local mod = string.match(id, "(.+):.+")
		repeat -- ask the user where to put the item on sort
			print(mod, "will be sent to:")
			destination = tonumber(io.read())
		until destination
		destination = math.floor(destination) -- make sure the number we received is an integer
		wildcards[mod] = destination -- assign the mod to a destination
		turtle.dropUp() -- release the item
	end
	local json = textutils.serialise(wildcards)
	local file = fs.open("disk/wildcards.dat", "w") -- file where we append all items and destinations
	if not file then return end
	file.write(json)
	file.close()
end

local choice
repeat --ask the user what he wants to set up (wildcards/specific routes)
	print("type W to define wildcards, S to define specific routes for each item or B to define specific routes for every item in the bottom chest")
	choice = io.read():lower()
until choice == "w" or choice == "s" or choice == "b"
if choice == "w" then wildcards()
else specific()
end
print("all done. your items are in the chest below :)")
