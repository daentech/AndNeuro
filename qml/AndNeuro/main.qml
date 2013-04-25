import QtQuick 1.0

Rectangle {
    id: page //unique id of the main object
    Background{ }
    width: 652 //width of the window
    height: 642 //height of the window
    color: "black" //background color of the window
    property int value: 0 //value of one EEG channel
    property int packetCounter: 0 //used for visualizing activity
    property int timeCounter: 30000/30 // Used to keep track of the current time
    property bool running: false;
    property int complete: 0;
    property int score: 0;
    property int total: 0;

    property variant timestamps: [];

    property variant words: [
    "acceptable",
    "accidentally",
    "accommodate",
    "acquire",
    "acquit",
    "amateur",
    "apparent",
    "argument",
    "atheist",
    "believe",
    "calendar",
    "category",
    "cemetery",
    "changeable",
    "collectible",
    "column",
    "committed",
    "conscience",
    "conscientious",
    "conscious",
    "consensus",
    "definite",
    "discipline",
    "drunkenness",
    "dumbbell",
    "embarrass",
    "equipment",
    "exhilirate",
    "exceed",
    "existence",
    "experience",
    "fiery",
    "foreign",
    "gauge",
    "grateful",
    "guarantee",
    "harass",
    "height",
    "hierarchy",
    "ignorance",
    "immediate",
    "independent",
    "indispensable",
    "inoculate",
    "intelligence",
    "it's",
    "its",
    "kernel",
    "leisure",
    "liaison",
    "library",
    "lightning",
    "maintenance",
    "memento",
    "millennium",
    "miniature",
    "miniscule",
    "mischievous",
    "misspell",
    "neighbour",
    "noticeable",
    "occasionally",
    "occurrence",
    "pastime",
    "perseverance",
    "personnel",
    "playwright",
    "possession",
    "precede",
    "privilege",
    "prounciation",
    "publicly",
    "questionnaire",
    "receive",
    "recommend",
    "referred",
    "reference",
    "relevant",
    "restaurant",
    "rhyme",
    "rhythm",
    "schedule",
    "separate",
    "sergeant",
    "supersede",
    "there",
    "their",
    "they're",
    "threshold",
    "twelfth",
    "tyranny",
    "until",
    "vacuum"
    ];

    function timeTick()
    {
        page.packetCounter = (page.packetCounter + 1)%16;
    }

    function timerTick(){
        if(running)
            timeCounter--;
            if(timeCounter <= 0) {
                timeCounter = 0;
                running = false;
                // TODO show message to say complete, score and then go to high score table
                outatime.show();

                // TODO Stop the data recording
                // stopRecording();
            }

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

    function openStart()
    {
        startView.visible = false;
        instructionView.visible = true;
    }

    function startProgram()
    {
        complete = 0;
        total = 0;
        score = 0;
        words = fisherYates(words);
        text_show.text = words[complete];
        instructionView.visible = false;
        mainView.visible = true;
        // TODO start data recording
        // startRecording(QString user, QString description);
        running = true;
    }

    function changeWord(){
        // TODO compare typed word to the one from the array
        if(text_input.text == words[complete])
            score++;
        total++;
        text_show.text = words[++complete];
        text_input.text = "";

    }

    function fisherYates ( myArray ) {
      var i = myArray.length, j, tempi, tempj;
      if ( i === 0 ) return false;
      while ( --i ) {
         j = Math.floor( Math.random() * ( i + 1 ) );
         tempi = myArray[i];
         tempj = myArray[j];
         myArray[i] = tempj;
         myArray[j] = tempi;
       }

      return myArray;
    }

    Rectangle {
        anchors.fill: parent;
        id: startView;

        width: 652 //width of the window
        height: 642 //height of the window

        Background{ }

        Button{
            id: startBtn
            x: 301
            y: 241
            text: "Instructions"
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: openStart()
        }
    }
    Rectangle {

        width: 652 //width of the window
        height: 642 //height of the window

        Background{
        }

        Text {
            id: text1
            x: 93
            y: 80
            width: 463
            height: 511
            text: qsTr("AndNeuro Data record")
            font.pixelSize: 12
        }

        Button{
            id: acceptBtn
            x: 301
            y: 241
            text: "Start"
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: startProgram()
        }

        visible: false;
        id: instructionView;



    }
    Rectangle {

        width: 652 //width of the window
        height: 642 //height of the window

        Background{ }

        visible: false;
        id: mainView;

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
                Keys.onPressed: {
                        if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return || event.key == Qt.Key_Space) {
                            changeWord();
                        }
                    }
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

    MessageBox {
        id: outtatime
        text: "You finished!"
        width: 200
        height:200
    }
}
