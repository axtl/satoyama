Shokaku.mainPage = SC.Page.design
    mainPane: SC.MainPane.design
        childViews: 'topView middleView bottomView'.w()
        topView: SC.ToolbarView.design
            layout: {top: 0, left: 0, right: 0, height: 48}
            anchorLocation: SC.ANCHOR_TOP
        middleView: SC.SplitView.design
            layout: { top: 48, bottom: 36, left: 0, right: 0}
            defaultThickness: 0.5
            dividerThickness: 5
            layoutDirection: SC.LAYOUT_HORIZONTAL
            autoresizeBehavior: SC.RESIZE_TOP_LEFT
            topLeftMinThickness: 480
            topLeftMaxThickness: 720
            contentView: SC.ListView.design({})

            topLeftView: SC.ScrollView.design
                hasHorizontalScroller: NO
                layout: {top: 48, bottom: 36}
                backgroundColor: 'white'

                contentView: SC.SourceListView.design
                    contentBinding: 'Shokaku.postsController.arrangedObjects'
                    selectionBinding: 'Shokaku.postsController.selection'
                    contentValueKey: 'post_title'
                    rowHeight: 24
                    canEditContent: NO
                    canDeleteContent: NO

            dividerView: SC.SplitDividerView.design({})

            bottomRightView: SC.View.design
                layout: {top: 48, right: 0, bottom: 36, left: 480}

        bottomView: SC.ToolbarView.design
          layout: {bottom: 0, left: 0, right: 0, height: 32 }
          anchorLocation: SC.ANCHOR_BOTTOM
