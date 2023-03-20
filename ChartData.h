#ifndef CHARTDATA_H
#define CHARTDATA_H

#include <QObject>
#include <QSharedPointer>
#include <QtCharts/QAbstractSeries>
#include <QtCharts/QLineSeries>
#include <QDateTime>

class QTimer;
class QQuickView;

class ChartData : public QObject
{
    Q_OBJECT
public:
    explicit ChartData(QQuickView *appViewer, QObject *parent = nullptr);
    Q_INVOKABLE void setSeries(QAbstractSeries *series);
    Q_INVOKABLE void setXAxisStartZoom(double time);
    Q_INVOKABLE void setXAxisEndZoom(double time);
    Q_INVOKABLE void setXAxisScrollPosition(double time);

    void setData(qreal x, qreal y);
    void setStartDate(QDateTime startDate);
    void setEndDate(QDateTime endDate);
private:
  QQuickView *m_appViewer;
  QVector<QPointF> m_data;
  int m_index;
  QLineSeries *mSeries;
  double m_minValue;
  double m_maxValue;
  double m_dateRange;
  double m_scrollPosition;
  QDateTime m_startDate;
  QDateTime m_endDate;
  QDateTime m_currStartDate;
  QDateTime m_currEndDate;
  QAbstractAxis* m_xAxis;
  QAbstractAxis* m_yAxis;
};

#endif // CHARTDATA_H
