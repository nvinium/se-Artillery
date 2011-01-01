local physics = require( "physics" )

module(..., package.seeall)

-- Main function - MUST return a display.newGroup()
function new()	
	local gameGroup = display.newGroup()
	
	-- add a back to main menu rectangle
	quitButton = display.newRect( display.contentWidth - 20, display.contentHeight - 20, 20, 20)
	quitButton:setFillColor( 50, 50, 50)
	gameGroup:insert(quitButton)
	local function quitTouched ( event )
		if event.phase == "ended" then
			director:changeScene("menu", "fade")
		end
	end
	quitButton:addEventListener("touch", quitTouched)	
	
	physics.start()
	physics.setGravity( 0, 0 )

	local canon_size = 20
	local canon = display.newRect( display.contentWidth/2, display.contentHeight - canon_size, canon_size, canon_size )
	canon:setFillColor( 100, 200, 300 )
	gameGroup:insert(canon)

	local planets = {}
	local bullets = {}

	for planet_count=1, 3 do 
		local planet = display.newCircle( math.random(0, display.contentWidth), math.random(0, display.contentHeight), 20 )
		planet:setFillColor( math.random(0,255), math.random(0,255), math.random(0,255) )
		gameGroup:insert(planet)
		physics.addBody( planet, "static", { friction=0.5, radius=20, friction=.9 } )
		planets[#planets + 1] = planet
	end

	function distance( a, b )
		local width, height = b.x-a.x, b.y-a.y
		return math.sqrt( width*width + height*height )
	end

	local tmax = distance( {x=0, y=0}, {x=display.contentWidth, y=display.contentHeight} )
	local strength = 10000

	local xmove = 0
	local ymove = -.5
	local push = -.01

	function doPlanet( event )
		for i=1, #bullets do
			bullet = bullets[i]
			if bullet.isAwake then
				dist = 0
				power = 0 
				xmove = 0 
				ymove = 0
				for j=1, #planets do 
					planet = planets[j]
					dist 	= distance( planet, bullet )
					power = tmax/dist / strength
					xmove = (planet.x-bullet.x) * power
					ymove = (planet.y-bullet.y) * power

					-- print("xmove is : ".. xmove)
					-- print("ymove is : ".. ymove)
					-- print("power is : ".. power)
					-- print("--------")
					bullet:applyForce( xmove, ymove+push, bullet.x, bullet.y )
					draw_trail()
				end
			end
		end
	end

	function draw_trail()
		for i=1, #bullets do 
			bullet = bullets[i]
			j = #bullet.trails+1
			bullet.trails[j] = display.newCircle( bullet.x, bullet.y, 1 )
			bullet.trails[j]:setFillColor(240, 200, 190)
			gameGroup:insert(bullet.trails[j])
			if #bullet.trails > 100 then
				bullet.trails[j-100]:removeSelf()
			end
		end
	end

	function fireCanon(event)
		i = #bullets + 1
		bullets[i] = display.newCircle( display.contentWidth/2 + canon_size/2, 450, 5 )
		gameGroup:insert(bullets[i])
		bullet = bullets[i]
		bullet.trails = {}
		bullet:setFillColor( 150, 100, 300 )
		physics.addBody( bullet, "dynamic", { density=1, radius = 3, bounce=.7, friction=.5 } )
		bullet.isBullet = true
		bullet.collision = onBulletCollision
		bullet:addEventListener( "collision", bullet )
	
		print( "Bullet Fired!" )
		touch_dist = distance( event, bullet )
		init_power = tmax/touch_dist / strength
		xmove = (event.x-bullet.x) * init_power
		ymove = (event.y-bullet.y) * init_power
		bullet:applyLinearImpulse( xmove, ymove, bullet.x, bullet.y )
	end

	function onBulletCollision(self, event)
		print("boom")
		if event.phase == 'began' then
			colissionMark = display.newCircle( self.x, self.y, 5 )
			gameGroup:insert(colissionMark)
			colissionMark:setFillColor( 255, 0, 0 )
		elseif event.phase == 'ended' then
			print( "Ball ".. "Colission at X,Y : ".. self.x.. "," ..self.y )
		end
	end

	Runtime:addEventListener( "tap", fireCanon )
	Runtime:addEventListener( "enterFrame", doPlanet )
	
	unloadMe = function()
		print( "Cleaning up..." )
		physics.stop()

		Runtime:removeEventListener( "tap", fireCanon )
		Runtime:removeEventListener( "enterFrame", doPlanet )
						
		-- planets = nil
		-- bullets = nil
	end	
	
	return gameGroup	
end