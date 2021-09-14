# Selenium import
from selenium import webdriver

import time

# USB 관련 에러 처리
options = webdriver.ChromeOptions()
options.add_experimental_option("excludeSwitches", ["enable-logging"])

# 크롬 드라이버 생성
driver = webdriver.Chrome('./Python/chromedriver.exe', options=options)

# 사이트 접속하기
driver.get('https://www.wadiz.kr/web/wreward/main?keyword=&endYn=ALL&order=recommend')

time.sleep(2)

# 스크롤 내리기
# 스크롤 높이 가져옴
# last_height = driver.execute_script("return document.body.scrollHeight")
# driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")

# lazy loading 먹이려면 일일히 내려가야함
# from selenium.webdriver.common.keys import Keys

# repeat = 8

# for _ in range(repeat * 5):
#     driver.find_element_by_tag_name('body').send_keys(Keys.PAGE_DOWN)
#     time.sleep(1)

## codes
# codes = driver.find_elements_by_css_selector('div.CategoryCircleList_list__2YBF3 a')

# code_list = []

# for code in codes:
#     # print(code.text)
#     if code.text != '':
#         code_list.append(code.text)
    
# # code next button 
# driver.find_element_by_css_selector('#main-app > div.MainWrapper_content__GZkTa > div > div.RewardCategoryCircleList_container__1GDge > div > button.CategoryCircleList_next__1mHyX').click()
# time.sleep(2)

# codes = driver.find_elements_by_css_selector('div.CategoryCircleList_list__2YBF3 a')

# for code in codes:
#     # print(code.text)
#     if code.text != '':
#         code_list.append(code.text)
    
# print(code_list)

import os

# codes 이미지 다운받기
code_list = []

codes = driver.find_elements_by_css_selector('div.CategoryCircleList_list__2YBF3 a')

for code in codes:
    # print(code.text)
    if code.text != '':
        code_list.append(code)
    
# code next button 
driver.find_element_by_css_selector('#main-app > div.MainWrapper_content__GZkTa > div > div.RewardCategoryCircleList_container__1GDge > div > button.CategoryCircleList_next__1mHyX').click()
time.sleep(2)

codes = driver.find_elements_by_css_selector('div.CategoryCircleList_list__2YBF3 a')

for code in codes:
    # print(code.text)
    if code.text != '':
        code_list.append(code)

# for code in codes:
# code = codes[0]
# code_img = code.find_element_by_css_selector('span.CategoryCircle_circle__3khwj').get_attribute('style')
# code_img = code_img[code_img.find("url(")+5:-3]
# print(code_img)

print(len(code_list))

code_no = 1

for code in code_list:   
    code_img = code.find_element_by_css_selector('span.CategoryCircle_circle__3khwj').get_attribute('style')
    code_img = code_img[code_img.find("url(")+5:-3]
    
    img_folder = './images/code'
    if not os.path.isdir(img_folder): # 폴더 없으면 폴더 생성
        os.mkdir(img_folder)

    from urllib.request import urlretrieve

    urlretrieve(code_img, f'{img_folder}/{code_no}.jpg') # 이름을 어떻게 할지 고민해봐야할듯
    code_no += 1
    

#################################################################
# proj_no = 1

# # 필요한거 PROJECT_NAME, AMOUNT_GOAL, AMOUNT_PRESENT, 
# # DDLN, DELIVERY_CHARGE(배송료), SUPPORT_NUM, DETAIL_INTRO, CATEGORY_NO

# # 각 파트 더 긁어오려면 lazy loading이므로 scroll 한번 내려봐야함
# items = driver.find_elements_by_css_selector('div.ProjectCardList_item__1owJa')

# print(len(items))

# # for item in items:

# item = items[0]
# # print(items)

# ## thumbnail link
# thumbnail = item.find_element_by_css_selector('span.CommonCard_background__3toTR').get_attribute("style")
# thumbnail = thumbnail[thumbnail.find("url(")+5:-3]
# print(f'thumbnail : {thumbnail}')

# # 이미지 다운
# import os

# img_folder = './images'
# if not os.path.isdir(img_folder): # 폴더 없으면 폴더 생성
#     os.mkdir(img_folder)

# from urllib.request import urlretrieve

# urlretrieve(thumbnail, f'{img_folder}/{proj_no}.jpg') # 이름을 어떻게 할지 고민해봐야할듯

# ## PROJECT_NAME
# name = item.find_element_by_css_selector('p.CommonCard_title__1oKJY').text

# ## CATEGORY_NO 카테고리 이름에 매칭해야함
# category = item.find_element_by_css_selector('span.RewardProjectCard_category__2muXk').text

# print(f'name : {name}\ncategory : {category}')

# #### detail page에서 처리
# # detail project로 이동
# clicker = item.find_element_by_css_selector('a.CardLink_link__1k83H')
# print(clicker.get_attribute('href'))
# driver.execute_script("arguments[0].click();", clicker)
# url = clicker.get_attribute('href')
# driver.get(url)

# ## AMOUNT_GOAL
# ## DDLN
# goal_date = driver.find_element_by_css_selector('#container > div.reward-body-wrap > div > div.wd-ui-info-wrap > div.wd-ui-sub-campaign-info-container > div > div > section > div.wd-ui-campaign-content > div > div:nth-child(6) > div > p:nth-child(1)').text
# # print(goal_date)
# goal, date = goal_date.split('\n')
# goal = goal[5:-1]
# date = date[date.find('-')+1:]
# print(f'goal : {goal}\ndate : {date}')

# ## AMOUNT_PRESENT
# present = driver.find_element_by_css_selector('#container > div.reward-body-wrap > div > div.wd-ui-info-wrap > div.wd-ui-sub-opener-info > div.project-state-info > div.state-box > p.total-amount > strong').text

# ## SUPPORT_NUM
# support = driver.find_element_by_css_selector('#container > div.reward-body-wrap > div > div.wd-ui-info-wrap > div.wd-ui-sub-opener-info > div.project-state-info > div.state-box > p.total-supporter > strong').text

# summary = driver.find_element_by_css_selector('#container > div.reward-body-wrap > div > div.wd-ui-info-wrap > div.wd-ui-sub-campaign-info-container > div > div > section > div.campaign-summary').text

# print(f'present : {present}\nsupport : {support}\nsummary : {summary}')

## DETAIL_INTRO 프로젝트 세부 내용

# 되돌아오기
#driver.back()

driver.close()