local bffightx = 700
local yeafight = false

function onCreatePost()
    addCharacterToList("baldi-fight", "boyfriend")
    addCharacterToList("baldi-fight-sad", "boyfriend")
    addCharacterToList("balsi-fight", "dad")

    addCharacterToList("baldi-run", "boyfriend")
    addCharacterToList("balsi-run", "dad")

    makeAnimatedLuaSprite("balsiheadintro", "characters/balsi-head/balsi-head-intro", -50, 700)
    setObjectCamera("balsiheadintro", "other")
    addAnimationByPrefix("balsiheadintro", "intro", "idle", 24, false)
    scaleObject("balsiheadintro", 1.3, 1.3, true)
    addLuaSprite("balsiheadintro")
end

function onEvent(eventName, value1, value2, strumTime)
    if eventName == '' then
        if value1 == 'introblack' then
            doTweenAlpha("black", "black", 1, 0.4, "linear")
        end
        if value1 == 'heybalsi' then
            doTweenY("balsiheadintro", "balsiheadintro", -150, 0.7, "expoOut")
            playAnim("balsiheadintro", "intro", true)
        end
        if value1 == 'byebalsi' then
            startTween('byebalsisc', 'balsiheadintro.scale', {
                x = 5,
                y = 5
            }, 0.5, {
                ease = 'expoIn'
            })

            startTween('byebalsiang', 'balsiheadintro', {
                angle = -50
            }, 0.5, {
                ease = 'expoIn'
            })
        end
        if value1 == 'fightstart' then
            doTweenAlpha("blacka", "black", 0, 0.01, "linear")
            cameraFlash("other", "white", 0.8, true)
            setProperty("balsiheadintro.visible", false)
            loadGraphic("schoolHouseEntrance", "stages/schoolHouseFight")
        end
        if value1 == 'byehead' then
            doTweenAlpha("balsihead", "balsihead", 0, 0.01, "linear")
        end
        if value1 == 'posfix' then
            setProperty("dad.scale.x", 1)
            setProperty("dad.scale.y", 1)
            setProperty("dad.x", -100)

            setProperty("boyfriend.y", 40)
            setProperty("boyfriend.x", 700)
        end
        if value1 == 'BALSIPIXEL' then
            cameraFlash("other", "white", 0.8, true)
            setSpriteShader("dad", "pixel")
            setShaderFloat("dad", "scale", 800)
        end
        if value1 == 'flash' then
            cameraFlash("other", "white", 0.8, true)
        end
        if value1 == 'removeShit' then
            removeSpriteShader("dad")
        end
        if value1 == 'cameralock' then
            setProperty('isCameraOnForcedPos', true)
            setProperty('camFollow.x', 950);
            setProperty('camFollow.y', 500);

            setProperty('camBetterFollow.x', 950);
            setProperty('camBetterFollow.y', 500);
        end
        if value1 == 'blacking' then
            doTweenAlpha("schoolHouseEntrance", "schoolHouseEntrance", 0, 1, "linear")
            doTweenAlpha("dad", "dad", 0, 1, "linear")
        end
        if value1 == 'heybalsis' then
            doTweenAlpha("balsihead", "balsihead", 1, 1, "linear")
        end
        if value1 == 'HEYSCHOOL' then
            doTweenAlpha("schoolHouseEntrance", "schoolHouseEntrance", 1, 0.01, "linear")
            doTweenAlpha("dad", "dad", 1, 0.01, "linear")
        end
        if value1 == 'posfix2' then

            setProperty("boyfriend.y", 300)
            setProperty("boyfriend.x", 630)
        end
        if value1 == 'posfix3' then
            setProperty("dad.x", -100)
            setProperty("dad.y", -50)

            setProperty("boyfriend.y", 100)
            setProperty("boyfriend.x", 900)
        end
        if value1 == 'runstart' then
            doTweenAlpha("blacka", "black", 0, 0.01, "linear")
            cameraFlash("other", "white", 0.8, true)
        end
        if value1 == 'fuck' then
            doTweenAlpha("ralsiidk", "ralsiidk", 1, 0.01, "linear")
        end
        if value1 == 'byefuck' then
            doTweenAlpha("ralsiidk", "ralsiidk", 0, 0.01, "linear")
        end
        if value1 == 'posfix4' then
            setProperty("dad.x", 200)

            setProperty("boyfriend.y", 40)
            setProperty("boyfriend.x", 700)
        end

        if value1 == 'f' then
            yeafight = true
        end
        if value1 == 'fa' then
            yeafight = false
        end
        if value1 == 'balsifall' then
            doTweenAngle("balsiangle", "dad", -50, 0.68, "expoIn")
            doTweenY("balsiay", "dad", getProperty("dad.y") + 550, 0.68, "expoIn")
        end
    end
end

function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if yeafight then
        if not isSustainNote then
            triggerEvent("Add Camera Zoom", 0.08, 0.08)
            setProperty("boyfriend.x", getProperty("dad.x") + 300)
            setProperty("dad.x", getProperty("dad.x") - 30)
            doTweenX("bffight", "boyfriend", getProperty("dad.x") + 400, 1, "expoOut")
            if noteData == 0 then
                playAnim("dad", "singLEFT-alt", true)
            elseif noteData == 1 then
                playAnim("dad", "singDOWN-alt", true)
            elseif noteData == 2 then
                playAnim("dad", "singUP-alt", true)
            elseif noteData == 3 then
                playAnim("dad", "singRIGHT-alt", true)
            end
        end
    end
end
