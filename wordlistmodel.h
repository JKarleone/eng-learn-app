#ifndef WORDLISTMODEL_H
#define WORDLISTMODEL_H

#include <QObject>
#include <QAbstractListModel>

class WordListModel : public QAbstractListModel
{
    Q_OBJECT

    enum myRoles
    {
        nameRole = Qt::DisplayRole
    };

public:
    WordListModel();

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    QHash<int, QByteArray> roleNames() const override;

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
private:
    QStringList stringList;
    QString normalizeStr(QString str);
};

#endif // WORDLISTMODEL_H
