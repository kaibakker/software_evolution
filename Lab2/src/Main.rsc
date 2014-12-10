module Main

import Prelude;
import util::Math;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::\syntax::Java15;

import CountMatrix;
import Visualisation;

public M3 testProject = createM3FromEclipseProject(|project://TestProject|);
public M3 testDuplicationProject = createM3FromEclipseProject(|project://TestDuplicationProject|);
public M3 smallSql = createM3FromEclipseProject(|project://smallsql0.21_src|);

public int minimumMethodLength = 6;
public int minimumNumberOfVariables = 2;
public int maxVariableDifference = 0;

public int GLOBALE_COUNTER = 0;

public void run(M3 project) {
	methodNames = [m | m <- methods(project) , size(readFileLines(m)) >= minimumMethodLength, size(countMatrix(m)) >= minimumNumberOfVariables ];
	countMatrices = [ countMatrix(m) | m <- methodNames ];

	visualise(similarities(countMatrices), methodNames);
}

public list[list[real]] similarities(list[list[list[int]]] countMatrices) {
	
	//for (i <- [0..size(methodNames)]) {
	//	println(methodNames[1]);
	//	println(methodNames[i]);
	//	println(countMatrices[i]);
	//	println( matrixSimilarity(countMatrices[1], countMatrices[i]) );
	//}
	
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
	//println(a);
	//println(b);
	//println(matchingMatrix);
	
	// map result of hongarion onto [0, 1]
	return hungarian(matchingMatrix) / max([numberOfRows, numberOfColumns]);
}

public bool less(<_,_,x>, <_,_,y>) = x < y;

public real hungarian(list[list[real]] original) {
	//m = [ [entity - min(row) | entity <- row] | row <- original];
	
	
	
//	  all_rows = [0..size(original)];
//	  all_cols = [0..size(original[0])];
//	  //1: minify per row
//	  m = [ [entity - min(row) | entity <- row] | row <- original];
//	
//	  //2: minify per column
//	  for(c <- all_cols) {
//		    minimum = min([m[r][c] | r <- all_rows]);
//
//		    for(r <- all_rows) m[r][c] -= minimum;
//	  }
//	
	result = 0.0;
	//rows = [0..size(original)];
	rows = [true | x <- [0..size(original)] ];
	cols = [true | x <- [0..size(original[0])] ];
	matrix = sort([<r, c, original[r][c]> | r <- [0..size(original)], c <- [0..size(original[0])] ], less);
	  
	for(<r,c,v> <- matrix, rows[r], cols[c]) {
	  	result += v;
	  	rows[r] = false;
	  	cols[c] = false;
	  	
	  	//if(isEmpty(rows) || isEmpty(cols)) {
	  	//	return result;
	  	//}
	}
	return result;
	  
//	
//	  while(true) {
//		    //3: Cover all zeros with a minimum number of lines
//		    columns = [];
//		    rows = [];
//			zeros = [<r,c> | <r,c,0.0> <- matrix];
//		    for(row_number <- all_rows) {
//			      zeros = [<r,c> | <r,c,0.0> <- matrix, !(r in rows), !(c in columns), r == row_number];
//			      if(size(zeros) >= 2) {
//  				      rows += row_number;
//			      } else if([<_, column_number>] := zeros) {
//				        columns += column_number;
//			      }
//		    }
//
//		    
//		    if (size(columns) + size(rows) < min([size(original), size(original[0])])) {
//		    	  // kan empty list worden
//			      minimum = min([v | <r,c,v> <- matrix, !(r in rows), !(c in columns)]);
//			      matrix = [<r, c, v - minimum> | <r,c,v> <- matrix];
//			      matrix = [<r, c, c in columns ? v + minimum : v> | <r,c,v> <- matrix];
//			      matrix = [<r, c, r in rows ? v + minimum : v> | <r,c,v> <- matrix];
//		    } else {
//			      //finished
//			      cords = {e | row_number <- all_rows, [e] := [<r,c> | <r,c,0.0> <- matrix, r == row_number]}
//				            + {e | col_number <- all_cols, [e] := [<r,c> | <r,c,0.0> <- matrix, c == col_number]};
//				            
//			      // weet niet zeker of dit goed werkt
//			      rows_used = [r | <r,c> <- cords];
//			      columns_used = [c | <r,c> <- cords];
//			      cords += {<r,c> | <r,c,0.0> <- matrix, ! (r in rows_used), ! (c in columns_used)};
//			      
//			      
//			      return (0.0 | it + original[r][v] | <r,v> <- cords);
//		    }
//	  }
}

public real vectorSimilarity(list[int] a, list[int] b) {
	  if (vectorLength(a) > 2 * vectorLength(b) || vectorLength(b) > 2 * vectorLength(a)) {
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
	return distance(a, [0,0,0,0,0,0,0,0,0,0,0,0,0]); 
}



test bool testDistance() =
	sqrt(2) == distance([1,0,0], [0,0,1]);

test bool testVectorSimilarity() =
	141 == vectorSimilarity([1,0,0], [0,0,1]);
	
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
	
