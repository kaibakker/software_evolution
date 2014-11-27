module LinesOfCode

import Util;
import Prelude;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::\syntax::Java15;

public int volumeRisk(int volume) {
 	if (volume < 66000) return 5;
 	if (volume < 246000) return 4;
 	if (volume < 665000) return 3;
 	if (volume < 1310000) return 2;
 	return 1;
}

public int linesOfCode(M3 project) {
	fileStrings = filesWithoutComments(project);
	count = 0;
	for (f <- fileStrings) {
		//println( nonEmptyLines(f) );
		count += size( nonEmptyLines(f) );
	}
  	return count;
}