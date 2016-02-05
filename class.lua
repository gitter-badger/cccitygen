
-- Exerro's (Benedict Allen's) class library

class = {}
local classobj = setmetatable( {}, { __index = class } )
local __names = {}
local names = setmetatable ( {}, { __newindex = function( t, k, v )
	--[[if k == "Structure" then
				print( "newindex @names:", t, "key", k, "value", v )
				read()
			end]]
	__names[k] = v
end;
__index = __names;
} )
local interfaces = {}
local last_created

local supportedMetaMethods = { __add = true, __sub = true, __mul = true, __div = true, __mod = true, __pow = true, __unm = true, __len = true, __eq = true, __lt = true, __lte = true, __tostring = true, __concat = true }

local function _tostring( self )
	return "[Class] " .. self:type()
end
local function _concat( a, b )
	return tostring( a ) .. tostring( b )
end

local function construct( t )
	if not last_created then
		return error "no class to define"
	end

	for k, v in pairs( t ) do
		last_created[k] = v
	end
	last_created = nil
end

local function newSuper( object, super )

	local superProxy = {}

	if super.super then
		superProxy.super = newSuper( object, super.super )
	end

	setmetatable( superProxy, { __index = function( t, k )

		if type( super[k] ) == "function" then
			return function( self, ... )

				if self == superProxy then
					self = object
				end
				object.super = superProxy.super
				local v = { super[k]( self, ... ) }
				object.super = superProxy
				return unpack( v )

			end
		else
			return super[k]
		end

	end, __newindex = super, __tostring = function( self )
		return "[Super] " .. tostring( super ) .. " of " .. tostring( object )
	end } )

	return superProxy

end

function classobj:new( ... )

	local mt = { __index = self, __INSTANCE = true }
	local instance = setmetatable( { class = self, meta = mt }, mt )

	if self.super then
		instance.super = newSuper( instance, self.super )
	end

	for k, v in pairs( self.meta ) do
		if supportedMetaMethods[k] then
			mt[k] = v
		end
	end

	if mt.__tostring == _tostring then
		function mt:__tostring()
			return self:tostring()
		end
	end

	function instance:type()
		return self.class:type()
	end

	function instance:typeOf( class )
		return self.class:typeOf( class )
	end

	if not self.tostring then
		function instance:tostring()
			return "[Instance] " .. self:type()
		end
	end

	local ob = self
	while ob do
		if ob[ob.meta.__type] then
			ob[ob.meta.__type]( instance, ... )
			break
		end
		ob = ob.super
	end

	return instance

end

function classobj:extends( super )
	self.super = super
	self.meta.__index = super
end

function classobj:type()
	return tostring( self.meta.__type )
end

function classobj:typeOf( super )
	return super == self or ( self.super and self.super:typeOf( super ) ) or false
end

function class:new( name )

	if type( name or self ) ~= "string" then
		return error( "expected string class name, got " .. type( name or self ) )
	end

	local mt = { __index = classobj, __CLASS = true, __tostring = _tostring, __concat = _concat, __call = classobj.new, __type = name or self }
	local obj = setmetatable( { meta = mt }, mt )

	names[name] = obj
	last_created = obj

	_ENV[name] = obj

	return function( t )
		if not last_created then
			return error "no class to define"
		end

		for k, v in pairs( t ) do
			last_created[k] = v
		end
		last_created = nil
	end

end

function class.type( object )
	local _type = type( object )

	if _type == "table" then
		pcall( function()
			local mt = getmetatable( object )
			_type = ( ( mt.__CLASS or mt.__INSTANCE ) and object:type() ) or _type
		end )
	end

	return _type
end

function class.typeOf( object, class )
	if type( object ) == "table" then
		local ok, v = pcall( function() return getmetatable( object ).__CLASS or getmetatable( object ).__INSTANCE or error() end )
		return ok and object:typeOf( class )
	end

	return false
end

function class.isClass( object )
	return pcall( function() if not getmetatable( object ).__CLASS then error() end end ), nil
end

function class.isInstance( object )
	return pcall( function() if not getmetatable( object ).__INSTANCE then error() end end ), nil
end

setmetatable( class, {
	__call = class.new;
} )

function extends( name )
	if not last_created then
		return error "no class to extend"
	end

	if not names[name] then
		return error( "no such class '" .. tostring( name ) .. "'" )
	end

	last_created:extends( names[name] )
	
	return construct
end

function interface( name )
	interfaces[name] = {}
	_ENV[name] = interfaces[name]
	return function( t )
		if type( t ) ~= "table" then
			return error( "expected table t, got " .. class.type( t ) )
		end
		_ENV[name] = t
		interfaces[name] = t
	end
end

function implements( name )
	if not last_created then
		return error "no class to modify"
	elseif not interfaces[name] then
		return error( "no interface by name '" .. tostring( name ) .. "'" )
	end

	for k, v in pairs( interfaces[name] ) do
		last_created[k] = v
	end
	
	return construct
end
