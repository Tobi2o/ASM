@ ASM
@ Author : Harun Ouweis

@@ @brief uint32_t discrete_distance_asm(const uint32_t a, const uint32_t b)
@@ Computes the discrete distance between a and b
@@ @param a (r0)
@@ @param b (r1)
@@ @return distance in r0
.global discrete_distance_asm
discrete_distance_asm:
	mov   r12, sp
        stmfd sp!, {r4-r12, lr}

        @@@@@@@@@@@ A completer @@@@@@@@@@

        @ Calcul de la distance discrète
        cmp r0, r1                @ Compare a et b
        moveq r0, #0              @ Si égaux, met 0 dans r0
        movne r0, #1              @ Si différents, met 1 dans r0


	@@@@@@@@@@@ ----------- @@@@@@@@@@

        ldmfd sp!, {r4-r12, lr}
        mov   sp, r12
        mov   pc, lr

@@ @brief uint32_t hamming_distance_asm(const uint32_t a, const uint32_t b)
@@ Computes the Hamming distance between a and b
@@ @param a (r0)
@@ @param b (r1)
@@ @return distance in r0
.global hamming_distance_asm
hamming_distance_asm:
	mov   r12, sp
        stmfd sp!, {r4-r12, lr}

        @@@@@@@@@@@ A completer @@@@@@@@@@

        @ Initialisation du résultat
        mov r4, #0

        @ Récupération des coordonnées Y avec un masque
        mov r2, r0, LSR #16    @ r2 = x1
        mov r3, r1, LSR #16    @ r3 = x2
        mov r5, r0, LSL #16
        mov r5, r5, LSR #16    @ r5 = y1
        mov r6, r1, LSL #16
        mov r6, r6, LSR #16    @ r6 = y2

        @ Comparaison des coordonnées X et ajout de 1 au résultat si différentes
        cmp r2, r3
        addne r4, r4, #1

        @ Comparaison des coordonnées Y et ajout de 1 au résultat si différentes
        cmp r5, r6
        addne r4, r4, #1

        mov r0, r4            @ Stockage du résultat final

	@@@@@@@@@@@ ----------- @@@@@@@@@@

        ldmfd sp!, {r4-r12, lr}
        mov   sp, r12
        mov   pc, lr

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

        @ Extraction des coordonnées Y en utilisant un masque
        movw r2, #0xFFFF
        and r4, r0, r2
        and r5, r1, r2

        @ Calcul de la différence pour les coordonnées Y
        cmp r4, r5
        subge r4, r4, r5
        sublt r4, r5, r4

        @ Décalage à droite de 16 bits pour obtenir les coordonnées X
        mov r2, r0, lsr #16
        mov r3, r1, lsr #16

        @ Calcul de la différence pour les coordonnées X
        cmp r2, r3
        subge r2, r2, r3
        sublt r2, r3, r2

        @ Additionne les différences Y et X pour obtenir la distance de Manhattan
        add r0, r4, r2

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

        @ Extraction des coordonnées X et Y
        mov r2, r0, LSR #16           @ r2 = x1
        mov r4, #0xFFFF
        and r0, r0, r4                @ r0 = y1
        mov r3, r1, LSR #16           @ r3 = x2
        and r1, r1, r4                @ r1 = y2

        @ Différences pour Y
        sub r5, r0, r1                @ r5 = y1 - y2
        mul r5, r5, r5                @ r5 = (y1 - y2)^2

        @ Différences pour X
        sub r0, r2, r3                @ r0 = x1 - x2
        mul r0, r0, r0                @ r0 = (x1 - x2)^2

        @ Somme des carrés
        add r0, r0, r5                @ r0 = (x1 - x2)^2 + (y1 - y2)^2


        @@@@@@@@@@@ ----------- @@@@@@@@@@

        ldmfd sp!, {r4-r12, lr}
        mov   sp, r12
        mov   pc, lr




@@ @brief uint32_t get_directions_asm(const char* map, const uint32_t position)
@@ Returns possible directions given a position on a map
@@ @param pointer on map (r0)
@@ @param position (r1)
@@ @return possible directions
.equiv MAP_SIZE_X, 8
.equiv MAP_SIZE_Y, 10
.equiv EAST_MASK, 0x2
.equiv NORTH_MASK, 0x8
.equiv SOUTH_MASK, 0x4
.equiv WEST_MASK, 0x1
.equiv WALL, 0x57
.global get_directions_asm
get_directions_asm:
	mov   r12, sp
    stmfd sp!, {r4-r12, lr}

        @@@@@@@@@@@ A completer @@@@@@@@@@

	@ Extraction des coordonnées X et Y
        mov r2, r1, LSR #16           @ r2 = x1
        mov r3, r1, LSL #16
        mov r3, r3, LSR #16           @ r3 = y1

        @ Calcul de l'offset pour accéder à la carte
        mov r4, #MAP_SIZE_Y
        mla r5, r4, r2, r3            @ r5 = y1 + (x1 * MAP_SIZE_Y)
        add r5, r5, r0                @ r5 = map[r5]

        @ Initialisation du résultat
        mov r4, #0                    @ r4 stocke les directions

        @ Vérification Nord
        check_north:
        cmp r2, #0                    @ Vérifie si x > 0
        beq check_east                @ Passe à l'Est si au bord supérieur
        sub r6, r5, #MAP_SIZE_Y       @ Passe à la case au nord
        ldrb r6, [r6]                 @ Charge le caractère de la nouvelle case
        cmp r6, #WALL                 @ Vérifie si c'est un mur
        orrne r4, r4, #NORTH_MASK     @ Ajoute la direction Nord si ce n'est pas le cas

        @ Vérification Est
        check_east:
        cmp r3, #(MAP_SIZE_Y - 1)     @ Vérifie si y < MAP_SIZE_Y - 1
        beq check_west
        add r6, r5, #1                @ Passe à la case à l'est
        ldrb r6, [r6]
        cmp r6, #WALL
        orrne r4, r4, #EAST_MASK

        @ Vérification Ouest
        check_west:
        cmp r3, #0                    @ Vérifie si y > 0
        beq check_south
        sub r6, r5, #1                @ Passe à la case à l'ouest
        ldrb r6, [r6]
        cmp r6, #WALL
        orrne r4, r4, #WEST_MASK

        @ Vérification Sud
        check_south:
        cmp r2, #(MAP_SIZE_X - 1)     @ Vérifie si x < MAP_SIZE_X - 1
        beq result
        add r6, r5, #MAP_SIZE_Y       @ Passe à la case au sud
        ldrb r6, [r6]
        cmp r6, #WALL
        orrne r4, r4, #SOUTH_MASK

        result:
        mov r0, r4                    @ Stocke les directions finales dans r0

        @@@@@@@@@@@ ----------- @@@@@@@@@@

        ldmfd sp!, {r4-r12, lr}
        mov   sp, r12
        mov   pc, lr