# Selenium import
from selenium import webdriver

# 크롬 드라이버 생성
driver = webdriver.Chrome('./Python/chromedriver.exe')

# 사이트 접속하기
driver.get('https://codeit.kr')