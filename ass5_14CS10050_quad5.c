0: t0 = 3
1: test = t0
2: t1 = 10
3: a = t2
4: x = t4
5: t5 = t6
6: y = t8
7: t9 = 10
8: t10 = 5
9: v = t10
10: t11 = 1
11: i = t12
12: t13 = 10
13: t14 = 0
14: t14 = t14 * 10
15: t14 = t14 + t13
16: t15 = 1
17: if i <a goto 24
18: t15 = 0
19: goto 27
20: goto 27
21: t16 = i
22: i = i + 1
23: goto 12
24: t17 = i
25: i = i + 1
26: goto 21
27: t18 = 1
28: t19 = i - t18
29: i = t20
30: t21 = 0
31: t21 = t21 * 10
32: t21 = t21 + i
33: t22 = 1
34: if a <v goto 27
35: t22 = 0
36: goto 37
37: t23 = 2
38: i = t24
39: goto 41
40: goto 44
41: if i == 0 goto 51
42: i = ~1
43: goto 40
44: if v == 0 goto 51
45: v = ~1
46: goto 48
47: goto 51
48: t25 = 1
49: i = t26
50: goto 51
51: t27 = 0
52: t27 = t27 * 10
53: t27 = t27 + i
54: t28 = 1
55: if v >a goto 59
56: t28 = 0
57: goto 62
58: goto 62
59: t29 = i
60: i = i - 1
61: goto 51
62: t30 = 1
63: t31 = 0
64: t31 = t31 * 10
65: t31 = t31 + t30
66: a[t31] = t32
67: t33 = 0
68: t33 = t33 * 10
69: t33 = t33 + i
70: t34 = a[t33]
71: v = t34
72: return 
----------------SYMBOL TABLE----------------
Name	Type		Size	Offset	InitVal
t0	int		4	0	3
test	int		4	12	3
add	function	0	12	null
main	function	0	0	null
--------------------------------------------
----------------SYMBOL TABLE(add)----------------
Name	Type		Size	Offset	InitVal
a	int		4	0	null
b	int		4	4	null
retVal	int		4	8	null
t1	int		4	12	10
t2		0	16	null
x	int *		4	20	null
y	int		4	32	null
t3	int		4	28	null
t4	int		4	32	null
t5	int		4	36	null
t6		0	40	null
t7	int		4	40	null
t8		0	44	null
--------------------------------------------
----------------SYMBOL TABLE(main)----------------
Name	Type		Size	Offset	InitVal
retVal		0	0	null
t9	int		4	0	10
t10	int		4	4	5
i	int		4	16	null
a	int [10]	40	16	null
v	int		4	64	5
d	double		8	76	null
t11	int		4	68	1
t12		0	72	null
t13	int		4	72	10
t14	int		4	76	null
t15	int		4	80	null
t16	int		4	84	null
t17	int		4	88	null
t18	int		4	92	1
t19	int		4	96	null
t20		0	100	null
t21	int		4	100	null
t22	int		4	104	null
t23	int		4	108	2
t24		0	112	null
t25	int		4	112	1
t26		0	116	null
t27	int		4	116	null
t28	int		4	120	null
t29	int		4	124	null
t30	int		4	128	1
t31	int		4	132	null
t32	int		4	136	null
t33	int		4	140	null
t34	int		4	144	null
--------------------------------------------
Success !!
