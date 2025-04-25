@ ASM
@ Author : Ouweis Harun

.macro absdiff, reg1, reg2, result
    cmp \reg1, \reg2
    subge \result, \reg1, \reg2 @ Si reg1 >= reg2, result = reg1 - reg2
    sublt \result, \reg2, \reg1 @ Sinon, result = reg2 - reg1
.endm

.macro unpack, input_reg, output_reg_x, output_reg_y
    mov \output_reg_x, \input_reg, lsr #16  @ Décale à droite de 16 bits pour obtenir X
    mov \output_reg_y, \input_reg, lsl #16  @ Décale à gauche de 16 bits pour masquer X
    mov \output_reg_y, \output_reg_y, lsr #16  @ Décale à droite de 16 bits pour obtenir Y
.endm



@@ @brief uint32_t manhattan_distance_asm(const uint32_t a, const uint32_t b)
@@ Computes the Manhattan distance between a and b
@@ @param a (r0)
@@ @param b (r1)
@@ @return distance in r0
.global manhattan_distance_asm
manhattan_distance_asm:
	mov   r12, sp
        stmfd sp!, {r4-r12, lr}

        @@@@@@@@@@@ A completer @@@@@@@@@@

        @ Décompresser les coordonnées
        unpack r0, r2, r4 @ r2 = x1, r4 = y1
        unpack r1, r3, r5 @ r3 = x2, r5 = y2

        @ Calculer les différences absolues
        absdiff r2, r3, r2 @ abs(x1 - x2)
        absdiff r4, r5, r4 @ abs(y1 - y2)

        @ Additionner les différences pour obtenir la distance de Manhattan
        add r0, r2, r4

	@@@@@@@@@@@ ----------- @@@@@@@@@@

        ldmfd sp!, {r4-r12, lr}
        mov   sp, r12
        mov   pc, lr

@@ @brief uint32_t ssd_semi_distance_asm(const uint32_t a, const uint32_t b)
@@ Computes the Sum of Squared Differences semi distance between a and b
@@ @param a (r0)
@@ @param b (r1)
@@ @return distance in r0
.global ssd_semi_distance_asm
ssd_semi_distance_asm:
	mov   r12, sp
        stmfd sp!, {r4-r12, lr}

        @@@@@@@@@@@ A completer @@@@@@@@@@


        @ Décompresser les coordonnées
        unpack r0, r2, r4 @ r2 = x1, r4 = y1
        unpack r1, r3, r5 @ r3 = x2, r5 = y2

        @ Calculer les différences au carré
        sub r6, r2, r3
        mul r6, r6, r6 @ (x1 - x2)^2
        sub r7, r4, r5
        mul r7, r7, r7 @ (y1 - y2)^2

        @ Additionner les carrés des différences
        add r0, r6, r7

	@@@@@@@@@@@ ----------- @@@@@@@@@@

        ldmfd sp!, {r4-r12, lr}
        mov   sp, r12
        mov   pc, lr

