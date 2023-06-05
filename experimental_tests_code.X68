TEST_SUB:
            ; BGT commands
            DC  $6E05   
            DC  $6E55   
            DC  $6EAA
            DC  $6EF0
            DC  $6E00
            DC  $1234
            DC  $6EFF
            DC  $1234
            DC  $5678
            DC  $6EFF
            DC  $8765
            DC  $4321
            DC  $6E01
            DC  $6E02
            DC  $6E03
            
            ; BLE commands
            DC  $6F05   
            DC  $6F55   
            DC  $6FAA
            DC  $6FF0
            DC  $6F00
            DC  $1234
            DC  $6FFF
            DC  $1234
            DC  $5678
            DC  $6FFF
            DC  $8765
            DC  $4321
            DC  $6F01
            DC  $6F02
            DC  $6F03
            
            ; BEQ commands
            DC  $6705  
            DC  $6755  
            DC  $67AA
            DC  $67F0
            DC  $6700
            DC  $1234
            DC  $67FF
            DC  $1234
            DC  $5678
            DC  $67FF
            DC  $8765
            DC  $4321
            DC  $6701
            DC  $6702
            DC  $6703
            
            ; BRA commands
            DC  $6005  
            DC  $6055  
            DC  $60AA
            DC  $60F0
            DC  $6000
            DC  $1234
            DC  $60FF
            DC  $1234
            DC  $5678
            DC  $60FF
            DC  $8765
            DC  $4321
            DC  $6001
            DC  $6002
            DC  $6003
            
            ; MOVE commands
            DC  $1202
            DC  $128A
            DC  $12D2
            DC  $1322
            DC  $11F8
            DC  $1234
            DC  $4321
            DC  $13F9
            DC  $1234
            DC  $5678
            DC  $8765
            DC  $4321
            DC  $11F9
            DC  $1234
            DC  $5678
            DC  $ABCD
            
            ; MOVEA commands
            DC  $3441
            DC  $3449
            DC  $2451
            DC  $3451
            DC  $3461
            DC  $3478
            DC  $1234
            DC  $3479
            DC  $1234
            DC  $5678
            DC  $347C  * (Currently unsupported)
            DC  $1234  * #$1234
            
            ; MOVEQ commansds
            DC  $7A02  * MOVEQ  #2,D5
            DC  $7C91  * MOVEQ  #145,D6
            
            ; NOT commands
            DC  $4602
            DC  $4612
            DC  $461A
            DC  $46A2
            DC  $4638
            DC  $1234
            DC  $4639
            DC  $1234
            DC  $5678
            
            ; JSR commands
            DC  $4E92   * JSR (A2)
            DC  $4EB8   * JSR $1234.W
            DC  $1234
            DC  $4EB9   * JSR $12345678.L
            DC  $1234
            DC  $5678
            
            ; LEA commands
            DC  $43D5   * LEA (A5),A1
            DC  $43F8   * LEA $1234.W, A1
            DC  $1234
            DC  $43F9   * LEA $12345678.L, A1
            DC  $1234
            DC  $5678

            ; NOP
            DC  $4E71   * NOP

            ; RTS
            DC  $4E75   * RTS
            
            ; ROR commands
            DC  $E01D   * ROR.B #8,D5
            DC  $E61D   * ROR.B #3,D5
            DC  $E63D   * ROR.B D3,D5
            DC  $E69D   * ROR.L #3,D5
            DC  $E6BD   * ROR.L D3,D5
            DC  $E6C5   * ROR D5
            DC  $E6D5   * ROR (A5)
            DC  $E6DD   * ROR (A5)+
            DC  $E6E5   * ROR -(A5)
            DC  $E6F8   * ROR $1234.W
            DC  $1234
            DC  $E6F9   * ROR $12345678.L
            DC  $1234
            DC  $5678
            
            ; ROL commands
            DC  $E11D   * ROL.B #8,D5
            DC  $E71D
            DC  $E73D
            DC  $E79D
            DC  $E7BD
            DC  $E7C5
            DC  $E7D5
            DC  $E7E5
            DC  $E7F8
            DC  $1234
            DC  $E7F9
            DC  $1234
            DC  $5678
            
            ; LSL commands
            DC  $E00D  
            DC  $E60D   
            DC  $E62D   *
            DC  $E68D   * 
            DC  $E6AD   *
 
            DC  $E2C5   * 
            DC  $E2D5   * 
            DC  $E2DD   * 
            DC  $E2E5   * 
            DC  $E2F8   * 
            DC  $1234
            DC  $E2F9   * 
            DC  $1234
            DC  $5678
            
            ; LSR commands
            DC  $E10D
            DC  $E70D
            DC  $E72D
            DC  $E78D
            DC  $E7AD
            
            DC  $E3C5
            DC  $E3D5
            DC  $E3DD 
            DC  $E3E5
            DC  $E3F8
            DC  $1234
            DC  $E3F9
            DC  $1234
            DC  $5678
            
            ; ASL commands
            DC  $E005  
            DC  $E605   
            DC  $E625   *
            DC  $E685   * 
            DC  $E6A5   *
 
            DC  $E0C5   * 
            DC  $E0D5   * 
            DC  $E0DD   * 
            DC  $E0E5   * 
            DC  $E0F8   * 
            DC  $1234
            DC  $E0F9   * 
            DC  $1234
            DC  $5678
            
            ; ASR commands
            DC  $E105
            DC  $E705
            DC  $E725
            DC  $E785
            DC  $E7A5
            
            DC  $E1C5
            DC  $E1D5
            DC  $E1DD
            DC  $E1E5
            DC  $E1F8
            DC  $1234
            DC  $E1F9
            DC  $1234
            DC  $5678

            ; AND commands
            DC  $C847
            ;DC  $C84F
            DC  $C857
            DC  $C85F
            DC  $C867
            DC  $C878
            DC  $1234
            DC  $C879
            DC  $1234
            DC  $5678
            DC  $C907
            DC  $C997
            DC  $C99F
            DC  $C9A7
            DC  $C9B8
            DC  $1234
            DC  $C9B9
            DC  $1234
            DC  $5678

            ; OR commands
            DC  $8807
            ;DC  $880F
            DC  $8817
            DC  $881F
            DC  $8827
            DC  $8838
            DC  $1234
            DC  $8839
            DC  $1234
            DC  $5678
            DC  $8947
            DC  $8957
            DC  $895F
            DC  $8967
            DC  $8978
            DC  $1234
            DC  $8979
            DC  $1234
            DC  $5678
            DC  $8987

            ; ADDQ commands
            DC  $5A04
            DC  $5A1C
            DC  $5A44
            DC  $5A4C
            DC  $5A5C
            DC  $5A84
            DC  $5A8C
            DC  $5A9C

            ; ADDA commands
            DC  $D6C4
            DC  $D6CC
            DC  $D6D4
            DC  $D6DC
            DC  $D6E4
            DC  $D6F8
            DC  $1234
            DC  $D6F9
            DC  $1234
            DC  $5678
            DC  $D7C4
            DC  $D7CC
            DC  $D7F8
            DC  $1234
            DC  $D7F9
            DC  $1234
            DC  $5678
            
            ; ADD commands
            DC  $D604
            DC  $D60C
            DC  $D614
            DC  $D61C
            DC  $D624
            ;DC  $942D
            ;DC  $1234
            ;DC  $9435
            ;DC  $1234
            DC  $D638
            DC  $1234
            DC  $D639
            DC  $1234
            DC  $5678
            ;DC  $D63C
            DC  $D684
            DC  $D794
            DC  $D79C
            DC  $D724
            DC  $D738
            DC  $1234
            DC  $D739
            DC  $1234
            DC  $5678

            ; SUB commands
            DC  $9405
            DC  $940D
            DC  $9415
            DC  $941D
            DC  $9425
            ;DC  $942D
            ;DC  $1234
            ;DC  $9435
            ;DC  $1234
            DC  $9438
            DC  $1234
            DC  $9439
            DC  $1234
            DC  $5678
            ;DC  $943C
            ;DC  $1234
            ;DC  $943A
            ;DC  $1234
            ;DC  $943B
            ;DC  $1200
            DC  $9485
            ;DC  $9545 - illegal instruction
            ;DC  $944D - illegal instruction
            DC  $9555
            DC  $955D
            DC  $9565
            DC  $9578
            DC  $1234
            DC  $9579
            DC  $1234
            DC  $5678
