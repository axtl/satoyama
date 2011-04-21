Shokaku.commsController = SC.ArrayController.create(
    SC.CollectionViewDelegate
    contentBinding: 'Shokaku.postController.comms'

    collectionViewDeleteContent: (view, content, indexes) ->
        # destroy the records
        records = indexes.map (idx) =>
            this.objectAt(idx)

        records.invoke 'destroy'

        selIndex = indexes.get 'min' - 1
        if selIndex < 0 then selIndex = 0
        this.selectObject(this.objectAt(selIndex))

)
