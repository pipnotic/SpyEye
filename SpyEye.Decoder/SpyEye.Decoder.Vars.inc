include windows.inc 
include kernel32.inc
include user32.inc
include comdlg32.inc

include C:\masm32\macros\macros.asm

includelib	kernel32.lib
includelib user32.lib
includelib comdlg32.lib

; Prototypes
GUI_DlgProc				PROTO		:DWORD,:DWORD,:DWORD,:DWORD
GUI_OpenSelectedFile		PROTO		:DWORD,:DWORD,:DWORD

.const
IDD_LOADER		EQU 			1001
IDC_NAME 		EQU 			1002
IDC_EXIT 		EQU 			1006
IDC_FILEPATH 	EQU 			1009
IDC_SMOPEN 		EQU 			1011
IDC_EXTRACT		EQU				1022
IDC_ABOUT		EQU				1023
ICON 			EQU 			2000


; Uninitialised data
.data?
hInstance		HINSTANCE 			?
hWindow		HWND				?
lBytesRead	DWORD				?
lBytesWritten	DWORD				?


; Initialised data
.data
ofn				OPENFILENAME	<SIZEOF OPENFILENAME>
lpOverLapped		OVERLAPPED		<SIZEOF OVERLAPPED>

szOurTitle			BYTE 			"-=[ Select File",0
szOutputFile		BYTE			"C:\config.zip",0
szModuleFilter		BYTE 			"Binary Files",0,"*.*",0,0
szModulePath		BYTE			MAX_PATH DUP(0)
