#INCLUDE <P18F45K22.INC>



     ; CONFIG1H

  CONFIG  FOSC = INTIO67        ; Oscillator Selection bits (Internal
; oscillator block)

  CONFIG  PLLCFG = OFF          ; 4X PLL Enable (Oscillator used directly)

  CONFIG  PRICLKEN = OFF        ; Primary clock enable bit (Primary clock can
; be disabled by software)

  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-
; Safe Clock Monitor disabled)

  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit
; (Oscillator Switchover mode disabled)



; CONFIG2L

  CONFIG  PWRTEN = OFF          ; Power-up Timer Enable bit (Power up timer
; disabled)

  CONFIG  BOREN = OFF           ; Brown-out Reset Enable bits (Brown-out Reset
; disabled in hardware and software)

  CONFIG  BORV = 190            ; Brown Out Reset Voltage bits (VBOR set to
; 1.90 V nominal)



; CONFIG2H

  CONFIG  WDTEN = OFF           ; Watchdog Timer Enable bits (Watch dog timer
; is always disabled. SWDTEN has no effect.)

  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits
; (1:32768)



; CONFIG3H

  CONFIG  CCP2MX = PORTC1       ; CCP2 MUX bit (CCP2 input/output is
; multiplexed with RC1)

  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<5:0> pins are
; configured as digital I/O on Reset)

  CONFIG  CCP3MX = PORTE0       ; P3A/CCP3 Mux bit (P3A/CCP3 input/output is
; mulitplexed with RE0)

  CONFIG  HFOFST = ON           ; HFINTOSC Fast Start-up (HFINTOSC output and
; ready status are not delayed by the oscillator stable status)

  CONFIG  T3CMX = PORTC0        ; Timer3 Clock input mux bit (T3CKI is on RC0)

  CONFIG  P2BMX = PORTD2        ; ECCP2 B output mux bit (P2B is on RD2)

  CONFIG  MCLRE = INTMCLR       ; MCLR Pin Enable bit (RE3 input pin enabled;
; MCLR disabled)



; CONFIG4L

  CONFIG  STVREN = OFF          ; Stack Full/Underflow Reset Enable bit (Stack
; full/underflow will not cause Reset)

  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply
; ICSP disabled)

  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit
; (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))



; CONFIG5L

  CONFIG  CP0 = OFF             ; Code Protection Block 0 (Block 0
; (000800-001FFFh) not code-protected)

  CONFIG  CP1 = OFF             ; Code Protection Block 1 (Block 1
; (002000-003FFFh) not code-protected)

  CONFIG  CP2 = OFF             ; Code Protection Block 2 (Block 2
; (004000-005FFFh) not code-protected)

  CONFIG  CP3 = OFF             ; Code Protection Block 3 (Block 3
; (006000-007FFFh) not code-protected)



; CONFIG5H

  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block
; (000000-0007FFh) not code-protected)

  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM
; not code-protected)



; CONFIG6L

  CONFIG  WRT0 = OFF            ; Write Protection Block 0 (Block 0
; (000800-001FFFh) not write-protected)

  CONFIG  WRT1 = OFF            ; Write Protection Block 1 (Block 1
; (002000-003FFFh) not write-protected)

  CONFIG  WRT2 = OFF            ; Write Protection Block 2 (Block 2
; (004000-005FFFh) not write-protected)

  CONFIG  WRT3 = OFF            ; Write Protection Block 3 (Block 3
; (006000-007FFFh) not write-protected)



; CONFIG6H

  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit
; (Configuration registers (300000-3000FFh) not write-protected)

  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot Block
; (000000-0007FFh) not write-protected)

  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data
; EEPROM not write-protected)



; CONFIG7L

  CONFIG  EBTR0 = OFF           ; Table Read Protection Block 0 (Block 0
; (000800-001FFFh) not protected from table reads executed in other blocks)

  CONFIG  EBTR1 = OFF           ; Table Read Protection Block 1 (Block 1
; (002000-003FFFh) not protected from table reads executed in other blocks)

  CONFIG  EBTR2 = OFF           ; Table Read Protection Block 2 (Block 2
; (004000-005FFFh) not protected from table reads executed in other blocks)

  CONFIG  EBTR3 = OFF

