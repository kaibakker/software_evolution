module Visualisation

import vis::Figure;
import vis::Render;
import Prelude;

public real threshold = 0.4;

public void visualise(list[list[real]] matrix, list[loc] methodNames) {
	for( i <- [0..size(methodNames)]) {
		clones = [j | j <- [0..i], matrix[i][j] < threshold];
		if(!isEmpty(clones)) {
			println("<methodNames[i]> lijkt op:");
			for(j <- clones) println("    <methodNames[j]> : <matrix[i][j]>");
			println("");
		}
	}
} 