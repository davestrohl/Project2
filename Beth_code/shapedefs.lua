-- This file is for use with Corona(R) SDK
--
-- This file is automatically generated with PhysicsEdtior (http://physicseditor.de). Do not edit
--
-- Usage example:
--			local scaleFactor = 1.0
--			local physicsData = (require "shapedefs").physicsData(scaleFactor)
--			local shape = display.newImage("objectname.png")
--			physics.addBody( shape, physicsData:get("objectname") )
--

-- copy needed functions to local scope
local unpack = unpack
local pairs = pairs
local ipairs = ipairs

module(...)

function physicsData(scale)
	local physics = { data =
	{ 
		
		["filler_desk"] = {
			
				{
					density = 2, friction = 2, bounce = 0, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   -47, -109  ,  -180, -238  ,  187, -241  ,  178, -115  }
				}  ,
				{
					density = 2, friction = 2, bounce = 0, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   193.24560546875, 238.263157963753  ,  -183, 228  ,  -41, 99  ,  189, 123  }
				}  ,
				{
					density = 2, friction = 2, bounce = 0, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   -183, 228  ,  -180, -238  ,  -47, -109  ,  -41, 99  }
				}  
		}
		
		, 
		["filler_plant"] = {
			
				{
					density = 2, friction = 0, bounce = 0, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   -14, 34.5  ,  -31, 21  ,  -32.5, 3.5  ,  -22, -17.5  ,  -0.5, 5.5  ,  14.5, 25  }
				}  ,
				{
					density = 2, friction = 0, bounce = 0, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   -2.5, -21.5  ,  -0.5, 5.5  ,  -22, -17.5  ,  -29.5, -31  ,  -13, -41.5  }
				}  ,
				{
					density = 2, friction = 0, bounce = 0, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   -0.5, 5.5  ,  -2.5, -21.5  ,  28.5, -15  ,  50.5, 10  }
				}  ,
				{
					density = 2, friction = 0, bounce = 0, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   28.5, -15  ,  -2.5, -21.5  ,  28, -28.5  }
				}  
		}
		
	} }

	-- apply scale factor
	local s = scale or 1.0
	for bi,body in pairs(physics.data) do
		for fi,fixture in ipairs(body) do
			for ci,coordinate in ipairs(fixture.shape) do
				fixture.shape[ci] = s * coordinate
			end
		end
	end
	
	function physics:get(name)
		return unpack(self.data[name])
	end
	
	return physics;
end


