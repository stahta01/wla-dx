
        .memorymap
          slotsize $8000
          defaultslot 1
          slot 0 $0000
          slot 1 $8000
        .endme

        .lorom

        .rombanksize $8000
        .rombanks 3

        .bank 0 slot 0
        .org 0

        ; @BT result.rom

        .section "Section1" force
        .DB "01>"                       ; @BT TEST-01 01 START
        AND #<$1020                     ; @BT 29 20
        AND <$1020,X                    ; @BT 35 20
        AND #>$1020                     ; @BT 29 10
        AND >$1020,X                    ; @BT 35 10
        AND #($1020 & $FF)              ; @BT 29 20
        AND ($1020 & $FF),X             ; @BT 35 20
        AND #($1020 # $100)             ; @BT 29 20
        AND ($1020 # $100),X            ; @BT 35 20
        .DB "<01"                       ; @BT END
        .ends

        .org $100

        .section "Section2" force
        .DB "02>"                       ; @BT TEST-02 02 START
        AND #<($1020 + 1)               ; @BT 29 21
        AND <($1020 + 1),X              ; @BT 35 21
        AND #>($1020 + 1)               ; @BT 29 10
        AND >($1020 + 1),X              ; @BT 35 10
        AND #(($1020 + 1) & $FF)        ; @BT 29 21
        AND (($1020 + 1) & $FF),X       ; @BT 35 21
        AND #(($1020 + 1) # $100)       ; @BT 29 21
        AND (($1020 + 1) # $100),X      ; @BT 35 21
        .DB "<02"                       ; @BT END
        .ends
        
        .org $200
        
        .section "Section3" force
        .DB "03>"                       ; @BT TEST-03 03 START
        AND #<label_205                 ; @BT 29 05
label_205:
        AND <label_205,X                ; @BT 35 05
        AND #>label_205                 ; @BT 29 02
        AND >label_205,X                ; @BT 35 02
        AND #(label_205 & $FF)          ; @BT 29 05
        AND (label_205 & $FF),X         ; @BT 35 05
        AND #(label_205 # $100)         ; @BT 29 05
        AND (label_205 # $100),X        ; @BT 35 05
        .DB "<03"                       ; @BT END
        .ends
        
label_216:
        .db "04>"                       ; @BT TEST-04 04 START
        .dw label_216, label_205,       ; @BT 16 02 05 02
        .dw label_216+1, label_205+1    ; @BT 17 02 06 02
        .db "<04"                       ; @BT END

        .section "Section4" force
label_224:
        .db "05>"                       ; @BT TEST-05 05 START
        .db 2 ^ 3, 1 | 2, 1 << 1,       ; @BT 08 03 02
        .db 2 >> 1, ~1                  ; @BT 01 FE
        .db "<05"                       ; @BT END
        .ends

        .db "06>"                       ; @BT TEST-06 06 START
        .db (label_216 & 15) ^ 2,       ; @BT 24
        .db (label_216 & 15) | 1,       ; @BT 07
        .db (label_216 & 15) << 1,      ; @BT 0C
        .db (label_216 & 15) >> 1,      ; @BT 03
        .db ~(label_216 & 15)           ; @BT F9
        .db "<06"                       ; @BT END

        .section "extrabits" appendto "Section1"
        .db "07>"                                                       ; @BT TEST-07 07 START
        .db $fe,$ff,$ff,$ff,$ff,$ff,$fe,$ff,$1,$0,$fe,$ff,$2,$0,$ff,$ff ; @BT FE FF FF FF FF FF FE FF 01 00 FE FF 02 00 FF FF
        .db "<07"                                                       ; @BT END
        .ends

        .section "Section5" force
        .define BIG_VALUE $0156
        .define SMALL_VALUE $1
        .db "08>"               ; @BT TEST-08 08 START
        .db 2+-1                ; @BT 01
        .db 2+(-1)              ; @BT 01
        .db >-BIG_VALUE, <-BIG_VALUE ; @BT FE AA
        .db >(-BIG_VALUE), <(-BIG_VALUE) ; @BT FE AA
        .db 2+-SMALL_VALUE           ; @BT 01
        .db 2+(-SMALL_VALUE)         ; @BT 01
        .db 2+-1, 2--1               ; @BT 01 03
        .db 2+(-1), 2-(-1)           ; @BT 01 03
        .db 1--3+-2                  ; @BT 02
        .db SMALL_VALUE--SMALL_VALUE*3+-SMALL_VALUE*2 ; @BT 02
        .db SMALL_VALUE-(-SMALL_VALUE*3)+(-SMALL_VALUE*2) ; @BT 02
        .db "<08"                    ; @BT END
        .ends
        
        .section "Section6" force
        .define VALUE_2 = VALUE_3-1
        .define VALUE_MINUS_2 = -VALUE_3+1
        .define VALUE_MINUS_2B = 0-VALUE_3+1
        .define VALUE_MINUS_2X = -VALUE_2
        .define VALUE_MINUS_2XB = 0-VALUE_2
        .db "09>"                ; @BT TEST-09 09 START
        .db >-VALUE_3, <-VALUE_3 ; @BT FF FD
        .db >(-VALUE_3), <(-VALUE_3) ; @BT FF FD
        .db -VALUE_3--2          ; @BT FF
        .db -VALUE_3*2           ; @BT FA
        .db >-3, <-3             ; @BT FF FD
        .db >(-3), <(-3)         ; @BT FF FD
        .db -VALUE_3-2           ; @BT FB
        .db -3-2                 ; @BT FB
        .db -3--2                ; @BT FF
        .db 6-VALUE_3            ; @BT 03
        .db VALUE_3--VALUE_3*3+-VALUE_3*2 ; @BT 06
        .db VALUE_3-(-VALUE_3*3)+(-VALUE_3*2) ; @BT 06
        .db VALUE_3--3*3+-VALUE_3*2 ; @BT 06
        .db VALUE_3-(-3*3)+(-VALUE_3)*2 ; @BT 06
        .db SMALL_VALUE--VALUE_3        ; @BT 04
        .db VALUE_2--VALUE_2            ; @BT 04
        .db VALUE_2-(-VALUE_2)          ; @BT 04
        .db VALUE_3-(-VALUE_MINUS_2)    ; @BT 01
        .db -VALUE_2+-VALUE_MINUS_2     ; @BT 00
        .db VALUE_3-(-VALUE_MINUS_2B)   ; @BT 01
        .db -VALUE_2+-VALUE_MINUS_2B    ; @BT 00
        .db VALUE_3-(-VALUE_MINUS_2X)   ; @BT 01
        .db -VALUE_2+-VALUE_MINUS_2X    ; @BT 00
        .db VALUE_3-(-VALUE_MINUS_2XB)  ; @BT 01
        .db -VALUE_2+-VALUE_MINUS_2XB   ; @BT 00
        .db "<09"                ; @BT END
        .ends
        
