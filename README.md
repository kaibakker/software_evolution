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

For each variable, we currently tally:

1. number of uses
2. number of additions and subtractions it appears in
3. number of multiplications and divisions it appears in
4. number of times invoked as a parameter
5. number of times it appears in an if-statement
6. number of times it appears as an array subscript
7. number of times it is defined
8. number of times it is defined by an add or subtract operation
9. number of times it is defined by a multiply or divide operation
10. number of times it is defined by an expression which has constants in it

For the above method, we would get:





Yuan, Y. & Guo, Y. CMCD: Count Matrix based Code Clone Detection, 2011 18th Asia-Pacific Software Engineering Conference.
