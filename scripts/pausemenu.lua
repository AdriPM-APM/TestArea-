local paused = false
local buttons = {"Resume", "Options", "Quit"}
local timeElapsed = 0;
local buttonHitboxes = {}
local allPauseObjects = {"pauseBlack", "pauseFront", "CursorSprite", "Paused"}
local canPause = true

local debug = true

function onCreatePost()
    makeLuaSprite("pauseBlack", "", 0, 0)
    makeGraphic("pauseBlack", screenWidth + 500, screenHeight + 500, '000000')
    screenCenter("pauseBlack")
    setObjectCamera("pauseBlack", 'other')
    setProperty("pauseBlack.alpha", 0)
    addLuaSprite("pauseBlack", true)

    createInstance('PauseBaldi', 'flixel.addons.display.FlxBackdrop', {nil, 0x11})
    setObjectCamera("PauseBaldi", 'other')
    setProperty("PauseBaldi.alpha", 0)
    loadGraphic('PauseBaldi', 'pause/baldiheadno')
    scaleObject("PauseBaldi", 2.5, 2.5, true)
    setProperty("PauseBaldi.color", getColorFromHex("00FF00"))
    setProperty("PauseBaldi.antialiasing", false)
    addInstance('PauseBaldi', true)

    makeLuaSprite("pauseFront", "pause/pausefront", 0, 0)
    setObjectCamera("pauseFront", 'other')
    scaleObject("pauseFront", 2.67, 2.67, true)
    setProperty("pauseFront.alpha", 0)
    setProperty("pauseFront.antialiasing", false)
    addLuaSprite('pauseFront', true)

    makeLuaSprite("CursorSprite", "pause/CursorSprite", 0, 0)
    setObjectCamera("CursorSprite", 'other')
    setProperty("CursorSprite.alpha", 0)
    setObjectOrder("CursorSprite", 1000)
    setProperty("CursorSprite.color", getColorFromHex("00FF00"))
    addLuaSprite("CursorSprite", true)
end

function onPause()
    if canPause then
        openCustomSubstate("pauseMenu", true)
        doyouwannaseemecum(true)
        return Function_Stop;
    end
end

function onGameOver()
    canPause = false
    openCustomSubstate("ohno", true)
    return Function_Stop
end

function onCustomSubstateCreatePost(name)
    if name == 'ohno' then
        setProperty("camGame.visible", false)
        setProperty("camHUD.visible", false)
        runTimer("hey", 2)
        setPropertyFromClass("openfl.Lib", "application.window.title", "")
    end
    if name == 'pauseMenu' then
        paused = true

        makeLuaText("Paused", "Paused?!", 300, screenWidth / 2 - 150, 200)
        setTextFont("Paused", "comic-pro-atlas.ttf")
        setObjectCamera("Paused", 'other')
        setProperty("Paused" .. ".color", getColorFromHex("00FF00"))
        setTextBorder("Paused", 0, "")
        setTextSize("Paused", 70)
        addLuaText("Paused")

        for i, v in ipairs(buttons) do
            if not luaTextExists(v) then
                local x = screenWidth / 2 - 150
                local y = 310 + (i * 160)

                makeLuaText(v, v, 300, screenWidth / 2 - 150, 310 + (i * 160))
                setTextFont(v, "comic-pro-atlas.ttf")
                setObjectCamera(v, 'other')
                setProperty(v .. ".color", getColorFromHex("00FF00"))
                setTextBorder(v, 0, "")
                setTextSize(v, 70)
                addLuaText(v)

                local textwidth = getProperty(v .. ".width")
                local textheight = getProperty(v .. ".height")
                buttonHitboxes[v] = {
                    x = x,
                    y = y,
                    width = textwidth,
                    height = textheight
                }

                makeLuaSprite(v .. "Line", "", getProperty(v .. ".x") + 50, getProperty(v .. ".y") + 70)
                makeGraphic(v .. "Line", 200, 2, '00FF00')
                setObjectCamera(v .. "Line", 'other')
                setProperty(v .. "Line.alpha", 0)
                addLuaSprite(v .. "Line", true)
            end
        end
    end
end

function onCustomSubstateUpdatePost(name, elapsed)
    local mouseX = getMouseX("other")
    local mouseY = getMouseY("other")

    setProperty("CursorSprite.x", mouseX)
    setProperty("CursorSprite.y", mouseY)

    setObjectOrder("CursorSprite", 1000)

    setObjectOrder("Paused", 900)

    if name == 'pauseMenu' then
        local oldFramesElapsed = math.floor(timeElapsed / (1 / 60));
        timeElapsed = timeElapsed + elapsed;
        local framesElapsed = math.floor(timeElapsed / (1 / 60));

        if oldFramesElapsed ~= framesElapsed then
            setProperty('PauseBaldi.x', getProperty("PauseBaldi.x") + 3)
            setProperty('PauseBaldi.y', getProperty("PauseBaldi.y") + 3)
        end

        for i, v in ipairs(buttons) do
            setObjectOrder(v, 900)
            local HitBoxCheck = buttonHitboxes[v]
            local hovering = false

            if HitBoxCheck and mouseX >= HitBoxCheck.x and mouseX <= HitBoxCheck.x + HitBoxCheck.width and mouseY >=
                HitBoxCheck.y and mouseY <= HitBoxCheck.y + HitBoxCheck.height then
                setProperty(v .. "Line.alpha", 1)
                hovering = true
            else
                setProperty(v .. "Line.alpha", 0)
                hovering = false
            end

            if hovering and mousePressed('left') then
                if v == "Resume" then
                    paused = false
                    doyouwannaseemecum(false)
                    closeCustomSubstate()
                elseif v == "Options" then
                    runHaxeCode([[
                            import options.OptionsState;
                    import backend.MusicBeatState;
                    game.paused = true;
                    game.vocals.volume = 0;
                    MusicBeatState.switchState(new OptionsState());
                    OptionsState.onPlayState = true;
                    ]])
                elseif v == "Quit" then
                    exitSong()
                end
            end
        end
    end
end

function doyouwannaseemecum(visible)
    local alpha = visible and 1 or 0
    for _, obj in ipairs(allPauseObjects) do
        if luaSpriteExists(obj) or luaTextExists(obj) then
            setProperty(obj .. ".alpha", alpha)
        end
    end

    setProperty("PauseBaldi.alpha", visible and 0.4 or 0)
    setProperty("PauseBaldi.visible", visible)

    for _, v in ipairs(buttons) do
        if luaTextExists(v) then
            setProperty(v .. ".alpha", alpha)
        end
        if luaSpriteExists(v .. "Line") then
            setProperty(v .. "Line.alpha", visible and 0 or 0)
        end
    end
end


function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'hey' then
        makeLuaSprite("ohno", "ohnoerror", 0, 0)
        setObjectCamera("ohno", 'other')
        scaleObject("ohno", 2.7, 2.7)
        playSound("ClassicError", '1', 'error')
        addLuaSprite("ohno", true)
    end
end

function onSoundFinished(tag)
    if tag == 'error' then
        os.exit()
    end
end