#!/usr/bin/env python
# coding: utf-8

# In[17]:


n = int(input("몇 개의 정수를 입력할까요?"))
numbers = []
for i in range(n):
    number = int(input("정수를 입력하세요"))
    numbers.append(number)
    
print(numbers, min(numbers), max(numbers))    

