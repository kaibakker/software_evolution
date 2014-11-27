module Lab1

import Prelude;

import util::Math;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::\syntax::Java15;

import LinesOfCode;
import UnitSizes;
import Complexity;
import Duplication;
import Util;

public M3 myModel = createM3FromEclipseProject(|project://TestProject|);
public M3 dupModel = createM3FromEclipseProject(|project://TestDuplicationProject|);
public M3 smallSql = createM3FromEclipseProject(|project://smallsql0.21_src|);

public void analyze(M3 project) {
	locMetric = linesOfCode(project);
	complexityMetric = complexity(project);
	unitSizesMetric = unitSizes(project);
	duplicationMetric = duplication(project);

	volumeScore = volumeRisk(locMetric);
	complexityScore = complexityRisk(complexityMetric);
	unitSizesScore = unitSizeRisk(unitSizesMetric);
	duplicationScore = duplicationRisk(duplicationMetric);

 	println("PROJECT NAME: <project[0]>");
 	
 	println("");
 	
 	println("NUMBER OF FILES IN PROJECT:");
 	println( size(files(project)) );
 	
 	println("");
 	
 	println("LINES OF CODE:");
 	println(locMetric);
 	
 	println("");
 	
 	println("UNIT COMPLEXITY:");
 	prettyPrintProfile(complexityMetric);
 	
 	println("");
 	
 	println("UNIT SIZES:");
 	prettyPrintProfile(unitSizesMetric);
 	
 	println("");
 	
 	println("PERCENT OF LINES DUPLICATED:");
 	println(duplicationMetric);
 	
 	println("");
 	
 	println("RATINGS ACCORDING TO SIG:");
 	println("Volume: <stars(volumeRisk(locMetric))>");
 	println("Unit Complexity: <stars( complexityRisk(complexityMetric) )>");
 	println("Unit size: <stars( unitSizeRisk(unitSizesMetric) )>");
 	println("Duplication: <stars( duplicationRisk(duplicationMetric) )>");
 	
 	println("");
 	
 	println("SYSTEM LEVEL SCORES ACCORDING TO SIG:");
 	println("EQUAL WEIGHTS FOR RELEVANT SOURCE CODE PROPERTIES");
 	println("analysability: <stars(average([volumeScore, duplicationScore, unitSizesScore]))>");
 	println("changeability: <stars(average([complexityScore, duplicationScore]))>");
 	println("testability: <stars(average([complexityScore, unitSizesScore]))>");
}

public num average(list[int] scores) =
	sum(scores) / size(scores);



//int numberOfCommentLines(M3 project) {
//	int sum = 0;
//	for(location <- range(project@documentation)) {
//		sum += location.end.line - location.begin.line + 1;
//	}
//	return sum;
//}



public int duplication(M3 model) {
	  int blockSize = 6;
	  fileStrings = filesWithoutComments(model);
	  
	  	  
	  //list[str] regels = ([] | it + readFileLines(f) + "\ndjfkalsdjfl adslkfj asdkl" | f <- files(model));
	  //.regels = [ trim(regel) | regel <- regels, !isEmptyLine(regel) ];
	  units = ([] | it + groups(nonEmptyLines(f), blockSize) | f <- fileStrings );
	  println(units);
	  list[bool] lineNumbers = [ false | x <- units] + [false, false, false, false, false, false];
	  map[str, int] uniques = ();
	  /*
	  	  volgens mij werkt het nog niet helemaal goed,
	  	  het problleem is dat units alle blokken zijn,
	  	  maar nu we de files los bekijken 
	  	  klopt lineNumbers niet meer
			  /*
			    The truc is als volgt: we doorlopen de stringblokken in volgorde.
			    Als een blok nog niet bestaat, stoppen we het in een map unique, met
			    als value de index van het blok. 
			    Als een blok al een keer gezien is, markeren we de code van het huidige blok 
			    en de index van het oorspronkelijke blok als gedupliceerd.
			  */
	  for(int i <- [0 .. size(units)]) {
		    if(units[i] in uniques) {
		    	  
			      lineNumbers = markDuplicate(lineNumbers, i, blockSize);
			      lineNumbers = markDuplicate(lineNumbers, uniques[ units[i] ], blockSize);
		    } else {
			      uniques[ units[i] ] = i;
		    }
	  }
	  
	  for(int i <- [0 .. size(lineNumbers)]) {
		    println(i + 1);
		    println(lineNumbers[i]);
	  }
	  duplicateLineNumbers = size([ x | x <- lineNumbers, x ]);
	  if(size(lineNumbers) == 0) {
	  	  return percent(duplicateLineNumbers, size(lineNumbers));
	  } else {
	  	  return 100;
	  }
}


public list[bool] markDuplicate(lineNumbers, i, blockSize) {
	  for(j <- [i..i + blockSize]) {
	  	  if(j < size(lineNumbers)) {
		    	  lineNumbers[j] = true;
		    }
	  }
	  return lineNumbers;
}


public map[loc,str] regels(M3 model) {
	  map[loc, str] result = ();

	  for (f <- files(model)) {
		    offset = 0;
		    for (regel <- readFileLines(f)) {
			      result[f(offset,1)] = trim(regel);
			      offset += 1;
		    }
	  }
										  return result;
}

public list[str] groups(list[str] lijst, int n) {
		  if (size(lijst) < 6) return [];
	  return ([] | it + ("" | it + x | x <- lijst[i..i + n]) | i <- [0.. size(lijst) - n + 1]);
}


/* UNIT TESTS */
test bool locTest() = linesOfCode(myModel) == 5;