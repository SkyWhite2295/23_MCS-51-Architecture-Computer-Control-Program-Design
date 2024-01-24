OUTBIG EQU 8002H   ;λ���ƿ�
OUTSEG EQU 8004H   ;�ο��ƿ�
KEYIN  EQU 8001H    ;���̶����


;***********updated*******
;���������ֵ�� ��ֵ��6�������
READY:    MOV 20H,#3fH
          MOV 21H,#5bH
          MOV 22H,#3fH
          MOV 23H,#06H
          MOV 24H,#5bH
          MOV 25H,#3fH
;*********************************

;**********ADD1 module test**************
;         LOOPADD1:
;         ACALL ADD1
;         JMP LOOPADD1
          ;jmp TRANSFER
;*********************************************���

          MOV 28h,#6
MAIN:

          LCALL DISPLAY   ;�޼������룬������ʾ��ǰ������
          LCALL TEST
          JZ MAIN    ;�ۼ���Ϊ0�ް����� ������ʾ
          LCALL SEARCH    ;�м�ֵ����?
          MOV 20H,21H    ;�������ʾ������ļ�ֵ
          MOV 21H,22H
          MOV 22H,23H
          MOV 23H,24H
          MOV 24H,25H

          MOV DPTR,#LEDTAB
          MOVC A,@A+DPTR
          MOV 25H,A


          DJNZ 28h, MAIN

TRANSFER:
         MOV A,20H
         MOV DPTR,#NUMBERTAB
         MOVC A,@A+DPTR
         MOV 20H,A

         MOV A,21H
         MOV DPTR,#NUMBERTAB
         MOVC A,@A+DPTR
         MOV 21H,A

         MOV A,22H
         MOV DPTR,#NUMBERTAB
         MOVC A,@A+DPTR
         MOV 22H,A

         MOV A,23H
         MOV DPTR,#NUMBERTAB
         MOVC A,@A+DPTR
         MOV 23H,A

         MOV A,24H
         MOV DPTR,#NUMBERTAB
         MOVC A,@A+DPTR
         MOV 24H,A

         MOV A,25H
         MOV DPTR,#NUMBERTAB
         MOVC A,@A+DPTR
         MOV 25H,A

SHIZHONG: LCALL Delone
          LCALL ADD1
          ;LCALL DELONE

          SJMP SHIZHONG

DISPLAY:    ;��ʾģ��
          MOV R0,#20H    ;��������20H����ʼ
          MOV R1,#6    ;��6���˶ι�
          MOV R2,#00100000B    ;����߿�ʼ��ʾ����Ϊ1����Ϊ0

LOOP:     MOV DPTR,#OUTSEG
          MOV A,#0
          MOVX @DPTR,A    ;λѡ�趨Ϊ0
          MOV A,@R0    ;����20HΪ�׵�ַ���ڴ�ֵ���͵����������8004H
          MOVX @DPTR,A

          MOV DPTR,#OUTBIG    ;���λѡͨ���ţ� ʹÿ��ֻ��ʾһλ�˶ι�
          MOV A,R2
          MOVX @DPTR,A
          RR A
          MOV R2,A
          LCALL DELAY;����ʱ
          INC R0
          DJNZ R1,LOOP;�� ��ʾ6��
          RET

 ;***********another display module**************
DISPLAY2:    ;��ʾģ��
          MOV R0,#20H    ;��������20H����ʼ
          MOV R1,#6    ;��6���˶ι�
          MOV R2,#00100000B    ;����߿�ʼ��ʾ����Ϊ1����Ϊ0

LOOP3:
          MOV DPTR,#LEDTAB
          MOV A,@R0
          MOVC A,@A+DPTR
          MOV B,A

          MOV DPTR,#OUTSEG
          MOV A,#0
          MOVX @DPTR,A
          MOV A,B    ;����20HΪ�׵�ַ���ڴ�ֵ���͵����������8004H
          MOVX @DPTR,A

          MOV DPTR,#OUTBIG    ;���λѡͨ���ţ� ʹÿ��ֻ��ʾһλ�˶ι�
          MOV A,R2
          MOVX @DPTR,A
          RR A
          MOV R2,A
          LCALL DELAY;����ʱ
          INC R0
          DJNZ R1,LOOP3;�� ��ʾ6��
          RET
 ;**********************************

DELAY:   MOV R7,#02H    ;��ʱ�ӳ���
DEL1:    MOV R6,#0ffH
DEL2:    DJNZ R6,DEL2
          DJNZ R7,DEL1
          RET

TEST:     MOV DPTR,#OUTBIG    ;������޼�ֵ����
          MOV A,#00H
          MOVX @DPTR,A    ;�ͳ�0
          MOV DPTR,#KEYIN
          MOVX A,@DPTR    ;�ض���״̬
          CPL  A        ;�ۼ�������λ��
          ANL A,#0FH
          RET

