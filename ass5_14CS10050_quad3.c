0: param a
1: param b
2: call add 2
3: d = t0
4: param d
5: param c
6: call add 2
7: e = t1
8: return e
9: t2 = a + b
10: c = t3
11: return c
12: t5 =  Char2Int(b)
13: t4 = a + t5
14: return t4
----------------SYMBOL TABLE----------------
Name	Type		Size	Offset	InitVal
add	function	0	12	null
sum	function	0	16	null
print	function	0	0	null
printerror	function	0	5	null
main	function	0	4	null
--------------------------------------------
----------------SYMBOL TABLE(add)----------------
Name	Type		Size	Offset	InitVal
a	int		4	0	null
b	int		4	4	null
retVal	int		4	8	null
c	int		4	20	null
t2	int		4	16	null
t3		0	20	null
--------------------------------------------
----------------SYMBOL TABLE(main)----------------
Name	Type		Size	Offset	InitVal
retVal	int		4	0	null
a	int		4	12	null
b	char		1	10	null
t4	int		4	9	null
t5	int		4	13	null
--------------------------------------------
----------------SYMBOL TABLE(print)----------------
Name	Type		Size	Offset	InitVal
retVal		0	0	null
--------------------------------------------
----------------SYMBOL TABLE(printerror)----------------
Name	Type		Size	Offset	InitVal
err	char		1	0	null
retVal	char 	4	1	null
print	int		4	5	null
--------------------------------------------
----------------SYMBOL TABLE(sum)----------------
Name	Type		Size	Offset	InitVal
a	int		4	0	null
b	int		4	4	null
c	int		4	8	null
retVal	int		4	12	null
d	int		4	24	null
add	int		4	20	null
t0		0	24	null
e	int		4	32	null
t1		0	28	null
--------------------------------------------
success
