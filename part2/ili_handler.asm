.globl my_ili_handler

.text
.align 4, 0x90
my_ili_handler:
  ####### Some smart student's code here #######
      pushq %rbp #prolog for backup
      movq %rsp, %rbp
      pushq %rdi
      pushq %rax
      pushq %rsi 
            
      movq 8(%rbp), %rsi # rsi <- rip
      cmpb $0x0F, (%rsi) #cheking if the opcode is one or two byte
      je Two_byte
      pushq $1 # the opcoed is 1 byte
      movb (%rsi), %dil # put the last byte of the instruction in rdi
continue:  
       call what_to_do
       cmpl $0, %eax
       jne my_handler
       popq %rsi #to get 1/2 out of the stack
       popq %rsi #restore rsi
       popq %rax #restore rax
       popq %rdi #restore rdi
       leave
       jmp *old_ili_handler #goto the original routine

my_handler:
       popq %rdi # need to know if to move 1 or 2 bytes
       addq %rdi, 8(%rbp) # rip <- rip + inst_len
       movl %eax, %edi
       
       popq %rsi #restore rsi
       popq %rax #restore rax
       leave
       

  iretq


 Two_byte:
       pushq $2 # the opcoed is 2 byte
       movb 1(%rsi), %dil # put the last byte of the instruction in rdi
       jmp continue
       