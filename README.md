# RealEstate - Ambiente de Desenvolvimento com Docker

Este projeto utiliza Docker para rodar uma stack completa de desenvolvimento Laravel com:

- PHP 8.2 + Nginx (em um único container)
- PostgreSQL 15
- Redis (para cache e sessões)
- MongoDB 6 (para dados não relacionais)

---

## 🚀 Primeiros passos

### 1. Clone este repositório de infraestrutura Docker
```bash
git clone <URL_DO_REPOSITORIO_INFRA>
cd realestate
```

> ⚠️ Certifique-se de que você tem Docker Desktop instalado e funcionando (versão 2.23+).

---

### 2. Configure o diretório com o código Laravel

Crie um diretório chamado `src/` dentro do projeto e, se necessário, inicialize um novo projeto Laravel dentro dele.

```bash
mkdir src
cd src
composer create-project laravel/laravel .
```

> Você pode colocar o projeto Laravel em qualquer lugar do seu sistema de arquivos. O `docker-compose.yml` está configurado para montar o diretório `src/` local como `/var/www` dentro do container.

---

### 3. Suba os containers pela primeira vez

```bash
docker compose up -d --build
```

> Este comando constrói e inicia os containers de:
> - `app`: PHP + Nginx
> - `postgres`: banco relacional
> - `redis`: cache/sessão
> - `mongodb`: documentos

---

## 🧪 Comandos úteis

### Acessar o container do app:
```bash
docker compose exec app bash
```

### Rodar migrations do Laravel:
```bash
php artisan migrate
```

### Testar conexão com Redis via Tinker:
```bash
php artisan tinker
>>> Cache::put('chave', 'valor', 60);
>>> Cache::get('chave');
```

---

## 🌐 Acessar a aplicação

Abra no navegador:
```
http://localhost:8080
```
Se tudo estiver certo, você verá a página inicial do Laravel.

---

## 🧹 Parar os containers
```bash
docker compose down
```

## 🧼 Parar e remover volumes (dados do banco)
```bash
docker compose down -v
```

---

Para dúvidas, entre em contato com o time de desenvolvimento ou consulte os arquivos dentro da pasta `docker/`.
