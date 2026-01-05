local healthObj = {"iconP1", "iconP2", "healthBar", "scoreTxt", "timeTxt", "timeBarBG", "timeBar"}
local pathHealth = "healthBar/"

local ytp = 0
local displayYTP = 0
local earlyytp = 0
local preytpstart = false
local updateytp = false
local needsToRemoveCounter = false;

function onCreatePost()
    precacheImage("ohnoerror")
    precacheSound("ClassicError")

    makeLuaSprite("HealthometerSheet_BG", pathHealth .. "HealthometerSheet_BG", 69.7, 842)
    setObjectCamera("HealthometerSheet_BG", 'camHUD')
    scaleObject("HealthometerSheet_BG", 2.5, 2.5)
    setProperty("HealthometerSheet_BG.antialiasing", false)
    addLuaSprite("HealthometerSheet_BG", true)

    makeLuaSprite("HealthometerSheet_Needle", pathHealth .. "HealthometerSheet_Needle", 70, 842)
    setObjectCamera("HealthometerSheet_Needle", 'camHUD')
    scaleObject("HealthometerSheet_Needle", 2.5, 2.5)
    setProperty("HealthometerSheet_Needle.antialiasing", false)
    addLuaSprite("HealthometerSheet_Needle", true)

    makeLuaSprite("Healthometer", pathHealth .. "Healthometer", 0, 750)
    setObjectCamera("Healthometer", 'camHUD')
    scaleObject("Healthometer", 2.5, 2.5)
    setProperty("Healthometer.antialiasing", false)
    addLuaSprite("Healthometer", true)

    makeLuaSprite("YTPCounter", pathHealth .. "YTPCounter", 0, 800)
    setProperty("YTPCounter.antialiasing", false)
    setObjectCamera("YTPCounter", 'camHUD')

    makeLuaText("YTP", displayYTP, 1000, -250, 825)
    setObjectCamera("YTP", 'camHUD')
    setTextSize("YTP", 55)
    setTextColor("YTP", "red")
    setTextBorder("YTP", 0, "")
    setTextAlignment("YTP", 'right')
    setProperty("YTP.antialiasing", false)
    setTextFont("YTP", "comic-pro-atlas.ttf")

    makeLuaText("PREYTP", "+" .. earlyytp, 1000, 0, 600)
    setObjectCamera("PREYTP", 'camHUD')
    setTextSize("PREYTP", 65)
    setTextBorder("PREYTP", 0, "")
    screenCenter("PREYTP", 'x')
    setProperty("PREYTP.alpha", 0)
    setTextAlignment("PREYTP", 'center')
    setProperty("PREYTP.antialiasing", false)
    setTextFont("PREYTP", "comic-pro-atlas.ttf")

    if not downscroll then
        setProperty("HealthometerSheet_BG.y", 842)
        setProperty("HealthometerSheet_Needle.y", 842)
        setProperty("Healthometer.y", 750)

        setProperty("YTPCounter.y", 1000)
        setProperty("YTP.y", 1030)
        loadGraphic("YTPCounter", pathHealth .. "YTPCounterDOWN")
        scaleObject("YTPCounter", 2.5, 2.5)
        screenCenter("YTPCounter", 'x')
        addLuaSprite("YTPCounter", true)
    else
        setProperty("HealthometerSheet_BG.y", 63)
        setProperty("HealthometerSheet_Needle.y", 65)
        setProperty("Healthometer.y", -30)

        setProperty("YTPCounter.y", -200)
        setProperty("YTP.y", -122)
        loadGraphic("YTPCounter", pathHealth .. "YTPCounterUP")
        scaleObject("YTPCounter", 2.5, 2.5)
        screenCenter("YTPCounter", 'x')
        addLuaSprite("YTPCounter", true)
    end

    addLuaText("YTP")
    addLuaText("PREYTP")

    for i, a in ipairs(healthObj) do
        setProperty(a .. ".visible", false)
    end
end

