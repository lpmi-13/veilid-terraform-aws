# Veilid nodes on AWS

Details at https://veilid.com/

Running veilid nodes is a super easy way to help grow the network, and if you don't feel like manually setting up everything, this is an easy way to run one or more in AWS via terraform.

Even though AWS doesn't have a "forever" free tier like Azure/GCP/Oracle, you might still want to take advantage of their 12-month free tier access, or even just run nodes in AWS because that's your preferred cloud environment.

## Cost

Since AWS doesn't have an always-on free tier (though they do offer 1 year of free tier, which would work with this configuration), you'll eventually have to pay a bit for this, but the majority of the cost will be the EC2 instance (the `t4g.nano`), which will run a little over $3/month.

Because AWS charges for IPv4 addresses, the default configuration here won't give the instance a public IPv4 address. Since veilid is configured to use either IPv4 or IPV6 (or both if available), this isn't a problem at all for the node.

However, if, like me, you don't have an IPv6 address from your internet provider, then you won't be able to connect via SSH to poke around via `veilid-cli`. If you'd like to get an IPv4 address, change the value for `needIpv4` in `local.tf` to `true`. You'll get the IPv4 address in the output after running `terraform apply`, and you can SSH to that address. Remember to change it back and re-run `terraform apply` when you're done, or you'll be paying an addition $3.5/month, which will double the cost for this node.

## Setup

You'll need terraform to run this, and you can get the installation instructions [here](https://developer.hashicorp.com/terraform/install).

If you don't have an Account on AWS yet, go ahead and [set one up](https://aws.amazon.com/).

You'll also need the AWS CLI to authenticate, and that can be installed following [this guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).

### Setup Walkthrough

Here are the steps to get all ready to run terraform:

1. Create an IAM user in the IAM console to use (You _can_ use the root user credentials for this, but it's very easy to [create an administrator user](https://docs.aws.amazon.com/streams/latest/dev/setting-up.html#setting-up-iam)), and then follow the steps [here](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) under **To create an access key**. You'll need the values for the access key and secret access key in the next step.

> Note: if you're comfortable with assuming an IAM role and know how to set that up, that would be even better, but this is a quick-start guide, so we won't be covering how to do that.

2. `cp .env.example .env` and fill in the values from the output of step 1 (the access key and secret access key)

3. Add the path to whatever public SSH key you want to use to SSH into the instances in `main.tf`.

4. `source .env` and you're ready to `terraform plan`!

> If you want to use a separate SSH key, then generate one in this folder like `ssh-keygen -t ed25519 -o -a 100 -f veilid-key`. Then, make sure to update the file path in `main.tf`.

### How to connect to the instance

After running `terraform apply`, you'll see the output of the public IP address like so:

```sh
Outputs:

public_ip_address_ipv4 = []
public_ip_address_ipv6 = [
  "2600:1f13:52f:d701:783d:b420:b6f1:ff74",
]
```

If you later decide you also want an IPv4 address, it'll look something like:

```sh
Outputs:

public_ip_address_ipv4 = [
  "34.221.247.223",
]
public_ip_address_ipv6 = [
  "2600:1f14:2a39:ac01:ee48:312f:fad:30ba",
]
```

so you can then SSH in if you wanna poke around a bit

```sh
ssh -i ROUTE_TO_PRIVATE_KEY veilid@IP_ADDRESS_FROM_OUTPUT
```

> when using an IPv6 address via ssh, you might need to put square brackets around the address, eg - `ssh -i ROUTE_TO_PRIVATE_KEY veilid@[IP_ADDRESS_FROM_OUTPUT]`
