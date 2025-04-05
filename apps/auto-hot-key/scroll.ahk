#Requires AutoHotkey v2.0
#SingleInstance Force

; ------------------------------------------------------------------------------
; グローバル変数
; ------------------------------------------------------------------------------
global deferred    := false  ; 右クリック(Down)を保留中かどうか
global isScrolling := false  ; スクロールモードに入っているかどうか
global lastX       := 0
global lastY       := 0
global scrollMult  := 4      ; スクロール速度の係数

; ------------------------------------------------------------------------------
; 右ボタン押下: OSへのRightButton Downをブロックし、座標取得＆タイマー開始
; ------------------------------------------------------------------------------
*RButton:: {
    deferred    := true
    isScrolling := false
    MouseGetPos(&lastX, &lastY)
    ; 10msごとにCheckDrag()を呼び出し
    SetTimer(CheckDrag, 10)
    return  ; OSにRButton Downは渡さない
}

; ------------------------------------------------------------------------------
; 右ボタン離し: ドラッグがなければ(= deferred=true) 右クリックを送信、タイマー停止
; ------------------------------------------------------------------------------
*RButton Up:: {
    SetTimer(CheckDrag, 0)  ; タイマー停止
    if deferred {
        SendEvent("{Click Right}")
    }
    deferred    := false
    isScrolling := false
    return  ; OSにRButton Upは渡さない
}

; ------------------------------------------------------------------------------
; タイマー関数: 右ボタンを押している間、マウス移動を監視してドラッグ→スクロールを実現
; ------------------------------------------------------------------------------
CheckDrag() {
    global deferred, isScrolling, lastX, lastY, scrollMult

    ; 右ボタンが離されていればタイマー停止
    if not GetKeyState("RButton", "P") {
        SetTimer(CheckDrag, 0)
        return
    }

    ; 現在のマウス座標を取得
    currentX := 0
    currentY := 0
    MouseGetPos(&currentX, &currentY)

    dx := currentX - lastX
    dy := currentY - lastY

    ; わずかでも動きがあればドラッグと判定
    if (Abs(dx) > 0 || Abs(dy) > 0) {
        ; まだ右クリック送信を保留していたらスクロールモードへ移行
        if deferred {
            deferred    := false
            isScrolling := true
        }

        ; スクロールモード中なら移動量に応じてホイールイベントを送る
        if isScrolling {
            lastX := currentX
            lastY := currentY
            SendScroll(dx * scrollMult, dy * scrollMult)
        }
    }
}

; ------------------------------------------------------------------------------
; 水平・垂直スクロールを送る関数
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
