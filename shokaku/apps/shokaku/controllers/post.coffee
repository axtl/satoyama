Shokaku.postController = SC.ObjectController.create
    contentBinding: SC.Binding.single 'Shokaku.postsController.selection'

    comms: ( ->
        this.get 'comm_list'
    ).property()
