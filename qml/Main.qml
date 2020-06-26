import Felgo 3.0
import QtQuick 2.13

App {
    id: app
    screenHeight: 720
    screenWidth: 1280

    minimumHeight: 600
    minimumWidth: 800

    Navigation {
        navigationMode: navigationModeTabs

        NavigationItem {
            title: "Учить"
            icon: IconType.book

            NavigationStack {
                initialPage:
                    LearningPage {
                    id: learningPage
                    title: "Учить"
                }
            }
        }

        NavigationItem {
            title: "Списки"
            icon: IconType.list

            NavigationStack {
                initialPage:
                WordListsPage {
                    id: listsPage
                    title: "Списки слов"
                }
            }
        }
    }

}
