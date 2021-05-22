.global get_elemnt_from_matrix, multiplyMatrices
# %rdi: int* matrix
# %rsi: int n
# %rdx: int row
# %rcx: int col
# %r8:  int value
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
	
# %rdi: int* first
# %rsi: int* second
# %rdx: int* result
# %rcx: int m
# %r8:  int n
# %r9:  int r
# (%rbp+0x10): unsigned int p
multiplyMatrices:
	pushq %rbp
	movq %rsp, %rbp
	pushq %r12
	pushq %rbx
	pushq %r13

	pushq %rdi
	pushq %rsi
	pushq %rdx
	pushq %rcx
	pushq %r8

	xor %r10, %r10 # i = 0
loop_i:
	cmp %r10, %rcx 
	jle end
	xor %r11, %r11 # j = 0
loop_j:
	cmp %r11, %r9
	jg cont_j
	inc %r10
	jmp loop_i
cont_j:
	movq $0, %r13
	movq %rdx, %rdi # result
	movq %r9, %rsi # column size = r
	movq %r10, %rdx # row = i
	movq %r11, %rcx # column = j
	movq %r13, %r8 # value = 0
	call set_elemnt_in_matrix

	movq -0x40(%rbp), %r8
	movq -0x38(%rbp), %rcx
	movq -0x30(%rbp), %rdx
	movq -0x28(%rbp), %rsi
	movq -0x20(%rbp), %rdi

	xor %r12, %r12 # k = 0
loop_k:
	cmp %r12, %r8
	jg cont_k
	inc %r11
	jmp loop_j
cont_k:
	# get first[i][k]
	# %rdi already on matrix 1
	movq %r8, %rsi # n = n
	movq %r10, %rdx # row = i  
	movq %r12, %rcx # col = k
	call get_elemnt_from_matrix
	movq %rax, %rbx 

	movq -0x38(%rbp), %rcx
	movq -0x30(%rbp), %rdx
	movq -0x28(%rbp), %rsi
	movq -0x20(%rbp), %rdi

	# get second[k][j]
	movq %rsi, %rdi
	movq %r9, %rsi # n = r
	movq %r12, %rdx # row = k  
	movq %r11, %rcx # col = j
	call get_elemnt_from_matrix

	movq -0x38(%rbp), %rcx
	movq -0x30(%rbp), %rdx
	movq -0x28(%rbp), %rsi
	movq -0x20(%rbp), %rdi

	# %rbx = first[i][k]*second[k][j]
	imul %rax, %rbx
	# %r13 = result[i][j] + first[i][k]*second[k][j]
	addq %rbx, %r13

	# %r13 = (result[i][j] + first[i][k]*second[k][j]) % p
	pushq %rdx
	xor %rdx, %rdx
	movq %r13, %rax
	idivl 0x10(%rbp)
	movq %rdx, %r13 
	popq %rdx

	movq %rdx, %rdi # result
	movq %r9, %rsi # column size = r
	movq %r10, %rdx # row = i
	movq %r11, %rcx # column = j
	movq %r13, %r8 # value = (result[i][j] + first[i][k]*second[k][j]) % p
	call set_elemnt_in_matrix

	movq -0x40(%rbp), %r8
	movq -0x38(%rbp), %rcx
	movq -0x30(%rbp), %rdx
	movq -0x28(%rbp), %rsi
	movq -0x20(%rbp), %rdi

	inc %r12
	jmp loop_k
end:
	popq %r8
	popq %rcx
	popq %rdx
	popq %rsi
	popq %rdi
	
	pop %r13
	pop %rbx
	pop %r12
	pop %rbp
	ret
