#     ___   _____ __  ______   ____ ___  ___ 
#    /   | / ___//  |/  /__ \ / __ \__ \|__ \
#   / /| | \__ \/ /|_/ /__/ // / / /_/ /__/ /
#  / ___ |___/ / /  / // __// /_/ / __// __/ 
# /_/  |_/____/_/  /_//____/\____/____/____/ 
#
# Author : Ouweis Harun

.text

## @brief uint32_t fib_asm(uint32_t n)
## Computes the nth Fibonacci number recursively
## Fib(0) = 0, Fib(1) = 1, Fib(n) = Fib(n-1) + Fib(n-2) for n > 1
## @param n the nth number we want as a result
## @return the nth Fibonacci number 0, 1, 1, 2, 3, 5, 8 etc...
.global silly_fib_asm
.type fib_asm, @function
silly_fib_asm:
#   @@@@@@@@@@@ A completer @@@@@@@@@@

    push %ebp             # Sauvegarde de l'ancienne base de la pile
    mov %esp, %ebp        # Établit la nouvelle base de la pile
    sub $4, %esp          # Réserve de l'espace pour une variable locale

    mov 8(%ebp), %eax     # Charge n dans eax

    cmp $2, %eax          # Compare n avec 2
    jb less_than_2          # Si n < 2, saute à less_than_2

    dec %eax              # Décrémente eax (équivalent de subl $1, %eax)
    push %eax             # Sauvegarde eax sur la pile
    call silly_fib_asm    # Appelle récursivement silly_fib_asm avec n-1
    add $4, %esp          # Restaure la pile
    mov %eax, -4(%ebp)    # Stocke le résultat intermédiaire

    mov 8(%ebp), %eax     # Charge n dans eax
    sub $2, %eax          # Calcule n-2
    push %eax             # Sauvegarde eax sur la pile
    call silly_fib_asm    # Appelle récursivement silly_fib_asm avec n-2
    add $4, %esp          # Restaure la pile

    add -4(%ebp), %eax    # Ajoute le résultat intermédiaire à eax

    jmp end               # Saute à la fin

less_than_2:
    mov 8(%ebp), %eax     # Charge n dans eax

end:
    mov %ebp, %esp        # Restaure la pile
    pop %ebp              # Restaure l'ancienne base de la pile
    ret                   # Retourne à l'appelant
#   @@@@@@@@@@@ ----------- @@@@@@@@@@

## @brief uint32_t fib_asm(uint32_t n, uint32_t a = 0, uint32_t b = 1)
## Computes the nth Fibonacci number recursively
## Fib(0) = 0, Fib(1) = 1, Fib(n) = Fib(n-1) + Fib(n-2) for n > 1
## @param n the nth number we want as a result
## @param a,b used for recursion
## @return the nth Fibonacci number 0, 1, 1, 2, 3, 5, 8 etc...
.global fib_asm
.type fib_asm, @function
fib_asm:
#   @@@@@@@@@@@ A completer @@@@@@@@@@

    push %ebp             # Sauvegarde de l'ancienne base de la pile
    mov %esp, %ebp        # Établit la nouvelle base de la pile
    sub $12, %esp         # Réserve de l'espace pour des variables locales

    mov 8(%ebp), %eax     # Copie du 1er argument dans eax
    mov %eax, -4(%ebp)

    mov 12(%ebp), %eax    # Copie du 2e argument dans eax
    mov %eax, -8(%ebp)

    mov 16(%ebp), %eax    # Copie du 3e argument dans eax
    mov %eax, -12(%ebp)

    mov -4(%ebp), %eax    # Charge n dans eax
    cmp $0, %eax          # Vérifie si n est égal à 0
    jne if_one
    mov -8(%ebp), %eax    # Si n == 0, retourne a
    jmp end_fib

if_one:          # Vérifie si n est égal à 1, sinon fait la récursion
    cmp $1, -4(%ebp)
    jne recurse
    mov -12(%ebp), %eax   # Si n == 1, retourne b
    jmp end_fib

recurse:
    mov -8(%ebp), %eax    # Charge a dans eax
    add -12(%ebp), %eax   # Additionne a + b
    push %eax             # Empile le résultat

    mov -12(%ebp), %eax   # Charge b dans eax
    push %eax             # Empile b

    mov -4(%ebp), %eax    # Charge n dans eax
    sub $1, %eax          # Décrémente n de 1
    push %eax             # Empile n-1

    call fib_asm          # Appel récursif de fib_asm
    add $12, %esp         # Remet en état la pile

end_fib:
    mov %ebp, %esp        # Restaure la pile
    pop %ebp              # Restaure l'ancienne base de la pile
    ret                   # Retourne à l'appelant
#   @@@@@@@@@@@ ----------- @@@@@@@@@@

## @brief uint32_t fib_asm(uint32_t n, uint32_t a = 0, uint32_t b = 1)
## Computes the nth Fibonacci number recursively
## Fib(0) = 0, Fib(1) = 1, Fib(n) = Fib(n-1) + Fib(n-2) for n > 1
## @param n the nth number we want as a result
## @param a,b used for recursion
## @return the nth Fibonacci number 0, 1, 1, 2, 3, 5, 8 etc...
.global fib_asm_tail
.type fib_asm_tail, @function
fib_asm_tail:
#   @@@@@@@@@@@ A completer @@@@@@@@@@

    pushl %ebp
    movl %esp, %ebp
    subl  $16, %esp

    movl  8(%ebp), %eax			# Copie du 1st argument en var locale
    movl  %eax, -4(%ebp)

    movl  12(%ebp), %eax		# Copie du 2nd argument en var locale
    movl  %eax, -8(%ebp)

    movl  16(%ebp), %eax		# Copie du 3rd argument en var locale
    movl  %eax, -12(%ebp)

	cmpl $0, -4(%ebp)			# Vérifie si n est égal à 0 si ce n'est pas le cas on fait le check de 1. Sinon on retourne a
    jne if_one_tail
    movl -8(%ebp), %eax
    jmp end_tail

if_one_tail:				# Vérifie si n est égal à 1 si ce n'est pas le cas on fait la recursion. Sinon on retourne  b
	cmpl $1, -4(%ebp)
    jne loop_tail
    movl -12(%ebp), %eax
    jmp end_tail

loop_tail:

    cmpl  $0, -4(%ebp)		# Condition d'arrêt de la boucle lorsque n est égal à 0
    je    end_tail

    movl  -12(%ebp), %eax	# Additionne a et b et le stocke temporairement
    addl  -8(%ebp), %eax
    movl  %eax, -16(%ebp)

    movl  -12(%ebp), %eax	# On met b à l'emplacement de a
    movl  %eax, -8(%ebp)

    movl  -16(%ebp), %eax	# On met l'addition précédente dans la place de b
    movl  %eax, -12(%ebp)

    decl  -4(%ebp)			# On décrémente n
    movl  -8(%ebp), %eax	# On stocke dans le registre de retour la valeur de temporaire/finale
    jmp   loop_tail

end_tail:
    mov %ebp, %esp        # Restaure la pile
    pop %ebp              # Restaure l'ancienne base de la pile
    ret                   # Retourne à l'appelant
#   @@@@@@@@@@@ ----------- @@@@@@@@@@
