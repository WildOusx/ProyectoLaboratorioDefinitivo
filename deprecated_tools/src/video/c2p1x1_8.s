; vim: set tabstop=8 shiftwidth=8 noexpandtab:
	xdef	_c2p1x1_8_falcon	;export symbol
	xdef	_c2p1x1_8_tt		;export symbol
	xdef	_c2p1x1_8_tt_partial		;export symbol
	xdef	_c2p1x1_4_st		;export symbol
	;code


; prototypes :
; void c2p1x1_8_falcon(const void * chunky, void * planar, long screen_size);
; void c2p1x1_8_tt(const void * chunky, void * planar, long screen_size);
; void c2p1x1_4_st(const void * chunky, void * planar, long screen_size, void * pal);
;
; c2p1x1_8_tt function double each 320 pixel line in the planar buffer,
; so a 320x200(320x240) screen is converted to 320x400(320x480) to
; accomodate the TT Low resolution (320x480)

_c2p1x1_8_falcon:
	move.l	12(sp),d0	; X*Y
	move.l	8(sp),a0
	move.l	4(sp),a1
	; in	a0	chunky
	; 	a1	screen
	movem.l	d2-d7/a2-a6,-(sp)
	move.l	a0,a2
	add.l	d0,a2
	move.l	#$0f0f0f0f,d4
	move.l	#$00ff00ff,d5
	move.l	#$55555555,d6

	move.l	(a0)+,d0
	move.l	(a0)+,d1
	move.l	(a0)+,d2
	move.l	(a0)+,d3

	; a7a6a5a4a3a2a1a0 b7b6b5b4b3b2b1b0 c7c6c5c4c3c2c1c0 d7d6d5d4d3d2d1d0
	; e7e6e5e4e3e2e1e0 f7f6f5f4f3f2f1f0 g7g6g5g4g3g2g1g0 h7h6h5h4h3h2h1h0
	; i7i6i5i4i3i2i1i0 j7j6j5j4j3j2j1j0 k7k6k5k4k3k2k1k0 l7l6l5l4l3l2l1l0
	; m7m6m5m4m3m2m1m0 n7n6n5n4n3n2n1n0 o7o6o5o4o3o2o1o0 p7p6p5p4p3p2p1p0

	move.l	d1,d7
	lsr.l	#4,d7
	eor.l	d0,d7
	and.l	d4,d7
	eor.l	d7,d0
	lsl.l	#4,d7
	eor.l	d7,d1
	move.l	d3,d7
	lsr.l	#4,d7
	eor.l	d2,d7
	and.l	d4,d7
	eor.l	d7,d2
	lsl.l	#4,d7
	eor.l	d7,d3

	; a7a6a5a4e7e6e5e4 b7b6b5b4f7f6f5f4 c7c6c5c4g7g6g5g4 d7d6d5d4h7h6h5h4
	; a3a2a1a0e3e2e1e0 b3b2b1b0f3f2f1f0 c3c2c1c0g3g2g1g0 d3d2d1d0h3h2h1h0
	; i7i6i5i4m7m6m5m4 j7j6j5j4n7n6n5n4 k7k6k5k4o7o6o5o4 l7l6l5l4p7p6p5p4
	; i3i2i1i0m3m2m1m0 j3j2j1j0n3n2n1n0 k3k2k1k0o3o2o1o0 l3l2l1l0p3p2p1p0

	move.l	d2,d7
	lsr.l	#8,d7
	eor.l	d0,d7
	and.l	d5,d7
	eor.l	d7,d0
	lsl.l	#8,d7
	eor.l	d7,d2
	move.l	d3,d7
	lsr.l	#8,d7
	eor.l	d1,d7
	and.l	d5,d7
	eor.l	d7,d1
	lsl.l	#8,d7
	eor.l	d7,d3

	; a7a6a5a4e7e6e5e4 i7i6i5i4m7m6m5m4 c7c6c5c4g7g6g5g4 k7k6k5k4o7o6o5o4
	; a3a2a1a0e3e2e1e0 i3i2i1i0m3m2m1m0 c3c2c1c0g3g2g1g0 k3k2k1k0o3o2o1o0
	; b7b6b5b4f7f6f5f4 j7j6j5j4n7n6n5n4 d7d6d5d4h7h6h5h4 l7l6l5l4p7p6p5p4
	; b3b2b1b0f3f2f1f0 j3j2j1j0n3n2n1n0 d3d2d1d0h3h2h1h0 l3l2l1l0p3p2p1p0

	bra.s	.start
