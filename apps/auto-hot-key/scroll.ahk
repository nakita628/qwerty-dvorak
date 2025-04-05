#Requires AutoHotkey v2.0
#InstallMouseHook

; ------------------------------------------------------------------------------
; グローバル変数定義
; ------------------------------------------------------------------------------
global deferred := false   ; 「右クリックを送るかどうか保留中か」を示すフラグ
global isScrolling := false
global lastX := 0, lastY := 0

; ------------------------------------------------------------------------------
; 右ボタン押下：システム側へのイベント送信をブロックし、監視用フラグを初期化
; ------------------------------------------------------------------------------
*RButton::
{
    deferred := true
    isScrolling := false
    MouseGetPos(&lastX, &lastY)
    return  ; システムへは渡さない
}

; ------------------------------------------------------------------------------
; 右ボタン離し：もしドラッグが発生していなければ(= deferred = true)通常の右クリックを送信
; ------------------------------------------------------------------------------
*RButton Up::
{
    if deferred {
        ; 右ドラッグしていない → 通常の右クリック
        SendEvent("{Click Right}")
    }
    return  ; システムへは渡さない
}

; ------------------------------------------------------------------------------
; 右ボタンを押しながらのマウス移動をフック
; 初回移動でスクロールモードへ移行し、以後は移動量をホイールイベントに変換
; ------------------------------------------------------------------------------
#HotIf GetKeyState("RButton", "P")  ; RButton を物理的に押している時だけ有効
    *~$MouseMove::
    {
        if deferred {
            ; まだ右クリック送信を保留していた場合 → スクロールモードへ移行
            deferred := false
            isScrolling := true
        }

        if isScrolling
        {
            ; マウス座標を取得して移動量を計算
            currentX := 0
            currentY := 0
            MouseGetPos(&currentX, &currentY)

            dx := currentX - lastX
            dy := currentY - lastY
            lastX := currentX
            lastY := currentY

            if (dx != 0 || dy != 0)
            {
                ; 移動量を増幅してスクロールイベントを送る
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
    ; X軸（水平）: dx > 0 → WheelRight, dx < 0 → WheelLeft
    if (dx > 0)
    {
        Loop dx
            SendEvent("{WheelRight}")
    }
    else if (dx < 0)
    {
        Loop -dx
            SendEvent("{WheelLeft}")
    }

    ; Y軸（垂直）: dy > 0 → WheelDown, dy < 0 → WheelUp
    if (dy > 0)
    {
        Loop dy
            SendEvent("{WheelDown}")
    }
    else if (dy < 0)
    {
        Loop -dy
            SendEvent("{WheelUp}")
    }
}
