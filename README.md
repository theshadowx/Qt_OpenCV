# Qt_OpenCV

This repository contains Qt/QtQuick apps using OpenCV.

## CannyQml 
It's an example of using a new feature in Qt5.5 which is filter that you can add it in the video output in Qml,
and then create this filter in C++. There is an [article](https://blog.qt.io/blog/2015/03/20/introducing-video-filters-in-qt-multimedia/) 
written by Laszlo Agocs taking about filters which can give you more depth about it.

The filter, made in this example, uses OpenCV Gaussian Blur and Canny edge detector for YUV420P camera. 

![cannyqml](https://cloud.githubusercontent.com/assets/976569/13226637/616d883a-d98a-11e5-9278-bc2d464eb8f1.jpg)
