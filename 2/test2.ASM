STRT:MOV 20H,#00H   ;20H��D7��0��ת,D1D0��ַƫ����
     MOV P1,#01H      ;���������ʼ��7,P1��#01H,A��ͨ��
     MOV 42H,#0A0H   ;100�����ӳټ�����42H

     acall speedup
     MOV 20H,#00H   ;20H��D7��0��ת,D1D0��ַƫ����
     acall speed
     MOV 20H,#00H   ;20H��D7��0��ת,D1D0��ַƫ����
     acall speedlow

     MOV 20H,#80H   ;20H��D7��1��ת,D1D0��ַƫ����
     MOV P1,#01H      ;���������ʼ��,P1��#01H,A��ͨ��
     MOV 42H,#0A0H   ;100�����ӳټ�����42H

     acall speedup
     MOV 20H,#80H   ;20H��D7��1��ת,D1D0��ַƫ����
     acall speed
     MOV 20H,#80H   ;20H��D7��1��ת,D1D0��ַƫ����
     acall speedlow

     sjmp strt

 ;���ٲ�������
speedup: MOV   R7,#64H      ;100���벽��������R7
MLP0:	 MOV   R6,42H        ;��ʱ
MLPX0:   LCALL DEL       ;���ö���ʱ�ӳ���
         DJNZ  R6,MLPX0
	 DEC   42H             ;���ӳټ�����42H�е�ֵ��һ
         LCALL STEPS      ;����һ���ӳ���
         DJNZ  R7,MLP0     ;����������1,��Ϊ���������
         ret

 ; ���ٲ�������
speed: 	 MOV   R7,#64H    ;100���벽��������R7
MLP1:    MOV   R6,42H        ;��ʱ
MLPX1:   LCALL DEL       ;���ö���ʱ�ӳ���
         DJNZ  R6,MLPX1
         LCALL STEPS      ;������һ���ӳ���
         DJNZ  R7,MLP1     ;����������1,��Ϊ���������
         RET

 ;���ٲ�������
speedlow:MOV   R7,#0C8H      ;100���벽��������R7
MLP2:	 MOV   R6,42H        ;��ʱ
MLPX2:   LCALL DEL       ;���ö���ʱ�ӳ���
         DJNZ  R6,MLPX2
	 Inc   42H             ;���ӳټ�����42H�е�ֵ��һ
         LCALL STEPS      ;����һ���ӳ���
         DJNZ  R7,MLP2  ;����������1,��Ϊ���������
         ret

;����һ���ӳ���
STEPS:INC   20H                  	;��ַƫ������1
            ANL    20H,#83H        	;����20H��D7��D1��D0λ״̬
            JB     7, STPSC            	;20H��D7=1��ת, D7=0��ת
            MOV    DPTR,#FTAB	 ;��ת����ַ��DPTR
            SJMP   STPW              ;��ת���������
STPSC:MOV   DPTR,  #CTAB   ;��ת����ַ��DPTR
STPW:MOV    A,20H                ;�������
            ANL    A,#03H              ;ȡ��ַƫ����
            MOVC   A,@A+DPTR  ;ȡͨ��״̬��
            MOV    P1,A                 ;���ͨ��״̬��,���������һ��
            RET

FTAB:DB 01H,02H,04H,08H	;��ת��
CTAB:DB 01H,08H,04H,02H	;��ת��

;����ʱ�ӳ���
DEL:   MOV  R5,#40H           ;   1T
DEL0:  DJNZ  R5,DEL0          ;   2T
       RET                               ;   1T
END                                      ;�������