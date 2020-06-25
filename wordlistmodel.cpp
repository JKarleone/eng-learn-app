#include "wordlistmodel.h"
#include <QDir>
#include <QtDebug>

WordListModel::WordListModel()
{
    if (!QDir("lists").exists())
        QDir().mkdir("lists");

    auto dir = QDir("lists");
    dir.setSorting(QDir::Time);
    QFileInfoList fileList = dir.entryInfoList();

    for (int i = 0; i < fileList.size(); i++) {
        QFileInfo fileInfo = fileList.at(i);
        QString fileName = fileInfo.fileName();

        if (fileName == "." || fileName == "..")
            continue;

        fileName = normalizeStr(fileName);

        if (fileName == "main" || fileName == "main lists")
            continue;

        stringList.append(fileName);
    }
}

QString WordListModel::normalizeStr(QString str)
{
    str = str.split(".")[0];
    return str.replace('_', ' ');
}

int WordListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return stringList.count();
}

QVariant WordListModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= stringList.size())
        return QVariant();

    if (role == Qt::DisplayRole)
        return stringList[index.row()];
    else
        return QVariant();
}

QHash<int, QByteArray> WordListModel::roleNames() const
{
    QHash<int, QByteArray> roleNames;
    roleNames[nameRole] = "name";
    return roleNames;
}

void WordListModel::addNewList(QString newListName)
{
    QString listName = newListName.replace(" ", "_");

    auto dir = QDir("lists");
    QFile newFile(dir.path() + "/" + listName + ".txt");

    emit addedNewList(newListName, !newFile.exists());

    if (newFile.exists())
        return;

    // Отображение нового списка в приложении
    beginInsertRows(QModelIndex(), 0, 0);
    stringList.insert(0, newListName);
    endInsertRows();

    // Создание файла
    newFile.open(QIODevice::WriteOnly);
    newFile.close();
}

void WordListModel::deleteList(QString listName, int index)
{
    listName = listName.replace(" ", "_");
    QFile file("lists/" + listName + ".txt");
    file.remove();

    beginRemoveRows(QModelIndex(), index, index);
    stringList.removeAt(index);
    endRemoveRows();
}
