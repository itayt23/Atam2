.global hamming_weight, negate_first_k, bring_balance_to_the_word, read_input

.section .bss
.lcomm path, 1024
.lcomm num, 8 #length of text from file in path

.section .text
read_input:
  push %rbp
  movq %rsp, %rbp 
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
  leave
  END_READ_INPUT:
  ret

hamming_weight:
  push %rbp
  movq %rsp, %rbp 
  movq %rsi, %rcx # this is the len
  xor %rax, %rax
  iterate_over_codeword:
  movq (%rdi), %rbx
  popcnt %rbx, %r8 
  add %r8, %rax

  add $8, %rdi
  loop iterate_over_codeword
DEBUG:
  leave
  ret

negate_first_k:
  ret

bring_balance_to_the_word:
  ret
