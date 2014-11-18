module Lab1

import Prelude;
import util::Math;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::\syntax::Java15;






public M3 myModel = createM3FromEclipseProject(|project://TestProject|);

public int linesOfCode(M3 project) = (0 | it + linesOfCodeInLoc(f) | f <- files(project));

private int linesOfCodeInLoc(loc file) = 
	size( [ line | line <- readFileLines(file), !isComment(line), !isEmptyLine(line) ] );

private bool isEmptyLine(str line) =
	isEmpty( trim(line) );

private bool isComment(str line) =
	startsWith( trim(line), "//" );




map[loc, int] complexity(M3 model) =
	(m : methodComplexity(m) | m <- methods(myModel) );

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
	
	units = groups(regels, blockSize);
	list[bool] lineNumbers = [true | x <- regels];
	uniques = [];
	
	for(int i <- [0 .. size(units)]) {
		if(units[i] in uniques) {
			lineNumbers = markDuplicate(lineNumbers, i, blockSize);
		} else {
			uniques += units[i];
		}
	}
	//print line numbers
	for(int i <- [0 .. size(lineNumbers)]) {
		println(i + 1);
		println(lineNumbers[i]);
	}
	uniqueLineNumbers = [x | x <- lineNumbers, x];
	return percent(size(uniqueLineNumbers), size(regels));
}


public list[bool] markDuplicate(lineNumbers, i, blockSize) {
	for(j <- [i..i + blockSize]) {
		lineNumbers[j] = false;
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