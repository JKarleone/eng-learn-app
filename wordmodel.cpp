#include <QDir>
#include <QTextStream>
#include <QTextCodec>
#include "wordmodel.h"

WordModel::WordModel()
{

}

int WordModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return words.size();
}

QHash<int, QByteArray> WordModel::roleNames() const
{
    QHash<int, QByteArray> roleNames;
    roleNames[wordRole] = "word";
    roleNames[translationRole] = "translation";
    roleNames[countRole] = "count";
    return roleNames;
}

QVariant WordModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= words.size())
        return QVariant();

    switch (role) {
    case wordRole:
        return words[index.row()].word;

    case translationRole:
        return words[index.row()].translation;

    case countRole:
        return words[index.row()].count;

    default:
        return QVariant();
    }
}

void WordModel::initialize(QString listName)
{
    listName = listName.replace(" ", "_");

    auto dir = QDir("lists");
    filePath = dir.path() + "/" + listName + ".txt";
    QFile file(filePath);

    if (file.exists() && file.open(QIODevice::ReadOnly))
    {
        while (!file.atEnd())
        {
            QByteArray line = file.readLine();
            if (line.isEmpty())
                continue;

            auto wordInfo = line.split('&');
            QString word = wordInfo[0];
            QString translation = wordInfo[1];
            int count = wordInfo[2].toInt();

            beginInsertRows(QModelIndex(), 0, 0);
            words.insert(0, WordInfo{ word, translation, count });
            endInsertRows();
        }
    }
    file.close();
}

void WordModel::addNewWord(QString word, QString translation)
{
    QFile file(filePath);

    if (file.open(QIODevice::Append | QIODevice::Text))
    {
        QTextStream writeStream(&file);
        writeStream.setCodec(QTextCodec::codecForName("UTF-8"));
        QString record = word.toLower() + "&" + translation.toLower() + "&" + "0\n";
        writeStream << record;
    }
    file.close();

    beginInsertRows(QModelIndex(), 0, 0);
    words.insert(0, WordInfo{ word, translation, 0});
    endInsertRows();

    emit addedNewWord(word, true);
}

void WordModel::deleteWord(int index)
{
    QFile file(filePath);
    int realIndex = rowCount() - index - 1;

    QString fileStr = "";
    file.open(QIODevice::ReadOnly);

    for (int i = 0; i < rowCount(); i++)
    {
        if (i == realIndex)
            continue;
        QByteArray line = file.readLine();
        fileStr += line;
    }
    file.close();

    if (file.open(QIODevice::WriteOnly))
    {
        QTextStream writeStream(&file);
        writeStream.setCodec(QTextCodec::codecForName("UTF-8"));
        writeStream << fileStr;
    }
    file.close();

    beginRemoveRows(QModelIndex(), index, index);
    words.removeAt(index);
    endRemoveRows();
}

QList<WordInfo> WordModel::getAllWords()
{
    return words;
}

QString WordModel::getFilePath()
{
    return filePath;
}
