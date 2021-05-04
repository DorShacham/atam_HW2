.global get_elemnt_from_matrix, multiplyMatrices
.extern set_elemnt_in_matrix

.section .text
get_elemnt_from_matrix:
	#TODO: STUDENTS NEED TO FILL
        pushq %rbp #prolog -it is not realy needed here...
        movq %rsp, %rbp
        
        xorq %rax, %rax
        movq %rsi, %eax
        mulq %edx # finding n*row
        shlq $32, %rdx #putting the resulut in rdx
        addq %rax, %rdx
        
        leaq (%rdi, %rdx, 4), %rdi #finding the right row
        movq (%rdi, %ecx, 4), %eax 
        
        leave
	ret

multiplyMatrices:
	#TODO: STUDENTS NEED TO FILL
	ret
