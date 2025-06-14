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

> Você pode colocar o projeto Laravel em qualquer lugar do seu sistema de arquivos. O `docker-compose.yml` está configurado para montar o diretório `src/` local como `/var/www/html` dentro do container.

---

### 3. Configure as variáveis de ambiente

Copie o arquivo `.env.example` para `.env` e configure as variáveis necessárias:

```bash
cp .env.example .env
```

> O arquivo `.env.example` contém todas as variáveis de ambiente necessárias para o projeto com valores de exemplo e comentários explicativos. É essencial utilizar este arquivo como referência ao configurar seu ambiente local.
>
> Lembre-se: Sempre que adicionar ou alterar variáveis no arquivo `.env`, atualize também o arquivo `.env.example` para que outros desenvolvedores tenham as informações necessárias.

---

### 4. Suba os containers pela primeira vez

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
http://realestate.localhost
```
ou
```
http://realestate.localhost
```
Se tudo estiver certo, você verá a página inicial do Laravel.

> ⚠️ Para que o domínio funcione, adicione a seguinte linha ao seu arquivo de hosts local:
> 
> **Linux/macOS:** Edite o arquivo `/etc/hosts` com permissão de administrador:
> ```bash
> sudo nano /etc/hosts
> ```
> **Windows:** Edite o arquivo `C:\Windows\System32\drivers\etc\hosts` com um editor de texto como Administrador.
>
> Adicione a linha:
> ```
> 127.0.0.1 realestate.localhost
> ```
>
> Salve o arquivo e acesse http://realestate.localhost:8080 ou http://realestate.localhost no navegador.

---

## 🔗 Como conectar aos bancos de dados

### PostgreSQL
- **De dentro do container app (Laravel):**
  - Host: `realestate_postgres`
  - Porta: `5432`
  - Usuário, senha e banco: conforme variáveis de ambiente (`DB_HOST`, `DB_PORT`, `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`)
  - Exemplo de string de conexão Laravel:
    ```env
    DB_CONNECTION=pgsql
    DB_HOST=realestate_postgres
    DB_PORT=5432
    DB_DATABASE=seu_banco
    DB_USERNAME=seu_usuario
    DB_PASSWORD=sua_senha
    ```
- **De sua máquina (host):**
  - Host: `localhost`
  - Porta: `5432`
  - Use os mesmos usuário, senha e banco.

### Redis
- **De dentro do container app (Laravel):**
  - Host: `realestate_redis`
  - Porta: `6379`
  - Senha: conforme `REDIS_PASSWORD` (se configurado)
  - Exemplo de configuração Laravel:
    ```env
    REDIS_HOST=realestate_redis
    REDIS_PASSWORD=null
    REDIS_PORT=6379
    ```
- **De sua máquina (host):**
  - Host: `localhost`
  - Porta: `6379`

### MongoDB
- **De dentro do container app (Laravel):**
  - Host: `realestate_mongo`
  - Porta: `27017`
  - Banco: `realestate` (definido em `MONGO_DB_DATABASE`)
  - String de conexão: `MONGO_URI=mongodb://realestate_mongo:27017/realestate`
- **De sua máquina (host):**
  - Host: `localhost`
  - Porta: `27017`
  - Banco: `realestate`
  - String de conexão: `mongodb://localhost:27017/realestate`

> O nome do banco MongoDB é definido pela variável `MONGO_DB_DATABASE` no `.env` e já está configurado como `realestate` por padrão.
> 
> Para acessar via ferramentas gráficas (ex: DBeaver, MongoDB Compass), use o host `localhost` e as portas acima.

---

## 🐛 Depuração com Xdebug

O ambiente está configurado com Xdebug 3.x para depuração em tempo real. Para utilizá-lo:

### Configuração no VSCode:
1. Instale a extensão **PHP Debug**
2. Crie ou configure o arquivo `.vscode/launch.json`:
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Listen for Xdebug",
            "type": "php",
            "request": "launch",
            "port": 9004,
            "pathMappings": {
                "/var/www/html": "${workspaceFolder}/src"
            }
        }
    ]
}
```

### Configuração no PHPStorm:
1. Acesse **Settings > PHP > Debug**
2. Configure o **Debug port** para **9004**
3. Em **Settings > PHP > Servers**, adicione um servidor:
   - Name: `realestate.localhost`
   - Host: `realestate.localhost`
   - Port: `80`
   - Debugger: `Xdebug`
   - Path mappings: `/var/www/html` → `caminho/para/seu/projeto/src`

### Como usar:
1. Defina breakpoints no seu código
2. Inicie o listener de debug no seu IDE
3. Acesse a aplicação no navegador ou execute comandos artisan
4. O debugger irá parar nos breakpoints definidos

### Script auxiliar:
Use o script `docker/xdebug-toggle.sh` para habilitar/desabilitar o Xdebug:
```bash
# Habilitar Xdebug
./docker/xdebug-toggle.sh on

# Desabilitar Xdebug
./docker/xdebug-toggle.sh off
```

> **Nota:** O Xdebug está configurado na porta **9004** e está ativo por padrão no ambiente de desenvolvimento.
> O modo está configurado como `debug,develop,coverage` para suporte completo a debugging e coverage de testes.

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
