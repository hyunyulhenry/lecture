
# List

List 형태는 항목(Element) 간 타입이나 길이가 달라도 데이터가 결합할 수 있습니다. 

## 리스트 생성하기


```r
l = list(1:3, 'a', c(TRUE, FALSE, TRUE), c(2.5, 4.2))
str(l)
```

```
## List of 4
##  $ : int [1:3] 1 2 3
##  $ : chr "a"
##  $ : logi [1:3] TRUE FALSE TRUE
##  $ : num [1:2] 2.5 4.2
```

첫번째 리스트는 정수, 두번째는 문자, 세번째는 논리값, 네번째는 숫자로 이루어져 있습니다.


```r
l = list(1:3, list(letters[1:5], c(TRUE, FALSE, TRUE)))
str(l)
```

```
## List of 2
##  $ : int [1:3] 1 2 3
##  $ :List of 2
##   ..$ : chr [1:5] "a" "b" "c" "d" ...
##   ..$ : logi [1:3] TRUE FALSE TRUE
```

또한 리스트 내에 리스트를 생성하는 것 역시 가능합니다.

## 기존 리스트에 데이터 추가하기


```r
l1 = list(1:3, 'a', c(TRUE, FALSE, TRUE))
str(l1)
```

```
## List of 3
##  $ : int [1:3] 1 2 3
##  $ : chr "a"
##  $ : logi [1:3] TRUE FALSE TRUE
```

```r
l2 = append(l1, list(c(2.5, 4.2)))
str(l2)
```

```
## List of 4
##  $ : int [1:3] 1 2 3
##  $ : chr "a"
##  $ : logi [1:3] TRUE FALSE TRUE
##  $ : num [1:2] 2.5 4.2
```

`append()` 함수를 이용해 기존 리스트에 추가로 리스트를 붙일 수 있습니다.


```r
l2$item4 = 'new list item'
str(l2)
```

```
## List of 5
##  $      : int [1:3] 1 2 3
##  $      : chr "a"
##  $      : logi [1:3] TRUE FALSE TRUE
##  $      : num [1:2] 2.5 4.2
##  $ item4: chr "new list item"
```

또한 기존 리스트에 달러 사인($)을 입력할 경우, 이름과 함께 리스트가 추가됩니다.

## 리스트 추출하기

리스트 역시 대괄호를 이용해 데이터를 추추할 수 있습니다.


```r
l2[1]
```

```
## [[1]]
## [1] 1 2 3
```

```r
l2[c(1,3)]
```

```
## [[1]]
## [1] 1 2 3
## 
## [[2]]
## [1]  TRUE FALSE  TRUE
```

리스트에 이름이 있을 경우, 이를 이용해 추출도 가능합니다.


```r
l2['item4']
```

```
## $item4
## [1] "new list item"
```

대괄호를 두번, 혹은 달러 사인을 이용해 데이터를 추출할 경우 결과물의 형태는 단순화되어 나타납니다.


```r
l2[[1]]
```

```
## [1] 1 2 3
```

```r
l2$item4
```

```
## [1] "new list item"
```

특정 리스트에서 항목을 추출하기 위해서는 [[와 [를 함께 사용합니다.


```r
l2[[1]]
```

```
## [1] 1 2 3
```

```r
l2[[1]][3]
```

```
## [1] 3
```
