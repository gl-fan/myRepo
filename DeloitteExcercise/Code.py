# -*- coding: utf-8 -*-
"""
Created on Mon Nov  1 19:07:53 2021

@author: fangu
"""

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
import numpy as np

# Read data
data_female = pd.read_csv('DIRPA_Exer_PikesPeak_Females.txt', sep='\t', encoding='latin-1')
data_male = pd.read_csv('DIRPA_Exer_PikesPeak_Males.txt', sep="\t",encoding='latin-1')

# Convert time to min
data_female['Gun Tim'] = pd.to_numeric(data_female['Gun Tim'].str.replace(r'[^0-9]+', ''))
data_female['Gun Tim'] = data_female['Gun Tim'].floordiv(10000) * 60 + \
                         data_female['Gun Tim'].mod(10000).floordiv(100) + \
                         data_female['Gun Tim'].mod(100) / 60

data_female['Net Tim'] = pd.to_numeric(data_female['Net Tim'].str.replace(r'[^0-9]+', ''))
data_female['Net Tim'] = data_female['Net Tim'].floordiv(10000) * 60 + \
                         data_female['Net Tim'].mod(10000).floordiv(100) + \
                         data_female['Net Tim'].mod(100) / 60

data_male['Gun Tim'] = pd.to_numeric(data_male['Gun Tim'].str.replace(r'[^0-9]+', ''))
data_male['Gun Tim'] = data_male['Gun Tim'].floordiv(10000) * 60 + \
                         data_male['Gun Tim'].mod(10000).floordiv(100) + \
                         data_male['Gun Tim'].mod(100) / 60

data_male['Net Tim'] = pd.to_numeric(data_male['Net Tim'].str.replace(r'[^0-9]+', ''))
data_male['Net Tim'] = data_male['Net Tim'].floordiv(10000) * 60 + \
                         data_male['Net Tim'].mod(10000).floordiv(100) + \
                         data_male['Net Tim'].mod(100) / 60
                         
# create new division
from numpy import inf
data_female['Div'] = pd.cut(data_female['Ag'], bins=[-inf,14,19,29,39,49,59,69,inf],
                     labels=["0-14", "15-19", "20-29", "30-39", "40-49", "50-59", "60-69", ">70"])
data_male['Div']=pd.cut(data_male['Ag'], bins = [-inf,14,19,29,39,49,59,69,inf],
                        labels=["0-14", "15-19", "20-29", "30-39", "40-49", "50-59", "60-69", ">70"])
# create a gender column
data_female['Gender'] = 'Female'
data_male['Gender']='Male'
# calculate the time differences
data_male['Time Difference'] = data_male['Gun Tim'] - data_male['Net Tim']
data_female['Time Difference'] = data_female['Gun Tim'] - data_female['Net Tim']

#concate all data
all_data = pd.concat([data_female,data_male])

                         
# =====================    Data statistics ==============================   
Div = pd.Series(data_female.groupby(['Div']).groups.keys())
fnumber = data_female.groupby(['Div']).size()
mnumber = data_male.groupby(['Div']).size()
font_color = '#525252'
hfont = {'fontname':'Calibri'}
index = Div

fig, axes = plt.subplots(figsize=(12,6),dpi=120, ncols=2, sharey=True)
fig.tight_layout()
axes[0].barh(index, fnumber, align='center', color='lightpink',edgecolor=".2")
axes[0].set_title('Female: total '+str(len(data_female)), fontsize=24, pad=15, color='k', **hfont)
axes[1].barh(index, mnumber, align='center', color='lightsteelblue',edgecolor=".2")
axes[1].set_title('Male: total '+str(len(data_male)), fontsize=24, pad=15, color='k', **hfont)
axes[0].invert_xaxis() 
plt.subplots_adjust(wspace=0, top=0.85, bottom=0.1, left=0.18, right=0.95)
plt.savefig('statistic') 
                        
# ===============================   Q1  ========================================                    
# 1. Female              
fmean = round(data_female['Net Tim'].mean(),2)
fmedian = round(data_female['Net Tim'].median(),2)
fmode = round(data_female['Net Tim']).mode().values[0]
fmin = round(data_female['Net Tim'].min(),2)
fmax = round(data_female['Net Tim'].max(),2)

plt.figure(figsize=(15, 6), dpi=120)
plt.rcParams['font.size'] = '16'
sns.distplot(data_female['Net Tim'], bins=15 ,kde=False,color="red",
             hist_kws=dict(edgecolor="black", linewidth=2))
