# SAR-Colorization-v2
This repository provides a brief guideline of using SAR image colorization network, including preparing dataset, training and test model, and reconstruction.
- More detail information about the network as well as how it works at [here](https://ieeexplore.ieee.org/document/8141881)
- Contact me at [songq15@fudan.edu.cn](songq15@fudan.edu.cn)

## Prerequisites
- Python 3.6+
- [Tensorflow](https://www.tensorflow.org/)
- [SciPy](http://www.scipy.org/install.html)
- [NumPy](http://www.numpy.org/)
- h5py

## Datasets
Two sample data (both smaller than 100M) are used in this repo to show how we organize the data.
- Training: C_SH.mat
- Test: C_NJ.mat
- VGG16 model: download it at [here](https://pan.baidu.com/s/1cJdZZx--nZSJFxTAoJEH5w) and store it in './data/'.

## Prepare training data
In this repo, full-pol data is represented by covariance matrix, which has a shape of `3*3*M*N`. Use `pre_data_tf` to extract the full-pol features as well as the input data of the network. Note that for test, only the input data is needed, thus use the function `pre_test_data_tf` instead.

## Training and test the model
- To train the model: `python train.py`
- To test the model: `python train.py --is_train=False --data="./data/data_NJ.mat"`

## Reconstruction
Use the function `Recons_from_feature` to recover the covariance matrix from predicted full-pol data.

## Authors
- [Qian Song](https://github.com/QianSong-Cherry)
- [Feng Xu](https://github.com/fudanxu)

## Reference
[1] Q. Song, F. Xu, and Y.Q. Jin, "Radar Image Colorization: Converting Single-Polarization to Fully Polarimetric Using Deep Neural Networks," IEEE Access.

[2] G. Larsson, M. Maire, and G. Shakhnarovich, “Learning representations for automatic colorization,” arXiv: 1603.06668, 2016.
