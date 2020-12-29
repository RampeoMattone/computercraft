while true do
	turtle.attack()
	for i=1, 16 do
		turtle.select(i)
		local item = turtle.getItemDetail()
		if item.name == "minecraft:blaze_rod" then
			repeat until turtle.dropUp()
		else
			turtle.dropDown()
		end
	end
end
