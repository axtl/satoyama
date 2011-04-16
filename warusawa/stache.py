import pystache

# location of Mustache templates
TMPL = 'templates'
# threshold for shortening text
THR = 50


# TESTING #
p1 = "Praesent eget neque eu eros interdum malesuada non vel leo. Sed \
     fringilla porta ligula egestas tincidunt. Nullam risus magna, ornare \
     vitae varius eget, scelerisque a libero. Morbi eu porttitor ipsum. \
     Nullam lorem nisi, posuere quis volutpat eget, luctus nec massa. \
     Pellentesque aliquam lacinia tellus sit amet bibendum. Ut posuere justo \
     in enim pretium scelerisque. Etiam ornare vehicula euismod. Vestibulum \
     at risus augue. Sed non semper dolor. Sed fringilla consequat velit a \
     porta."
p2 = "Nulla fringilla, orci ac euismod semper, magna diam porttitor mauris, \
     quis sollicitudin sapien justo in libero. Vestibulum mollis mauris enim. \
     Morbi euismod magna ac lorem rutrum elementum. Donec viverra auctor \
     lobortis. Pellentesque eu est a nulla placerat dignissim. Morbi a enim \
     in magna semper bibendum. Etiam scelerisque, nunc ac egestas consequat, \
     odio nibh euismod."
c1 = "this is a longer comment because we need to test some crap, and\
     lorem ipsum is such a bother, really, that I'm not even going to \
     try and pretend..."
c2 = "Quisque lacus quam, egestas ac tincidunt a, lacinia vel velit. \
     Aenean facilisis nulla vitae urna tincidunt congue sed ut dui. \
     Morbi malesuada nulla nec purus convallis consequat. Vivamus id \
     mollis quam. Morbi ac commodo nulla. In condimentum orci id nisl \
     volutpat bibendum. Quisque commodo hendrerit lorem quis egestas. \
     Maecenas quis tortor arcu. Vivamus rutrum nunc non neque \
     consectetur quis placerat neque lobortis. Nam vestibulum, arcu \
     sodales feugiat consectetur, nisl orci bibendum elit, eu euismod \
     magna sapien ut nibh. Donec semper quam scelerisque tortor \
     dictum gravida. In hac habitasse platea dictumst. Nam pulvinar, \
     odio sed rhoncus suscipit, sem diam ultrices mauris, eu \
     consequat purus metus eu velit. Proin metus."

# NO MORE TESTING #

def _trim_post(post_text):
    if len(post_text) > THR:
        short = post_text[:(THR - 5)] + ' ...'
        return short
    return post_text


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
        return 0 # fetch from Redis

    def posts(self):
        posts = []
        posts.append({'short_name': _trim_post(p1), 'url': '1'})
        posts.append({'short_name': _trim_post(p2), 'url': '2'})
        return posts


class Post(pystache.View):
    template_path = TMPL

    def post_title(self):
        return "{TITLE}"

    def post_id(self):
        return self.context['post_id']

    def post_body(self):
        return p2

    def has_comments(self):
        return True


class Comments(pystache.View):
    template_path = TMPL

    def for_post(self):
        return self.context['for_post_id']

    def comments(self):
        comments = []
        comments.append({'body': c1, 'url': '1', 'date': 'A'})
        comments.append({'body': c2, 'url': '2', 'date': 'B'})
        return comments


class Comment(pystache.View):
    template_path = TMPL

    def for_post(self):
        return self.context['for_post_id']

    def comm_id(self):
        return self.context['comm_id']

    def body(self):
        return c2
