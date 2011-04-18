from datetime import datetime
import redis

# redis setup
r = redis.Redis(host='localhost', port=6379, db=0)


def post_key(pid, part, raw=False):
    # used to quickly compute the proper Redis key based on id and keypart
    k = 'posts:%s:%s' % (pid, part)
    return k if raw else r.get(k)


def comm(pid, cid, raw=False):
    # compute the Redis key for the comment
    k = 'posts:%s:comm:%s' % (pid, cid)
    return k if raw else r.get(k)


def comm_key(pid, cid, part, raw=False):
    # compute the Redis key for the comment part
    k = 'posts:%s:comm:%s:%s' % (pid, cid, part)
    return k if raw else r.get(k)


def posts_del():
    post_idxs = get_list('post.list')
    for pid in post_idxs:
        post_del(pid)
    r.delete('post.list')


def post_add(title, body):
    # increment the global post id counter
    npid = r.incr('next.post.id')
    # store in the posts list
    r.lpush('post.list', npid)
    # post title
    r[post_key(npid, 'title', raw=True)] = title
    # post body
    r[post_key(npid, 'body', raw=True)] = body
    # post date
    r[post_key(npid, 'date', raw=True)] = datetime.utcnow()


def post_del(pid):
    r.delete(post_key(pid, 'title', raw=True))
    r.delete(post_key(pid, 'body', raw=True))
    r.delete(post_key(pid, 'date', raw=True))
    r.delete(post_key(pid, 'next.comm.id', raw=True))
    r.lrem('post.list', pid)
    comms_del(pid)


def comms_del(pid):
    comm_idxs = get_list(post_key(pid, 'comm.list', raw=True))
    for cid in comm_idxs:
        comm_del(pid, cid)
    r.delete(post_key(pid, 'comm.list', raw=True))


def comm_add(pid, body):
    # increment per-post comment counter
    ncid = r.incr(post_key(pid, 'next.comm.id', raw=True))
    # store in the per-post list of active comments
    r.lpush(post_key(pid, 'comm.list', raw=True), ncid)
    # and store the post
    r[comm(pid, ncid, raw=True)] = body
    r[comm_key(pid, ncid, 'date', raw=True)] = datetime.utcnow()


def comm_del(pid, cid):
    r.delete(comm(pid, cid, raw=True))
    r.delete(comm_key(pid, cid, 'date', raw=True))
    r.lrem(post_key(pid, 'comm.list', raw=True), cid)


def get_list(lkey):
    return r.lrange(lkey, 0, -1)


def len(lkey):
    return r.llen(lkey)


def has(key):
    return r.exists(key)
