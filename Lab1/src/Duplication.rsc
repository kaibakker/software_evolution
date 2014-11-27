module Duplication

import Prelude;

import util::Math;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::\syntax::Java15;

import UnitSizes;
import Util;

public int duplicationRisk(int dup) {
	if (dup < 3) return 5;
	if (dup < 5) return 4;
	if (dup < 10) return 3;
	if (dup < 20) return 2;
	return 1;
}

public int duplication(M3 model) {
	int blockSize = 6;
	fileStrings = filesWithoutComments(model);
	allFiles = 	( "" | it + f | f <- fileStrings );
	allLines = nonEmptyLines(allFiles);
	
	//println(size(allLines));
	
	units = groups(allLines, blockSize);
	//list[str] regels = ([] | it + readFileLines(f) + "\ndjfkalsdjfl adslkfj asdkl" | f <- files(model));
	//.regels = [ trim(regel) | regel <- regels, !isEmptyLine(regel) ];
	//units = ([] | it + groups(nonEmptyLines(f), blockSize) | f <- fileStrings );
	//println(units);
	
	list[bool] lineNumbers = [ false | x <- allLines];
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
	  
	//for(int i <- [0 .. size(lineNumbers)]) {
	//	println(i + 1);
	//	println(lineNumbers[i]);
	//}
	duplicateLineNumbers = size([ x | x <- lineNumbers, x ]);
	return percent(duplicateLineNumbers, size(lineNumbers));
}


public list[bool] markDuplicate(lineNumbers, i, blockSize) {
	for(j <- [i..i + blockSize]) {
		lineNumbers[j] = true;
	}
	return lineNumbers;
}

public list[str] groups(list[str] lijst, int n) {
	if (size(lijst) < n) return [("" | it + x | x <- lijst)];
	return ([] | it + ("" | it + x | x <- lijst[i..i + n]) | i <- [0.. size(lijst) - n + 1]);
}
