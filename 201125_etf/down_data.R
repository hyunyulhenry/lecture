library(httr)
library(rvest)
library(readr)
library(dpl)

gen_otp_url =
  'http://marketdata.krx.co.kr/contents/COM/GenerateOTP.jspx'

# 지수
gen_otp_data = list(
  name = 'fileDown',
  filetype = 'xls',
  url = 'MKD/03/0304/03040101/mkd03040101T2_01',
  idx_cd = '1301',
  ind_tp_cd = '1',
  idx_ind_cd = '301',
  add_data_yn = '',
  bz_dd = '20201126',
  indexname = '지수명을 입력해 주세요.',
  chartType = 'updown',
  chartStandard = 'srate',
  pagePath = '/contents/MKD/03/0304/03040101/MKD03040101T2.jsp'
)

otp = POST(gen_otp_url, query = gen_otp_data) %>%
  read_html() %>%
  html_text()

code = list(
  tabCode = 'a110dc6b3a1678330158473e0d0ffbf0',
  tabNumber = '1',
  code = otp 
)

down_url = 'http://file.krx.co.kr/download.jspx'

down_index = POST(down_url, query = code,
                   add_headers(referer = gen_otp_url))


# ETF
gen_otp_data = list(
  name = 'fileDown',
  filetype = 'csv',
  url = 'MKD/08/0801/08010700/mkd08010700_02',
  trd_dd = '20201125',
  acsString = '1',
  mkt = 'ETF',
  domforn = '00',
  uly_gubun = '00',
  gubun = '00',
  isu_cd = 'KR7122630007',
  fromdate = '20201024',
  todate = '20201124',
  gubun2 = '1',
  pagePath = '/contents/MKD/08/0801/08010700/MKD08010700.jsp'
)

otp = POST(gen_otp_url, query = gen_otp_data) %>%
  read_html() %>%
  html_text()

code = list(
  code = otp 
)

down_url = 'http://file.krx.co.kr/download.jspx'

down_index = POST(down_url, query = code,
                  add_headers(referer = gen_otp_url))

