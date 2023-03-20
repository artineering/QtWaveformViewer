#include <QApplication>
#include <QQuickView>
#include <QQmlEngine>
#include <QtCharts/QChartView>
#include <QtCharts/QLineSeries>
#include <QtCore/QDateTime>
#include <QtCharts/QDateTimeAxis>
#include <QtCore/QFile>
#include <QtCore/QTextStream>
#include <QtCore/QDebug>
#include <QtCharts/QValueAxis>
#include <QSharedPointer>
#include <QQuickItem>
#include <QQmlContext>
#include <QPointF>
#include <QList>
#include <QDir>
#include "ChartData.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QQuickView view;
    view.setBaseSize(QSize(640,480));

    QPointer<ChartData> data = new ChartData(&view);
    view.engine()->rootContext()->setContextProperty("chartData",data.get());

    QFile powerFile("power.csv");
    if (!powerFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        return 1;
    }

    view.engine()->addImportPath("qrc:/qml/imports");
    view.setSource(QUrl("qrc:/qml/main.qml"));
    if (!view.errors().isEmpty())
        return -1;
    view.show();

    QTextStream stream(&powerFile);
    int index = 0;

    double startTime = 0;
    while (!stream.atEnd()) {
        QString line = stream.readLine();
        if (index == 0) {
            index++;
            continue;
        }
        QStringList values = line.split(QLatin1Char(','), Qt::SkipEmptyParts);
        double currTime = values[0].toDouble();
        double dataValue = values[1].toDouble();
        if (startTime == 0) {
            QDateTime dateTime;
            dateTime.setMSecsSinceEpoch(currTime);
            data->setData(currTime, dataValue);
            data->setStartDate(dateTime);
        } else {
            data->setData(currTime, dataValue);
        }
        startTime = currTime;
        index++;
    }
    QDateTime dateTime;
    dateTime.setMSecsSinceEpoch(startTime);
    data->setEndDate(dateTime);

    powerFile.close();

    return app.exec();
}
