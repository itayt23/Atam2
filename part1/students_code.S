.global hamming_weight, negate_first_k, bring_balance_to_the_word, read_input

.section .bss
.lcomm path, 1024
.lcomm num, 8 #length of text from file in path

.section .text
read_input:
  push %rbp
  movq %rsp, %rbp 
  pushq %rbx
  sub $16, %rsp
  xor %rbx, %rbx
  movq %rdi, -16(%rbp) # this is the codeword
  lea path(%rip), %rdi
  call get_path
  
  movq $2, %rax
  lea path(%rip), %rdi
  movq $0, %rsi
  syscall #sys_open
  movq %rax, -8(%rbp) # saving file discroptor to -8(%rbp)
  
  movq -8(%rbp), %rdi
  movq $0, %rax
  movq $8, %rdx
  lea num(%rip), %rsi
  syscall #sys_read, need to check about where it start
  
  lea num(%rip), %rdi
  find_newline:
  movq (%rdi), %rdx
  inc %rdi
  inc %rbx
  cmpb $'\n', %dl
  jne find_newline
  movq $0, -1(%rdi) #change newline to \0 

  lea num(%rip), %rdi
  call atam_atol
  movq %rax, %r8

  movq -8(%rbp), %rdi
  movq $0, %rax
  movq $8, %rdx
  lea num(%rip), %rsi
  syscall #sys_read, need to check about where it start

  movq $3, %rax
  movq -8(%rbp), %rdi
  syscall #sys_close

  movq $2, %rax
  lea path(%rip), %rdi
  movq $0, %rsi
  syscall #sys_open
  movq %rax, -8(%rbp) # saving file discroptor to -8(%rbp)

  movq -8(%rbp), %rdi
  movq $0, %rax
  movq %rbx, %rdx
  lea num(%rip), %rsi
  syscall #sys_read

  movq -8(%rbp), %rdi
  movq $0, %rax
  movq %r8, %rdx
  movq -16(%rbp), %rsi
  syscall #sys_read

  movq %r8, %rax
  mov $8, %rbx
  movq $0, %rdx
  div %rbx
  popq %rbx
  leave
  ret

hamming_weight:
  push %rbp
  movq %rsp, %rbp 
  pushq %rbx
  movq %rsi, %rcx # this is the len
  xor %rax, %rax
  iterate_over_codeword:
  movq (%rdi), %rbx
  popcnt %rbx, %r8 
  add %r8, %rax
  add $8, %rdi
  loop iterate_over_codeword
  popq %rbx
  leave
  ret

negate_first_k:
  push %rbp
  movq %rsp, %rbp 
  movq %rsi, %rcx # this is the k - number of bits to NOT
  movq $1, %r8
  shl %cl, %r8
  dec %r8         # r8 is 2^k - 1
  movq %rdi, %rcx # this is the codeword
  movq %rdi, %rdx # this is the codeword
  not %rcx
  and %r8, %rcx
  not %r8
  and %r8, %rdx
  add %rcx, %rdx
  movq %rdx, %rax
  leave
  ret

bring_balance_to_the_word:
  push %rbp
  movq %rsp, %rbp 
  movq %rdi, %rbx # this is the codeword
  movq %rsi, %rcx # this is the len
  movq %rsi, %r8 # this is the len
  xor %r9, %r9
  movq $1, %r13
  imul $32, %r8 # this is n/2 - the number of bits divide 2
  check_balance:
  movq %rbx, %rdi
  movq %rcx, %rsi
  pushq %r8
  pushq %r9
  pushq %rcx
  call hamming_weight
  popq %rcx
  popq %r9
  popq %r8
  cmp %rax, %r8
  je end_bring_balance_to_the_word
  # we are getting the origin codeword back
  cmp $1, %r13
  je not_first_time
  movq %rbx, %rdi
  movq %r9, %rsi
  pushq %r8
  pushq %r9
  pushq %rcx
  call array_negate_first_k
  popq %rcx
  popq %r9
  popq %r8
  ###############################
  not_first_time:
  movq $0, %r13
  inc %r9
  movq %rbx, %rdi
  movq %r9, %rsi
  pushq %r8
  pushq %r9
  pushq %rcx
  DEBUG:
  call array_negate_first_k
  popq %rcx
  popq %r9
  popq %r8
  jmp check_balance
  
  end_bring_balance_to_the_word:
  movq %r9, %rax
  leave
  ret


array_negate_first_k:
  push %rbp
  movq %rsp, %rbp 
  movq %rdi, %r8
  movq %rsi, %r9 # this is k
  k_greater_than_64:
  cmp $64, %r9
  jl end_k_greater_than_64
  notq (%r8)
  sub $64, %r9
  add $8, %r8
  jmp k_greater_than_64
  end_k_greater_than_64:
  movq (%r8), %rdi
  movq %r9, %rsi
  pushq %r8
  call negate_first_k
  popq %r8
  movq %rax, (%r8)
  leave
  ret
