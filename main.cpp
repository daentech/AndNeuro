#include <QApplication>
#include "qmlapplicationviewer.h"
#include <QtDeclarative>

#include "main.h"
#include <mycallback.h>
#include <hardware/emotiv/sbs2emotivdatareader.h>

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    qDebug() << "catalogPath: "<<Sbs2Common::setDefaultCatalogPath();
    qDebug() << "rootAppPath: "<<Sbs2Common::setDefaultRootAppPath();

    MyCallback* myCallback = new MyCallback();
    Sbs2EmotivDataReader* sbs2DataReader = Sbs2EmotivDataReader::New(myCallback,0);

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/AdNeuro/main.qml"));
    viewer.showExpanded();

    QObject *rootObject = dynamic_cast<QObject*>(viewer.rootObject());

    QTimer* timer = new QTimer();

    QObject::connect(timer, SIGNAL(timeout()), rootObject, SLOT(timerTick()));
    timer->start(33);

    QObject::connect(myCallback,SIGNAL(timeTick8()),rootObject,SLOT(timeTick()));
    QObject::connect(myCallback,SIGNAL(valueSignal(QVariant)),rootObject,SLOT(channelValue(QVariant)));

    QObject::connect(app.data(), SIGNAL(aboutToQuit()), sbs2DataReader, SLOT(aboutToQuit()));
    QObject::connect((QObject*)viewer.engine(), SIGNAL(quit()), app.data(), SLOT(quit()));

    return app->exec();
}