function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if not preytpstart then
        cancelTween("AYTPCounter")
        cancelTween("AYTP")
        if not downscroll then
            doTweenY("YTPCounter", "YTPCounter", 800, 1, "linear")
            doTweenY("YTP", "YTP", 830, 1, "linear")
        else
            doTweenY("YTPCounter", "YTPCounter", 0, 1, "linear")
            doTweenY("YTP", "YTP", 78, 1, "linear")
        end
    end
    preytpstart = true
    local rawNoteRating = getPropertyFromGroup('notes', membersIndex, 'rating')
    if preytpstart then
        cancelTween("PREYTP")
        if not downscroll then
            setProperty("PREYTP.y", 730)
        else
            setProperty("PREYTP.y", 160)
        end
        if rawNoteRating == 'sick' then
            earlyytp = earlyytp + 350
        elseif rawNoteRating == 'good' then
            earlyytp = earlyytp + 200
        elseif rawNoteRating == 'bad' then
            earlyytp = earlyytp + 100
        elseif rawNoteRating == 'shit' then
            earlyytp = earlyytp + 50
        end

        setTextString("PREYTP", "+" .. earlyytp)
        setProperty("PREYTP.color", getColorFromHex("00FF00"))

        setProperty("PREYTP.alpha", 1)

        runTimer("earlyytpdown", 0.8)
    end
end

function noteMiss(membersIndex, noteData, noteType, isSustainNote)
    if not preytpstart then
        cancelTween("AYTPCounter")
        cancelTween("AYTP")
        if not downscroll then
            doTweenY("YTPCounter", "YTPCounter", 800, 1, "linear")
            doTweenY("YTP", "YTP", 830, 1, "linear")
        else
            doTweenY("YTPCounter", "YTPCounter", 0, 1, "linear")
            doTweenY("YTP", "YTP", 78, 1, "linear")
        end
    end
    preytpstart = true
    if preytpstart then
        cancelTween("PREYTP")
        if not downscroll then
            setProperty("PREYTP.y", 730)
        else
            setProperty("PREYTP.y", 160)
        end
        earlyytp = earlyytp - 10
        if score > 0 then
            setTextString("PREYTP", "-" .. earlyytp)
        else
            setTextString("PREYTP", "" .. earlyytp)
        end
        setProperty("PREYTP.color", getColorFromHex("FF0000"))
        setProperty("PREYTP.alpha", 1)

        runTimer("earlyytpdown", 0.8)
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'earlyytpdown' then
        if not downscroll then
            doTweenY("PREYTP", "PREYTP", 825, 0.42, "cubeIn")
        else
            doTweenY("PREYTP", "PREYTP", 78, 0.42, "cubeIn")
        end
    end
    if tag == 'byecounter' then
        if not downscroll then
            doTweenY("AYTPCounter", "YTPCounter", 1000, 0.5, "linear")
            doTweenY("AYTP", "YTP", 1030, 0.5, "linear")
        else
            doTweenY("AYTPCounter", "YTPCounter", -200, 0.5, "linear")
            doTweenY("AYTP", "YTP", -122, 0.5, "linear")
        end
    end
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

function onTweenCompleted(tag, vars)
    if tag == 'PREYTP' then
        preytpstart = false
        updateytp = true

        ytp = ytp + earlyytp
        earlyytp = 0

        setTextString("PREYTP", "")
        setProperty("PREYTP.alpha", 0)
        needsToRemoveCounter = true;
    end
end

function onUpdate()
    displayYTP = lerp(displayYTP, ytp, 0.15)
    if math.abs(displayYTP - ytp) < 1 then
        displayYTP = ytp

        if needsToRemoveCounter then
            runTimer("byecounter", 0.5)
            needsToRemoveCounter = false;
        end
    end
    setTextString("YTP", round(displayYTP))

    local health = getProperty('health')
    local minX = 70
    local maxX = 400
    local needleX = minX + ((health / 2) * (maxX - minX))
    setProperty('HealthometerSheet_Needle.x', needleX)
end

function lerp(a, b, ratio)
    return a + ratio * (b - a)
end

function round(n)
    return math.floor(n + 0.5)
end

function onGameOver()
    openCustomSubstate("ohno", true)
    return Function_Stop
end