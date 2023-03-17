.data
	x:			.space 4
	m_size:		.space 4
	done:			.space 4
	y:			.space 4
	p:			.space 4
	x3:			.space 4
	y3:			.space 4
	aux:			.space 4
	x3_stop:		.space 4
	y3_stop:		.space 4
	
	M:			.space 400
		
	format_r_file:		.asciz "sudoku.txt"
	format_rf:		.asciz "r"
	format_r_d:		.asciz "%d"
	
	format_p_file:		.asciz "sudoku_sol.txt"
	format_pf:		.asciz "w"
	format_p_d:		.asciz "%d "
	format_p_c:		.asciz "%c"
.text

proc_afis:
	movl $0, %ecx
	
	et_p_a_for:
		cmp $81, %ecx
		je et_p_a_ret
	
		pushl %ecx
		pushl (%edi, %ecx, 4)
		pushl $format_p_d
		call printf
		popl %ebx
		popl %ebx
		popl %ecx
		
		xorl %edx, %edx
		movl %ecx, %eax
		movl $9, %ebx
		divl %ebx
		
		cmp $8, %edx
		jl et_p_a_for_cont
		
		pushl %ecx
		pushl $10
		pushl $format_p_c
		call printf
		popl %ebx
		popl %ebx
		popl %ecx
		
		et_p_a_for_cont:
			incl %ecx
			jmp et_p_a_for
	et_p_a_ret:
		pushl $10
		pushl $format_p_c
		call printf
		popl %ebx
		popl %ebx
		ret
		
proc_valid:
	
	movl 4(%esp), %ecx
	movl %ecx, p
	movl %ebx, aux
	
	et_verif_linie:
		xorl %edx, %edx
		movl x, %eax
		movl $9, %esi
		mull %esi
		
		xorl %ecx, %ecx
		
		et_v_l_for:
			cmp $9, %ecx
			je et_verif_coloana
			
			movl (%edi, %eax, 4), %edx
			incl %eax
			
			cmp p, %edx
			je et_ret_0
			
			incl %ecx
			jmp et_v_l_for
		
	et_verif_coloana:
		movl y, %eax
		
		xorl %ecx, %ecx
		
		et_v_c_for:
			cmp $9, %ecx
			je et_verif_patrat
			
			movl (%edi, %eax, 4), %edx
			addl $9, %eax
			
			cmp p, %edx
			je et_ret_0
			
			incl %ecx
			jmp et_v_c_for
			
	et_verif_patrat:
		movl $3, %esi
		
		xorl %edx, %edx
		movl x, %eax
		divl %esi
		
		xorl %edx, %edx
		mull %esi
		
		movl %eax, %ecx
		addl $2, %eax
		movl %eax, x3_stop
		
		xorl %edx, %edx
		movl y, %eax
		divl %esi
		
		xorl %edx, %edx
		mull %esi
		
		movl %eax, y3
		addl $2, %eax
		movl %eax, y3_stop
		
		movl $9, %esi
		
		et_v_p_for_i:
			cmp x3_stop, %ecx
			jg et_ret_1
			
			xorl %edx, %edx
			movl %ecx, %eax
			mull %esi
			
			movl y3, %ebx
			
			et_v_p_for_j:
				cmp y3_stop, %ebx
				jg et_v_for_i_cont
				
				addl %ebx, %eax
				movl (%edi, %eax, 4), %edx
				subl %ebx, %eax
				
				cmp p, %edx
				je et_ret_0
				
				incl %ebx
				jmp et_v_p_for_j
				
			et_v_for_i_cont:
				incl %ecx
				jmp et_v_p_for_i
			
	et_ret_1:
		movl aux, %ebx
		movl $1, %eax
		ret
	et_ret_0:
		movl aux, %ebx
		movl $0, %eax
		ret
		
proc_Back:
	movl $1, %ebx
	cmp done, %ebx
	je et_proc_Back_ret
	
	movl 4(%esp), %ebx
	cmp $81, %ebx
	jge et_proc_Back_afis
	
	movl (%edi, %ebx, 4), %eax
	
	cmp $0, %eax
	je et_proc_Back_for_init
	
	incl %ebx
	pushl %ebx
	call proc_Back
	popl %ebx
	decl %ebx
	jmp et_proc_Back_ret
	
	et_proc_Back_for_init:
		movl $9, %esi
		xorl %edx, %edx
		movl %ebx, %eax
		divl %esi
		movl %eax, x
		movl %edx, y
		
		movl $1, %ecx
		
		et_proc_Back_for:
			cmp $9, %ecx
			jg et_proc_Back_ret
			
			pushl %ecx
			call proc_valid
			popl %ecx 
			
			cmp $0, %eax
			je et_proc_Back_for_cont
			
			movl %ecx, (%edi, %ebx, 4)
			incl %ebx
			
			pushl x
			pushl y
			pushl %ecx
			pushl %ebx
			call proc_Back
			popl %ebx
			popl %ecx
			popl %edx
			popl %eax
			
			movl %eax, x
			movl %edx, y
			
			decl %ebx
			xorl %eax, %eax
			movl %eax, (%edi, %ebx, 4)
			
			et_proc_Back_for_cont:
				incl %ecx
				jmp et_proc_Back_for
	et_proc_Back_afis:
		movl $1, %eax
		movl %eax, done
		call proc_afis
	et_proc_Back_ret:
		ret
.global main

main:
	pushl stdin
	pushl $format_rf
	pushl $format_r_file
	call freopen
	popl %ebx
	popl %ebx
	popl %ebx
	
	pushl stdout
	pushl $format_pf
	pushl $format_p_file
	call freopen
	popl %ebx
	popl %ebx
	popl %ebx
	
	movl $81, %eax
	movl %eax, m_size
	
	xorl %ecx, %ecx
	lea M, %edi
	
et_for_read:
	cmp m_size, %ecx
	jg et_back
	
	pushl %ecx
	pushl $x
	pushl $format_r_d
	call scanf
	popl %ebx
	popl %ebx
	popl %ecx
	
	movl x, %eax
	
	movl %eax, (%edi, %ecx, 4)
	
	incl %ecx
	jmp et_for_read
		
et_back:
	pushl $0
	call proc_Back
	popl %ebx
	
et_exit:
	pushl $0
	call fflush
	popl %ebx
	
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
