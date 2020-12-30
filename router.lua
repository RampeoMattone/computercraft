-- script created by GiappoNylon

local routing = {}
os.run(routing, "disk/routing.dat") -- load the filter that has already been written to disk
turtle.select(1)
print("type next to each item where you want it to go")
while turtle.suckUp() do -- get an item from the chest
	local id = turtle.getItemDetail().name -- get the item name
	local destination -- mod name, item name, place to put the item
	repeat -- ask the user where to put the item on sort
		local mod, item = string.match(id, "(.+):(.+)")
		print(mod, item, "\n where to?")
		destination = tonumber(io.read())
	until destination
	destination = math.floor(destination) -- make sure the number we received is an integer
	if not routing[mod] then -- generate an entry for the mod if it does not already exist
		routing[mod] = {}
	end
	routing[mod][item] = destination -- assign the item to a destination
	turtle.dropDown() -- release the item
end
local file = fs.open("routing.dat", "w") -- file where we append all items and destinations
if not file then return end
-- serialize the routing table
for mod in pairs(routing) do
	file.writeLine(mod .. "={}")
	for item, destination in pairs(routing[mod]) do
		file.writeLine(string.format("%s[%s]=%s", mod, item, destination))
	end
end
file.close()
print("all done. your items are in the chest below :)")
