import json
import os
import sys

inputs = sys.argv # 1 source; 2 dest;
genesis_source = inputs[1]
genesis_destination = inputs[2]



genesis_tmp=None
starname_acc = None
starname_doamins = None



# End read dest genesis
with open(genesis_destination, 'r') as file:
    genesis_tmp = json.loads(file.read())


with open(genesis_source, 'r') as file:
    source = json.loads(file.read())

    genesis_tmp['app_state']['starname']['accounts'] = source['app_state']['starname']['accounts']
    genesis_tmp['app_state']['starname']['domains'] = source['app_state']['starname']['domains']

    acc_bank_supply = 0
    acc_bank_tmp = []
    source = None

with open(f"{genesis_destination}.edit.json", 'w') as file:
    file.write(json.dumps(genesis_tmp).replace('uiov', 'ustake'))