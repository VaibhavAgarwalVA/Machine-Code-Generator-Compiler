0: t0 = 1
1: test = t0
2: t1 = 1
3: t2 = 2
4: a = t1
5: b = t2
6: t3 = a + b
7: c = t4
8: t5 = a
9: a = a + 1
10: t6 = 2
11: t7 = a >> t6
12: a = t8
13: t9 = a / b
14: b = t10
15: t12 =  Int2Double(a)
16: t11 = t12 + d
17: d = t13
18: t14 = 1
19: if b >a goto 23
20: t14 = 0
21: goto 24
22: goto 28
23: goto 26
24: t15 = a
25: goto 28
26: t15 = b
27: goto 28
28: a = t16
29: t17 = b * c
30: t18 = a + t17
31: check = t18
32: t19 = 1
33: if check <c goto 37
34: t19 = 0
35: goto 40
36: goto 40
37: t20 = a | b
38: c = t21
39: goto 40
40: a = a + 1
41: t22 = a
42: t23 = b
43: b = b + 1
44: t24 = t22 + t23
45: i = t25
----------------SYMBOL TABLE----------------
Name	Type		Size	Offset	InitVal
t0	int		4	0	1
test	int		4	12	1
main	function	0	4	null
--------------------------------------------
----------------SYMBOL TABLE(main)----------------
Name	Type		Size	Offset	InitVal
retVal	int		4	0	null
t1	int		4	4	1
t2	int		4	8	2
a	int		4	20	1
b	int		4	24	2
c	int		4	28	null
t3	int		4	24	null
t4		0	28	null
t5	int		4	28	null
t6	int		4	32	2
t7	int		4	36	null
t8		0	40	null
t9	int		4	40	null
t10		0	44	null
d	double		8	60	null
t11	double		8	52	null
t12	double		8	60	null
t13		0	68	null
t14	int		4	68	null
t15	int		4	72	null
t16		0	76	null
t17	int		4	76	null
t18	int		4	80	null
check	int		4	92	null
t19	int		4	88	null
t20	int		4	92	null
t21		0	96	null
i	int		4	96	null
t22	int		4	100	null
t23	int		4	104	null
t24	int		4	108	null
t25		0	112	null
--------------------------------------------
success
