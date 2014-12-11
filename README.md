# Software Evolution Lab 2: type III code clone detection

## Introduction

Based on a [2011 paper of Yuan and Guo](#references), we made a tool that detects type III clones.
Because we use a metrics based approach, we detect clones that conventional methods cannot: variables names don't matter,
the order of statements does not matter, statements can be added or deleted. The intended use of this tool is detecting plagiarism.

## Overview of approach

We analyze code on method level only.

For every variable in a method, we compute occurrences of pre-defined
situations: how often does this variable occur in an if-statement? How often is this variable added?
The resulting table is called the count matrix.

By comparing two methods, we get a similarity score. If this score exceeds a threshold, the methods are considered clones.

### An example of computing a count matrix

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

For the above method, we get:

```
numbers:
len:
sum:
i:
```

### Comparison of two methods
From the two count matrices of the methods, we construct a new matrix that
has on the x,y'th position the distance between the count vector of variable x of method 1 and variable y of method 2.
Currently we use euclidean distance.

From this matrix, we compute a similarity value of the two methods, using a quick and dirty version of the [Hungarian algorithm](http://en.wikipedia.org/wiki/Hungarian_algorithm).

### Clone classes
We consider methods to be in the same clone class if their similarity score is 1.0, i.e. the same counts on all variables. For any other similarity, clone classes are not well defined, since a similarity less than 1.0 is not an equivalence relation.

## Examples of clones
The following functions are all considered clones to the above `sumOfSquares` function.

Considered identical (all variable names and order changed):

```java
public static int somVanKwadraten(int[] getallen) {
  int lengte = getallen.length;
  int som = 0;
  for(int j = 0; j != lengte; j += 1) {
    som += getallen[j] * getallen[j];
  }
  
  return som;
}  
```

clone:

```
public static int sum(int[] numbers) {
  int lengte = numbers.length;
  int sum = 0;
  for(int i = 0; i != lengte; i += 1) {
    sum += numbers[i];
  }
  
  return sum;
}
```

## Discussion and limitations
Preliminary limitations:

- We do not detect multiple method clones.
- We have not implemented the following counts for method variables:
  1. occurences of variable in a first-level loop
  2. in a second-level loop
  3. in a third-level loop or deeper
- A metrics based approach fails on small methods. For example, getters and setters
  are considered the same methods. However, ordinary clone detectors also typically limit a clone
  to at least 6 lines of code. To limit the number of false positives, we use parameters `minimumNumberOfVariables`
  (typically 2) and `minimumNumberOfLines` (typically 6) to limit eligible methods.

### Calibration of threshold value

We have not done sufficient calibration to make a recommendation for a threshold value for the similarity score. We count clones between 0.85 and 1.0 similarity score. A lower threshold gives too many false positives. But, a lot of the false positives occur in small methods (small amount of variables and / or low counts.) It makes sense to make the threshold a function of count matrix size: for big methods, use a lower threshold than for small methods. In our experience, for small methods (2 or 3 variables) the threshold should be around 0.85 - 0.9. For bigger methods, it can be as low as 0.6. This is not done in the paper, but it should improve accuracy.

## References

Yuan, Y. & Guo, Y. CMCD: Count Matrix based Code Clone Detection, 2011 18th Asia-Pacific Software Engineering Conference.
