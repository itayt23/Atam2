.globl my_ili_handler

.text
.align 4, 0x90



my_ili_handler:
  iretq
  xor %r9, %r9
  xor %r10, %r10
  xor %r11, %r11
  xor %rdi, %rdi
  movq (%rsp), %rdx
  movq %rdx, %r9 # First byte
  movb $8, %cl
  shr %cl, %rdx
  movq %rdx, %r10 # Second byte
  shr %cl, %rdx
  movq %rdx, %r11 # Third byte
  cmp $0x0F, %dl
  jne one_byte
  cmp $0x0F3A, %dx
  jne check_two_bytes
  one_byte:
  movq %r9, %rdi
  call what_to_do
  jmp end_brain_fuck
  check_two_bytes:
  cmp $0x0F38, %dx
  jne two_bytes
  jmp one_byte
  two_bytes:
  movq %r10, %rdi
  call what_to_do
  jmp end_brain_fuck
  end_brain_fuck:
  cmp $0, %rax
  jne handle
  jmp *old_ili_handler
  end:
  iretq


handle:
  movq %rax, %rdi
  jmp end
