# Notes App – Dockerized Setup

This project includes a **React frontend**, **Lambda backend**, and **PostgreSQL database**.

## 🐳 Services Overview

- **database**: PostgreSQL database with persistent volume.
- **backend**: AWS Lambda.
- **frontend**: React app served on port `5173`.

---

## 🚀 Getting Started

### Clone the Repository

```bash
git clone https://github.com/vibakar/notes-app.git
cd notes-app
```

### Update .env file
Before launching the app, duplicate the example environment file in the `frontend` directory, then update each with your specific configuration.

```cp .env.example .env```

### Start All Services
```docker compose up --build```

### Access the App
`Frontend:` http://localhost:5173

### Clean Up
To stop and remove container:

```docker compose down```

### Manual Configuration

* The `Infra Setup` pipeline handles Auth0 setup when deploying the app to AWS.
* However, to enable the pipeline to configure Auth0, you must manually create a Machine-to-Machine (M2M) application.
* Configure below permissions for M2M application
    ```
    create:client_grants, read:client_grants, update:client_grants, delete:client_grants, create:clients, read:clients, update:clients, delete:clients, create:resource_servers, read:resource_servers, update:resource_servers, delete:resource_servers, create:actions, read:actions, update:actions, delete:actions, create:custom_domains, read:custom_domains, update:custom_domains, delete:custom_domain
    ```
    
* Store the credentials of M2M application in AWS Secrets Manager under:
    ```
    notes-app/auth0/pipeline-config
    ```
* Store the credentials for pulling docker images in AWS Secrets Manager under:
    ```
    notes-app/docker/credentials
    ```
    Note: `Bootstrap` stage in `Infra Setup` pipeline will create the secret container for storing both AUTH0 (`notes-app/auth0/pipeline-config`) and docker (`notes-app/docker/credentials`) credentials

### Repository Secrets
The following secrets have been configured in the repository to enable the pipeline to create AWS resources and push images to the Docker registry:

- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_REGION
- DOCKER_USERNAME
- DOCKER_PASSWORD