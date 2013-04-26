import QtQuick 1.0
import FileIO 1.0

Rectangle {
    id: page //unique id of the main object
    Background{ }
    width: 652 //width of the window
    height: 642 //height of the window
    color: "black" //background color of the window

    // Define signals
    signal startRecording(string user, string description);
    signal stopRecording();

    property int value: 0 //value of one EEG channel
    property int packetCounter: 0 //used for visualizing activity
    property int initTime: 10000/30 // Initial time
    property int timeCounter: initTime // Used to keep track of the current time
    property bool running: false;

    property bool typingTask: false;

    // User details
    property int complete: 0;
    property int score: 0;
    property int total: 0;
    property string username;

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
    "pronunciation",
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

    function addTimestamp(correct){
        timestamps = timestamps.concat({"timestamp": new Date().getTime(), "correct" : correct});
        console.log(JSON.stringify(timestamps));
    }

    function timerTick(){
        if(running){
            timeCounter--;
            if(timeCounter <= 0) {
                timeCounter = 0;
                running = false;
                // TODO show message to say complete, score and then go to high score table

                // TODO Stop the data recording
                stopRecording();

                // TODO save the timestamps to a file
                myFile.source = username + "_timestamps_" + new Date().getTime() + ".txt";

                myFile.write(JSON.stringify(timestamps));

                list_model_leaderboard.clear();
                makeList(list_model_leaderboard);


                mainView.visible = false;
                leaderboardView.visible = true;
            }
            timer.text = "Time: " + timeToString(timeCounter);
        }
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
        username = username_input.text;
        flankerInstructionsView.visible = !typingTask;
        typingInstructionsView.visible = typingTask;
        startView.visible = false;
        instructionView.visible = true;
    }

    function openTyping()
    {
        typingTask = true;
        openStart();
    }

    function openFlanker()
    {
        typingTask = false;
        openStart();
    }

    function resetToMainMenu()
    {
        // Hide everything except the startView
        username_input.text = "";
        username_input.focus = true;
        timeCounter = initTime;
        score = 0;
        complete = 0;
        timestamps = [];

        leaderboardView.visible = false;
        instructionView.visible = false;
        mainView.visible = false;
        startView.visible = true;
    }

    function startProgram()
    {
        complete = 0;
        total = 0;
        score = 0;
        words = fisherYates(words);
        text_show.text = words[complete];
        instructionView.visible = false;
        text_input.focus = true;
        mainView.visible = true;

        if(typingTask){
            // Show the typing task view
        } else {
            // Show the flanker task view
        }

        startRecording(username + (typingTask ? "-typing" : "-flanker"), (typingTask ? "typing" : "flanker"));
        running = true;
    }

    function changeWord(){
        if(text_input.text == words[complete]){
            addTimestamp(true);
            score++;
        } else {
            addTimestamp(false);
        }

        total++;
        text_show.text = words[++complete];
        text_input.focus = false;
        text_input.text = "";
        text_input.focus = true;

    }

    function makeList(id){

        myFile.source = "leaderboard.txt";

        var ldrboard = myFile.read();
        var scores = [];

        scores.push({"name":username,"score":score});
        if(ldrboard)
            scores = scores.concat(eval(ldrboard));
        scores.sort(compare);
        for(var i = scores.length - 1; i >= 0; i--){
            id.append({"index": scores.length - i, "name":scores[i].name, "score":scores[i].score});
        }

        myFile.write(JSON.stringify(scores));
    }

    function compare(a,b) {
      if (a.score < b.score)
         return -1;
      if (a.score > b.score)
        return 1;
      return 0;
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

        Text {
            color: "#FFFFFF"
            text: "Enter your name and choose a task from below"
            font.pointSize: 12
            horizontalAlignment: Text.AlignHCenter
            anchors.top: parent.top
            anchors.topMargin: 50
            wrapMode: Text.WordWrap
            anchors.right: parent.right
            anchors.rightMargin: 100
            anchors.left: parent.left
            anchors.leftMargin: 100
        }
        Item {
            id: item1
                property alias text: text_input.text
                x: 174
                y: 290
                width: 304; height: 59
                anchors.top: parent.top
                anchors.topMargin: 290
                anchors.horizontalCenterOffset: 0
                anchors.horizontalCenter: parent.horizontalCenter
                BorderImage {
                    x: -6
                    y: -5
                    width: 316
                    height: 53
                    anchors.bottomMargin: 0
                    anchors.topMargin: 0
                    anchors.rightMargin: 0
                    anchors.leftMargin: 0
                    source: "qrc:/images/lineedit.sci"
                    anchors.fill: parent
                }
            TextInput {
                id: username_input
                color: "#000000"
                text: qsTr("")
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                anchors.top: parent.top
                anchors.topMargin: 10
                cursorVisible: false
                font.pointSize: 10
                echoMode: TextInput.Normal
                focus: true
                Keys.onPressed: {
                        if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return || event.key == Qt.Key_Space) {
                            changeWord();
                        }
                    }
            }
        }

        Button{
            id: startFlankerBtn
            x: 301
            text: "Flanker Task"
            anchors.top: parent.top
            anchors.topMargin: 400
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: openFlanker()
        }

        Button{
            id: startTypingBtn
            x: 301
            text: "Typing Task"
            anchors.top: parent.top
            anchors.topMargin: 500
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: openTyping()
        }
    }

    Rectangle {

        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0 //width of the window
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0 //height of the window

        visible: false;
        id: instructionView;

        Rectangle {
            id: typingInstructionsView
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0

            Background{
                id: background2
            }

            // TODO instruction for typing task
            Text {
                color: "#FFFFFF"
                text: "Typing instructions"
                font.pointSize: 15
                anchors.top: parent.top
                anchors.topMargin: 50
                anchors.horizontalCenter: parent.horizontalCenter
                verticalAlignment: Text.AlignTop
            }

            Flickable {
                id: flickable1
                y: 77
                anchors.right: parent.right
                anchors.rightMargin: 50
                anchors.left: parent.left
                anchors.leftMargin: 50
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                flickableDirection: Flickable.VerticalFlick
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 150
                anchors.top: parent.top
                anchors.topMargin: 150

                Text {
                    id: typingTaskInstructions
                    color: "#ffffff"
                    text: qsTr("These are the instructions for the typing task.\nThis ought to be a new line..\n\nMore intructions in another paragraph")
                    wrapMode: Text.WordWrap
                    anchors.top: parent.top
                    anchors.topMargin: 30
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    font.pointSize: 11
                }

                contentHeight: typingTaskInstructions.height
                contentWidth: typingTaskInstructions.width
                }
        }

        Rectangle {
            id: flankerInstructionsView
            x: 50
            y: 0
            width: 552
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0

            Background{
                id: background3
            }

            // TODO insruction for flanker task
            Text {
                color: "#FFFFFF"
                text: "Flanker instructions"
                font.pointSize: 15
                anchors.top: parent.top
                anchors.topMargin: 50
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Flickable {
                id: flickable2
                anchors.right: parent.right
                anchors.rightMargin: 50
                anchors.left: parent.left
                anchors.leftMargin: 50
                boundsBehavior: Flickable.StopAtBounds
                clip: true
                flickableDirection: Flickable.VerticalFlick
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 150
                anchors.top: parent.top
                anchors.topMargin: 150

                Text {
                    id: flankerInstructionsText
                    color: "#ffffff"
                    text: qsTr("These are the instructions for the flanker task\nWith some newlines\n\nAnd a couple of paragraphs\nThese are the instructions for the flanker task\nWith some newlines\n\nAnd a couple of paragraphs\nThese are the instructions for the flanker task\nWith some newlines\n\nAnd a couple of paragraphs\nThese are the instructions for the flanker task\nWith some newlines\n\nAnd a couple of paragraphs\nThese are the instructions for the flanker task\nWith some newlines\n\nAnd a couple of paragraphs\nThese are the instructions for the flanker task\nWith some newlines\n\nAnd a couple of paragraphs\nThese are the instructions for the flanker task\nWith some newlines\n\nAnd a couple of paragraphs\nThese are the instructions for the flanker task\nWith some newlines\n\nAnd a couple of paragraphs\nThese are the instructions for the flanker task\nWith some newlines\n\nAnd a couple of paragraphs\nThese are the instructions for the flanker task\nWith some newlines\n\nAnd a couple of paragraphs\nThese are the instructions for the flanker task\nWith some newlines\n\nAnd a couple of paragraphs\nThese are the instructions for the flanker task\nWith some newlines\n\nAnd a couple of paragraphs\nThese are the instructions for the flanker task\nWith some newlines\n\nAnd a couple of paragraphs\nThese are the instructions for the flanker task\nWith some newlines\n\nAnd a couple of paragraphs\nThese are the instructions for the flanker task\nWith some newlines\n\nAnd a couple of paragraphs\nThese are the instructions for the flanker task\nWith some newlines\n\nAnd a couple of paragraphs\nThese are the instructions for the flanker task\nWith some newlines\n\nAnd a couple of paragraphs\nThese are the instructions for the flanker task\nWith some newlines\n\nAnd a couple of paragraphs\nThese are the instructions for the flanker task\nWith some newlines\n\nAnd a couple of paragraphs\nThese are the instructions for the flanker task\nWith some newlines\n\nAnd a couple of paragraphs\nThese are the instructions for the flanker task\nWith some newlines\n\nAnd a couple of paragraphs\nThese are the instructions for the flanker task\nWith some newlines\n\nAnd a couple of paragraphs\nThese are the instructions for the flanker task\nWith some newlines\n\nAnd a couple of paragraphs\nThese are the instructions for the flanker task\nWith some newlines\n\nAnd a couple of paragraphs\nThese are the instructions for the flanker task\nWith some newlines\n\nAnd a couple of paragraphs\nThese are the instructions for the flanker task\nWith some newlines\n\nAnd a couple of paragraphs\n")
                    wrapMode: Text.WordWrap
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 30
                    font.pointSize: 11
                }

                contentHeight: flankerInstructionsText.height
                contentWidth: flickable2.width
            }
        }

        Button{
            id: acceptBtn
            x: 301
            y: 241
            text: "Start Test"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 50
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: startProgram()
        }
    }
    Rectangle {

        width: 652 //width of the window
        height: 642 //height of the window

        visible: false
        id: mainView

        Rectangle {
            id: typingTaskView
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0

        Background{ }
            Button {
                id: doneBtn
                x: 491
                y: 433
                color: "#FFFFFF"
                text: "Done"
                onClicked: changeWord()
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
                width: 304; height: 66
                anchors.verticalCenterOffset: 128
                anchors.horizontalCenterOffset: 0
                BorderImage {
                    x: -6
                    y: -6
                    width: 316
                    height: 64
                    anchors.bottomMargin: -30
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
                height: 52
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
        }
        Rectangle{
            id:flankerTaskView
        }
    }

    MessageBox {
        id: outtatime
        text: "You finished!"
        width: 200
        height:200
        visible: false;
    }

    Rectangle {
        anchors.fill: parent;
        id: leaderboardView;

        visible: false;

        width: 652 //width of the window
        height: 642 //height of the window

        FileIO {
                id: myFile
                source: "leaderboard.txt"
                onError: console.log(msg)
        }

        Background{
            id: background1
            ListView {
                id: list_view_leaderboard
                x: 188
                width: 276
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 105
                anchors.top: parent.top
                anchors.topMargin: 150
                anchors.horizontalCenter: parent.horizontalCenter
                delegate: Item {
                    x: 5
                    height: 40
                    Row {
                        id: row1
                        spacing: 10

                        Text {
                            text: index + ": " + name + " - " + score
                            anchors.verticalCenter: parent.verticalCenter
                            font.bold: true
                            color: "#FFFFFF"
                        }
                    }
                }
                model: ListModel { id: list_model_leaderboard }
                }
            }

        Text{
            x: 289
            y: 108
            color: "#ffffff"
            text: "High Scores"
            horizontalAlignment: Text.AlignLeft
            font.pointSize: 24
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.horizontalCenterOffset: 1
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button{
            id: resetToStartBtn
            x: 282
            y: 557
            text: "Main Menu"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 59
            anchors.horizontalCenterOffset: 1
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: resetToMainMenu()
        }
    }
}
