.global my_ili_handler
.extern old_ili_handler

.text
.align 4, 0x90
my_ili_handler:
  # keep reg state
  pushq %rax

  # take rip
  movq 8(%rsp), %rax
  cmpb $0x0F, (%rax)
  jne cont
  # addr of next byte in op
  addq $1, %rax
cont:
  # pass last byte of invalid op 
  movzx (%rax), %edi

  call what_to_do
  test %eax, %eax
  je orig
  # store code in edi & next instruction in rip
  movl %eax, %edi
  movq 8(%rsp), %rax
  addq $1, %rax
  movq %rax, 8(%rsp)
  # keep reg state
  pop %rax

  iretq

orig:
  # go to original handler
  popq %rax
  
  jmp *(old_ili_handler)
