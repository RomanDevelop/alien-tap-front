# Гайд по архітектурі проекту Oschadbank

## Огляд

Цей проект використовує **MWWM (Model-Widget-WidgetModel)** архітектурний підхід від SurfStudio, який поєднує:

- **MVVM** паттерн
- **Clean Architecture** принципи
- Flutter best practices

## 1. Основний пакет: MWWM

### 1.1 Що таке MWWM?

**MWWM** - це легкий архітектурний фреймворк для Flutter додатків, що забезпечує:

- Повну розділеність коду на незалежні шари: UI, presentation та business logic
- Простий синтаксис - основна одиниця це розширена версія StatefulWidget
- Вбудовані механізми для асинхронних операцій
- Просту реалізацію стратегії обробки помилок
- Event-подібний механізм для структурованої бізнес-логіки

### 1.2 Ключові компоненти MWWM

#### Widget

- Декоративна частина UI
- Схожа на звичайний `StatefulWidget`
- Містить посилання на WidgetModel
- Представлена класом `CoreMwwmWidget`

#### WidgetModel

- Логічне представлення віджета та його стану
- Схожа на `State`, але має доступ до бізнес-логіки
- Відстежує стан віджета
- Виступає як диспетчер між UI подіями та бізнес-логікою
- Представлена класом `WidgetModel`

#### Model (опціонально)

- Допомагає спростити бізнес-логічний шар
- Розділяє абстракції на:
  - **Change** - намір зробити щось без деталей реалізації
  - **Performer** - реакція на Change з конкретною реалізацією операції
- Представлена класами `Model`, `Change`, `Performer`

## 2. Структура проекту

### 2.1 Основні директорії

```
lib/
├── app/                      # Конфігурація додатку
├── blocs/                    # BLoC компоненти (для глобального стану)
├── components/                # Переіспользуємі UI компоненти
├── data_management/          # Слой даних
│   ├── cache/               # Кешування
│   ├── models/              # Моделі даних
│   ├── providers/           # Data providers
│   └── repositories/        # Репозиторії
├── features/                # Фічі (feature-based структура)
├── interactors/             # Бізнес-логіка (use cases)
├── pages/                   # Екрани (legacy структура)
├── util/                    # Утиліти
└── view/                    # UI теми та компоненти
```

### 2.2 Структура Feature

Кожна feature організована наступним чином:

```
lib/features/<feature_name>/
├── components/              # Переіспользуємі компоненти для feature
├── data_providers/          # Data providers (mock або API)
├── dto/                     # Data Transfer Objects (DTO)
├── models/                  # Бізнес-моделі
├── pages/                   # Екрани feature
│   └── <page_name>/
│       ├── <page_name>_page.dart         # UI (Widget)
│       ├── <page_name>_wm.dart           # WidgetModel
│       ├── <page_name>_i18n.dart          # Інтернаціоналізація
│       ├── components/                    # Компоненти екрану
│       ├── di/                            # Dependency Injection
│       │   └── <page_name>_wm_builder.dart
│       └── navigation/                    # Навігація
│           └── <page_name>_navigator.dart
└── repositories/            # Репозиторії
    └── <feature_name>_repository.dart
```

## 3. Dependency Injection (DI)

### 3.1 Підхід до DI

Проект використовує **Manual Dependency Injection** через **Builder Pattern**:

- Кожен екран має свій `*_wm_builder.dart` файл
- Білдер створює всі залежності та передає їх у WidgetModel
- Немає глобального DI контейнера (окрім `GetIt` для деяких сервісів)

### 3.2 Структура WM Builder

