.globl my_ili_handler

.text
.align 4, 0x90
my_ili_handler:
  ####### Some smart student's code here #######
      pushq %rsi #backup rsi
      movq 8(%rsp), %rsi # rsi <- rip
      cmpb $0x0F, (%rsi) #cheking if the opcode is one or two byte
      je Two_byte
      pushq $1
      movb (%rsi), %dil
continue:  
       call what_to_do
       cmpl $0, %eax
       jne my_handler
       popq %rsi 
       popq %rsi
       jmp *old_ili_handler

my_handler:
       popq %rdi # need to know if to move 1 or 2 bytes
       addq %rdi, (%rsp)
       popq %rsi
       movl %eax, %edi

  iretq


 Two_byte:
       pushq $2
       movb 1(%rsi), %dil
       jmp continue
       