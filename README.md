# catalyst-pool-docker
Docker configuration to setup `Catalyst` coin pool.

**Create persistent volumes**
> We need this to store blockchain and wallet data..

- `docker volume create catalyst-blockchain`
- `docker volume create catalyst-wallet`

If you have the blockchain already downloaded, just put its contents inside `blockchain` folder in the `src` and run these commands: 

- `docker run -d --rm --name dummy -v catalyst-blockchain:/root alpine tail -f /dev/null`
- `docker cp blockchain/. dummy:/root/`
- `docker stop dummy`

> This will copy the blockchain inside the persistent docker container, and you won't need to wait until it synchronizes from scratch! Note, though, if your docker host is remote, it can take significant time, depending on your ISP connection speed. The current `Catalyst` blockchain size is around 5GB


Now, let's set-up a wallet. Run this command:
- `docker-compose run --rm catalyst_wallet`

If the wallet doesn't exist it will help you to create one. Just press `2` inside the menu. name your wallet `wallet` without any extension, and assign a password. By default, the password should be `12345678` if you chose another one, don't forget to change it in `.env` config file at `src` root folder.

Next time you run this command it will log in inside the wallet. so you will be able to see the balance.
Also after you created the wallet copy its address and seed data. You will need it later, and if something goes wrong you'll be able to restore it.
