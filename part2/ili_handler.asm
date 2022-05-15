.globl my_ili_handler

.text
.align 4, 0x90

handle:
  movq %rax, %rdi
  popq %rax
  popq %rdx
  addq $2, (%rsp) 
  jmp end


my_ili_handler:
  pushq %rdx
  pushq %rax
  xor %rdx, %rdx
  xor %rax, %rax
  xor %rdi, %rdi
  movq 16(%rsp), %rdx
  cmp $0x0F, %dl
  jne one_byte
  movb %dh, %al
  movq %rax, %rdi
  call what_to_do
  jmp end_brain_fuck
  one_byte:
  movb %dl, %al
  movq %rax, %rdi
  call what_to_do
  jmp end_brain_fuck
  end_brain_fuck:
  cmp $0, %rax
  jne handle
  popq %rax
  popq %rdx
  jmp *old_ili_handler
  end:
  iretq
