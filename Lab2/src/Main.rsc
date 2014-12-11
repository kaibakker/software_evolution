module Main

import Prelude;
import util::Math;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::\syntax::Java15;

import CountMatrix;
import Visualisation;
import Report;
import CloneClasses;

public M3 testProject = createM3FromEclipseProject(|project://TestProject|);
public M3 testDuplicationProject = createM3FromEclipseProject(|project://TestDuplicationProject|);
public M3 smallSql = createM3FromEclipseProject(|project://smallsql0.21_src|);

public int minimumMethodLength = 2;
public int minimumNumberOfVariables = 0;
public int maxVariableDifference = 1;

public int GLOBALE_COUNTER = 0;

public void run(M3 project) {
	methodNames = [m | m <- methods(project) , size(readFileLines(m)) >= minimumMethodLength, size(countMatrix(m)) >= minimumNumberOfVariables ];
	countMatrices = [ countMatrix(m) | m <- methodNames ];

	similarityMatrix = similarities(countMatrices);

	visualise(similarityMatrix, methodNames);
	
	list[set[loc]] classes = cloneClasses(similarityMatrix, methodNames);
	
	createReport(similarityMatrix, methodNames, classes);
}

public list[list[real]] similarities(list[list[list[int]]] countMatrices) {
	numberOfMethods = size(countMatrices);
	
	return [ [ matrixSimilarity(countMatrices[i], countMatrices[j]) | j <- [0..i] ] | i <- [0..numberOfMethods] ];
}

public real matrixSimilarity(list[list[int]] a, list[list[int]] b) {
	numberOfRows = size(a);
	numberOfColumns = size(b);
	
	if (GLOBALE_COUNTER % 1000 == 0) println(GLOBALE_COUNTER);
	GLOBALE_COUNTER += 1;
	
	if (abs(numberOfRows - numberOfColumns) > maxVariableDifference) { return 1.0; }
		
	matchingMatrix = [ [ vectorSimilarity(x, y) | x <- a ] | y <- b ]; 

	
	// map result of hongarion onto [0, 1]
	return hungarian(matchingMatrix) / max([numberOfRows, numberOfColumns]);
}

public bool less(<_,_,x>, <_,_,y>) = x < y;

public real hungarian(list[list[real]] original) {
	number_of_rows = size(original);
	number_of_cols = size(original[0]);
	
	rows = [true | x <- [0..number_of_rows] ];
	cols = [true | x <- [0..number_of_cols] ];
	matrix = sort([<r, c, original[r][c]> | r <- [0..number_of_rows], c <- [0..number_of_cols] ], less);
	 
	count = min(number_of_rows, number_of_cols);
	
	result = 0.0;
	for(<r,c,v> <- matrix, rows[r], cols[c]) {
	  	result += v;
	  	rows[r] = false;
	  	cols[c] = false;
	  	
	  	count -= 1;
	  	if(count == 0) return result;
	}
	return result;

}

public real vectorSimilarity(list[int] a, list[int] b) {
	length_a = vectorLength(a);
	length_b = vectorLength(b);
	  if (length_a > 2 * length_b || length_b > 2 * length_a) {
		    return 1.0;
	  }
	  // we map the vector distance to a monotonic function with range [0..1]
	  return 1.0 - (1.0 / (1.0 + distance(a, b)));

}

public real distance(list[int] a, list[int] b) {
	  int length = min( [size(a), size(b)] );
	  
	  return wortel((0 | it + (a[i] - b[i])*(a[i] - b[i]) | i <- [0..length]));
}

public real wortel(waarde) {
	if(waarde == 0) {
		return 0.0;
	} else {
		return sqrt(waarde);
	}
}

public real vectorLength(list[int] a) {
	return wortel((0 | it + x*x | x <- a)); 
}

test bool testWortelZero() =
	wortel(0) == 0.0;

test bool testWortelFour() = 
	wortel(4) == 2.0;
	
test bool testWortelArb(int x) = 
	x == 0 || wortel(abs(x)) == sqrt(abs(x));
	
test bool testMatrixSimilarity() =
	matrixSimilarity([[1]], [[2]]) == 0.5;
	
test bool testDistance() =
	sqrt(2) == distance([1,0,0], [0,0,1]);

test bool testVectorSimilarity() =
	0.58578643761 == vectorSimilarity([1,0,0], [0,0,1]);
	
test bool testVectorSimilarityWithBigLengthDifference() =
	1.0 == vectorSimilarity([5,0,0], [2,0,0]);

test bool testVectorLength() =
	sqrt(2) == vectorLength([1,1,0]);
	
test bool testMatrixSimilarity() =
	matrixSimilarity([[0,1], [2,3]], [[0,1], [2,3]]) == 0.0;
	
test bool testHungarian() =
	hungarian([[82.0, 83.0, 69.0, 92.0], [77.0, 37.0, 49.0, 92.0], [11.0, 69.0, 5.0, 86.0], [8.0, 9.0, 98.0, 23.0]]) == 142.0;

test bool testHungarian2() =
	hungarian([[10.0, 100.0], [100.0, 10.0], [100.0, 100.0]])  == 20.0;


