local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )


local canon_size = 20
local canon = display.newRect( display.contentWidth/2, display.contentHeight - canon_size, canon_size, canon_size )
canon:setFillColor( 100, 200, 300 )

local bullet = display.newCircle( display.contentWidth/2 + canon_size/2, 450, 5 )
bullet:setFillColor( 150, 100, 300 )

physics.addBody( bullet, "dynamic", { density=1, radius = 3, bounce=.7, friction=.5 } )
bullet.isBullet = true
bullet.isAwake = false

local planets = {}
for planet_count=1, 3 do 
	local planet = display.newCircle( math.random(0, display.contentWidth), math.random(0, display.contentHeight), 20 )
	planet:setFillColor( math.random(0,255), math.random(0,255), math.random(0,255) )
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

function doplanet( event )
	if bullet.isAwake  then
		
		for i=1, #planets do 
			local planet = planets[i]
			local dist 	= distance( planet, bullet )
			local power = tmax/dist / strength
			local xmove = (planet.x-bullet.x) * power
			local ymove = (planet.y-bullet.y) * power


			print("xmove is : ".. xmove)
			print("ymove is : ".. ymove)
			print("power is : ".. power)
			print("--------")
			bullet:applyForce( xmove, ymove+push, bullet.x, bullet.y )
			draw_trail()
		end

		-- bullet:applyForce( xmove, ymove, planet.x, planet.y )
	end
end

function draw_trail()
	trail = display.newCircle( bullet.x, bullet.y, 1 )
	trail:setFillColor(240, 200, 190)
end

function fireCanon(event)
	bullet.isAwake = true
	print( "Bullet Fired!" )
	bullet:applyLinearImpulse( 0, -.1, bullet.x, bullet.y )
end

function onBulletCollision(event)
	print("boom")
	if event.phase == 'began' then
		colissionMark = display.newCircle( bullet.x, bullet.y, 5 )
		colissionMark:setFillColor( 255, 0, 0 )
	elseif event.phase == 'ended' then
		print( "Colission at X,Y : ".. bullet.x.. "," ..bullet.y )
	end
end

canon:addEventListener( "tap", fireCanon )
bullet:addEventListener( "collision", onBulletCollision )
Runtime:addEventListener( "enterFrame", doplanet )