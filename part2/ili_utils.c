#include <asm/desc.h>

void my_store_idt(struct desc_ptr *idtr) {
    asm("\
            sidt %0\
        "
        : "=m"(*idtr)
        );
}

void my_load_idt(struct desc_ptr *idtr) {
    asm("\
            lidt %0\
        "
        : 
        : "m"(*idtr)
        );
}

void my_set_gate_offset(gate_desc *gate, unsigned long addr) {
    gate->offset_low = addr & 0xFFFF;
    gate->offset_middle = ((addr >> 16) & 0xFFFF);
    gate->offset_high = ((addr >> 32) & 0xFFFFFFFF);
}

unsigned long my_get_gate_offset(gate_desc *gate) {
    unsigned long offset = 0;
    offset = gate->offset_high;
    offset <<= 16;
    offset += gate->offset_middle;
    offset <<= 16;
    offset += gate->offset_low;
    return offset;
}
