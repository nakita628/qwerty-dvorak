#Requires AutoHotkey v2.0
#SingleInstance Force

; ------------------------------------------------------------------------------
; グローバル変数
; ------------------------------------------------------------------------------
global deferred    := false  ; 右ボタンを押しているがまだドラッグかどうか未確定
global isScrolling := false  ; ドラッグを検知してスクロールモードに入ったか
global anchorX     := 0      ; 右ボタン押下時の座標 (ポインタ固定位置)
global anchorY     := 0
global scrollMult  := 1      ; スクロール速度(移動量に掛ける係数)

; ------------------------------------------------------------------------------
; 右ボタン押下：OSへのRightButton Downをブロック。アンカー座標を取得し、タイマー開始
; ------------------------------------------------------------------------------
*RButton:: {
    global deferred, isScrolling, anchorX, anchorY

    deferred    := true
    isScrolling := false

    MouseGetPos(&anchorX, &anchorY)
    SetTimer(CheckDrag, 10)   ; 10msごとにCheckDrag()を呼び出し
    return                    ; OSにRButton Downは渡さない
}

; ------------------------------------------------------------------------------
; 右ボタン離し：ドラッグしていなければ(= deferred=true)通常の右クリック、タイマー停止
; ------------------------------------------------------------------------------
*RButton Up:: {
    global deferred, isScrolling

    SetTimer(CheckDrag, 0)    ; タイマー停止
    if deferred {
        SendEvent("{Click Right}")
    }
    deferred    := false
    isScrolling := false
    return                    ; OSにRButton Upは渡さない
}

; ------------------------------------------------------------------------------
; タイマー関数：右ボタンを押している間、マウス移動をスクロールに変換してポインタを固定
; ------------------------------------------------------------------------------
CheckDrag() {
    global deferred, isScrolling, anchorX, anchorY, scrollMult

    ; 右ボタンが離されていればタイマー停止
    if not GetKeyState("RButton", "P") {
        SetTimer(CheckDrag, 0)
        return
    }

    curX := 0
    curY := 0
    MouseGetPos(&curX, &curY)

    dx := curX - anchorX
    dy := curY - anchorY

    ; 少しでも移動があればスクロールモードへ
    if (Abs(dx) > 0 || Abs(dy) > 0) {
        if deferred {
            deferred    := false
            isScrolling := true
        }

        if isScrolling {
            ; 移動量分だけスクロールを送る(逆方向設定)
            SendScroll(dx * scrollMult, dy * scrollMult)
            ; ポインタをアンカー座標へ戻して固定
            MouseMove(anchorX, anchorY)
        }
    }
}

; ------------------------------------------------------------------------------
; スクロール送信（方向を逆に）
;   dx>0 → WheelLeft,  dx<0 → WheelRight
;   dy>0 → WheelUp,    dy<0 → WheelDown
; ------------------------------------------------------------------------------
SendScroll(dx, dy) {
    ; 水平方向の逆スクロール
    if (dx > 0) {
        Loop dx
            SendEvent("{WheelLeft}")
    } else if (dx < 0) {
        Loop -dx
            SendEvent("{WheelRight}")
    }

    ; 垂直方向の逆スクロール
    if (dy > 0) {
        Loop dy
            SendEvent("{WheelUp}")
    } else if (dy < 0) {
        Loop -dy
            SendEvent("{WheelDown}")
    }
}
