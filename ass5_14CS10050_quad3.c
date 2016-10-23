0: t0 = a + b
1: c = t1
2: return c
3: t2 = 10
4: t3 = t2 + b
5: return t3
6: param a
7: param b
8: call add 2
9: d = t4
10: param d
11: param c
12: call add 2
13: e = t5
14: return e
15: t6 = 10
16: a = t6
17: t7 = 2
18: b = t8
19: t9 = 3
20: c = t10
21: param a
22: param b
23: param c
24: call sum 3
25: d = t11
26: param ch
27: param d
28: call addch 2
29: f = t12
30: t13 = a + b
31: return t13
----------------SYMBOL TABLE----------------
Name	Type		Size	Offset	InitVal
add	function	0	12	null
addch	function	0	9	null
sum	function	0	16	null
print	function	0	0	null
main	function	0	4	null
--------------------------------------------
----------------SYMBOL TABLE(add)----------------
Name	Type		Size	Offset	InitVal
a	int		4	0	null
b	int		4	4	null
retVal	int		4	8	null
c	int		4	20	null
t0	int		4	16	null
t1		0	20	null
--------------------------------------------
----------------SYMBOL TABLE(addch)----------------
Name	Type		Size	Offset	InitVal
a	char		1	0	null
b	int		4	1	null
retVal	int		4	5	null
t2	int		4	9	10
t3	int		4	13	null
--------------------------------------------
----------------SYMBOL TABLE(main)----------------
Name	Type		Size	Offset	InitVal
retVal	int		4	0	null
t6	int		4	4	10
a	int		4	16	10
ch	char		1	14	null
b	int		4	21	null
c	int		4	25	null
d	int		4	29	null
t7	int		4	25	2
t8		0	29	null
t9	int		4	29	3
t10		0	33	null
sum	int		4	33	null
t11		0	37	null
f	int		4	45	null
addch	int		4	41	null
t12		0	45	null
print	int		4	45	null
t13	int		4	49	null
--------------------------------------------
----------------SYMBOL TABLE(print)----------------
Name	Type		Size	Offset	InitVal
retVal		0	0	null
--------------------------------------------
----------------SYMBOL TABLE(sum)----------------
Name	Type		Size	Offset	InitVal
a	int		4	0	null
b	int		4	4	null
c	int		4	8	null
retVal	int		4	12	null
d	int		4	24	null
add	int		4	20	null
t4		0	24	null
e	int		4	32	null
t5		0	28	null
--------------------------------------------
success
