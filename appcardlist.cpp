#include <QDir>
#include <QMap>
#include <QVariant>
#include <QVariantMap>
#include <QTextStream>
#include <QTextCodec>
#include "appcardlist.h"
#include "wordmodel.h"

AppCardList::AppCardList(QObject *parent) : QObject(parent)
{
    auto dir = QDir("lists");
    cardwordsPath = dir.path() + "/main.txt";
    QFile file (cardwordsPath);

    if (!file.exists())
    {
        file.open(QIODevice::WriteOnly);
        file.close();
    }

    initList();

    // Заполнение m_cardwords из файла main.txt
    if (file.open(QIODevice::ReadOnly))
    {
        while (!file.atEnd())
        {
            QByteArray line = file.readLine();
            if (line.isEmpty())
                continue;

            auto cardInfo = line.split('&');
            QString list = cardInfo[0];
            QString word = cardInfo[1];
            QString translation = cardInfo[2];
            int count = cardInfo[3].toInt();

            magicInsert(CardWord{ list, word, translation, count });
        }
    }
    file.close();

    std::sort(m_cardwords.begin(), m_cardwords.end());

    if (m_cardwords.size() != 0)
    {
        currentCard = m_cardwords.at(0);
        QStringList currentCardList;
    }
}

bool AppCardList::isEmpty()
{
    return m_cardwords.empty();
}

QStringList AppCardList::get()
{
    QStringList currentCardList;
    if (m_cardwords.size() != 0)
    {
        currentCardList.append(currentCard.list);
        currentCardList.append(currentCard.word);
        currentCardList.append(currentCard.translation);
        currentCardList.append(QString::number(currentCard.count));
    }
    return currentCardList;
}

void AppCardList::swipeCompleted(QString direction)
{
    if (direction == "right")
        currentCard.count++;

    m_cardwords.removeAt(0);
    magicInsert(currentCard);

    // Занесение изменений в main.txt
    if (direction == "right")
    {
        updateMainTxt();
        WordModel model;
        model.initialize(currentCard.list);
        model.updateWord(currentCard.word, currentCard.translation);
    }

    currentCard = m_cardwords[0];
}

void AppCardList::addList(QString listName)
{
    WordModel model;
    model.initialize(listName);
    QString filePath = model.getFilePath();

    // Добавление пути к файлу списка в main_list.txt и listNames
    listNames.append(filePath);
    QFile file(listNamesPath);
    if (file.open(QIODevice::Append))
    {
        QTextStream writeStream(&file);
        writeStream.setCodec(QTextCodec::codecForName("UTF-8"));
        writeStream << filePath + "\n";
    }
    file.close();

    // Запись всех слов из списка в main.txt и m_cardwords
    auto modelWords = model.getAllWords();
    QFile cardFile(cardwordsPath);
    if (cardFile.open(QIODevice::Append))
    {
        QTextStream writeStream(&cardFile);
        writeStream.setCodec(QTextCodec::codecForName("UTF-8"));

        for (int i = 0; i < modelWords.size(); i++)
        {
            WordInfo word = modelWords[i];
            CardWord cardword { listName, word.word, word.translation, word.count };

            QString record = cardword.list + "&" + cardword.word + "&"
                    + cardword.translation + "&" + QString::number(cardword.count) + "\n";

            writeStream << record;
            m_cardwords.append(cardword);
        }
    }
    cardFile.close();

    // Сортировка по значению CardWord.count
    std::sort(m_cardwords.begin(), m_cardwords.end());

    if (m_cardwords.size() != 0)
        currentCard = m_cardwords[0];
}

void AppCardList::removeList(QString listName)
{
    QString filePath = "lists/" + listName.replace(" ", "_") + ".txt";

    // *** Удаление списка из main_list.txt и listNames ***
    listNames.removeOne(filePath);
    QFile file(listNamesPath);
    if (file.open(QIODevice::WriteOnly))
    {
        QTextStream writeStream(&file);
        writeStream.setCodec(QTextCodec::codecForName("UTF-8"));

        QString listNamesStr;

        for (int i = 0; i < listNames.size(); i++)
            listNamesStr += listNames[i] + "\n";

        writeStream << listNamesStr;
    }
    file.close();

    // *** Удаление списка слов из main.txt и m_cardwords ***
    QFile mainFile(cardwordsPath);
    // Удаление всех данных из файла
    mainFile.open(QIODevice::WriteOnly | QIODevice::Truncate);
    mainFile.close();
    // Удаление из листа всех слов данного списка
    for (int i = 0; i < m_cardwords.size(); i++)
        if (m_cardwords[i].list == listName)
        {
            m_cardwords.removeAt(i);
            i--;
        }
    // Перезапись всех слов из листа в файл
    updateMainTxt();
}

// Инициализация listNames
void AppCardList::initList()
{
    auto dir = QDir("lists");
    listNamesPath = dir.path() + "/main_lists.txt";
    QFile file(listNamesPath);

    // Создание файла, если не существует
    if (!file.exists())
    {
        file.open(QIODevice::WriteOnly);
        file.close();
        return;
    }

    if (file.open(QIODevice::ReadOnly))
    {
        while(!file.atEnd())
        {
            QByteArray line = file.readLine();
            if (line.isEmpty())
                continue;
            listNames.append(line);
        }
    }
    file.close();
}

void AppCardList::magicInsert(CardWord cardword)
{
    m_cardwords.append(cardword);
}

bool AppCardList::isListExist(QString listName)
{
    for (int i = 0; i < listNames.size(); i++)
    {
        QFile file(listNames[i]);
        QString name = file.fileName()
                           .split("/")[1]
                           .split(".")[0]
                           .replace("_", " ");
        if (listName == name)
            return true;
    }
    return false;
}

void AppCardList::updateMainTxt()
{
    // Обновление данных в main.txt данными из m_cardwords
    QFile file(cardwordsPath);
    if (file.open(QIODevice::WriteOnly))
    {
        QTextStream writeStream(&file);
        writeStream.setCodec(QTextCodec::codecForName("UTF-8"));

        QString inputStr;

        for (int i = 0; i < m_cardwords.size(); i++)
        {
            CardWord cardword = m_cardwords[i];

            QString record = cardword.list + "&" + cardword.word + "&"
                    + cardword.translation + "&" + QString::number(cardword.count) + "\n";

            inputStr += record;
        }

        writeStream << inputStr;
    }
    file.close();

    if (m_cardwords.size() != 0)
        currentCard = m_cardwords[0];
}

void AppCardList::removeWord(QString list, QString word, QString translation)
{
    for (int i = 0; i < m_cardwords.size(); i++)
    {
        CardWord cardword = m_cardwords[i];
        if (cardword.list == list &&
            cardword.word == word &&
            cardword.translation == translation)
        {
            m_cardwords.removeAt(i);
            updateMainTxt();
            break;
        }
    }
}

void AppCardList::addWord(QString list, QString word, QString translation)
{
    magicInsert(CardWord { list, word, translation, 0 });
    updateMainTxt();
}
