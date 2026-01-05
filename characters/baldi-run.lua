local total = 1
local beatLol = false
local curY = getProperty("boyfriend.y")

function onBeatHit()
    if beatLol then
        if total == 1 then
            playAnim("boyfriend", "idle1", true)
            total = 2
        else
            playAnim("boyfriend", "idle2", true)
            total = 1
        end
        setProperty("boyfriend.y", curY + 20)
        doTweenY("boyfriendy", "boyfriend", curY, 0.5, "expoOut")
    end
end

function onEvent(eventName, value1, value2, strumTime)
    if eventName == '' then
        if value1 == 'beatStart' then
            beatLol = true
        end
        if value1 == 'posfix3' then
            curY = 150
        end
        if value1 == 'beatEnd' then
            beatLol = false
            setProperty("boyfriend.y", curY)
        end
    end

end

function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if beatLol then
        setProperty("boyfriend.y", curY + 20)
        doTweenY("boyfriendy", "boyfriend", curY, 0.5, "expoOut")
    end
end
