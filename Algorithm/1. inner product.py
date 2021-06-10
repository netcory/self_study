def solution(a, b):
    
    answer = 0
    length = len(a)
    
    for i in range(length):
        
        answer += a[i] * b[i]
        
    
    return answer

solution([1,2,3,4, 5], [0,1,3,1, 5])
