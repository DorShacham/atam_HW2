.global get_elemnt_from_matrix, multiplyMatrices
.extern set_elemnt_in_matrix

.section .text
get_elemnt_from_matrix:
	#TODO: STUDENTS NEED TO FILL
        pushq %rbp #prolog -it is not realy needed here...
        movq %rsp, %rbp
        
        xorq %rax, %rax
        movl %esi, %eax
        mull %edx # finding n*row
        shlq $32, %rdx #putting the resulut in rdx
        addq %rax, %rdx
        
        leaq (%rdi, %rdx, 4), %rdi #finding the right row
        shlq $32, %rcx
        shrq $32, %rcx
        movl (%rdi, %rcx, 4), %eax 
        
        leave
	ret

multiplyMatrices:
	#TODO: STUDENTS NEED TO FILL
	ret

mult_modolo_p: # int mult_modolo_p(int a, int b, unsigned int p) {return (a*b)%p;}
    pushq %rbp #prolog -it is not realy needed here...
    movq %rsp, %rbp
    
    xorq %rax, %rax
    movl %edx, %ecx # moving p because we gona mult soon..
    movl %edi, %eax #eax = a
    mull %esi #EDX:EAX = a*b
    divl %ecx
    movl %edx, %eax 
      
    
    leave
    ret