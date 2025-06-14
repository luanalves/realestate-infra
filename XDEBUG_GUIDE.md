# Guia de Teste do Xdebug

## 1. Configuração do IDE

### VSCode:
**IMPORTANTE: Use esta configuração específica para o projeto RealEstate**

Crie o arquivo `.vscode/launch.json` no diretório `realestate-infra`:

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
                "/var/www/html": "/opt/homebrew/var/www/realestate/realestate-app"
            },
            "ignore": [
                "**/vendor/**/*.php"
            ]
        }
    ]
}
```

**Passos para usar no VSCode:**
1. Instale a extensão **PHP Debug** (felixfbecker.php-debug)
2. Abra a pasta `realestate-app` no VSCode (onde está o código Laravel)
3. Use a configuração de debug criada acima
4. Coloque breakpoints nos arquivos PHP
5. Inicie "Listen for Xdebug" na aba Debug do VSCode
6. Acesse a aplicação no navegador

### PHPStorm:
1. **Settings > PHP > Debug**
   - Debug port: `9004`
   
2. **Settings > PHP > Servers**
   - Name: `realestate.localhost`
   - Host: `realestate.localhost`
   - Port: `80`
   - Debugger: `Xdebug`
   - Path mappings: `/var/www/html` → `[caminho para seu projeto]/src`

## 2. Teste do Xdebug

### Passo 1: Verificar se o Xdebug está ativo
```bash
docker exec realestate_app php -m | grep -i xdebug
```

### Passo 2: Abrir o arquivo de teste
Acesse: http://realestate.localhost/test-xdebug.php

### Passo 3: Configurar breakpoint
1. Abra o arquivo `src/public/test-xdebug.php` no seu IDE
2. Coloque um breakpoint na linha: `$test_variable = "Xdebug funcionando!";`
3. Inicie o listener de debug no seu IDE
4. Atualize a página no navegador

### Passo 4: Verificar logs (se não funcionar)
```bash
docker exec realestate_app tail -f /var/log/xdebug.log
```

## 3. Teste com Laravel

### Criar rota de teste:
```bash
docker exec realestate_app bash -c 'echo "Route::get(\"/debug-test\", function () { \$data = \"Debug test\"; return view(\"welcome\", compact(\"data\")); });" >> /var/www/html/routes/web.php'
```

### Testar:
1. Coloque breakpoint na rota criada
2. Acesse: http://realestate.localhost/debug-test

## 4. Troubleshooting

### Se o Xdebug não conectar:

**⚠️ IMPORTANTE: A porta 9004 deve estar "ocupada" pelo Docker - isso é normal!**

1. **Verifique se o IDE está ouvindo na porta 9004:**
   - VSCode: Inicie o debug "Listen for Xdebug"
   - PHPStorm: Ative "Start Listening for PHP Debug Connections"

2. **Confirme que o domínio `realestate.localhost` está no `/etc/hosts`:**
   ```bash
   echo "127.0.0.1 realestate.localhost" | sudo tee -a /etc/hosts
   ```

3. **Verifique se a porta está mapeada corretamente:**
   ```bash
   docker port realestate_app | grep 9004
   ```
   Deve retornar: `9004/tcp -> 0.0.0.0:9004`

4. **Teste com sessão forçada:**
   http://realestate.localhost/test-xdebug.php?XDEBUG_SESSION_START=1

5. **Verificar configuração do Xdebug:**
   ```bash
   docker exec realestate_app php -i | grep "xdebug.client_port\|xdebug.mode"
   ```

### Comandos úteis:
```bash
# Verificar se Docker está usando a porta (isso é NORMAL)
lsof -i :9004

# Verificar configuração do Xdebug
docker exec realestate_app php -i | grep xdebug

# Verificar portas do container
docker port realestate_app

# Reiniciar container
docker restart realestate_app
```

### Path Mappings corretos:
- **Container:** `/var/www/html`
- **Host:** `${workspaceFolder}` (diretório onde está o docker-compose.yml)
- **Se você tem o código Laravel em `src/`:** `${workspaceFolder}/src`
