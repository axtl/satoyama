Shokaku.Post = SC.Record.extend
    primaryKey: 'post_id'
    post_id: SC.Record.attr(Number)
    post_title: SC.Record.attr(String)
    post_body: SC.Record.attr(String)
    post_date: SC.Record.attr(Date)
    
    comm_list: SC.Record.toMany 'Shokaku.Comment'
        inverse: 'post'
        isMaster: YES
