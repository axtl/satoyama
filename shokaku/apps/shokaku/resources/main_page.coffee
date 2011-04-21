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
            topLeftMinThickness: 320
            topLeftMaxThickness: 720
            contentView: SC.ListView.design({})

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

            # Right side shows a form to create a new post
            bottomRightView: SC.View.design
                layout: {top: 48, right: 0, bottom: 36, left: 320}
                childViews: 'header tLabel bLabel tText bText'.w()
                # childViews: 'header tLabel bLabel tText bText addB title'.w()

                header: SC.LabelView.design
                    layout: {top: 24, left: 24, right: 24}
                    value: 'Add a new post'

                tLabel: SC.LabelView.design
                    layout: {top: 72, left: 24, width: 48, right: 24}
                    value: 'Title'

                bLabel: SC.LabelView.design
                    layout: {top: 96, left: 24, width: 48, right: 24}
                    value: 'Body'

                tText: SC.TextFieldView.design
                    layout: {top: 72, left: 96, width: 300, height: 20}
                    hint: 'Post Title'.loc()
                    isTextArea: NO
                    valueBinding: 'Shokaku.postController.post_title'

                bText: SC.TextFieldView.design
                    layout: {top: 96, left: 96, width: 300, height: 110}
                    hint: 'Post Body'.loc()
                    isTextArea: YES
                    valueBinding: 'Shokaku.postController.post_body'

        bottomView: SC.ToolbarView.design
          layout: {bottom: 0, left: 0, right: 0, height: 32 }
          anchorLocation: SC.ANCHOR_BOTTOM
