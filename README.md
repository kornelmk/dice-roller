# dice-roller
Aplikacja symulująca rzucenie kościami do gry

## Strukutra katalogów

```text
dice-roller/
│
├── docker-compose.yml
|
├── database/
│   └── init.sql
│
├── backend/
│   ├── Dockerfile
│   ├── requirements.txt
│   └── app/
│       ├── main.py
│       ├── database.py
│       └── models.py
│
├── frontend/
    ├── Dockerfile
    ├── requirements.txt
    └── app.py
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