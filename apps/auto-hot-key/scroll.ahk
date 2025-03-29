#NoEnv
SendMode Input
SetBatchLines -1
CoordMode, Mouse, Screen

dragThreshold := 5
scrollMult := 4
pollInterval := 10

isDragging := false
clickCandidate := true
startX := 0
startY := 0

~RButton::
    MouseGetPos, startX, startY
    isDragging := false
    clickCandidate := true
    SetTimer, RightDragScroll, %pollInterval%
return

~RButton Up::
    SetTimer, RightDragScroll, Off
    if (!isDragging && clickCandidate)
        Click, right
return

RightDragScroll:
    MouseGetPos, curX, curY
    dx := curX - startX
    dy := curY - startY
    if (!isDragging && (Abs(dx) >= dragThreshold || Abs(dy) >= dragThreshold))
    {
        isDragging := true
        clickCandidate := false
    }
    if (isDragging)
    {
        if (dy != 0)
        {
            scrollSteps := Round(dy * scrollMult / 10)
            if (scrollSteps > 0)
                Loop, %scrollSteps%
                    Send {WheelDown}
            else if (scrollSteps < 0)
                Loop, % Abs(scrollSteps)%
                    Send {WheelUp}
        }
    }
    startX := curX
    startY := curY
return
