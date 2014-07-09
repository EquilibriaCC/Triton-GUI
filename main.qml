import QtQuick 2.2
import QtQuick.Window 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import "components"

ApplicationWindow {
    id: appWindow
    objectName: "appWindow"
    property var currentItem
    property bool whatIsEnable: false
    property bool ctrlPressed: false
    function ctrlKeyPressed() { ctrlPressed = true; }
    function ctrlKeyReleased() { ctrlPressed = false; }
    function sequencePressed(seq) {
        if(seq === undefined)
            return
        if(seq === "Ctrl+D") middlePanel.state = "Dashboard"
        else if(seq === "Ctrl+H") middlePanel.state = "History"
        else if(seq === "Ctrl+T") middlePanel.state = "Transfer"
        else if(seq === "Ctrl+B") middlePanel.state = "AddressBook"
        else if(seq === "Ctrl+M") middlePanel.state = "Minning"
        else if(seq === "Ctrl+S") middlePanel.state = "Settings"
        leftPanel.selectItem(middlePanel.state)
    }
    function mousePressed(obj, mouseX, mouseY) {
        if(obj.objectName === "appWindow")
            obj = rootItem

        var tmp = rootItem.mapFromItem(obj, mouseX, mouseY)
        if(tmp !== undefined) {
            mouseX = tmp.x
            mouseY = tmp.y
        }

        if(currentItem !== undefined) {
            var tmp_x = rootItem.mapToItem(currentItem, mouseX, mouseY).x
            var tmp_y = rootItem.mapToItem(currentItem, mouseX, mouseY).y

            if(!currentItem.containsPoint(tmp_x, tmp_y)) {
                currentItem.hide()
                currentItem = undefined
            }

        }
    }
    function mouseReleased(obj, mouseX, mouseY) {

    }

    visible: true
    width: 1269
    height: 800
    color: "#FFFFFF"
    x: (Screen.width - width) / 2
    y: (Screen.height - height) / 2
    flags: Qt.FramelessWindowHint | Qt.WindowSystemMenuHint | Qt.Window | Qt.WindowMinimizeButtonHint

    Item {
        id: rootItem
        anchors.fill: parent

        MouseArea {
            property var previousPosition
            anchors.fill: parent

            onPressed: previousPosition = Qt.point(mouseX, mouseY)
            onPositionChanged: {
                if (pressedButtons == Qt.LeftButton) {
                    var dx = mouseX - previousPosition.x
                    var dy = mouseY - previousPosition.y
                    appWindow.x += dx
                    appWindow.y += dy
                }
            }
        }

        LeftPanel {
            id: leftPanel
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            onDashboardClicked: middlePanel.state = "Dashboard"
            onHistoryClicked: middlePanel.state = "History"
            onTransferClicked: middlePanel.state = "Transfer"
            onAddressBookClicked: middlePanel.state = "AddressBook"
            onMiningClicked: middlePanel.state = "Minning"
            onSettingsClicked: middlePanel.state = "Settings"
        }

        RightPanel {
            id: rightPanel
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }

        MiddlePanel {
            id: middlePanel
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: leftPanel.right
            anchors.right: rightPanel.left
            state: "Dashboard"
        }

        TipItem {
            id: tipItem
            text: "send to the same destination"
            visible: false
            z: 100
        }
    }
}