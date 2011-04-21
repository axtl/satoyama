# ==========================================================================
# Project:   Shokaku
# Copyright: ©2011 alexandru
# ==========================================================================

#  Front-end for Naka, a simplistic web board.

this.Shokaku = SC.Application.create
    NAMESPACE: 'Shokaku'
    VERSION: '0.1.0'

    # This is your application store.  You will use this store to access all
    # of your model data.  You can also set a data source on this store to
    # connect to a backend server.  The default setup below connects the store
    # to any fixtures you define.
    store: SC.Store.create().from('Shokaku.PostDataSource')

    # TODO: Add global constants or singleton objects needed by your app here.
