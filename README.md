# dice-roller

## Opis projektu 

Dice Roller to prosta aplikacja webowa realizująca generowanie losowych rzutów kostkami oraz obliczanie podstawowych statystyk. Projekt został przygotowany w celu demonstracji pełnego procesu CI/CD, konteneryzacji oraz wdrożenia na AWS z użyciem Terraform. 

## Funkcjonalności aplikacji  

Dostępne endpointy: 

- `GET /api/health` – status aplikacji  
- `GET /api/version` – wersja aplikacji  
- `GET /api/dice-types` – lista dostępnych kostek  
- `POST /api/roll` – wykonanie rzutu kostkami  

Przykładowa odpowiedź z endpointu /api/roll: 
```
{ 
 "dice": "K6",
 "results": [4, 6, 1, 6, 1],
 "average": 3.2,
 "min": 1, 
 "max": 6, 
 "median": 4 
}
```

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
│   ├── github_actions_role.tf
│   ├── iam.tf
│   ├── locals.tf
│   ├── logs.tf
│   ├── network.tf
│   ├── oidc.tf
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
└── nginx/
    └── nginx.conf

```

## Architektura systemu

Aplikacja składa się z trzech głównych komponentów: 

- frontend (Streamlit) – interfejs użytkownika  
- backend (FastAPI) – API obsługujące logikę biznesową  
- baza danych (PostgreSQL) – przechowywanie definicji kostek       

Środowisko uruchomieniowe obejmuje: 

- Docker i Docker Compose  
- instancja EC2 na AWS  

## Architektura pipeline CI/CD

```text
1. backend-test + frontend-test
            ↓
2. docker-build-and-push
            ↓
3. docker-scout
            ↓
4. smoke-test
            ↓
5. deploy
            ↓
6. tag-release
```

Pipeline CI/CD składa się z etapów:

### 1. Testy
- backend (pytest)
- frontend (syntax check)

### 2. Build & Push
- budowanie obrazów Docker
- push do Docker Hub
- tagowanie wersji: `v1.0.<run_number>`

### 3. Smoke test
- uruchomienie backendu lokalnie w CI
- test endpointu `/api/health`

### 4. Docker Scout
- quickview obrazu
- analiza CVE
- rekomendacje bezpieczeństwa

### 5. Deploy
- SSH na EC2
- sklonowanie repozytorium
- aktualizacja zmiennych środowiskowych z wersją
- uruchomienie docker compose

### 6. Release
- Git tag
- GitHub Release

## Architektura pipeline Infrastructure as Code (Terraform)

Pipeline Infrastructure as Code (Terraform) składa się z jednego kroku i konfiguruje następujące elementy chmury AWS:

- instancje EC2 instance
- Security Groups
- IAM Role
- Elastic IP
- CloudWatch Log Group oraz alarm

## Uruchomienie lokalne 

Uruchomienie lokalne wymaga narzędzi `docker` oraz `docker-compose`

`git clone https://github.com/kornelmk/dice-roller.git `
`cd dice-roller `
`docker compose up --build`

Aplikacja:
http://localhost/

Api aplikacji:
http://localhost/api/

## Demo projektu

Działająca wersja demonstracyjna projektu dostępna jest na AWS:

Aplikacja:
http://34.214.34.127/

Api aplikacji:
http://34.214.34.127/api/

