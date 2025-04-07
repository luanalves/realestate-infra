#!/bin/bash

echo "===== Docker Network Diagnostics ====="
echo ""
echo "=== Host Machine Information ==="
echo "Host IP Addresses:"
ifconfig | grep "inet " | grep -v 127.0.0.1
echo ""

echo "=== Docker Information ==="
echo "Docker version:"
docker --version
echo ""

echo "Docker network list:"
docker network ls
echo ""

echo "App network details:"
docker network inspect realestate-infra_app-network 2>/dev/null || echo "App network not found"
echo ""

echo "=== Container Information ==="
echo "Running containers:"
docker ps
echo ""

echo "Container IP addresses:"
docker ps -q | xargs -I{} docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' {} 2>/dev/null
echo ""

echo "=== Connectivity Tests ==="
echo "1. Testing connection from host to containers:"
for container in $(docker ps --format '{{.Names}}'); do
  echo "  - Can ping $container?: $(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container 2>/dev/null | xargs -I{} ping -c 1 -W 1 {} > /dev/null 2>&1 && echo "Yes" || echo "No")"
done
echo ""

echo "2. Testing DNS resolution inside app container:"
echo "  - host.docker.internal resolution:"
docker exec realestate_app getent hosts host.docker.internal 2>/dev/null || echo "  Cannot resolve host.docker.internal inside container"
echo ""

echo "3. Testing connection from app container to host:"
echo "  - Ping to host.docker.internal:"
docker exec realestate_app ping -c 1 host.docker.internal 2>/dev/null || echo "  Cannot ping host.docker.internal from container"
echo ""

echo "=== PHP & Xdebug Information ==="
echo "PHP version in container:"
docker exec realestate_app php -v
echo ""

echo "Xdebug info:"
docker exec realestate_app php -i | grep -i xdebug
echo ""

echo "===== Suggested Solutions ====="
echo "1. Add this to your /etc/hosts file (requires sudo):"
echo "127.0.0.1 host.docker.internal"
echo ""

echo "2. Update docker-compose.yml extra_hosts with your actual host IP:"
host_ip=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -n1)
echo "extra_hosts:"
echo "  - \"host.docker.internal:${host_ip}\""
echo ""

echo "3. Restart Docker service completely:"
echo "docker-compose down"
echo "docker system prune -f"
echo "docker-compose up -d --build"
echo ""

echo "===== End of Diagnostics ====="
