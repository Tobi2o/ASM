#include <common.h>
#include <exports.h>

uint32_t leading_zero_count_c(const uint32_t value) {
        if (value == 0) return 32;

    unsigned int count = 0;
    unsigned int mask = 0x80000000; // Start with the highest bit set.
    while ((value & mask) == 0) {
        count++;
        mask >>= 1;
    }
    return count;
}

uint32_t leading_zero_count(const uint32_t value) {
    uint32_t result = 0;

    // A vous de jouer !
    __asm__ ("lzcnt %1, %0"
	     : "=r" (result)
	     : "r" (value)
	     : "cc" 
    );

    return result;
}

int main(int argc, char *argv[]) {
    uint32_t input = 0x00000087;
    uint32_t expected_result = 24;

    uint32_t leading_zero_count_c_result = leading_zero_count_c(input);
    uint32_t leading_zero_count_result = leading_zero_count(input);

    if (leading_zero_count_c_result != expected_result) {
        printf("[C] [KO] Expected result is %d but %d was returned\n", expected_result, leading_zero_count_c_result);
    } else {
      printf("[C] [OK] Result %d is Correct !\n", leading_zero_count_c_result);
    }

    if (leading_zero_count_result != expected_result) {
        printf("[ASM] [KO] Expected result is %d but %d was returned\n", expected_result, leading_zero_count_result);
    } else {
      printf("[ASM] [OK] Result %d is Correct !\n", leading_zero_count_result);
    }

    printf("Built-in result is %d\n", __builtin_ia32_lzcnt_u32(input));

    printf("Hit any key to exit ... ");
    while (!tstc());

    /* consume input */
    (void) getc();

    printf("\n\n");
    return 0;
}
