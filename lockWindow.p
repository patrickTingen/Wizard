/*------------------------------------------------------------------------
    File        : lockWindow.p
    Purpose     : Lock / unlock updates that Windows does to windows.

    Author(s)   : Patrick Tingen
    Created     : 2019
*/
DEFINE INPUT PARAMETER phWindow AS HANDLE  NO-UNDO.
DEFINE INPUT PARAMETER plLock   AS LOGICAL NO-UNDO.

DEFINE VARIABLE iRet AS INTEGER NO-UNDO.

/* Locking / unlocking windows */
&GLOBAL-DEFINE WM_SETREDRAW     11
&GLOBAL-DEFINE RDW_ALLCHILDREN 128
&GLOBAL-DEFINE RDW_ERASE         4
&GLOBAL-DEFINE RDW_INVALIDATE    1

IF NOT VALID-HANDLE(phWindow) THEN RETURN.

IF plLock THEN
  RUN SendMessageA(phWindow:HWND, {&WM_SETREDRAW}, 0, 0, OUTPUT iRet).
ELSE 
DO:
  RUN SendMessageA(phWindow:HWND, {&WM_SETREDRAW}, 1, 0, OUTPUT iRet).
  RUN RedrawWindow(phWindow:HWND, 0, 0, {&RDW_ALLCHILDREN} + {&RDW_ERASE} + {&RDW_INVALIDATE}, OUTPUT iRet).
END.


PROCEDURE SendMessageA EXTERNAL "user32.dll":
  DEFINE INPUT  PARAMETER hwnd   AS long NO-UNDO.
  DEFINE INPUT  PARAMETER wmsg   AS long NO-UNDO.
  DEFINE INPUT  PARAMETER wparam AS long NO-UNDO.
  DEFINE INPUT  PARAMETER lparam AS long NO-UNDO.
  DEFINE RETURN PARAMETER rc     AS long NO-UNDO.
END PROCEDURE.


PROCEDURE RedrawWindow EXTERNAL "user32.dll":
  DEFINE INPUT PARAMETER v-hwnd  AS LONG NO-UNDO.
  DEFINE INPUT PARAMETER v-rect  AS LONG NO-UNDO.
  DEFINE INPUT PARAMETER v-rgn   AS LONG NO-UNDO.
  DEFINE INPUT PARAMETER v-flags AS LONG NO-UNDO.
  DEFINE RETURN PARAMETER v-ret  AS LONG NO-UNDO.
END PROCEDURE.