# -*- coding: utf-8 -*-
"""
Created on Sat Mar 25 13:13:08 2017

@author: shawn
"""

import os
#os.chdir(r'E:\Dropbox\2017HousePrice')
os.chdir(r'/Users/shawn/Dropbox/2017HousePrice')
import pandas as pd

"""
把資料讀近來 看一下大概的樣子
分做
train: 訓練資料
test: 測試資料
all_data: 全部的資料混合再一起
"""
train = pd.read_csv('input/train.csv')
test = pd.read_csv('input/test.csv')

print(train.head())
print(train.tail())
print(train.shape)
print(train.columns)

#查看個變數的類別型態
print(train.info())
#diagnose numerical data
print(train.describe())

all_data = pd.concat((train.loc[:,'MSSubClass':'SaleCondition'],
                     test.loc[:,'MSSubClass':'SaleCondition']))

#diagnose catergorical data
#print(train[''].value_counts(dropna= False))
import matplotlib.pyplot as plt
import matplotlib as mpl
#底下為例子 劃出直方圖 (可以直接畫log transform)
#df['Existing Zoning Sqft'].plot(kind='hist', rot=70, logx=True, logy=True)
# Display the histogram
#plt.show()
#比較在類別變數下數值變數的差異時boxplot還不錯用
# Create the boxplot
#df.boxplot(column='initial_cost', by='Borough', rot=90)
# Display the plot
#plt.show()
#如果是兩個類別變數可以用scatter plot
# Create and display the first scatter plot
#df.plot(kind='scatter', x='initial_cost', y='total_est_fee', rot=70)
#plt.show()
#移除掉outlier之後再畫圖會比較清楚
# Create and display the second scatter plot
#df_subset.plot(kind='scatter',x='initial_cost',y='total_est_fee',rot=70)
#plt.show()
"""
進入資料處理的部分
"""
from scipy.stats import skew, mode
import numpy as np
#首先看看output histogram
mpl.rcParams['figure.figsize']=(12.0,6.0)
prices = pd.DataFrame({"Price":train["SalePrice"], "log(price + 1)":np.log1p(train["SalePrice"]),"log(Price)":np.log(train["SalePrice"])})
#prices.hist()
#看上去效果不錯 所以就
#log transform the target:
train["SalePrice"] = np.log1p(train["SalePrice"])

#這部分在了解skewness各種不同的公式
numeric_feats = train.dtypes[train.dtypes!='object'].index
temp = train[numeric_feats[1]]
q1 = np.percentile(temp,25, interpolation='lower')
q3 = np.percentile(temp,75, interpolation='lower')
tmed = np.median(temp)
tmea = np.mean(temp)
n = temp.shape[0]
M0 = mode(temp).mode
m3 = np.mean((temp - np.mean(temp)) ** 3)
m2 = np.mean((temp - np.mean(temp)) ** 2)
print('Coefficient of skewness :' +str(m3 / (m2 ** 3/2)))
print('Pearson’s first coefficient of skewness :' + str((tmea-M0)/np.std(temp)))
print('Pearson’s second moment of skewness : ' +str(3*(np.mean(temp)-np.median(temp))/np.std(temp)))
print('Quadratic coefficient of skewness : ' + str((q3-2*tmed+q1)/(q3-q1)))
print('scipy.state.skew"s skewness :' +str(m3 / m2 **1.5))
print('check scipy.state.skew :'+str(skew(temp)))

#使用scipy.state.skew 來計算skewness
#log transform skewed numeric features:
skewed_feats = train[numeric_feats].apply(lambda x: skew(x.dropna()),axis = 0) #compute skewness
skewed_feats = skewed_feats[skewed_feats>0.75]
skewed_feats = skewed_feats.index

all_data[skewed_feats] = np.log1p(all_data[skewed_feats])
#把skewness>.75的作log transform後
#感覺上資料是都沒有亂偏了
#接下就要針對類別變數處理
numeric_feats = numeric_feats[numeric_feats != 'Id']
numeric_feats = numeric_feats[numeric_feats != 'SalePrice']
def nor(a):
    return (a-np.mean(a))/np.std(a)
all_data[numeric_feats] = all_data[numeric_feats].apply(lambda x: nor(x),axis = 0)
all_data = pd.get_dummies(all_data)

#filling NA's with the mean of the column:
all_data = all_data.fillna(all_data.mean())

#creating matrices for sklearn:
X_all_train = all_data[:train.shape[0]]
X_test = all_data[train.shape[0]:]
y = train.SalePrice

