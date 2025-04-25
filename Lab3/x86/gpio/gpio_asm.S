# Author : Harun Ouweis

.global asm_config_register

# int asm_config_register(int gpio_reg)
# input gpio_reg in eax
# output in eax
asm_config_register:
        pushl %ebp                # Save old stack frame
        movl  %esp, %ebp          # Set new stack base
        movl  8(%ebp), %eax       # copy the argument in eax
        pushl %ebx

        ########## A completer ##########
        # Pour cette partie, j'ai pris le libre choix d'utiliser mon cerveau afin de raccourcir certaines étapes.

        # Effacer le bit 0
        andl $~1, %ebx

        # Mettre les bits 4,5,6, et 7 à 1
        orl   $0xF0, %ebx

        # Effacer upper byte
        andl $0x00FFFFFF, %ebx

        # Set upper byte
        orl   $0x66000000, %ebx

        # Diviser par 8
        shrl $3, %ebx

        # Opération composite
        orl   $0xA5, %ebx        # OR logique avec 0xA5
        andl  $0x7FF76E8, %ebx   # AND logique avec 0xFFEEDD << 3 qui vaut 0x7FF76E8

        movl %ebx, %eax





exit:
        popl  %ebx
        leave                     # Restore stack frame
        ret                       # Return to caller
