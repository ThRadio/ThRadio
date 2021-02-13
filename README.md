# ThRadio

**ThRadio** is strongly inspired by AzuraCast, I started the project because AzuraCast had many features that I didn't need.

For this project the main language is Typescript all running on nodejs.

## Support ThRadio Development

ThRadio will always be available free of charge, but if you find the software useful and would like to support the project's lead developer, visit either of the links below. Your support is greatly appreciated.

<a href="https://ko-fi.com/therhenals" target="_blank" title="Buy me a coffee!"><img height='50' style='border:0px;height:50px;' src='https://az743702.vo.msecnd.net/cdn/kofi1.png?v=b' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

## Install

ThRadio is powered by Docker and uses pre-built images that contain every component of the software

```bash
# Pick a base directory on your host computer that ThRadio can use. If you're on Linux, you can follow the steps below to use the recommended directory:

$ mkdir -p /var/thradio
$ cd /var/thradio

# Use these commands to download our Docker Utility Script, set it as executable and then run the Docker installation process:

$ curl -fsSL https://raw.githubusercontent.com/ThRadio/ThRadio/master/thradio.sh > thradio.sh
$ chmod a+x thradio.sh
$ ./thradio.sh install
```

**ThRadio is currently in alpha.** If you use it in production, it is at your own risk.

## Licence

ThRadio is licensed under the Apache license, version 2.0. This project is free and open-source software, and pull requests are always welcome.

<!-- ## Dev Setup

```bash
# install dependencies
$ yarn install

# serve with hot reload at localhost:3000
$ yarn dev

# build for production and launch server
$ yarn build
$ yarn start

# generate static project
$ yarn generate
``` -->
