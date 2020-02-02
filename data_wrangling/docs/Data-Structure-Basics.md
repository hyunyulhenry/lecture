
# (PART) 데이터 구조 다루기 {-}

# Data Structure Basics

R의 데이터구조는 크게 벡터, 리스트, 매트릭스, 데이터프레임으로 나누어집니다. (array는 잘 사용되지 않습니다) 

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:center;"> Dimension </th>
   <th style="text-align:center;"> Homogeneous </th>
   <th style="text-align:center;"> Heterogeneous </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> 1D </td>
   <td style="text-align:center;"> Atomic Vector </td>
   <td style="text-align:center;"> List </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 2D </td>
   <td style="text-align:center;"> Matrix </td>
   <td style="text-align:center;"> Data frame </td>
  </tr>
  <tr>
   <td style="text-align:center;"> nD </td>
   <td style="text-align:center;"> Array </td>
   <td style="text-align:center;">  </td>
  </tr>
</tbody>
</table>

Homogenous는 컬럼간 데이터 구조가 같은 경우, Heterogeneous는 다른 경우입니다.

## 구조 파악하기

`str()` 함수를 이용해 각 데이터의 구조(structure)를 파악할 수 있습니다.


```r
vector = 1:10
list = list(item1 = 1:10, item2 = LETTERS[1:18])
matrix = matrix(1:12, nrow = 4)
df = data.frame(item1 = 1:18, item2 = LETTERS[1:18])
```


```r
vector
```

```
##  [1]  1  2  3  4  5  6  7  8  9 10
```

```r
str(vector)
```

```
##  int [1:10] 1 2 3 4 5 6 7 8 9 10
```

```r
list
```

```
## $item1
##  [1]  1  2  3  4  5  6  7  8  9 10
## 
## $item2
##  [1] "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R"
```

```r
str(list)
```

```
## List of 2
##  $ item1: int [1:10] 1 2 3 4 5 6 7 8 9 10
##  $ item2: chr [1:18] "A" "B" "C" "D" ...
```

```r
matrix
```

```
##      [,1] [,2] [,3]
## [1,]    1    5    9
## [2,]    2    6   10
## [3,]    3    7   11
## [4,]    4    8   12
```

```r
str(matrix)
```

```
##  int [1:4, 1:3] 1 2 3 4 5 6 7 8 9 10 ...
```

```r
df
```

```
##    item1 item2
## 1      1     A
## 2      2     B
## 3      3     C
## 4      4     D
## 5      5     E
## 6      6     F
## 7      7     G
## 8      8     H
## 9      9     I
## 10    10     J
## 11    11     K
## 12    12     L
## 13    13     M
## 14    14     N
## 15    15     O
## 16    16     P
## 17    17     Q
## 18    18     R
```

```r
str(df)
```

```
## 'data.frame':	18 obs. of  2 variables:
##  $ item1: int  1 2 3 4 5 6 7 8 9 10 ...
##  $ item2: Factor w/ 18 levels "A","B","C","D",..: 1 2 3 4 5 6 7 8 9 10 ...
```

