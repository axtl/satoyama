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
            
            # another split pane to show all/individual comments
            bottomRightView: SC.SplitView.design
                layout: {top: 48, right: 0, bottom: 36, left: 320}
                defaultThickness: 0.5
                dividerThickness: 2.5
                layoutDirection: SC.LAYOUT_VERTICAL
                autoresizeBehavior: SC.RESIZE_TOP
                topLeftMinThickness: 240
                bottomRightMinThickness: 360

                topLeftView: SC.ScrollView.design
                    hasHorizontalScroller: NO
                    layout: {top: 48, right: 0, height: 408, left: 320}

                    contentView: SC.LabelView.design
                        layout: {top: 24, right: 24, left: 24}
                        valueBinding: 'Shokaku.postController.post_body'

                dividerView: SC.SplitDividerView.design({})

                bottomRightView: SC.ListView.design
                    hasHorizontalScroller: NO
                    layout: {top: 408, right: 0, height: 360, left: 320}

                    contentView: SC.LabelView.design
                        layout: {top: 144, right: 24, left: 24}
                        contentBinding: 'Shokaku.commsController.arrangedObjects'
                        selectionBinding: 'Shokaku.commsController.selection'
                        contentValueKey: 'comm_body'
                        rowHeight: 24
                        canEditContent: YES
                        canDeleteContent: YES


            # # Right side shows a form to create a new post
            # bottomRightView: SC.View.design
            #     layout: {top: 48, right: 0, bottom: 36, left: 320}
            #     childViews: 'header tLabel bLabel tText bText addB'.w()
            #
            #     header: SC.LabelView.design
            #         layout: {top: 24, left: 24, right: 24}
            #         value: 'Add a new post'
            #
            #     tLabel: SC.LabelView.design
            #         layout: {top: 72, left: 24, width: 48, right: 24}
            #         value: 'Title'
            #
            #     bLabel: SC.LabelView.design
            #         layout: {top: 96, left: 24, width: 48, right: 24}
            #         value: 'Body'
            #
            #     tText: SC.TextFieldView.design
            #         layout: {top: 72, left: 72, width: 360, height: 20}
            #         hint: 'Post Title'.loc()
            #         isTextArea: NO
            #         # valueBinding: 'Shokaku.postsController.post_title'
            #
            #     bText: SC.TextFieldView.design
            #         layout: {top: 96, left: 72, width: 360, height: 110}
            #         hint: 'Post Body'.loc()
            #         isTextArea: YES
            #         # valueBinding: 'Shokaku.postsController.post_body'
            #
            #     addB: SC.ButtonView.design
            #         layout: {bottom: 24, right: 48, width: 96, height: 24}
            #         title: 'Add Post'.loc()
            #         isDefault: YES
            #         target: 'Shokaku.postsController'
            #         action: 'addPost'

        bottomView: SC.ToolbarView.design
          layout: {bottom: 0, left: 0, right: 0, height: 32 }
          anchorLocation: SC.ANCHOR_BOTTOM
