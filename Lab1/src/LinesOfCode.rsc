module LinesOfCode


public int linesOfCode(M3 project) = (0 | it + linesOfCodeInLoc(f) | f <- files(project));

private int linesOfCodeInLoc(loc file) = 
	size( [ line | line <- readFileLines(file), !isComment(line), !isEmptyLine(line) ] );

private bool isEmptyLine(str line) =
	isEmpty( trim(line) );

private bool isComment(str line) =
	startsWith( trim(line), "//" );


