.686
.model flat,stdcall
option casemap:none

include SpyEye.Decoder.Vars.inc
include SpyEye.Decoder.Funcs.asm

.code

GUI_DlgProc PROC hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM 
	.if uMsg == WM_INITDIALOG
		push hWnd
		pop hWindow
		invoke LoadIcon,hInstance,ICON
		invoke SendMessage,hWindow,WM_SETICON,1,eax
		invoke GetDlgItem,hWindow,IDC_NAME
		invoke SetFocus,eax 
	.elseif uMsg == WM_COMMAND
		mov	eax,wParam
		.if eax == IDC_SMOPEN
			invoke GUI_OpenSelectedFile,ADDR szModulePath,ADDR szModuleFilter,IDC_FILEPATH
			.if eax != 0
				invoke GetDlgItem,hWindow,IDC_EXTRACT
				invoke EnableWindow,eax,1
			.endif
		.elseif eax == IDC_EXTRACT
		
			push OFFSET szModulePath
			call ReadConfigBinary
			
			invoke GetDlgItem,hWindow,IDC_EXTRACT
			invoke EnableWindow,eax,0
			
			invoke MessageBox,hWindow,ADDR szOutputFile,CTXT("-=[ Encrypted ZIP Archive"),MB_ICONINFORMATION
			
		.elseif eax==IDC_ABOUT
			invoke MessageBox,hWindow,CTXT("SpyEye Config.bin Decoding utility."),CTXT("-=[ CSIS Security Group"),MB_ICONINFORMATION
		.elseif eax==IDC_EXIT
			invoke SendMessage,hWindow,WM_CLOSE,0,0
		.endif
	.elseif uMsg == WM_CLOSE
		invoke EndDialog,hWindow,0
	.endif
	
	@return:
	xor eax,eax
	ret 
GUI_DlgProc ENDP 

GUI_OpenSelectedFile PROC path:DWORD,filter:DWORD,field:DWORD
	mov ofn.lStructSize,SIZEOF ofn
	push hWindow
	pop  ofn.hwndOwner
	push hInstance
	pop  ofn.hInstance
	mov eax,filter
	mov  ofn.lpstrFilter,eax
	mov eax,path
	mov  ofn.lpstrFile,eax
	mov  ofn.nMaxFile,MAX_PATH
	mov  ofn.Flags, OFN_FILEMUSTEXIST or OFN_PATHMUSTEXIST or OFN_LONGNAMES or OFN_EXPLORER or OFN_HIDEREADONLY
	mov  ofn.lpstrTitle, OFFSET szOurTitle
	
	invoke GetOpenFileName,ADDR ofn

	test eax,eax
	jz @good
		push path
		push field
		push hWindow
		call SetDlgItemText
		ret
	@good:
	
	xor eax,eax
	ret
GUI_OpenSelectedFile ENDP

start:

invoke GetModuleHandle, NULL 
mov hInstance,eax
invoke DialogBoxParam,hInstance,IDD_LOADER,0,ADDR GUI_DlgProc,0 
invoke ExitProcess,eax 


end start