Shokaku.Comment = SC.Record.extend
    primaryKey: 'comm_id'
    comm_id: SC.Record.attr(Number)
    comm_body: SC.Record.attr(String)
    comm_date: SC.Record.attr(Date)

    post_id: SC.Record.toOne 'Shokaku.Post',
        inverse: 'comments'
        isMaster: NO
