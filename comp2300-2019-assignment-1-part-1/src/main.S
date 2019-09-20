  .syntax unified
  .global main
  .type main, %function

@ The main idea for this part is to minimize the error by calculating 48000/440,if the result is not an integer(has remainder), then store the remainder
@ into one register, make it ready to use in next iteration(add to 48000 later), until we get an integer(to be more precisely,get 110) to minimize the 
@ error.
main:
  bl init
  mov r4,#440 @ desired frequency
  ldr r5,= 48000 @ sample rate
  
loop2:
  mov r10,#2
  udiv r8,r5,r4
  cmp r8,#110 
  bne loop3
  ldr r5,= 48000 @ sample rate

loop3:
  mls r9,r8,r4,r5
  add r5,r5,r9
  udiv r6,r8,r10
  mls r9,r6,r10,r8
  add r6,r9
  udiv r7,r8,r10
  b loop1
  b loop2

 loop1:
   mov r0,#0x7FFF
   bl BSP_AUDIO_OUT_Play_Sample
   subs r7,#1
   beq loop
   b loop1

 loop:
   mov r0,#0x8000
   bl BSP_AUDIO_OUT_Play_Sample
   subs r6,#1
   beq loop2
   b loop