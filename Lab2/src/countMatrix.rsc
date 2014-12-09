module countMatrix
import Prelude;
import util::Math;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::\syntax::Java15;


public M3 testProject = createM3FromEclipseProject(|project://TestProject|);
public loc methHead = getOneFrom(methods(testProject));

int POSITION_USES = 0;
int POSITION_ADD = 1;
int POSITION_MULTIPLY = 2;
int POSITION_METHOD_CALLS = 3;

public map[str,list[int]] matrix;

public set[str] variablesInExpression(value method) {
	set[str] variables = {};
	visit (method) {
    	case \variable(name, extraDimensions) : variables += name;
    	case \variable(name, extraDimensions, \initializer) : variables += name;
    	case \parameter(\type, name, extraDimensions) : variables += name;
	}
	return variables;
}

public set[str] namesInExpression(Expression expr) {
	set[str] names = {};
	visit (expr) {
    	case \simpleName(name) : names += name;
	}
	return names;
}

public list[list[int]] countMatrix(loc methodLoc) {
	method = getMethodASTEclipse(methodLoc);
	
	set[str] variables = variablesInExpression(method);
	if(variables == {}) {
		return [[]];
	}
  	matrix = ( var : [0,0,0,0,0,0,0,0,0,0,0,0,0] | var <- variables);
  	
  	countUses(method); //0
  	
  	countAdditionsAndSubtractions(method); //1
  	
  	countMultiplicationsAndDivisions(method); //2
  	
  	countInvokeAsParameter(method); //3
  	
  	countInIf(method); //4
  	
  	countInArray(method); //5
  	
  	countDefined(method); //6
  	
  	countDefinedByAdd(method); //7
  	
  	countDefinedByMultiplication(method); //8
  	
  	countDefinedWithConstant(method); //9
  	
  	// Van de for loops werkt nog niks
  	
  	// countLoops(method); //10
  	// countFirstLevelLoop(method); //10
  	// countSecondLevelLoop(method); //11
  	// countThirdLevelLoop(method); //12
  	//
  	
	return transformToMatrix(matrix);
}

private list[list[int]] transformToMatrix(noMatrix) {
	return [noMatrix[k] | k <- noMatrix];
}
public void addOneForName(str name, int position) {
	println("KOE");
	if (name in matrix) {
		matrix[name][position] += 1;
	}
}

public void addOneForNames(set[str] names, int position) {
	for(name <- names) addOneForName(name, position);
}


// 0 x
public void countUses(method) {
  	visit (method) {
    	case \simpleName(name) : addOneForName(name, 0);	
  	}
}


// 1 x
public void countAdditionsAndSubtractions(method) {
  	visit (method) {
    	case \infix(lhs, /\+|\-/, rhs) : {
    		addOneForNames(namesInExpression(lhs) + namesInExpression(rhs), POSITION_ADD);
    	}
  	}
}

// 2 x
public void countMultiplicationsAndDivisions(method) {
  	visit (method) {
    	case \infix(lhs, /\*|\//, rhs) : {
    		addOneForNames(namesInExpression(lhs) + namesInExpression(rhs), POSITION_MULTIPLY);
    	}
  	}
}

// 3
public void countInvokeAsParameter(method) {
  	visit (method) {
    	case \methodCall(isSuper, name, arguments) : {
    		addOneForNames(({} | it + namesInExpression(arg) | arg <- arguments), POSITION_METHOD_CALLS);
    	}
    	case \methodCall(isSuper, receiver, name, arguments) : {
    		addOneForNames(({} | it + namesInExpression(arg) | arg <- arguments), POSITION_METHOD_CALLS);
    	}

  	}
}
  	
// 4 x
public void countInIf(method) {
  	visit (method) {
    	case \if(condition, thenBranch): addOneForNames(namesInExpression(condition), 4);
    	case \if(condition, thenBranch, elseBranch): addOneForNames(namesInExpression(condition), 4);
  	}
}

// 5
public void countInArray(method) {
  	visit (method) {
    	case \arrayInitializer(elements):
    		addOneForNames(({} | it + namesInExpression(elem) | elem <- elements), 5);
  	}
}

// 6 x
public void countDefined(method) {
  	visit (method) {
    	case \assignment(lhs, "=", rhs) : {
    		addOneForNames(namesInExpression(lhs) + namesInExpression(rhs), 6);
    	}
  	}
}

// 7 x
public void countDefinedByAdd(method) {
  	visit (method) {
    	case \assignment(lhs, /\+=|\-=/, rhs) : {
    		addOneForNames(namesInExpression(lhs) + namesInExpression(rhs), 7);
    	}
  	}
}

// 8 x
public void countDefinedByMultiplication(method) {
  	visit (method) {
    	case \assignment(lhs, /\*=|\/=/, rhs) : {
    		addOneForNames(namesInExpression(lhs) + namesInExpression(rhs), 8);
    	}
  	}
}

// 9
public void countDefinedWithConstant(method) {
  	visit (method) {
    	case \assignment(\simpleName(name), "=", rhs) : {
    		if((Expression)\null() := rhs || \number(_) := rhs || \booleanLiteral(_) := rhs || \stringLiteral(_) := rhs) {  
    			addOneForName(name, 9);
    		}
    	}
  	}
}
//
// 10
//public void countFirstLevelLoop(method) = countFirstLevelLoop(matrix,method,0); 
//public void countFirstLevelLoop(matrix, method, int depth) {
//  	top-down visit (method) {
//    	case \for(initializers, condition, updaters, body) :
//    		{
//    			println(depth);
//    			println(body);
//    			countFirstLevelLoop(matrix, body, 1+depth);
//    			break;// 
//    		}
//    	
//  	}
//  	return matrix;
//}

// 10 Nog niet compleet moet andere for loops, while loops en al het ander.., later kunnen we depth gaan bijhouden
public void countLoops(method) {
  	//visit (method) {
   // 	case \for(initializers, condition, updaters, body) : addOneForNames(namesInExpression(body), 10);
   // 	
  	//}
}

//// 12
//public void countThridLevelLoop(method) {
//  	visit (method) {
//    	case \simpleName(name) : if(name in matrix) matrix[name][POSITION_USES] += 1;
//    	
//  	}
//  	return matrix;
//}

test bool testCountMatrix() =
	countMatrix(methHead) ==
		("a":[3,0,0,2,0,0,0,0,0,0,0,0,0],
  		"b":[8,1,1,1,1,0,2,1,2,0,0,0,0],
  		"i":[3,0,0,0,1,0,1,0,0,0,0,0,0],
  		"j":[2,0,0,0,0,0,0,0,0,0,0,0,0],
  		"k":[3,0,0,1,0,0,0,0,0,0,0,0,0]);
