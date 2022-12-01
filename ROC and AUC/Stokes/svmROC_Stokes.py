# -*- coding: utf-8 -*-
"""
Created on Fri Jan 10 11:08:18 2020

@author: nkqqj
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from itertools import cycle

from sklearn import svm, datasets
from sklearn.linear_model import LogisticRegression, LinearRegression
from sklearn.metrics import roc_curve, auc
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import label_binarize
from sklearn.multiclass import OneVsRestClassifier
from scipy import interp
from sklearn.metrics import roc_auc_score
from mlxtend.plotting import plot_decision_regions




def load_from_excel(filename):
    df = pd.read_excel(filename,converters={'Pathology_status_str_col':str})
    col1 = df['DEP_col'].values
    col2 = df['RET_col'].values
    col3 = df['Hue_col'].values
    col4 = df['Saturation_col'].values
    y = label_binarize(df['Pathology_status_str_col'], classes=['normal', 'cancerous'])
    X = np.vstack((col1,col2,col3,col4)).T # the columns are dep, ret, hue, sat respectively
    return y, X

def svm_roc(X_input,y_input, reg_C):
    # shuffle and split training and test sets
    X_train, X_test, y_train, y_test = train_test_split(X_input, y_input, test_size=.4, random_state=1)
    # Learn to predict each class against the other
    classifier = OneVsRestClassifier(svm.SVC(kernel='linear', probability=True, random_state=1, C = reg_C))

    
    y_score = classifier.fit(X_train, y_train).decision_function(X_test)
    rms = np.sqrt(np.mean(np.square(classifier.predict(X_train) - y_train)))
    
    # Compute ROC curve and ROC area for each class
    fpr = dict()
    tpr = dict()
    roc_auc = dict()
    
    fpr, tpr, thres = roc_curve(y_test, y_score, drop_intermediate=False)
    #fpr, tpr, thres = roc_curve(y_input, classifier.decision_function(X_input), drop_intermediate=False)
    roc_auc = auc(fpr, tpr)
    return roc_auc, classifier, fpr, tpr, rms


def plot_roc(fpr,tpr, roc_auc, colorStr = 'darkorange', name_of_data = 'WLI', marker = None):

    # plot
    fig = plt.figure(1)
    lw = 1
    ft = 16
    fpr1 = np.insert(fpr,0,0)
    tpr1 = np.insert(tpr,0,0)
    plt.plot(fpr1, tpr1, color = colorStr,
             lw=lw, label='%s (AUC = %0.2f)' % (name_of_data, roc_auc)) #,marker = marker, markersize = 2)
    plt.plot([0, 1], [0, 1], color='lightgray', lw=lw, linestyle='--')
    plt.xlim([-0.025, 1.025])
    plt.ylim([-0.025, 1.025])
    plt.xlabel('False Positive Rate', fontsize = ft)
    plt.ylabel('True Positive Rate', fontsize = ft)
    plt.title('Receiver Operating Characteristic Curve', fontsize = ft)
    plt.legend(loc="lower right", fontsize =ft)
    plt.rc('font', size= ft)
    plt.show()    
    
    return fig

def visualize_clf(classifier, X_input, y_input, haxis_name, vaxis_name, XLimit = [0, 1], YLimit = [0, 1]):
    scatter_kwargs = {'s': 40, 'edgecolor': 'black', 'alpha': 0.6}
    contourf_kwargs = {'alpha': 0.4}
    scatter_highlight_kwargs = {'s': 120, 'label': 'Test data', 'alpha': 0.7}
    ft = 16
    fig = plt.figure()
    ax = plot_decision_regions(X=X_input, 
                  y=y_input.ravel(),
                  clf=classifier, 
                  legend=2,
                  markers = 'oo',
                  colors='#1f77b4,#ff7f0e',
                  scatter_kwargs=scatter_kwargs,
                  contourf_kwargs=contourf_kwargs,
                  scatter_highlight_kwargs=scatter_highlight_kwargs)
    handles, labels = ax.get_legend_handles_labels()
    if haxis_name is 'Depolarization':
        ax.legend(handles, 
                  ['Normal', 'Cancerous'], 
                   framealpha=0.3, scatterpoints=1, loc = 'lower left')
    else:
        ax.legend(handles, 
                  ['Normal', 'Cancerous'], 
                   framealpha=0.3, scatterpoints=1, loc = 'lower right')
    # Update plot object with X/Y axis labels and Figure Title
    plt.title('Classification Decision Region Boundary', size=ft)
    plt.xlabel(haxis_name, size = ft)
    plt.ylabel(vaxis_name, size = ft)
    plt.xlim(XLimit)
    plt.ylim(YLimit)
    #plt.legend(loc = 'lower right')
    plt.show()
    return fig

def visualize_clf_1D(classifier, X_input, y_input, haxis_name, XLimit = [0, .2]):
    y_input = np.squeeze(y_input)
    
    scatter_kwargs = {'s': 40, 'edgecolor': 'black', 'alpha': 0.6}
    contourf_kwargs = {'alpha': 0.4}
    scatter_highlight_kwargs = {'s': 120, 'label': 'Test data', 'alpha': 0.7}
    ft = 16
    fig = plt.figure()
    ax = plot_decision_regions(X=X_input, 
                  y=y_input,
                  clf=classifier, 
                  legend=2,
                  markers = 'oo',
                  colors='#1f77b4,#ff7f0e',
                  scatter_kwargs=scatter_kwargs,
                  contourf_kwargs=contourf_kwargs,
                  scatter_highlight_kwargs=scatter_highlight_kwargs)
    handles, labels = ax.get_legend_handles_labels()
    if haxis_name == 'Depolarization':
        ax.legend(handles, 
                  ['Normal', 'Cancerous'], 
                   framealpha=0.3, scatterpoints=1, loc = 'lower left')
    else:
        ax.legend(handles, 
                  ['Normal', 'Cancerous'], 
                   framealpha=0.3, scatterpoints=1, loc = 'lower right')
    # Update plot object with X/Y axis labels and Figure Title
    plt.title('Classification Decision Region Boundary', size=ft)
    plt.xlabel(haxis_name, size = ft)
    plt.xlim(XLimit)
    
    #plt.legend(loc = 'lower right')
    plt.show()
    return fig
    
    

    

# Import some data to play with
filename = 'A8.xlsx'
y8, X8 = load_from_excel(filename)

filename = 'A7.xlsx'
y7, X7 = load_from_excel(filename)

filename = 'A9.xlsx'
y9, X9 = load_from_excel(filename)

X = np.vstack((X7,X8,X9))
y = np.vstack((y7,y8,y9))

##------------------------------------------------------------------------------


# color classification
Name_of_Data = 'Color'
X_input = X[:,2:4]
y_input = y
auc1, classifier, fpr, tpr, rms = svm_roc(X_input,y_input, 150)
fig = plot_roc(fpr,tpr, auc1, colorStr = 'black', name_of_data = Name_of_Data, marker = 'o')
print(Name_of_Data+" rms is %f, auc is %f" % (float(rms), auc1))
fig.savefig(Name_of_Data+'roc.png', format='png', dpi=300)
plt.close()

# polarization classification
Name_of_Data = 'Ret+Dep'
X_input = X[:,0:2]
y_input = y
auc1, classifier, fpr, tpr, rms = svm_roc(X_input,y_input, 350)
fig = plot_roc(fpr,tpr, auc1, colorStr = 'black', name_of_data = Name_of_Data, marker = 'o')
print(Name_of_Data+" rms is %f, auc is %f" % (float(rms), auc1))
fig.savefig(Name_of_Data+'roc.png', format='png', dpi=300)
plt.close()

Name_of_Data = 'Dep'
X_input = X[:,0:1]
y_input = y
auc1, classifier, fpr, tpr, rms = svm_roc(X_input,y_input, 150)
fig = plot_roc(fpr,tpr, auc1, colorStr = 'black', name_of_data = Name_of_Data, marker = 'o')
print(Name_of_Data+" rms is %f, auc is %f" % (float(rms), auc1))
fig.savefig(Name_of_Data+'roc.png', format='png', dpi=300)
plt.close()

Name_of_Data = 'Ret'
X_input = X[:,1:2]
y_input = y
auc1, classifier, fpr, tpr, rms = svm_roc(X_input,y_input, 150)
fig = plot_roc(fpr,tpr, auc1, colorStr = 'black', name_of_data = Name_of_Data, marker = 'o')
print(Name_of_Data+" rms is %f, auc is %f" % (float(rms), auc1))
fig.savefig(Name_of_Data+'roc.png', format='png', dpi=300)
plt.close()



Name_of_Data = 'Dep+Color'
X_input = np.concatenate((X[:,0:1],X[:,2:4]), axis=1)
y_input = y
auc1, classifier, fpr, tpr, rms = svm_roc(X_input,y_input, 150)
fig = plot_roc(fpr,tpr, auc1, colorStr = 'black', name_of_data = Name_of_Data, marker = 'o')
print(Name_of_Data+" rms is %f, auc is %f" % (float(rms), auc1))
fig.savefig(Name_of_Data+'roc.png', format='png', dpi=300)
plt.close()

Name_of_Data = 'Ret+Color'
X_input = np.concatenate((X[:,1:2],X[:,2:4]), axis=1)
y_input = y
auc1, classifier, fpr, tpr, rms = svm_roc(X_input,y_input, 40)
fig = plot_roc(fpr,tpr, auc1, colorStr = 'black', name_of_data = Name_of_Data, marker = 'o')
print(Name_of_Data+" rms is %f, auc is %f" % (float(rms), auc1))
fig.savefig(Name_of_Data+'roc.png', format='png', dpi=300)
plt.close()

Name_of_Data = 'All'
X_input = X[:,:]
y_input = y
auc1, classifier, fpr, tpr, rms = svm_roc(X_input,y_input, 17)
fig = plot_roc(fpr,tpr, auc1, colorStr = 'black', name_of_data = Name_of_Data, marker = 'o')
print(Name_of_Data+" rms is %f, auc is %f" % (float(rms), auc1))
fig.savefig(Name_of_Data+'roc.png', format='png', dpi=300)
plt.close()
