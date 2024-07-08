# README Docker

Instructions pour faire tourner DS avec Docker.

> [!CAUTION]
>
> - La configuration du serveur SMTP n'est pas faite pour la production (cf `config/env.example.optional`)

1. [Build des images](#build-de-limage)
  - [Setup local](#setup-local)
  - [Et build](#et-build)
    - [Développement](#développement)
    - [Production](#production)
2. [Mise à jour](#mise-à-jour-depuis-le-repo-ds-officiel)
3. [Modifications apportées](#3-modifications-apportées)
4. [Test](#tests)
5. [Plus d'infos](#plus-dinfos)

## Build de l'image

### Setup local

Il faut mettre à jour les fichiers de dépendances (`bun.lockb` et `Gemfile.lock`) dû au fait que l'on a ajouté des dépendances et supprimés d'autres. Cette mise à jour doit avoir lieu dans le cadre d'une installation de base ou d'une mise à jour depuis le `main` officiel.

Il est nécessaire d'avoir Ruby d'installé et la version définie dans `.ruby_version` (pour installer une version spécifique de Ruby je recommande https://asdf-vm.com/)

```
# Ruby et NodeJS sont nécessaires
./bin/prepare-local-env
```

### Et build

L'image de dev et de prod sont construites de façon très différentes :
- La dev s'appuie sur une seule image contenant le serveur applicatif et les jobs. La production s'appuie sur 2 conteneurs différents ;
- La dev charge les assets à la volée. La production précompile tous les assets qui sont servis via le reverse proxy et non le serveur applicatif ;
- La dev authorise le HTTP. La production n'autorise que le HTTPS et redirige toutes le requêtes en HTTPS ;

#### Développement

Puis ensuite il est possible de construire l'image Docker de dev :

```
./bin/docker-dev
# ou pour forcer le re-build (suppression des volumes et conteneurs)
DEBUG=true ./bin/docker-dev
```

#### Production

> [!CAUTION]
>
> En production, il y a des variables à renseigner dans `env.production`.

Le script suivant fusionne les fichiers de variables :

- `env.production.base` : les variables par défaut de DS inchangées ;
- `env.production` : **les variables à changer pour la production** ;
- les fichiers sont fusionnés pour devenir `.env` par `bin/docker-prod` pour avoir l'intégralité des variables obligatoires

Pour faire des tests en local sur l'environnement de production il faut désactiver temporairement le SSL (ou mettre un reverse proxy devant). Cf les 3 "WARNING" dans :

- `config/environnement/production.rb` : 2 warnings ;
- `env.production` : 1 warning

Une fois celà remplit :

```
# Start the server
./bin/docker-prod
# ou pour forcer un re-build, contrairement au développement ça ne supprime pas la bdd
DEBUG=true ./bin/docker-prod
```

## Mise à jour depuis le repo DS officiel

TODO XXX

## Modifications apportées

Pour convenir à notre usage les modifications suivantes ont été apportées :

- ajout d'une action préalable à tous les controllers via `app/controllers/concerns/remote_user_concern.rb` qui identifie l'utilisateur à partir de headers envoyés par le reverse proxy ;
- suppression de [Skylight](https://www.skylight.io) à plusieurs endroits, il n'est pas possible de le désactiver ;
- fix de l'import des features via [Flipper](https://github.com/flippercloud/flipper), dans Docker les features n'ont pas l'air d'être pré-chargée 🤔, elles sont donc chargées manuellement (`config/initializers/flipper.rb`)

## 3. Tests

Des tests ont été écrits pour le code produit ; les tests se lancent ainsi :

```
# prefixer la commande avec RAILS_ENV=test si l'env détecté est différent
./bin/rspec spec/controllers/application_controller_spec.rb:211
# second fichier
./bin/rspec spec/controllers/super_admins/sessions_controller_spec.rb
```

## Plus d'infos

Les fichiers de configuration de Docker sont rangés ainsi :

```arduino
.
├── docker/
│   ├── development/
│   │   ├── Dockerfile
│   │   ├── docker-compose.yml
│   ├── production/
│   │   ├── Dockerfile
│   │   ├── docker-compose.yml
├── app/
├── config/
├── Gemfile
├── Gemfile.lock
├── ...
```
