copy:
	cp -r ../starnamed/build/* ./builds

reboot:
	rm -fr tmp/base_chain
	cp -r tmp/base_chain_pre_upgrade tmp/base_chain