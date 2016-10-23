0: t0 = 1
1: t1 = 2
2: t2 = 3
3: t3 = 4
4: t4 = 5
5: a = t0
6: b = t1
7: c = t2
8: d = t3
9: e = t4
10: t5 = 1
11: if d >c goto 15
12: t5 = 0
13: goto 17
14: goto 22
15: t6 = 2
16: goto 20
17: t7 = 1
18: t8 = t7
19: goto 22
20: t8 = t6
21: goto 22
22: a = t9
23: t10 = 1
24: if a ==b goto 28
25: t10 = 0
26: goto 34
27: goto 33
28: t11 = 1
29: if b ==c goto 52
30: t11 = 0
31: goto 34
32: goto 33
33: goto 51
34: t12 = 1
35: if a !=b goto 52
36: t12 = 0
37: goto 39
38: goto 50
39: t13 = 1
40: if c >d goto 44
41: t13 = 0
42: goto 63
43: goto 49
44: t14 = 1
45: if d <=e goto 52
46: t14 = 0
47: goto 63
48: goto 49
49: goto 50
50: goto 51
51: goto 63
52: t15 = a & b
53: a = t16
54: t17 = d << a
55: c = t18
56: t19 = c >> b
57: d = t20
58: t21 = a | b
59: a = t22
60: t23 = b ^ c
61: b = t24
62: goto 63
63: t25 = a + b
64: a = t26
65: t27 = d * e
66: c = t28
67: t29 = 0
68: t30 = 1
69: if e !=t29 goto 73
70: t30 = 0
71: goto 76
72: goto 76
73: t31 = d / e
74: b = t32
75: goto 76
76: t33 = d % e
77: c = t34
78: t35 = a + b
79: t36 = t35 + c
80: t37 = d * e
81: t38 = t36 - t37
82: return t38
----------------SYMBOL TABLE----------------
Name	Type		Size	Offset	InitVal
main	function	0	4	null
--------------------------------------------
----------------SYMBOL TABLE(main)----------------
Name	Type		Size	Offset	InitVal
retVal	int		4	0	null
t0	int		4	4	1
t1	int		4	8	2
t2	int		4	12	3
t3	int		4	16	4
t4	int		4	20	5
a	int		4	32	1
b	int		4	36	2
c	int		4	40	3
d	int		4	44	4
e	int		4	48	5
t5	int		4	44	null
t6	int		4	48	2
t7	int		4	52	1
t8	int		4	56	null
t9		0	60	null
t10	int		4	60	null
t11	int		4	64	null
t12	int		4	68	null
t13	int		4	72	null
t14	int		4	76	null
t15	int		4	80	null
t16		0	84	null
t17	int		4	84	null
t18		0	88	null
t19	int		4	88	null
t20		0	92	null
t21	int		4	92	null
t22		0	96	null
t23	int		4	96	null
t24		0	100	null
t25	int		4	100	null
t26		0	104	null
t27	int		4	104	null
t28		0	108	null
t29	int		4	108	0
t30	int		4	112	null
t31	int		4	116	null
t32		0	120	null
t33	int		4	120	null
t34		0	124	null
t35	int		4	124	null
t36	int		4	128	null
t37	int		4	132	null
t38	int		4	136	null
--------------------------------------------
success
