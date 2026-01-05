local aaa = false
local aa = false
local head = false
local balsiprefix = "idle"
local balsiindex = 0
local idk = false
local precacheimages = {
    "characters/balsi-head/idle-0",
    "characters/balsi-head/left-0",
    "characters/balsi-head/left-1",
    "characters/balsi-head/left-2",

    "characters/balsi-head/down-0",
    "characters/balsi-head/down-1",
    "characters/balsi-head/down-2",

    "characters/balsi-head/up-0",
    "characters/balsi-head/up-1",
    "characters/balsi-head/up-2",

    "characters/balsi-head/right-0",
    "characters/balsi-head/right-1",
    "characters/balsi-head/right-2"
}



function onCreatePost()
    for i, pre in ipairs(precacheimages) do
        precacheImage(pre)
    end
    createInstance('balsihead', 'flixel.addons.display.FlxBackdrop', {nil, 0x11})
    setObjectCamera("balsihead", 'game')
    setProperty("balsihead.alpha", 0)
    loadGraphic('balsihead', 'characters/balsi-head/idle-0')
    scaleObject("balsihead", 1, 1)
    setObjectOrder("balsihead", 1)
    addInstance('balsihead')

    makeLuaSprite("ralsiidk", 'characters/balsi-head/idle-spooky',0,0)
    setObjectCamera("ralsiidk", 'hud')
    setProperty("ralsiidk.alpha", 0)
    addLuaSprite("ralsiidk")
end

local timeElapsed = 0;
function onUpdate(elapsed)
    local oldFramesElapsed = math.floor(timeElapsed / (1/60));
    timeElapsed = timeElapsed + elapsed;
    local framesElapsed = math.floor(timeElapsed / (1/60));

    if oldFramesElapsed ~= framesElapsed then
        setProperty('balsihead.x', getProperty("balsihead.x") + 8)
        setProperty('balsihead.y', getProperty("balsihead.y") + 2)
    end
end


function noteMiss(membersIndex, noteData, noteType, isSustainNote)
    if not isSustainNote then
        setProperty("boyfriend.alpha", 0.7)
        doTweenAlpha("boyfriend", "boyfriend", 1, 0.3, "linear")
    end    
end

function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if noteData == 0 then
        balsiprefix = "left"
    elseif noteData == 1 then
        balsiprefix = "down"
    elseif noteData == 2 then
        balsiprefix = "up"
    elseif noteData == 3 then
        balsiprefix = "right"
    end

    balsiindex = 2
    loadGraphic("balsihead", "characters/balsi-head/" .. balsiprefix .. "-" .. balsiindex)
    runTimer("balsiSing", 1/12, 3)
end
function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "balsiSing" then
        if balsiindex >= 0 then
            loadGraphic("balsihead", "characters/balsi-head/" .. balsiprefix .. "-" .. balsiindex)
            balsiindex = balsiindex - 1
        end

        if loopsLeft == 0 then
            runTimer("heyidle", (getPropertyFromClass('backend.Conductor', 'stepCrochet')/1000)*4, 1)
        end
    elseif tag == "heyidle" then
        loadGraphic("balsihead", "characters/balsi-head/idle-0")
    end
end

function onEvent(eventName, value1, value2, strumTime)
    if eventName == 'Play Animation' then
        if value1 == 'shader' then
            if value2 == 'on' then
                aaa = true
            elseif value2 == 'nah' then
                aaa = false
            end
        end
        if value1 == 'end' then
            --setProperty("endfade.alpha", tonumber(value2))
            aa = true
        end
    end
    if eventName == '' then
        if value1 == '1' then
            doTweenZoom("camGame", "camGame", 4, 1.2, "expoIn")
            startTween('cameralol', 'camFollow', {
                x = 750,
                y = 450
            }, 1.3, {
                ease = 'expoOut'
            })
            setProperty("isCameraOnForcedPos", true)
        end
        if value1 == '2' then
            setProperty("isCameraOnForcedPos", false)
            cameraFlash("game", "black", 1, true)
        end
        if value1 == '3' then
            aa = true
            cameraFlash("game", "black", 1, true)
        end
        if value1 == '4' then
            aa = false
            head = true
            cameraFlash("game", "white", 1, true)
            setProperty("balsihead.alpha", 1)
            setProperty("dad.alpha", 0)
            setProperty("schoolHouseEntrance.alpha", 0)
        end
        if value1 == '6' then
            aa = true
        end
        if value1 == '7' then
            aa = false
            head = false
            cameraFlash("game", "white", 1.5, true)
            setProperty("balsihead.alpha", 0)
            setProperty("dad.alpha", 1)
            setProperty("schoolHouseEntrance.alpha", 1)
        end
        if value1 == '5' then
            cameraFlash("game", "white", 0.5, true)
        end
        if value1 == 'aaa' then
            idk = true
        end
        if value1 == 'end' then
            setProperty("ralsiidk.alpha", 1)
            cameraShake("other", 0.002, 100)
            setPropertyFromClass("openfl.Lib", "application.window.title", "I SEE YOU")
        end 
    end
end
