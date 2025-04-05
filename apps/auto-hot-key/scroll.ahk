#Requires AutoHotkey v2.0

; ------------------------------------------------------------------------------
; グローバル変数
; ------------------------------------------------------------------------------
global deferred    := false  ; 「右クリックを送るかどうか」まだ確定していないフラグ
global isScrolling := false  ; ドラッグによるスクロール中かどうか
global lastX       := 0
global lastY       := 0
global scrollMult  := 4      ; スクロール速度を調整する係数
global checkDragTimer := 0

; ------------------------------------------------------------------------------
; 右ボタンを押したとき：通常のRButton Downをブロックし、座標を記録＆タイマー開始
; ------------------------------------------------------------------------------
*RButton:: {
    deferred := true
    isScrolling := false
    MouseGetPos(&lastX, &lastY)
    SetTimer(CheckDrag, 10, true)  ; 10msごとにCheckDrag()を呼び出す
    return  ; OSには右クリックDownを渡さない
}

; ------------------------------------------------------------------------------
; 右ボタンを離したとき：ドラッグ発生していなければ右クリック送信、タイマー停止
; ------------------------------------------------------------------------------
*RButton Up:: {
    SetTimer(CheckDrag, "Off")
    if deferred {
        ; ドラッグなし(=スクロールせず) → 通常の右クリックを送る
        SendEvent("{Click Right}")
    }
    ; 状態をリセット
    deferred    := false
    isScrolling := false
    return  ; OSにRButton Upは渡さない
}

; ------------------------------------------------------------------------------
; タイマー関数：右ボタン押下中のマウス移動を監視し、
;                移動があればドラッグ(スクロール)と判定してホイールを送る
; ------------------------------------------------------------------------------
CheckDrag() {
    global deferred, isScrolling, lastX, lastY, scrollMult

    ; もし右ボタンが既に離されていればタイマー停止
    if not GetKeyState("RButton", "P") {
        SetTimer(CheckDrag, "Off")
        return
    }

    ; 現在座標を取得し、前回座標との差分を計算
    currentX := 0
    currentY := 0
    MouseGetPos(&currentX, &currentY)
    dx := currentX - lastX
    dy := currentY - lastY

    ; 少しでも動いたら → ドラッグと判定
    if (Abs(dx) > 0 || Abs(dy) > 0) {
        ; まだ右クリックを保留中だったら、スクロールモードへ移行
        if deferred {
            deferred    := false
            isScrolling := true
        }

        ; スクロール中なら、移動量分だけホイールイベントを送る
        if isScrolling {
            ; 新しい座標を次回比較用に更新
            lastX := currentX
            lastY := currentY
            SendScroll(dx * scrollMult, dy * scrollMult)
        }
    }
}

; ------------------------------------------------------------------------------
; 移動量を水平・垂直スクロールに変換して送信する関数
; ------------------------------------------------------------------------------
SendScroll(dx, dy) {
    ; 横スクロール: dx>0 → {WheelRight}, dx<0 → {WheelLeft}
    if (dx > 0) {
        Loop dx
            SendEvent("{WheelRight}")
    } else if (dx < 0) {
        Loop -dx
            SendEvent("{WheelLeft}")
    }

    ; 縦スクロール: dy>0 → {WheelDown}, dy<0 → {WheelUp}
    if (dy > 0) {
        Loop dy
            SendEvent("{WheelDown}")
    } else if (dy < 0) {
        Loop -dy
            SendEvent("{WheelUp}")
    }
}
