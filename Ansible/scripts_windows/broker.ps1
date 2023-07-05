# Crée un déploiement de session Bureau à distance (Remote Desktop Session Deployment)
New-RDSessionDeployment -ConnectionBroker srv-wad-test-01.favb.local -SessionHost srv-wad-test-01.favb.local -WebAccessServer srv-wad-test-01.favb.local

# Crée une collection de session Bureau à distance (Remote Desktop Session Collection)
New-RDSessionCollection -CollectionName "RdsApps" -CollectionDescription "Collection RDS pour accéder aux applications" -ConnectionBroker srv-wad-test-01.favb.local -SessionHost srv-wad-test-01.favb.local

# Configure les paramètres de la collection de session, désactivant les dossiers temporaires par session et empêchant leur suppression à la sortie
Set-RDSessionCollectionConfiguration -CollectionName "RdsApps" -TemporaryFoldersPerSession $false -TemporaryFoldersDeletedOnExit $false

# Configure les limites de session pour la collection, définissant une limite de session déconnectée de 360 minutes et une limite de session inactive de 120 minutes
Set-RDSessionCollectionConfiguration -CollectionName "RdsApps" -DisconnectedSessionLimitMin 360 -IdleSessionLimitMin 120

# Crée une application Bureau à distance (RemoteApp) pour WordPad, spécifiant l'alias, le nom d'affichage, le chemin d'accès à l'exécutable et la collection à laquelle elle appartient
New-RDRemoteApp -Alias Wordpad -DisplayName WordPad -FilePath "C:\Program Files\Windows NT\Accessoires\wordpad.exe" -ShowInWebAccess 1 -CollectionName "RdsApps" -ConnectionBroker srv-wad-test-01.favb.local

# Crée une application Bureau à distance (RemoteApp) pour WinSCP, spécifiant l'alias, le nom d'affichage, le chemin d'accès à l'exécutable et la collection à laquelle elle appartient
New-RDRemoteApp -Alias WinSCP -DisplayName WinSCP -FilePath "C:\Program Files (x86)\WinSCP\WinSCP.exe" -ShowInWebAccess 1 -CollectionName "RdsApps" -ConnectionBroker srv-wad-test-01.favb.local

# Importe un certificat pour le rôle RDS RD Server, spécifiant le chemin d'accès au certificat PFX, le mot de passe du certificat et le rôle
Set-RDCertificate -Role RDS-RD-SERVER -ImportPath "C:\Users\Administrateur\Documents\rds_certificat.pfx" -Password (ConvertTo-SecureString -String "ProjetAnnuel2023!" -AsPlainText -Force)

# Crée un nouveau certificat pour le rôle RD Web Access, spécifiant le nom DNS du serveur, le mot de passe du certificat, le chemin d'accès pour l'exportation du certificat PFX, le serveur Connection Broker et force la création du certificat
New-RDCertificate -Role RDWebAccess -DnsName "srv-wad-test-01.favb.local" -Password (ConvertTo-SecureString -String "ProjetAnnuel2023!" -AsPlainText -Force) -ExportPath "C:\Users\Administrateur\Documents\rds_cert.pfx" -ConnectionBroker srv-wad-test-01.favb.local -Force
