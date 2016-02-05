
dofile "Classes/Material.lua"
dofile "Classes/Block.lua"

local woodPlanksBlock = Block()
woodPlanksBlock.name = "minecraft:planks"

local function mut( block, x, y, z )
	-- Note:	There is no need for a mutator, as a wood planks wall simply
	--			consists of woodPlanksBlocks.
end

WoodPlanksWall = Material( woodPlanksBlock )	-- :addMutator( mut )
