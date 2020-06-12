import Felgo 3.0
import WordListModel 1.0

ListPage {
    id: listsPage

    model: wordListModel
    delegate: SimpleRow {
        text: name
        AppCheckBox {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: parent.width / 20
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
        negativeActionLabel: "Отмена"

        AppTextField {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            borderWidth: 1
            borderColor: "#1C77C3"

            placeholderText: "Название нового списка"
        }

        onCanceled: close()
        onAccepted: {
            //Добавление нового списка в wordListModel
            close()
            console.log("Добавление нового списка")
        }
    }

    WordListModel {
        id: wordListModel
    }
}
