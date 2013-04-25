import QtQuick 1.1

Item {
    id: container

    width: 640; height: 360

    property alias text: textMessage.text
    property alias nextView: messageBox.nextView
    property alias boxHeight: messageBox.height
    property alias boxWidth: messageBox.width

    signal clicked

    states: [
        State {
            name: "normal"

            PropertyChanges {
                target: outFocus
                opacity: 0
            }

            PropertyChanges {
                target: focusHandler
                enabled: false
            }

            PropertyChanges {
                target: messageBox
                state: 'hide'
            }
        },

        State {
            name: "hideForeground"

            PropertyChanges {
                target: outFocus
                opacity: 0.5
            }

            PropertyChanges {
                target: focusHandler
                enabled: true
            }

            PropertyChanges {
                target: messageBox
                state: 'show'
            }
        }
    ]

    Rectangle {
        id: outFocus

        anchors.fill: parent
        color: 'black'
        opacity: 0

        Behavior on opacity { NumberAnimation{ duration: 600 } }

        MouseArea {
            id: focusHandler

            anchors.fill: parent
            enabled: true
        }

    }

    Rectangle {
        id: messageBox

        property string nextView : ""
//        property alias text: textMessage.text

        anchors.centerIn: parent

        border {width: 5; color: "black"}
        radius: 5

        Behavior on opacity { NumberAnimation { duration: 700 } }

        Text {
            id: textMessage

            anchors { left: parent.left; right: parent.right; top: parent.top; topMargin: 40 }
            text: ""
            font { pointSize: 7; family: "Series 60 Sans"; weight: Font.Bold }
            horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
        }

        Button {
            id: okButton

            anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 40 }
            text: "OK"

            onClicked: {
//                messageBox.visible = false;
                container.clicked();
            }
        }

        states: [

            State {
                name: "hide"
                PropertyChanges {
                    target: messageBox;
                    opacity: 0
                }
            },

            State {
                name: "show"
                PropertyChanges {
                    target: messageBox
                    opacity: 1
                }
            }
        ]
    }
}
