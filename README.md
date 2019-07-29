# catalyst-pool-docker
Docker configuration to setup Catalyst coin pool.

**Create persistent volumes**
> We need this to store blockchain and wallet data..

`docker volume create catalyst-blockchain`
`docker volume create catalyst-wallet`

If you have the blockchain already downloaded, just put its contents inside `blockchain` folder in the `src` and run these commands: 

`docker run -d --rm --name dummy -v catalyst-blockchain:/root alpine tail -f /dev/null`
`docker cp blockchain/. dummy:/root/`
`docker stop dummy`

> This will copy the blockchain inside the persistent docker container, and you won't need to wait until it synchronizes from scratch! Note, though, if your docker host is remote, it can take significant time, depending on your ISP connection speed. The current `Catalyst` blockchain size is around 5GB
