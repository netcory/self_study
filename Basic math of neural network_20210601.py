#!/usr/bin/env python
# coding: utf-8

# In[2]:


import math
import numpy as np
import matplotlib.pyplot as plt
plt.style.use(['seaborn-whitegrid'])


# In[3]:


def linear_function(x):
    a = 0.5
    b = 2
    
    return a * x + b


# In[4]:


print(linear_function(5))


# In[5]:


linear_function(5)


# In[6]:


x = np.arange(-5, 5, 0.1)
y = linear_function(x)

plt.plot(x, y)
plt.xlabel('x')
plt.ylabel('y')
plt.title('Linear Function')
plt.show()


# In[7]:


def qudratic_function(x):
    a = 1
    b = -1
    c = -2
    
    return a * x ** 2 + b * x + c


# In[8]:


print(qudratic_function(2))


# In[9]:


x = np.arange(-5, 5, 0.1)
y = qudratic_function(x)

plt.plot(x, y)
plt.xlabel('x')
plt.ylabel('y')
plt.title('Qudratic Function')
plt.show()


# In[10]:


def cubic_function(x):
    a = 4
    b = 0
    c = -1
    d = -8
    
    return a * x**3 + b * x**2 + c * x + d


# In[12]:


cubic_function(3)


# In[13]:


x = np.arange(-5, 5, 0.1)
y = cubic_function(x)

plt.plot(x, y)
plt.xlabel('x')
plt.ylabel('y')
plt.title('Cubic Function')
plt.show()


# In[14]:


def my_func(x):
    a = 1
    b = -3
    c = 10
    
    return a * x**2 + b * x + c


# In[27]:


x = np.arange(-10, 10,0.1)
y = my_func(x)

plt.plot(x, y)
plt.xlabel('x')
plt.ylabel('y')
plt.scatter(1.5, my_func(1.5))
plt.text(1.5-1.5, my_func(1.5) + 10, 'min value of f(x)\n({}, {})'.format(1.5, my_func(1.5)), fontsize = 10)
plt.title('my_func')
plt.show()


# In[28]:


min_val = min(y)
print(min_val)


# In[29]:


def get_minimum(x1, x2, f):
    x = np.arange(x1, x2, 0.01)
    y = f(x)
    
    plt.plot(x, y)
    plt.xlabel('x')
    plt.ylabel('y')
    plt.title('get_minimum')
    plt.show()
    
    return min(y)


# In[31]:


get_minimum(1, 4, my_func)


# In[ ]:





# In[ ]:





# ## 지수함수

# In[40]:


def exponential_function(x):
    a = 4
    return a ** x


# In[41]:


exponential_function(4)


# In[42]:


exponential_function(0)


# In[43]:


x = np.arange(-3, 2, 0.1)
y = exponential_function(x)

plt.plot(x, y)
plt.xlabel('x')
plt.ylabel('y')
plt.ylim(-1, 15)
plt.xlim(-4, 3)
plt.title('exponential_function')
plt.show()


# In[44]:


def exponential_function2(x):
    a = 4
    return math.pow(a, x)


# In[45]:


exponential_function2(3.3)


# ## 밑이 e인 지수함수 표현

# In[46]:


print(math.exp(4))


# In[47]:


print(np.exp(4))


# ## 로그함수

# In[49]:


print(math.log(2, 3)) ## 밑이 3, x가 2. math.log(x, base)

print(np.log2(4)) ## 밑이 2인 로그함수
print(np.log(4)) ## 밑이 e인 자연로그


# ## 역함수 관계
# ## y =  x 대칭

# In[50]:


x = np.arange(-1, 5, 0.01)
y1 = np.exp(x)

x2 = np.arange(0.000001, 5, 0.01)
y2 = np.log(x2)

y3 = x

plt.plot(x, y1, 'r-', x2, y2, 'b-', x, y3, 'k--')

plt.ylim(-2, 6)
plt.axvline(x = 0, color = 'k') #axvline 은 세로선 강조
plt.axhline(y = 0, color = 'k') #axhline 은 가로선 강조

plt.xlabel('x')
plt.ylabel('y')
plt.show()


# ## 함수 조작

# In[51]:


x = np.arange(-10, 10, 0.01)
y1 = -np.log(x)
y2 = -np.log(1-x)

plt.axvline(x = 0, color = 'k')
plt.axhline(y = 0, color = 'k')

plt.grid()
plt.plot(x, y1, 'b-', x, y2, 'r-')
plt.text(0.9, 2.0, 'y=-log(1-x)', fontsize = 15)
plt.text(0.1, 3, 'y=-log(x)', fontsize = 15)
plt.xlim(-0.3, 1.4)
plt.ylim(-0.5, 4)
plt.scatter(0.5, -np.log(0.5))
plt.show()


# ## 극한
# 
# ### 극한에 대해서는 어떠한 식을 코드로 표현할 수 있다 정도로만 이해하며 참고
# ### 극한에서 알아야 할 사실은 x가 어떤 값 a에 가까이 다가갈 때
# ### a에 '한없이 가까이 간다'일 뿐, a에 도달하지 않는다는 점
# ### 이를 표현할 때, 엡시론(epsilon)이라는 아주 작은 값(ex, 0.0001) 등으로 표현

# In[56]:


from sympy import*
init_printing()

x, y, z = symbols('x y z')
a, b, c, t = symbols('a b c t ')


# In[60]:


print("극한값:", limit((x**3-1) / (x-1), x, 1)) ## x가 1로 갈 때 극한값

plot(((x**3-1) / (x-1)), xlim=(-5, 5), ylim=(-1,10))


# In[63]:


print("극한값:", limit((1+x) / x, x, oo)) # 소문자 o를 두개 연달아 입력하면 무한대

plot((1+x) / x, xlim = (-10, 10), ylim = (-5, 5))


# In[72]:


print("극한값:", limit((sqrt(x+3) -2) / (x - 1), x, 1))

plot((sqrt(x+3) -2) / (x -1), xlim = (-5, 12), ylim = (-0.5, 1))


# ## 삼각함수의 극한

# In[73]:


print("극한값:", limit(tan(x), x, pi/2, '+'))
print("극한값:", limit(tan(x), x, pi/2, '-'))

plot(tan(x), xlim = (-3.14, 3.14), ylim = (-6, 6))


# In[74]:


print("극한값:", limit(sin(x)/x, x, 0))

plot(sin(x)/x, ylim = (-2,2))


# In[77]:


print("극한값:", limit(x * sin(1/x), x, 0))

plot(x * sin(1/x), xlim = (-2, 2), ylim = (-1, 1.5))

