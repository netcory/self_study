#!/usr/bin/env python
# coding: utf-8

# In[21]:


import random

a = []
b = []

def solution ():
    
    answer = 0
    length = random.randint(1, 1000)
    
    for i in range(length):
        m = random.randint(-1000, 1000)
        n = random.randint(-1000, 1000)
        a.append(m)
        b.append(n)
        answer += a[i] * b[i]
        
    
    return answer

print(solution())
print(a)
print(b)

