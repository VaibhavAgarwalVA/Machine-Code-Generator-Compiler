0: t0 = 1
1: if a <b goto 5
2: t0 = 0
3: goto 7
4: goto 9
5: mn = t1
6: goto 9
7: mn = t2
8: goto 9
9: goto 13
10: t3 = mn
11: mn = mn + 1
12: goto 16
13: if mn == 0 goto 16
14: mn = ~1
15: goto 10
16: t4 = 0
17: i = t4
18: t5 = 1
19: if i <mn goto 26
20: t5 = 0
21: goto 44
22: goto 44
23: t6 = i
24: i = i + 1
25: goto 18
26: t7 = a % i
27: t8 = 0
28: t9 = 1
29: if t7 ==t8 goto 33
30: t9 = 0
31: goto 23
32: goto 40
33: t10 = b % i
34: t11 = 0
35: t12 = 1
36: if t10 ==t11 goto 41
37: t12 = 0
38: goto 23
39: goto 40
40: goto 43
41: ans1 = t13
42: goto 23
43: goto 23
44: t14 = 0
45: i = t15
46: t16 = 1
47: if i <mn goto 51
48: t16 = 0
49: goto 55
50: goto 55
51: t17 = i
52: i = i + 1
53: ans2 = t18
54: goto 46
55: t19 = i
56: i = i - 1
57: ans3 = t20
58: t21 = 0
59: t22 = 1
60: if i >t21 goto 55
61: t22 = 0
62: goto 63
63: t23 = 0
64: i = t24
65: t25 = 1
66: if ans1 ==ans2 goto 70
67: t25 = 0
68: goto 
69: goto 75
70: t26 = 1
71: if ans2 ==ans3 goto 76
72: t26 = 0
73: goto 
74: goto 75
75: goto 78
76: return ans1
77: goto 
78: t27 = 15
79: a = t27
80: t28 = 10
81: param t28
82: param a
83: call gcd 2
84: ans = t29
----------------SYMBOL TABLE----------------
Name	Type		Size	Offset	InitVal
gcd	function	0	12	null
main	function	0	4	null
--------------------------------------------
----------------SYMBOL TABLE(gcd)----------------
Name	Type		Size	Offset	InitVal
a	int		4	0	null
b	int		4	4	null
retVal	int		4	8	null
mn	int		4	20	null
t0	int		4	16	null
t1		0	20	null
t2		0	20	null
t3	int		4	20	null
t4	int		4	24	0
i	int		4	36	0
ans1	int		4	40	null
ans2	int		4	44	null
ans3	int		4	48	null
t5	int		4	44	null
t6	int		4	48	null
t7	int		4	52	null
t8	int		4	56	0
t9	int		4	60	null
t10	int		4	64	null
t11	int		4	68	0
t12	int		4	72	null
t13		0	76	null
t14	int		4	76	0
t15		0	80	null
t16	int		4	80	null
t17	int		4	84	null
t18		0	88	null
t19	int		4	88	null
t20		0	92	null
t21	int		4	92	0
t22	int		4	96	null
t23	int		4	100	0
t24		0	104	null
t25	int		4	104	null
t26	int		4	108	null
--------------------------------------------
----------------SYMBOL TABLE(main)----------------
Name	Type		Size	Offset	InitVal
retVal	int		4	0	null
t27	int		4	4	15
a	int		4	16	15
ans	int		4	20	null
gcd	int		4	16	null
t28	int		4	20	10
t29		0	24	null
--------------------------------------------
success
