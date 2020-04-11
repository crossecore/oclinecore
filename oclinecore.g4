/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
 
 //https://help.eclipse.org/kepler/index.jsp?topic=%2Forg.eclipse.ocl.doc%2Fhelp%2FOCLinEcore.html
 //https://wiki.eclipse.org/OCL/OCLinEcore
grammar oclinecore;

classifierCS:
	classCS|
	dataTypeCS|
	enumerationCS
	    ;

dataTypeCS:
	      'datatype' unrestrictedName templateSignatureCS? (':' SINGLE_QUOTED_STRING)? ('{' ('!'? 'serializable')? '}')? ('{' (annotationCS|invariantConstraintCS)* '}'|';')
	  ;

classCS:
         ('abstract')? 'class' unrestrictedName templateSignatureCS? ('extends' typedRefCS (',' typedRefCS))? (':' SINGLE_QUOTED_STRING)? ('{' 'interface' '}')? ('{'
         (annotationCS|operationCS|structuralFeatureCS|invariantConstraintCS)*|';')
;

templateSignatureCS: '(' unrestrictedName ('extends' unrestrictedName)? ')';

enumerationCS:
	  'enum' unrestrictedName templateSignatureCS? (':' SINGLE_QUOTED_STRING)? 
      ('{' ('!'? 'serializable')? '}')? ('{' (annotationCS|enumerationLiteralCS|invariantConstraintCS)* '}'|';')
      ;

enumerationLiteralCS:
			unrestrictedName ('=' INT)? ';'
		   ;

structuralFeatureCS:
		       attributeCS|
	       referenceCS;

attributeCS:
	       'attribute' unrestrictedName (':' typeRefCS (cardinality)?)? ('=' SINGLE_QUOTED_STRING)? '{' ('!'('derived'|'id'|'ordered'|'readonly'|'transient'|'unique'|'unsettable'|'volatile'))*  '}' ('{' (annotationCS|initialConstraintCS|derivedConstraintCS)* '}'|';')
	   ;

referenceCS:
	       'property' unrestrictedName ('#' unrestrictedName) (':' typeRefCS (cardinality)?)? ('=' SINGLE_QUOTED_STRING)? '{' ('!'('composes'|'derived'|'ordered'|'readonly'|'resolve'|'transient'|'unique'|'unsettable'|'volatile'))*  '}' ('{' (annotationCS|('key' unrestrictedName(',' unrestrictedName))|initialConstraintCS|derivedConstraintCS)* '}'|';')
	   ; 

operationCS:
	       'operation' unrestrictedName (templateSignatureCS)? '(' (parameterCS (',' parameterCS)*)? ')' (':' typeRefCS (cardinality)?)? ('throws' typeRefCS (',' typeRefCS)*)? ('{' ('!'('derived'|'ordered'|'unique'))*  '}')? ('{' (annotationCS|preconditionConstraintCS|bodyConstraintCS|postconditionConstraintCS)* '}'|';')
	   ;
	   
parameterCS:
	       unrestrictedName (':' typeRefCS (cardinality)?)? ('{' ('!'(|'ordered'|'unique'))*  '}')? ('{' annotationCS* '}')?
	   ;

bodyConstraintCS:'body' unrestrictedName? ':' specificationCS? ';';

derivedConstraintCS:'derivation' unrestrictedName? ':' specificationCS? ';';

initialConstraintCS:'initial' unrestrictedName? ':' specificationCS? ';';

postconditionConstraintCS:'postcondition' unrestrictedName? ':' specificationCS? ';';

preconditionConstraintCS:'precondition' unrestrictedName? ':' specificationCS? ';';

specificationCS: expCS|UNQUOTED_STRING;


invariantConstraintCS: 'invariant' (unrestrictedName ('(' specificationCS ')')?)? (':' specificationCS)? ';';


annotationCS:
		'annotation' (SINGLE_QUOTED_STRING| unrestrictedName) ('(' detailCS (',' detailCS)*')')? ('{' (annotationCS|unrestrictedName '}')*|';')
		   ;


detailCS: (unrestrictedName|SINGLE_QUOTED_STRING) ('=' SINGLE_QUOTED_STRING)?;
typeRefCS:
	     typedRefCS|wildcardTypeRefCS;

wildcardTypeRefCS:'?' ('extends' typedRefCS | 'super' typedRefCS)?
		 ;

typedRefCS: primitiveTypeCS|typedTypeRefCS;

primitiveTypeCS:primitiveTypeIdentifier;

primitiveTypeIdentifier:'Boolean'|'Integer'|'Real'|'String'|'UnlimitedNatural';

typedTypeRefCS:
		  (unrestrictedName '::' (unreservedName '::')* unreservedName|unrestrictedName) templateBindingCS?
	      ;

templateBindingCS:;

cardinality:
    '[' (('?'|'*'|'*')|(INT (',' INT)?)) ']'
           ;

expCS:
	 infixedExpCS;

infixedExpCS:
		prefixedExpCS (binaryOperatorCS prefixedExpCS)*;

