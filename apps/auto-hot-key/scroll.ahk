#Requires AutoHotkey v2.0
#InstallMouseHook

; ------------------------------------------------------------------------------
; グローバル変数
; ------------------------------------------------------------------------------
global deferred := false     ; 右クリックを保留しているかどうか
global isScrolling := false  ; 右ドラッグによるスクロール中かどうか
global lastX := 0, lastY := 0

; ------------------------------------------------------------------------------
; 右ボタン押下時：OSへのRightButton Downイベントをブロックし、保留フラグをセット
; ------------------------------------------------------------------------------
*RButton::
{
    deferred := true
    isScrolling := false
    MouseGetPos(&lastX, &lastY)
    return  ; システム（OS）へは渡さない
}

; ------------------------------------------------------------------------------
; 右ボタン離し時：もしドラッグしていなければ(= deferred = true)通常の右クリックを送る
; ------------------------------------------------------------------------------
*RButton Up::
{
    if deferred {
        SendEvent("{Click Right}")
    }
    return  ; システムへは渡さない
}

; ------------------------------------------------------------------------------
; 右ボタンを押しっぱなし中のマウス移動をフック
; 最初の移動で "スクロールモード" に切り替え、移動量をホイールイベントに変換
; ------------------------------------------------------------------------------
#HotIf GetKeyState("RButton", "P")  ; 物理的にRButtonを押している間のみ有効
    *~$MouseMove::
    {
        if deferred {
            ; ドラッグが始まったので、通常右クリックはやめてスクロールモードへ移行
            deferred := false
            isScrolling := true
        }

        if isScrolling {
            ; 現在のマウス座標を取得
            currentX := 0
            currentY := 0
            MouseGetPos(&currentX, &currentY)

            ; 移動量を計算
            dx := currentX - lastX
            dy := currentY - lastY
            lastX := currentX
            lastY := currentY

            ; 移動があった分だけスクロールさせる
            if (dx != 0 || dy != 0) {
                scrollMult := 4
                SendScroll(dx * scrollMult, dy * scrollMult)
            }
        }
        return
    }
#HotIf

; ------------------------------------------------------------------------------
; 水平・垂直スクロールを送る汎用関数
; ------------------------------------------------------------------------------
SendScroll(dx, dy)
{
    ; dx > 0 → WheelRight, dx < 0 → WheelLeft
    if (dx > 0) {
        Loop dx
            SendEvent("{WheelRight}")
    }
    else if (dx < 0) {
        Loop -dx
            SendEvent("{WheelLeft}")
    }

    ; dy > 0 → WheelDown, dy < 0 → WheelUp
    if (dy > 0) {
        Loop dy
            SendEvent("{WheelDown}")
    }
    else if (dy < 0) {
        Loop -dy
            SendEvent("{WheelUp}")
    }
}
