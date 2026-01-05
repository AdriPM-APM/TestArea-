function onCreatePost()
    setProperty("camHUD.alpha", 0)
    setProperty("camGame.alpha", 0)
    precacheSound("DoorOpen")

    for i = 0, 4, 1 do
        precacheImage("cutscene/" .. i)
    end

    makeLuaSprite("cutsceneImages", "cutscene/0", 0, 0)
    setObjectCamera("cutsceneImages", 'other')
    scaleObject("cutsceneImages", 1.6, 1.6, true)
    setProperty("cutsceneImages.alpha", 0)
    addLuaSprite("cutsceneImages")

    makeLuaSprite("black", nil, 0, 0)
    setObjectCamera("black", 'other')
    makeGraphic("black", screenWidth + 1000, screenHeight + 1000, '000000')
    setProperty("black.alpha", 0)
    addLuaSprite("black")
end

function onEvent(eventName, value1, value2, strumTime)
    if eventName == '' then
        if value1 == 'cutsceneChange' then
            loadGraphic("cutsceneImages", "cutscene/" .. value2)
        end
        if value1 == 'sound' then
            playSound(tostring(value2), 5, "sound")
        end
        if value1 == 'start' then
            startTween('bye', 'cutsceneImages.scale', {
                x = 3,
                y = 3
            }, 1, {
                ease = 'expoIn'
            })
        end
        if value1 == 'realstart' then
            setProperty("camGame.alpha", 1)
            setProperty("camHUD.alpha", 1)
            removeLuaSprite("cutsceneImages")
            setProperty("black.alpha", 1)
            doTweenAlpha("black", "black", 0, 3, "linear")

            runHaxeCode([[
        var shaderlol0 = game.createRuntimeShader("pixel");
        game.camHUD.setFilters([new ShaderFilter(shaderlol0)]); 
        game.camGame.setFilters([new ShaderFilter(shaderlol0)]); 
        game.camOther.setFilters([new ShaderFilter(shaderlol0)]); 
        game.getLuaObject("pixelCam").shader = shaderlol0;
    ]])

            setShaderFloat("pixelCam", "scale", 1500)
        end
    end
    if eventName == 'Change Alpha' then
        doTweenAlpha("cutsceneImages", "cutsceneImages", value1, value2, "linear")
    end
end
