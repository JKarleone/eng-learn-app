import Felgo 3.0
import QtQuick 2.12
import WordListModel 1.0

ListPage {
    id: listPage

    property string listName: ""

    model: wordListModel
    delegate: SimpleRow {
        text: name
        AppCheckBox {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: parent.width / 10
        }

        IconButton {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: parent.width / 200
            icon: IconType.angleright
            size: dp(25)

            onClicked: {
                listName = name
                listPage.navigationStack.push(wordListComponent)
            }
        }
    }

    FloatingActionButton {
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        icon: IconType.plus
        visible: true

        onClicked: {
            addingNewListDialog.open()
        }
    }

    Dialog {
        id: addingNewListDialog
        title: "Создать новый список"

        positiveActionLabel: "Добавить"
        negativeActionLabel: "Закрыть"

        Column {
            anchors.centerIn: parent
            spacing: 10

            AppTextField {
                id: newListNameField
                borderWidth: 1
                borderColor: "#1C77C3"
                font.pixelSize: 16

                placeholderText: "Название нового списка"
            }

            AppText {
                id: message
                visible: false
                width: parent.width
                fontSize: 13
            }
        }

        onCanceled: {
            message.visible = false
            newListNameField.clear()
            close()
        }
        onAccepted: {
            message.color = "red"
            message.visible = true

            if (newListNameField.text == "") {
                message.text = "Осталось пустое поле"
            }

            //Недопустимые символы в названии списка
            var re = /[`~#;%^:&?*(-_)+=|/\<>{}"]/
            if (newListNameField.text.search(re) != -1) {
                message.text = "Название содержит недопустимые символы"  
            }
            else {
                //Добавление нового списка в wordListModel
                wordListModel.addNewList(newListNameField.text)
            }
            console.log("Добавление нового списка")
        }
    }

    WordListModel {
        id: wordListModel

        onAddedNewList: {
            if (added) {
                message.text = "Список \"" + newListName + "\" успешно добавлен!"
                message.color = "green"
            }
            else {
                message.text = "Список с таким названием уже существует!"
                message.color = "red"
            }
            message.visible = true
        }
    }

    Component {
        id: wordListComponent

        WordsPage {
            title: listName
        }
    }
}
