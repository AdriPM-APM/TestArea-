local healtH = {"iconP1", "iconP2", "healthBar", "scoreTxt"}

function onCreatePost()
    local screen = screenWidth + 100
    local targetX = {}
    screen = 1280
    for strums = 0, 7 do
        if strums < 4 then
            if not middlescroll then
                table.insert(targetX, 0 + (112 * strums + 100))
            else
                if strums < 2 then
                    table.insert(targetX, 0 + (112 * strums + 100))
                else
                    table.insert(targetX, screen - 620 + (112 * strums + 100))
                end
            end
        else
            if not middlescroll then
                table.insert(targetX, screen - 440 + (112 * (strums - 5)))
            else
                table.insert(targetX, screenWidth / 2.0 - 112 + (112 * (strums - 5)))
            end
        end
    end
    setProperty('camGame.targetOffset.x', 0)
    setProperty('camGame.targetOffset.y', -100)

    for strums = 0, 7 do
        setPropertyFromGroup('strumLineNotes', strums, 'x', targetX[strums + 1])
    end

    if downscroll then
        for strums = 0, 7 do
            setPropertyFromGroup('strumLineNotes', strums, 'y', getPropertyFromGroup('strumLineNotes', strums, 'y') + 230)
        end
    end
    local middleCam = (screenWidth - screen) / 2.0
    setProperty('timeBar.x', (screen - getProperty('timeBar.width')) / 2.0)
    setProperty('timeTxt.x', screen / 2.0 - 248 + 50)
    setProperty('camGame.width', screen)
    setProperty('camHUD.width', screen)
    setProperty('camGame.height', screen)
    setProperty('camHUD.height', screen)
    setProperty('camOther.width', screen)
    setProperty('camOther.height', screen)
    setProperty('camGame.x', middleCam)
    setProperty('camHUD.x', middleCam)
    setProperty('camOther.x', middleCam)
    setProperty('camOther.y', middleCam - 120)
    setProperty('camGame.y', middleCam - 150)
    setProperty('camHUD.y', middleCam - 120)

    for i, a in ipairs(healtH) do
        if not downscroll then
            setProperty(a .. ".y", getProperty(a .. ".y") + 240)
        else
            setProperty("timeBar.y", 920)
            setProperty("timeTxt.y", 911)
        end
    end
    setPropertyFromClass('lime.app.Application', 'current.window.fullscreen', false)
    setPropertyFromClass('lime.app.Application', 'current.window.resizable', false)

    setPropertyFromClass('lime.app.Application', 'current.window.width', 800)
    setPropertyFromClass('lime.app.Application', 'current.window.height', 600)
    setPropertyFromClass('lime.app.Application', 'current.window.x',
        (getPropertyFromClass('flixel.FlxG', 'stage.window.display.bounds.width') - 800) / 2)
    setPropertyFromClass('lime.app.Application', 'current.window.y',
        (getPropertyFromClass('flixel.FlxG', 'stage.window.display.bounds.height') - 600) / 2)
end

function onUpdate(elapsed)
    if getPropertyFromClass('lime.app.Application', 'current.window.fullscreen') == true then
        setPropertyFromClass('lime.app.Application', 'current.window.fullscreen', false)
    end
end

function onDestroy()
    setPropertyFromClass("openfl.Lib", "application.window.title", "Friday Night Funkin' Psych Engine")
    setPropertyFromClass('lime.app.Application', 'current.window.width', screenWidth)
    setPropertyFromClass('lime.app.Application', 'current.window.height', screenHeight)
    setPropertyFromClass('lime.app.Application', 'current.window.resizable', true)
    setPropertyFromClass('lime.app.Application', 'current.window.x',
        (getPropertyFromClass('flixel.FlxG', 'stage.window.display.bounds.width') - screenWidth) / 2)
    setPropertyFromClass('lime.app.Application', 'current.window.y',
        (getPropertyFromClass('flixel.FlxG', 'stage.window.display.bounds.height') - screenHeight) / 2)
end