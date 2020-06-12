import Felgo 3.0
import QtQuick 2.12

Page {
    id: learningPage

    Column {
        anchors.centerIn: parent
//        AppPaper {
//            width: dp(200)
//            height: dp(300)
////            margin: parent.height / 20

//            AppText {
//                id: word
//                width: parent.width
//                text: "Some word"
//                horizontalAlignment: Text.AlignHCenter
//                topPadding: parent.height / 10
//            }

//            AppText {
//                id: translation
//                width: parent.width
//                text: "Some translation"
//                color: "green"
//                visible: false
//                horizontalAlignment: Text.AlignHCenter
//                topPadding: parent.height / 5
//            }

//            AppCardSwipeArea {
//                rotationFactor: 0.05

//            }
//        }

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
        }
    }
}