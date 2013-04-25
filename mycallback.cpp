#include "mycallback.h"

MyCallback::MyCallback(QObject *parent) :
    Sbs2Callback(parent)
{
}

void MyCallback::getData(Sbs2Packet *packet)
{
    setPacket(packet);

    if (currentPacketCounter%8 == 0)
        emit timeTick8();

    emit valueSignal((QVariant)thisPacket->filteredValues["O2"]);

}
