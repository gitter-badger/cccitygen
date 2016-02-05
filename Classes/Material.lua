
dofile "Classes/Block.lua"
dofile "Classes/Mutator.lua"
dofile "Interfaces/IHasChildren.lua"

class "Material"
{
	baseBlock = {};
	mutators = {};
}

function Material:Material( base )
	if not base:typeOf( Block ) then
		error( "Expected Block", 2 )
	end

	self.baseBlock = base:duplicate()

	self.mutators = {}

	self.meta.__call = self.getBlock
end

function Material:addMutator( mut, pos )
	if not mut:typeOf( Mutator ) then
		error( "Expected Mutator, optional position", 2 )
	end

	if type( pos ) then
		self.mutators[ #self.mutators + 1 ] = mut
		return true, "Added mutator to the end of mutator chain."
	end

	pos = math.floor( pos )

	if pos < 1 or pos > #self.mutators + 1 then
		error( "Invalid position", 2 )
	end

	return table.insert( self.mutators, pos, mut )
end

function Material:removeMutator( mut )
	if not mut:typeOf( Mutator ) then
		error( "Expected Mutator", 2 )
	end

	for i, m in ipairs( self.mutators ) do
		if m == mut then
			return table.remove( self.mutators, i )
		end
	end

	error( "No mutator found", 2 )
end

function Material:apply( x, y, z )
	local result = self.baseBlock:duplicate()

	for i, mutator in ipairs( self.mutators ) do
		result = mutator:apply( result, x, y, z )
	end

	return result
end

function Material:duplicate()
	local d = Material( self.baseBlock:duplicate() )

	for i, mutator in ipairs( self.mutators ) do
		d:addMutator( mutator )
	end

	return d
end

function Material:getBlock( x, y, z )
	return self.baseBlock:duplicate()
end

--TODO: Material:applyToGrid3D (+ overloads for __add)
