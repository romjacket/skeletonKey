Class LV_InCellEdit {
   __New(HWND, HiddenCol1 := False, BlankSubItem := False) {
      If (This.Base.Base.__Class) 
         Return False
      If This.Attached[HWND] 
         Return False
      If !DllCall("IsWindow", "Ptr", HWND) 
         Return False
      VarSetCapacity(Class, 512, 0)
      DllCall("GetClassName", "Ptr", HWND, "Str", Class, "Int", 256)
      If (Class <> "SysListView32") 
         Return False
      SendMessage, 0x1036, 0x010000, 0x010000, , % "ahk_id " . HWND 
      This.HWND := HWND
      This.HEDIT := 0
      This.Item := -1
      This.SubItem := -1
      This.ItemText := ""
      This.RowCount := 0
      This.ColCount := 0
      This.Cancelled := False
      This.Next := False
      This.Skip0 := !!HiddenCol1
      This.Blank := !!BlankSubItem
      This.Critical := "Off"
      This.DW := 0
      This.EX := 0
      This.EY := 0
      This.EW := 0
      This.EH := 0
      This.LX := 0
      This.LY := 0
      This.LR := 0
      This.LW := 0
      This.SW := 0
      This.OnMessage()
      This.Attached[HWND] := True
   }   
   __Delete() {
      This.Attached.Remove(This.HWND, "")
      WinSet, Redraw, , % "ahk_id " . This.HWND
   }
   EditCell(Row, Col := 0) {
      If !This.HWND
         Return False
      ControlGet, Rows, List, Count, , % "ahk_id " . This.HWND
      This.RowCount := Rows - 1
      ControlGet, ColCount, List, Count Col, , % "ahk_id " . This.HWND
      This.ColCount := ColCount - 1
      If (Col = 0) {
         If (This["Columns"])
            Col := This.Columns.MinIndex() + 1
         ELse If This.Skip0
            Col := 2
         Else
            Col := 1
      }
      If (Row < 1) || (Row > Rows) || (Col < 1) || (Col > ColCount)
         Return False
      If (Column = 1) && This.Skip0
         Col := 2
      If (This["Columns"])
         If !This.Columns[Col - 1]
            Return False
      VarSetCapacity(LPARAM, 1024, 0)
      NumPut(Row - 1, LPARAM, (A_PtrSize * 3) + 0, "Int")
      NumPut(Col - 1, LPARAM, (A_PtrSize * 3) + 4, "Int")
      This.NM_DBLCLICK(&LPARAM)
      Return True
   }
   SetColumns(ColNumbers*) {
      If !This.HWND
         Return False
      This.Remove("Columns")
      If (ColNumbers.MinIndex() = "")
         Return True
      ControlGet, ColCount, List, Count Col, , % "ahk_id " . This.HWND
      Indices := []
      For Each, Col In ColNumbers {
         If Col Is Not Integer
            Return False
         If (Col < 1) || (Col > ColCount)
            Return False
         Indices[Col - 1] := True
      }
      This["Columns"] := Indices
      Return True
   }
   OnMessage(Apply := True) {
      If !This.HWND
         Return False
      If (Apply) && !This.HasKey("NotifyFunc") {
         This.NotifyFunc := ObjBindMethod(This, "On_WM_NOTIFY")
         OnMessage(0x004E, This.NotifyFunc) 
      }
      Else If !(Apply) && This.HasKey("NotifyFunc") {
         OnMessage(0x004E, This.NotifyFunc, 0) 
         This.NotifyFunc := ""
         This.Remove("NotifyFunc")
      }
      WinSet, Redraw, , % "ahk_id " . This.HWND
      Return True
   }
   Static Attached := {}
   Static OSVersion := DllCall("GetVersion", "UChar")
   On_WM_COMMAND(W, L, M, H) {
      If (L = This.HEDIT) {
         N := (W >> 16)
         If (N = 0x0400) || (N = 0x0300) || (N = 0x0100) { 
            If (N = 0x0100) 
               SendMessage, 0x00D3, 0x01, 0, , % "ahk_id " . L 
            ControlGetText, EditText, , % "ahk_id " . L
            SendMessage, % (A_IsUnicode ? 0x1057 : 0x1011), 0, % &EditText, , % "ahk_id " . This.HWND
            EW := ErrorLevel + This.DW
            , EX := This.EX
            , EY := This.EY
            , EH := This.EH + (This.OSVersion < 6 ? 3 : 0) 
            If (EW < This.MinW)
               EW := This.MinW
            If (EX + EW) > This.LR
               EW := This.LR - EX
            ControlMove, , %EX%, %EY%, %EW%, %EH%, % "ahk_id " . L
            If (N = 0x0400) 
               Return 0
         }
      }
   }
   On_WM_HOTKEY(W, L, M, H) {
      If (H = This.HWND) {
         If (W = 0x801B) { 
            This.Cancelled := True
            PostMessage, 0x10B3, 0, 0, , % "ahk_id " . H
         }
         Else {
            This.Next := True
            SendMessage, 0x10B3, 0, 0, , % "ahk_id " . H
            This.Next := True
            This.NextSubItem(W)
         }
         Return False
      }
   }
   On_WM_NOTIFY(W, L) {
      Critical, % This.Critical
      If (H := NumGet(L + 0, 0, "UPtr") = This.HWND) {
         M := NumGet(L + (A_PtrSize * 2), 0, "Int")
         If (M = -175) || (M = -105) 
            Return This.LVN_BEGINLABELEDIT(L)
         If (M = -176) || (M = -106) 
            Return This.LVN_ENDLABELEDIT(L)
         If (M = -3) 
            This.NM_DBLCLICK(L)
      }
   }
   LVN_BEGINLABELEDIT(L) {
      Static Indent := 4   
      If (This.Item = -1) || (This.SubItem = -1)
         Return True
      H := This.HWND
      SendMessage, 0x1018, 0, 0, , % "ahk_id " . H 
      This.HEDIT := ErrorLevel
      , VarSetCapacity(ItemText, 2048, 0) 
      , VarSetCapacity(LVITEM, 40 + (A_PtrSize * 5), 0) 
      , NumPut(This.Item, LVITEM, 4, "Int")
      , NumPut(This.SubItem, LVITEM, 8, "Int")
      , NumPut(&ItemText, LVITEM, 16 + A_PtrSize, "Ptr") 
      , NumPut(1024 + 1, LVITEM, 16 + (A_PtrSize * 2), "Int") 
      SendMessage, % (A_IsUnicode ? 0x1073 : 0x102D), % This.Item, % &LVITEM, , % "ahk_id " . H 
      This.ItemText := StrGet(&ItemText, ErrorLevel)
      ControlSetText, , % This.ItemText, % "ahk_id " . This.HEDIT
      If (This.SubItem > 0) && (This.Blank) {
         Empty := ""
         , NumPut(&Empty, LVITEM, 16 + A_PtrSize, "Ptr") 
         , NumPut(0,LVITEM, 16 + (A_PtrSize * 2), "Int") 
         SendMessage, % (A_IsUnicode ? 0x1074 : 0x102E), % This.Item, % &LVITEM, , % "ahk_id " . H 
      }
      VarSetCapacity(RECT, 16, 0)
      , NumPut(This.SubItem, RECT, 4, "Int")
      SendMessage, 0x1038, This.Item, &RECT, , % "ahk_id " . H 
      This.EX := NumGet(RECT, 0, "Int") + This.LX + This.DX + Indent
      , This.EY := NumGet(RECT, 4, "Int") + This.LY + This.DY
      If (This.OSVersion < 6)
         This.EY -= 1 
      If (This.SubItem = 0) {
         SendMessage, 0x101D, 0, 0, , % "ahk_id " . H 
         This.EW := ErrorLevel
      }
      Else
         This.EW := NumGet(RECT, 8, "Int") - NumGet(RECT, 0, "Int")
      This.EW -= Indent
      , This.EH := NumGet(RECT, 12, "Int") - NumGet(RECT, 4, "Int")
      , This.CommandFunc := ObjBindMethod(This, "On_WM_COMMAND")
      , OnMessage(0x0111, This.CommandFunc)
      If !(This.Next)
         This.RegisterHotkeys()
      This.Cancelled := False
      This.Next := False
      Return False
   }
   LVN_ENDLABELEDIT(L) {
      H := This.HWND
      OnMessage(0x0111, This.CommandFunc, 0)
      This.CommandFunc := ""
      If !(This.Next)
         This.RegisterHotkeys(False)
      ItemText := This.ItemText
      If !(This.Cancelled)
         ControlGetText, ItemText, , % "ahk_id " . This.HEDIT
      If (ItemText <> This.ItemText) {
         If !(This["Changed"])
            This.Changed := []
         This.Changed.Insert({Row: This.Item + 1, Col: This.SubItem + 1, Txt: ItemText})
      }
      If (ItemText <> This.ItemText) || ((This.SubItem > 0) && (This.Blank)) {
         VarSetCapacity(LVITEM, 40 + (A_PtrSize * 5), 0) 
         , NumPut(This.Item, LVITEM, 4, "Int")
         , NumPut(This.SubItem, LVITEM, 8, "Int")
         , NumPut(&ItemText, LVITEM, 16 + A_PtrSize, "Ptr") 
         SendMessage, % (A_IsUnicode ? 0x1074 : 0x102E), % This.Item, % &LVITEM, , % "ahk_id " . H 
      }
      If !(This.Next)
         This.Item := This.SubItem := -1
      This.Cancelled := False
      This.Next := False
      Return False
   }
   NM_DBLCLICK(L) {
      H := This.HWND
      This.Item := This.SubItem := -1
      Item := NumGet(L + (A_PtrSize * 3), 0, "Int")
      SubItem := NumGet(L + (A_PtrSize * 3), 4, "Int")
      If (This["Columns"]) {
         If !This["Columns", SubItem]
            Return False
      }
      If (Item >= 0) && (SubItem >= 0) {
         This.Item := Item, This.SubItem := SubItem
         If !(This.Next) {
            ControlGet, V, List, Count, , % "ahk_id " . H
            This.RowCount := V - 1
            ControlGet, V, List, Count Col, , % "ahk_id " . H
            This.ColCount := V - 1
            , NumPut(VarSetCapacity(WINDOWINFO, 60, 0), WINDOWINFO)
            , DllCall("GetWindowInfo", "Ptr", H, "Ptr", &WINDOWINFO)
            , This.DX := NumGet(WINDOWINFO, 20, "Int") - NumGet(WINDOWINFO, 4, "Int")
            , This.DY := NumGet(WINDOWINFO, 24, "Int") - NumGet(WINDOWINFO, 8, "Int")
            , Styles := NumGet(WINDOWINFO, 36, "UInt")
            SendMessage, % (A_IsUnicode ? 0x1057 : 0x1011), 0, % "WWW", , % "ahk_id " . H 
            This.MinW := ErrorLevel
            SendMessage, % (A_IsUnicode ? 0x1057 : 0x1011), 0, % "III", , % "ahk_id " . H 
            This.DW := ErrorLevel
            , SBW := 0
            If (Styles & 0x200000) 
               SysGet, SBW, 2
            ControlGetPos, LX, LY, LW, , , % "ahk_id " . H
            This.LX := LX
            , This.LY := LY
            , This.LR := LX + LW - (This.DX * 2) - SBW
            , This.LW := LW
            , This.SW := SBW
            , VarSetCapacity(RECT, 16, 0)
            , NumPut(SubItem, RECT, 4, "Int")
            SendMessage, 0x1038, %Item%, % &RECT, , % "ahk_id " . H 
            X := NumGet(RECT, 0, "Int")
            If (SubItem = 0) {
               SendMessage, 0x101D, 0, 0, , % "ahk_id " . H 
               W := ErrorLevel
            }
            Else
               W := NumGet(RECT, 8, "Int") - NumGet(RECT, 0, "Int")
            R := LW - (This.DX * 2) - SBW
            If (X < 0)
               SendMessage, 0x1014, % X, 0, , % "ahk_id " . H 
            Else If ((X + W) > R)
               SendMessage, 0x1014, % (X + W - R + This.DX), 0, , % "ahk_id " . H 
         }
         PostMessage, % (A_IsUnicode ? 0x1076 : 0x1017), %Item%, 0, , % "ahk_id " . H 
      }
      Return False
   }
   NextSubItem(K) {
      H := This.HWND
      Item := This.Item
      SubItem := This.SubItem
      If (K = 0x8009) 
         SubItem++
      Else If (K = 0x8409) { 
         SubItem--
         If (SubItem = 0) && This.Skip0
            SubItem--
      }
      Else If (K = 0x8028) 
         Item++
      Else If (K = 0x8026) 
         Item--
      IF (K = 0x8409) || (K = 0x8009) { 
         If (This["Columns"]) {
            If (SubItem < This.Columns.MinIndex())
               SubItem := This.Columns.MaxIndex(), Item--
            Else If (SubItem > This.Columns.MaxIndex())
               SubItem := This.Columns.MinIndex(), Item++
            Else {
               While (This.Columns[SubItem] = "") {
                  If (K = 0x8009) 
                     SubItem++
                  Else
                     SubItem--
               }
            }
         }
      }
      If (SubItem > This.ColCount)
         Item++, SubItem := This.Skip0 ? 1 : 0
      Else If (SubItem < 0)
         SubItem := This.ColCount, Item--
      If (Item > This.RowCount)
         Item := 0
      Else If (Item < 0)
         Item := This.RowCount
      If (Item <> This.Item)
         SendMessage, 0x1013, % Item, False, , % "ahk_id " . H 
      VarSetCapacity(RECT, 16, 0), NumPut(SubItem, RECT, 4, "Int")
      SendMessage, 0x1038, % Item, % &RECT, , % "ahk_id " . H 
      X := NumGet(RECT, 0, "Int"), Y := NumGet(RECT, 4, "Int")
      If (SubItem = 0) {
         SendMessage, 0x101D, 0, 0, , % "ahk_id " . H 
         W := ErrorLevel
      }
      Else
         W := NumGet(RECT, 8, "Int") - NumGet(RECT, 0, "Int")
      R := This.LW - (This.DX * 2) - This.SW, S := 0
      If (X < 0)
         S := X
      Else If ((X + W) > R)
         S := X + W - R + This.DX
      If (S)
         SendMessage, 0x1014, % S, 0, , % "ahk_id " . H 
      Point := (X - S + (This.DX * 2)) + ((Y + (This.DY * 2)) << 16)
      SendMessage, 0x0201, 0, % Point, , % "ahk_id " . H 
      SendMessage, 0x0202, 0, % Point, , % "ahk_id " . H 
      SendMessage, 0x0203, 0, % Point, , % "ahk_id " . H 
      SendMessage, 0x0202, 0, % Point, , % "ahk_id " . H 
   }
   RegisterHotkeys(Register = True) {
      H := This.HWND
      If (Register) { 
         DllCall("RegisterHotKey", "Ptr", H, "Int", 0x801B, "UInt", 0, "UInt", 0x1B)
         , DllCall("RegisterHotKey", "Ptr", H, "Int", 0x8009, "UInt", 0, "UInt", 0x09)
         , DllCall("RegisterHotKey", "Ptr", H, "Int", 0x8409, "UInt", 4, "UInt", 0x09)
         , DllCall("RegisterHotKey", "Ptr", H, "Int", 0x8028, "UInt", 0, "UInt", 0x28)
         , DllCall("RegisterHotKey", "Ptr", H, "Int", 0x8026, "UInt", 0, "UInt", 0x26)
         , This.HotkeyFunc := ObjBindMethod(This, "On_WM_HOTKEY")
         , OnMessage(0x0312, This.HotkeyFunc) 
      }
      Else { 
         DllCall("UnregisterHotKey", "Ptr", H, "Int", 0x801B)
         , DllCall("UnregisterHotKey", "Ptr", H, "Int", 0x8009)
         , DllCall("UnregisterHotKey", "Ptr", H, "Int", 0x8409)
         , DllCall("UnregisterHotKey", "Ptr", H, "Int", 0x8028)
         , DllCall("UnregisterHotKey", "Ptr", H, "Int", 0x8026)
         , OnMessage(0x0312, This.HotkeyFunc, 0) 
         , This.HotkeyFunc := ""
      }
   }
}