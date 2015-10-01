import QtQuick 2.5
import QtQuick.Window 2.2
import QtMultimedia 5.5
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.2
import com.calibration.opencv 1.0

Window {
    id: window1
    visible: true
    width: 1280
    height : 720
    color: "#202020"

    property bool cameraItemCreated: false
    property variant cameraComponent : null;

    Timer{
        id: timer
        interval: 1000
        repeat: true
        onTriggered: {
            if(QtMultimedia.availableCameras.length >0){
                if(!cameraItemCreated){
                    /// Dynamic  Qml object creation
                    var str = "CameraProcessing{id:cameraProcessing;
                                          anchors.fill: parent;
                                          gaussianBlurCoefValue :" + coefficient.value +
                                          ";gaussianBlurSizeValue :" + kernelSize.value +
                                          ";cannyThresholdValue   :" + cannyThreshold.value +
                                          ";cannyKernelSizeValue  :" + cannyKernelSize.value +
                                        ";}";

                    cameraComponent = Qt.createQmlObject(str,cameraRect, "cameraComponent.qml");

                    cameraItemCreated = true;
                }

            }else{
                if(cameraComponent !== null){
                    cameraComponent.destroy(1000);
                    cameraComponent = null;
                    cameraItemCreated = false;
                }
            }
        }
    }

    Component.onCompleted: {
        timer.start()
    }

    Rectangle{
        width: 300
        height: parent.height
        anchors.right: parent.right
        anchors.rightMargin: 0
        color: "#b3000000"
        anchors.left: cameraRect.right
        anchors.leftMargin: 0
        z : 0

        SpinBox {
            id: kernelSize
            x: 174
            y: 63
            width: 101
            height: 33
            minimumValue: 1
            stepSize: 2
            maximumValue: 9999999
            value : 7

            onValueChanged: {
                if(value %2 != 1)
                    value = cameraComponent.gaussianBlurSizeValue;
                else
                    cameraComponent.gaussianBlurSizeValue = value;
            }
        }

        SpinBox {
            id: coefficient
            x: 174
            y: 129
            width: 101
            height: 33
            stepSize: 0.01
            decimals: 2
            maximumValue: 9999999
            value : 1.5
            onValueChanged: cameraComponent.gaussianBlurCoefValue = value
        }

        Label {
            id: label1
            x: 8
            y: 15
            color: "#ffffff"
            text: qsTr("Gaussian Blur")
            font.family: "Courier"
            font.pixelSize: 24
            font.bold: true
            verticalAlignment: Text.AlignVCenter
        }

        Label {
            id: label2
            x: 29
            y: 63
            width: 119
            height: 33
            color: "#ffffff"
            text: qsTr("Kernel Size")
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 17
            font.family: "Courier"
        }

        Label {
            id: label3
            x: 29
            y: 129
            width: 119
            height: 33
            color: "#ffffff"
            text: qsTr("Coefficient")
            verticalAlignment: Text.AlignVCenter
            font.family: "Courier"
            font.bold: true
            font.pixelSize: 17
        }

        Label {
            id: label4
            x: 8
            y: 192
            color: "#ffffff"
            text: qsTr("Canny Edge Detector")
            verticalAlignment: Text.AlignVCenter
            font.family: "Courier"
            font.bold: true
            font.pixelSize: 24
        }

        SpinBox {
            id: cannyKernelSize
            x: 174
            y: 245
            width: 101
            height: 33
            value: 3
            minimumValue: 1
            maximumValue: 9999999
            stepSize: 2

            onValueChanged: {
                if(value %2 === 1)
                    cameraComponent.cannyKernelSizeValue = value;
            }
        }

        SpinBox {
            id: cannyThreshold
            x: 174
            y: 311
            width: 101
            height: 33
            decimals: 2
            value: 0.0
            maximumValue: 9999999
            stepSize: 1

            onValueChanged: cameraComponent.cannyThresholdValue = value
        }

        Label {
            id: label5
            x: 29
            y: 245
            width: 119
            height: 33
            color: "#ffffff"
            text: qsTr("Kernel Size")
            verticalAlignment: Text.AlignVCenter
            font.family: "Courier"
            font.bold: true
            font.pixelSize: 17
        }

        Label {
            id: label6
            x: 29
            y: 311
            width: 119
            height: 33
            color: "#ffffff"
            text: qsTr("Threshold")
            verticalAlignment: Text.AlignVCenter
            font.family: "Courier"
            font.bold: true
            font.pixelSize: 17
        }
    }

    Rectangle{
        color: "#262626"
        anchors.right: parent.right
        anchors.rightMargin: 300
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.top: parent.top
        id:cameraRect
    }

}
