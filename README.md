# mSGDT
Implementation and testing of mSGDT

This repository contains MATLAB code for implementing and testing mSGDT, a stochastic gradient descent based method for solving tensor linear systems under the t-product with missing data. It implements the method for three different missing data models, the uniform missing data model, the column block missing data model, and the frontal slice missing data model.

These three implementations can be found in [mSGDT_uniform.m](mSGDT_uniform.m), [mSGDT_column.m](mSGDT_column.m), and [mSGDT_frontal.m](mSGDT_frontal.m). We provide an additional implementation of the uniform missing data model under the streaming setting, where row slices of the tensor A are provided one-by-one, instead of all at a time. This is done in [mSGDT_uniform_streaming.m](mSGDT_uniform_streaming.m).

Two files are provided that show how to use the provided methods and to reproduce the figures found in paper corresponding to this repository. [synthetic_tests.m](synthetic_tests.m) reproduces the synthetic tests, while [video_tests.m](video_tests.m) reproduces the test on the available 'shuttle.avi' MATLAB video data.

To use this project, you must first install [Tensor-tensor-product-toolbox](https://github.com/canyilu/Tensor-tensor-product-toolbox), which is used to carry out various tensor operations, including the t-product.

