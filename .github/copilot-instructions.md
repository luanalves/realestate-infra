# GitHub Copilot Instructions for RealEstate Project

## Project Overview
This is a real estate application infrastructure project that uses Docker to run a complete Laravel development stack with:
- PHP 8.2 + Nginx (in a single container)
- PostgreSQL 15
- Redis (for caching and sessions)
- MongoDB 6 (for non-relational data)

## Project Structure
- `docker/` - Contains all Docker-related configuration files
  - `Dockerfile` - Main Dockerfile for the PHP/Nginx container
  - `supervisord.conf` - Supervisor configuration for managing processes
  - `nginx/` - Nginx server configurations
  - `php/` - PHP configuration files
- `docker-compose.yml` - Defines all services and their configurations
- `clean.sh` - Script to clean up Docker artifacts
- `README.md` - Project documentation

## Development Environment
The application expects a Laravel project in the `src/` directory (mounted as `/var/www/html` in the container).

### Environment Variables
- Always maintain the `.env.example` file when making changes to the `.env` file.
- Any time you add or update environment variables in `.env`, make sure to update `.env.example` with appropriate placeholder values and comments.
- New environment variables should include descriptive comments in the `.env.example` file.
- This ensures that new developers joining the project can quickly set up their environment with all necessary configuration options.
- Remember that `.env` files contain sensitive information and should not be committed to the repository, while `.env.example` is tracked in version control.

## Key Technologies
- Docker & Docker Compose
- PHP 8.2
- Laravel (latest)
- PostgreSQL 15
- Redis
- MongoDB 6
- Nginx

## Coding Guidelines
1. Follow PSR-12 coding standards for PHP code
2. Use Laravel best practices and conventions
3. Document Docker configurations with comments
4. Keep Dockerfile commands organized by functionality
5. Use environment variables for configuration values

## Common Tasks
- Database connections should use environment variables
- Redis should be configured for session and cache
- MongoDB should be used for document-based data storage
- Nginx configurations should be optimized for Laravel applications

## Docker Environment Variables
The following environment variables are expected:
- APP_ENV
- APP_DEBUG
- DB_CONNECTION
- DB_HOST
- DB_PORT
- DB_DATABASE
- DB_USERNAME
- DB_PASSWORD
- REDIS_HOST
- REDIS_PASSWORD
- MONGO_URI
- APP_PATH (for mounting the source code directory)

## Best Practices
1. Always validate Docker configurations before committing
2. Use proper versioning for Docker images
3. Optimize Docker layers for better build performance
4. Document changes to Docker configurations
5. Implement proper error handling for all services

## Application Architecture
The application follows a standard Laravel architecture with:
- MVC pattern
- Repository pattern for data access
- Service classes for business logic
- Multiple database connections (PostgreSQL and MongoDB)
- Redis for caching and session management

## Security Considerations
1. No secrets should be hardcoded in Docker files
2. Use non-root users for running services where possible
3. Follow security best practices for all services
4. Properly configure firewalls and network access

## Performance Guidelines
1. Optimize database queries
2. Implement proper caching strategies
3. Configure proper resource limits for containers
4. Utilize connection pooling where supported