prefixedExpCS:
		 primaryExpCS|(unaryOperatorCS* primaryExpCS);

unaryOperatorCS:
		   '-'|'not';

binaryOperatorCS:
		    '.'|'->'|'+'|'-'|'<'|'<='|'>='|'>'|'='|'<>'|'and'|'or'|'xor'|'implies'
		;

primaryExpCS:
		navigatingExpCS|
		selfExpCS|
		primitiveLiteralExpCS|
		tupleLiteralExpCS|
		collectionLiteralExpCS|
		typeLiteralExpCS|
		letExpCS|
		ifExpCS|
		nestedExpCS
          ;

navigatingExpCS: navigatingExpCS_Base ('(' (navigatingArgCS navigatingCommaArgCS*)? (navigatingSemiArgCS navigatingCommaArgCS*)? (navigatingBarArgCS navigatingCommaArgCS*)? ')')? 
	       ;

navigatingExpCS_Base: indexExpCS
		    ;

navigatingArgCS:navigatingArgExpCS (':' typeExpCS)? ('=' expCS)?  
	       ;

navigatingBarArgCS:'|' navigatingArgExpCS (':' typeExpCS)? ('=' expCS)? ;


navigatingCommaArgCS:',' navigatingArgExpCS (':' typeExpCS)? ('=' expCS)? ;


navigatingSemiArgCS:';' navigatingArgExpCS (':' typeExpCS)? ('=' expCS)? ;

navigatingArgExpCS: expCS;

indexExpCS:nameExpCS ('[' expCS (',' expCS)* ']')? ('[' expCS (',' expCS)* ']')?;



selfExpCS:
	     'self'
	 ;


primitiveLiteralExpCS:
	    numberLiteralExpCS|
	    stringLiteralExpCS|
	    booleanLiteralExpCS|
	    unlimitedNaturalLiteralCS|
	    invalidLiteralExpCS|
	    nullLiteralExpCS
		     ;

tupleLiteralExpCS: 'Tuple' '{' tupleLiteralPartCS (',' tupleLiteralPartCS)*'}';

tupleLiteralPartCS:
		  unrestrictedName (':' typeExpCS)? '=' primaryExpCS;

collectionLiteralExpCS: collectionTypeCS '{' (collectionLiteralPartCS (',' collectionLiteralPartCS)*)? '}';

collectionTypeCS: collectionTypeIdentifier ('(' typeExpCS ')'|'<' typeExpCS '>')?
		;

collectionTypeIdentifier:'Collection'|'Bag'|'OrderedSet'|'Sequence'|'Set';


collectionLiteralPartCS: expCS ('..' expCS)?;

typeLiteralExpCS: typeLiteralCS;

letExpCS: 'let' letVariableCS (',' letVariableCS)* 'in' expCS;

letVariableCS: unrestrictedName (':' typeExpCS)? '=' expCS;

typeExpCS: typeNameExpCS|typeLiteralCS;

typeNameExpCS:(unrestrictedName '::' ((unreservedName '::')*)? unreservedName|unrestrictedName);
nameExpCS:(unrestrictedName '::' ((unreservedName '::')*)? unreservedName|unrestrictedName);

typeLiteralCS:primitiveTypeCS | collectionTypeCS | tupleTypeCS;

tupleTypeCS: 'Tuple' ('(' tuplePartCS (',' tuplePartCS)* ')'|'<' tuplePartCS (',' tuplePartCS)* '>')?;

tuplePartCS: unrestrictedName ':' typeExpCS;


ifExpCS: 'if' expCS 'then' expCS 'else' expCS 'endif';

nestedExpCS:'(' expCS ')';


numberLiteralExpCS: INT ('.' INT)? (('e'|'E') ('+'|'-')? INT)?
		  ;

stringLiteralExpCS: '\'' .* '\'';
		  
booleanLiteralExpCS:
		   'true'|'false'
		   ;

unlimitedNaturalLiteralCS:'*';

invalidLiteralExpCS:'invalid';

nullLiteralExpCS:'null';

unrestrictedName: ~('and'|'else'|'endif'|'false'|'if'|'implies'|'in'|'invalid'|'let'|'not'|'null'|'or'|'self'|'then'|'true'|'xor'|'Bag'|'Boolean'|'Collection'|'Integer'|'Lambda'|'OclAny'|'OclInvalid'|'OclMessage'|'OclSelf'|'OclVoid'|'OrderedSet'|'Real'|' Sequence'|'Set'|'String'|'Tuple'|'UnlimitedNatural');

unreservedName: ~('and'|'else'|'endif'|'false'|'if'|'implies'|'in'|'invalid'|'let'|'not'|'null'|'or'|'self'|'then'|'true'|'xor');

INT: ('0'..'9')+;

SINGLE_QUOTED_STRING:
			'\''.*'\'';

COMMENT:LINE_COMMENT|BLOCK_COMMENT|DOCU_COMMENT;
LINE_COMMENT:'--' .* '\n';
BLOCK_COMMENT: '/*' .* '*/';
DOCU_COMMENT: '/**' .* '*/';




