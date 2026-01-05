local zoomFree = false
local yeafight = false

local hallwaySpeed = 1200
local hallwayWidth = 1366 * 1.4 

function onCreatePost()
    initLuaShader("pixel")
    setProperty('comboGroup.visible', false)
    setProperty("dad.scale.x", 0.28)
    setProperty("dad.scale.y", 0.28)

    makeLuaSprite("schoolHouseEntrance", "stages/schoolHouseEntrance", 0, 0)
    scaleObject("schoolHouseEntrance", 1.4, 1.4)
    addLuaSprite("schoolHouseEntrance", false)
    setProperty("schoolHouseEntrance.antialiasing", false)

    makeLuaSprite("schoolHouseHallway1", "stages/schoolHouseHallway", 0, 0)
    scaleObject("schoolHouseHallway1", 1.4, 1.4)
    addLuaSprite("schoolHouseHallway1", false)
    setProperty("schoolHouseHallway1.alpha", 0.0001)
    setProperty("schoolHouseHallway1.antialiasing", false)

    makeLuaSprite("schoolHouseHallway2", "stages/schoolHouseHallway", 0, 0)
    scaleObject("schoolHouseHallway2", 1.4, 1.4)
    addLuaSprite("schoolHouseHallway2", false)
    setProperty("schoolHouseHallway2.alpha", 0.0001)
    setProperty("schoolHouseHallway2.antialiasing", false)

    makeLuaSprite("pixelCam")
    makeGraphic("pixelCam", screenWidth, screenHeight)
    addHaxeLibrary("ShaderFilter", "openfl.filters")

    runHaxeCode([[
        var shaderlol0 = game.createRuntimeShader("pixel");
        game.camHUD.setFilters([new ShaderFilter(shaderlol0)]); 
        game.camGame.setFilters([new ShaderFilter(shaderlol0)]); 
        game.camOther.setFilters([new ShaderFilter(shaderlol0)]); 
        game.getLuaObject("pixelCam").shader = shaderlol0;
    ]])

    setShaderFloat("pixelCam", "scale", 1800)
end

function onSectionHit()
    if not zoomFree then
        if not getProperty("isCameraOnForcedPos")then
            if not mustHitSection then
                setProperty("defaultCamZoom", 2.6)
            else
                setProperty("defaultCamZoom", 1.4)
            end
        end
    end
end

function onEvent(eventName, value1, value2, strumTime)
    if eventName == '' then
        if value1 == 'zoomFree' then
            if value2 == 'on' then
                zoomFree = true
            elseif value2 == 'off' then
                zoomFree = false
            end
        end
        if value1 == '4' then
            zoomFree = true
        end
        if value1 == '7' then
            zoomFree = false
        end
        if value1 == 'runstart' then
            setProperty("schoolHouseHallway1.alpha", 1)
            setProperty("schoolHouseHallway2.alpha", 1)
        end
        if value1 == 'norunbro' then
            setProperty("schoolHouseHallway1.alpha", 0)
            setProperty("schoolHouseHallway2.alpha", 0)
            setProperty("schoolHouseEntrance.alpha", 1)
            loadGraphic("schoolHouseEntrance", "stages/schoolHouseHallway")
        end
        if value1 == 'f' then
            yeafight = true
        end
        if value1 == 'fa' then
            yeafight = false
        end
    end
end

function onUpdate(elapsed)
    local moveAmount = hallwaySpeed * elapsed

    setProperty("schoolHouseHallway1.x", getProperty("schoolHouseHallway1.x") - moveAmount)
    setProperty("schoolHouseHallway2.x", getProperty("schoolHouseHallway2.x") - moveAmount)

    if getProperty("schoolHouseHallway1.x") + hallwayWidth <= 0 then
        setProperty("schoolHouseHallway1.x", getProperty("schoolHouseHallway2.x") + hallwayWidth)
    end
    if getProperty("schoolHouseHallway2.x") + hallwayWidth <= 0 then
        setProperty("schoolHouseHallway2.x", getProperty("schoolHouseHallway1.x") + hallwayWidth)
    end
end

function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if yeafight then
        if not isSustainNote then
            setProperty("schoolHouseEntrance.x", getProperty("schoolHouseEntrance.x") - 30)
        end
    end
end