```dart
// lib/features/additional_privileges/pages/additional_privileges/di/additional_privileges_wm_builder.dart

import 'package:flutter/material.dart';
import 'package:oschadbank/features/additional_privileges/pages/additional_privileges/additional_privileges_wm.dart';
import 'package:oschadbank/features/additional_privileges/pages/additional_privileges/additional_privileges_i18n.dart';
import 'package:oschadbank/features/additional_privileges/pages/additional_privileges/navigation/additional_privileges_navigator.dart';
import 'package:oschadbank/features/additional_privileges/repositories/additional_privileges_repository.dart';
import 'package:oschadbank/features/additional_privileges/data_providers/mock_additional_privileges_data_provider.dart';

// Білдер створює всі залежності та повертає WidgetModel
AdditionalPrivilegesWidgetModel createAdditionalPrivilegesWidgetModel(
  BuildContext context,
  {PrivilegeCategoryType? initialTab}
) {
  // 1. Створюємо Data Provider (mock або реальний API)
  final dataProvider = MockAdditionalPrivilegesDataProvider();

  // 2. Створюємо Repository з Data Provider
  final repository = AdditionalPrivilegesRepository(dataProvider: dataProvider);

  // 3. Створюємо Navigator з контекстом та repository
  final navigator = AdditionalPrivilegesNavigator(context, repository);

  // 4. Створюємо I18n для локалізації
  final i18n = AdditionalPrivilegesI18n();

  // 5. Створюємо та повертаємо WidgetModel з усіма залежностями
  return AdditionalPrivilegesWidgetModel(
    repository,
    navigator,
    i18n,
    initialTab: initialTab
  );
}
```

### 3.3 Використання в Page

```dart
// lib/features/additional_privileges/pages/additional_privileges/additional_privileges_page.dart

import 'package:mwwm/mwwm.dart';
import 'package:oschadbank/features/additional_privileges/pages/additional_privileges/di/additional_privileges_wm_builder.dart';

class AdditionalPrivilegesPage extends CoreMwwmWidget {
  final PrivilegeCategoryType? initialTab;

  AdditionalPrivilegesPage({super.key, this.initialTab})
      : super(
          widgetModelBuilder: (context) => createAdditionalPrivilegesWidgetModel(
            context,
            initialTab: initialTab
          )
        );

  @override
  State<StatefulWidget> createState() {
    return _AdditionalPrivilegesPageState();
  }
}

class _AdditionalPrivilegesPageState
    extends MwwmWidgetState<AdditionalPrivilegesWidgetModel> {
  @override
  Widget build(BuildContext context) {
    // Доступ до WidgetModel через wm
    return BasePage(
      appBar: _AppBar(title: wm.i18n.pageTitle),
      body: _Body(wm: wm),
    );
  }
}
```

## 4. Шари архітектури

### 4.1 Data Layer (Шар даних)

#### Data Provider

- Відповідає за отримання даних (API, Mock, Cache)
- Повертає DTO об'єкти
- Може бути mock для розробки або реальний API

```dart
// lib/features/additional_privileges/data_providers/mock_additional_privileges_data_provider.dart

class MockAdditionalPrivilegesDataProvider {
  Future<List<AdditionalPrivilegeDto>> getPrivileges() async {
    // Симулюємо затримку мережі
    await Future.delayed(const Duration(milliseconds: 500));

    // Повертаємо mock дані у вигляді DTO
    return [
      const AdditionalPrivilegeDto(
        id: 'mastercard_bonus',
        title: 'Mastercard Більше',
        // ...
      ),
    ];
  }
}
```

#### DTO (Data Transfer Object)

- Простий об'єкт для передачі даних
- Може мати `fromJson` та `toJson` методи
- Не містить бізнес-логіки

```dart
// lib/features/additional_privileges/dto/additional_privileges_dto.dart

class AdditionalPrivilegeDto {
  final String id;
  final String title;
  final String description;
  // ...

  const AdditionalPrivilegeDto({
    required this.id,
    required this.title,
    // ...
  });

  factory AdditionalPrivilegeDto.fromJson(Map<String, dynamic> json) {
    return AdditionalPrivilegeDto(
      id: json['id'] as String,
      title: json['title'] as String,
      // ...
    );
  }
}
```

#### Repository

