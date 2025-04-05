#Requires AutoHotkey v2.0
#SingleInstance Force

; ------------------------------------------------------------------------------
; グローバル変数の宣言と初期化
; ------------------------------------------------------------------------------
global deferred    := false  ; 右ボタンを押したがまだドラッグかどうか未確定
global isScrolling := false  ; スクロールモードに入っているかどうか
global lastX       := 0
global lastY       := 0
global scrollMult  := 4      ; スクロール速度（マウス移動量に掛ける係数）

; ------------------------------------------------------------------------------
; 右ボタン押下時: イベントをOSに渡さずブロックし、マウス座標取得＆タイマー開始
; ------------------------------------------------------------------------------
*RButton:: {
    ; このブロックで使用するグローバル変数を明示的に指定
    global deferred, isScrolling, lastX, lastY

    deferred    := true
    isScrolling := false

    MouseGetPos(&lastX, &lastY)
    ; 10msごとにCheckDrag()を呼び出し
    SetTimer(CheckDrag, 10)
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
    ; 状態リセット
    deferred    := false
    isScrolling := false
    return  ; OSへのRButton Upイベントはブロック
}

; ------------------------------------------------------------------------------
; タイマー関数: 右ボタン押下中のマウス移動を監視し、スクロールモードへ切り替え
; ------------------------------------------------------------------------------
CheckDrag() {
    global deferred, isScrolling, lastX, lastY, scrollMult

    ; 右ボタンが離されていればタイマー停止
    if not GetKeyState("RButton", "P") {
        SetTimer(CheckDrag, 0)
        return
    }

    ; 前回座標からの移動量を取得
    currentX := 0
    currentY := 0
    MouseGetPos(&currentX, &currentY)

    dx := currentX - lastX
    dy := currentY - lastY

    if (Abs(dx) > 0 || Abs(dy) > 0) {
        ; まだ右クリックを送る可能性がある状態なら、スクロールモードに移行
        if deferred {
            deferred    := false
            isScrolling := true
        }

        ; スクロールモード中なら、移動量に応じてホイールイベントを送る
        if isScrolling {
            lastX := currentX
            lastY := currentY
            SendScroll(dx * scrollMult, dy * scrollMult)
        }
    }
}

; ------------------------------------------------------------------------------
; 移動量をホイール操作に変換して送る関数
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
