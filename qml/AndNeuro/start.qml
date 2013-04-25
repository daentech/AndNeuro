import QtQuick 1.0

Rectangle {
    id: startpage //unique id of the main object
    Background{ }
    width: 652 //width of the window
    height: 642 //height of the window
    color: "black" //background color of the window

    function openStart()
    {
        console.log("Opening start?");
    }

    Button{
        id: startBtn
        text: "Start"
        objectName: "startBtn"
    }


}
