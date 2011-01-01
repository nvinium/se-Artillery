module(..., package.seeall)

-- Main function - MUST return a display.newGroup()
function new()
	local localGroup = display.newGroup()
	
	-- Background
	local background = display.newImage("images/backgrounds/menu.png")
	localGroup:insert(background)
	
	-- Buttons
	local singlePlayerButton = display.newImage("images/buttons/singlePlayer.png")
	local function singlePlayerPressed ( event )
		if event.phase == "ended" then
			director:changeScene("game", "fade", "green")
		end
	end
	singlePlayerButton:addEventListener("touch", singlePlayerPressed)
	singlePlayerButton.x = 160
	singlePlayerButton.y = 80	
	localGroup:insert(singlePlayerButton)
	
	local singlePlayerButton = display.newImage("images/buttons/singlePlayer.png")
	local function singlePlayerPressed ( event )
		if event.phase == "ended" then
			director:changeScene("game", "fade", "green")
		end
	end
	singlePlayerButton:addEventListener("touch", singlePlayerPressed)
	singlePlayerButton.x = 160
	singlePlayerButton.y = 80	
	localGroup:insert(singlePlayerButton)

	local multiPlayerButton = display.newImage("images/buttons/multiPlayer.png")
	multiPlayerButton.x = 160
	multiPlayerButton.y = 130	
	localGroup:insert(multiPlayerButton)
	
	local helpButton = display.newImage("images/buttons/help.png")
	local function helpPressed ( event )
		if event.phase == "ended" then
			director:changeScene("help", "fade", "green")
		end
	end
	helpButton:addEventListener("touch", helpPressed)	
	helpButton.x = 160
	helpButton.y = 180	
	localGroup:insert(helpButton)
	
	local aboutButton = display.newImage("images/buttons/about.png")
	local function aboutPressed ( event )
		if event.phase == "ended" then
			director:changeScene("about", "fade", "green")
		end
	end
	aboutButton:addEventListener("touch", aboutPressed)	
	aboutButton.x = 160
	aboutButton.y = 230	
	localGroup:insert(aboutButton)	
					
					
	unloadMe = function()
	end
						
	-- MUST return a display.newGroup()
	return localGroup
end
