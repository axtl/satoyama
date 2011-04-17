import pystache

# location of Mustache templates
TMPL = 'templates'


# TESTING #
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


class Posts(pystache.View):
    template_path = TMPL

    def title(self):
        return "Posts"

    def num_posts(self):
        return self.context['num_posts']

    def posts(self):
        return self.context['posts']


class Post(pystache.View):
    template_path = TMPL

    def post_title(self):
        return self.context['title']

    def post_id(self):
        return self.context['post_id']

    def post_body(self):
        return self.context['body']

    def num_comms(self):
        return self.context['numc'] if 'numc' in self.context else False

    def is_plural(self):
        return 'numc' in self.context and int(self.context['numc']) > 1


class Comments(pystache.View):
    template_path = TMPL

    def for_post(self):
        return self.context['post_id']

    def comments(self):
        return self.context['comments']

    def numc(self):
        return len(self.context['comments'])

    def is_plural(self):
        return len(self.context['comments']) > 1


class Comment(pystache.View):
    template_path = TMPL

    def for_post(self):
        return self.context['for_post_id']

    def comm_id(self):
        return self.context['comm_id']

    def body(self):
        return c2
