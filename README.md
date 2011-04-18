# Satoyama #

## Motivation ##

To compare end-to-end JavaScript applications, and 'traditional' client-server layouts.

## Architecture ##

The *sato-* (plains) are the client components / front-ends:

* Shōkaku: SproutCore ('flying crane', inspired by the 'flying template' paper)
* Hiryū: HTML ('flying dragon')

The *-yama* (mountains) are the server components / back-ends:

* Naka : node.js
* Warusawa : web.py

## API ##

The simple [REST API](/totolici/satoyama/blob/master/API.md)

## Requirements ##

* Python
    * [web.py](http://webpy.org/)
    * [mimerender](http://code.google.com/p/mimerender/)
    * [pystache](https://github.com/defunkt/pystache)
    * [redis-py](https://github.com/andymccurdy/redis-py)
    * [gevent](http://www.gevent.org/) (requires [libevent](http://monkey.org/~provos/libevent/))
* [Node.js](http://nodejs.org/)
    * [clutch](https://github.com/clement/clutch)
    * [redis-node](https://github.com/bnoguchi/redis-node)
* [SproutCore](http://www.sproutcore.com/)
* [Redis](http://redis.io)

#### (c) alexandru totolici ####
##### UBC CPSC 507 Term Project Jan-Apr 2011 #####
