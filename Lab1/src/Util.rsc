module Util

import Prelude;

import util::Math;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::\syntax::Java15;

public list[str] filesWithoutComments(M3 model) {
	result = [];
	for (f <- files(model)) {
		str content_file = readFile(f);
		set[loc] documentations = model@documentation[f];
		for(d <- documentations) {
			content_file = content_file[0..(d.offset)] + left(" ",  d.length) + content_file[(d.offset + d.length)..];
		}
		result += content_file; 
	}
  
	return result;
}

public list[str] nonEmptyLines(str file) =
	[line | line <- split("\n", file) , !isEmptyLine(line)];

public bool isEmptyLine(str line) =
	isEmpty( trim(line) );

public bool isComment(str line) =
	startsWith( trim(line), "//" );
	
public int linesOfCodeInLoc(loc file) = 
	size( [ line | line <- readFileLines(file), !isComment(line), !isEmptyLine(line) ] );
	
public void prettyPrintProfile(map[str, real] profile) {
	for (key <- profile) {
		println("<key> : <profile[key]>");
	}
}

public str stars(num n) {
	return left("", round(n), "★");
}

test bool nonEmptyLinesTest() = size(nonEmptyLines((myModel))) == 15;