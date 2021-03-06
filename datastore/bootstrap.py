#!/usr/bin/env python
from datetime import datetime
import redis
import sys

WITH_LOREM = True

LBODY = "Nulla facilisi. Duis aliquet egestas purus in blandit. Curabitur \
    vulputate, ligula lacinia scelerisque tempor, lacus lacus ornare ante, \
    ac egestas est urna sit amet arcu. Class aptent taciti sociosqu ad \
    litora torquent per conubia nostra, per inceptos himenaeos. Sed molestie \
    augue sit amet leo consequat posuere. Vestibulum ante ipsum primis in \
    faucibus orci luctus et ultrices posuere cubilia Curae; Proin vel ante a \
    orci tempus eleifend ut et magna. Lorem ipsum dolor sit amet, \
    consectetur  adipiscing elit. Vivamus luctus urna sed urna ultricies ac \
    tempor dui sagittis. In condimentum facilisis porta. Sed nec diam eu \
    diam mattis viverra. Nulla fringilla, orci ac euismod semper, magna \
    diam porttitor mauris, quis sollicitudin sapien justo in libero.\
    Vestibulum mollis mauris enim. Morbi euismod magna ac lorem rutrum \
    elementum. Donec viverra auctor lobortis. Pellentesque eu est a nulla \
    placerat dignissim. Morbi a enim in magna semper bibendum. Etiam \
    scelerisque, nunc ac egestas consequat, odio nibh euismod nulla, eget \
    auctor orci nibh vel nisi. Aliquam erat volutpat. Mauris vel neque sit \
    amet nunc gravida congue sed sit amet purus. Quisque lacus quam, egestas \
    ac tincidunt a, lacinia vel velit. Aenean facilisis nulla vitae urna \
    tincidunt congue sed ut dui. Morbi malesuada nulla nec purus convallis \
    consequat. Vivamus id mollis quam. Morbi ac commodo nulla. In \
    condimentum orci id nisl volutpat bibendum. Quisque commodo hendrerit \
    lorem quis egestas. Maecenas quis tortor arcu. Vivamus rutrum nunc non \
    neque consectetur quis placerat neque lobortis. Nam vestibulum, arcu \
    sodales feugiat consectetur, nisl orci bibendum elit, eu euismod magna \
    sapien ut nibh. Donec semper quam scelerisque tortor dictum gravida. In \
    hac habitasse platea dictumst. Nam pulvinar, odio sed rhoncus suscipit, \
    sem diam ultrices mauris, eu consequat purus metus eu velit. Proin metus \
    odio, aliquam eget molestie nec, gravida ut sapien. Phasellus quis est \
    sed turpis sollicitudin venenatis sed eu odio. Praesent eget neque eu \
    eros interdum malesuada non vel leo. Sed fringilla porta ligula egestas \
    tincidunt. Nullam risus magna, ornare vitae varius eget, scelerisque \
    a libero. Morbi eu porttitor ipsum. Nullam lorem nisi, posuere quis \
    volutpat eget, luctus nec massa. Pellentesque aliquam lacinia tellus sit \
    amet bibendum. Ut posuere justo in enim pretium scelerisque. Etiam \
    ornare vehicula euismod. Vestibulum at risus augue. Sed non semper \
    dolor. Sed fringilla consequat velit a porta. Pellentesque sed lectus \
    pharetra ipsum ultricies commodo non sit amet velit. Suspendisse \
    volutpat lobortis ipsum, in scelerisque nisi iaculis a. Duis pulvinar \
    lacinia commodo. Integer in lorem id nibh luctus aliquam. Sed elementum, \
    est ac sagittis porttitor, neque metus ultricies ante, in accumsan massa \
    nisl non metus. Vivamus sagittis quam a lacus dictum tempor. Nullam in \
    semper ipsum. Cras a est id massa malesuada tincidunt. Etiam a urna \
    tellus. Ut rutrum vehicula dui, eu cursus magna tincidunt pretium. Donec \
    malesuada accumsan quam, et commodo orci viverra et. Integer tincidunt \
    sagittis lectus. Mauris ac ligula quis orci auctor tincidunt. \
    Suspendisse odio justo, varius id posuere sit amet, iaculis sit amet \
    orci. Suspendisse potenti. Suspendisse potenti. Aliquam erat volutpat. \
    Sed posuere dignissim odio, nec cursus."

LCOMM = "Mauris iaculis porttitor posuere. Praesent id metus massa, ut \
    blandit odio. Proin quis tortor orci. Etiam at risus et justo dignissim \
    congue. Donec congue lacinia dui, a porttitor lectus condimentum \
    laoreet. Nunc eu ullamcorper orci. Quisque eget odio ac lectus \
    vestibulum faucibus eget in metus. In pellentesque faucibus \
    vestibulum. Nulla at nulla justo, eget luctus tortor. Nulla facilisi. \
    Duis aliquet egestas purus in blandit. Curabitur vulputate, ligula \
    lacinia scelerisque tempor, lacus lacus ornare ante, ac egestas est \
    urna sit amet arcu. Class aptent taciti sociosqu ad litora torquent \
    per conubia nostra, per inceptos himenaeos. Sed molestie augue sit \
    amet leo consequat posuere. Vestibulum ante ipsum primis in faucibus \
    orci luctus et ultrices posuere cubilia Curae; Proin vel ante a orci \
    tempus eleifend ut et magna. Lorem ipsum dolor sit amet, consectetur \
    adipiscing elit. Vivamus luctus urna sed urna ultricies ac tempor dui \
    sagittis. In condimentum facilisis porta. Sed nec diam eu diam mattis \
    viverra. Nulla fringilla, orci ac euismod semper, magna diam porttitor \
    mauris, quis sollicitudin sapien justo in libero. Vestibulum mollis \
    mauris enim. Morbi euismod magna ac lorem rutrum elementum. Donec \
    viverra auctor lobortis. Pellentesque eu est a nulla placerat \
    dignissim. Morbi a enim in magna semper bibendum. Etiam scelerisque, \
    nunc."


BODY = "The answer is 42" if not WITH_LOREM else LBODY
COMM = "I don't agree!" if not WITH_LOREM else LCOMM


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
        r[post(npid, 'post_body')] = '%s' % BODY
        # post date
        r[post(npid, 'post_date')] = datetime.utcnow()
        # store 5 comments
        for i in xrange(5):
            # increment per-post comment counter
            ncid = r.incr(post(npid, 'next.comm.id'))
            # store in the per-post list of active comments
            r.lpush(post(npid, 'comm.list'), ncid)
            # and store the post
            r[comm(npid, ncid)] = '%s' % COMM
            r[comm(npid, ncid) + ':comm_date'] = datetime.utcnow()

if __name__ == '__main__':
    main(sys.argv)
