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


	matchingMatrix = [ [ vectorSimilarity(x, y) | x <- a ] | y <- b ]; 
	return hungarian(matchingMatrix);
}

public real hungarian(list[list[int]] original) {
	
	all_rows = [0..size(original)];
	all_cols = [0..size(original[0])];
	//1: minify per row
	m = [ [entity - min(row) | entity <- row] | row <- original];
	
	//2: minify per column
	for(c <- all_cols) {
		minimum = min([m[r][c] | r <- all_rows]);

		for(r <- all_rows) {
			m[r][c] -= minimum;
		}
	}
	
	matrix = [<r, c, m[r][c]> | r <- all_rows, c <- all_cols ];
	
	while(true) {
		//3: Cover all zeros with a minimum number of lines
		columns = [];
		rows = [];
	
		for(row_number <- all_rows) {
			zeros = [<r,c> | <r,c,0> <- matrix, !(r in rows), !(c in columns), r == row_number];
			if(size(zeros) >= 2) {
				rows += row_number;
			} else if([<_, column_number>] := zeros) {
				columns += column_number;
			}
		}

		if (size(columns) + size(rows) != 4) {
			minimum = min([v | <r,c,v> <- matrix, !(r in rows), !(c in columns)]);
			matrix = [<r, c, v - minimum> | <r,c,v> <- matrix];
			matrix = [<r, c, c in columns ? v + minimum : v> | <r,c,v> <- matrix];
			matrix = [<r, c, r in rows ? v + minimum : v> | <r,c,v> <- matrix];
		} else {
			//finished
			cords = {e | row_number <- all_rows, [e] := [<r,c> | <r,c,0> <- matrix, r == row_number]}
				  + {e | col_number <- all_cols, [e] := [<r,c> | <r,c,0> <- matrix, c == col_number]};
			//cords += {e | <r,c,0> <- matrix | r == c}
			println(cords);	
			return (0.0 | it + original[r][v] | <r,v> <- cords);
		}
	}
	
	
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
	
test bool testHungarian() =
	hungarian([[82, 83, 69, 92], [77, 37, 49, 92], [11, 69, 5, 86], [8, 9, 98, 23]]) == 140;
	
