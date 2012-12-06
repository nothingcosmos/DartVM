class Fibo {
  static int fibo(int n) {
    if (n < 2) {
      return n;
    } else {
      return fibo(n-1) + fibo(n-2);
    }
  }
  public static void main(String[] args) {
    System.out.println(fibo(40));
  }
}

$ time java Fibo
102334155

real  0m0.482s
user  0m0.464s
sys 0m0.020s

#
#  int ( int )
#
#r000 ecx   : parm 0: int
# -- Old esp -- Framesize: 32 --
#r045 esp+28: return address
#r044 esp+24: saved fp register
#r043 esp+20: pad2, stack alignment
#r042 esp+16: Fixed slot 0
#r049 esp+12: spill
#r048 esp+ 8: spill
#r047 esp+ 4: spill
#r046 esp+ 0: spill
#
abababab   N1: #  B1 <- B13 B18  Freq: 1
abababab
000   B1: # B12 B2 <- BLOCK HEAD IS JUNK   Freq: 1
000     # stack bang
        PUSH   EBP  # Save EBP
        SUB    ESP, #24 # Create frame

00b     MOV    [ESP + #0],ECX
00e     CMP    ECX,#2
011     Jl,s  B12  P=0.500011 C=360570.000000
011
013   B2: # B6 B3 <- B1  Freq: 0.499989
013     MOV    EBX,ECX                           // EBX <-- n
015     DEC    EBX                               // EBX <-- n - 1
016     ADD    ECX,#-3                           // ECX <-- n - 3
019     MOV    [ESP + #4],ECX
01d     MOV    EBP,[ESP + #0]
020     ADD    EBP,#-2
023     CMP    EBX,#2
026     Jl,s  B6  P=0.500011 C=360570.000000
026
028   B3: # B14 B4 <- B2  Freq: 0.249989
028     MOV    [ESP + #8],EBX
02c     MOV    ECX,EBP
        nop   # 1 bytes pad for loops and calls
02f     CALL,static  Fibo::fibo
        # Fibo::fibo @ bci:10  L[0]=esp + #8
        # Fibo::fibo @ bci:10  L[0]=esp + #0
        # OopMap{off=52}
034
034   B4: # B16 B5 <- B3  Freq: 0.249984
        # Block is sole successor of call
034     MOV    [ESP + #8],EBP
038     MOV    EBP,EAX
03a     MOV    ECX,[ESP + #4]
        nop   # 1 bytes pad for loops and calls
03f     CALL,static  Fibo::fibo
        # Fibo::fibo @ bci:16  L[0]=_ STK[0]=EBP
        # Fibo::fibo @ bci:10  L[0]=esp + #0
        # OopMap{off=68}
044
044   B5: # B6 <- B4  Freq: 0.249979
        # Block is sole successor of call
044     MOV    EBX,EAX
046     ADD    EBX,EBP
048     MOV    EBP,[ESP + #8]
048
04c   B6: # B10 B7 <- B2 B5  Freq: 0.499979
04c     CMP    EBP,#2
04f     Jl,s  B10  P=0.500011 C=360570.000000
04f
051   B7: # B15 B8 <- B6  Freq: 0.249984
051     MOV    [ESP + #8],EBX
055     MOV    ECX,[ESP + #4]
        nop   # 2 bytes pad for loops and calls
05b     CALL,static  Fibo::fibo
        # Fibo::fibo @ bci:10  L[0]=EBP
        # Fibo::fibo @ bci:16  L[0]=_ STK[0]=esp + #8
        # OopMap{off=96}
060
060   B8: # B17 B9 <- B7  Freq: 0.249979
        # Block is sole successor of call
060     MOV    EBP,EAX
062     MOV    ECX,[ESP + #0]
065     ADD    ECX,#-4
        nop   # 3 bytes pad for loops and calls
06b     CALL,static  Fibo::fibo
        # Fibo::fibo @ bci:16  L[0]=_ STK[0]=EBP
        # Fibo::fibo @ bci:16  L[0]=_ STK[0]=esp + #8
        # OopMap{off=112}
070
070   B9: # B11 <- B8  Freq: 0.249974
        # Block is sole successor of call
070     ADD    EAX,EBP
072     MOV    EBX,[ESP + #8]
076     JMP,s  B11
076
078   B10: #  B11 <- B6  Freq: 0.249995
078     MOV    EAX,EBP
078
07a   B11: #  B13 <- B10 B9  Freq: 0.499969
07a     ADD    EAX,EBX
07c     JMP,s  B13
07c
07e   B12: #  B13 <- B1  Freq: 0.500011
07e     MOV    EAX,ECX                            // EAX <-- n
07e
080   B13: #  N1 <- B12 B11  Freq: 0.99998
080     ADD    ESP,24 # Destroy frame
        POPL   EBP
        TEST   PollPage,EAX ! Poll Safepoint

08a     RET                                       // return n
08a
08b   B14: #  B18 <- B3  Freq: 2.49989e-06
08b     # exception oop is in EAX; no code emitted
08b     MOV    ECX,EAX
08d     JMP,s  B18
08d
08f   B15: #  B18 <- B7  Freq: 2.49984e-06
08f     # exception oop is in EAX; no code emitted
08f     MOV    ECX,EAX
091     JMP,s  B18
091
093   B16: #  B18 <- B4  Freq: 2.49984e-06
093     # exception oop is in EAX; no code emitted
093     MOV    ECX,EAX
095     JMP,s  B18
095
097   B17: #  B18 <- B8  Freq: 2.49979e-06
097     # exception oop is in EAX; no code emitted
097     MOV    ECX,EAX
097
099   B18: #  N1 <- B14 B16 B15 B17  Freq: 9.99936e-06
099     ADD    ESP,24 # Destroy frame
        POPL   EBP

09d     JMP    rethrow_stub
09d




$ time java -XX:MaxInlineSize=0 -XX:FreqInlineSize=0 Fibo
102334155

real  0m0.661s
user  0m0.640s
sys 0m0.020s

abababab   N1: #  B1 <- B6 B9  Freq: 1
abababab
000   B1: # B5 B2 <- BLOCK HEAD IS JUNK   Freq: 1
000     # stack bang
        PUSH   EBP  # Save EBP
        SUB    ESP, #24 # Create frame

00b     MOV    EBP,ECX
00d     CMP    ECX,#2
010     Jl,s  B5  P=0.500013 C=359559.000000
010
012   B2: # B7 B3 <- B1  Freq: 0.499987
012     DEC    ECX
013     CALL,static  Fibo::fibo
        # Fibo::fibo @ bci:10  L[0]=EBP
        # OopMap{off=24}
018
018   B3: # B8 B4 <- B2  Freq: 0.499977
        # Block is sole successor of call
018     MOV    [ESP + #0],EAX
01b     MOV    ECX,EBP
01d     ADD    ECX,#-2
        nop   # 3 bytes pad for loops and calls
023     CALL,static  Fibo::fibo
        # Fibo::fibo @ bci:16  L[0]=_ STK[0]=esp + #0
        # OopMap{off=40}
028
028   B4: # B6 <- B3  Freq: 0.499967
        # Block is sole successor of call
028     ADD    EAX,[ESP + #0]
02b     JMP,s  B6
02b
02d   B5: # B6 <- B1  Freq: 0.500013
02d     MOV    EAX,ECX
02d
02f   B6: # N1 <- B5 B4  Freq: 0.99998
02f     ADD    ESP,24 # Destroy frame
        POPL   EBP
        TEST   PollPage,EAX ! Poll Safepoint

039     RET
039
03a   B7: # B9 <- B2  Freq: 4.99987e-06
03a     # exception oop is in EAX; no code emitted
03a     MOV    ECX,EAX
03c     JMP,s  B9
03c
03e   B8: # B9 <- B3  Freq: 4.99977e-06
03e     # exception oop is in EAX; no code emitted
03e     MOV    ECX,EAX
03e
040   B9: # N1 <- B7 B8  Freq: 9.99965e-06
040     ADD    ESP,24 # Destroy frame
        POPL   EBP

044     JMP    rethrow_stub
044



