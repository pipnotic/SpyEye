.code

ReadConfigBinary PROC path:DWORD
	LOCAL hFile:DWORD
	LOCAL lSize:DWORD
	LOCAL pMem:DWORD
	
	invoke CreateFile,path,GENERIC_READ,NULL,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,NULL
	.if eax != INVALID_HANDLE_VALUE
	
		mov hFile,eax
		invoke GetFileSize,hFile,NULL
		
		mov lSize,eax
		invoke VirtualAlloc,NULL,lSize,MEM_COMMIT or MEM_RESERVE,PAGE_READWRITE
		
		mov pMem,eax
		invoke ReadFile,hFile,pMem,lSize,ADDR lBytesRead,NULL
		
		.if eax != 0
			push lSize
			push pMem
			call DecodeBinary
			
			push lSize
			push pMem
			call WriteZipArchive
			
		.endif
		
		invoke CloseHandle,hFile
		invoke VirtualFree,pMem,NULL,MEM_RELEASE
	
	.endif
	Ret
ReadConfigBinary ENDP

DecodeBinary proc pMem:DWORD, lCount:DWORD
	mov eax,lCount
	mov ecx,pMem	
	
	@@:
		mov dl, [eax+ecx]
		xor dl,04ch
		sub dl,[eax+ecx-1]
		mov [eax+ecx],dl
		dec eax
		test eax,eax
	jg @b

	Ret
DecodeBinary endp

WriteZipArchive proc pMem:DWORD,lCount:DWORD
	LOCAL hArchive:DWORD
	
	invoke CreateFile,ADDR szOutputFile,GENERIC_WRITE,NULL,NULL,CREATE_NEW,FILE_ATTRIBUTE_NORMAL,NULL
	.if eax != INVALID_HANDLE_VALUE
		mov hArchive,eax
		invoke WriteFile,hArchive,pMem,lCount,ADDR lBytesWritten,NULL
		invoke CloseHandle,hArchive
	.endif
	Ret
WriteZipArchive endp
