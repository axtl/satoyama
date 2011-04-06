# API Commands #

*   Return a list of the available papers:

        GET /papers/


*   Replace the entire paper collection:

        PUT /papers/



*   Create a new paper and return it's URL:

        POST /papers/



*   Delete the entire collection of papers:

        DELETE /papers/



*   Return the requested paper:

        GET /paper-<id>



*   Replace/create the specified paper:

        PUT /paper-<id>



*   Create a review in the given paper:

        POST /paper-<id>



*   Delete the paper (and all children resources, i.e. reviews):

        DELETE /paper-<id>



*   Return a list of all reviews for the paper:

        GET /paper-<id>/reviews/



*   Replace the collection of reviews:

        PUT /paper-<id>/reviews/



*  Create a new review in the given paper:

        POST /paper-<id>/reviews/



*   Delete all reviews for the paper:

        DELETE /paper-<id>/reviews/



*   Returns the requested review:

        GET /paper-<id>/review-<id>



*   Replace / create the specified review:

        PUT /paper-<id>/review-<id>



*   Update the given review with new content:

        POST /paper-<id>/review-<id>



*   Deletes the specified review:

        DELETE /paper-<id>/review-<id>


