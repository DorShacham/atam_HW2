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
        pushq %rbp 
        movq %rsp, %rbp
        pushq %rbx
        pushq %r12
        pushq %r13
        
        sub $36, %rsp #open frame and save parametres
        movl %r9d, 32(%rsp) #r 
        movl %r8d, 28(%rsp) #n
        movl %ecx, 24(%rsp) #m
        movq %rdx, 16(%rsp) # *result
        movq %rsi,  8(%rsp) # *second
        movq %rdi,   (%rsp) #  *first 
        
        xorl %r12d, %r12d # row_counter
       row_loop: 
        cmpl %r12d, 24(%rsp) # for(row_counter = 0; row_conter < m; row_counter++)
        jle end_of_row_loop
        xorl %r13d, %r13d # col_counter
        
       col_loop:
        cmpl %r13d, 32(%rsp)  # for(col_counter = 0; col_conter < r; col_counter++)
        jle end_of_col_loop
        
        #getting ready to call vec_mul
        movq (%rsp), %rdi #  *first 
        movl 28(%rsp), %esi #n1
        movl %r12d, %edx # row
        movq 8(%rsp), %rcx # *second
        movl 32(%rsp), %r8d # n2
        movl %r13d, %r9d # col
        
        xorq %rax, %rax
        movl 16(%rbp), %eax
        pushq %rax # putting p on the stack
        
        call vec_mult
        popq %rbx # to get p out of the stack so our parmters will not move
        # eax = vec_mul[row][col]
        
        #getting ready to call set function
        movq 16(%rsp), %rdi #  *matrix 
        movl 32(%rsp), %esi # num_of_colms
        movl %r12d, %edx # row
        movl %r13d, %ecx # col
        movl %eax, %r8d # value
        
        call set_elemnt_in_matrix
        
        incl %r13d
        jmp col_loop
        
       end_of_col_loop:
        incl %r12d
        jmp row_loop
        
        
        
       end_of_row_loop:
        addq $36, %rsp 
        popq %r13
        popq %r12
        popq %rbx
        leave
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
    
#int vec_mult(int* first,int n1, int row, int* second, int n2, int col) 
#return the multiplactaion of the row of the first matrix to the colum of the second matrix
vec_mult: 
    pushq %rbp 
    movq %rsp, %rbp
    pushq %rbx
    pushq %r12
    pushq %r13
    
    xorl %r13d, %r13d # r13d = sum 
    xorl %r12d, %r12d #  this will be the iterator
    movl 16(%rbp), %eax # getting p
    
    #saving the parameters
    subq $36, %rsp
    movl %eax, 32(%rsp) #p //rsp+32
    movl %r9d, 28(%rsp) #col //rsp+28
    movl %r8d, 24(%rsp) #n2 //rsp+24
    movq %rcx, 16(%rsp) #*second//rsp+16
    movl %edx, 12(%rsp) #row //rsp+12
    movl %esi,  8(%rsp) #n1 //rsp+8
    movq %rdi ,  (%rsp)#*first //rsp
    
   loop:
    cmpl %r12d, 8(%rsp) # i < n1
    jle finish
    movq (%rsp), %rdi
    movl 8(%rsp), %esi
    movl 12(%rsp), %edx 
    movl %r12d, %ecx
    call get_elemnt_from_matrix
    movl %eax, %ebx
    
 #   jle finish
    movq 16(%rsp), %rdi
    movl 24(%rsp), %esi
    movl %r12d, %edx 
    movl 28(%rsp), %ecx
    call get_elemnt_from_matrix
    
    movl %eax, %edi # a
    movl %ebx, %esi # b
    movl 32(%rsp), %edx # p
    call mult_modolo_p # eax = (first[row][i]*second[i][col])%p
    
    addl %r13d, %eax
    xorl %edx,%edx
    divl 32(%rsp) 
    movl %edx, %r13d # sum += eas%p
    inc %r12d
    jmp loop
    
   finish:
    movl %r13d, %eax
    addq $36, %rsp 
    popq %r13
    popq %r12
    popq %rbx
    leave
    ret
    
   