        # Authors : Ouweis Harun
        # File    : asm_filter.S
        # Date    :
        # AT&T Syntax

#include "image_processing.h"

.globl asm_filter
.type asm_filter, @function
.extern edge_detection_3x3

.macro check_edges pos min max
        movl \pos, %eax                # Charger la position dans eax
        cmpl \min, %eax                # Vérifier si pos est égal à min
        je 1f                          # Sauter à 1 si pos est égal à min
        cmpl \max, %eax                # Vérifier si pos est égal à max
        je 1f                          # Sauter à 1 si pos est égal à max
        jmp 2f                         # Sinon, sauter à 2
1:      movl $1, %eax                  # Si on est sur le bord, mettre 1 dans eax
        jmp 3f
2:      movl $0, %eax                  # Sinon, mettre 0 dans eax
3:
.endm

.macro calc_offset reg
        movl  (y), \reg                # Charger la position y du pixel
        imull (width), \reg            # Multiplier y par la largeur de l'image
        addl  (x), \reg                # Ajouter la position x du pixel
.endm



.text
        # Function arguments :
        # ebp + 8  : address of source image data (pointer to unsigned 8 bits)
        # ebp + 12 : address of destination image data (already allocated)
        # ebp + 16 : width of the image (signed 32 bits)
        # ebp + 20 : height of the image (signed 32 bits)
        # ebp + 24 : x position of pixel (signed 32 bits)
        # ebp + 28 : y position of pixel (signed 32 bits)

asm_filter:
        pushl %ebp                      # Save old stack frame
        movl  %esp, %ebp                # Set new stack base
        pushl %esi                      # Save registers
        pushl %edi                      # Save registers
        pushl %ebx                      # Save registers

        # Copy of the arguments for easier access
        movl 8(%ebp),   %esi            # esi is for source
        movl 12(%ebp),  %edi            # edi is for destination

        movl 16(%ebp),  %eax
        movl %eax,      (width)         # width holds the width parameter
        movl 20(%ebp),  %eax
        movl %eax,      (height)        # height holds the height parameter
        movl 24(%ebp),  %eax
        movl %eax,      (x)             # x holds the x position
        movl 28(%ebp),  %eax
        movl %eax,      (y)             # y holds the y position

check_if_on_border:

        # TODO : Check if the current pixel is on the border of the image
        # when on border jump to copy_pixel else continue

        # Vérifier si le pixel actuel est sur la bordure de l'image à l'aide de la macro check_edges
        movl (x), %ecx
        movl (width), %ebx
        decl %ebx
        movl $0, %edx
        check_edges %ecx, %edx, %ebx
        cmpl $1, %eax
        je copy_pixel

        movl (y), %ecx
        movl (height), %ebx
        decl %ebx
        check_edges %ecx, %edx, %ebx
        cmpl $1, %eax
        je copy_pixel

conv_filter:

        # TODO : Implement the convolution filter

        calc_offset %ebx                # Calculer l'offset du pixel
        movl %esi, %ecx                 # Adresse de base de l'image dans ecx
        addl %ebx, %ecx                 # Se déplacer vers le pixel à la position (x,y)
        incl  %ecx                      # Déplacer le pointeur vers le pixel en bas à droite du pixel actuel
        addl (width), %ecx

        movl $edge_detection_3x3, %eax  # Adresse du noyau de détection de contours

        movl $0, %edx                   # Initialiser le registre qui stocke le résultat
        movl $0, (row_counter)         # Initialiser l'itérateur de ligne
        movl $0, (pixel_counter)      # Initialiser l'itérateur d'élément



row_loop:
        movl $0, (pixel_counter)        # Réinitialiser le compteur de pixels

pixel_loop:
        movl %edx, (temp_accumulator)   # Sauvegarder la valeur de l'accumulateur
        movsbl (%eax), %ebx             # Charger le byte courant du noyau avec signe étendu
        movzbl (%ecx), %edx             # Charger le byte courant de l'image avec extension zéro
        imull %edx, %ebx                # Multiplier les deux valeurs
        movl (temp_accumulator), %edx   # Restaurer la valeur temporaire de l'accumulateur
        addl %ebx, %edx                 # Ajouter la multiplication courante à l'accumulateur
        incl %eax                       # Aller à la valeur suivante dans le noyau
        decl %ecx                       # Aller à la valeur suivante dans l'image
        incl (pixel_counter)            # Incrémenter le compteur de pixels

        cmpl $MATRIX_SIZE, (pixel_counter) # Vérifier si la fin de la ligne est atteinte
        jne pixel_loop                  # Si non, refaire une itération de pixel

        incl (row_counter)              # Incrémenter le compteur de lignes
        addl $MATRIX_SIZE, %ecx         # Ajuster le pointeur à la fin de la ligne suivante
        subl (width), %ecx

        cmpl $MATRIX_SIZE, (row_counter) # Vérifier si toutes les lignes ont été parcourues
        jne row_loop                    # Si non, recommencer une boucle de ligne


check_negative:
        testl %edx, %edx                # Vérifier si la valeur est négative
        jns check_maximum               # Si non, sauter à la vérification max
        negl %edx                       # Si oui, prendre la valeur absolue

check_maximum:
        cmpl $MAX_PIXEL_VALUE, %edx     # Vérifier si la valeur est supérieure au maximum
        jle end_check                   # Si non, sauter à la fin
        movl $MAX_PIXEL_VALUE, %edx     # Si oui, fixer la valeur au maximum

end_check:
        movl %edx, (res)                # Copier le résultat dans res

        calc_offset %ecx                # Calculer l'offset pour la position (x,y)
        movl %edi, %ebx
        addl %ecx, %ebx
        movb %dl, (%ebx)                # Placer le résultat dans l'image destination

exit:
        popl %ebx                       # Restore registers
        popl %edi       	        # Restore registers
	popl %esi                       # Restore registers
	leave                           # Restore stack frame
	ret                             # Return to caller

copy_pixel:

	# TODO : Copy pixel from source to destination image


        calc_offset %ecx                      # Calculer l'offset pour la position (x,y)

        # Charger l'adresse source et l'adresse destination en ajoutant l'offset
        lea (%esi, %ecx), %eax                # Charger l'adresse du pixel source
        lea (%edi, %ecx), %ebx                # Charger l'adresse du pixel destination

        # Copier la valeur du pixel source à la destination
        movzbl (%eax), %ecx                   # Charger le byte du pixel source avec extension zéro
        movb %cl, (%ebx)                      # Stocker le byte du pixel source dans la destination

        jmp exit                        # exit

.bss
        # Block Started by Symbol Section
        # space is 4 bytes because the values are 32 bit

width:                                  # image width
        .space 4
height:                                 # image height
        .space 4
x:                                      # x position of pixel
        .space 4
y:                                      # y position of pixel
        .space 4
res:                                    # result of convolution
        .space 4
row_counter:       .space 4          # compteur de boucle pour chaque ligne
pixel_counter:    .space 4          # compteur de boucle pour chaque pixel d'une ligne
temp_accumulator:   .space 4          # stockage temporaire de l'accumulateur

.data
        .equiv MATRIX_SIZE, 3                 # Taille d'un côté de la matrice
        .equiv MAX_PIXEL_VALUE, 255           # Valeur maximale pour un pixel