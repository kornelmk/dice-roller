# dice-roller

## Opis projektu 

Dice Roller to prosta aplikacja webowa realizująca generowanie losowych rzutów kostkami oraz obliczanie podstawowych statystyk. Projekt został przygotowany w celu demonstracji pełnego procesu CI/CD, konteneryzacji oraz wdrożenia na AWS z użyciem Terraform. 

## Strukutra katalogów

```text
dice-roller/
│
├── LICENSE
|
├── README.md
|
├── docker-compose.yml
|
├── database/
│   └── init.sql
│
├── backend/
│   ├── Dockerfile
│   ├── requirements.txt
│   ├── requirements-dev.txt
│   ├── app/
│   │   ├── __init__.py
│   │   ├── main.py
│   │   ├── database.py
│   │   └── models.py
│   └── tests/
│       ├── __init__.py
│       └── test_main.py
│
├── ifnra/
│   ├── app.tf
│   ├── cloudwatch.tf
│   ├── iam.tf
│   ├── locals.tf
│   ├── logs.tf
│   ├── network.tf
│   ├── provider.tf
│   └── security-groups.tf
│
├── frontend/
│   ├── Dockerfile
│   ├── requirements.txt
│   └── app.py
│
├── infra/
│   └── nginx.conf
│
├── nginx/
│   └── nginx.conf

```

## Architektura potoku CI/CD

```text
1. backend-test
2. frontend-test
        ↓
3. docker-build
        ↓
4. docker-push
        ↓
5. smoke-test
        ↓
6. tag-release
```