- Абстракція над Data Provider
- Конвертує DTO в бізнес-моделі
- Може кешувати дані
- Ізолює бізнес-логіку від деталей отримання даних

```dart
// lib/features/additional_privileges/repositories/additional_privileges_repository.dart

class AdditionalPrivilegesRepository {
  final MockAdditionalPrivilegesDataProvider _dataProvider;

  AdditionalPrivilegesRepository({
    required MockAdditionalPrivilegesDataProvider dataProvider,
  }) : _dataProvider = dataProvider;

  Future<List<AdditionalPrivilegeDto>> getPrivileges() async {
    return await _dataProvider.getPrivileges();
  }

  Future<PromotionDetail> getPromotionDetail(String id) async {
    final dto = await _dataProvider.getPromotionDetail(id);
    return PromotionDetail.fromDto(dto); // Конвертація DTO -> Model
  }
}
```

### 4.2 Business Layer (Шар бізнес-логіки)

#### Model

- Бізнес-модель з логікою
- Конвертується з DTO через factory метод `fromDto`
- Може містити обчислювані властивості та методи

```dart
// lib/features/additional_privileges/models/additional_privileges_model.dart

class AdditionalPrivilege {
  final String id;
  final String title;
  // ...

  const AdditionalPrivilege({
    required this.id,
    required this.title,
    // ...
  });

  // Factory для конвертації з DTO
  factory AdditionalPrivilege.fromDto(AdditionalPrivilegeDto dto) {
    return AdditionalPrivilege(
      id: dto.id,
      title: dto.title,
      // ...
    );
  }

  // Обчислювані властивості
  PrivilegeContent get displayContent {
    if (isModular && modularContent != null) {
      return modularContent!;
    }
    // Логіка для створення простого контенту
    return PrivilegeBuilder.createSimplePrivilege(...);
  }
}
```

#### Interactor (Use Case)

- Інкапсулює специфічну бізнес-логіку
- Виконує одну конкретну задачу
- Використовується для складних операцій

```dart
// lib/interactors/analytics/analytics_interactor.dart

class AnalyticsInteractor {
  final AnalyticsEngine _engine;

  void trackEvent(String eventName, Map<String, dynamic> properties) {
    _engine.track(eventName, properties);
  }
}
```

### 4.3 Presentation Layer (Шар презентації)

#### WidgetModel

- Містить стан та логіку презентації
- Використовує `BehaviorSubject` або `StreamController` для реактивного стану
- Обробляє події з UI та викликає методи Repository
- Наслідує `WidgetModel` з MWWM

```dart
// lib/features/additional_privileges/pages/additional_privileges/additional_privileges_wm.dart

import 'package:mwwm/mwwm.dart';
import 'package:rxdart/rxdart.dart';

class AdditionalPrivilegesWidgetModel extends WidgetModel {
  final AdditionalPrivilegesRepository _repository;
  final AdditionalPrivilegesNavigator _navigator;
  final AdditionalPrivilegesI18n i18n;

  // Реактивні потоки для стану
  final BehaviorSubject<List<AdditionalPrivilege>> privilegesStream =
      BehaviorSubject.seeded([]);
  final BehaviorSubject<bool> isLoadingStream =
      BehaviorSubject.seeded(false);

  AdditionalPrivilegesWidgetModel(
    this._repository,
    this._navigator,
    this.i18n,
  ) : super(const WidgetModelDependencies());

  @override
  void onLoad() {
    super.onLoad();
    _loadData();
  }

  void _loadData() {
    isLoadingStream.add(true);

    _repository.getPrivileges()
      .then((privileges) {
        privilegesStream.add(privileges);
        isLoadingStream.add(false);
      })
      .catchError((error) {
        isLoadingStream.add(false);
        // Обробка помилок
      });
  }

  void onPrivilegeTap(AdditionalPrivilege privilege) {
    _navigator.goToPrivilegeDetail(privilege.id);
  }

  @override
  void dispose() {
    privilegesStream.close();
    isLoadingStream.close();
    super.dispose();
  }
}
```

