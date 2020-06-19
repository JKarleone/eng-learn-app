import Felgo 3.0
import QtQuick 2.12
import WordModel 1.0

ListPage {
    id: wordListPage

    model: wordModel
    delegate: SimpleRow {
        text: word
        detailText: translation

        IconButton {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: parent.width / 100
            icon: IconType.close

            onClicked: {
                wordModel.deleteWord(index)
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
            addingNewWordDialog.open()
        }
    }

    Dialog {
        id: addingNewWordDialog
        title: "Добавить новое слово"

        positiveActionLabel: "Добавить"
        negativeActionLabel: "Закрыть"

        Column {
            anchors.centerIn: parent
            spacing: 10

            AppTextField {
                id: newWordNameField
                borderWidth: 1
                borderColor: "#1C77C3"

                placeholderText: "Введите новое слово"
            }

            AppTextField {
                id: translationField
                borderWidth: 1
                borderColor: "#1C77C3"
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width

                placeholderText: "Перевод"
            }

            AppText {
                id: message
                visible: false
                width: parent.width
                fontSize: 13
                text: "Test"
            }
        }

        onCanceled: {
            message.visible = false;
            newWordNameField.clear()
            translationField.clear()
            close()
        }

        onAccepted: {
            message.text = ""
            message.color = "red"
            message.visible = true

            if (newWordNameField.text == "" ||
                translationField.text == "") {
                message.text = "Присутствуют пустые поля! Заполните их!"
                return
            }

            var re = /[&]/
            if (newWordNameField.text.search(re) != -1 ||
                translationField.text.search(re) != -1) {
                message.text = "Заполненные поля содержат недопустимые символы!"
            }
            else {
                wordModel.addNewWord(newWordNameField.text,
                                     translationField.text)
            }

            console.log("Добавление нового слова в список '" + wordListPage.title + "'")
        }
    }

    WordModel {
        id: wordModel

        Component.onCompleted: wordModel.initialize(wordListPage.title)

        onAddedNewWord: {
            if (added) {
                message.text = "Слово \"" + word + "\" добавлено!"
                message.color = "green"
                message.visible = true

                newWordNameField.clear()
                translationField.clear()
            }
        }
    }
}
