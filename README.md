# <img src=/docs/icon.png alt="Logo" width="48" align="left" />catalyst-pool-docker
Docker configuration to setup `Catalyst` coin pool.

The `cryptonote-nodejs-pool` dockerized!

This config is quite universal, with a little adjustment, you can use it to run any `cryptonote` coin pool in docker environment!

![example 01](/docs/screenshot01.png)

**Create persistent volumes**
> We need this to store blockchain and wallet data..

```bash
docker volume create catalyst-blockchain
docker volume create catalyst-wallet
```

If you have the blockchain already downloaded, just put its contents inside `blockchain` folder in the `src` and run these commands:

```bash
docker run -d --rm --name dummy -v catalyst-blockchain:/root alpine tail -f /dev/null
docker cp blockchain/. dummy:/root/
docker stop dummy
```

> This will copy the blockchain inside the persistent docker container, and you won't need to wait until it synchronizes from scratch! Note, though, if your docker host is remote, it can take significant time, depending on your ISP connection speed. The current `Catalyst` blockchain size is around 5GB

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
