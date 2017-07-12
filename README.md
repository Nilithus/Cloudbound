Cloudbound
-----------
Cloudbound is a tool to create Machine Images of a [Starbound](http://playstarbound.com/) dedicated server using [Hashicorps Packer](https://www.packer.io/) -- at present it is only configured to create AWS AMI's but could easily be expanded to support other cloud platforms see [Packer Builders](https://www.packer.io/docs/builders/index.html) for a list of supported platforms.

## Assumed Setup
- You have the awscli installed and configured
- Your aws IAM user has the [minimal](https://www.packer.io/docs/builders/amazon.html#using-an-iam-task-or-instance-role) set of permissions required to run
- You have [Hashicorps Packer](https://www.packer.io/) installed and in your path.
- Your aws account as security group allowing tcp traffic on starbound server port (defaults to 21025)

## Disclaimers
There is a couple of gotchas in using [steamcmd](https://developer.valvesoftware.com/wiki/SteamCMD) and your steam account to install the starbound server
1. By running this you'll be accepting the [steamcmd eula](http://metadata.ftp-master.debian.org/changelogs/non-free/s/steamcmd/steamcmd_0~20130205-1_copyright)
2. Running this to create an AWS AMI will spin up a t2.micro instance -- this falls inside the [free tier](https://aws.amazon.com/free/) but if you are not eligble for free tier you might be charged a few cents. (I'm not responsible for your money problems).
3. Packer is setup to create an EC2 EBS backed AMI which means that if it runs successfully you'll have registered an ami to your account and created a volume snapshot of the root filesystem. **Packer does not manage AMI's** and each time you run and packer completes successfully a new EBS snapshot is created. Amazon charges for the storage of snapshots so just make sure you clean those up if don't want them hanging around. If you want to remove the ami you need to delete the snapshot and desregister the ami. Follow amazons guide to [deregistering AMI's](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/deregister-ami.html)
4. You must disable steamguard for this to work.I **Highly recommend** that you do not use your regular steam account for server setup. 

## Other notes
This only deals with creating an ami that has the starbound server installed. It does not handle server configuration (though it provides some server config dist files to help you get started) or persisting save game state between server restarts on a seperate ebs volume. To get those things is where you start getting into using something like [terraform](https://www.terraform.io/) and have it spin up a server using the ami that this repo has created and then attaching persistent storage and configuring the server ect... You'd also have it setup security groups and key-pairs and all that jazz. So this not push button get starbound server. This is push button get starbound server ami. 

## How to run
```bash
packer build \
-var 'steam_name=<steam_username>' \
-var 'steam_password=<steam_password>' \
-var 'amazon_region=us-east-1' \
starbound-server-template.json
```

## Why?
I started playing starbound and thought it'd be fun to run a dedicated server and have been looking for an excuse to learn and use packer.
This seemed like a resonable side project to expirment and learn packer.

## Todo
- [x] install steamcmd without prompting
- [x] login with steam account (steamguard?!)
- [x] Install starbound dedicated server under steam user
- [x] create systemd unit file to manage starbound server
- [ ] script cleanup (idempotent script or maybe just go full ansible)
- [ ] use [LinuxGSM](https://github.com/GameServerManagers/LinuxGSM) instead of steamcmd directly
- [ ] create a hyper-v packer build
- [ ] packer put environment vars doesn't interact well with special characters ($) which could be in passwords
- [x] Allow specifying the aws region right now only does us-east-1
