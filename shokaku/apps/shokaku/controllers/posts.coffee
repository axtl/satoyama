Shokaku.postsController = SC.ArrayController.create(
    SC.CollectionViewDelegate

    collectionViewDeleteContent: (view, content, indexes) ->
        # destroy the records
        records = indexes.map (idx) =>
            this.objectAt(idx)

        records.invoke('destroy')

        selIndex = indexes.get 'min' - 1
        selIndex = 0 if selIndex < 0
        this.selectObject(this.objectAt(selIndex))
)