.pix16:
	move.l	(a0)+,d0
	move.l	(a0)+,d1
	move.l	(a0)+,d2
	move.l	(a0)+,d3

	; a7a6a5a4a3a2a1a0 b7b6b5b4b3b2b1b0 c7c6c5c4c3c2c1c0 d7d6d5d4d3d2d1d0
	; e7e6e5e4e3e2e1e0 f7f6f5f4f3f2f1f0 g7g6g5g4g3g2g1g0 h7h6h5h4h3h2h1h0
	; i7i6i5i4i3i2i1i0 j7j6j5j4j3j2j1j0 k7k6k5k4k3k2k1k0 l7l6l5l4l3l2l1l0
	; m7m6m5m4m3m2m1m0 n7n6n5n4n3n2n1n0 o7o6o5o4o3o2o1o0 p7p6p5p4p3p2p1p0

	move.l	d1,d7
	lsr.l	#4,d7
	move.l	a3,(a1)+
	move.l	a3,(a1)+
	eor.l	d0,d7
	and.l	d4,d7
	eor.l	d7,d0
	lsl.l	#4,d7
	eor.l	d7,d1
	move.l	d3,d7
	lsr.l	#4,d7
	eor.l	d2,d7
	and.l	d4,d7
	eor.l	d7,d2
	move.l	a4,(a1)+
	lsl.l	#4,d7
	eor.l	d7,d3

	; a7a6a5a4e7e6e5e4 b7b6b5b4f7f6f5f4 c7c6c5c4g7g6g5g4 d7d6d5d4h7h6h5h4
	; a3a2a1a0e3e2e1e0 b3b2b1b0f3f2f1f0 c3c2c1c0g3g2g1g0 d3d2d1d0h3h2h1h0
	; i7i6i5i4m7m6m5m4 j7j6j5j4n7n6n5n4 k7k6k5k4o7o6o5o4 l7l6l5l4p7p6p5p4
	; i3i2i1i0m3m2m1m0 j3j2j1j0n3n2n1n0 k3k2k1k0o3o2o1o0 l3l2l1l0p3p2p1p0

	move.l	d2,d7
	lsr.l	#8,d7
	eor.l	d0,d7
	and.l	d5,d7
	eor.l	d7,d0
	move.l	a5,(a1)+
	move.l	a5,(a1)+
	lsl.l	#8,d7
	eor.l	d7,d2
	move.l	d3,d7
	lsr.l	#8,d7
	eor.l	d1,d7
	and.l	d5,d7
	eor.l	d7,d1
	move.l	a6,(a1)+
	move.l	a6,(a1)+
	lsl.l	#8,d7
	eor.l	d7,d3

	; a7a6a5a4e7e6e5e4 i7i6i5i4m7m6m5m4 c7c6c5c4g7g6g5g4 k7k6k5k4o7o6o5o4
	; a3a2a1a0e3e2e1e0 i3i2i1i0m3m2m1m0 c3c2c1c0g3g2g1g0 k3k2k1k0o3o2o1o0
	; b7b6b5b4f7f6f5f4 j7j6j5j4n7n6n5n4 d7d6d5d4h7h6h5h4 l7l6l5l4p7p6p5p4
	; b3b2b1b0f3f2f1f0 j3j2j1j0n3n2n1n0 d3d2d1d0h3h2h1h0 l3l2l1l0p3p2p1p0
	.start
	move.l	d2,d7
	lsr.l	#1,d7
	eor.l	d0,d7
	and.l	d6,d7
	eor.l	d7,d0
	add.l	d7,d7
	eor.l	d7,d2
	move.l	d3,d7
	lsr.l	#1,d7
	eor.l	d1,d7
	and.l	d6,d7
	eor.l	d7,d1
	add.l	d7,d7
	eor.l	d7,d3

	; a7b7a5b5e7f7e5f5 i7j7i5j5m7n7m5n5 c7d7c5d5g7h7g5h5 k7l7k5l5o7p7o5p5
	; a3a2a1a0e3e2e1e0 i3j3i1j1m3n3m1n1 c3d3c1d1g3h3g1h1 k3l3k1l1o3p3o1p1
	; a6a4...
