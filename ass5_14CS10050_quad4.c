0: t0 = 1
1: t1 = 1
2: if n ==t0 goto 6
3: t1 = 0
4: goto 9
5: goto 16
6: t2 = 1
7: return t2
8: goto 16
9: t3 = 1
10: t4 = n - t3
11: param t4
12: call fact 1
13: t5 = n * fact
14: return t5
15: goto 16
16: t6 = 0
17: t7 = 0
18: product = t6
19: i = t7
20: t8 = 1
21: if i <a goto 25
22: t8 = 0
23: goto 33
24: goto 33
25: t9 = product + b
26: product = t10
27: t11 = i
28: i = i + 1
29: param a
30: param b
31: call mult 2
32: goto 33
33: return product
34: t12 = 10
35: t13 = 12
36: a = t12
37: b = t13
38: param num
39: call fact 1
40: f = t14
41: param a
42: param b
43: call mult 2
44: prod = t15
45: t16 = 0
46: return t16
----------------SYMBOL TABLE----------------
Name	Type		Size	Offset	InitVal
fact	function	0	8	null
mult	function	0	12	null
main	function	0	4	null
--------------------------------------------
----------------SYMBOL TABLE(fact)----------------
Name	Type		Size	Offset	InitVal
n	int		4	0	null
retVal	int		4	4	null
t0	int		4	8	1
t1	int		4	12	null
t2	int		4	16	1
fact	int		4	20	null
t3	int		4	24	1
t4	int		4	28	null
t5	int		4	32	null
--------------------------------------------
----------------SYMBOL TABLE(main)----------------
Name	Type		Size	Offset	InitVal
retVal	int		4	0	null
num	int		4	12	null
f	int		4	16	null
prod	int		4	20	null
t12	int		4	16	10
t13	int		4	20	12
a	int		4	32	10
b	int		4	36	12
fact	int		4	32	null
t14		0	36	null
mult	int		4	36	null
t15		0	40	null
t16	int		4	40	0
--------------------------------------------
----------------SYMBOL TABLE(mult)----------------
Name	Type		Size	Offset	InitVal
a	int		4	0	null
b	int		4	4	null
retVal	int		4	8	null
t6	int		4	12	0
t7	int		4	16	0
product	int		4	28	0
i	int		4	32	0
t8	int		4	28	null
t9	int		4	32	null
t10		0	36	null
t11	int		4	36	null
mult	int		4	40	null
--------------------------------------------
Success !!
