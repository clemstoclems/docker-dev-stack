#Omnilog Docker Dev Stack

# Images

voici la liste des images actuellement utilisées : 

| Image | Tag | Container |
| ------ | ------ | ------ |
| [traefik](https://hub.docker.com/_/traefik) | 2.2 | traefik | 
| [portainer](https://hub.docker.com/r/portainer/portainer) | 1.21.0 | portainer | 
| [rabbitmq](https://hub.docker.com/_/rabbitmq) | 3.6-management | rabbit |
| [docker.elastic.co/elasticsearch/elasticsearch](https://www.docker.elastic.co) | 7.7.0 | elasticsearch |
| [docker.elastic.co/kibana/kibana](https://www.docker.elastic.co) | 7.7.0 | kibana | 
| [elastic/logstash](https://www.elastic.co/guide/en/logstash/current/docker.html) | 7.7.0 | logstash | 
| [evenstore/eventstore](https://hub.docker.com/r/eventstore/eventstore) | release-5.0.7 | event-store | 
| [symfony-docker](https://github.com/coloso/symfony-docker) | latest | php7.4 |
| [symfony-docker](https://github.com/coloso/symfony-docker) | latest | nginx |
| [mysql](https://hub.docker.com/_/mysql) | 5.7 | mysql |

# Mise à jour de docker compose

Pour mettre à jour votre docker-compose :

```
sudo apt-get remove docker-compose

sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

# Personnalisation

Quelques informations sont à mettre à jour en fonction de votre environnement :

* Vous devez copier le fichier `env.template` en `.env` et renseigner les valeurs des variables d'environnement. Les valeurs par défaut sont indiquées dans le fichier `env.template`
```
ELASTIC_TAG=7.7.0
```

* Dans le `docker-compose.yml` : Vérifier tous les `volumes:` et la valeur de la variable `PROJECTS_ROOT_DIR` (doit pointer sur votre repertoire de projets)

# Ajouter un host

## /etc/hosts

Ajouter le `host` dans votre fichier **local** `/etc/hosts` sur l'ip `127.0.0.1`

```
127.0.0.1       application.local
```

# Applicatif 

Vous devez créer le sous repertoire symfony et y installer votre projet symfony.

## Traefik

C'est `Traefik` qui va se charger de savoir si tel host est accessible depuis tel ou tel container .
Traefik gère cette config via les `labels` du container dans le `docker-compose.yml`. 
Sur le bon container, ajouter : 
```
labels:
    [ ... ]
    - "traefik.http.routers.redis_omnistack.rule=Host(`${REDIS_TRAEFIK_LABEL}`)"
```

### Helpers
Nettoyages des containers & images via portainer : 
La web interface portainer (accesible via http://portainer.local) vous permet de gerer vos container, vos volumes, vos networks.

```
login: admin
password: dev
```

Quelques alias pratiques :

```bash
# Mise à jour des images
alias dcp='docker-compose -f ~/projets/docker-dev-stack/docker-compose.yml --project-directory ~/projets/docker-dev-stack pull'

# Éteind les images et les supprime du network
alias dcd='docker-compose -f ~/projets/docker-dev-stack/docker-compose.yml --project-directory ~/projets/docker-dev-stack down'

# Arrêt des images sans les supprimer
alias dcs='docker-compose -f ~/projets/docker-dev-stack/docker-compose.yml --project-directory ~/projets/docker-dev-stack stop'

# Démarrage des images avec mise à jour automatique
alias dcu='dcd && dcp && docker-compose -f ~/projets/docker-dev-stack/docker-compose.yml --project-directory ~/projets/docker-dev-stack up -d'
```

Quelques commandes docker pratiques :

```bash
# Pour entrer dans un container
docker exec -it redis_omnistack bash
docker exec -it mysql_omnistack bash
```

# Liens utiles : 

- [Docker](https://docs.docker.com/)
- [Doc Traefik](https://docs.traefik.io/)
