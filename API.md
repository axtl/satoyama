# API Commands #

*   
    
        GET /papers/
    
    Return a list of the available papers.

*   

        PUT /papers/

    Replace the entire paper collection.

*   

        POST /papers/

    Create a new paper and return it's URL.

*   

        DELETE /papers/

    Delete the entire collection of papers.

*   

        GET /paper-<id>

    Return the requested paper.

*   

        PUT /paper-<id>

    Replace/create the specified paper.

*   

        POST /paper-<id>

    Create a review in the given paper.


*   

        DELETE /paper-<id>

    Delete the paper (and all children resources, i.e. reviews).

*   

        GET /paper-<id>/reviews/

    Return a list of all reviews for the paper.

*   

        PUT /paper-<id>/reviews/

    Replace the collection of reviews.

*   

        POST /paper-<id>/reviews/

    Create a new review in the given paper.

*   

        DELETE /paper-<id>/reviews/

    Delete all reviews for the paper.

*   

        GET /paper-<id>/review-<id>

    Returns the requested review.

*   

        PUT /paper-<id>/review-<id>

    Replace / create the specified review.

*   

        POST /paper-<id>/review-<id>

    Update the given review with new content.

*   

        DELETE /paper-<id>/review-<id>

    Deletes the specified review.