#### Widget (UI)

- Відповідає лише за відображення UI
- Наслідує `CoreMwwmWidget`
- Використовує `StreamBuilder` для реактивного оновлення UI

```dart
// lib/features/additional_privileges/pages/additional_privileges/additional_privileges_page.dart

class AdditionalPrivilegesPage extends CoreMwwmWidget {
  AdditionalPrivilegesPage({super.key})
      : super(
          widgetModelBuilder: (context) =>
            createAdditionalPrivilegesWidgetModel(context)
        );

  @override
  State<StatefulWidget> createState() => _AdditionalPrivilegesPageState();
}

class _AdditionalPrivilegesPageState
    extends MwwmWidgetState<AdditionalPrivilegesWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: _AppBar(title: wm.i18n.pageTitle),
      body: StreamBuilder<List<AdditionalPrivilege>>(
        stream: wm.privilegesStream,
        initialData: wm.privilegesStream.value,
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('Немає даних'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final privilege = snapshot.data![index];
              return PrivilegeCard(
                privilege: privilege,
                onTap: () => wm.onPrivilegeTap(privilege),
              );
            },
          );
        },
      ),
    );
  }
}
```

## 5. Навігація

### 5.1 Navigator Pattern

Кожна feature має свій Navigator, який інкапсулює всю навігацію:

```dart
// lib/features/additional_privileges/pages/additional_privileges/navigation/additional_privileges_navigator.dart

import 'package:flutter/material.dart';

class AdditionalPrivilegesNavigator {
  final NavigatorState _navigator;
  final AdditionalPrivilegesRepository _repository;

  AdditionalPrivilegesNavigator(
    BuildContext context,
    AdditionalPrivilegesRepository repository,
  ) : _navigator = Navigator.of(context),
      _repository = repository;

  void goBack() {
    _navigator.pop();
  }

  void goToAdditionalPrivileges({PrivilegeCategoryType? initialTab}) {
    _navigator.push(
      MaterialPageRoute(
        builder: (context) => AdditionalPrivilegesPage(initialTab: initialTab),
      ),
    );
  }

  void goToPromotionDetail(PromotionDetail promotionDetail) {
    _navigator.push(
      MaterialPageRoute(
        builder: (context) => PromotionDetailPage(
          promotionDetail: promotionDetail,
          repository: _repository,
          navigator: AdditionalPrivilegesNavigator(context, _repository),
        ),
      ),
    );
  }
}
```

## 6. Обробка помилок

### 6.1 Error Handler Mixin

Використовується `ShowToastOnDataErrorMixin` для відображення помилок:

```dart
// lib/util/show_toast_on_data_error_mixin.dart

mixin ShowToastOnDataErrorMixin {
  Stream<ToastErrorType> get errorStream => _errorStreamController.stream;
  final _errorStreamController = StreamController<ToastErrorType>.broadcast();

  void showToastOnDataError(DataError error) {
    // Логіка обробки помилок
    final toastType = _getToastTypeByError(error);
    _errorStreamController.addIfNotClosed(toastType);
  }
}
```

### 6.2 Використання в WidgetModel

```dart
class AdditionalPrivilegesWidgetModel extends WidgetModel
    with ShowToastOnDataErrorMixin {

  void _loadData() {
    _repository.getPrivileges()
      .catchError((error) {
        showToastOnDataError(
          DataError(
            errorCode: ErrorCode.unhandled_error,
            message: error.toString()
          )
        );
      });
  }
}
```

## 7. Інтернаціоналізація (I18n)

Кожна feature має свій клас I18n:

