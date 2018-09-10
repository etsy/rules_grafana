import json
import sys

'''Asserts that the JSON dashboard in $1 is valid JSON and has a "uid" key with value $2.'''

if __name__ == '__main__':
    with open(sys.argv[1], 'r') as f:
        j = json.load(f)
    assert 'uid' in j, 'no uid'
    expected_uid = sys.argv[2]
    assert j['uid'] == expected_uid, 'mismatched uid actual=%s expected=%s' % (j['uid'], expected_uid)
