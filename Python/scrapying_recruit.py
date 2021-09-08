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
for i in range(plen):
    paging = driver.find_elements_by_css_selector('div.paging a.page-number')
    paging[i].click()
    time.sleep(2)

# 각 공고 접근
bbs_item = driver.find_elements_by_css_selector('li.bbs-item')
# for bbs in bbs_item:
#     print(bbs.text)
# 공고 클릭하기
bbs = bbs_item[0].find_element_by_css_selector('a')
# print(bbs.text)
# bbs.click()

# 각 공고 페이지 내용 접근
contents = driver.find_elements_by_css_selector('div.detail-content p')
# for content in contents:
#     print(content.text)



# driver.close()