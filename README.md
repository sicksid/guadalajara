# guadalajara [![Fly Deploy](https://github.com/sicksid/guadalajara/actions/workflows/main.yml/badge.svg)](https://github.com/sicksid/guadalajara/actions/workflows/main.yml)

## Using development environment

In order to make your rails application work for development, you have to install docker first

### running the app

`docker compose up -d`

### running any rails command

`docker compose run app <COMMAND>`

example running `rails db:migrate`

`docker compose run app rails db:migrate`


### from scratch

```
docker compose up -d
docker compose run app rails db:create db:migrate db:seed
```

