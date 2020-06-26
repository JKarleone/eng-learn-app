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
                var title = wordListPage.title

                AppCardList.removeWord(title,
                                       word,
                                       translation)
                wordModel.deleteWord(index)
                AppCardList.showData()
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

            var word = newWordNameField.text
            var translation = translationField.text
            var title = wordListPage.title

            if (word == "" ||
                translation == "") {
                message.text = "Присутствуют пустые поля! Заполните их!"
                return
            }

            var re = /[&]/
            if (word.search(re) != -1 ||
                translation.search(re) != -1) {
                message.text = "Заполненные поля содержат недопустимые символы!"
            }
            else {
                wordModel.addNewWord(word,
                                     translation)

                if (AppCardList.isListExist(title)){
                    AppCardList.addWord(title,
                                        word,
                                        translation)
                    AppCardList.showData()
                }
            }

            newWordNameField.focus = true

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
