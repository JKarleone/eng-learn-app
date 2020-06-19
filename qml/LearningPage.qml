import Felgo 3.0
import QtQuick 2.12

Page {
    id: learningPage

    Column {
        anchors.centerIn: parent

        Component.onCompleted: {
            loader.sourceComponent = cardComponent
        }

        Loader {
            id: loader
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
                text: "Новое слово"
                detailText: "Название списка"
                enabled: false
            }

            content: Column {
                padding: dp(15)
                spacing: dp(15)

                AppText {
                    text: "Word"
                }

                AppText {
                    text: "Перевод:"
                    color: "grey"
                }

                AppText {
                    id: translatedWord
                    text: "Слово"
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
                console.log("Swipe completed")
                loader.sourceComponent = cardComponent
            }
        }
    }
}
