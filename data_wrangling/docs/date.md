
# Date

날짜, 시간에 관련된 데이터는 R의 기본함수 및 `lubridate` 패키지를 이용해 쉽게 다룰 수 있습니다.

## 현재 날짜 및 시간 


```r
Sys.timezone()
```

```
## [1] "Etc/UTC"
```

```r
Sys.Date()
```

```
## [1] "2020-02-02"
```

```r
Sys.time()
```

```
## [1] "2020-02-02 09:29:56 UTC"
```

기본 함수를 통해 현재 타임존 및 날짜, 시간을 확인할 수 있습니다.

## 문자열을 날짜로 변경하기



```r
x = c('2015-07-01', '2015-08-01', '2015-09-01')
x_date = as.Date(x)
str(x_date)
```

```
##  Date[1:3], format: "2015-07-01" "2015-08-01" "2015-09-01"
```

`as.Date()` 함수를 이용할 경우, 문자열 형태가 Date로 변경됩니다.


```r
y = c('07/01/2015', '08/01/2015', '09/01/2015')
as.Date(y, format = '%m/%d/%Y')
```

```
## [1] "2015-07-01" "2015-08-01" "2015-09-01"
```

YYYY-MM-DD 형태가 아닌 다른 형태로 입력된 경우, format을 직접 입력하여 Date 형태로 변경할 수 있습니다.


```r
library(lubridate)
ymd(x)
```

```
## [1] "2015-07-01" "2015-08-01" "2015-09-01"
```

```r
mdy(y)
```

```
## [1] "2015-07-01" "2015-08-01" "2015-09-01"
```

`lubridate` 패키지를 이용할 경우 YYYY-MM-DD 형태는 `ymd()`, MM-DD-YYYY 형태는 `mdy()` 함수를 사용해 손쉽게 Date 형태로 변경할 수 있습니다. 이 외에도 lubridate에는 Date 형태로 변경하기 위한 다양한 함수가 존재합니다.

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:center;"> 순서 </th>
   <th style="text-align:center;"> 함수 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> year, month, day </td>
   <td style="text-align:center;"> ymd() </td>
  </tr>
  <tr>
   <td style="text-align:center;"> year, day, month </td>
   <td style="text-align:center;"> ydm() </td>
  </tr>
  <tr>
   <td style="text-align:center;"> month, day, year </td>
   <td style="text-align:center;"> mdy() </td>
  </tr>
  <tr>
   <td style="text-align:center;"> day, month, year </td>
   <td style="text-align:center;"> dmy() </td>
  </tr>
  <tr>
   <td style="text-align:center;"> hour, minute </td>
   <td style="text-align:center;"> hm() </td>
  </tr>
  <tr>
   <td style="text-align:center;"> hour, minute, second </td>
   <td style="text-align:center;"> hms() </td>
  </tr>
  <tr>
   <td style="text-align:center;"> year, month, day, hour, minute, secod </td>
   <td style="text-align:center;"> ymd_hms() </td>
  </tr>
</tbody>
</table>

## 날짜 관련 정보 추출

`lubridate` 패키지에는 날짜 관련 정보를 추출할 수 있는 다양한 함수가 존재합니다.

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:center;"> 정보 </th>
   <th style="text-align:center;"> 함수 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> Year </td>
   <td style="text-align:center;"> year() </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Month </td>
   <td style="text-align:center;"> month() </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Week </td>
   <td style="text-align:center;"> week() </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Day of year </td>
   <td style="text-align:center;"> yday() </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Day of month </td>
   <td style="text-align:center;"> mday() </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Day of week </td>
   <td style="text-align:center;"> wday() </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Hour </td>
   <td style="text-align:center;"> hour() </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Minute </td>
   <td style="text-align:center;"> minute() </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Second </td>
   <td style="text-align:center;"> second() </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Time zone </td>
   <td style="text-align:center;"> tz() </td>
  </tr>
</tbody>
</table>


```r
x = c('2015-07-01', '2015-08-01', '2015-09-01')
```


```r
year(x)
```

```
## [1] 2015 2015 2015
```

```r
month(x)
```

```
## [1] 7 8 9
```

```r
week(x)
```

```
## [1] 26 31 35
```

`year()`, `month()`, `week()` 함수를 통해 년도, 월, 주 정보를 확인할 수 있습니다.


```r
z = '2015-09-15'
```


```r
yday(z)
```

```
## [1] 258
```

```r
mday(z)
```

```
## [1] 15
```

```r
wday(z)
```

```
## [1] 3
```

`yday()`, `mday()`, `wday()` 함수는 각각 해당 년도에서 몇번째 일인지, 해당 월에서 몇번째 일인지, 해당 주에서 몇번째 일인지를 계산합니다.


```r
x = ymd('2015-07-01', '2015-08-01', '2015-09-01') 
x + years(1) - days(c(2, 9, 21))
```

```
## [1] "2016-06-29" "2016-07-23" "2016-08-11"
```

날짜에서 년도와 월, 일자를 더하거나 빼는 계산 역시 가능합니다.

## 날짜 순서 생성하기

`seq()` 함수를 이용할 경우 날짜 벡터를 생성할 수도 있습니다.


```r
seq(ymd('2010-01-01'), ymd('2015-01-01'), by ='years')
```

```
## [1] "2010-01-01" "2011-01-01" "2012-01-01" "2013-01-01" "2014-01-01"
## [6] "2015-01-01"
```

2010년 1월 1일부터 2015년 1월 1일까지 1년을 기준으로 벡터가 생성됩니다.


```r
seq(ymd('2010-09-01'), ymd('2010-09-30'), by ='2 days')
```

```
##  [1] "2010-09-01" "2010-09-03" "2010-09-05" "2010-09-07" "2010-09-09"
##  [6] "2010-09-11" "2010-09-13" "2010-09-15" "2010-09-17" "2010-09-19"
## [11] "2010-09-21" "2010-09-23" "2010-09-25" "2010-09-27" "2010-09-29"
```

지정 일수만큼 벡터를 생성할 수도 있습니다.
