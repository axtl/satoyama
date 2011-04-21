Shokaku.main = ->

        # Step 1: Instantiate Your Views
        # The code here will make the mainPane for your application visible
        # on screen. Once there's any level of complexity, you will want to
        # create multiple pages and panes.
        Shokaku.getPath('mainPage.mainPane').append()

        # Step 2. Set the content property on your primary controller.
        # This will make your app come alive!
        # TODO: Set the content property on your primary controller
        # ex: Shokaku.contactsController.set('content', Shokaku.contacts);
        # Shokaku.rootController.populate();
        posts = Shokaku.store.find(Shokaku.Post)
        Shokaku.postsController.set 'content', posts

window.main = ->
    Shokaku.main()
