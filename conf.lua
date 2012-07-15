function love.conf(t)

	t.author 	= "Leon Jiang"
	t.version 	= "0.8.0"
	
	t.console 			= true	 
	t.modules.joystick 	= false    
    t.modules.audio 	= true      
    t.modules.keyboard 	= true   
    t.modules.event 	= true      
    t.modules.image 	= true      
    t.modules.graphics 	= true   
    t.modules.timer 	= true      
    t.modules.mouse 	= true      
    t.modules.sound 	= true      
    t.modules.physics 	= true
    t.screen.fullscreen = false 
    t.screen.vsync 		= true
    
    t.screen.fsaa 		= 0           
    t.screen.height 	= 768
    t.screen.width 		= 1366   
	
end