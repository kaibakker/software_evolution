module Main

import Prelude;
import util::Math;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::\syntax::Java15;

public M3 testProject = createM3FromEclipseProject(|project://TestProject|);
public M3 testDuplicationProject = createM3FromEclipseProject(|project://TestDuplicationProject|);

data Matrix = matrix(int r, int c, int val);

Matrix d = matrix(0, 0, 1);

public list[list[real]] similarities(M3 project) {
	countMatrices = [ countMatrix(m) | m <- methods(project) ];
	return [ [ matrixSimilarity(a, b) | a <- countMatrices ] | b <- countMatrices ];
}



public real matrixSimilarity(list[list[int]] a, list[list[int]] b) {

	matchingMatrix = [ [ vectorSimilarity(x, y) | x <- a ] | y <- b ]; 
	return hungarian(matchingMatrix);
}

public real hungarian(list[list[int]] m) {

	[ [entity - min(row) | entity <- row] | row <- m];
	return 10.0;
}

/*
	Here, we have just used the distance. The similarity is not neccessarily between 0 and 1.
	TODO: devise some normalizing function.
*/
public real vectorSimilarity(list[int] a, list[int] b) {
	if (vectorLength(a) > 2 * vectorLength(b) || vectorLength(b) > 2 * vectorLength(a)) {
		return 0.0;
	}
	
	return distance(a, b);
}

public real distance(list[int] a, list[int] b) {
	int length = min( size(a), size(b) );
	return sqrt( (0 | it + (a[i] - b[i])*(a[i] - b[i]) | i <- [0..length]) );
}

public real vectorLength(list[int] a) {
	origin = [ 0 | x <- a ];
	return distance(a, origin); 
}

test bool testDistance() =
	sqrt(2) == distance([1,0,0], [0,0,1]);

test bool testVectorSimilarity() =
	sqrt(2) == vectorSimilarity([1,0,0], [0,0,1]);
	
test bool testVectorSimilarityWithBigLengthDifference() =
	0.0 == vectorSimilarity([5,0,0], [2,0,0]);

test bool testVectorLength() =
	sqrt(2) == vectorLength([1,1,0]);
	
test bool testMatrixSimilarity() =
	matrixSimilarity([[0,1], [2,3]], [[0,1], [2,3]]) == 0.0;

test bool testMatrixSimilarity() =
	matrixSimilarity([[0,1], [2,3]], [[0,1], [2,3]]) == 0.0;
	