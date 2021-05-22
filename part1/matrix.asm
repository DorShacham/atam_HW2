.global get_elemnt_from_matrix, multiplyMatrices
.extern set_elemnt_in_matrix

# note to self, %rax,%rdi,%rsi,%rdx,%rcx,%r8-11 are caller-save 

# %rdi: int* matrix
# %rsi: int n
# %rdx: int row
# %rcx: int col
.section .text
get_elemnt_from_matrix:
	pushq %rbp
	movq %rsp, %rbp
	
	imulq %rdx, %rsi
	addq %rcx, %rsi
	movl (%rdi,%rsi,4), %eax
	
	popq %rbp
	ret
	
multiplyMatrices:
	#TODO: STUDENTS NEED TO FILL
	ret
