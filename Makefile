#  __     __         _       _     _
#  \ \   / /_ _ _ __(_) __ _| |__ | | ___ ___
#   \ \ / / _` | '__| |/ _` | '_ \| |/ _ \ __|
#    \ V / (_| | |  | | (_| | |_) | |  __\__ \
#     \_/ \__,_|_|  |_|\__,_|_.__/|_|\___|___/
#

ETHER_ADDR = 0x421c82B3C230f94B8C8f08a849D34cb9ca4602D3

# Docker container resource limits
MEMORY = "4g"
SWAP_MEMORY = "6g"
CPUS = 2

#   _____                    _
#  |_   _|_ _ _ __ __ _  ___| |_ ___
#    | |/ _` | '__/ _` |/ _ \ __/ __|
#    | | (_| | | | (_| |  __/ |_\__ \
#    |_|\__,_|_|  \__, |\___|\__|___/
#                 |___/

build:
	-mkdir -p $$HOME/ropsten-miner/data
	docker pull ethereum/client-go

start: build
	docker run -it --name ropsten-miner \
	-p 127.0.0.1:8545:8545 -p 30303:30303 \
	--memory=$(MEMORY) --memory-swap=$(SWAP_MEMORY) --memory-swappiness=80 --oom-kill-disable \
	--cpus=$(CPUS) \
	-v $$HOME/ropsten-miner/data:/root/.ethereum ethereum/client-go \
	--syncmode snap --networkid 3 --ropsten --http --http.addr "0.0.0.0" --mine --miner.etherbase $(ETHER_ADDR) \
	--http.api admin,eth,debug,miner,net,txpool,personal,web3 \
	--metrics

shell:
	docker exec -it ropsten-miner geth --datadir=/root/.ethereum/testnet attach
