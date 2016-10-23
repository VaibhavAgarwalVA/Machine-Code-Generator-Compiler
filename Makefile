a.out: lex.yy.c y.tab.c y.tab.h ass5_14CS10050_translator.h ass5_14CS10050_translator.cxx dec_test.c
	g++ lex.yy.c y.tab.c ass5_14CS10050_translator.cxx -lfl

	#->>> Type "make run to generate output for all test files"

y.tab.h: ass5_14CS10050.y
	yacc -dtv ass5_14CS10050.y 
y.tab.c: ass5_14CS10050.y
	yacc -dtv ass5_14CS10050.y 
lex.yy.c: ass5_14CS10050.l y.tab.h
	flex ass5_14CS10050.l

clean: 
	rm a.out y.tab.h y.tab.c lex.yy.c y.output
run:
	./a.out < ass5_14CS10050_test0.c > ass5_14CS10050_quad0.c
	./a.out < ass5_14CS10050_test1.c > ass5_14CS10050_quad1.c
	./a.out < ass5_14CS10050_test2.c > ass5_14CS10050_quad2.c
	./a.out < ass5_14CS10050_test3.c > ass5_14CS10050_quad3.c
	./a.out < ass5_14CS10050_test4.c > ass5_14CS10050_quad4.c
