import hjson
import os

with open('install.hjson') as f:
    x = hjson.load(f)
for k, v in x.items():
    if k == 'install':
        script = ';'.join(v)
        ret = os.system(script)
        if ret:
            print('uh oh')
        else:
            print('installed')
