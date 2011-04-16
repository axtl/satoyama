import redis

# how many posts to generate
GENERATE = 3

r = redis.Redis(host='localhost', port=6379, db=0)
r.flushall()

def post(post_id, frag):
    return 'posts:%s:%s' % (npid, frag)

for pid in xrange(GENERATE):
    npid = r.incr('next.post.id')
    r.lpush('post.list', npid)
    r[post(npid, 'post_id')] = npid
    r[post(npid, 'title')] = 'TITLE: %s' % npid
    r[post(npid, 'body')] = 'This is post %s' % npid
    r.rpush(post(npid, 'comms'), 'A comment for post %s' % npid)
