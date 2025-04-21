# Author : Ouweis Harun

.global traverse_tree_asm

.extern printf

# Macro that will print what is at the end of string_ptr (char *)
# with an extra space at the end (through the format string used).
.macro PUT_S string_ptr
    pushal
    push \string_ptr
    push $format_string
    call printf
    add  $0x8, %esp
    popal
.endm

## @brief void traverse_tree_asm(Node *root);
## Traverses a binary search tree in natural order and prints data if available
##
## @param Node *root the root of the tree to traverse and prints
traverse_tree_asm:
        # Intro
        pushl %ebp                      # Save old stack frame
        movl  %esp, %ebp                # Set new stack base
        pushal                          # Save all registers
        movl  8(%ebp), %eax             # copy the argument in eax
	####### Student code below
	
        # TODO
        #
        # Note : It is a good idea to write the algorithm in pseudo code
        #        on paper before you start, this is not difficult but also
        #        not easy. Prepare a strategy, then finally write the assembly
        #        Have fun !

                # Initialiser la pile et le pointeur
        subl $1024, %esp                # Allouer de l'espace pour la pile
        movl %esp, %ecx                 # ECX sera notre pointeur de pile

        # Initialiser
        movl %eax, %edx                 # EDX sera notre nœud courant

traverse_loop:
        # Parcourir jusqu'au nœud le plus à gauche
        .left_traversal:
        cmpl $0, %edx                   # Vérifier si le nœud courant est NULL
        je .process_node                # Si NULL, traiter le nœud au sommet de la pile
        pushl %edx                      # Pousser le nœud courant sur la pile
        movl 8(%edx), %edx              # Passer à l'enfant gauche
        jmp .left_traversal             # Répéter le parcours à gauche

        # Traiter le nœud
        .process_node:
        cmpl %esp, %ecx                 # Vérifier si la pile est vide
        je .done                        # Si vide, nous avons terminé
        popl %edx                       # Dépiler le nœud de la pile

        # Afficher les données du nœud
        movl 4(%edx), %ebx              # Obtenir le pointeur de données
        PUT_S %ebx                      # Imprimer les données

        # Passer au nœud de droite
        movl 12(%edx), %edx             # Passer à l'enfant droit
        jmp traverse_loop               # Répéter le parcours

        # Fin du parcours
        .done:
        addl $1024, %esp                # Libérer l'espace alloué pour la pile

	





	
	######## End of student code
        # Outro
        popal                           # Restore all register
        leave                           # Restore stack frame
        ret                             # Return to caller

.data
format_string:
    .string "%s "
example_string:
    .string "Hello from ASM !"
