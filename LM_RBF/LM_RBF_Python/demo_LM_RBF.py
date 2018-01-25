# -*- coding: utf-8 -*-
"""
Created on Mon Dec 26 09:20:32 2016

x : N x d
y : 1 x N

@author: shawn
"""
import os
os.chdir(r"E:\Dropbox\LM_RBF\LM_RBF_Python")
#os.chdir(r"/Users/shawn/Dropbox/LM_RBF_python")
import time
import numpy as np
from lm_rbf import lm_rbf
from lm_rbf import evaRBF
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

t = time.time()

N = 200
d = 2
x = np.random.rand(N,d)*2 -1 
x = np.asmatrix(x)
y = np.exp(-2*np.square(x[:,0]) - np.square(x[:,1]))
y = np.transpose(np.asmatrix(y))

[net, theta] = lm_rbf(x,y)
[yhat, D] = evaRBF(x,net)
print('\nmean square error:',np.mean(np.square((y - yhat)))/2)

elapsed = time.time() - t
print('\nPassed Time:',elapsed)

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
plot_x = np.squeeze(np.asarray(x[:,0]))
plot_y = np.squeeze(np.asarray(x[:,1]))
plot_hz = np.squeeze(np.asarray(yhat))
plot_z = np.squeeze(np.asarray(y))
ax.scatter(plot_x,plot_y,plot_hz,c='b')
ax.scatter(plot_x,plot_y,plot_z,c='r')
