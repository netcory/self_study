#!/usr/bin/env python
# coding: utf-8

# In[29]:


def finding_alphabet(S):
    
    s = 'abcdefghijklmnopqrstuvwxyz'
    
    for i in range(26):
        result = S.find(s[i])
        print(result)
        
finding_alphabet("baekjoon")

