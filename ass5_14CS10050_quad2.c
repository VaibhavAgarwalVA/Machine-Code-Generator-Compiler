0: t0 = 19
1: t1 = 2
2: t2 = 4
3: t3 = 5
4: t4 = 6
5: a = t0
6: t5 = 90
7: t6 = 2.6
8: t7 = 30
9: d = t6
10: t8 = 2
11: t10 =  Int2Double(t8)
12: t9 = d + t10
13: aa = t11
14: t12 = a
15: char_a = t13
16: t14 = 10
17: t15 = 0
18: t15 = t15 * 90
19: t15 = t15 + t14
20: t16 = 1
21: t18 =  Char2Int(char_a)
22: t17 = t18 + t16
23: ch_b[t15] = t19
24: t20 = 2.6
25: t21 =  Double2Int(t20)
26: return t21
----------------SYMBOL TABLE----------------
Name	Type		Size	Offset	InitVal
main	function	0	4	null
--------------------------------------------
----------------SYMBOL TABLE(main)----------------
Name	Type		Size	Offset	InitVal
retVal	int		4	0	null
t0	int		4	4	19
t1	int		4	8	2
t2	int		4	12	4
t3	int		4	16	5
t4	int		4	20	6
a	int		4	32	19
b	int *		4	32	null
c	int **		4	40	null
d	double		8	1132	2.6
arr	int [2][4][5][6]	960	56	null
t5	int		4	1016	90
char_a	char		1	1022	null
ch_b	char [90]	90	1022	null
t6	double		8	1112	2.6
t7	int		4	1120	30
dd	double [30]	240	1132	null
aa	double		8	1388	null
t8	int		4	1380	2
t9	double		8	1384	null
t10	double		8	1392	null
t11		0	1400	null
t12	char		1	1400	a
t13		0	1401	null
t14	int		4	1401	10
t15	int		4	1405	null
t16	int		4	1409	1
t17	int		4	1413	null
t18	int		4	1417	null
t19	char		1	1421	null
t20	double		8	1422	2.6
t21	int		4	1430	null
--------------------------------------------
Success !!
