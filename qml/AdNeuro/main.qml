import QtQuick 1.0

Rectangle {
    id: page //unique id of the main object
    Background{ }
    width: 652 //width of the window
    height: 642 //height of the window
    color: "black" //background color of the window
    property int value: 0 //value of one EEG channel
    property int packetCounter: 0 //used for visualizing activity
    property int timeCounter: 0 // Used to keep track of the current time

    function timeTick()
    {
        page.packetCounter = (page.packetCounter + 1)%16;
    }

    function timerTick(){
        timeCounter++;
        timer.text = "Time: " + timeToString(timeCounter);
    }

    function timeToString(time){
        var milliseconds = time * 30;

        var seconds = Math.floor(milliseconds/1000);
        milliseconds = milliseconds % 1000;
        var minutes = Math.floor(seconds/60);
        seconds = seconds % 59;

        return minutes + ":" + ((seconds < 10) ? "0" : "") + seconds + "." + ((milliseconds < 100) ? (milliseconds < 10 ? "00" : 0) : "") + milliseconds;
    }

    function channelValue(value_)
    {
        page.value = value_;
    }

    Text
    {
        x: 307
        y: 509
        anchors.centerIn: parent
        font.pixelSize: 59
        color: "#000000"
        text: page.value
        anchors.verticalCenterOffset: 223
        anchors.horizontalCenterOffset: 0
    }

    Rectangle
    {
        color: "red"
        height: 33
        width: height
        opacity: page.packetCounter/16.0
    }

    Text {
        id: text_show
        x: 226
        y: 349
        width: 188
        height: 42
        color: "#ff0000"
        text: qsTr("it's")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 35
    }

    Text {
        id: instruction_label
        x: 154
        y: 113
        width: 332
        height: 44
        color: "#ffffff"
        text: qsTr("Type the word you see. Try not to rely on autocorrect:")
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 19
    }

    Text {
        id: timer
        x: 193
        y: 185
        width: 254
        height: 71
        color: "#ffffff"
        text: qsTr("0:3.54s")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 60
    }
    Item {
            property alias text: text_input.text
            x: 174
            y: 435
            anchors.centerIn: parent
            width: 304; height: 28
            anchors.verticalCenterOffset: 128
            anchors.horizontalCenterOffset: 0
            BorderImage {
                x: -6
                y: -6
                width: 316
                height: 46
                anchors.bottomMargin: -12
                anchors.topMargin: -6
                anchors.rightMargin: -6
                anchors.leftMargin: -6
                source: "qrc:/images/lineedit.sci"
                anchors.fill: parent
            }
        TextInput {
            id: text_input
            x: 19
            y: 0
            width: 254
            height: 34
            color: "#000000"
            text: qsTr("")
            cursorVisible: false
            font.pointSize: 20
            echoMode: TextInput.Normal
        }
    }

    Text {
        id: score
        x: 200
        y: 268
        width: 252
        height: 49
        color: "#ffffff"
        text: qsTr("Score: 3/6")
        horizontalAlignment: Text.AlignHCenter
        font.family: "Lucida Sans"
        wrapMode: Text.NoWrap
        font.pixelSize: 30
    }
}
