copy:
	cp -r ../starnamed/build/* ./builds

reboot:
	rm -fr tmp/base_chain
	cp -r tmp/base_chain_pre_upgrade tmp/base_chain

init:
	rm -fr tmp/base_chain/
	bash scripts/1_genesis.sh 
	python3 genesis_editor.py prd.v10.genesis.json tmp/base_chain/config/genesis.json

start:
	bash scripts/2_start.sh

run_clean: init start 

proposal:
	bash ./scripts/3_proposal.sh