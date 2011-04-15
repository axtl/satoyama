import pystache

TMPL = 'templates'


class Index(pystache.View):
    template_path = TMPL

    def num_posts(self):
        # should fetch from Redis
        return 0

class Posts(pystache.View):
    template_path = TMPL

    def title(self):
        return "Posts"

    def num_posts(self):
        return 0


class Post(pystache.View):
    template_path = TMPL

    def post_title(self):
        return "{TITLE}"


class Comments(pystache.View):
    template_path = TMPL

    def commenter_name(self):
        return "{NAME}"


class Comment(pystache.View):
    template_path = TMPL

    def comment_time(self):
        return "{TIME}"
