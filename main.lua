local Map = require( "TileMapLoader.map" )


local world = Map.new( "map.json" )

local Car = require( "car" )

local camera = require( "2DCamera.camera" ).new
{
    view = world,
    trackingSpeed = 0.05,
    maxVelocity = 10,
    maxZoom = 3,
    minZoom = 0.25
}

local focusCar = 1
local cars = {}

cars[ #cars + 1 ] = Car.new
{
    parent = world,
    playerIndex = #cars + 1,
    x = math.random( 100, display.contentWidth - 100 ),
    y = math.random( 100, display.contentHeight - 100 ),
    rotation = math.random( 360 ),
    isSmoothingDisabled = camera.isSmoothingDisabled(),
    controls = { go = "up", stop = "down", left = "left", right = "right", reallyStop = "space", zoomIn = "x", zoomOut = "c" }
}

cars[ #cars + 1 ] = Car.new
{
    parent = world,
    playerIndex = #cars + 1,
    x = math.random( 100, display.contentWidth - 100 ),
    y = math.random( 100, display.contentHeight - 100 ),
    rotation = math.random( 360 ),
    isSmoothingDisabled = camera.isSmoothingDisabled(),
    controls = { go = "w", stop = "s", left = "a", right = "d", reallyStop = "z", zoomIn = "x", zoomOut = "c" }
}

local frames = 0
local onEnterFrame = function( event )

    camera.update( 1 )

    local focus = cars[ focusCar ].getCameraFocus()

    if camera.getMaxZoom() and focus.zoom > camera.getMaxZoom() then
        focus.zoom = camera.getMaxZoom()
    elseif camera.getMinZoom() and focus.zoom < camera.getMinZoom() then
        focus.zoom = camera.getMinZoom()
    end

    camera.setBounds( 0, 0, world.getTileLayer( "track" ).contentWidth, world.getTileLayer( "track" ).contentHeight )
    camera.focusOn( focus.x, focus.y, focus.zoom, focus.rotation )
    --camera.clampPosition()

    local column, row = world.worldToMap( focus.x, focus.y )

    if frames == 0 or frames % 30 == 0 then
       world.render( column, row, 4, 3 )
    end

    frames = frames + 1

end
Runtime:addEventListener( "enterFrame", onEnterFrame )

local onKey = function( event )

    if event.phase == "down" and cars[ tonumber( event.keyName ) ] then
        focusCar = tonumber( event.keyName )
    end

end
Runtime:addEventListener( "key", onKey )
