module CloneClasses

import Prelude;

public list[set[loc]] cloneClasses(list[list[real]] matrix, list[loc] methodNames) {
	classes = [ r + { c | c <- [0..size(matrix[r])], matrix[r][c] == 0.0 } | r <- [0..size(matrix)] ];
	classes = [ c | c <- classes, size(c) > 1 ];
	
	// subsume
	return  [ { methodNames[c] | c <- cloneClass} | cloneClass <- classes, !isStrictSubsetOf(classes, cloneClass) ];
}

public bool isStrictSubsetOf(list[set[int]] classes, set[int] cloneClass) {
	for(class <- classes) {
		if (cloneClass < class) return true;
	}
	return false;
}