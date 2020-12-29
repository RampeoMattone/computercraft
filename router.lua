-- script created by GiappoNylon

local routing = fs.open("filter.dat", "a") -- file where we append all items and destinations
if not routing then return end
print("type next to each item where you want it to go")
turtle.select(1)
while turtle.suck() do
	local item = turtle.getItemDetail().name
	local destination
	repeat
		print(item, "goes to:")
		destination = tonumber(io.read())
	until destination
	destination = math.floor(destination)
	routing.write('"' .. item  .. '"' .. "=" .. destination)
	turtle.dropUp()
end
routing.close()

