; Autor reseni: Tomas Dolak xdolak09
; Pocet cyklu k serazeni puvodniho retezce:             3732
; Pocet cyklu razeni sestupne serazeneho retezce:       4053
; Pocet cyklu razeni vzestupne serazeneho retezce:      568
; Pocet cyklu razeni retezce s vasim loginem:           823
; Implementovany radici algoritmus: BubbleSort
; ------------------------------------------------

; DATA SEGMENT
                .data

; login:          .asciiz "vitejte-v-inp-2023"    ; puvodni uvitaci retezec
; login:          .asciiz "vvttpnjiiee3220---"    ; sestupne serazeny retezec
; login:          .asciiz "---0223eeiijnpttvv"    ; vzestupne serazeny retezec
login:          .asciiz "xdolak09"                ; SEM DOPLNTE VLASTNI LOGIN
                                                  ; A POUZE S TIMTO ODEVZDEJTE

params_sys5:    .space  8   ; misto pro ulozeni adresy pocatku
                            ; retezce pro vypis pomoci syscall 5
                            ; (viz nize - "funkce" print_string)

; CODE SEGMENT
                .text


main:
        ; SEM DOPLNTE VASE RESENI

        daddi   r4, r0, login           ; vzorovy vypis: adresa login: do r4
        jal     BubbleSort              ; skok na navesti BubbleSort
        jal     print_string            ; vypis pomoci print_string - viz nize
        syscall 0                       ; halt

BubbleSort:
        add     $s0, $zero, $zero       ; $s0 = 0 (inicializace delky)
        add     $s1, $zero, $zero       ; $s1 = 0 (index pro vypocet delky)

; Vypocet delky retezce
CalculateLength:
        lb      $s2, login($s1)         ; nacteni znaku
        beq     $s2, $zero, StartSort   ; pokud je znak 0, konec retezce
        addi    $s0, $s0, 1             ; inkrementace delky
        addi    $s1, $s1, 1             ; inkrementace indexu
        j       CalculateLength         ; jump back to CalculateLength

; Razeni
StartSort:
        addi    $s0, $s0, -1            ; snizeni delky o 1 pro indexaci od nuly
OuterLoop:
        add     $s1, $zero, $zero       ; s1 -> index aktualniho znaku
        add     $s7, $zero, $zero       ; s7 -> flag na Swap
InnerLoop:
        lb      $s2, login($s1)         ; nacteni znaku 
        addi    $s3, $s1, 1             ; s3 -> index nasledujiciho znaku
        lb      $s4, login($s3)         ; nacteni dalsiho znaku
        sub     $s5, $s2, $s4           ; porovnani znaku
        slt     $s6, $zero, $s5         ; test -> rozdil hodnot znaku a nuly
        beq     $s6, $zero, NoSwap      ; pokud (s5 < 0) -> preskocit Swap
        sb      $s4, login($s1)         ; Swap
        sb      $s2, login($s3)
        add     $s7, $s3, $zero         ; Nastaveni flag swapu
NoSwap:
        addi    $s1, $s1, 1             ; inkrementace s1
        sub     $t2, $s0, $s1           ; vypocet zbyvajici delky retezce
        bne     $t2, $zero, InnerLoop   ; pokud neni konec -> jmp to InnerLoop
        beq     $s7, $zero, EndSort     ; pokud nebyl proveden zadny swap -> serazeno
        addi    $s0, $s0, -1            ; dekrementace s0
        j       OuterLoop               ; skok na zacatek OuterLoop
EndSort:
        jr      $ra                     ; navrat do mainu



print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5            ; adr pro syscall 5 musi do r14
                syscall 5                               ; systemova procedura - vypis retezce na terminal
                jr      r31                             ; return - r31 je urcen na return address
