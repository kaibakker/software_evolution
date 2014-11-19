module Lab1

import Prelude;

import util::Math;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::\syntax::Java15;

public M3 myModel = createM3FromEclipseProject(|project://TestProject|);
public M3 dupModel = createM3FromEclipseProject(|project://TestDuplicationProject|);

public void analyze(M3 project) {
  println("Project name: <project@names>");
  println("Lines of code: <linesOfCode(project)>");
  println("Unit complexity: <complexity(project)>");
  println("Unit sizes: <unitSizes(project)>");
  println("Percent of lines duplicated: <duplication(project)>"); 
}


public int volumeRisk(int volume) {
  if (volume < 66000) return 5;
  if (volume < 246000) return 4;
  if (volume < 665000) return 3;
  if (volume < 1310000) return 2;
  return 1;
}

public int complexityRisk(map[str, real] profile) {
	  if (profile["moderate"] < 0.25 && profile["high"] < 0.01 && profile["very high"] < 0.01) return 5;
	  if (profile["moderate"] < 0.30 && profile["high"] < 0.05 && profile["very high"] < 0.01) return 4;
	  if (profile["moderate"] < 0.40 && profile["high"] < 0.10 && profile["very high"] < 0.01) return 3;
	  if (profile["moderate"] < 0.50 && profile["high"] < 0.15 && profile["very high"] < 0.05) return 2;
	  return 1;
}

public str complexityEvaluation(int cc) {
  if (cc < 10) return "low";
  if (cc < 20) return "moderate";
  if (cc < 50) return "high";
  return "very high"; 
} 

public int linesOfCode(M3 project) =
  (0 | it + linesOfCodeInLoc(f) | f <- files(project)) - numberOfCommentLines(project);

private int linesOfCodeInLoc(loc file) = 
	  size( [ line | line <- readFileLines(file), !isEmptyLine(line) ] );

private bool isEmptyLine(str line) =
	  isEmpty( trim(line) );

private bool isComment(str line) =
	  startsWith( trim(line), "//" );

int numberOfCommentLines(M3 project) {
			  int sum = 0;
	  for(location <- range(project@documentation)) {
	    sum += location.end.line - location.begin.line + 1;
	  }
	  return sum;
	}



map[str, real] complexity(M3 model) {
	  complexities = (m : methodComplexity(m) | m <- methods(model) );
	  sizes = unitSizes(model);
	  linesOfCodeInMethods = 0.0;
	  for (method <- methods(model)) {
	  		  linesOfCodeInMethods += sizes[method];
	  }
	  numberOfMethods = size(complexities);
	  profile = ("low" : 0.0, "moderate" : 0.0, "high" : 0.0, "very high" : 0.0);
	  for (method <- methods(model)) {
	  		  evaluation = complexityEvaluation( complexities[method] );
	  		  profile[evaluation] += sizes[method] / linesOfCodeInMethods;
	  }
	  return profile;
}

// maybe add do
public int methodComplexity(loc m) {
  result = 1;
  visit (getMethodASTEclipse(m)) {
    case \while (_,_) : result += 1;
    case \if (_,_) : result +=1;
    case \if (_,_,_) : result +=1;
    case \for (_,_,_) : result += 1;
    case \for (_,_,_,_) : result += 1;
    case \foreach (_,_,_) : result += 1;
    case \switch (_,_): result += 1;
    case \case (_) : result += 1;
    case \catch(_,_) : result += 1;
  }
  return result;
}


public map[loc, int] unitSizes(M3 model) =
	  (m : linesOfCodeInLoc(m) | m <- methods(model));



public int duplication(M3 model) {
	  int blockSize = 6;
	  list[str] regels = ([] | it + readFileLines(f) | f <- files(model));
	  regels = [ trim(regel) | regel <- regels, !isEmptyLine(regel) ];
	  units = groups(regels, blockSize);
	  
	  list[bool] lineNumbers = [ false | x <- regels];
	  map[str, int] uniques = ();
	
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
	  //print line numbers
	  //for(int i <- [0 .. size(lineNumbers)]) {
		 //   println(i + 1);
		 //   println(lineNumbers[i]);
	  //}
	  duplicateLineNumbers = size([ x | x <- lineNumbers, x ]);
	  return percent(duplicateLineNumbers, size(regels));
}


public list[bool] markDuplicate(lineNumbers, i, blockSize) {
	  for(j <- [i..i + blockSize]) {
		    lineNumbers[j] = true;
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

public list[str] groups(list[str] lijst, int n) =
	([] | it + ("" | it + x | x <- lijst[i..i + n]) | i <- [0.. size(lijst) - n + 1]);


/* UNIT TESTS */
test bool locTest() = linesOfCode(myModel) == 5;