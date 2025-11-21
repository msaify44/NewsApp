# NewsApp

A lightweight NYTimes “Most Popular” reader built with SwiftUI, async/await, and a layered architecture for testability and configurability.


## Demo

[![Demo](https://img.youtube.com/vi/izYWCzL7VV0/maxresdefault.jpg)](https://youtube.com/shorts/izYWCzL7VV0?feature=share) 

## Module Hierarchy

```
NewsApp
 ├─ Core
 │   ├─ Configuration        // BuildConfiguration
 │   ├─ DependencyInjection  // DIContainer, assembly
 │   ├─ DesignSystem         // Typography, Spacing, assets
 │   └─ Service              // ServiceClient, Descriptor & API Configs
 └─ Features
     └─ Articles
        ├─ Data             // DTOs, Remote Datasource, Repository impl
        ├─ Domain           // Entities, Repository protocol, UseCases
        └─ Presentation     // SwiftUI Views, ViewModels, previews
 
```

## Architecture (MVVM + Clean Architecture with SwiftUI)

- **Data Layer**: Repository pattern (`DefaultArticleRepository`), remote datasource (`DefaultArticleRemoteDatasource`), and build-aware `APIConfigFactory`.
- **Domain Layer**: Core entities (`Article`, `Period`) and use cases (`DefaultFetchMostViewedArticlesUseCase`).
- **Presentation Layer**: SwiftUI views + `ArticlesListViewModel`, dependency injection via custom `DIContainer`, localized copy, reusable design tokens and preview helpers.
- **Core Infrastructure**: ServiceClient networking abstraction, configurable URL descriptors, and centralized DI assembly.

## CI/CD

- **GitHub Actions** runs the CI workflow.
  - Executes `fastlane build` on pull requests.
- **Fastlane** manages automation.
  - Define lanes in `fastlane/Fastfile` for build & tests.


## Tests & Coverage

- **Unit Tests** cover repositories, use cases, remote datasource, view model, and Service layer.

### Running Tests

```bash
fastlane test          # preferred
```