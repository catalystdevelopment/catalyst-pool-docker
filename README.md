# <img src=/docs/icon.png alt="Logo" width="48" align="left" />catalyst-pool-docker
Docker configuration to setup `Catalyst` coin pool.

The `cryptonote-nodejs-pool` dockerized!

This config is quite universal, with a little adjustment, you can use it to run any `cryptonote` coin pool in docker environment!

![example 01](/docs/screenshot01.png)

**Install**

```
git clone https://github.com/n8tb1t-crypto/catalyst-pool-docker.git
cd catalyst-pool-docker
chmod -R 775 ./bin
```

> If you are going to use `AWS Free Tier` `t2.micro`, select `Ubuntu 18.04` instance, and the setup the [swap file](https://aws.amazon.com/premiumsupport/knowledge-center/ec2-memory-swap-file/) in order to compile the pool! `sudo dd if=/dev/zero of=/swapfile bs=512M count=4` etc. 

**Create persistent volumes**
> We need this to store blockchain and wallet data..

```bash
docker volume create catalyst-blockchain
docker volume create catalyst-wallet
docker volume create catalyst-db
```

If you have the blockchain already downloaded, just put its contents inside `blockchain` folder in the `src` and run these commands:

> Or you can download the latest blockchain snapshot:
> - `apt-get install megatools unrar`
> - `megadl 'https://mega.nz/#F!fv5QhQjK!BsEqgs7SQoBCqzzfcXVXPw'`
> - `unrar x blockchain.part1.rar`
>
> On Amazon EC2 instance it will take you around 3-5 minutes to download the whole blockchain snapshot!


```bash
docker run -d --rm --name dummy -v catalyst-blockchain:/root alpine tail -f /dev/null
docker cp blockchain/. dummy:/root/
docker stop dummy
```

> This will copy the blockchain inside the persistent docker container, and you won't need to wait until it synchronizes from scratch! Note, though, if your docker host is remote, it can take significant time, depending on your ISP connection speed. The current `Catalyst` blockchain size is around 5GB

You can also copy the blockchain directly into `/var/lib/docker/volumes/catalyst-blockchain/_data`

Now, let's set-up a wallet. Run this command:
- `docker-compose run --rm catalyst_wallet`

If the wallet doesn't exist it will help you to create one. Just press `2` inside the menu. Name your wallet `wallet` without any extension, and assign a password. By default, the password should be `12345678` if you chose another one, don't forget to change it in `.env` config file at `src` root folder.

> Next time you run this command it will log in inside the wallet. so you will be able to see the balance.
Also after you created the wallet copy its address and seed data. You will need it later, and if something goes wrong you'll be able to restore it.

**Specify your wallet address in `/config/config.json`** - so the pool will know where to send the coins:)

**change the website URL in `/config/site-config.js`** - replace the `var api = "http://fs.local:8407"` with your docker host domain or IP, in most cases, it should be `127.0.0.1` or 'localhost' or your local `IP` - the port should stay the same. Do not change it!

**That's it now you can start the pool:**

> Note, when you start the pool for the first time, it can take a while to bootstrap the services. The good thing though, next time it will be blazing fast!

- `docker-compose up -d catalyst_pool_site` - you can access the pool at `http://docker_host_ip/admin.html` the default password is `12345678`.

![example 02](/docs/screenshot02.png)

- To stop all the services, use: `docker-compose down -v`
- To follow the logs, use: `docker-compose logs -f --tail 30`

**If something went wrong, just try to lunch services one by one in console mode!**

> Don't forget to recompile the `catalyst_pool` and `catalyst_pool_site` services, every time you change the config files.
- `docker-compose build --force-rm --parallel catalyst_pool`
- `docker-compose build --force-rm --parallel catalyst_pool_site`

**You can troubleshoot each service, by starting them one by one.**

**available servises:**
- redis
- catalyst_deamon
- catalyst_rpc_service
- catalyst_pool
- catalyst_pool_site
- catalyst_wallet

- `docker-compose up -d [service_name]` - starts specified service as a daemon, in the background.
- `docker-compose run --rm --service-ports [service_name]` - starts service in real-time with output to console **[CONSOLE MOD]**.
- `docker-compose run --rm --service-ports [service_name] bash` - log in into service container.
- `docker-compose logs [service_name]` - watch service logs.
- `docker-compose build --force-rm --parallel [service_name]` - **[REBUILD SERVICE]**.

## BACKUP

**Wallet backup**
```
docker-compose run --rm -d --name backup backup
docker exec backup tar -czvf wallet.tar.gz ./wallet/
docker cp backup:/catalyst/wallet.tar.gz wallet.tar.gz
docker rm -v -f backup
```

**Blockchain backup**
```
docker-compose run --rm -d --name backup backup
docker exec backup tar -czvf blockchain.tar.gz ./blockchain/
docker cp backup:/catalyst/blockchain.tar.gz blockchain.tar.gz
docker rm -vf backup
```

**Pool DB backup**
```
docker-compose run --rm -d --name backup backup
docker exec backup tar -czvf db.tar.gz ./db/
docker cp backup:/catalyst/db.tar.gz db.tar.gz
docker rm -vf backup
```

**Logs**
- Clear pool logs `docker exec catalyst_pool sh -c "rm ./logs/*.log"`

