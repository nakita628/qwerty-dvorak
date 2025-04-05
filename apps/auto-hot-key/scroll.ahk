#Requires AutoHotkey v2.0
#SingleInstance Force

; ------------------------------------------------------------------------------
; グローバル変数の宣言と初期化
; ------------------------------------------------------------------------------
global deferred    := false  ; 右ボタンを押したがまだドラッグかどうか未確定
global isScrolling := false  ; スクロールモードに入っているかどうか
global lastX       := 0
global lastY       := 0
global scrollMult  := 1      ; スクロール速度（マウス移動量に掛ける係数）

; ------------------------------------------------------------------------------
; 右ボタン押下時: イベントをOSに渡さずブロックし、マウス座標取得＆タイマー開始
; ------------------------------------------------------------------------------
*RButton:: {
    global deferred, isScrolling, lastX, lastY

    deferred    := true
    isScrolling := false

    MouseGetPos(&lastX, &lastY)
    SetTimer(CheckDrag, 10)  ; 10msごとにCheckDrag()を呼び出し
    return  ; OSへのRButton Downイベントはブロック
}

; ------------------------------------------------------------------------------
; 右ボタン離し時: ドラッグしていなければ通常の右クリックを送信、タイマー停止
; ------------------------------------------------------------------------------
*RButton Up:: {
    global deferred, isScrolling

    SetTimer(CheckDrag, 0)  ; タイマー停止
    if deferred {
        SendEvent("{Click Right}")  ; まだドラッグしていなければ右クリック
    }
    deferred    := false
    isScrolling := false
    return      ; OSへのRButton Upイベントはブロック
}

; ------------------------------------------------------------------------------
; タイマー関数: 右ボタン押下中のマウス移動を監視し、スクロールモードへ切り替え
; ------------------------------------------------------------------------------
CheckDrag() {
    global deferred, isScrolling, lastX, lastY, scrollMult

    if not GetKeyState("RButton", "P") {
        SetTimer(CheckDrag, 0)
        return
    }

    currentX := 0
    currentY := 0
    MouseGetPos(&currentX, &currentY)

    dx := currentX - lastX
    dy := currentY - lastY

    if (Abs(dx) > 0 || Abs(dy) > 0) {
        if deferred {
            deferred    := false
            isScrolling := true
        }
        if isScrolling {
            lastX := currentX
            lastY := currentY
            SendScroll(dx * scrollMult, dy * scrollMult)
        }
    }
}

; ------------------------------------------------------------------------------
; スクロール方向を「逆」に設定したバージョン
; dx>0 → WheelLeft, dx<0 → WheelRight
; dy>0 → WheelUp,   dy<0 → WheelDown
; ------------------------------------------------------------------------------
SendScroll(dx, dy) {
    ; 水平スクロール
    if (dx > 0) {
        Loop dx
            SendEvent("{WheelLeft}")
    } else if (dx < 0) {
        Loop -dx
            SendEvent("{WheelRight}")
    }

    ; 垂直スクロール
    if (dy > 0) {
        Loop dy
            SendEvent("{WheelUp}")
    } else if (dy < 0) {
        Loop -dy
            SendEvent("{WheelDown}")
    }
}
