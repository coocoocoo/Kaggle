# -*- coding: utf-8 -*-
"""
Created on Mon Dec 26 10:56:40 2016

@author: shawn
"""
from sklearn.cluster import KMeans
import numpy as np
#import pdb

class Net():
    def __init__(self,u,si,w0,w,M,d,MaxLoop,T,A,beta):
        self.u = u
        self.si = si
        self.w0 = w0
        self.w = w
        self.M = M
        self.d = d
        self.MaxLoop = MaxLoop
        self.T = T
        self.A = A
        self.beta = beta

def lm_ininet_rbf(x):
    M = 50
    [N, d] = x.shape
    ep = 0.001
    L = M*d + 2*M + 1
    
    theta = np.random.rand(1,L)*2*ep - ep
    theta = list(theta[0,:])
    kmeans = KMeans(n_clusters=M, random_state=0).fit(x)
    ctrs = kmeans.cluster_centers_
    ctrs = np.transpose(ctrs)
    theta[0:M*d] = list(np.reshape(ctrs,(1,M*d))[0,:])
    theta[M*d:M*d+M] = np.repeat(1,M*d+M-M*d)
    net = Net(np.reshape(theta[0:M*d],(M,d))
        , theta[M*d:M*d+M], theta[M*d+M+1],theta[M*d+M+1:M*d+M+M+1]
        , M, d, 1500, N, np.eye(d), 1)
    return M, ep, L, theta, net
    
def cross_distance(x,u):
    x = np.asmatrix(x)
    u = np.asmatrix(u)
    M = u.shape[0]
    N = x.shape[0]
    D = np.dot(x,np.transpose(u))
    D = -2*D + np.tile(np.sum(np.square(x),axis=1),(1,M))
    D = D + np.tile(np.transpose(np.sum(np.square(u),axis=1)) ,(N,1))
    return D
    
def evaRBF(x,net):
    #M = net.M
    u = net.u
    N = x.shape[0]
    D = cross_distance(x,u)
    si = np.asmatrix(net.si)
    s = 2*np.tile(np.square(si),(N,1))
    w = np.asmatrix(net.w)
    y = np.sum(np.multiply(np.exp(np.divide(-D,s)),np.tile(w,(N,1))) , axis=1) + net.w0
    yhat = np.transpose(y)
    return yhat, D

def derivative_RBF(net,x,theta,D):
    M = net.M
    w = np.asmatrix(net.w)
    si = np.asmatrix(net.si)
    u = np.asmatrix(net.u)
    x = np.asmatrix(x)
    [N, d] = x.shape
    s = 2*np.tile(np.square(si),(N,1))
    v = np.exp(np.divide(-D,s))
    v2 = np.multiply(v,np.tile(np.divide(w,np.square(si)),(N,1)))
    v3 = np.reshape(np.transpose(np.tile(v2,(d,1))),(N,d*M))
    u_row = np.asmatrix(np.reshape(u,(1,M*d)))
    dx_u = np.tile(x,(1,M)) - np.tile(u_row,(N,1))
    gu = np.multiply(v3,dx_u)
    #pdb.set_trace()
    v2 = np.multiply(v,np.tile(np.divide(w,np.multiply(np.square(si),si)),(N,1)))
    gsi = np.multiply(v2,D)
    gw0 = np.asmatrix(np.tile(1,(N,1)))
    gw = v
    gtheta = np.append(gu, gsi, axis = 1)
    gtheta = np.append(gtheta, gw0, axis = 1)
    gtheta = np.append(gtheta, gw, axis = 1)
    return gtheta
    
def update_net(net,theta):
    #M = Net.M;
    #d = Net.d;

    #Net.u=reshape(theta(1:M*d),[d,M])';
    #Net.si=theta(M*d+1:M*d+M);
    #Net.w0=theta(M*d+M+1);
    #Net.w=theta(M*d+M+2:M*d+M+M+1);
    
    M = net.M
    d = net.d
    
    net.u = np.reshape(theta[0:M*d],(M,d))
    net.si = theta[M*d:M*d+M]
    net.w0 = theta[M*d+M+1]
    net.w = theta[M*d+M+1:M*d+M+M+1]
 
    return net
    
def lm_rbf(x,y):
    x = np.asmatrix(x)
    [N,d] = x.shape
    [M, ep, L, theta, net]=lm_ininet_rbf(x)
    tag = 0
    lamda = 0.01
    lamda_old = 0
    #loop = 0
    for loop in range(0,net.MaxLoop):
        if tag == 0:
            [yhat, D]=evaRBF(x,net)
            e = y - yhat
            current_E = (e * np.transpose(e))/(2*net.T)
            gtheta = derivative_RBF(net,x,theta,D)
            G = -np.transpose((e*gtheta)/net.T)
            R = (np.transpose(gtheta)*gtheta)/net.T
            tag =1
        dtheta = np.transpose(np.linalg.solve((R + np.eye(R.shape[0]))*(lamda-lamda_old),-G))
        NextTheta = [x + y for x, y in zip(theta, np.array(dtheta)[0].tolist())]
        [next_yhat, D] = evaRBF(x,net)
        next_E = (y-next_yhat)*np.transpose(y-next_yhat)/(2*net.T)
        next_EL = -dtheta*G + lamda*dtheta*np.transpose(dtheta)
        #print(loop,' beta=',net.beta,'lamda=',lamda,'next_E=',next_E,'EL=',next_EL)
        #print(current_E > next_E)
        #print(net.si)
        #print(theta)
        if (current_E - next_E) > 0.75*next_EL:
            lamda = lamda/2
        elif (current_E - next_E) < 0.25*next_EL:
            lamda = lamda*2
        else:
            lamda_old = lamda
        #print(current_E > next_E)
        if current_E > next_E:
            theta = NextTheta;
            lamda_old=0;
            tag=0;
            if lamda >=4:
                lamda = 1
                if net.beta < 1.2:
                    net.beta = net.beta/0.98
            if loop % 10 == 0:
                print(loop,' beta=',net.beta,'lamda=',lamda,'next_E=',next_E[0,0],'EL=',next_EL[0,0])
            if (next_E < 10**-6 ) or (next_EL < 10**-8):
                break
        if loop % 10 == 0:
                print(loop,' beta=',round(net.beta,2),'lamda=',round(lamda,2),'next_E=',next_E[0,0],'EL=',next_EL[0,0])
        net = update_net(net,NextTheta)
        
    [yhat, D]=evaRBF(x,net)
    e = (y-yhat)
    current_E = e*np.transpose(e)/(2*net.T)
    
    return net, theta