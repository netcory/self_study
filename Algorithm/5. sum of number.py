#!/usr/bin/env python
# coding: utf-8

# In[11]:


def string_sum(N, s):
    
    total = 0
    a = str(s)
    for i in range(N):
        total = int(a[i]) + total
        
    return total

string_sum(6, 123456)


# In[ ]:




