# Selenium import
from selenium import webdriver

import time

# USB 관련 에러 처리
options = webdriver.ChromeOptions()
options.add_experimental_option("excludeSwitches", ["enable-logging"])

# 크롬 드라이버 생성
driver = webdriver.Chrome('./Python/chromedriver.exe', options=options)

# 사이트 접속하기
driver.get('http://job2.wadiz.kr/recruit/info2')

time.sleep(2)

# 직무 코드 scraping
codes = driver.find_elements_by_css_selector('a.fake-menu')
# for code in codes:
#     print(code.text)
#############################################################

# 공고 처리

# 공고 페이지네이션 접근
paging = driver.find_elements_by_css_selector('div.paging a.page-number')
# for page in paging:
#     print(page.text)


# 3번째에서 안됨 뭐가 문제인지 모르겠음
# for page in paging:
#     print(page)
    # page.click()
    # time.sleep(1)

# 이것도 안됨
# plen = print(len(paging))
#driver.execute_script("pager.goPage(2)")

plen = len(paging)

# 매 클릭마다 다시 찾는걸로 변경
# for i in range(plen):
#     paging = driver.find_elements_by_css_selector('div.paging a.page-number')
#     paging[i].click()
    
#     time.sleep(2)

# 각 공고 접근
bbs_item = driver.find_elements_by_css_selector('li.bbs-item')
# for bbs in bbs_item:
#     print(bbs.text)
# 공고 클릭하기
bbs = bbs_item[1].find_element_by_css_selector('a')

# bbs_code = bbs_item[0].find_element_by_css_selector('span.col-sub-title').text
# bbs_title = bbs_item[0].find_element_by_css_selector('span.col-title').text
# bbs_time = bbs_item[0].find_element_by_css_selector('a.col-flag').text
# bbs_date = bbs_item[0].find_element_by_css_selector('span.col-span').text

# print(f'{bbs_code} {bbs_title} {bbs_time} {bbs_date}')

# print(bbs.text)
bbs.click()
# time.sleep(2)
# driver.back() # 뒤로가기

# 각 공고 페이지 내용 접근
contents = driver.find_elements_by_css_selector('div.detail-content p')
# print(contents.text)

temp = ''
for content in contents:
    temp += content.text

# 문자열 처리
# print(temp)
c1, c2, c3, c4, c5 = temp.split('[')
c1 = c1[c1.find(']')+1:]
c2 = c2[c2.find(']')+1:]
c3 = c3[c3.find(']')+1:]
c4 = c4[c4.find(']')+1:]
c6 = c5[c5.find('**기타 사항')+len('**기타 사항'):]
c5 = c5[c5.find(']')+1:c5.find('**')-1]
# print(c1)
# print(c2)
# print(c3)
# print(c4)
# print(c5)
# print(c6)

driver.close()