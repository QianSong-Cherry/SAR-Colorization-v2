
'''
SAR Colorization Using ALOS2 Data
by Qian Song on Jun. 13 2019
'''


import utils
import numpy as np
import time
import scipy.io as sio
import h5py
import tensorflow as tf
flags = tf.app.flags
import random
random.seed(0)

flags.DEFINE_boolean('is_train', True, "Flag of opertion: True is for training")
flags.DEFINE_string('data', './data/data_SH.mat', "Path of training/test data")
flags.DEFINE_string('dir', './checkpoint', "Path of saving model")

FLAGS = flags.FLAGS

class Pol_SD(object):
    def __init__(self, sess):
        self.sess = sess
        
        self.learning_rate = 0.0005
        self.output_size = 400
        self.feature_size = 1153

        self.model_build()
        
    def model_build(self):
        ##Build Model
        self.HHHH = tf.placeholder(tf.float32, [None, self.output_size, self.output_size, 1])
        self.H = tf.placeholder(tf.float32, [None, self.feature_size])
        self.X_true = tf.placeholder(tf.float32, [None, 32*9])
        
        self.hypercolumn = utils.VGG16(self.HHHH)
        self.X,self.X_ = utils.T_prediction(self.H)
        
        self.d_loss = - tf.reduce_mean(self.X_true*tf.log(self.X_+1e-7))
        self.optim = tf.train.AdamOptimizer(learning_rate=self.learning_rate, epsilon=1e-6) \
                                  .minimize(self.d_loss)
        self.saver = tf.train.Saver()

    def train(self):
        init = tf.global_variables_initializer()
        self.sess.run(init)

        data_X, data_V = self.load_data()
        temp_mean = np.zeros([self.training_size, self.feature_size])
        temp_var = np.zeros([self.training_size, self.feature_size])
        for i in range(self.training_size):
           batch_V = np.reshape(data_V[i, :, :], [1, self.output_size, self.output_size, 1])
           batch_H = self.sess.run(self.hypercolumn, feed_dict={self.HHHH: batch_V})
           temp_mean[i, :] = np.mean(batch_H, axis=0)
           temp_var[i, :] = np.std(batch_H, axis=0)
        temp_mean = np.mean(temp_mean, axis=0)
        temp_var = np.mean(temp_var, axis=0)
        temp_var[temp_var < 1.0] = 1.0
        sio.savemat('./data/mean_and_var.mat', {'mean': temp_mean, 'var': temp_var})

        start_time = time.time()

        # Training steps:=====================================
        counter = 0
        temp_list1 = np.linspace(0, self.output_size*self.output_size-1, self.output_size*self.output_size, dtype = 'int')
        temp_list2 = np.linspace(0, self.training_size-1, self.training_size, dtype = 'int')
        for epoch in range(100):
           batch_idxs = len(data_X)
           random.shuffle(temp_list2)
           random.shuffle(temp_list1)

           for idx in temp_list2:
               batch_V = np.reshape(data_V[idx, :, :], [1, self.output_size, self.output_size, 1])
               temp_H = self.sess.run(self.hypercolumn, feed_dict={self.HHHH: batch_V})
               temp_H = (temp_H-temp_mean)/temp_var
               temp_X = utils.get_vectorised_T(data_X[idx, :, :, :])

               for index in range(80):
                   batch_H = temp_H[temp_list1[index*2000:(index+1)*2000], :]
                   batch_X = temp_X[temp_list1[index*2000:(index+1)*2000], :]
                   loss1, train_step, X = self.sess.run([self.d_loss, self.optim, self.X_], feed_dict={self.H: batch_H,
                                                                                                       self.X_true:
                                                                                                           batch_X})

                   counter += 1
                   if np.mod(counter, 10) == 9:
                       print("Epoch: [%2d] [%4d/%4d] time: %4.4f, d_loss: %.8f" % (epoch, idx+1, batch_idxs, time.time()
                                                                                   - start_time, loss1))
           self.saver.save(self.sess, FLAGS.dir + "/Generate model")
           print("[*]Save Model...")

    def test(self):

        print("[*]Loading Model...")
        self.saver.restore(self.sess, FLAGS.dir + "/Generate model")
        print("[*]Load successfully!")

        matfn = './data/mean_and_var.mat'
        data1 = sio.loadmat(matfn)
        temp_mean = data1['mean']
        temp_var = data1['var']

        test_V = self.load_data()

        Re_data = np.zeros([len(test_V), self.output_size, self.output_size, 9])
        for i in range(len(test_V)):
            batch_V = np.reshape(test_V[i, :, :], [1, self.output_size, self.output_size, 1])
            batch_H = self.sess.run(self.hypercolumn, feed_dict={self.HHHH: batch_V})
            batch_H = (batch_H-temp_mean)/temp_var
            val_X = self.sess.run(self.X_, feed_dict={self.H: batch_H})
            Re_data[i, :, :, :] = utils.inv_vetorization_T(val_X)

        f = h5py.File("./data/test_nj.mat", 'w')
        f.create_dataset('Re_data', data=Re_data)
        f.close()
        # sio.savemat('./data/test_sh2.mat', {'Re_data': Re_data})

    def load_data(self):

        if FLAGS.is_train == True:
            matfn = FLAGS.data
            data1 = h5py.File(matfn, 'r')
            data = data1['data']
            data = np.transpose(data, axes=[3, 2, 1, 0])
            data.shape = -1, self.output_size, self.output_size, 9
            self.training_size = len(data)

            data_H = data1['data_H']
            data_H = np.transpose(data_H, axes=[2, 1, 0])
            data_H = np.log10(data_H + 1e-10)    # Normalization of input image
            data_H[data_H > 13] = 13
            data_H[data_H < 9] = 9
            data_H = (data_H-9) / 4
            data_H.shape = self.training_size, self.output_size, self.output_size
            return data, data_H
        else:
            data1 = sio.loadmat(FLAGS.data)
            data_H = data1['data_H']
            self.test_size = len(data_H)
            data_H = np.log10(data_H + 1e-10)    # Normalization of input image
            data_H[data_H > 13] = 13
            data_H[data_H < 9] = 9
            data_H = (data_H - 9) / 4
            return data_H

def main(_):
    with tf.Session() as sess:
        print(FLAGS.data)
        sdgan = Pol_SD(sess)
        if FLAGS.is_train == True:
            sdgan.train()
        else:
            sdgan.test()

if __name__ == '__main__':
    tf.app.run() 