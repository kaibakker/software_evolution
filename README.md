# Software Evolution Lab 2: type III code clone detection

## Introduction

Based on a 2011 paper of Yuan and Guo, we have made a tool that detects type III clones.
Because we use a metrics based approach, we detect clones that conventional methods cannot: variables names don't matter,
the order of statements does not matter, lines can be added or deleted. The intended use of this tool is plagiarism detection.

## Overview of method

We analyze code on method level only.

For every variable in a method, we compute occurances of pre-defined
situations: how often does this variable occur in an if-statement? How often is this variable added?
The resulting table is called the count matrix.

By comparing two methods, we get a similarity score. If this score exceeds a threshold, the methods are considered clones.

An example: 

```java
public static int sumOfSquares(int[] numbers) {
  int len = numbers.length;
  int sum = 0;
  for(int i = 0; i != len; i += 1) {
    sum += numbers[i] * numbers[i];
  }
  
  return sum;
}
```


Yuan, Y. & Guo, Y. CMCD: Count Matrix based Code Clone Detection, 2011 18th Asia-Pacific Software Engineering Conference.