; Table Read Protection Block 3 (Block 3 (006000-007FFFh) not protected from
; table reads executed in other blocks)



; CONFIG7H

  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot
; Block (000000-0007FFh) not protected from table reads executed in other
; blocks)



CBLOCK 0x000

LIMIT_U,LIMIT_L,A_DC,PLUS,RDD,RA,COUNTER,VALUE,SEG7:10,UNIT,CENT,DECT,STATUS_PORTC,STATUS_PORTE,LIMIT

ENDC



ORG 0

GOTO M



ORG 0x0008

GOTO INT_H ;INTERRUPCION ALERTA PASE DE LIMITES

ORG 0x0018

GOTO INT_M ;INTERRUPCION INTERFAZ (SETEO DE LIMITES)



;TABLA CONTIENE DECODIFICACION 7 SEGMENTSOS

TABLE

  DT 0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7C,0x07,0x7F,0x6F,0x40



;ASIGNACION TABLA

M:

    MOVLW UPPER TABLE

    MOVWF TBLPTRU

    MOVLW HIGH TABLE

    MOVWF TBLPTRH

    MOVLW LOW TABLE

    MOVWF TBLPTRL

    LFSR 0,SEG7

    TBLRD*

    GOTO INIT



; TABLA A VECTORES

INIT:

    MOVFF TABLAT,INDF0

    TBLRD+*

    TBLRD+*

    MOVF POSTINC0,W

    ADDLW 0x00

    BNZ INIT

    BRA MAIN



MAIN:



    MOVLW d'100'

    MOVWF LIMIT_U ;LIMITE SUPERIOR

    MOVLW d'20'

    MOVWF LIMIT_L ;LIMITE INFERIOR



    MOVLW b'11100000' ;GLOBAL INTERRUPTION, PERIPHERICAL INTERRUPTION, TIMER0 OVERFLOW ENABLE

    MOVWF INTCON

    MOVLW b'00011000' ;RB1 AND RB2 INTERRUPTION ENABLE ON LOW PRIORITY

    MOVWF INTCON3

    MOVLW b'00110100' ;EXTERNAL INTERUPTION SETTING IN RISING EDGE, TIMER0 HIGH PRIORITY

    MOVWF INTCON2

    MOVLW b'11000110' ; TIMER0 ENABLE, CONFIGURED 8 BIT, INCREMENT HIGH TO LOW TRANSITION, PREESCALAR NOT ASIGN

    MOVWF T0CON

    BSF RCON,7 ; ACTIVATE OR DESACTIVE LOW - HIGH INTERRUPTION



    CLRF A_DC ; ADC CONVERTED VALUE

    CLRF PLUS

    CLRF RA

    CLRF RDD

    CLRF VALUE

    CLRF COUNTER ;DELAY COUNTER

    CLRF LIMIT ;LIMITES



    MOVLW b'00101111' ;LEFT JUSTIFIED, 12TAD, INTERNAL FRECUENCY ADC CONVERTER 600KHZ

    MOVWF ADCON2

   MOVLW b'00000000'  ;ADC REF = Vdd,Vss

    MOVWF ADCON1

    MOVLW 0x7F

    MOVWF TRISB

    CLRF PORTB

    BSF ANSELB,0 ;RB0 AS ANALOG INPUT

    CLRF TRISC

    CLRF PORTC

    CLRF TRISD

    CLRF PORTD

    CLRF TRISA

    MOVLW 0x01

    MOVWF PORTA

    MOVWF RA

    MOVLW b'00110001' ; CHANNEL 6 RB0 SETTED AS ANALOG INPUT, ADC ENABLE BIT

    MOVWF ADCON0

    GOTO MAIN2



; MAIN PRINCIPAL

MAIN2:

    CALL CONVER

    CALL FUN

    BTFSC LIMIT,0

    BRA INTERFAZ

    BRA MENU_P



