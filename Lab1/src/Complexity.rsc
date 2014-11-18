module Complexity



map[loc, int] complexity(M3 model) =
	(m : methodComplexity(m) | m <- methods(model) );

// maybe add do
public int methodComplexity(loc m) {
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
