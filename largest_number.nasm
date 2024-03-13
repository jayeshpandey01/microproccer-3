section .data
     arr_msg db 10,13,"Array Elements are :"
     arr_len equ $ - arr_msg
     large_msg db 10,13,"Largest element is :"
     large_len equ $ - large_msg
     nwline db 10
     nl_len equ $ - nwline
     array dw 0005h,0003h,0008h,0001h,0002h
     arr_cnt dd 05h
     
     
     
section .bss
     dnum_buff resb 4
     large resw 1
     
     
%macro dispmsg 2
     mov eax,4
     mov ebx,1
     mov ecx,%1
     mov edx,%2
     int 80h
%endmacro
     
     
section .text
     global _start
     _start:

     dispmsg arr_msg,arr_len
     mov esi,array
     mov ecx,[arr_cnt]
     
up1: mov bx,[esi]
     push ecx
     call disp_num
     dispmsg nwline,1
     pop ecx
     add esi,2
     loop up1
     mov esi,array
     mov ecx,[arr_cnt]
     mov ax,[esi]
     dec ecx
     
     
     
lup1:add esi,02
     cmp ax,[esi]
     ja lskip1
     xchg ax,[esi]
lskip1:loop lup1

       mov [large],ax
       
       dispmsg large_msg,large_len
       mov bx,[large]
       call disp_num
       
       dispmsg nwline,nl_len
       
       
exit:  mov eax,01
       mov ebx,0
       int 80h
       
       
disp_num: mov edi,dnum_buff
          mov ecx,04
          
dispup1:  rol bx,4
          mov dl,bl
          and dl,0fh
          
          cmp dl,09h
          jbe dispskip1
          add dl,07h
          
dispskip1:  add dl, 30h
            mov [edi],dl
            inc edi
            dec ecx
            jnz dispup1
            
            
            dispmsg dnum_buff,4
            
            ret
     

     
     
     
