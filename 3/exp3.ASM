;LED��ʾ16������
ORG 0000H
OUTBIG EQU 8002H   ;λѡ�źſ��Ƶ�ַ,��ʱ����Ϊ������ɨ���źŵ�ַ
OUTSEG EQU 8004H   ;��ѡ�źſ��Ƶ�ַ
KEYIN  EQU 8001H    ;������ѡ�źſ��Ƶ�ַ
DAC EQU 9000H ;D/Aת��������������λ��,D/Aѡͨ�ź�ΪCS1
AJMP READY
ORG 000BH          ;T0���жϷ�������ַTIME
AJMP TIME

;T1����,T0��ʱ,������Ϊ��12MHz,ʵ����11.0592MHz
READY:
	MOV SP,#60H    ;���ö�ջָ��
	MOV 20H,#3fH   ;0
	MOV 21H,#06H   ;1
        MOV 22H,#06H   ;1
        MOV 23H,#7dH   ;6
        MOV 24H,#3fH   ;0
        MOV 25H,#66H   ;4   ����LED��ʾ��ֵ
	MOV 26H,#00H   ;����������ֵ
	MOV 27H,#00H    ;���ڼ�¼�жϴ���
	MOV 28H,#01H    ;��¼����ֵ��λ
        MOV 29H,#20H

	MOV TMOD,#51H  ;01010001B,T1�����ڷ�ʽ1,T0�����ڷ�ʽ1
	MOV TL0,#0B0H
	MOV TH0,#3CH   ;����T0��ʱ����Ϊ15536,������Ϊ12MHz,��ÿ20���ж�Ϊ1��
	MOV  TL1,#00H
	MOV TH1,#00H   ;����T1������������ֵΪ0
	SETB ET0        ;����T0�ж�
	SETB EA                  ;�������ж�
	SETB TR0       ;������ʱ
	SETB TR1       ;��������
MAIN:
        LCALL DACHANGE
        LCALL DISPLAY   ;�޼�������,������ʾ��ǰ������(ʮ������)
        LCALL TEST      ;�����Ƿ��м�������
        JZ MAIN         ;�ۼ���Ϊ0,�ް���,������ʾ
	LCALL SEARCH    ;�м�ֵ����,���ȡ��ֵ,����A��
	MOV 20H,21H     ;���2λ �������ʾ������

	MOV B,28H        ;����ֵ��λ����B
	MOV 28H,A        ;������ֵ��λ

	MOV DPTR,#LEDTAB
	MOVC A,@A+DPTR  ;����ֵת��Ϊ����
	MOV 21H,A       ;���¼�ֵ�Ķ�����������ڶ�λLED��ʾ

	MOV A,#0FH      ;������16����A
	MUL AB          ;��λ��B,��λ��A
	ADD A,28H        ;����ֵ�����A
	MOV 26H,A       ;����ֵ��26H

        LCALL DACHANGE
	SJMP MAIN

DACHANGE:
        MOV DPTR,#DAC
        MOV A,29H
        MOVX @DPTR,A
        RET
;-----��ʾģ��-----------------------------------------------------------
DISPLAY:
          MOV R0,#20H    ;��������20H����ʼ
          MOV R1,#6    ;��6���˶ι�
          MOV R2,#00100000B    ;����߿�ʼ��ʾ����Ϊ1����Ϊ0

LOOP:     MOV DPTR,#OUTSEG
          MOV A,#0
          MOVX @DPTR,A    ;�����趨Ϊ0
          MOV A,@R0       ;����20HΪ�׵�ַ���ڴ�ֵ���͵����������8004H
          MOVX @DPTR,A

          MOV DPTR,#OUTBIG
          MOV A,R2
          MOVX @DPTR,A     ;���λѡͨ�źţ� ʹÿ��ֻ��ʾһλ�˶ι�
          RR A
          MOV R2,A
          LCALL DELAY         ;��ʱ
          INC R0
          DJNZ R1,LOOP        ;��ʾ6��

          RET
;---��ʱ�ӳ���--------------------------------------------------------------
DELAY:
	MOV R7,#02H
DEL1:    MOV R6,#0ffH
DEL2:    DJNZ R6,DEL2
          DJNZ R7,DEL1
          RET
;---------������޼�������-------------------------------------------------
TEST:
	  MOV DPTR,#OUTBIG
          MOV A,#00H
          MOVX @DPTR,A
          MOV DPTR,#KEYIN
          MOVX A,@DPTR    ;�ض���״̬
          CPL  A        ;�ۼ���A��λ��
          ANL A,#0FH    ;ȡA��4λ

	  RET
;-------��ȡ���µļ���Ϣ--------------------------------------------------
SEARCH:
          MOV R1,#00100000B  ;��ʼ�У�����߿�ʼ
          MOV R2,#06H ;��6��
          MOV R5,#00H ;��¼��ǰ������
          MOV R4,#03H ;�Ѿ������˶�����
