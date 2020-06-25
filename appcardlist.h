#ifndef APPCARDLIST_H
#define APPCARDLIST_H

#include <QObject>
#include <QMap>

struct CardWord
{
    QString list;
    QString word;
    QString translation;
    int count;

    bool operator<(const CardWord &other) const
    {
        return count < other.count;
    }
};

class AppCardList : public QObject
{
    Q_OBJECT
public:
    explicit AppCardList(QObject *parent = nullptr);

    Q_INVOKABLE QStringList get();

    Q_INVOKABLE void swipeCompleted(QString direction);

    Q_INVOKABLE void addList(QString listName);
    Q_INVOKABLE void removeList(QString listName);
    Q_INVOKABLE bool isEmpty();
    Q_INVOKABLE bool isListExist(QString listName);

    Q_INVOKABLE void addWord(QString list, QString word, QString translation);
    Q_INVOKABLE void deleteWord(QString list, QString word, QString translation);

signals:
    void showData();

private:
    QList<CardWord> m_cardwords;
    QString cardwordsPath;

    QStringList listNames;
    QString listNamesPath;

    CardWord currentCard;

    void initList();
    void magicInsert(CardWord cardword);
    void updateMainTxt();
};

#endif // APPCARDLIST_H
