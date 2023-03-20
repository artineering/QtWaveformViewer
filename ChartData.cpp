#include "ChartData.h"
#include <QtCharts/QAreaSeries>
#include <QtCharts/QXYSeries>
#include <QtCore/QDebug>
#include <QtCore/QtMath>
#include <QtQuick/QQuickItem>
#include <QtQuick/QQuickView>

Q_DECLARE_METATYPE(QAbstractSeries *)
Q_DECLARE_METATYPE(QAbstractAxis *)

ChartData::ChartData(QQuickView *appViewer, QObject *parent)
    : QObject(parent), m_appViewer(appViewer), m_index(0),m_minValue(qInf()),m_maxValue(-qInf()),m_dateRange(0),m_scrollPosition(0),m_startDate(),m_endDate() {
  qRegisterMetaType<QAbstractSeries *>();
  qRegisterMetaType<QAbstractAxis *>();
}

void ChartData::setSeries(QAbstractSeries *series) {
  if (series) {
    mSeries = static_cast<QLineSeries *>(series);
    auto axes = mSeries->attachedAxes();
    m_xAxis = axes[0];
    m_yAxis = axes[1];
  }
}

void ChartData::setXAxisStartZoom(double time)
{
    QDateTime newStartTime = m_startDate.addMSecs(time);
    m_xAxis->setMin(newStartTime);
    m_currStartDate = newStartTime;
    m_scrollPosition = m_currStartDate.time().msec() + m_currStartDate.time().msecsTo(m_currEndDate.time())/2;
}

void ChartData::setXAxisEndZoom(double time)
{
    QDateTime newEndTime = m_startDate.addMSecs(time);
    m_xAxis->setMax(newEndTime);
    m_currEndDate = newEndTime;
    m_scrollPosition = m_currStartDate.time().msec() + m_currStartDate.time().msecsTo(m_currEndDate.time())/2;
}

void ChartData::setXAxisScrollPosition(double time)
{
//    double diff = time - m_scrollPosition;
//    qDebug() << diff;
//    m_currStartDate.setMSecsSinceEpoch(m_currStartDate.toMSecsSinceEpoch() + diff);
//    m_currEndDate .setMSecsSinceEpoch(m_currStartDate.toMSecsSinceEpoch() + diff);
//    m_scrollPosition = m_currStartDate.time().msec() + m_currStartDate.time().msecsTo(m_currEndDate.time())/2;
//    qDebug() << m_currStartDate << "," << m_currEndDate;
//    m_xAxis->setMin(m_currStartDate);
//    m_xAxis->setMax(m_currEndDate);
}

void ChartData::setData(qreal x, qreal y)
{
    if (y < m_minValue) {
        m_minValue = y;
    }
    if (y > m_maxValue) {
        m_maxValue = y;
    }
    mSeries->append(x,y);
    m_data.append(QPointF(x,y));
    m_index++;
    double range = m_maxValue - m_minValue;
    m_yAxis->setRange(m_minValue - range/5,m_maxValue + range/5);
    m_yAxis->setProperty("minCache", m_minValue - range/5);
    m_yAxis->setProperty("maxCache", m_maxValue + range/5);
    m_yAxis->setProperty("rangeValue", range + 2 * range / 5);
    m_yAxis->setProperty("scrollPosition", (m_maxValue + m_minValue)/2);
}

void ChartData::setStartDate(QDateTime startDate)
{
    m_startDate = startDate;
    m_xAxis->setMin(m_startDate);
}

void ChartData::setEndDate(QDateTime endDate)
{
    m_endDate = endDate;
    m_xAxis->setMax(m_endDate);
    m_dateRange = m_startDate.time().msecsTo(m_endDate.time());
    m_scrollPosition = m_dateRange/2;
    m_xAxis->setProperty("dateRange",m_dateRange);
    m_xAxis->setProperty("scrollPosition",m_dateRange/2);
}

