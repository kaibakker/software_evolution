module Lab1

import Prelude;
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
int methodComplexity(loc m) {
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


map[loc, int] unitSizes(M3 model) =
	(m : linesOfCodeInLoc(m) | m <- methods(model));





/* UNIT TESTS */
test bool locTest() = linesOfCode(myModel) == 5;