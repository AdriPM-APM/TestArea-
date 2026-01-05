local dadY = getProperty("dad.y")
local total = 1
local beatLol = false

function onBeatHit()
    if beatLol then
        if total == 1 then
            playAnim("dad", "idle1", true)
            total = 2
        elseif total == 2 then
            playAnim("dad", "idle2", true)
            total = 1
        end
        setProperty("dad.y", dadY + 20)
        doTweenY("dady", "dad", dadY, 0.5, "expoOut")
    end
end

function onEvent(eventName, value1, value2, strumTime)
    if eventName == '' then
        if value1 == 'beatStart' then
            beatLol = true
        end
        if value1 == 'beatEnd' then
            beatLol = false
            setProperty("dad.y", dadY)
        end
    end
end

function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if beatLol then
        setProperty("dad.y", dadY + 20)
        doTweenY("dady", "dad", dadY, 0.5, "expoOut")
    end
end