;MAIN NORMAL

MENU_P:

    CALL FIX

    CALL SEP

    CALL SLIDE

    CALL DELAY

    CALL DECODER

    CALL DELAY

    GOTO MAIN2



; MAIN PARA EL SETEO DE LIMITES

INTERFAZ:

    CALL S_LIMIT

    CALL OP

    CALL FIX

    CALL SEP

    CALL SLIDE

    CALL DELAY

    CALL DECODER

    CALL DELAY

    GOTO MAIN2



; CONVERSION ANALOGO A DIGITAL 0 A 255 POTENCIOMETRO

CONVER:

    BSF ADCON0,GO

    GOTO ADC_LOOP

ADC_LOOP:

    BTFSC ADCON0,GO

    GOTO ADC_LOOP

    MOVFF ADRESH,A_DC ;VALORES DE 0 A 255

    RETURN



; FUNCION Y = 0.5X-20, PARA LLEVAR VALORES DE 0 A 100

FUN:

    MOVFF A_DC,PLUS

    BCF STATUS,C

    RRCF PLUS,F ;DIVISION ENTRE 2

    MOVLW d'20'

    SUBWF PLUS,F ;RESTA 20

    BTFSS STATUS,C

    CLRF PLUS

    CLRF CENT

    CLRF UNIT

    CLRF DECT

    MOVFF PLUS,VALUE

    MOVFF PLUS,PORTC

    RETURN



; FUNCION PARA SEPARAR VALORES EN UNIDADES Y DECIMAS

SEP:

    MOVFF PLUS,UNIT

    MOVLW 0x09

    CPFSGT PLUS

    RETURN

    MOVLW 0x0A

    SUBWF PLUS,F

    INCF DECT,F

    GOTO SEP



; FUNCION REALIZA BARRIDO

SLIDE:

    CLRF PORTD

    MOVLW 0x01

    SUBWF RA,W

    BZ DIS_1

    MOVLW 0x02

    SUBWF RA,W

    BZ DIS_2

    MOVLW 0x04

    SUBWF RA,W

    BZ DIS_3

    RETURN



; ENCENDIDO ANODO 1ER 7 SEGMENTO

DIS_1:

    RLNCF RA,F

    MOVFF RA,PORTA

    MOVFF DECT,RDD ;DISPLAY PARA LA DECIMA

    RETURN

; ENCENDIDO ANODO 2DO 7 SEGMENTO

DIS_2:

    MOVLW 0x04

    MOVWF RA

    MOVFF RA,PORTA

    MOVFF CENT,RDD ;DISPLAY PARA LA CENTESIMA

    RETURN

; ENCENDIDO ANODO 3ER 7 SEGMENTO

DIS_3:

    MOVLW 0x01

    MOVWF RA

    MOVFF RA,PORTA

    MOVFF UNIT,RDD ;DISPLAY PARA LAS UNIDADES

    RETURN



; FUNCION DECODIFICADOR 7 SEGMENTO CON VECTORES

DECODER:

    LFSR 0,SEG7

    MOVF RDD,W

    MOVFF PLUSW0,PORTD

    RETURN

;RETRASO

DELAY:

    INCF COUNTER,F

    MOVLW d'20'

    SUBWF COUNTER,W

    BNZ DELAY

    CLRF COUNTER

; FUNCION PARA LLEVAR LOS VALORES DE 0 - 100 A LOS LIMITES -50 A 50

FIX:

    MOVLW d'50'

    SUBWF PLUS,F

    BNC NEGG

    MOVLW d'11'

    MOVWF CENT

    RETURN

NEGG:

    NEGF PLUS

    MOVLW d'10'

    MOVWF CENT

    RETURN

; INTERRUPCION CHEQUEO DE LIMITES (HIGH PRIORITY)

