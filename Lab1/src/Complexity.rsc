module Complexity

import Prelude;
import Util;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::\syntax::Java15;

import UnitSizes;

map[str, real] complexity(M3 model) {
	allMethods = methods(model);
	complexities = (m : methodComplexity(m) | m <- allMethods );
	sizes = (m : linesOfCodeInLoc(m) | m <- allMethods );
	linesOfCodeInMethods = ( 0.0 | it + sizes[m] | m <- allMethods );
	profile = ("low" : 0.0, "moderate" : 0.0, "high" : 0.0, "very high" : 0.0);
	numberOfMethods = size(complexities);
	
	for (method <- methods(model)) {
		evaluation = complexityEvaluation( complexities[method] );
		profile[evaluation] += sizes[method] / linesOfCodeInMethods;
	}
	return profile;
}

// maybe add do
public int methodComplexity(loc m) {
	result = 1;
	visit (getMethodASTEclipse(m)) {
		case \while (_,_) : result += 1;
		case \do (_,_) : result += 1;
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

public int complexityRisk(map[str, real] profile) {
	  if (profile["moderate"] < 0.25 && profile["high"] < 0.01 && profile["very high"] < 0.01) return 5;
	  if (profile["moderate"] < 0.30 && profile["high"] < 0.05 && profile["very high"] < 0.01) return 4;
	  if (profile["moderate"] < 0.40 && profile["high"] < 0.10 && profile["very high"] < 0.01) return 3;
	  if (profile["moderate"] < 0.50 && profile["high"] < 0.15 && profile["very high"] < 0.05) return 2;
	  return 1;
}

public str complexityEvaluation(int cc) {
 	if (cc < 10) return "low";
 	if (cc < 20) return "moderate";
 	if (cc < 50) return "high";
 	return "very high"; 
} 