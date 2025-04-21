@ ASM
@ Author :

@@ @brief void show_backtrace() prints the backtrace up to main()
.global show_backtrace
show_backtrace:
        stmfd sp!, {fp, lr}
        add fp, sp, #4

        @@@@@@@@@@@ A completer @@@@@@@@@@

        ldr r0, =backtrace_string
        bl printf

	mov r2, fp                     @ Initialiser r2 avec la valeur de fp (frame pointer)

backtrace_loop:
        ldr r0, =format_string         @ Charger l'adresse de la chaîne de format dans r0
        ldr r1, [r2]                   @ Charger l'adresse de retour (lr) sauvegardée à partir de r2
        cmp r1, #-1                    @ Comparer l'adresse de retour avec -1 (fin de la pile)
        beq backtrace_end              @ Si égal, sauter à backtrace_end pour terminer la boucle

        push {r2}                      @ Sauvegarder r2 pour protéger son contenu pendant printf
        bl printf                      @ Appeler printf pour afficher l'adresse de retour
        pop {r2}                       @ Restaurer r2 après l'appel à printf

        ldr r2, [r2, #-4]              @ Charger la valeur précédente de fp (frame pointer) à partir de r2
        b backtrace_loop               @ Retourner au début de la boucle pour continuer le parcours

backtrace_end:

	@@@@@@@@@@@ ----------- @@@@@@@@@@
        sub sp, fp, #4
        ldmfd sp!, {fp, pc}

.data

backtrace_string:
        .string "\nBacktrace :\n----\n"

format_string:
        .string "Previous link register : 0x%p\n"