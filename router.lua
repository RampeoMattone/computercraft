-- script created by GiappoNylon

local routing = fs.open("filter.dat", "a") -- file where we append all items and destinations
if not routing then return end
print("type next to each item where you want it to go")
turtle.select(1)
while turtle.suckUp() do
	local item = turtle.getItemDetail().name
	local destination
	repeat
		print(item, "goes to:")
		destination = tonumber(io.read())
	until destination
	destination = math.floor(destination)
	item = string.gsub(item, ":", "§")
	routing.writeLine(item .. "=" .. destination)
	turtle.dropDown()
end
routing.close()
print("all done. your items are in the chest below :)")
