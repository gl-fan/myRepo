import pandas as pd
# import re
# import numpy as np

from sklearn import metrics
from sklearn.metrics import confusion_matrix

# from sklearn.metrics import confusion_matrix
import itertools
import os
# import shutil
# import random
# import glob

import tensorflow as tf
from tensorflow import keras
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Activation, Dense, Flatten, BatchNormalization, Conv2D, MaxPool2D, Dropout, GlobalAveragePooling2D
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.metrics import categorical_crossentropy
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.callbacks import ReduceLROnPlateau
import numpy as np
from numpy.random import seed

import matplotlib.pyplot as plt
import visualkeras
from PIL import ImageFont

seed(1337)
tf.random.set_seed(1337)

# def plotImages(images_arr):
#     fig, axes = plt.subplots(1, 10, figsize=(20,20))
#     axes = axes.flatten()
#     for img, ax in zip( images_arr, axes):
#         ax.imshow(img)
#         ax.axis('off')
#     plt.tight_layout()
#     plt.show()
def plot_confusion_matrix(cm, classes,
   normalize=False,
   title='Confusion matrix',
   cmap=plt.cm.Blues):
 
#Add Normalization Option prints pretty confusion metric with normalization option 
   if normalize:
     cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
     print("Normalized confusion matrix")
   else:
     print('Confusion matrix, without normalization')
 
# print(cm)
 
   plt.imshow(cm, interpolation='nearest', cmap=cmap)
   plt.title(title)
   plt.colorbar()
   tick_marks = np.arange(len(classes))
   plt.xticks(tick_marks, classes, rotation=45)
   plt.yticks(tick_marks, classes)
 
   fmt = '.2f' if normalize else 'd'
   thresh = cm.max() / 2.
   for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
      plt.text(j, i, format(cm[i, j], fmt), horizontalalignment="center", color="white" if cm[i, j] > thresh else "black")
 
   plt.tight_layout()
   plt.ylabel('True label')
   plt.xlabel('Predicted label') 
# plotImages(imgs)
# print(labels)

# raw_data = pd.read_csv('D:/FineGL/FGL/UMiami MSBA/Term3/Deloitte image/dataset.csv')
# data = raw_data[raw_data['type'] == 'PHOTO']
# data = data.drop_duplicates()

# del raw_data
# #Only one price is extremly high, and others are all below 200000

# print('Min: ', np.quantile(data['price'], 0.00))
# print('Q1: ', np.quantile(data['price'], 0.25))
# print('Q2: ', np.quantile(data['price'], 0.50))
# print('Q3: ', np.quantile(data['price'], 0.75))
# print('Max: ', np.quantile(data['price'], 1.00))

# #set the price into 4 levels: 1 - 4 based on the quantile

# a = (data['price'] < 30)
# data.loc[a, 'price'] = 1

# d = data['price'] >= 150
# data.loc[d, 'price'] = 4

# c = (data['price'] >= 55 )
# data.loc[c, 'price'] = 3

# b = (data['price'] >= 30)
# data.loc[b, 'price'] = 2

# data.groupby(['price'])['cid'].count().plot(kind='bar')

# del a,b,c,d

# #chenck the accuracy after spliting data

# assert data[data['price'] == 1]['path'].count() + data[data['price'] == 2]['path'].count() \
#         +data[data['price'] == 3]['path'].count() + data[data['price'] == 4]['path'].count() == 3024

# #change the variable 'path' to match the picture file name

# n = 0

# for i in data.iloc[:, -1]: 
#     data.iloc[n, -1] = i.replace('./dataset/image/', '')
#     n += 1;


# #change the name of local picture

# os.chdir('E:/archive/dataset/image')

#==============================Split images into different folder==========================================================
# file = glob.glob('*')
# p = data.loc[:, ('path', 'price')]

