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
  movb (%rax), %dil

  pushq %rdi
  pushq %rsi
  pushq %rdx
  pushq %rcx
  pushq %r8
  pushq %r9
  pushq %r10
  pushq %r11

  call what_to_do

  popq %r11
  popq %r10
  popq %r9
  popq %r8
  popq %rcx
  popq %rdx
  popq %rsi
  popq %rdi

  test %eax, %eax
  je orig
  # store code in edi & next instruction in rip
  movl %eax, %edi
  incq 8(%rsp)
  # keep reg state
  pop %rax

  iretq

orig:
  # go to original handler
  popq %rax
  
  jmp *(old_ili_handler)
