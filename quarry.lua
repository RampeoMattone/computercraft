-- Script created by GiappoNylon
-- check to see if all the required parameters are present
local tArgs = { ... }
if #tArgs ~= 2 then
	error("Use: dig <length and width> <depth>")
end
-- now we capture them
local dim = tonumber(tArgs[1]) or 10 -- length and width as a number or 10
local dep = tonumber(tArgs[2]) or 10 -- depth as a number or 10
dim = math.floor(dim) -- converting floats to integers
dep = math.floor(dep) -- converting floats to integers

-- refueler for the turtle. uses slot 16 to store the fuel ender chest
local function fuel()
	if turtle.getFuelLevel() == 0 then -- if we need to refuel because the level is critically low (aka 0)
		turtle.select(16) -- we select the fuel ender chest
		repeat turtle.digUp() until turtle.placeUp() -- make sure to free space above the turtle and place the chest
		repeat until turtle.suckUp() -- we wait until we get fuel and place it in slot 16
		turtle.refuel(turtle.getItemCount()) -- we refuel by the amount of items we sucked up from the chest
		turtle.digUp() -- we remove the chest and place it in slot 16
	end
end

-- in order to dig without losing materials we use this function
local function check()
	local empty = 14 -- the turtle uses two slots out of 16 for ender chests. all other slots (14) can be used for pickups
	for i=1, 14 do -- every time we dig we check to see if all our slots are full
		if turtle.getItemCount(i) > 0 then empty = empty - 1 end -- every slot with an item count greater than zero is counted as "full"
	end
	if empty == 0 then -- if we have no more space for new items we need to empty our inventory
		turtle.select(15) -- we select the item drop chest
		repeat turtle.digUp() until turtle.placeUp() -- make sure to free space above the turtle and place the chest
		for i=1, 14 do -- for every slot we use for pickups
			turtle.select(i) -- select the slot in question
			repeat until turtle.dropUp() -- we wait until we can drop all of our items in it
		end
		turtle.select(15) -- we select the slot for the item chest
		turtle.digUp() -- we collect the chest
	end
end

local function forward(blocks) -- wrapper to make a the turtle move n blocks forward or just 1 block if no argument is specified
	for i=1, blocks or 1 do
		repeat turtle.dig() until turtle.forward() -- the function will try to move forward auntil it eventually does
	end
end

-- this function will alternate turning left and right to cover a square area
local function turn(pos)
	if math.mod(pos,2) == 0 then -- every time that pos is even we turn to our left
		turtle.turnLeft()
		check()
		forward() -- move forward to "change lane"
		turtle.turnLeft()
	else -- else, when it is odd, we turn to our right
		turtle.turnRight()
		check()
		forward() -- move forward to "change lane"
		turtle.turnRight()
	end
end

-- this function will be used to bring the turtle back to its starting position on an odd number of lanes
local function back_odd()
	turtle.turnLeft()
	forward(dim - 1)
	turtle.turnLeft()
	forward(dim - 1)
	turtle.turnLeft()
	turtle.turnLeft()
end

-- this function will be used to bring the turtle back to its starting position on an even number of lanes
local function back_even()
	turtle.turnRight()
	forward(dim - 1)
	turtle.turnRight()
end

-- this is the actual script
local back -- the function tha will make the turtle go back to the starting position on each layer
if math.mod(dim, 2) == 0 then
	back = back_even -- if the number of lanes is even we use this function
else
	back = back_odd -- else we use this one
end
-- setup phase (break the first block and get in the corner of the selected area)
check() -- check the inventory to see if it needs emptying
fuel() -- before we move we need to check out fuel
repeat turtle.digDown() until turtle.down() -- go down in the hole
-- repetition phase (excavate the whole block)
for z=1, dep do -- we dig until we reach the desired depth
	for y=1, dim do -- y is the lane
		for x=1, dim - 1 do -- x is the position in the lane
			check() -- check the inventory to see if it needs emptying
			fuel() -- before we move we need to check out fuel
			forward() -- then we can move
		end
		if y ~= dim then -- unless we are on the last lane we want to turn around
			-- once a whole lane is completed we turn.
			-- we use the lane number to alternate turns and cover a square area
			turn(y)
		end
	end
	back() -- once we finish digging up a layer we turn back to the starting position of the quarry
	-- we dig down a layer and we repeat the process
	if z ~= dep then -- unless we are on the last layer we want to turn dig down and descend
		check() -- check to see if inventory is full
		fuel() -- before we move we need to check out fuel
		repeat turtle.digDown() until turtle.down() -- go down in the hole
	end
end
