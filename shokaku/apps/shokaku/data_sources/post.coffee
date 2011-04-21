sc_require('models/task')

Shokaku.PostDataSource = SC.DataSource.extend

    fetch = (store, query) ->
        if query === Todos.TASKS_QUERY
            SC.Request.getUrl('/posts')
                .header({'Accept': 'application/json'}).json()
                .notify(this, 'didFetchTasks', store, query)
                .send()
            return YES

        return NO

    didFetchTasks = (response, store, query) ->
        if SC.ok response
            store.loadRecords Shokaku.Post, response.get('body').content
            store.dataSourceDidFetchQuery query
        else
            store.dataSourceDidErrorQuery query, response

    # Shokaku.POSTS_QUERY = SC.Query.local Shokaku.Post, 
    #     orderBy: 'post_id DESC'
    # return NO

    retrieveRecord = (store, storeKey) ->
        return NO

    createRecord = (store, storeKey) ->
        return NO

    updateRecord = (store, storeKey) ->
        return NO

    destroyRecord = (store, storeKey) ->
        return NO
