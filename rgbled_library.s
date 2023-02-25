        .text
        .global read_character
        .global output_character
        .global output_string
        .global gpio_init
        .global read_from_push_btn
        .global illuminate_RGB_LED

U0FR:   .equ 0x18       ; UART0 Flag Register


        ; Add read_character, output_character, and output_string from Project #2

        ; Stubs are included for read_from_push_button and illuminate_RGB_LED
        ; below.

        ; gpio_init is included below.




read_from_push_btn:
        PUSH {lr} ; Store register lr on stack


        MOV r0, #0xE608
        MOVT r0, #0x400F
        LDRB r1, [r0]                   ;Enable clock for gpio port F
        ORR r1, r1, #0x20
        STRB r1, [r0]

        MOV r0, #0x5000
        MOVT r0, #0x4002                ;Set port F pin 4 as input

        LDRB r1, [r0, #0x400]
        AND r1, r1, #0xEF
        STRB r1, [r0, #0x400]

        LDRB r1, [r0, #0x51C]           ;Configure as digital
        ORR r1, r1, #0x10
        STRB r1, [r0, #0x51C]

        LDRB r1, [r0, #0x510]           ;Enable pull up resistor on port F pin 4
        ORR r1, r1, #0x10
        STRB r1, [r0, #0x510]

        LDRB r2, [r0, #0x3FC]   ;Store GPIO data register value into r2 for pin 4
        AND r2, r2, #0x10
        LSR r2, r2, #4
        EOR r2, r2, #1


        ;Disable clock to 0
        AND r1, r1, #0xDF
        STRB r1, [r0]

        MOV r0, r2 ;move r2 to r0


        POP {lr}
        MOV pc, lr


illuminate_RGB_LED:
        PUSH {lr}   ; Store register lr on stack

        MOV r1, #0xE000 ; Provide clock to GPIO
        MOVT r1, #0x400F
        LDRB r2, [r1, #0x608]
    ORR r2, r2, #0x20
    STRB r2, [r1, #0x608]

    MOV r1, #0x5000                             ;Enable clock to port F
    MOVT r1, #0x4002
    MOV r2, #1
    STRB r2, [r1, #0x608]

    MOV r1, #0x5000     ; set GPIOF direction as output
    MOVT r1, #0x4002
    LDRB r2, [r1, #0x400]
    ORR r2, r2, #0x02
    STRB r2, [r1, #0x400]

    MOV r1, #0x5000
    MOVT r1, #0x4002
    LDRB r2, [r1, #0x51C]                       ;Set pin as digital and enable pins 1- 3
    ORR r2, r2, #0x02
    STRB r2, [r1, #0x51C]

        CMP r0, #1     ;see whether the user wanted r,g,b,p,y,w or o
        BEQ Red
        CMP r0, #2
        BEQ Green
        CMP r0, #3
        BEQ Blue
        CMP r0, #4
        BEQ Purple
        CMP r0, #5
        BEQ Yellow
        CMP r0, #6
        BEQ White
        CMP r0, #7
        BEQ OFF
Red:


    MOV r1, #0x5000
    MOVT r1, #0x4002
    LDRB r2, [r1, #0x3FC]       ;for red enable 0010
    ORR r2, r2, #0x02
    STRB r2, [r1, #0x3FC]

    B ENDLOOP

Blue:


    MOV r1, #0x5000
    MOVT r1, #0x4002
    LDRB r2, [r1, #0x3FC]       ;for blue enable 0100
    ORR r2, r2, #0x04
    STRB r2, [r1, #0x3FC]

    B ENDLOOP


Green:


    MOV r1, #0x5000
    MOVT r1, #0x4002
    LDRB r2, [r1, #0x3FC]       ;for green enable 1000
    ORR r2, r2, #0x08
    STRB r2, [r1, #0x3FC]

    B ENDLOOP




Purple:


    MOV r1, #0x5000
    MOVT r1, #0x4002
    LDRB r2, [r1, #0x3FC]       ;for purple enable 0110
    ORR r2, r2, #0x6
    STRB r2, [r1, #0x3FC]

    B ENDLOOP


Yellow:


    MOV r1, #0x5000
    MOVT r1, #0x4002
    LDRB r2, [r1, #0x3FC]       ;for yellow enable 1010
    ORR r2, r2, #0xA
    STRB r2, [r1, #0x3FC]

    B ENDLOOP

White:


    MOV r1, #0x5000
    MOVT r1, #0x4002
    LDRB r2, [r1, #0x3FC]       ;for white enable 1110
    ORR r2, r2, #0xE
    STRB r2, [r1, #0x3FC]

    B ENDLOOP


OFF: ;this is used to turn rgb off before we start over again


    MOV r1, #0x5000
    MOVT r1, #0x4002
    LDRB r2, [r1, #0x3FC]
    AND r2, r2, #0x0            ;in order to turn off and r2 with 0 as in 0000
    STRB r2, [r1, #0x3FC]

    B ENDLOOP


ENDLOOP:

          ; Your code is placed here
                ; Your code for your illuminate_RGB_LED routine is placed here

        POP {lr}
        mov pc, lr



output_string:
        PUSH {lr, r10}   ; Store register lr on stack

        MOV r10, r0  ;move the initial pointer of the string in r0 to r10
INITIAL_LOOP1:
        LDRB r0, [r10]   ;load the byte from r10 to r0
        BL output_character ;call output character
        CMP r0, #0  ;see if it is null
        BNE OUTPUT_LOOP1        ;if not null, go to output_loop
        B END_LOOP1 ;else go to end loop

OUTPUT_LOOP1:
        ADD r10, r10, #1  ;increment pointer address by 1
        B INITIAL_LOOP1 ;branch back to initial loop

END_LOOP1:
                ; Your code for your output_string routine is placed here

        POP {lr, r10}
        mov pc, lr

read_character:
                        PUSH {lr, r4}   ; Store register lr and r4 on stack
                        MOV r2, #0xC000         ; Load address of Flag register
                        MOVT r2, #0x4000

READ_LOOP:
                        LDRB r3, [r2, #U0FR]    ; Read RxFE, wait until it is 0
                        AND r4, r3, #16
                        CMP r4, #0
                        BNE READ_LOOP
                        LDRB r0, [r2]           ; Read byte from Flag register

                        POP {lr, r4} ; Restore registers back for parent function
                        mov pc, lr


output_character:

        PUSH {lr, r4}   ; Store register lr and r4 on stack
        MOV r2, #0xC000 ; Load address of Flag register
        MOVT r2, #0x4000

OUTPUT_LOOP:
                        LDRB r3, [r2, #U0FR]    ; Read TxFF, wait until it is 0
                        AND r4, r3, #32
                        CMP r4, #0
                        BNE OUTPUT_LOOP
                        STRB r0, [r2]   ; Store byte into Flag register

                        POP {lr, r4} ; Restore registers back for parent function
                        mov pc, lr





gpio_init:

        ; Enable Clock for Port F
        mov r0, #0xE000
        movt r0, #0x400F
        ldrb r1, [r0, #0x608]
        orr r1, r1, #0x20
        strb r1, [r0, #0x0608]

        ; Set Direction
        mov r0, #0x5000
        movt r0, #0x4002
        ldrb r1, [r0, #0x400]
        orr r1, r1, #0xE
        bic r1,r1, #0x10
        strb r1, [r0, #0x400]

        ; Enable Digital
        mov r0, #0x5000
        movt r0, #0x4002
        ldrb r1, [r0, #0x51C]
        orr r1, r1, #0x1E
        strb r1, [r0, #0x051C]


        ; Enable Pull-Up Resistor
        mov r0, #0x5000
        movt r0, #0x4002
        ldrb r1, [r0, #0x510]
        orr r1, r1, #0x10
        strb r1, [r0, #0x0510]

        ; Return
        mov pc,lr







        .end