plt.axvline(fmean, color='g', linestyle='dashed', linewidth=2)
plt.axvline(fmedian, color='r', linestyle='dashed', linewidth=2)
plt.axvline(fmode, color='b', linestyle='dashed')
plt.axvline(fmin, color='k', linestyle='dashed')
plt.axvline(fmax, color='k', linestyle='dashed')
plt.legend(['mean = ' + str(fmean),
            'median = ' + str(fmedian),
            'mode = ' + str(fmode),
            'Range = ' + str(fmin) + '~' + str(fmax)],
           )
plt.xlabel('Net Time / min')
plt.ylabel('Count')
plt.xlim([data_female['Net Tim'].min()-0.1,data_female['Net Tim'].max()+0.1])
plt.title('Female')
plt.savefig('Female-1')

# 1. Male
plt.figure(figsize=(15, 6), dpi=120)
plt.rcParams['font.size'] = '16'                      
fmean = round(data_male['Net Tim'].mean(),2)
fmedian = round(data_male['Net Tim'].median(),2)
fmode = round(data_male['Net Tim']).mode().values[0]
fmin = round(data_male['Net Tim'].min(),2)
fmax = round(data_male['Net Tim'].max(),2)
sns.distplot(data_male['Net Tim'], bins=15 ,kde=False,
             hist_kws=dict(edgecolor="black", linewidth=2))
plt.axvline(fmean, color='g', linestyle='dashed', linewidth=2)
plt.axvline(fmedian, color='r', linestyle='dashed', linewidth=2)
plt.axvline(fmode, color='b', linestyle='dashed')
plt.axvline(fmin, color='k', linestyle='dashed')
plt.axvline(fmax, color='k', linestyle='dashed')
plt.legend(['mean = ' + str(fmean),
            'median = ' + str(fmedian),
            'mode = ' + str(fmode),
            'Range = ' + str(fmin) + '~' + str(fmax)],
           )
plt.xlabel('Net Time / min')
plt.ylabel('Count')
plt.xlim([data_male['Net Tim'].min()-0.1,data_male['Net Tim'].max()+0.1])
plt.title('Male')
plt.savefig('male-1')

# =============================== Q2. Time Difference ========================================                    

# By gender
means = round(all_data.groupby(['Gender'])['Time Difference'].mean(),2)
medians = round(all_data.groupby(['Gender'])['Time Difference'].median(),2)
stds = round(all_data.groupby(['Gender'])['Time Difference'].std(),2)
print('means:\n', means)
print('stds:\n', stds)
print('medians\n:', medians)

plt.figure(figsize=(8, 8), dpi=120)
cpalette = reversed(sns.color_palette("coolwarm",2))
h = sns.boxplot(x = all_data['Gender'], y =  all_data['Time Difference'],
                palette=cpalette)
plt.ylabel('Time Difference / min')
plt.title('Time Difference by gender')
for xtick in h.get_xticks():
    h.text(xtick, medians[xtick] + 0.05, 'median = ' + str(medians[xtick]),
            horizontalalignment='center',size='x-small',color='k',weight='semibold')
plt.savefig('gender-2')

# By age group
means = round(all_data.groupby(['Div'])['Time Difference'].mean(),2)
medians = round(all_data.groupby(['Div'])['Time Difference'].median(),2)
stds = round(all_data.groupby(['Div'])['Time Difference'].std(),2)
print('means:\n', means)
print('stds:\n', stds)
print('medians\n:', medians)

plt.figure(figsize=(8, 8), dpi=120)
h = sns.boxplot(x = all_data['Div'], y =  all_data['Time Difference'],palette="Blues")
plt.ylabel('Time Difference / min')
plt.xlabel('Age group')
plt.title('Male')
plt.title('Time Difference by age group')
for xtick in h.get_xticks():
    h.text(xtick, medians[xtick] + 0.05, str(medians[xtick]),
            horizontalalignment='center',size='x-small',color='k',weight='semibold')
plt.savefig('age-2')

# =============================== Q3. Percentile Analysis ===============================
Pcti = np.percentile(data_male.loc[data_male['Div'] == '40-49']['Net Tim'],10)
ChrisTime = data_male.loc[data_male['Name'] == 'Chris Doe']['Net Tim']
Difference = round(float(ChrisTime - Pcti),2)
print ('Time seperates = ', Difference)
# =============================== Q4. Race results of each division ===============================

plt.figure(figsize=(16, 8), dpi=120)
cpalette = reversed(sns.color_palette("coolwarm",2))
b = sns.barplot(x=all_data['Div'], y=all_data['Net Tim'],hue=all_data['Gender'],
               edgecolor=".1",capsize=.1,palette=cpalette)
plt.ylabel('Net Time / min')
plt.xlabel('Age group')
plt.title('Net time for all divisions')
plt.savefig('Div-4')


