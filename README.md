# private-registry-harbor-installation

-- harbor --

öncelikle docker ve docker-compose kurulması gerekiyor.

ubuntu 18.04 e yüklemek için scriptimi kullanabilirsiniz.

```curl https://raw.githubusercontent.com/alperen-selcuk/docker-install/main/ubuntu-1804.sh | bash -```

daha sonra lets-encrypt sertifikası için cert bot yükleyeceğiz. ve sertifika üreteceğiz

eğer domaininiz varsa A kaydı domaine eklemeniz gerekiyor. 

```
apt install certbot -y

certbot certonly --standalone -d "yourdomain" --preferred-challenges http --agree-tos -n -m "yourmail" --keep-until-expiring
```

cert üretiltikten sonra cert dizininden kendi dizinimize atacağız.

```
cp /etc/letsencrypt/live/registry.dev-ops.expert/fullchain.pem cert.key
cp /etc/letsencrypt/live/registry.dev-ops.expert/privkey.pem key.key
```

daha sonra harbor github sayfasından install scriptini indireceğiz.

```
wget https://github.com/goharbor/harbor/releases/download/v2.7.0/harbor-online-installer-v2.7.0.tgz
tar xzvf harbor-online-installer-v2.7.0.tgz
```

burada harbor.yml.tmpl isimli dosyada sırasıyla domain, cert file yerleri değiştirilecek ve tmpl kaldırılacak "mv harbor.yml.tmpl harbor.yml"

işlemler bittikten sonra install scripti çalıştırıalacak "./install.sh"

harbor kurulduktan sonra birtane private repo açılıp içine image atabilriiz. image atmak içinse bir tane admin yetkili user ekleyebiliriz.

-- kubernetes -- 

kubernetes için öncelikle bir private registry secret üreteceğiz. username ve password olarak açtığımız admin yetkili user ı verebiliriz.

```
kubectl create secret docker-registry registry --docker-server=<registry> --docker-username=<username> --docker-password=<password> --docker-email=push@dev-ops.expert
```

daha sonra bu secret in bütün podlarda kullanılamsı için default service accoutn a inject etmemiz gerekiyor. ister editleyerek ister patchleyerek bunu yapabiliriz.

```
kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "registry"}]}'
```
