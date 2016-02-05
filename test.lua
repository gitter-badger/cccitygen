
dofile "class.lua"

dofile "Classes/Structure.lua"
dofile "Classes/Block.lua"
dofile "Classes/Point3D.lua"
dofile "Classes/Wall.lua"
dofile "Classes/Room.lua"
dofile "Classes/MaterialPalette.lua"

dofile "Classes/ObjectFactory.lua"

dofile "Materials/WoodPlanksWall.lua"

local testOrigin = Point3D( 191, 4, 835 )

commands.fill( table.concat( { testOrigin:unpack() }, " " ) .. " " .. table.concat( { ( testOrigin + 25 ):unpack() }, " " ) .. " minecraft:air" )

local stoneBlock = Block()
stoneBlock.name = "minecraft:stone"

local stoneFactory = ObjectFactory( stoneBlock )

local glassBlock = Block()
glassBlock.name = "minecraft:glass"

local glassFactory = ObjectFactory( glassBlock )


--[[
	local test = Structure( "test", 50, 2, 50, 191, 4, 835, function()
		local x = Block()
		x.name = "minecraft:stone"
		return x
	end )

	print( test )

	-- test:build(  )

	print( "Test Wall" )

	local w = Wall( testOrigin, Point3D( 201, 5, 836 ), function()
		local x = Block()
		x.name = "minecraft:glass"
		return x
	end )

	-- w:build()

	print( w )

	print( "Test Point3D" )
	local a = Point3D( 5, 5, 5 )
	local b = Point3D( 2, 3, 4 )

	print( a )
	print( b )

	print( a - b )
]]

--[[print( "Waht tha fcuk" )
local w = Wall( testOrigin, testOrigin + 4, stoneFactory:getPortableConstructor() )
]]
-- w:build()


print( "Test Room" )

local p = MaterialPalette( {}, {}, { WoodPlanksWall }, {} )

local r = Room( testOrigin, testOrigin + 4, p )
r:build()