INT_H:

    BCF INTCON,2

    MOVF LIMIT_U,W

    SUBWF VALUE,W

    BC UPPE ;COMPARACION RANGO LIMITE SUPERIOR

    MOVF LIMIT_L,W

    SUBWF VALUE,W

    BNC LOWW ;COMPARACION RANGO LIMITE INFERIOR

    BCF PORTA,7

    BCF PORTA,6

    RETFIE

; FUNCION PASE DE LIMITE SUPERIOR

UPPE:

    BTG PORTA,7

    RETFIE



; FUNCION PASE DE LIMITE INFERIOR

LOWW:

    BTG PORTA,6

    RETFIE



; INTERRUPCION INTERFAZ PARA SETEAR LIMITES

INT_M:

    BTFSC INTCON3,INT1IF

    BRA CONF ;SI RB1 SE PRESIONO ENTRA A LA INTERFAZ, PARA VER O SETEAR LIMITES

    BTFSC INTCON3,INT2IF

    BRA OUT ;SI RB2 SE PRESIONO SAL DE LA INTERFAZ

    RETFIE



; FUNCION ALERTA ENTRADO EN LA INTERFAZ

CONF:

    BSF PORTB,7 ;LED PARA MOSTRAR USUARIO DENTRO DE LA INTERFAZ

    BSF LIMIT,0

    BCF INTCON3,INT1IF

    RETFIE



; FUNCION ALERTA FUERA DE LA INTERFAZ

OUT:

    BCF PORTB,7 ;LED PARA MOSTRAR USUARIO FUERA DE LA INTERFAZ

    BCF LIMIT,0

    BCF INTCON3,INT2IF

    RETFIE



; FUNCION CHEQUEO DE LIMITES

S_LIMIT:

    BTFSC PORTB,4 ;SI SE PRESIONO RB4 MOSTRAR LIMITE SUPERIOR

    BRA LIMIT_SUP

    BTFSC PORTB,3 ;SI SE PRESIONO RB3 MOSTRAR LIMITE INFERIOR

    BRA LIMIT_INF

    BTFSC LIMIT,1 ;MOSTRAR LIMITE SUPERIOR POR DEFAULT AL ENTRAR LA INTERFAZ

    BRA LIMIT_INF

    BRA LIMIT_SUP



; FUNCION VE LIMITE SUPERIOR

LIMIT_SUP:

    MOVFF LIMIT_U,PLUS ;MOSTRAR LIMITE SUPERIOR 7SEG

    BCF LIMIT,1

    RETURN



; FUNCION VE LIMITE INFERIOR

LIMIT_INF:

    MOVFF LIMIT_L,PLUS ;MOSTRAR LIMITE INFERIOR 7SEG

    BSF LIMIT,1

    RETURN



; FUNCION PARA DECREMENTAR O INCREMENTAR LIMITES

OP:

    BTFSC PORTB,5 ;SI SE PRESIONO RB5 DECREMENTAR

    BRA RESTA

    BTFSC PORTB,6 ;SI SE PRESIONO RB6 INCREMENTAR

    BRA SUMA

    BCF LIMIT,2

    RETURN

; FUNCION PARA INCREMENTAR LIMITES

SUMA:

    BTFSC LIMIT,2

    RETURN

    BSF LIMIT,2

    BTFSS LIMIT,1

    INCF LIMIT_U,F

    INCF LIMIT_L,F



    ;CHEQUEO LIMITES NO PASEN DE 50 AL SUMAR



    MOVLW d'100'

    CPFSLT LIMIT_U

    MOVWF LIMIT_U

    MOVLW d'49'

    CPFSLT LIMIT_L

    MOVLW LIMIT_L

    RETURN



; FUNCION PARA DECREMENTAR LIMITES

RESTA:

    BTFSC LIMIT,2

    RETURN

    BSF LIMIT,2

    BTFSS LIMIT,1

    DECF LIMIT_U,F



    ;CHEQUEO LIMITE NO PASE DE -50 AL RESTAR



    MOVLW 0x00

    CPFSEQ LIMIT_L

    DECF LIMIT_L,F

    MOVLW d'51'

    CPFSGT LIMIT_U

    MOVWF LIMIT_U

    RETURN
    END
