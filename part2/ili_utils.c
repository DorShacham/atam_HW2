#include <asm/desc.h>

void my_store_idt(struct desc_ptr *idtr) {
// <STUDENT FILL>
asm ("sidt (%%rax);"
    :    
    :"a" (idtr));
// </STUDENT FILL>
}

void my_load_idt(struct desc_ptr *idtr) {
// <STUDENT FILL>
asm ("lidt (%%rax);"
    :    
    :"a" (idtr));
// <STUDENT FILL>
}

void my_set_gate_offset(gate_desc *gate, unsigned long addr) {
// <STUDENT FILL>
asm ("movw %%si,(%%rax);"
     "shrq $16, %%rsi;"
     "movw %%si, 6(%%rax);"
     "shrq $16, %%rsi;"
     "movl %%esi, 8(%%rax);"
    :    
    :"a" (gate), "S" (addr));
// Doesn't work for some reson


// </STUDENT FILL>
}

unsigned long my_get_gate_offset(gate_desc *gate) {
// <STUDENT FILL>
unsigned long return_value;
asm ("movl 8(%%rax),%%esi;"
     "shlq $16,%%rsi;"
     "movw 6(%%rax),%%si;"
     "shlq $16,%%rsi;"
     "movw (%%rax),%%si;"
    :"=S" (return_value)  
    :"a" (gate));

return return_value;
// </STUDENT FILL>
}
