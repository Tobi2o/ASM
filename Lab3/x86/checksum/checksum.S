# Author : Harun Ouweis

.global parity_word
.global check_parity

# int parity_word(int value)
# input value in eax
# output in eax
parity_word:
        pushl %ebp                      # Save old stack frame
        movl  %esp, %ebp                # Set new stack base
        movl 8(%ebp), %eax              # copy the argument in eax
        pushl %ebx

        ########## A completer ##########

        movl %eax, %ebx         # Utiliser %ebx pour travailler

        shrl $8, %ebx           # Mettre Byte1 dans la position de Byte0

        movw %bx, %cx           # Utiliser %cx pour travailler séparément

        shrl $16, %ebx          # Mettre Byte2 dans la position de Byte0
        xorb %cl, %bl           # XOR entre le Byte0 original et Byte1 (maintenant dans cl)
        xorb %ch, %bl           # XOR entre le résultat précédent et Byte2 (maintenant dans ch)

        movb %bl, %al           # Déplacer le résultat du checksum (bl) dans la partie (al)


        popl %ebx
        leave                           # Restore stack frame
        ret                             # Return to caller

# int check_word(int value)
# input value in eax
# output in eax
check_parity:
        pushl %ebp                      # Save old stack frame
        movl  %esp, %ebp                # Set new stack base
        movl 8(%ebp), %eax              # copy the argument in eax
        pushl %ebx

        ########## A completer ##########

        movl %eax, %ebx         # Utiliser %ebx pour valeur de travail

        shrl $8, %ebx           # Mettre Byte1 dans la position de Byte0

        movw %bx, %cx           # Utiliser %cx pour travailler séparément

        shrl $16, %ebx          # Mettre Byte2 dans la position de Byte0

        xorb %cl, %bl           # XOR entre le Byte0 original et Byte1 (maintenant dans cl)
        xorb %ch, %bl           # XOR entre le résultat précédent et Byte2 (maintenant dans ch)

        movl %eax, %edx         # Copier la valeur initiale (les trois octets et le checksum) dans edx

        movb %bl, %dl           # Utiliser %edx pour travailler séparément

        subl %edx, %eax         # Soustraire edx de eax, soustrayant le checksum calculé de la valeur originale


        popl %ebx
        leave                           # Restore stack frame
        ret                             # Return to caller
