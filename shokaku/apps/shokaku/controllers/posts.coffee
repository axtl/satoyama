Shokaku.postsController = SC.ArrayController.create(
    SC.CollectionViewDelegate

    collectionViewDeleteContent: (view, content, indexes) ->
        # destroy the records
        records = indexes.map (idx) =>
            this.objectAt(idx)

        records.invoke('destroy')

        selIndex = indexes.get 'min' - 1
        if selIndex < 0 then selIndex = 0 
        this.selectObject(this.objectAt(selIndex))

    addPost: () ->
        # create a new task in the store
        new_post = this.get 'content'
        post = Shokaku.store.createRecord Shokaku.Post,
            'post_title': new_post.post_title
            'post_body': new_post.post_body
            'post_date': new Date().toUTCString()


        # # select new task in UI
        # this.selectObject(task);
        YES
)
