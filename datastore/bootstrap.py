#!/usr/bin/env python

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

    def post(post_id, frag):
        return 'posts:%s:%s' % (npid, frag)

    for pid in xrange(max_pid):
        npid = r.incr('next.post.id')
        r.lpush('post.list', npid)
        r[post(npid, 'post_id')] = npid
        r[post(npid, 'title')] = 'TITLE: %s' % npid
        r[post(npid, 'body')] = 'This is post %s' % npid
        r.rpush(post(npid, 'comms'), 'A comment for post %s' % npid)
        r.rpush(post(npid, 'comms'), 'TROLLFACE >:@')

if __name__ == '__main__':
    main(sys.argv)