```dart
// lib/features/additional_privileges/pages/additional_privileges/additional_privileges_i18n.dart

class AdditionalPrivilegesI18n {
  String get pageTitle => 'Додаткові привілеї';
  String get proposalsButtonTitle => 'Пропозиції';
  String get promotionsButtonTitle => 'Акції';
  String get loadMoreButton => 'Завантажити ще';
  String get retryButton => 'Спробувати знову';
  String get errorMessage => 'Помилка завантаження';
}
```

Використання:

```dart
// В WidgetModel
final i18n = AdditionalPrivilegesI18n();

// В UI
Text(wm.i18n.pageTitle)
```

## 8. State Management

### 8.1 RxDart для реактивності

Проект використовує **RxDart** для реактивного програмування:

```dart
import 'package:rxdart/rxdart.dart';

class AdditionalPrivilegesWidgetModel extends WidgetModel {
  // BehaviorSubject - зберігає останнє значення та емітить його новим підписникам
  final BehaviorSubject<List<AdditionalPrivilege>> privilegesStream =
      BehaviorSubject.seeded([]);

  final BehaviorSubject<bool> isLoadingStream =
      BehaviorSubject.seeded(false);

  // Оновлення значення
  void _loadData() {
    isLoadingStream.add(true);
    // ...
    privilegesStream.add(newPrivileges);
    isLoadingStream.add(false);
  }

  // Закриття потоків при dispose
  @override
  void dispose() {
    privilegesStream.close();
    isLoadingStream.close();
    super.dispose();
  }
}
```

### 8.2 Використання в UI

```dart
StreamBuilder<List<AdditionalPrivilege>>(
  stream: wm.privilegesStream,
  initialData: wm.privilegesStream.value, // Початкове значення
  builder: (context, snapshot) {
    final privileges = snapshot.data ?? [];
    return ListView.builder(
      itemCount: privileges.length,
      itemBuilder: (context, index) {
        return PrivilegeCard(privilege: privileges[index]);
      },
    );
  },
)
```

## 9. Глобальний State (Provider/GetIt)

### 9.1 Provider для глобального стану

Для глобального стану (теми, локалізація, тощо) використовується **Provider**:

```dart
// main.dart

MultiProvider(
  providers: [
    Provider<DataManager>(...),
    Provider<ThemeProvider>(...),
    // ...
  ],
  child: MyApp(),
)

// Використання
final theme = context.watch<ThemeProvider>().appTheme;
```

### 9.2 GetIt для сервісів

Для сервісів використовується **GetIt**:

```dart
// lib/data_management/service_locator.dart

final locator = GetIt.instance;

Future<void> init(DeviceType deviceType) async {
  locator.registerLazySingleton<CrashAnalyticsService>(
    () => FirebaseCrashlyticsService()
  );
}

// Використання
final analytics = locator.get<CrashAnalyticsService>();
```

## 10. Створення нової Feature

### Крок 1: Структура директорій

```
lib/features/my_feature/
├── components/
├── data_providers/
│   └── my_feature_data_provider.dart
├── dto/
│   └── my_feature_dto.dart
├── models/
│   └── my_feature_model.dart
├── pages/
│   └── my_feature_page/
│       ├── my_feature_page.dart
│       ├── my_feature_wm.dart
│       ├── my_feature_i18n.dart
│       ├── components/
│       ├── di/
│       │   └── my_feature_wm_builder.dart
│       └── navigation/
│           └── my_feature_navigator.dart
└── repositories/
    └── my_feature_repository.dart
```

### Крок 2: Створення DTO

```dart
// dto/my_feature_dto.dart

class MyFeatureDto {
  final String id;
  final String title;
  // ...

  const MyFeatureDto({
    required this.id,
    required this.title,
  });

  factory MyFeatureDto.fromJson(Map<String, dynamic> json) {
    return MyFeatureDto(
      id: json['id'] as String,
      title: json['title'] as String,
    );
  }
}
```

### Крок 3: Створення Data Provider

```dart
// data_providers/my_feature_data_provider.dart

class MyFeatureDataProvider {
  Future<List<MyFeatureDto>> getData() async {
    // API або Mock логіка
    return [];
  }
}
```

