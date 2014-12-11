module Report

import Prelude;
import util::Math;

public real threshold = 0.4;

public void createReport(list[list[real]] matrix, list[loc] methodNames, list[set[loc]] cloneClasses) {
	println("Hi, we are going to detect clones in a codebase for you!");
	println("## All the cloneClasses (clones with identical metrics):");
	for(c <- cloneClasses) {
		for(x <- c) {
			println(x);
		}
		println("");
	}
	
	numberOfClonedMethods = (0 | it + size(c) | c <- cloneClasses);
	println("Number of cloned methods: <numberOfClonedMethods>");
	println("");
	
	numberOfCloneClasses = size(cloneClasses);
	println("Number of clone classes: <numberOfCloneClasses>");
	println("");
	
	percentDuplicateMethods = percent( numberOfClonedMethods, size(methodNames));
	println("Percent of duplicate methods: <percentDuplicateMethods>");
	println("");
	
	biggestCloneClass = ({} | size(it) < size(c) ? c : it | c <- cloneClasses);
	println("The biggest clone class:");
	println(biggestCloneClass);
	println("");
	
	allClones = [ clone | klasse <- cloneClasses, clone <- klasse ];
	biggestClone = ( head(allClones) | size(readFileLines(it)) <  size(readFileLines(c)) ? c : it | c <- allClones);
	classWithBiggestClone = head( [ c | c <- cloneClasses, biggestClone in c ]);
	println("The biggest cloned method:");
	println(biggestClone);
	println("The class of the biggest cloned method:");
	println(classWithBiggestClone);
	println("");
	
	exampleCloneClass = cloneClasses[0];
	println("Example clone class: ");
	println(exampleCloneClass);
	println("");
	
	println("Methods with a difference score below the threshold (i.e. with a high similarity.):");
	
	for(i <- [0..size(matrix)] ) {
		clones = [<j, matrix[i][j]> | j <- [0..size(matrix[i]) ], matrix[i][j] < threshold, matrix[i][j] != 0.0];
		if(!isEmpty(clones) ) {
			println("<methodNames[i]> is similar to:");
			for(<j, score> <- clones ) {
				println("    <methodNames[j]> with a score of <score>");
			}
			println("");
		}
	}
	
}