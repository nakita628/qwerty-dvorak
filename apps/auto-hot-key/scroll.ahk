#Requires AutoHotkey v2.0

; ------------------------------------------------------------------------------
; グローバル変数
; ------------------------------------------------------------------------------
global deferred    := false  ; 「右クリックを送るかどうか」未確定フラグ
global isScrolling := false  ; ドラッグによるスクロール中かどうか
global lastX       := 0
global lastY       := 0
global scrollMult  := 4      ; スクロール速度の係数

; ------------------------------------------------------------------------------
; 右ボタン押下：OSへのRightButton Downをブロック、座標を記録＆タイマー開始
; ------------------------------------------------------------------------------
*RButton:: {
    deferred    := true
    isScrolling := false
    MouseGetPos(&lastX, &lastY)
    SetTimer(CheckDrag, 10)  ; 10ms間隔でCheckDrag()を呼び出しスタート
    return  ; OSには渡さない
}

; ------------------------------------------------------------------------------
; 右ボタン離し：ドラッグしていなければ(= deferred=true)通常の右クリックを送信し、タイマー停止
; ------------------------------------------------------------------------------
*RButton Up:: {
    SetTimer(CheckDrag, 0)   ; タイマー停止
    if deferred {
        SendEvent("{Click Right}")
    }
    deferred    := false
    isScrolling := false
    return  ; OSには渡さない
}

; ------------------------------------------------------------------------------
; タイマー関数：右ボタン押下中のマウス移動を監視し、移動があればドラッグとみなしてスクロールする
; ------------------------------------------------------------------------------
CheckDrag() {
    global deferred, isScrolling, lastX, lastY, scrollMult

    ; 右ボタンが離されていればタイマー停止
    if not GetKeyState("RButton", "P") {
        SetTimer(CheckDrag, 0)
        return
    }

    ; 現在座標を取得して移動量を計算
    currentX := 0
    currentY := 0
    MouseGetPos(&currentX, &currentY)
    dx := currentX - lastX
    dy := currentY - lastY

    ; 少しでも動いた → ドラッグと判定
    if (Abs(dx) > 0 || Abs(dy) > 0) {
        ; まだ「右クリック保留中」ならスクロールモードへ
        if deferred {
            deferred    := false
            isScrolling := true
        }

        ; スクロールモードの場合、移動量に応じてホイールイベントを送る
        if isScrolling {
            lastX := currentX
            lastY := currentY
            SendScroll(dx * scrollMult, dy * scrollMult)
        }
    }
}

; ------------------------------------------------------------------------------
; 横・縦のスクロールを送る関数
; ------------------------------------------------------------------------------
SendScroll(dx, dy) {
    ; dx>0 → WheelRight, dx<0 → WheelLeft
    if (dx > 0) {
        Loop dx
            SendEvent("{WheelRight}")
    } else if (dx < 0) {
        Loop -dx
            SendEvent("{WheelLeft}")
    }

    ; dy>0 → WheelDown, dy<0 → WheelUp
    if (dy > 0) {
        Loop dy
            SendEvent("{WheelDown}")
    } else if (dy < 0) {
        Loop -dy
            SendEvent("{WheelUp}")
    }
}
