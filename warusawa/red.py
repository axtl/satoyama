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
    r[post_key(npid, 'post_title', raw=True)] = title
    # post body
    r[post_key(npid, 'post_body', raw=True)] = body
    # post date
    r[post_key(npid, 'post_date', raw=True)] = _formed_date()


def post_update(pid, title, body):
    # post title
    r[post_key(pid, 'post_title', raw=True)] = title
    # post body
    r[post_key(pid, 'post_body', raw=True)] = body
    # post date
    r[post_key(pid, 'post_date', raw=True)] = _formed_date()


def post_del(pid):
    # Remove list entry first, post should no longer be retrievable
    r.lrem('post.list', pid)
    r.delete(post_key(pid, 'post_title', raw=True))
    r.delete(post_key(pid, 'post_body', raw=True))
    r.delete(post_key(pid, 'post_date', raw=True))
    r.delete(post_key(pid, 'next.comm.id', raw=True))
    comms_del(pid)


def comms_del(pid):
    comm_idxs = get_list(post_key(pid, 'comm.list', raw=True))
    for cid in comm_idxs:
        comm_del(pid, cid)
    r.delete(post_key(pid, 'comm.list', raw=True))


def comm_add(pid, comm_body):
    # increment per-post comment counter
    ncid = r.incr(post_key(pid, 'next.comm.id', raw=True))
    # store in the per-post list of active comments
    r.lpush(post_key(pid, 'comm.list', raw=True), ncid)
    # and store the post
    r[comm(pid, ncid, raw=True)] = comm_body
    r[comm_key(pid, ncid, 'comm_date', raw=True)] = _formed_date()


def comm_update(pid, cid, comm_body):
    # and store the post
    r[comm(pid, cid, raw=True)] = comm_body
    r[comm_key(pid, cid, 'comm_date', raw=True)] = _formed_date()


def comm_del(pid, cid):
    # Remove list entry first, post should no longer be retrievable
    r.lrem(post_key(pid, 'comm.list', raw=True), cid)
    r.delete(comm(pid, cid, raw=True))
    r.delete(comm_key(pid, cid, 'comm_date', raw=True))


def get_list(lkey):
    return r.lrange(lkey, 0, -1)


def len(lkey):
    return r.llen(lkey)


def has(key):
    return r.exists(key)


def _formed_date():
    return datetime.utcnow().strftime("%a, %d %b %Y %H:%M:%S GMT")