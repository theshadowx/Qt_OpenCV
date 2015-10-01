TEMPLATE = app

QT += qml quick multimedia
CONFIG += c++11

SOURCES += main.cpp \
    videofilter.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    videofilter.h

OpenCv = /software/libraries/OpenCV/OpenCV-3.0.0

unix{
    INCLUDEPATH += $$OpenCv/include/
    LIBS += -L$$OpenCv/lib \
    -lopencv_core          \
    -lopencv_imgproc       \
    -lopencv_highgui       \
    -lopencv_calib3d       \
    -lopencv_features2d    \
    -lopencv_imgcodecs     \
    -lopencv_videoio
}
