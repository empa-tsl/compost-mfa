# -*- coding: utf-8 -*-
"""
Created on Mon Apr 29 09:54:22 2019

@author: dew

History of modifications:
- 02.07.2019: added special case if N == 1, which is important for the DPMFA module in Python 2.7
- 03.07.2019: added tests in functions for special inputs, so that errors are caught and the while loop does not loop without end
- 03.07.2019: added truncated normal distribution

"""


from scipy.stats import trapz
import numpy.random as nr
import numpy as np



#============= FUNCTION FOR TRUNCATING TRAPEZOIDAL DISTRIBUTIONS ==============

def TrapezTrunc(TC1, TC2, spread1, spread2, N, linf, lsup):
    
    if lsup < linf:
        raise Exception('lsup should be larger than linf')
    if spread1 < 0 or spread2 < 0:
        raise Exception('spread should not be below 0')
    if TC1 > TC2:
        raise Exception('TC1 should be smaller than TC2')
    
    if TC1+TC2 == 0:
        if N == 1:
            return 0
        else :
            return np.asarray([0]*N)
    
    # define variables for trapezoidal distribution
    A = TC1*(1-spread1)
    B = TC2*(1+spread2)
    
    if B < linf or A > lsup:
        raise Exception('TC1, TC2, linf and lsup are not compatible')
    
    c = (TC1-A)/(B-A)
    d = (TC2-A)/(B-A)
    loc = A
    scale = B-A
    
    dist = trapz.rvs(c, d, loc, scale, N)
    
    truncdist = [i for i in dist if i >= linf]
    truncdist = [i for i in truncdist if i <= lsup]
    
    
    while len(truncdist) < N:
        adddist = trapz.rvs(c, d, loc, scale, N-len(truncdist))
        truncadddist = [i for i in adddist if i >= linf]
        truncadddist = [i for i in truncadddist if i <= lsup]
        
        truncdist = truncdist + truncadddist
    
    if N == 1:
        return truncdist[0]
    else :
        return np.asarray(truncdist)




#============= FUNCTION FOR TRUNCATING TRIANGULAR DISTRIBUTIONS ===============
    
def TriangTrunc(TC1, spread1, N, linf, lsup):
    
    if lsup < linf:
        raise Exception('lsup should be larger than linf')
    if spread1 < 0:
        raise Exception('spread1 should not be below 0')
    
    if TC1 == 0:
        if N == 1:
            return 0
        else :    
            return np.asarray([0]*N)
    
    # define variables for triangular distribution
    A = TC1*(1-spread1)
    B = TC1*(1+spread1)
    
    if B < linf or A > lsup:
        raise Exception('TC1, TC2, linf and lsup are not compatible')
    
    dist = nr.triangular(A, TC1, B, N)
    
     # remove all that's not in the proper range - we end with a distribution with a length < N
    truncdist = [i for i in dist if i >= linf]
    truncdist = [i for i in truncdist if i <= lsup]
    
    # Create the "same" triangular distribution with the missing number of samples, and remove all that's not in the range.
    # "while" -> do that until you have N samples. 
    while len(truncdist) < N:
        adddist = nr.triangular(A, TC1, B, N-len(truncdist))
        truncadddist = [i for i in adddist if i >= linf]
        truncadddist = [i for i in truncadddist if i <= lsup]
        
        # concatenate both triangular distributions
        truncdist = truncdist + truncadddist
    
    if N == 1:
        return truncdist[0]
    else :
        return np.asarray(truncdist)




#============= FUNCTION FOR TRUNCATING NORMAL DISTRIBUTIONS ===============
    
def NormTrunc(TC1, spread1, N, linf, lsup):
    
    if lsup < linf:
        raise Exception('lsup should be larger than linf')
    if spread1 < 0:
        raise Exception('spread1 should not be below 0')
    
    if TC1 == 0:
        if N == 1:
            return 0
        else :
            return np.asarray([0]*N)
    
    dist = nr.normal(TC1, spread1, N)
    
     # remove all that's not in the proper range - we end with a distribution with a length < N
    truncdist = [i for i in dist if i >= linf]
    truncdist = [i for i in truncdist if i <= lsup]
    
    # Create the "same" triangular distribution with the missing number of samples, and remove all that's not in the range.
    # "while" -> do that until you have N samples.
    i = 1
    while len(truncdist) < N:
        adddist = nr.normal(TC1, spread1, N-len(truncdist))
        truncadddist = [i for i in adddist if i >= linf]
        truncadddist = [i for i in truncadddist if i <= lsup]
        
        # concatenate both triangular distributions
        truncdist = truncdist + truncadddist
        
        i += 1
        
        if i > 100:
            raise Exception('The calculation took too much time, make sure that the truncating boundaries are sensible.')
    
    if N == 1:
        return truncdist[0]
    else :
        return np.asarray(truncdist)