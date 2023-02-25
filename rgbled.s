        .global project3
        .global gpio_init
        .global read_character
        .global output_character
        .global output_string
        .global read_from_push_btn
        .global illuminate_RGB_LED


ptr_to_prompt:          .word prompt
ptr_to_prompt1:         .word prompt1
ptr_to_prompt2:         .word prompt2
ptr_to_prompt3:         .word prompt3
ptr_to_rgbs:            .word rgbs
ptr_to_quit:            .word quit


project3:
        PUSH {lr, r4-r11}   ; Store lr to stack
        ldr r4, ptr_to_prompt
        ldr r3, ptr_to_prompt1
        ldr r7, ptr_to_prompt2
        ldr r8, ptr_to_prompt3
        ldr r5, ptr_to_rgbs
        ldr r6, ptr_to_quit


        mov r0, r4    ;print out prompt
        BL output_string

REPEAT:
        mov r0, r5
        BL read_character


TURNOFF: ;this is used to turn rgb off before we start over again
        MOV r1, #0xE000 ; Provide clock to GPIO
        MOVT r1, #0x400F
        LDRB r2, [r1, #0x608]
    ORR r2, r2, #0x20
    STRB r2, [r1, #0x608]

    MOV r1, #0x5000                     ;Enable clock to port F
    MOVT r1, #0x4002
    MOV r2, #1
    STRB r2, [r1, #0x608]

    MOV r1, #0x5000     ; set direction as output
    MOVT r1, #0x4002
    LDRB r2, [r1, #0x400]
    ORR r2, r2, #0xE
    STRB r2, [r1, #0x400]

    MOV r1, #0x5000
    MOVT r1, #0x4002
    LDRB r2, [r1, #0x51C]       ;Set pin as digital and enable pins 1- 3
    ORR r2, r2, #0xE
    STRB r2, [r1, #0x51C]

    MOV r1, #0x5000
    MOVT r1, #0x4002
    LDRB r2, [r1, #0x3FC]       ;switch all rgb pins off by anding 0000 before we start our program
    AND r2, r2, #0x0
    STRB r2, [r1, #0x3FC]

        CMP r0, #0x73 ;see if s was pressed
        BEQ SWITCH
        B RED

SWITCH:
        BL read_from_push_btn ;read from sw1
        CMP r0, #1                      ;if 1 then button was pressed
        BEQ Switchp
        CMP r0, #0              ;if 0 button was not pressed
        BEQ Switchn
        MOV r0, #0
        B EXEC1
Switchp:
        MOV r0, r7
        BL output_string                ;output that button was pressed
        MOV r0, #0
        B EXEC1
Switchn:
        MOV r0, r8
        BL output_string                ;output that button wasn't pressed
        MOV r0, #0
        B EXEC1

RED:
        CMP r0, #0x72
        BNE GREEN                       ;if r0 was 'r' then turn red on
        MOV r0, #1
        B EXEC


GREEN:
        CMP r0, #0x67
        BNE BLUE
        MOV r0, #2      ;if r0 was 'g' then turn green on
        B EXEC


BLUE:
        CMP r0 , #0x62
        BNE PURPLE      ;if r0 was 'b' then turn purple on
        MOV r0, #3
        B EXEC

PURPLE:
        CMP r0, #0x70
        BNE YELLOW              ;if r0 was 'p' then turn purple on
        MOV r0, #4
        B EXEC

YELLOW:
        CMP r0, #0x79
        BNE WHITE               ;if r0 was 'y' then turn yellow on
        MOV r0, #5
        B EXEC

WHITE:
        CMP r0, #0x77
        BNE OFF         ;if r0 was 'w' then turn white on
        MOV r0, #6
        B EXEC

OFF:
        CMP r0, #0x6F
        MOV r0, #7              ;if r0 was 'o' then turn lights off
        B EXEC

EXEC:
        BL illuminate_RGB_LED

EXEC1:
        B REPEAT





                ; Your code is placed here.  This is your main routine for
                ; Project #3.  This should call your other routines such as
                ; read_from_push_button and illuminate_RGB_LED.

        POP {lr, r4-r11}          ; Restore lr from stack
        mov pc, lr




        .end
