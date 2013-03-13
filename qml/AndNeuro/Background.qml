import QtQuick 1.1

Rectangle {
    id: background
    anchors.fill: parent;
    color: "#343434"
    Image { source: "qrc:/images/stripes.png"; fillMode: Image.Tile; anchors.fill: parent;  opacity: 0.3 }
}
