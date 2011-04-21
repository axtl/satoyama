Shokaku.mainPage = SC.Page.design
    mainPane: SC.MainPane.design
        childViews: 'topView middleView bottomView'.w()
        # Generic toolbar
        topView: SC.ToolbarView.design
            layout: {top: 0, left: 0, right: 0, height: 48}
            anchorLocation: SC.ANCHOR_TOP
        # Main content pane
        middleView: SC.SplitView.design
            layout: { top: 48, bottom: 36, left: 0, right: 0}
            defaultThickness: 0.5
            dividerThickness: 5
            layoutDirection: SC.LAYOUT_HORIZONTAL
            autoresizeBehavior: SC.RESIZE_TOP_LEFT
            topLeftMinThickness: 240
            bottomRightMinThickness: 720
            # contentView: SC.ListView.design({})

            # Left side shows a list of posts
            topLeftView: SC.ScrollView.design
                hasHorizontalScroller: NO
                layout: {top: 48, bottom: 36}
                backgroundColor: 'white'

                contentView: SC.ListView.design
                    contentBinding: 'Shokaku.postsController.arrangedObjects'
                    selectionBinding: 'Shokaku.postsController.selection'
                    contentValueKey: 'post_title'
                    rowHeight: 24
                    canEditContent: YES
                    canDeleteContent: YES

            dividerView: SC.SplitDividerView.design({})
            
            # tab between post body and comments
            bottomRightView: SC.TabView.design
                layout: {top: 48, right: 0, bottom: 36, left: 320}
                nowShowing: 'Shokaku.mainPage.postView'
                itemTitleKey: 'title'
                itemValueKey: 'value'
                items: [
                    {title: 'Post', value: 'Shokaku.mainPage.postView'}
                    {title: 'Comments', value: 'Shokaku.mainPage.commsView'}
                ]

        bottomView: SC.ToolbarView.design
          layout: {bottom: 0, left: 0, right: 0, height: 32 }
          anchorLocation: SC.ANCHOR_BOTTOM

    postView: SC.ScrollView.design
        hasHorizontalScroller: NO
        layout: {top: 48, left: 24, right: 24}

        contentView: SC.LabelView.design
            # layout: {top: 24, right: 24, left: 24}
            valueBinding: 'Shokaku.postController.post_body'

    commsView: SC.ScrollView.design
        hasHorizontalScroller: NO
        layout: {top: 48, left: 24, right: 24}

        contentView: SC.ListView.design
            # layout: {top: 48, right: 24, left: 24}
            contentBinding: 'Shokaku.commsController.arrangedObjects'
            selectionBinding: 'Shokaku.commsController.selection'
            contentValueKey: 'comm_body'
            # rowHeight: 24
            canEditContent: NO
            canDeleteContent: NO