# os.makedirs('all1')
# os.makedirs('all2')
# os.makedirs('all3')
# os.makedirs('all4')    
# for i in range(len(file)):
#     if any(p['path'] == file[i]):
#         if len(p[p['path'] == file[i]]['price']) > 1:
#             for j in range (len(p[p['path'] == file[i]]['price'])):
#                 folder = 'all' + str(int(p[p['path'] == file[i]]['price'].values[j]))
#                 shutil.copyfile(file[i], folder + '/' + file[i])
#         else:
#             folder = 'all' + str(int(p[p['path'] == file[i]]['price'].values))
#             shutil.copyfile(file[i], folder + '/' + file[i])
# os.chdir('../')
# import splitfolders
# splitfolders.ratio('all', output="splitted", seed=1337, ratio=(.8, 0.1,0.1)) 

#============================== DATA PREPROCESS ==========================================================

train_path = 'image_4/splitted/train'
valid_path = 'image_4/splitted/val'
test_path = 'image_4/splitted/test'

im_size = 224
train_batches = ImageDataGenerator(preprocessing_function=tf.keras.applications.resnet_v2.preprocess_input,
                                   rotation_range=90,
                                   horizontal_flip=True, 
                                   vertical_flip=True,
                                    # width_shift_range=0.02,
                                    # height_shift_range=0.02,
                                    # rescale=1./255,
                                    # shear_range=0.02,
                                    # zoom_range=0.02
                                   ) \
    .flow_from_directory(directory=train_path, target_size=(im_size,im_size), batch_size=16)
valid_batches = ImageDataGenerator(preprocessing_function=tf.keras.applications.resnet_v2.preprocess_input) \
    .flow_from_directory(directory=valid_path, target_size=(im_size,im_size), batch_size=16, shuffle=False)
test_batches = ImageDataGenerator(preprocessing_function=tf.keras.applications.resnet_v2.preprocess_input) \
    .flow_from_directory(directory=test_path, target_size=(im_size,im_size), batch_size= 16, shuffle=False)

test_labels = test_batches.classes
valid_labels = valid_batches.classes
# #call next(train_batches) to generate a batch of images and labels from the training set



#==============================Transfer Learning==========================================================



# transfer learning
base_model = keras.applications.ResNet50V2(
    weights='imagenet',  # Load weights pre-trained on ImageNet.
    input_shape=(im_size, im_size, 3),
    include_top=False)  # Do not include the ImageNet classifier at the top.
#Then, freeze the base model.
base_model.trainable = False

#Create a new model on top.
img_inputs = keras.Input(shape=(im_size,im_size, 3))
x = base_model(img_inputs, training=False)
x = keras.layers.GlobalAveragePooling2D()(x)
x = tf.keras.layers.Dropout(0.5)(x)


# A Dense classifier with 4 unit (4 classes)    
outputs = keras.layers.Dense(units=4, activation='softmax')(x)
model = keras.Model(img_inputs, outputs)
#Train the model on new data.

reduce_lr = ReduceLROnPlateau(monitor='val_categorical_accuracy', factor=0.5,
                              patience=2, min_lr=1e-5)
early_stop = tf.keras.callbacks.EarlyStopping(
    monitor="val_categorical_accuracy",
    patience=5,
    restore_best_weights=True,
)

save_checkpoint = tf.keras.callbacks.ModelCheckpoint(
    'checkpoint_{epoch}.h5', monitor='val_loss', save_best_only=False,
    save_weights_only=False
)
save_checkpoint2 = tf.keras.callbacks.ModelCheckpoint(
    'checkpoint2_{epoch}.h5', monitor='val_loss', save_best_only=False,
    save_weights_only=False
)


base_learning_rate = 1e-4
initial_epochs = 20

model.compile(optimizer=Adam(learning_rate=base_learning_rate), 
              loss='categorical_crossentropy', 
              metrics=['categorical_accuracy'],              
              )

history = model.fit(x=train_batches,
    validation_data=valid_batches, 
    epochs=initial_epochs,
    # verbose=2
    callbacks=[reduce_lr
               ,save_checkpoint
               # ,early_stop
               ]
)


# Unfreeze the base model
base_model.trainable = True
# Let's take a look to see how many layers are in the base model
print("Number of layers in the base model: ", len(base_model.layers))

# Fine-tune from this layer onwards
fine_tune_at = 15

