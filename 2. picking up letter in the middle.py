#!/usr/bin/env python
# coding: utf-8

# In[22]:


def solution(s):
    
    length = len(s)
    center = int(length / 2)
    answer = ''
    
    if length % 2 == 0:
        answer = s[center-1] + s[center]
    else:
        answer = s[center]
        
        
    return answer
    
solution("1a2b3c4d5e")


# In[ ]:




