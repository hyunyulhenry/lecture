
# Character Strings

문자열은 R의 기본함수 및`stringr` 패키지를 이용해 쉽게 다룰 수 있습니다.

## 문자열 기본


```r
a = 'learning to create'
b = 'character strings'
paste(a, b)
```

```
## [1] "learning to create character strings"
```

`paste()` 함수를 이용해 두 문자를 붙일 수 있습니다.


```r
paste('pi is', pi)
```

```
## [1] "pi is 3.14159265358979"
```

R에서 pi는 숫자로 입력되어 있으며, `paste()` 함수를 통해 문자열과 숫자를 붙일수도 있습니다.


```r
paste('I', 'love', 'R', sep = '-')
```

```
## [1] "I-love-R"
```

sep 인자를 추가할 경우, 각 단어를 구분하는 문자를 입력할 수 있습니다.


```r
paste0('I', 'love', 'R')
```

```
## [1] "IloveR"
```

`paste0()` 함수는 구분 문자가 없이 결합됩니다.

## 문자열 출력

문자를 출력하는데 다음과 같은 함수가 있습니다.

- `print()`: 기본적인 출력 함수
- `noquote()`: 쿼트("") 생략
- `cat()`: 문자열 결합 및 쿼트 생략


```r
x = 'learning to print strings'
print(x)
```

```
## [1] "learning to print strings"
```

```r
print(x, quote = 'FALSE')
```

```
## [1] learning to print strings
```

`print()` 함수를 이용해 기본적인 출력을 할 수 있으며, quote 인자를 FALSE로 지정하여 쿼트를 생략할 수도 있습니다.


```r
noquote(x)
```

```
## [1] learning to print strings
```

`noquote()` 함수를 이용할 경우 쿼트가 출력되지 않습니다.


```r
cat(x)
```

```
## learning to print strings
```

```r
cat(x, 'in R')
```

```
## learning to print strings in R
```

`cat()` 함수를 이용할 경우도 출력이 가능하며, 여러 문자를 결합한 뒤 출력하는 것 또한 가능합니다.

## 문자열 갯수 확인


```r
x = 'How many elements are in this string?'

length(x)
```

```
## [1] 1
```

`length()` 함수의 경우 element의 갯수를 세므로, 1이 출력됩니다.


```r
nchar(x)
```

```
## [1] 37
```

반면 `nchar()` 함수를 이용하여 문장 내 문자의 갯수를 셀 수 있습니다.

## `stringr` 패키지를 이용한 문자열 다루기

R의 기본함수를 이용하여도 문자열을 다룰 수 있지만, `stringr` 패키지를 이용할 경우 더욱 작업을 수행할 수 있습니다.

### 기본 사용법


```r
library(stringr)

str_c('Learning', 'to', 'use', 'the', 'stringr', 'package')
```

```
## [1] "Learningtousethestringrpackage"
```

`str_c()` 함수는 `paste0()`와 기능이 동일합니다.


```r
library(stringr)

str_c('Learning', 'to', 'use', 'the', 'stringr', 'package', sep = ' ')
```

```
## [1] "Learning to use the stringr package"
```

sep 인자를 통해 구분자를 추가할 수 있으며, 이는 `paste()`와 동일합니다.


```r
text = c('Learning', 'to', NA, 'use', 'the', NA, 'stringr', 'package')

str_length(text)
```

```
## [1]  8  2 NA  3  3 NA  7  7
```

`str_length()` 함수는 문자의 갯수를 셉니다.


```r
x = 'Learning to use the stringr package'

str_sub(x, start = 1, end = 15)
```

```
## [1] "Learning to use"
```

`str_sub()` 함수는 start부터 end까지의 문자를 출력합니다.


```r
str_sub(x, start = -7, end = -1)
```

```
## [1] "package"
```

start 혹은 end에 음수를 입력하면, 문장의 맨 끝에서부터 start/end 지점이 계산됩니다.


```r
str_dup('beer', times = 3)
```

```
## [1] "beerbeerbeer"
```

`str_dub()` 함수를 이용해 특정 문자를 반복되게 출력할 수 있습니다.

### 공백(Whitespace) 제거

텍스트 데이터를 다룰때는 빈 공백이 따라오는 경우가 많으며, 데이터분석의 편이를 위해 이를 제거해야 합니다.


```r
text = c('Text ', ' with', ' whitespace ', ' on', 'both ', 'sides ')

print(text)
```

```
## [1] "Text "        " with"        " whitespace " " on"          "both "       
## [6] "sides "
```

각 단어의 좌/우 혹은 양쪽에 공백이 있습니다.


```r
str_trim(text, side = 'left')
```

```
## [1] "Text "       "with"        "whitespace " "on"          "both "      
## [6] "sides "
```

```r
str_trim(text, side = 'right')
```

```
## [1] "Text"        " with"       " whitespace" " on"         "both"       
## [6] "sides"
```

```r
str_trim(text, side = 'both')
```

```
## [1] "Text"       "with"       "whitespace" "on"         "both"      
## [6] "sides"
```

`str_trim()` 함수를 통해 좌/우/양쪽의 공백을 제거할 수 있습니다.

### 문자열 자리수 채우기

원하는 자리수를 채우기 위해 문자열에 공백 혹은 특정 문자를 입력할 수 있습니다.


```r
str_pad('beer', width = 10, side = 'left')
```

```
## [1] "      beer"
```

10자리를 맞추기 위해 좌측에 공백이 추가되었습니다.


```r
str_pad('beer', width = 10, side = 'left', pad = '!')
```

```
## [1] "!!!!!!beer"
```

pad 인자를 추가할 경우, 공백이 아닌 해당 문자가 추가됩니다.



