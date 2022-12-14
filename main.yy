//%define lr.type canonical-lr

%{
	/* definitions */
	#include <stdio.h>
	#include <stdlib.h>

	bool result = 0;
	int yylex(void);
	void yyerror(const char*);
%}

%%
/* rules */
/* <S> ::= <A> */
/* <A> ::= <A>"+"<B> | <A>"-"<B> |<B> */
/* <B> ::= <C>"*"<B> | <C>"/"<B> |<C> */
/* <C> ::= "a" | "("<A>")" */

S:      A               {printf("S -> A\n"); result = 1; };

A:      A'+'B           {printf("A -> A+B\n"); result = 0; }
        | A'-'B         {printf("A -> A-B\n"); result = 0; }
        | B             {printf("A -> B\n"); result = 0; };
        
B:	C'*'B   	{printf("B -> (C*B)\n"); result = 0; }
	| C'/'B 	{printf("B -> (C/B)\n"); result = 0; }
	| C		{printf("B -> C\n"); result = 0; };

C:	'a'		{printf("C -> a\n"); result = 1; }
	| '('A')'	{printf("C -> (A)\n"); result = 1; };
%%

int yylex(void) {
	int i;
	i = getchar();
	while (i == ' ' || i == '\t')
		i = getchar();
	if (i == EOF || i == '\n')
		if (result) {
			printf("\nSuccess\n");
			exit(0);
		} else {
			printf("\nFail\n");
			exit(0);
		}
    return i;
}

void yyerror(char const* message) {
	printf("Error:\n %s\n", message);
	exit(-1);
}

int main() {
	printf("\nThe process has begin...\n");
	printf("Enter: ");
	yyparse();
	return 0;
}
