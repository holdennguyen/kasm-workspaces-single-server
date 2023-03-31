<h1>
<p align="center">
  <img src="/docs/images/thumbnail.png" alt="Logo" height="350">
</h1>
</p> 
<p align="center">
  <a href="https://www.terraform.io/" target="_blank">
    <img src="https://img.shields.io/badge/-Terraform-7B42BC?logo=terraform&logoColor=white" alt="Terraform">
  </a>
  <a href="https://linode.gvw92c.net/c/3922399/903680/10906" target="_blank">
    <img src="https://img.shields.io/badge/Linode-00A95C?logo=Linode&logoColor=white" alt="Linode">
  </a>
  <a href="https://hub.docker.com/u/kasmweb" target="_blank">
    <img src="https://img.shields.io/badge/-DockerHub-2496ED?logo=docker&logoColor=white" alt="Docker">
  </a>
</p>




## 🥷 Usage
I use this solution to `keep my identity private` and my workstation `safe from malware`. It is incredibly more powerful than **Incognito Mode**, **VM**, and **VPN**:
- The session is pristine with `no browser history or cookies` from my host computer or previous sessions.
- Any website I visit `only runs in the context of this session`. None of the website’s code runs on my personal computer — only the remote browser `in the disposable container`.
- The session is running the `full edition of Chrome/Brave/Firefox or even Tor` so I can add my favorite extensions and I can be confident most websites will work.
- Websites will see the IP of my Linode server and `not my home or work IP`.
- At any time I can `destroy this session` and `start a fresh one` over again.

*Researchers*, *hackers*, *Darkweb tourists*.. This solution maybe work for you!

![Singer Server](/docs/images/single-server.png)

## 💽 About The Kasm Workspaces
**The Container Streaming Platform®**
Streaming containerized apps and desktops to end-users. The Workspaces platform provides enterprise-class orchestration, data loss prevention, and web streaming technology to enable the delivery of containerized workloads to your browser.

<video width="100%" controls>
  <source src="https://kasmweb.com/assets/videos/Cloud_Personal_Walkthrough.mp4" type="video/mp4">
</video>

- [What is Kasm Workspaces](https://kasmweb.com/)
- [Kasm Cloud Personal](https://kasmweb.com/cloud-personal)

## 🔎 Pros & Cons

This instruction requires knowledge of networking essentials, Linux, and Terraform. You also have to turn it off after using and re-config when turn-on (But don't worry, only three commands)

    | Solution                              | Resource             | Cost                    |
    | ------------------------------------- | ---------------------| ----------------------- |
    | Kasm Cloud Personal Browser           | 1 Core, 2GB RAM      | `$5/month fix.`         |
    | Terraform + Linode (Self Manage)      | 2 Core, 4GB RAM      | `$0.28/hour On-demand.` |

## 🔱 Instruction

### Setup Linode Cloud (Akamai)

You must have `a Linode Cloud account`. If you don't have an account yet, [register via my referral](https://linode.gvw92c.net/c/3922399/903680/10906) to get a `$100 credit` (expires after 4 months). 

![Credit](/docs/images/credit.png)

**Since you have a Linode account, get API Tokens to allow Terraform provision as Code:**
1. To generate a **new personal access token**, navigate to your profile by clicking on `your username` and selecting `API Tokens`.
![token1](/docs/images/token1.jpg) 
1. Click `Create a Personal Access Token`. A panel appears that allows you to give this token a label and choose the access rights you want users authenticated with the new token to have.
<img src="/docs/images/token2.jpg" alt="Logo" height="350">
1. When you have finished, click `Create Token` to generate a new `Personal Access Token`. `Copy the token and save it` to a secure location before closing the popup. **You will not be able to view this token through the Cloud Manager after closing the popup.**

### Install Terraform

[How to Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

>🔔 In Windows, make sure that you add the path of the Terraform CLI executable to your PATH environment variable so that you can run from any directory on your laptop/computer.

Clone this repository, go to folder `kasm-workspaces-single-server/` and open file `main.tf` to replace **[YOUR TOKEN]** with your Personal Access Token from Linode in the previous section:

```
provider "linode" {
  token = "[YOUR TOKEN]"
}
```

Replace **[YOUR PASSWORD]** with your root user password of Linode Instance, it requires passwords to meet the following criteria:
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

Save the file and run these commands:

```
terraform init
terraform apply --auto-approve
```

Your output will be similar:
![output](/docs/images/output.png)

`public_ip` will be your public IP address of the Linode cloud server.

After Terraform is completed, wait 10-15 minutes for `Kasm Workspaces` installation finished.

## 📺 Kasm Workspaces
Open your browser, enter `https://[YOUR LINODE PUBLIC IP]`
![kasm workspaces1](/docs/images/kasm-workspaces.png)

Click `Advanced` and `Proceed to [YOUR LINODE PUBLIC IP] (unsafe)` (Don't worry, this is your own cloud server). Login with `admin@kasm.local`:`password`
![kasm workspaces login](/docs/images/kasm-workspaces-login.png)

We will need to SSH remotely to this server to reset the Kasm Workspace password. 
Run this command:

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

After runing, it will output `UPDATE 1` which means you success to reset the password of Kasm Workspaces. Your admin account will be `admin@kasm.local`: `password`.

>If you install manual Kasm Workspaces instead of using Terraform, your random password will be output on the terminal so you don't need to do this reset task.

Now your `Kasm Workspaces` is ready:
![kasm workspaces ready](/docs/images/kasm-workspaces-ready.png)

Select the tab `WORKSPACES` on the top bar to start using.
![workspaces](/docs/images/workspaces.png)


## ☢️ Destroy Kasm Workspaces
In your terraform working directory, run this command:

```
terraform destroy --auto-approve
```
Your Linode server on the cloud will be destroyed completely!

#### Further
- You can also share an account user with your friend to use your Kasm Workspaces by config in the section `Users` (Our capacity is quite low, so multiple users is not recommended):
<img src="/docs/images/user.png" alt="Logo" height="250">

- To add more types of containers (Workspace) in your Kasm Workspaces, go to the section `Workspaces` to `Add Workspace` and config the DockerHub image. (You can build your custom Docker image and use it in Kasm Workspaces).

- If you see the error when starting some container (workspace) like `Terminal`, it is due to your server's capacity can't handle it. You can change the capacity of the Linode server by modifying it in `main.tf`.
This tutorial will use for browsing the web so I will not go into detail on this capacity issue.

- For more information, you can read Kasm Documentation [here](https://www.kasmweb.com/docs/latest/index.html).