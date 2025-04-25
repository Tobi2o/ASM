@     ___   _____ __  ______   ____ ___  ___ 
@    /   | / ___//  |/  /__ \ / __ \__ \|__ \
@   / /| | \__ \/ /|_/ /__/ // / / /_/ /__/ /
@  / ___ |___/ / /  / // __// /_/ / __// __/ 
@ /_/  |_/____/_/  /_//____/\____/____/____/ 
@
@ Author : Ouweis Harun

@@ @brief uint32_t sum_asm(uint32_t n, ...)
@@ Computes the sum of ... (uint32_t), 0 if empty
@@ @param n (r0) the number of elements in ...
@@ @param ... variable number of uint32_t elements
@@ @return sum of ... or 0 if empty
.global sum_asm
sum_asm:
        @@@@@@@@@@@ A completer @@@@@@@@@@
        @ L'espace vide vous donne une idée de la taille de la solution
               
        push {r1-r3}		    @ On stocke r1-r3 sur la pile pour itérer sur tous les arguments d'un coup
        push {fp, lr}		    @ Réalisation de l'épilogue classique avec fp et lr
        add fp, sp, #4
        add sp, sp, #8

        mov r1, #0	            @ Stocke la valeur de l'addition finale

        loop:
            cmp r0, #0              @ Vérifie si l'on a itéré à travers tous les éléments
            bne continue            @ Si n != 0, continue l'addition
            b end                   @ Sinon, termine la boucle

        continue:
            pop {r2}                @ Récupère dans la pile la valeur à additionner
            add r1, r1, r2          @ Additionne la valeur
            subs r0, r0, #1         @ Soustrait le compteur d'arguments d'une unité
            b loop                  @ Boucle vers le début

        end:
            mov r0, r1              @ Valeur de retour

        sub sp, fp, #4
        pop {fp, pc}

        @@@@@@@@@@@ ----------- @@@@@@@@@@
