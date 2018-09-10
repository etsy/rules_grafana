import json
import sys

if __name__ == '__main__':
    with open(sys.argv[1], 'r') as f:
        j = json.load(f)
    if not j.get('uid'):
        j['uid'] = sys.argv[2]
    print json.dumps(j)
