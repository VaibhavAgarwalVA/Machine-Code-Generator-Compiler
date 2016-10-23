0: t0 = 2
1: t1 = 3
2: b = t0
3: c = t1
4: t3 = b + c
5: t2 = t4
6: t5 = 5
7: aa = t5
8: t6 = t7
9: return t8
10: t9 = 5
11: a = t9
12: param t10
13: call good 1
14: t11 = 4.4
15: t12 = 6.9
16: c = t11
17: b = t12
18: t13 = t14
19: t16 =  Int2Double(a)
20: t15 = t16 + b
21: t17 = t15 + c
22: t18 =  Double2Char(t17)
23: return t18
----------------SYMBOL TABLE----------------
Name	Type		Size	Offset	InitVal
good	function	0	8	null
func	function	0	4	null
main	function	0	1	null
--------------------------------------------
----------------SYMBOL TABLE(func)----------------
Name	Type		Size	Offset	InitVal
retVal	double 	4	0	null
a	double **		4	12	null
b	double *		4	24	null
c	double *		4	36	null
t5	int		4	40	5
aa	double		8	60	5
t6	int		4	52	null
t7		0	56	null
t8		0	56	null
--------------------------------------------
----------------SYMBOL TABLE(good)----------------
Name	Type		Size	Offset	InitVal
a	int		4	0	null
retVal	int		4	4	null
t0	int		4	8	2
t1	int		4	12	3
b	int		4	24	2
c	int		4	28	3
t2	int		4	24	null
t3	int		4	28	null
t4		0	32	null
--------------------------------------------
----------------SYMBOL TABLE(main)----------------
Name	Type		Size	Offset	InitVal
retVal	char		1	0	null
t9	int		4	1	5
a	int		4	13	5
good	int		4	9	null
t10	int		4	13	null
t11	double		8	17	4.4
t12	double		8	25	6.9
c	double		8	49	4.4
b	double		8	57	6.9
e	double *		4	57	null
t13	int		4	61	null
t14		0	65	null
t15	double		8	65	null
t16	double		8	73	null
t17	double		8	81	null
t18	char		1	89	null
--------------------------------------------
success
