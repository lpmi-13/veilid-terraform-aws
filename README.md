# Veilid nodes on AWS

Details at https://veilid.com/

Running veilid nodes is a super easy way to help grow the network, and if you don't feel like manually setting up everything, this is an easy way to run one or more in AWS via terraform.

Even though AWS doesn't have a "forever" free tier like Azure/GCP/Oracle, you might still want to take advantage of their 12-month free tier access, or even just run nodes in AWS because that's your preferred cloud environment.

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
