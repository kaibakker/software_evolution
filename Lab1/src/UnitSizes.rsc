module UnitSizes

import Prelude;

import Util;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::\syntax::Java15;

public map[str, real] unitSizes(M3 model) {
	numberOfMethods = size( methods(model) );
  
	profile = ("S" : 0.0, "M" : 0.0, "L" : 0.0, "XL" : 0.0);
	for (m <- methods(model)) {
		evaluation = unitSizeEvaluation( linesOfCodeInLoc(m) );
		profile[evaluation] += 1.0 / numberOfMethods; 
	}
	return profile;
}

public int unitSizeRisk(map[str, real] profile) {
	if (profile["M"] < 0.25 && profile["L"] < 0.01 && profile["XL"] < 0.01) return 5;
	if (profile["M"] < 0.30 && profile["L"] < 0.05 && profile["XL"] < 0.01) return 4;
	if (profile["M"] < 0.40 && profile["L"] < 0.10 && profile["XL"] < 0.01) return 3;
	if (profile["M"] < 0.50 && profile["L"] < 0.15 && profile["XL"] < 0.05) return 2;
	return 1;
}

public str unitSizeEvaluation(int regels) {
	if (regels < 20) return "S";
	if (regels < 50) return "M";
	if (regels < 100) return "L";
	return "XL";
}