;----�ҳ���Ч�к���----------
LSEARCH:
          MOV A,R1
          CPL A           ;������ɨ�����Ч��LEDλѡ����Ч
          MOV DPTR,#OUTBIG
          MOVX @DPTR,A
          CPL A
          RR A            ;ʼ�ս�LEDλѡͨ�ź����ƣ�����R1
          MOV R1,A
          MOV DPTR,#KEYIN
          MOVX A,@DPTR     ;����������ɨ���ź�(����Ч)
          CPL A
          ANL A,#0FH     ;ȡ��4λ
          JNZ HSEARCH    ;A��Ϊ����ҵ������к��У��д���R1�У��д���A�У�
          INC R5     	 ;AΪȫ�㣬��������һ��������
          DJNZ R2,LSEARCH  ;����6�ο����ҵ�
;--------���дӶ�����λ��ʾת��Ϊ��ŵ���ʽ------
HSEARCH:
          MOV R7,#04H	;һ��������
LOOP2:    RRC A
          JC GET
          DEC R4
          DJNZ R7,LOOP2
;-------;ȷ������ļ���ֵ---------------------
GET:
        MOV A,R4    ;��ֵ�ڼ����ϵ�ƫ����=�к�*6+�к�,R4*6+R5->A
        MOV B,#6H
        MUL AB
        ADD A,R5
        MOV DPTR,#KEYTAB
        MOVC A,@A+DPTR
        MOV 26H,A    ;��ȡ����ֵ��ʱ�������ڴ���,��ֹ���ݶ�ʧ

WAIT:   MOV DPTR,#OUTBIG    ;�ȼ��ͷ�
        CLR A
        MOVX @DPTR,A
        LCALL DELAY
        LCALL TEST
        JNZ WAIT
        MOV A,26H    ;����ֵ����A

        RET
;-----T0���жϴ�������TIME----------------
TIME:
	PUSH PSW
	PUSH ACC
	PUSH B
	PUSH DPL
	PUSH DPH
	SETB RS0     ;ѡ��Ĵ�����1
	CLR  RS1
	MOV R0,27H   ;ȡ���жϴ���
	INC R0  ;�жϴ�����һ
	MOV 27H,R0   ;����жϴ���
	CJNE R0,#14H,END1  ;����20ֱ�ӷ���
	MOV R0,#00H
	MOV 27H,R0  ;����жϴ���
	CLR  TR0  ;ֹͣ��ʱ
	CLR  TR1  ;ֹͣ����
	MOV  30H,TL1  ;������λ����30H
	MOV  31H,TH1  ;������λ����31H
	MOV A,30H    ;��������A
	MOV  B,#0FH    ;������B
	DIV AB       ;������̴�A,������B
	MOV DPTR,#LEDTAB
	MOVC A,@A+DPTR  ;����ֵת��Ϊ����
	MOV  24H,A
	MOV A,B
	MOVC A,@A+DPTR  ;����ֵת��Ϊ����
	MOV 25H,A

	MOV A,31H    ;��������A
	MOV  B,#0FH    ;������B
	DIV AB       ;������̴�A,������B
	MOV DPTR,#LEDTAB
	MOVC A,@A+DPTR  ;����ֵת��Ϊ����
	MOV  22H,A
	MOV A,B
	MOVC A,@A+DPTR  ;����ֵת��Ϊ����
	MOV 23H,A

	MOV A,31H     ;ȡת�ٸ�λ
	JNZ SPEEDDOWN   ;��λ����0����ת��̫�죬����
	MOV A,30H     ;ȡת�ٵ�λ
	CLR C         ;���CYλ
	SUBB A,26H         ;ת��-����ֵ���������A
	JB CY,SPEEDUP ;���ֽ�λ��ת��ƫ�ͣ�����
	JZ SUBEND     ;��Aȫ�㣬ת�ٺ�����ֵ��ͬ����ת
	SJMP SPEEDDOWN ;����ת��̫�죬����

SPEEDDOWN:
	MOV A,29H     ;����������A
	ADDC A,#01H
	MOV 29H,A      ;��������һ
	SJMP SUBEND

SPEEDUP:
	MOV A,29H     ;����������A
	SUBB A,#01H
	MOV 29H,A      ;��������һ
	SJMP SUBEND

SUBEND:	;���¸���ֵȻ��������ʱ����
	MOV TL0,#0B0H
	MOV TH0,#3CH   ;����T0��ʱ����Ϊ15536,������Ϊ12MHz,��ÿ20���ж�Ϊ1��
	MOV TL1,#00H
	MOV TH1,#00H   ;����T1������������ֵΪ0
	SETB ET0        ;����T0�ж�
	SETB EA         ;�������ж�
	SETB TR0       ;������ʱ
	SETB TR1       ;��������

END1:	POP DPH
	POP DPL
	POP B
	POP ACC
	POP PSW
	RETI     ;�жϷ���

;--��������ֵ---�������ֵ----���----------------------------------------

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