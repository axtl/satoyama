#!/usr/bin/env python
from datetime import datetime
import redis
import sys


def main(argv):
    # parse the arguments
    if len(argv) > 1:
        max_pid = int(argv[1])
    else:
        max_pid = 10
    r = redis.Redis(host='localhost', port=6379, db=0)
    r.flushall()
    # global post counter
    npid = 0

    def post(post_id, frag):
        return 'posts:%s:%s' % (post_id, frag)

    def comm(post_id, comm_id):
        return 'posts:%s:comm:%s' % (post_id, comm_id)

    while npid < max_pid:
        # increment the global post id counter
        npid = r.incr('next.post.id')
        # store in the posts list
        r.lpush('post.list', npid)
        # post title
        r[post(npid, 'post_title')] = 'TITLE: %s' % npid
        # post body
        r[post(npid, 'post_body')] = 'This is post %s' % npid
        # post date
        r[post(npid, 'post_date')] = datetime.utcnow()
        # increment per-post comment counter
        ncid = r.incr(post(npid, 'next.comm.id'))
        # store in the per-post list of active comments
        r.lpush(post(npid, 'comm.list'), ncid)
        # and store the post
        r[comm(npid, ncid)] = 'A comment for post %s' % npid
        r[comm(npid, ncid) + ':comm_date'] = datetime.utcnow()

if __name__ == '__main__':
    main(sys.argv)
