# API Commands #

*   Return a list of the available posts:

        GET /posts/


*   Replace the entire post collection:

        PUT /posts/



*   Create a new post and return it's URL:

        POST /posts/



*   Delete the entire collection of posts:

        DELETE /posts/



*   Return the requested post:

        GET /post-<id>



*   Replace/create the specified post:

        PUT /post-<id>



*   Update the given post:

        POST /post-<id>



*   Delete the post (and all children resources, i.e. comments):

        DELETE /post-<id>



*   Return a list of all comments for the post:

        GET /post-<id>/comments/



*   Replace the collection of comments:

        PUT /post-<id>/comments/



*  Create a new comment in the given post:

        POST /post-<id>/comments/



*   Delete all comments for the post:

        DELETE /post-<id>/comments/



*   Returns the requested comment:

        GET /post-<id>/comment-<id>



*   Replace/create the specified comment:

        PUT /post-<id>/comment-<id>



*   Update the given comment with new content:

        POST /post-<id>/comment-<id>



*   Deletes the specified comment:

        DELETE /post-<id>/comment-<id>


