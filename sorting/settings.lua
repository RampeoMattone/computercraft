-- script created by GiappoNylon

local config = {}
local continue = false
repeat -- ask the user where to put the item on sort
	print("do you want to use cheap fuel [y/n]")
	local answer = io.read()
	if answer == "y" then
		config.cheapFuel = true
		continue = true
	elseif answer == "n" 
		config.cheapFuel = false
		continue = true
	end
until continue
print("done")
