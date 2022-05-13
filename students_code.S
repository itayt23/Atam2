.global hamming_weight, negate_first_k, bring_balance_to_the_word, read_input

.section .bss
.lcomm path, 1024
.lcomm num, 8 #length of text from file in path
.lcomm n, 8 #codeword length

.section .text
read_input:
  push %rbp
  movq %rsp, %rbp 
  sub $16, %rsp
  xor %rbx, %rbx
  movq %rdi, -16(%rbp) # this is the codeword
  movq path, %rdi
  call get_path
  popq %rbp
  movq $2, %rax
  movq path, %rdi
  movq $0, %rsi
  syscall #sys_open
  movq %rax, -8(%rbp) # saving file discroptor to -8(%rbp)
  
  movq -8(%rbp), %rdi
  movq $0, %rax
  movq $8, %rdx
  movq num, %rsi
  syscall #sys_read, need to check about where it start
  
  movq num, %rdi
  find_newline:
  cmp $0xa, (%rdi)
  inc %rdi
  inc %rbx
  jne find_newline
  movq $0, -1(%rdi) #change newline to \0 

  movq num, %rdi
  call atam_atol
  movq %rax, (n)

  movq -8(%rbp), %rdi
  movq $0, %rax
  movq $8, %rdx
  movq num, %rsi
  syscall #sys_read, need to check about where it start

  movq $3, %rax
  movq -8(%rbp), %rdi
  syscall #sys_close

  movq $2, %rax
  movq path, %rdi
  movq $0, %rsi
  syscall #sys_open
  movq %rax, -8(%rbp) # saving file discroptor to -8(%rbp)

  movq -8(%rbp), %rdi
  movq $0, %rax
  movq %rbx, %rdx
  movq num, %rsi
  syscall #sys_read

  movq -8(%rbp), %rdi
  movq $0, %rax
  movq (n), %rdx
  movq -16(%rbp), %rsi
  syscall #sys_read

  movq (n), %rax
  mov $8, %rbx
  div %rbx

  ret

hamming_weight:
  ret

negate_first_k:
  ret

bring_balance_to_the_word:
  ret
