#!/usr/bin/env python
# coding: utf-8

# In[ ]:


def b_e_point(A, B, C):
    
    if B >= C:
        point = -1
    else:
        point = A / (C-B) + 1
        
    return int(point)
 
b_e_point(2100000000, 9, 10)


출처: https://matsu53.tistory.com/7?category=0 [Matsu]

