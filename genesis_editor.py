import json
import os
import sys



inputs = sys.argv # 1 source; 2 dest;
genesis_source = inputs[1]
genesis_destination = inputs[2]



genesis_tmp=None
starname_acc = None
starname_doamins = None

configurer:str = None
__new__supply__ = 0

# End read dest genesis
with open(genesis_destination, 'r') as file:
    genesis_tmp = json.loads(file.read())


with open(genesis_source, 'r') as file:
    source = json.loads(file.read())
    configurer = source['app_state']['configuration']['config']['configurer']

    # Starname module
    genesis_tmp['app_state']['starname']['accounts'] = source['app_state']['starname']['accounts']
    genesis_tmp['app_state']['starname']['domains'] = source['app_state']['starname']['domains']

    
    # Chain time and height
    genesis_tmp['genesis_time'] = source['genesis_time'] 
    genesis_tmp['initial_height'] = source['initial_height']

    source = None
            

with open(f"{genesis_destination}", 'w') as file:
    file.write(
        json.dumps(genesis_tmp)
        .replace(configurer, genesis_tmp['app_state']['configuration']['config']['configurer']))


# balances -> app_state.bank.balances[*].coins[*].{'amount','denom'}
# supply -> app_state.bank.supply[*].{'amount','denom'}

# genesis_time -> genesis_time
# initial_height -> initial_height