### Крок 4: Створення Model

```dart
// models/my_feature_model.dart

class MyFeature {
  final String id;
  final String title;
  // ...

  const MyFeature({
    required this.id,
    required this.title,
  });

  factory MyFeature.fromDto(MyFeatureDto dto) {
    return MyFeature(
      id: dto.id,
      title: dto.title,
    );
  }
}
```

### Крок 5: Створення Repository

```dart
// repositories/my_feature_repository.dart

class MyFeatureRepository {
  final MyFeatureDataProvider _dataProvider;

  MyFeatureRepository({required MyFeatureDataProvider dataProvider})
      : _dataProvider = dataProvider;

  Future<List<MyFeature>> getData() async {
    final dtos = await _dataProvider.getData();
    return dtos.map((dto) => MyFeature.fromDto(dto)).toList();
  }
}
```

### Крок 6: Створення I18n

```dart
// pages/my_feature_page/my_feature_i18n.dart

class MyFeatureI18n {
  String get pageTitle => 'Моя Фіча';
  String get errorMessage => 'Помилка';
}
```

### Крок 7: Створення Navigator

```dart
// pages/my_feature_page/navigation/my_feature_navigator.dart

class MyFeatureNavigator {
  final NavigatorState _navigator;
  final MyFeatureRepository _repository;

  MyFeatureNavigator(BuildContext context, MyFeatureRepository repository)
      : _navigator = Navigator.of(context),
        _repository = repository;

  void goBack() {
    _navigator.pop();
  }
}
```

### Крок 8: Створення WidgetModel

```dart
// pages/my_feature_page/my_feature_wm.dart

import 'package:mwwm/mwwm.dart';
import 'package:rxdart/rxdart.dart';

class MyFeatureWidgetModel extends WidgetModel {
  final MyFeatureRepository _repository;
  final MyFeatureNavigator _navigator;
  final MyFeatureI18n i18n;

  final BehaviorSubject<List<MyFeature>> dataStream =
      BehaviorSubject.seeded([]);
  final BehaviorSubject<bool> isLoadingStream =
      BehaviorSubject.seeded(false);

  MyFeatureWidgetModel(
    this._repository,
    this._navigator,
    this.i18n,
  ) : super(const WidgetModelDependencies());

  @override
  void onLoad() {
    super.onLoad();
    _loadData();
  }

  void _loadData() {
    isLoadingStream.add(true);
    _repository.getData()
      .then((data) {
        dataStream.add(data);
        isLoadingStream.add(false);
      })
      .catchError((error) {
        isLoadingStream.add(false);
        // Обробка помилок
      });
  }

  @override
  void dispose() {
    dataStream.close();
    isLoadingStream.close();
    super.dispose();
  }
}
```

### Крок 9: Створення WM Builder

```dart
// pages/my_feature_page/di/my_feature_wm_builder.dart

import 'package:flutter/material.dart';
import 'package:oschadbank/features/my_feature/pages/my_feature_page/my_feature_wm.dart';
import 'package:oschadbank/features/my_feature/pages/my_feature_page/my_feature_i18n.dart';
import 'package:oschadbank/features/my_feature/pages/my_feature_page/navigation/my_feature_navigator.dart';
import 'package:oschadbank/features/my_feature/repositories/my_feature_repository.dart';
import 'package:oschadbank/features/my_feature/data_providers/my_feature_data_provider.dart';

MyFeatureWidgetModel createMyFeatureWidgetModel(BuildContext context) {
  final dataProvider = MyFeatureDataProvider();
  final repository = MyFeatureRepository(dataProvider: dataProvider);
  final navigator = MyFeatureNavigator(context, repository);
  final i18n = MyFeatureI18n();

  return MyFeatureWidgetModel(repository, navigator, i18n);
}
```

### Крок 10: Створення Page