# Freeze all the layers before the `fine_tune_at` layer
for layer in base_model.layers[:fine_tune_at]:
  layer.trainable = False

# It's important to recompile your model after you make any changes
# to the `trainable` attribute of any inner layer, so that your changes
# are take into account
model.compile(optimizer=tf.keras.optimizers.RMSprop(learning_rate=base_learning_rate/10), 
              loss='categorical_crossentropy', 
              metrics=['categorical_accuracy'],              
              )
len(model.trainable_variables)

fine_tune_epochs = 10
total_epochs =  initial_epochs + fine_tune_epochs

history_fine = model.fit(train_batches,
                         epochs=total_epochs,
                         initial_epoch=history.epoch[-1],
                         validation_data=valid_batches,
                         callbacks=[reduce_lr,
                                    # early_stop,
                                    save_checkpoint2
                                    ]
                          
                         )

# history2 = model.fit(x=train_batches,
#     validation_data=valid_batches, 
#     epochs=10,
#     # verbose=2
#     callbacks=[reduce_lr,
#                 early_stop,
#                 save_checkpoint2
#                 ]
# )
#============================== plot ==========================================================

acc = history.history['categorical_accuracy']
val_acc = history.history['val_categorical_accuracy']

loss = history.history['loss']
val_loss = history.history['val_loss']

plt.figure(figsize=(8, 8))
plt.subplot(2, 1, 1)
plt.plot(acc, label='Training Accuracy')
plt.plot(val_acc, label='Validation Accuracy')
plt.legend(loc='lower right')
plt.ylabel('Accuracy')
# plt.ylim([min(plt.ylim()),1])
plt.title('Training and Validation Accuracy')

plt.subplot(2, 1, 2)
plt.plot(loss, label='Training Loss')
plt.plot(val_loss, label='Validation Loss')
plt.legend(loc='upper right')
plt.ylabel('Cross Entropy')
# plt.ylim([0,1.0])
plt.title('Training and Validation Loss')
plt.xlabel('epoch')
plt.show()



acc += history_fine.history['categorical_accuracy']
val_acc += history_fine.history['val_categorical_accuracy']

loss += history_fine.history['loss']
val_loss += history_fine.history['val_loss']


plt.figure(figsize=(8, 8))
plt.subplot(2, 1, 1)
plt.plot(acc, label='Training Accuracy')
plt.plot(val_acc, label='Validation Accuracy')
# plt.ylim([0.8, 1])
plt.plot([initial_epochs-1,initial_epochs-1],
          plt.ylim(), label='Start Fine Tuning')
plt.legend(loc='lower right')
plt.title('Training and Validation Accuracy')

plt.subplot(2, 1, 2)
plt.plot(loss, label='Training Loss')
plt.plot(val_loss, label='Validation Loss')
# plt.ylim([0, 1.0])
plt.plot([initial_epochs-1,initial_epochs-1],
         plt.ylim(), label='Start Fine Tuning')
plt.legend(loc='upper right')
plt.title('Training and Validation Loss')
plt.xlabel('epoch')
plt.show()


#============================== SAVE MODEL AND Visualize==========================================================


# model.save("model_0310.pb")
# model2 = keras.models.load_model('model_0309.pb')

# visualkeras.layered_view(model2) 
# visualkeras.layered_view(base_model, legend=True) 
#============================== Load model and confusion matrics ==========================================================

# model3 = keras.models.load_model(
#     # 'saved_models/checkpoint_7.h5'
#     "checkpoint2_32.h5"
#                                   )
# preds = model3.predict(x=valid_batches, verbose=0)
# price = ['0-30','30-55','55-150','150+']
# # classification_metrics = metrics.classification_report(test_labels,preds,target_names=price)
# # print(classification_metrics)

# categorical_valid_labels = valid_labels
# categorical_preds = pd.DataFrame(preds).idxmax(axis=1)

# cmatrix= confusion_matrix(categorical_valid_labels, categorical_preds)
# #To get better visual of the confusion matrix:

# plt.figure()   
# plot_confusion_matrix(cmatrix,
#                       ['0-30','30-55','55-150','150+'],
#                       normalize=True)