"""
結束了資料處理
接下來就是建構Model了
"""
#先使用https://www.kaggle.com/neviadomski/how-to-get-to-top-25-with-simple-model-sklearn
from sklearn import ensemble, tree, linear_model
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.metrics import r2_score, mean_squared_error
from sklearn.utils import shuffle
### Elastic Net ###
# Prints R2 and RMSE scores
def get_score(prediction, lables):    
    print('R2: {}'.format(r2_score(prediction, lables)))
    print('RMSE: {}'.format(np.sqrt(mean_squared_error(prediction, lables))))

# Shows scores for train and validation sets    
def train_test(estimator, x_trn, x_tst, y_trn, y_tst):
    prediction_train = estimator.predict(x_trn)
    # Printing estimator
    print(estimator)
    # Printing train scores
    get_score(prediction_train, y_trn)
    prediction_test = estimator.predict(x_tst)
    # Printing test scores
    print("Test")
    get_score(prediction_test, y_tst)
    
### Shuffling train sets
X_all_train, y = shuffle(X_all_train, y, random_state = 5)
### Splitting
X_train, X_val, y_train, y_val = train_test_split(X_all_train, y, test_size=0.1, random_state=200)

ENSTest = linear_model.ElasticNetCV(alphas=[0.0001, 0.0005, 0.001, 0.01, 0.1, 1, 10], l1_ratio=[.01, .1, .5, .9, .99], max_iter=5000).fit(X_train, y_train)
train_test(ENSTest, X_train, X_val, y_train, y_val)

# Average R2 score and standart deviation of 5-fold cross-validation
scores = cross_val_score(ENSTest, X_all_train, y, cv=5)
print("Accuracy: %0.2f (+/- %0.2f)" % (scores.mean(), scores.std() * 2))
### Gradient Boosting ###
GBest = ensemble.GradientBoostingRegressor(n_estimators=2500, learning_rate=0.05, max_depth=3, max_features='sqrt',
                                               min_samples_leaf=12, min_samples_split=10, loss='huber').fit(X_train, y_train)
train_test(GBest, X_train, X_val, y_train, y_val)

# Average R2 score and standart deviation of 5-fold cross-validation
scores = cross_val_score(GBest, X_all_train, y, cv=5)
print("Accuracy: %0.2f (+/- %0.2f)" % (scores.mean(), scores.std() * 2))

###KERAS Neural network"""

from keras.layers import Dense
from keras.models import Sequential
from keras.regularizers import l1
from sklearn.preprocessing import StandardScaler
X_tr = X_train.as_matrix()
X_va = X_val.as_matrix()

model = Sequential()
model.add(Dense(288, activation="relu", input_dim = X_train.shape[1]))
model.add(Dense(1, W_regularizer=l1(0.01)))
model.compile(loss = "mean_squared_error", optimizer = "Adam")
model.summary()

hist = model.fit(X_tr, y_train, shuffle=True, nb_epoch=400, batch_size=1314, validation_data = (X_va, y_val))
train_test(model, X_tr, X_va, y_train, y_val)

# summarize history for loss
plt.plot(hist.history['loss'])
plt.plot(hist.history['val_loss'])
plt.title('model loss')
plt.ylabel('loss')
plt.xlabel('epoch')
plt.legend(['train', 'test'], loc='upper left')
plt.show()


### LM RBF """
"""
from lm_rbf import *
X_lm_train = np.asmatrix(X_train)
X_lm_test = np.asmatrix(X_test)
y_lm_train = y = np.transpose(np.asmatrix(y_train))
[net, theta] = lm_rbf(X_lm_train,y_lm_train)
"""

"""
建構最後輸出模型
以及輸出
"""

# Retraining models
X_a_train = X_all_train.as_matrix()
GB_model = GBest.fit(X_all_train, y)
ENST_model = ENSTest.fit(X_all_train, y)
#NN_model = model.fit(X_a_train, y)

## Getting our SalePrice estimation
X_te = X_test.as_matrix()
#Final_labels = (np.exp(GB_model.predict(X_test)) + np.exp(ENST_model.predict(X_test)) + np.exp(np.array(np.transpose(model.predict(X_te))))) / 3
#Final_labels = Final_labels[0]
Final_labels = (np.exp(GB_model.predict(X_test)) + np.exp(ENST_model.predict(X_test))) / 2

## Saving to CSV
pd.DataFrame({'Id': test.Id, 'SalePrice': Final_labels}).to_csv('2017-05-10-1.csv', index =False)   
