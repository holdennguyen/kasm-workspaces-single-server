<h1>
<p align="center">
  <img src="/docs/images/thumbnail.png" alt="Logo" height="350">
</h1>
</p> 
<br>

## Usage
I use this solution `keep my identity private` and `workstation safe from malware`. It is incredibly more powerful than **Incognito Mode**, **VM** and **VPN**:
- The session is pristine with `no browser history or cookies` from my host computer or previous sessions.
- Any website I visit `only runs in the context of this session`. None of the website’s code runs on my personal computer — only the remote browser `in the disposable container`.
- The session is running the `full edition of Chrome/Brave/Firefox or even Tor` so I can add my favorite extensions and I can be confident most websites will work.
- Websites will see the IP of my Linode server and `not my home or work IP`.
- At any time I can `destroy this session` and `start a fresh one` over again.

*Researchers*, *hackers*, *Darkweb tourist*.. This solution maybe work for you!

![Singer Server](/docs/images/single-server.png)

## About The Kasm Workspaces
<video width="100%" controls>
  <source src="https://kasmweb.com/assets/videos/Cloud_Personal_Walkthrough.mp4" type="video/mp4">
</video>

- [What is Kasm Workspaces](https://kasmweb.com/)
- [Kasm Cloud Personal](https://kasmweb.com/cloud-personal)

## Pros & Cons

This instruction require knowledge in networking essentials, linux and terraform. You also have to turn off after using and re-config when turn-on (But don't worry, only three command)

    | Solution                              | Resource             | Cost                    |
    | ------------------------------------- | ---------------------| ----------------------- |
    | Kasm Cloud Personal Browser           | 1 Core, 2GB RAM      | `$5/month fix.`         |
    | Terraform + Linode (Self Manage)      | 2 Core, 4GB RAM      | `$0.28/hour On-demand.` |

## Instruction

### Setup Linode Cloud (Akamai)

You must have `Linode Cloud account`. If you don't have account yet, [registry via my refferal](https://linode.gvw92c.net/c/3922399/903680/10906) to get `$100 credit` (expire after 4 months). 

![Credit](/docs/images/credit.png)

**Since you have Linode account, get API Tokens to allow Terraform provision as Code:**
1. To generate a **new personal access token**, navigate to your profile by clicking on `your username` and select `API Tokens`.
![token1](/docs/images/token1.jpg) 
1. Click `Create a Personal Access Token`. A panel appears that allows you to give this token a label and choose the access rights you want users authenticated with the new token to have.
<img src="/docs/images/token2.jpg" alt="Logo" height="350">
1. When you have finished, click `Create Token` to generate a new `Personal Access Token`. `Copy the token and save it` to a secure location before closing the popup. **You will not be able to view this token through the Cloud Manager after closing the popup.**

### Install Terraform

[How to Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

>🔔 In Windows, make sure that you add the path of the Terraform CLI executable to your PATH environment variable so that you can run from any directory on your laptop/computer.

Clone this repository, go to folder `kasm-workspaces-single-server/` and open file `main.tf` to replace **[YOUR TOKEN]** by your Personal Access Token from Linode in previous section:

```
provider "linode" {
  token = "[YOUR TOKEN]"
}
```

Replace **[YOUR PASSWORD]** by your root user password of Linode Instace, it requires passwords to meet the following criteria:
- At least 8 characters long
- Contains at least one uppercase letter
- Contains at least one lowercase letter
- Contains at least one number
- Contains at least one special character

```
resource "linode_instance" "kasm" {
  label = "kasm"
  type = "g6-standard-2"
  region = "us-east"
  image = "linode/ubuntu20.04"
  root_pass = "[YOUR PASSWORD]"
  backups_enabled = false
  private_ip = true
  tags = ["kasm"]
  stackscript_id = linode_stackscript.kasm-stackscript.id
}
```

Save file and run these commands:

```
terraform init
terraform apply --auto-approve
```

After complete, your output will be similar:
![output](/docs/images/output.png)

`public_ip` will be your public IP address of Linode cloud server.

We will need to SSH remote to this server to reset Kasm Workspace password. Run this command:

```
ssh root@[YOUR LINODE PUBLIC IP]
```

![SSH](/docs/images/ssh.png)

Type `yes` and **[YOUR PASSWORD]** (which you provide in `main.tf`)

![SSH Success](/docs/images/ssh-success.png)

Copy and paste this command:

```
sudo docker exec -i kasm_db psql -U kasmapp -d kasm <<EOF
    update users set
    pw_hash = 'fe519184b60a4ef9b93664a831502578499554338fd4500926996ca78fc7f522',
    salt = '83d0947a-bf55-4bec-893b-63aed487a05e',
    secret=NULL, set_two_factor=False, locked=False,
    disabled=False, failed_pw_attempts = 0 where username ='admin@kasm.local';
\q
EOF
```

After run, it will output `UPDATE 1` that mean you success to reset the password of Kasm Workspaces. Your admin account will be `admin@kasm.local`:`password`

>If you install manual Kasm Workspaces instead of using Terraform, your random password will be output on terminal so you don't need to do this reset task.

## Kasm Workspaces
Open your browser, enter `https://[YOUR LINODE PUBLIC IP]`
![kasm workspaces1](/docs/images/kasm-workspaces.png)

Click `Advanced` and `Proceed to [YOUR LINODE PUBLIC IP] (unsafe)` (Don't worry, this is your own cloud server). Login with `admin@kasm.local`:`password`
![kasm workspaces login](/docs/images/kasm-workspaces-login.png)

Now your `Kasm Workspaces` is ready:
![kasm workspaces ready](/docs/images/kasm-workspaces-ready.png)

Select tab `WORKSPACES` on top bar to start using.
![workspaces](/docs/images/workspaces.png)


## Destroy Kasm Workspaces
In your terraform working directory, run this command:

```
terraform destroy --auto-approve
```
Your Linode server on cloud will be destroy completely!

#### Further
- You can also share account user to your friend to using your Kasm Workspaces by config in secion `Users` (Our capacity is quite low, so multiple user is not recommend.):
<img src="/docs/images/user.png" alt="Logo" height="250">

- To add more type of container (Workspace) in your Kasm Workspaces, go to section `Workspaces` to `Add Workspace` and config DockerHub image and install. (You can build your custom Docker image and use it in Kasm Workspaces).

- If you see error when start some container (workspace) like `Terminal`, it is due to your server capacity can't handle it. You can change capacity of Linode server by modify in `main.tf`.
This tutorial will use for browsing web so I will not go to detail on this capacity issue.

- For more information, you can read Kasm Documentation [here](https://www.kasmweb.com/docs/latest/index.html).