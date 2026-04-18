# Features - Clean Architecture Structure

This directory contains feature modules following Clean Architecture principles.

## Folder Structure

Each feature follows a three-layer structure:

```
lib/features/[feature_name]/
├── data/                    # Data Layer
│   ├── datasources/         # Data sources (local/remote)
│   ├── models/             # Data models (DTOs)
│   └── repositories/       # Repository implementations
├── domain/                 # Domain Layer
│   ├── entities/           # Business entities
│   ├── repositories/       # Repository interfaces (abstractions)
│   └── usecases/          # Business use cases
└── presentation/          # Presentation Layer
    ├── pages/             # Screen widgets
    ├── widgets/            # Reusable widgets
    └── cubits/            # State management
```

## Layer Dependencies

- Presentation → Domain (depends on interfaces)
- Domain → Data (no dependencies - pure business logic)
- Data → Infrastructure (implements domain interfaces)

## Rules

1. Data layer must NOT import Domain entities 
2. Use cases contain pure business logic
3. Repositories are defined in Domain, implemented in Data
4. Cubits manage presentation state only