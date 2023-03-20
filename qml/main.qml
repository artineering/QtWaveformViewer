import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtCharts 2.15

RowLayout{
    anchors.fill: parent
    Item {
        id: root
        Layout.fillHeight: true
        Layout.fillWidth: true
        Grid
        {
            id: chartGrid
            anchors.fill: parent
            rows: 2
            columns: 2
            horizontalItemAlignment: Grid.AlignLeft
            verticalItemAlignment: Grid.AlignTop
            RangeSelector
            {
                id: vertSlider
                axis: "y"
                orientation: Qt.Vertical
                width: 40
                height: chartGrid.height - width
                y: chartGrid.y
                color: 'green'
            }
            ChartView
            {
                id: chart
                width: chartGrid.width - vertSlider.width
                height: chartGrid.height - horzSlider.height
                plotArea: Qt.rect(0,0,width,height)
                legend.visible: false

                Component.onCompleted: {
                    chartData.setSeries(dataSeries);
                }

                Connections {
                    target: vertSlider
                    function onFirstHandleChanged(value,axis) {
                        var newMinLimit = yAxis.rangeValue * value / 100;
                        yAxis.min = newMinLimit
                    }
                    function onSecondHandleChanged(value,axis) {
                        var newMaxLimit = yAxis.rangeValue * value / 100;
                        yAxis.max = newMaxLimit
                    }
                    function onBarPositionChanged(value,axis) {
                        var currentScrollPosition = (yAxis.min + yAxis.max)/2;
                        var newScrollPosition = yAxis.rangeValue * value / 100;
                        var diff = newScrollPosition - currentScrollPosition;
                        yAxis.min = yAxis.min + diff
                        yAxis.max = yAxis.max + diff
                    }
                }

                Connections {
                    target: horzSlider
                    function onFirstHandleChanged(value,axis) {
                        var newStartTime = xAxis.dateRange * value / 100;
                        chartData.setXAxisStartZoom(newStartTime)
                    }
                    function onSecondHandleChanged(value,axis) {
                        var newEndTime = xAxis.dateRange * value / 100;
                        chartData.setXAxisEndZoom(newEndTime)
                    }
                    function onBarPositionChanged(value,axis) {
                        var newScrollPosition = xAxis.dateRange * value / 100;
                        if (newScrollPosition !== chartData.scrollPosition)
                            chartData.setXAxisScrollPosition(newScrollPosition);
                    }
                }

                ValuesAxis
                {
                    id: yAxis
                    property real minCache
                    property real maxCache
                    property real rangeValue
                    property real scrollPosition
                    gridVisible: true
                    color: 'lightgray'
                    labelFormat: "%.0f"
                }
                DateTimeAxis
                {
                    id: xAxis
                    property real dateRange
                    property real scrollPosition
                    gridVisible: true
                    color: 'lightgray'
                    labelsVisible: false
                    labelsAngle: 90
                    tickCount: 10
                }
                LineSeries
                {
                    id: dataSeries
                    color: "orange"
                    axisX: xAxis
                    axisY: yAxis
                    onAxisXChanged: {
                        console.log(xAxis.min, xAxis.max)
                    }
                }

            }
            Rectangle
            {
                id: spacer
                width: vertSlider.width
                height: horzSlider.height
                color: 'transparent'
            }
            RangeSelector
            {
                id: horzSlider
                axis: "x"
                orientation: Qt.Horizontal
                width: parent.width - height
                height: 40
                x: 40
                y: parent.height - height
                color: 'blue'
            }

        }



    }
}


