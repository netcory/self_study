class Solution(object):
    def findMaxConsecutiveOnes(self, nums):
        
        count, sum = 0, 0
        
        for i in nums:
            if i == 1:
                count += 1
                sum = max(count, sum)
            else:
                count = 0
        
        return sum
