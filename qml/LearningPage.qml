import Felgo 3.0
import QtQuick 2.12

Page {
    id: learningPage

    property string listName: ""
    property string word: ""
    property string translation: ""
    property int count: -1

    function updateData() {
        var list = AppCardList.get()

        if (list.length != 0) {
            listName = list[0]
            word = list[1]
            translation = list[2]
            count = list[3]
            loader.sourceComponent = cardComponent
        }
        else {
            loader.sourceComponent = textComponent
        }

        console.log(listName)
        console.log(word)
        console.log(translation)
        console.log(count)
    }

    Column {
        anchors.centerIn: parent

        Component.onCompleted: {
            updateData()
        }

        Loader {
            id: loader

            Connections {
                target: AppCardList;
                onShowData: {
                    console.log("working")
                    if (!AppCardList.isEmpty()) {
                        loader.sourceComponent = cardComponent
                        updateData()
                    }
                    else
                        loader.sourceComponent = textComponent
                }
            }
        }
    }

    Component {
        id: textComponent

        AppText {
            id: mainText

            text: "Похоже слов больше нет"
            font.pixelSize: dp(20)
            color: "red"
        }
    }

    Component {
        id: cardComponent

        AppCard {
            id: card
            width: dp(300)
            height: dp(300)
            paper.radius: dp(5)
            swipeEnabled: true

            header: SimpleRow {
                text: count == "0" ? "Новое слово" : count + "й повтор слова"
                detailText: listName
                enabled: false
            }

            content: Column {
                padding: dp(15)
                spacing: dp(15)

                AppText {
                    text: word
                }

                AppText {
                    text: "Перевод:"
                    color: "grey"
                }

                AppText {
                    id: translatedWord
                    text: translation
                    font.bold: true
                    visible: false
                }
                IconButton {
                    icon: IconType.eye
                    selectedIcon: IconType.eyeslash
                    toggle: true

                    onClicked: {
                        translatedWord.visible = !translatedWord.visible
                    }
                }
            }

            actions: Row {
                spacing: card.width - leftBtn.width - rightBtn.width

                AppButton {
                    id: leftBtn
                    text: "Учить дальше"
                    flat: true

                    onClicked: {
                        card.cardSwipeArea.swipeOut("left")
                    }
                }
                AppButton {
                    id: rightBtn
                    text: "Запомнилось"
                    flat: true

                    onClicked: {
                        card.cardSwipeArea.swipeOut("right")
                    }
                }
            }

            cardSwipeArea.swipeOutDuration: 400
            cardSwipeArea.rotationFactor: 0.075

            cardSwipeArea.onSwipeOutCompleted: {
                loader.sourceComponent = undefined

                console.log("Swipe completed on " + direction)

                AppCardList.swipeCompleted(direction)
                updateData()

                loader.sourceComponent = cardComponent
            }
        }
    }
}
