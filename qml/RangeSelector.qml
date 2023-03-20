import QtQuick 2.15
import QtQuick.Controls 2.12

RangeSlider
{
    id: sli
    property string axis
    property int start: 0.0
    property int end: 100.0
    property string color: 'red'
    from: start
    to: end
    first.value: start
    second.value: end

    signal firstHandleChanged(value: real, axis: string)
    signal secondHandleChanged(value: real, axis: string)
    signal barPositionChanged(value: real, axis: string)

    MouseArea {
        anchors.fill: parent
        property real dx: 0
        property real dy: 0
        property real currD: 0
        property bool firstHandleDragged: false
        property bool secondHandleDragged: false
        onPressed: {
            dx = mouseX
            dy = mouseY
            if (sli.orientation === Qt.Horizontal) {
                currD = (dx / sli.width) * Math.abs(sli.to - sli.from)
            } else {
                currD = ((sli.height - dy) / sli.height) * Math.abs(sli.to - sli.from)
            }
            if (Math.abs(currD - sli.first.value) < sli.first.implicitHandleWidth/2) {
                firstHandleDragged = true
                currD = sli.first.value
            } else if (Math.abs(currD - sli.second.value) < sli.second.implicitHandleWidth/2) {
                secondHandleDragged = true
                currD = sli.second.value
            }
        }
        onReleased: {
            firstHandleDragged = false
            secondHandleDragged = false
        }
        onPositionChanged: {
            if (sli.orientation === Qt.Horizontal) {
                if (!firstHandleDragged && !secondHandleDragged) {
                    var d = ((mouseX - dx) / sli.width) * Math.abs(sli.to - sli.from)
                    if ((d + sli.first.value) < sli.from) d = sli.from - sli.first.value
                    if ((d + sli.second.value) > sli.to) d = sli.to - sli.second.value
                    sli.first.value += d
                    sli.second.value += d
                    sli.barPositionChanged((sli.first.value + sli.second.value)/2, axis)
                    dx = mouseX
                } else {
                    var d = (mouseX / sli.width) * Math.abs(sli.to - sli.from)
                    if (firstHandleDragged) {
                        if (d <= sli.from) {
                            sli.first.value = sli.from
                        } else if (d >= sli.second.value) {
                            sli.first.value = sli.second.value
                        } else {
                            sli.first.value = d
                        }
                        sli.firstHandleChanged(sli.first.value, axis)
                    } else {
                        if (d >= sli.to) {
                            sli.second.value = sli.to
                        } else if (d <= sli.first.value) {
                            sli.second.value = sli.first.value
                        } else {
                            sli.second.value = d
                        }
                        sli.secondHandleChanged(sli.second.value, axis)
                    }
                }
            } else {
                if (!firstHandleDragged && !secondHandleDragged) {
                    var d = ((dy - mouseY) / sli.height) * Math.abs(sli.to - sli.from)
                    if ((d + sli.first.value) < sli.from) d = sli.from - sli.first.value
                    if ((d + sli.second.value) > sli.to) d = sli.to - sli.second.value
                    sli.first.value += d
                    sli.second.value += d
                    sli.barPositionChanged((sli.first.value + sli.second.value)/2, axis)
                    dy = mouseY
                } else {
                    var d = ((sli.height - mouseY) / sli.height) * Math.abs(sli.to - sli.from)
                    if (firstHandleDragged) {
                        if (d <= sli.from) {
                            sli.first.value = sli.from
                        } else if (d >= sli.second.value) {
                            sli.first.value = sli.second.value
                        } else {
                            sli.first.value = d
                        }
                        sli.firstHandleChanged(sli.first.value, axis)
                    } else {
                        if (d >= sli.to) {
                            sli.second.value = sli.to
                        } else if (d <= sli.first.value) {
                            sli.second.value = sli.first.value
                        } else {
                            sli.second.value = d
                        }
                        sli.secondHandleChanged(sli.second.value, axis)
                    }
                }
            }
        }
    }
}
