#ifndef WORDMODEL_H
#define WORDMODEL_H

#include <QObject>
#include <QAbstractListModel>

struct WordInfo
{
    QString word;
    QString translation;
    int count;
};

class WordModel : public QAbstractListModel
{
    Q_OBJECT

    enum myRoles
    {
        wordRole = Qt::DisplayRole,
        translationRole,
        countRole
    };

public:
    WordModel();

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    QHash<int, QByteArray> roleNames() const override;

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    Q_INVOKABLE void initialize(QString listName);
    Q_INVOKABLE void addNewWord(QString word, QString translation);

signals:
    void addedNewWord(QString word, bool added);

private:
    QList<WordInfo> words;
    QString filePath;
    QString decode(QByteArray str);
};

#endif // WORDMODEL_H
