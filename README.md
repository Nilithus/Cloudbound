Cloudbound
-----------
Cloudbound is a tool to create Machine Images of a [Starbound](http://playstarbound.com/) dedicated server using [Hashicorps Packer](https://www.packer.io/) -- at present it is only configured to create AWS AMI's but could easily be expanded to support other cloud platforms see [Packer Builders](https://www.packer.io/docs/builders/index.html) for a list of supported platforms.

## Assumed Setup
- You have the awscli installed and configured
- Your aws IAM user has the [minimal](https://www.packer.io/docs/builders/amazon.html#using-an-iam-task-or-instance-role) set of permissions required to run
- You have [Hashicorps Packer](https://www.packer.io/) installed and in your path.

## Disclaimers
There is a couple of gotchas in using [steamcmd](https://developer.valvesoftware.com/wiki/SteamCMD) and your steam account to install the starbound server
1. By running this you'll be accepting the [steamcmd eula](http://metadata.ftp-master.debian.org/changelogs/non-free/s/steamcmd/steamcmd_0~20130205-1_copyright)
2. Running this to create an AWS AMI will spin up a t2.micro instance -- this falls inside the [free tier](https://aws.amazon.com/free/) but if you are not eligble for free tier you might be charged a few cents. (I'm not responsible for your money problems).
3. Packer is setup to create an EC2 ESB backed AMI which means that if it runs successfully you'll have registered an ami to your account and created a volume snapshot of the root filesystem. Packer does not manage AMI's and each time you run and packer completes successfully a new EBS snapshot is created. Amazon charges for the storage of snapshots so just make sure you clean those up if don't want them hanging around. If you want to remove the ami you need to delete the snapshot and desregister the ami. Follow amazons guide to [deregistering AMI's](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/deregister-ami.html)

## How to run
```bash
# remember this fires up a t2.micro ec2 instance you will be charged
# you've been warned repeatedly.
packer build starbound-server-template.json
```

## Why?
I started playing starbound and thought it'd be fun to run a dedicated server and have been looking for an excuse to learn and use packer.
This seemed like a resonable side project to expirment and learn packer.

## Todo
- [ ] install steamcmd without prompting
- [ ] login with steam account (steamguard?!)
- [ ] Install starbound dedicated server
- [ ] create systemd unit file to manage starbound server
- [ ] profit