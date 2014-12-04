module Main

import Prelude;
import util::Math;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::\syntax::Java15;

public M3 testProject = createM3FromEclipseProject(|project://TestProject|);
public M3 testDuplicationProject = createM3FromEclipseProject(|project://TestDuplicationProject|);

public list[list[real]] similarities(M3 project) {
	countMatrices = [ countMatrix(m) | m <- methods(project) ];
	return [ [ matrixSimilarity(a, b) | a <- countMatrices ] | b <- countMatrices ];
}



public real matrixSimilarity(list[list[int]] a, list[list[int]] b) {
	return 0.0;
}

public real vectorSimilarity(list[int] a, list[int] b) {
	int size = max(length(a), length(b))
	result = 0;
	for(i = 0; i < size; i++) {
		result = a[i]*b[i];
	}
	return result;
}