```dart
// pages/my_feature_page/my_feature_page.dart

import 'package:mwwm/mwwm.dart';
import 'package:oschadbank/components/common/base_page.dart';
import 'package:oschadbank/features/my_feature/pages/my_feature_page/my_feature_wm.dart';
import 'package:oschadbank/features/my_feature/pages/my_feature_page/di/my_feature_wm_builder.dart';

class MyFeaturePage extends CoreMwwmWidget {
  MyFeaturePage({super.key})
      : super(
          widgetModelBuilder: (context) => createMyFeatureWidgetModel(context)
        );

  @override
  State<StatefulWidget> createState() => _MyFeaturePageState();
}

class _MyFeaturePageState extends MwwmWidgetState<MyFeatureWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: AppBar(title: Text(wm.i18n.pageTitle)),
      body: StreamBuilder<List<MyFeature>>(
        stream: wm.dataStream,
        initialData: wm.dataStream.value,
        builder: (context, snapshot) {
          final data = snapshot.data ?? [];
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text(data[index].title));
            },
          );
        },
      ),
    );
  }
}
```

## 11. Best Practices

### 11.1 Розділення відповідальності

- **Widget** - тільки UI, без бізнес-логіки
- **WidgetModel** - стан та логіка презентації
- **Repository** - абстракція над даними
- **Data Provider** - отримання даних
- **Model** - бізнес-логіка та дані

### 11.2 Іменування

- **DTO**: `*Dto` (наприклад, `AdditionalPrivilegeDto`)
- **Model**: без суфікса (наприклад, `AdditionalPrivilege`)
- **Repository**: `*Repository` (наприклад, `AdditionalPrivilegesRepository`)
- **Data Provider**: `*DataProvider` (наприклад, `MockAdditionalPrivilegesDataProvider`)
- **WidgetModel**: `*WidgetModel` (наприклад, `AdditionalPrivilegesWidgetModel`)
- **Page**: `*Page` (наприклад, `AdditionalPrivilegesPage`)
- **Navigator**: `*Navigator` (наприклад, `AdditionalPrivilegesNavigator`)
- **I18n**: `*I18n` (наприклад, `AdditionalPrivilegesI18n`)
- **Builder**: `create*WidgetModel` (наприклад, `createAdditionalPrivilegesWidgetModel`)

### 11.3 Реактивність

- Використовуйте `BehaviorSubject` для стану з початковим значенням
- Використовуйте `StreamController` для подій без початкового значення
- Завжди закривайте потоки в `dispose()`

### 11.4 Обробка помилок

- Використовуйте `ShowToastOnDataErrorMixin` для відображення помилок
- Логуйте помилки через `Logger`
- Перетворюйте винятки на `DataError`

### 11.5 Тестування

- Тестуйте WidgetModel окремо від Widget
- Mock Repository та Data Provider
- Тестуйте логіку конвертації DTO -> Model

## 12. Ключові бібліотеки

### Архітектурні

- **mwwm** - основний архітектурний фреймворк
- **rxdart** - реактивне програмування
- **provider** - dependency injection для глобального стану
- **get_it** - service locator

### UI

- **flutter_screenutil** - responsive sizing
- **provider** - state management
- **flutter_svg** - SVG іконки

### Networking

- **dio** - HTTP клієнт
- **get_storage** - локальне сховище

### Інші

- **surf_logger** - логування
- **equatable** - порівняння об'єктів

## 13. Приклади реальної feature

Дивіться на feature `additional_privileges` як референс:

```
lib/features/additional_privileges/
```

Ця feature демонструє:

- Повну структуру feature
- Використання MWWM
- DI через builder
- Навігацію
- Обробку помилок
- Інтернаціоналізацію

## Висновок

Ця архітектура забезпечує:

- **Чітке розділення відповідальності**
- **Легке тестування**
- **Масштабованість**
- **Підтримуваність**
- **Розділену розробку** (UI та бізнес-логіка окремо)

Використовуйте цей гайд як референс для створення нових feature в проекті!
