-- script created by GiappoNylon

local routing = fs.open("filter.dat", "a") -- file where we append all items and destinations
if not routing then return end
turtle.select(1)
print("type next to each item where you want it to go")
while turtle.suck() do
	local item = turtle.getItemDetail().name
	print(item, "goes to:")
	local destination = tonumber(io.read())
	if destination then
		destination = math.floor(destination)
		routing:write(item .. "=" .. destination)
	end
end
routing:close()

