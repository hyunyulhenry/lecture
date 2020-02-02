
# Data Frame

데이터프레임은 R에서 가장 널리 사용되는 형식으로써, 각 컬럼이 다른 클래스를 가질 수 있습니다.

## 데이터프레임 생성하기



```r
df = data.frame (col1 = 1:3,
                 col2 = c ("this", "is", "text"),
                 col3 = c (TRUE, FALSE, TRUE),
                 col4 = c (2.5, 4.2, pi))

str(df)
```

```
## 'data.frame':	3 obs. of  4 variables:
##  $ col1: int  1 2 3
##  $ col2: Factor w/ 3 levels "is","text","this": 3 1 2
##  $ col3: logi  TRUE FALSE TRUE
##  $ col4: num  2.5 4.2 3.14
```

col1은 숫자, col2는 팩터, col3는 논리연산자, col4는 숫자로 구성되어 있습니다. R에서는 문자형식을 자동으로 팩터로 인식하며, 이를 원하지 않을 경우 `stringsAsFactors = FALSE`를 입력합니다.


```r
df = data.frame (col1 = 1:3,
                 col2 = c ("this", "is", "text"),
                 col3 = c (TRUE, FALSE, TRUE),
                 col4 = c (2.5, 4.2, pi),
                 stringsAsFactors = FALSE)

str(df)
```

```
## 'data.frame':	3 obs. of  4 variables:
##  $ col1: int  1 2 3
##  $ col2: chr  "this" "is" "text"
##  $ col3: logi  TRUE FALSE TRUE
##  $ col4: num  2.5 4.2 3.14
```

또한 벡터 혹은 리스트를 이용해 데이터프레임을 생성할 수도 있습니다.


```r
v1 = 1:3
v2 = c ("this", "is", "text")
v3 = c (TRUE, FALSE, TRUE)

data.frame (col1 = v1, col2 = v2, col3 = v3)
```

```
##   col1 col2  col3
## 1    1 this  TRUE
## 2    2   is FALSE
## 3    3 text  TRUE
```


```r
l = list (item1 = 1:3,
          item2 = c ("this", "is", "text"),
          item3 = c (2.5, 4.2, 5.1))

l
```

```
## $item1
## [1] 1 2 3
## 
## $item2
## [1] "this" "is"   "text"
## 
## $item3
## [1] 2.5 4.2 5.1
```


```r
as.data.frame (l)
```

```
##   item1 item2 item3
## 1     1  this   2.5
## 2     2    is   4.2
## 3     3  text   5.1
```

## 기존 데이터프레임에 데이터 추가하기

`cbind()` 함수를 통해 기존 데이터프레임에 새로운 열을 추가할 수 있습니다.


```r
df
```

```
##   col1 col2  col3  col4
## 1    1 this  TRUE 2.500
## 2    2   is FALSE 4.200
## 3    3 text  TRUE 3.142
```

```r
v4 = c ("A", "B", "C")
```


```r
cbind(df, v4)
```

```
##   col1 col2  col3  col4 v4
## 1    1 this  TRUE 2.500  A
## 2    2   is FALSE 4.200  B
## 3    3 text  TRUE 3.142  C
```

`rbind()` 함수를 사용할 경우 새로운 행을 추가할 수 있습니다. 주의할 점은 각 행의 클래스가 기존 데이터와 일치해야 합니다.


```r
v5 = c (4, "R", F, 1.1)
rbind(df, v5)
```

```
##   col1 col2  col3             col4
## 1    1 this  TRUE              2.5
## 2    2   is FALSE              4.2
## 3    3 text  TRUE 3.14159265358979
## 4    4    R FALSE              1.1
```

## 데이터프레임추출하기

데이터프레임 역시 대괄호를 이용해 데이터를 추출할 수 있으며, 공백으로 둘시 모든 행(열)을 선택하게 됩니다.


```r
df
```

```
##   col1 col2  col3  col4
## 1    1 this  TRUE 2.500
## 2    2   is FALSE 4.200
## 3    3 text  TRUE 3.142
```

```r
df[2:3, ]
```

```
##   col1 col2  col3  col4
## 2    2   is FALSE 4.200
## 3    3 text  TRUE 3.142
```

컬럼 이름을 통해 데이터를 선택할 수도있습니다.


```r
df[ , c('col2', 'col4')]
```

```
##   col2  col4
## 1 this 2.500
## 2   is 4.200
## 3 text 3.142
```

만일 하나의 열만 선택시 결과가 벡터 형태로 출력되며, drop = FALSE 인자를 추가해주면 데이터프레임의 형태가 유지되어 출력됩니다.


```r
df[, 2]
```

```
## [1] "this" "is"   "text"
```

```r
df[, 2, drop = FALSE]
```

```
##   col2
## 1 this
## 2   is
## 3 text
```
