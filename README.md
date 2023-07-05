# Projet_Annuel_2023
Proxmox, Packer, Terraform, Ansible

# Packer

# Terraform


# Ansible

# Etape 1 : Prérequis
Remote Computer :
   
   --> Windows PowerShell 3.0

   --> .NET Framework 9.4.7


# Etape 2 : Installation des plugins Ansible dont nous avons besoin
# Fonctionne à partir de la version Ansible 2.12 et antérieur
ansible-galaxy collection install community.windows 

ansible-galaxy collection install ansible.windows


# Etape 3: Installation des paquets python
sudo python3 -m pip -V

sudo curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py

sudo python3 get-pip.py --user

sudo python3 -m pip install --user ansible

sudo apt install python3-winrm

# Etape4 : Lancement du playbook Ansible
sudo -E /home/ansible/.local/bin/ansible -i inventory.ini SRV-AD -m win_ping  # Test de ping avec WinRM depuis Ansible

ansible-playbook -i inventory.ini scripts_windows/deploy_AD_on_proxmox.yml # Execution du yaml pour déployer le contrôleur de domaine sur un serveur windows

ansible-playbook -i inventory.ini scripts_windows/deploy_RDS_on_proxmox.yml # Execution du yaml pour déployer l'ensemble de la configuration RDS

