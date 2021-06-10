#!/usr/bin/env python
# coding: utf-8

# In[19]:


case = int(input("케이스의 개수는? "))


for i in range(case):
    scores = []
    count = 0
    
    student = int(input("학생의 수는? "))
    for j in range(student):
        score = int(input("점수를 입력하세요. "))
        scores.append(score)
        
    average = sum(scores)/len(scores)
    for k in range(len(scores)):
        if scores[k] > average:
            count += 1
        probability = count/len(scores) * 100

    print(student, scores, round(probability, 3))


# In[ ]:





# In[4]:


a= [1, 2, 3]


# In[6]:


sum(a)


# In[ ]:




