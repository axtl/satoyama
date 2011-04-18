import pystache

# location of Mustache templates
TMPL = 'templates'


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
        return self.context['post_title']

    def post_id(self):
        return self.context['post_id']

    def post_body(self):
        return self.context['post_body']

    def num_comms(self):
        return self.context['numc'] if 'numc' in self.context else False

    def is_plural(self):
        return 'numc' in self.context and int(self.context['numc']) != 1


class Comments(pystache.View):
    template_path = TMPL

    def for_post(self):
        return self.context['post_id']

    def comments(self):
        return self.context['comments']

    def numc(self):
        return len(self.context['comments'])

    def is_plural(self):
        return len(self.context['comments']) != 1


class Comment(pystache.View):
    template_path = TMPL

    def for_post(self):
        return self.context['post_id']

    def comm_id(self):
        return self.context['comm_id']

    def comm_body(self):
        return self.context['comm_body']