SEARCH:    ;�ҳ���ֵ���ڵĵ�λ��(�к���)
          MOV R1,#00100000B  ;����ʼ�У�����߿�ʼ
          MOV R2,#06H ;����6��
          MOV R5,#00H ;����¼��ǰ��������
          MOV R4,#03H ;���Ѿ������˶�����

LSEARCH:    ;�ҳ�������λ�ú�
          MOV A,R1
          CPL A
          MOV DPTR,#OUTBIG
          MOVX @DPTR,A
          CPL A
          RR A    ;ͨ���ж�ѭ�����ν�λΪ1��ʵ�ּ����Ĺ���
          MOV R1,A
          MOV DPTR,#KEYIN
          MOVX A,@DPTR
          CPL A
          ANL A,#0FH
          JNZ HSEARCH    ;AΪ����ҵ������У� ����Ѱ��������λ��
          INC R5     ;����Ϊ������һ��������
          DJNZ R2,LSEARCH

HSEARCH:
          MOV R7,#04H;��һ��������
LOOP2:    RRC A
          JC GET
          DEC R4
          DJNZ R7,LOOP2
GET:    ;ȷ������ļ���ֵ
        MOV A,R4    ;��ֵ=��*6+��,R4*6+R5->A
        MOV B,#6H
        MUL AB
        ADD A,R5
        MOV DPTR,#KEYTAB;ȡ����������λ��
        MOVC A,@A+DPTR
        MOV 26H,A    ;��ȡ����ֵ��ʱ�������ڴ���,��ֹ���ݶ�ʧ

WAIT:   MOV DPTR,#OUTBIG    ;�ȼ��ͷ�
        CLR A
        MOVX @DPTR,A
        LCALL DELAY
        LCALL TEST
        JNZ WAIT
        MOV A,26H    ;�ͷų���������ֵ
        RET

;********************ADD1*************************
ADD1:   ;20h ---25h
        ;���λ
        MOV A,25H
        INC A
        MOV 25H,A
        CJNE A,#0AH,QUIT;���λ������10�򷵻�
        MOV 25H,#00H
        ;���λ
        MOV A,24H
        INC A
        MOV 24H,A
        CJNE A,#06H,QUIT;���λ������6�򷵻�
        MOV  24H,#00H
        ;�ֵ�λ
        MOV A,23H
        INC A
        MOV 23H,A
        CJNE A,#0AH,QUIT;�ֵ�λ������10�򷵻�
        MOV 23H,#00H
        ;�ָ�λ
        MOV A,22H
        INC A
        MOV 22H,A
        CJNE A,#06H,QUIT;���λ������6�򷵻�
        MOV  22H,#00H
        ;ʱ��λ,���⴦��0~19,20~24
        MOV A,20H
        CJNE A,#02H,HOUR019
        JMP HOUR2024

        ;ʱ��λ
HOUR019:
       MOV A,21H
       INC A
       MOV 21H,A
       CJNE A,#0AH,QUIT;ʱ��λ������4�򷵻�
       MOV 21H,#00H
       ;��ʱʱ��λһ���޽�λ��ֱ�Ӷ�ʱ��λ��һ����
       MOV A,20H
       INC A
       MOV 20H,A
       JMP QUIT
HOUR2024:
       MOV A,21H
       INC A
       MOV 21H,A
       CJNE A,#04H,QUIT;ʱ��λ������4�򷵻�
       MOV 21H,#00H
       ;��ʱʱ��λһ���н�λ��ֱ�Ӷ�ʱ��λ��0����
       MOV 20H,#00H
       JMP QUIT
QUIT:ret
        RET
;**********************************************************

;************delay 1 second***********
DELONE:
        MOV 29h,#10

L3:
    LCALL DISPLAY2
    MOV 2ah,#6
L1:
    LCALL DISPLAY2
    MOV 2bh,#1

L2:
    LCALL DISPLAY2
    DJNZ 2bh,L2
        DJNZ 2ah,L1
        DJNZ 29h,L3
        RET
;**********************************

LEDTAB:     ;�˶ι���ʾ��
        DB 3fh, 06h, 5bh, 4fh, 66h, 6dh, 7dh, 07h
        DB 7fh, 6fh, 77h, 7ch, 39h, 5eh, 79h, 71h
KEYTAB:    ;������
        DB 07h, 08h, 09h, 0ah, 10h, 0ffh,
        DB 04h, 05h, 06h, 0bh, 11h, 14h,
        DB 01h, 02h, 03h, 0ch, 12h, 15h,
        DB 00h, 0fh,0eh, 0dh, 13h, 16h,
NUMBERTAB:
DB 0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,01H,07H,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,
DB 0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,
DB 0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,
DB 0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,00H,
DB 0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,03H,
DB 0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,02H,0FFH,0FFH,0FFH,0FFH,
DB 0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,04H,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,05H,0FFH,09H,
DB 0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,06H,0FFH,08H,
DB 0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,
DB 0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,
DB 0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,
DB 0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,
DB 0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,
DB 0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,
DB 0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,
DB 0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,