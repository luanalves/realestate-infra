# docker compose down -v --remove-orphans       # derruba tudo e limpa volumes/containers órfãos
docker compose down 
docker system prune -a --volumes -f           # limpa imagens, containers parados, volumes não usados, etc.
docker compose build --no-cache               # reconstrói tudo do zero
docker compose up -d                          # sobe tudo em background
docker compose exec app bash ./clean.sh