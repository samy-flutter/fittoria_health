# Fittoria — Flutter Patient App
## Project Blueprint & Architecture Guide

> **Source Project:** `fittoria-crm` (Next.js 16 / MySQL)
> **Mobile Scope:** Patient App ONLY — Staff CRM is web-only
> **Created:** 2026-06-01
> **Architecture:** MVVM (Flutter Official Guide)
> **State Management:** BLoC
> **Networking:** Dio + QueuedInterceptor + Token Refresh

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Architecture — MVVM](#2-architecture--mvvm)
3. [Tech Stack & Libraries](#3-tech-stack--libraries)
4. [Folder Structure](#4-folder-structure)
5. [Layer-by-Layer Explanation](#5-layer-by-layer-explanation)
6. [Networking — Dio Setup](#6-networking--dio-setup)
7. [Auth Flow & Token Refresh](#7-auth-flow--token-refresh)
8. [Storage Strategy](#8-storage-strategy)
9. [Navigation — GoRouter](#9-navigation--gorouter)
10. [BLoC Pattern — How to Write Every Feature](#10-bloc-pattern--how-to-write-every-feature)
11. [Patient App — Feature Scope](#11-patient-app--feature-scope)
12. [Implementation Phases](#12-implementation-phases)
13. [Naming Conventions](#13-naming-conventions)
14. [Code Generation](#14-code-generation)
15. [Environment Config](#15-environment-config)

---

## 1. Project Overview

Fittoria is a **multi-role health & fitness CRM** that runs as a Next.js web app at `fittoria-crm/`. This Flutter project is the **mobile client for patients only**.

### What the Patient App Does

| Module | Description |
|---|---|
| Auth | Phone/email login, TOTP MFA, token rotation |
| Home | Dashboard summary — appointments, body stats, quick actions |
| Appointments | Book, view, cancel clinic appointments |
| Gym Card | Digital membership card with QR code for gym check-in |
| Lab | Book lab tests, view reports, view referrals |
| Prescriptions | View & download prescriptions (PDF) |
| Records | Medical history, discharge summaries |
| Body Progress | Log & track weight, BMI, body fat % — line charts |
| Nutrition | Assigned meal plans, meal tracking, AI nutrition |
| Shop | Browse products, add to cart, checkout, track orders |
| Profile | Edit profile, manage addresses |
| Community | Clubs, events, social feed |
| Notifications | Appointment reminders, push notifications (FCM) |

### Backend API Base

```
Auth:      POST /api/v2/auth/mobile/login
           POST /api/v2/auth/mobile/refresh
           POST /api/v2/auth/mobile/logout

Patient:   /api/patient/*        (profile, appointments, gym, lab, etc.)
Shared:    /api/v2/*             (compliance, consent, FHIR, uploads)
```

> **Note:** The Next.js route groups `(patient-app)` and `(staff-crm)` are **invisible in the URL**.
> The actual endpoints are `/api/patient/appointments`, `/api/patient/gym`, etc.

---

## 2. Architecture — MVVM

Flutter's official architecture guide recommends MVVM with two layers:

```
┌─────────────────────────────────────────────────┐
│                  UI LAYER                       │
│                                                 │
│   View (Widget)  ◄────────►  ViewModel (BLoC)  │
│   - Renders UI               - Manages state   │
│   - Fires events             - Business logic  │
│   - Dumb / no logic          - Calls repo      │
└────────────────────────┬────────────────────────┘
                         │
                    calls │ repository
                         │
┌────────────────────────▼────────────────────────┐
│                 DATA LAYER                      │
│                                                 │
│   Repository  ◄──────────►  Services           │
│   - Source of truth          - Dio API calls   │
│   - Error handling           - SecureStorage   │
│   - Token save/clear         - SharedPrefs     │
└─────────────────────────────────────────────────┘
```

### MVVM Role Mapping

| MVVM Role | Flutter Implementation | Responsibility |
|---|---|---|
| **View** | `*_screen.dart` / `*_widget.dart` | Display state, send events to BLoC |
| **ViewModel** | `*_bloc.dart` | Handle events, emit states, call Repository |
| **Model** | `*_repository.dart` | Fetch/save data, error handling |
| **Service** | `*_service.dart` / `dio_client.dart` | Raw HTTP calls, raw storage ops |

### Data Flow — One-Way

```
User Action
    │
    ▼
View dispatches Event ──► BLoC receives Event
                               │
                               ▼ calls
                          Repository
                               │
                               ▼ calls
                           Service (Dio / Storage)
                               │
                               ▼ returns data or throws
                          Repository wraps result
                               │
                               ▼ returns entity or Failure
                          BLoC emits State
                               │
                               ▼
                          View rebuilds via BlocBuilder
```

---

## 3. Tech Stack & Libraries

### Reference Links
- [Flutter Official Architecture Guide](https://docs.flutter.dev/app-architecture/guide)
- [BLoC Library Official Docs](https://bloclibrary.dev)
- [dartz — Either/Failure](https://pub.dev/packages/dartz)
- [Dio Package](https://pub.dev/packages/dio)
- [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)
- [go_router](https://pub.dev/packages/go_router)
- [get_it](https://pub.dev/packages/get_it)
- [freezed](https://pub.dev/packages/freezed)

### `pubspec.yaml` Dependencies

```yaml
name: fittoria_patient
description: Fittoria Patient Mobile App
version: 1.0.0+1

environment:
  sdk: ">=3.3.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_bloc: ^8.1.6
  equatable: ^2.0.7

  # Error Handling — functional Either
  dartz: ^0.10.1

  # Networking
  dio: ^5.7.0
  dio_smart_retry: ^6.0.0

  # Storage
  flutter_secure_storage: ^9.2.4
  shared_preferences: ^2.3.5

  # Navigation
  go_router: ^14.8.0

  # Dependency Injection
  get_it: ^8.0.3
  injectable: ^2.5.0

  # Models / Serialization
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0

  # Environment
  flutter_dotenv: ^5.2.1

  # UI / Images
  cached_network_image: ^3.4.1
  google_fonts: ^6.2.1
  shimmer: ^3.0.0
  lottie: ^3.3.1

  # Charts
  fl_chart: ^0.70.2

  # QR Code
  qr_flutter: ^4.1.0

  # File / PDF
  open_filex: ^4.7.0

  # Camera / Upload
  image_picker: ^1.1.2
  permission_handler: ^11.3.1

  # Utilities
  intl: ^0.20.2
  connectivity_plus: ^6.1.1

  # Notifications
  firebase_core: ^3.13.0
  firebase_messaging: ^15.2.4
  flutter_local_notifications: ^17.2.4

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0

  # Code Generation
  build_runner: ^2.4.14
  freezed: ^2.5.8
  json_serializable: ^6.9.5
  injectable_generator: ^2.7.0
```

---

## 4. Folder Structure

```
fittoria_patient/
├── .env.dev                           # Development environment variables
├── .env.prod                          # Production environment variables
├── pubspec.yaml
│
└── lib/
    │
    ├── main.dart                      # App entry point, DI init, BlocObserver
    │
    ├── core/                          # App-wide infrastructure (no business logic)
    │   │
    │   ├── constants/
    │   │   ├── api_constants.dart     # Base URL + all endpoint strings
    │   │   └── storage_keys.dart     # ALL storage key name constants
    │   │
    │   ├── network/
    │   │   ├── dio_client.dart        # Dio instance builder + interceptor wiring
    │   │   ├── auth_interceptor.dart  # QueuedInterceptor: attach token, 401 refresh
    │   │   └── retry_interceptor.dart # dio_smart_retry config
    │   │
    │   ├── error/
    │   │   └── failures.dart          # Failure sealed class: NetworkFailure, AuthFailure,
    │   │                              # ServerFailure, ParseFailure, CacheFailure, UnknownFailure
    │   │
    │   ├── storage/
    │   │   ├── secure_storage_service.dart   # flutter_secure_storage wrapper
    │   │   └── preferences_service.dart      # shared_preferences wrapper
    │   │
    │   ├── router/
    │   │   ├── app_router.dart        # GoRouter config with auth guard
    │   │   └── route_names.dart       # All route path constants
    │   │
    │   ├── theme/
    │   │   ├── app_theme.dart         # ThemeData (light + dark)
    │   │   ├── app_colors.dart        # Color palette
    │   │   └── app_text_styles.dart   # TextStyle tokens
    │   │
    │   ├── di/
    │   │   └── injection.dart         # GetIt setup + @InjectableInit
    │   │
    │   └── utils/
    │       ├── validators.dart        # Form validators (phone, email, password)
    │       ├── date_formatter.dart    # intl date/time formatting helpers
    │       └── extensions.dart        # Dart extension methods
    │
    ├── features/                      # One folder per feature (patient-facing)
    │   │
    │   ├── auth/
    │   │   ├── data/
    │   │   │   ├── models/
    │   │   │   │   ├── login_request_model.dart       # @JsonSerializable, @freezed
    │   │   │   │   ├── auth_response_model.dart
    │   │   │   │   └── token_model.dart
    │   │   │   ├── services/
    │   │   │   │   └── auth_service.dart              # Raw Dio calls only
    │   │   │   └── repositories/
    │   │   │       └── auth_repository.dart           # Implements IAuthRepository
    │   │   ├── domain/
    │   │   │   ├── contracts/
    │   │   │   │   └── i_auth_repository.dart         # Abstract interface
    │   │   │   └── entities/
    │   │   │       └── auth_user.dart                 # Pure Dart (no JSON annotations)
    │   │   └── presentation/
    │   │       ├── bloc/
    │   │       │   ├── auth_bloc.dart                 # ViewModel
    │   │       │   ├── auth_event.dart
    │   │       │   └── auth_state.dart
    │   │       └── screens/
    │   │           ├── login_screen.dart              # View
    │   │           └── mfa_screen.dart
    │   │
    │   ├── home/                      # Dashboard
    │   │   ├── data/
    │   │   │   ├── models/
    │   │   │   ├── services/
    │   │   │   └── repositories/
    │   │   ├── domain/
    │   │   │   ├── contracts/
    │   │   │   └── entities/
    │   │   └── presentation/
    │   │       ├── bloc/
    │   │       └── screens/
    │   │           └── home_screen.dart
    │   │
    │   ├── appointments/
    │   │   ├── data/
    │   │   │   ├── models/
    │   │   │   │   └── appointment_model.dart
    │   │   │   ├── services/
    │   │   │   │   └── appointment_service.dart
    │   │   │   └── repositories/
    │   │   │       └── appointment_repository.dart
    │   │   ├── domain/
    │   │   │   ├── contracts/
    │   │   │   │   └── i_appointment_repository.dart
    │   │   │   └── entities/
    │   │   │       └── appointment.dart
    │   │   └── presentation/
    │   │       ├── bloc/
    │   │       │   ├── appointment_bloc.dart
    │   │       │   ├── appointment_event.dart
    │   │       │   └── appointment_state.dart
    │   │       └── screens/
    │   │           ├── appointments_screen.dart
    │   │           └── book_appointment_screen.dart
    │   │
    │   ├── gym_card/                  # Membership card + QR
    │   │   ├── data/
    │   │   ├── domain/
    │   │   └── presentation/
    │   │
    │   ├── lab/                       # Lab booking + reports
    │   │   ├── data/
    │   │   ├── domain/
    │   │   └── presentation/
    │   │
    │   ├── prescriptions/
    │   │   ├── data/
    │   │   ├── domain/
    │   │   └── presentation/
    │   │
    │   ├── records/                   # Medical records
    │   │   ├── data/
    │   │   ├── domain/
    │   │   └── presentation/
    │   │
    │   ├── body_progress/             # Weight/metrics + charts
    │   │   ├── data/
    │   │   ├── domain/
    │   │   └── presentation/
    │   │
    │   ├── nutrition/                 # Meal plans + AI nutrition
    │   │   ├── data/
    │   │   ├── domain/
    │   │   └── presentation/
    │   │
    │   ├── shop/                      # Products, cart, orders
    │   │   ├── data/
    │   │   ├── domain/
    │   │   └── presentation/
    │   │
    │   ├── profile/
    │   │   ├── data/
    │   │   ├── domain/
    │   │   └── presentation/
    │   │
    │   └── community/                 # Clubs, events, social
    │       ├── data/
    │       ├── domain/
    │       └── presentation/
    │
    └── shared/                        # Reusable widgets & shared BLoCs
        ├── widgets/
        │   ├── app_button.dart
        │   ├── app_text_field.dart
        │   ├── app_loading_indicator.dart
        │   ├── app_error_widget.dart
        │   ├── stat_card.dart
        │   ├── info_chip.dart
        │   └── shimmer_loader.dart
        └── blocs/
            └── connectivity_cubit.dart
```

---

## 5. Layer-by-Layer Explanation

### 5.1 View (`presentation/screens/`)

- Uses `BlocBuilder`, `BlocListener`, or `BlocConsumer`
- **Zero business logic** — only rendering and user event dispatch
- Accesses BLoC via `context.read<XBloc>()` or provided through `BlocProvider`

```dart
// features/auth/presentation/screens/login_screen.dart

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) context.go(RouteNames.home);
        if (state is AuthError) _showSnackbar(context, state.message);
      },
      builder: (context, state) {
        return Scaffold(
          body: LoginForm(
            isLoading: state is AuthLoading,
            onSubmit: (phone, password) {
              context.read<AuthBloc>().add(LoginSubmitted(phone, password));
            },
          ),
        );
      },
    );
  }
}
```

### 5.2 ViewModel — BLoC (`presentation/bloc/`)

Each feature has exactly **3 files**:

| File | Purpose |
|---|---|
| `*_event.dart` | All user/system events — sealed class |
| `*_state.dart` | All UI states — sealed class |
| `*_bloc.dart` | Event handlers, calls repository, emits states |

```dart
// auth_event.dart
sealed class AuthEvent {}
final class LoginSubmitted extends AuthEvent {
  const LoginSubmitted(this.phone, this.password);
  final String phone;
  final String password;
}
final class LogoutRequested extends AuthEvent {}

// auth_state.dart
sealed class AuthState {}
final class AuthInitial extends AuthState {}
final class AuthLoading extends AuthState {}
final class AuthSuccess extends AuthState {
  const AuthSuccess(this.user);
  final AuthUser user;
}
final class AuthError extends AuthState {
  const AuthError(this.message);  // message comes from Failure.message
  final String message;
}

// auth_bloc.dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  final IAuthRepository _authRepository;

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    // No try/catch — repository returns Either<Failure, AuthUser>
    final result = await _authRepository.login(event.phone, event.password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user)    => emit(AuthSuccess(user)),
    );
  }
}
```

### 5.3 Repository (`data/repositories/`)

- Implements the abstract contract from `domain/contracts/`
- Calls the Service (Dio), maps response model → entity
- Saves/clears tokens in `SecureStorageService`
- Converts raw exceptions into typed `NetworkException`

```dart
// data/repositories/auth_repository.dart
@Injectable(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  AuthRepository(this._authService, this._secureStorage);

  final AuthService _authService;
  final SecureStorageService _secureStorage;

  @override
  Future<Either<Failure, AuthUser>> login(String phone, String password) async {
    try {
      final response = await _authService.login(LoginRequestModel(
        phone: phone,
        password: password,
        deviceName: await _deviceName(),
      ));
      await _secureStorage.saveAccessToken(response.accessToken);
      await _secureStorage.saveRefreshToken(response.refreshToken);
      await _secureStorage.saveSessionId(response.sessionId);
      await _secureStorage.saveUserId(response.patient.id.toString());
      return Right(AuthUser(
        id: response.patient.id,
        fullName: response.patient.fullName,
        phone: response.patient.phone,
        role: 'patient',
      ));
    } on SocketException {
      return Left(NetworkFailure('No internet connection.'));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) return Left(AuthFailure('Session expired.'));
      if ((e.response?.statusCode ?? 0) >= 500) return Left(ServerFailure('Server error.'));
      return Left(ServerFailure(e.response?.data['message'] as String? ?? 'Request failed.'));
    } on TypeError catch (e) {
      return Left(ParseFailure('Response parse error: $e'));
    } on FlutterSecureStorageException catch (e) {
      return Left(CacheFailure('Storage error: $e'));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }
}
```

### 5.4 Service (`data/services/`)

- Only responsible for **raw HTTP calls** via Dio
- Returns the raw response model (or throws `DioException`)
- Never touches BLoC or storage

```dart
// data/services/auth_service.dart
@injectable
class AuthService {
  AuthService(this._dio);
  final Dio _dio;

  Future<AuthResponseModel> login(LoginRequestModel request) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: request.toJson(),
    );
    return AuthResponseModel.fromJson(response.data);
  }

  Future<TokenModel> refreshToken(String sessionId, String refreshToken) async {
    final response = await _dio.post(
      ApiConstants.refresh,
      data: {'session_id': sessionId, 'refresh_token': refreshToken},
    );
    return TokenModel.fromJson(response.data);
  }
}
```

### 5.5 Domain Contracts (`domain/contracts/`)

- Abstract `interface class` — defines the **contract** between BLoC and Repository
- BLoC depends on the contract, NOT the implementation (enables testing)

```dart
// domain/contracts/i_auth_repository.dart
abstract interface class IAuthRepository {
  Future<Either<Failure, AuthUser>> login(String phone, String password);
  Future<Either<Failure, Unit>> logout();
  Future<Either<Failure, bool>> isLoggedIn();
  Future<Either<Failure, AuthUser?>> getCurrentUser();
}
```

> **`Unit`** is dartz's equivalent of `void` for `Either` — use `Right(unit)` for success with no return value.

### 5.6 Domain Entities (`domain/entities/`)

- Pure Dart classes — no `json_annotation`, no `freezed` (optional)
- Represent business objects passed between BLoC and View

```dart
// domain/entities/auth_user.dart
class AuthUser {
  const AuthUser({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.role,
  });
  final int id;
  final String fullName;
  final String phone;
  final String role;
}
```

### 5.7 Data Models (`data/models/`)

- Annotated with `@freezed` + `@JsonSerializable`
- Used only in the data layer — never leak into BLoC or View
- Generated with `build_runner`

```dart
// data/models/auth_response_model.dart
@freezed
class AuthResponseModel with _$AuthResponseModel {
  const factory AuthResponseModel({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'session_id') required String sessionId,
    required PatientModel patient,
  }) = _AuthResponseModel;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);
}
```

---

## 6. Networking — Dio Setup

### `core/network/dio_client.dart`

```dart
@singleton
class DioClient {
  DioClient(this._secureStorage) {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.addAll([
      AuthInterceptor(_dio, _secureStorage),     // token attach + 401 refresh
      RetryInterceptor(                           // 3 retries, exponential backoff
        dio: _dio,
        retries: 3,
        retryDelays: [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 4),
        ],
        retryEvaluator: (error, attempt) =>
            error.type != DioExceptionType.badResponse,
      ),
      if (kDebugMode) LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }

  late final Dio _dio;
  final SecureStorageService _secureStorage;

  Dio get dio => _dio;
}
```

### `core/network/auth_interceptor.dart`

```dart
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(this._dio, this._storage);

  final Dio _dio;
  final SecureStorageService _storage;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final sessionId = await _storage.getSessionId();
        final refreshToken = await _storage.getRefreshToken();

        if (sessionId == null || refreshToken == null) {
          await _clearAndLogout();
          return handler.next(err);
        }

        // Call refresh endpoint directly (bypass interceptor with new Dio instance)
        final refreshDio = Dio()..options.baseUrl = ApiConstants.baseUrl;
        final response = await refreshDio.post(
          ApiConstants.refresh,
          data: {'session_id': sessionId, 'refresh_token': refreshToken},
        );

        final newAccessToken = response.data['access_token'] as String;
        final newRefreshToken = response.data['refresh_token'] as String;

        // Rotate — save new tokens
        await _storage.saveAccessToken(newAccessToken);
        await _storage.saveRefreshToken(newRefreshToken);

        // Retry original request with new token
        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        final retryResponse = await _dio.fetch(err.requestOptions);
        return handler.resolve(retryResponse);

      } catch (_) {
        await _clearAndLogout();
        return handler.next(err);
      }
    }
    handler.next(err);
  }

  Future<void> _clearAndLogout() async {
    await _storage.clearAll();
    // Navigate to login — via GoRouter without BuildContext
    appRouter.go(RouteNames.login);
  }
}
```

> **Why `QueuedInterceptor`?**
> If 5 API calls fail at 401 simultaneously, `QueuedInterceptor` ensures only **one** refresh call is made.
> The other 4 wait in queue and automatically retry with the new token.

### `core/network/network_exception.dart`

```dart
class NetworkException implements Exception {
  const NetworkException({required this.message, required this.type});

  final String message;
  final NetworkExceptionType type;

  factory NetworkException.fromDioException(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout    => const NetworkException(
          message: 'Connection timed out. Check your internet.',
          type: NetworkExceptionType.timeout,
        ),
      DioExceptionType.connectionError   => const NetworkException(
          message: 'No internet connection.',
          type: NetworkExceptionType.noInternet,
        ),
      DioExceptionType.badResponse       => NetworkException(
          message: _parseServerMessage(e.response),
          type: e.response?.statusCode == 401
              ? NetworkExceptionType.unauthorized
              : NetworkExceptionType.serverError,
        ),
      _ => const NetworkException(
          message: 'Something went wrong. Try again.',
          type: NetworkExceptionType.unknown,
        ),
    };
  }

  static String _parseServerMessage(Response? response) {
    try {
      return response?.data['message'] as String? ?? 'Server error';
    } catch (_) {
      return 'Server error';
    }
  }
}

enum NetworkExceptionType { timeout, noInternet, unauthorized, serverError, unknown }
```

---

## 7. Auth Flow & Token Refresh

### Login Flow

```
App Start
    │
    ▼
SecureStorageService.getAccessToken()
    │
    ├── Token exists? ──► GoRouter guard → /home
    │
    └── No token? ──► GoRouter guard → /login

User submits login form
    │
    ▼
LoginSubmitted event → AuthBloc
    │
    ▼
AuthRepository.login(phone, password)
    │
    ▼
AuthService: POST /api/v2/auth/mobile/login
    { phone, password, device_name }
    │
    ▼
Response: { access_token, refresh_token, session_id, patient: {...} }
    │
    ▼
SecureStorageService.saveAccessToken()
SecureStorageService.saveRefreshToken()
SecureStorageService.saveSessionId()
SecureStorageService.saveUserId()
    │
    ▼
AuthBloc emits AuthSuccess(user)
    │
    ▼
View (BlocListener) → context.go('/home')
```

### Token Refresh Flow (Auto — via AuthInterceptor)

```
Any API call
    │
    ▼
AuthInterceptor.onRequest → attaches Bearer token
    │
    ▼
Server returns 401 Unauthorized
    │
    ▼
AuthInterceptor.onError catches 401
    │
    ▼
POST /api/v2/auth/mobile/refresh
    { session_id, refresh_token }
    │
    ├── Success: new access_token + refresh_token (rotated)
    │       │
    │       ▼
    │   Save new tokens to SecureStorage
    │   Retry original request with new token
    │   handler.resolve(response) ← seamless for user
    │
    └── Failure (refresh_token expired/revoked)
            │
            ▼
        SecureStorage.clearAll()
        GoRouter.go('/login')
```

---

## 8. Storage Strategy

### `core/constants/storage_keys.dart`

```dart
abstract final class StorageKeys {
  // Secure Storage (flutter_secure_storage)
  static const String accessToken       = 'access_token';
  static const String refreshToken      = 'refresh_token';
  static const String sessionId         = 'session_id';
  static const String userId            = 'user_id';

  // SharedPreferences (shared_preferences)
  static const String themeMode         = 'theme_mode';
  static const String language          = 'language';
  static const String onboardingDone    = 'onboarding_done';
  static const String notifEnabled      = 'notification_enabled';
}
```

### What Goes Where

| Data | Storage | Why |
|---|---|---|
| `access_token` | `flutter_secure_storage` | JWT — Keychain/Keystore encrypted |
| `refresh_token` | `flutter_secure_storage` | Sensitive — must not be in SharedPrefs |
| `session_id` | `flutter_secure_storage` | Required for token rotation |
| `user_id` | `flutter_secure_storage` | Patient identity |
| `theme_mode` | `shared_preferences` | Non-sensitive preference |
| `language` | `shared_preferences` | Non-sensitive preference |
| `onboarding_done` | `shared_preferences` | Non-sensitive flag |
| `notification_enabled` | `shared_preferences` | Non-sensitive flag |

---

## 9. Navigation — GoRouter

### `core/router/route_names.dart`

```dart
abstract final class RouteNames {
  static const String login     = '/login';
  static const String mfa       = '/mfa';
  static const String home      = '/home';
  static const String appointments = '/appointments';
  static const String bookAppointment = '/appointments/book';
  static const String gymCard   = '/gym-card';
  static const String lab       = '/lab';
  static const String prescriptions = '/prescriptions';
  static const String records   = '/records';
  static const String bodyProgress = '/body-progress';
  static const String nutrition = '/nutrition';
  static const String shop      = '/shop';
  static const String cart      = '/cart';
  static const String orders    = '/orders';
  static const String profile   = '/profile';
  static const String community = '/community';
}
```

### `core/router/app_router.dart`

```dart
final appRouter = GoRouter(
  initialLocation: RouteNames.login,
  redirect: (context, state) async {
    final secureStorage = getIt<SecureStorageService>();
    final token = await secureStorage.getAccessToken();
    final isLoggedIn = token != null;
    final isOnLoginPage = state.matchedLocation == RouteNames.login;

    if (!isLoggedIn && !isOnLoginPage) return RouteNames.login;
    if (isLoggedIn && isOnLoginPage) return RouteNames.home;
    return null;
  },
  routes: [
    GoRoute(path: RouteNames.login, builder: (_, __) => const LoginScreen()),
    GoRoute(path: RouteNames.mfa,   builder: (_, __) => const MfaScreen()),

    // Shell route — bottom navigation bar persists
    ShellRoute(
      builder: (context, state, child) => PatientShell(child: child),
      routes: [
        GoRoute(path: RouteNames.home,         builder: (_, __) => const HomeScreen()),
        GoRoute(path: RouteNames.appointments, builder: (_, __) => const AppointmentsScreen()),
        GoRoute(path: RouteNames.gymCard,      builder: (_, __) => const GymCardScreen()),
        GoRoute(path: RouteNames.lab,          builder: (_, __) => const LabScreen()),
        GoRoute(path: RouteNames.profile,      builder: (_, __) => const ProfileScreen()),
      ],
    ),

    // Full-screen routes (no bottom nav)
    GoRoute(path: RouteNames.prescriptions, builder: (_, __) => const PrescriptionsScreen()),
    GoRoute(path: RouteNames.records,       builder: (_, __) => const RecordsScreen()),
    GoRoute(path: RouteNames.bodyProgress,  builder: (_, __) => const BodyProgressScreen()),
    GoRoute(path: RouteNames.nutrition,     builder: (_, __) => const NutritionScreen()),
    GoRoute(path: RouteNames.shop,          builder: (_, __) => const ShopScreen()),
    GoRoute(path: RouteNames.orders,        builder: (_, __) => const OrdersScreen()),
  ],
);
```

---

## 10. BLoC Pattern — How to Write Every Feature

Every feature follows this exact structure. Use `auth` as the reference.

### Step 1 — Create the domain contract

```dart
// domain/contracts/i_appointments_repository.dart
abstract interface class IAppointmentsRepository {
  Future<List<Appointment>> getAppointments();
  Future<void> bookAppointment(BookAppointmentRequest request);
  Future<void> cancelAppointment(int appointmentId);
}
```

### Step 2 — Create the data model (Freezed)

```dart
// data/models/appointment_model.dart
@freezed
class AppointmentModel with _$AppointmentModel {
  const factory AppointmentModel({
    required int id,
    @JsonKey(name: 'doctor_name') required String doctorName,
    @JsonKey(name: 'clinic_name') required String clinicName,
    @JsonKey(name: 'appointment_date') required String appointmentDate,
    required String status,
  }) = _AppointmentModel;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);
}
```

### Step 3 — Create the service (Dio only)

```dart
// data/services/appointment_service.dart
@injectable
class AppointmentService {
  AppointmentService(this._dio);
  final Dio _dio;

  Future<List<AppointmentModel>> getAppointments() async {
    final response = await _dio.get(ApiConstants.appointments);
    return (response.data['data'] as List)
        .map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
```

### Step 4 — Create the repository

```dart
// data/repositories/appointment_repository.dart
@Injectable(as: IAppointmentsRepository)
class AppointmentRepository implements IAppointmentsRepository {
  AppointmentRepository(this._service);
  final AppointmentService _service;

  @override
  Future<List<Appointment>> getAppointments() async {
    try {
      final models = await _service.getAppointments();
      return models.map((m) => Appointment(
        id: m.id,
        doctorName: m.doctorName,
        clinicName: m.clinicName,
        appointmentDate: m.appointmentDate,
        status: m.status,
      )).toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }
}
```

### Step 5 — Write the BLoC (ViewModel)

```dart
// presentation/bloc/appointment_bloc.dart
class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  AppointmentBloc(this._repository) : super(AppointmentInitial()) {
    on<AppointmentsLoadRequested>(_onLoadRequested);
    on<AppointmentCancelRequested>(_onCancelRequested);
  }

  final IAppointmentsRepository _repository;

  Future<void> _onLoadRequested(
      AppointmentsLoadRequested event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoading());
    try {
      final appointments = await _repository.getAppointments();
      emit(AppointmentsLoaded(appointments));
    } on NetworkException catch (e) {
      emit(AppointmentError(e.message));
    }
  }
}
```

### Step 6 — Build the screen (View)

```dart
// presentation/screens/appointments_screen.dart
class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AppointmentBloc>()
        ..add(const AppointmentsLoadRequested()),
      child: BlocBuilder<AppointmentBloc, AppointmentState>(
        builder: (context, state) => switch (state) {
          AppointmentLoading()        => const AppLoadingIndicator(),
          AppointmentsLoaded(:final appointments) => AppointmentsList(appointments),
          AppointmentError(:final message) => AppErrorWidget(message: message),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}
```

---

## 11. Patient App — Feature Scope

### APIs Used (from backend)

```
Auth:
  POST  /api/v2/auth/mobile/login
  POST  /api/v2/auth/mobile/refresh
  POST  /api/v2/auth/mobile/logout
  POST  /api/v2/auth/mfa/enrol
  POST  /api/v2/auth/mfa/enrol/verify

Profile:
  GET   /api/patient/profile
  PUT   /api/patient/profile
  GET   /api/patient/addresses
  POST  /api/patient/addresses

Appointments:
  GET   /api/patient/appointments
  POST  /api/patient/appointments
  PATCH /api/patient/appointments/:id/cancel

Gym:
  GET   /api/patient/gym           (membership + QR code data)

Lab:
  GET   /api/patient/lab-bookings
  POST  /api/patient/lab-bookings
  GET   /api/patient/lab-reports
  GET   /api/patient/lab-referrals

Prescriptions:
  GET   /api/patient/prescriptions

Records:
  GET   /api/patient/records

Body Progress:
  GET   /api/patient/body-progress
  POST  /api/patient/body-progress

Nutrition:
  GET   /api/patient/nutrition
  GET   /api/patient/ai-nutrition

Shop:
  GET   /api/patient/shop
  GET   /api/patient/cart
  POST  /api/patient/cart
  POST  /api/patient/orders
  GET   /api/patient/orders

Invoices:
  GET   /api/patient/invoices

Community:
  GET   /api/patient/clubs
  GET   /api/patient/events
  GET   /api/patient/social

Meetings:
  GET   /api/patient/meetings

Points:
  GET   /api/patient/points
```

---

## 12. Implementation Phases

### Phase 0 — Project Setup & Core Infrastructure

**Goal:** Runnable app shell with DI, theme, routing, networking, and storage wired up.

- [ ] `flutter create fittoria_patient --org com.fittoria`
- [ ] Create full folder structure (`core/`, `features/`, `shared/`)
- [ ] Write `pubspec.yaml` with all dependencies
- [ ] Create `.env.dev` and `.env.prod`
- [ ] `core/constants/api_constants.dart` — all endpoint strings
- [ ] `core/constants/storage_keys.dart`
- [ ] `core/storage/secure_storage_service.dart`
- [ ] `core/storage/preferences_service.dart`
- [ ] `core/network/network_exception.dart`
- [ ] `core/network/auth_interceptor.dart` (QueuedInterceptor)
- [ ] `core/network/retry_interceptor.dart`
- [ ] `core/network/dio_client.dart`
- [ ] `core/di/injection.dart` — register all singletons
- [ ] `core/router/app_router.dart` + `route_names.dart`
- [ ] `core/theme/app_colors.dart` + `app_text_styles.dart` + `app_theme.dart`
- [ ] `main.dart` — init dotenv, init GetIt, run app with BlocObserver
- [ ] Run `flutter pub get` — verify no errors

---

### Phase 1 — Auth Feature

**Goal:** Login → token storage → auto-login on cold start → logout.

- [ ] `features/auth/domain/entities/auth_user.dart`
- [ ] `features/auth/domain/contracts/i_auth_repository.dart`
- [ ] `features/auth/data/models/login_request_model.dart` (Freezed)
- [ ] `features/auth/data/models/auth_response_model.dart` (Freezed)
- [ ] `features/auth/data/services/auth_service.dart`
- [ ] `features/auth/data/repositories/auth_repository.dart`
- [ ] `features/auth/presentation/bloc/auth_event.dart`
- [ ] `features/auth/presentation/bloc/auth_state.dart`
- [ ] `features/auth/presentation/bloc/auth_bloc.dart`
- [ ] `features/auth/presentation/screens/login_screen.dart`
- [ ] `features/auth/presentation/screens/mfa_screen.dart`
- [ ] Register AuthBloc + AuthRepository in `injection.dart`
- [ ] GoRouter guard — redirect unauthenticated users to `/login`
- [ ] Run `build_runner` — generate Freezed + Injectable code
- [ ] Test: login → token saved → redirect to home ✓
- [ ] Test: cold start with valid token → skip login ✓
- [ ] Test: 401 → token refresh → retry ✓
- [ ] Test: refresh expired → clear storage → redirect to login ✓

---

### Phase 2 — Home & Profile

**Goal:** Home dashboard with quick stats. Profile view/edit.

- [ ] `features/home/` — full MVVM stack
- [ ] Home screen: stats cards (today's appointment, active gym membership)
- [ ] Bottom navigation shell (`shared/widgets/patient_shell.dart`)
- [ ] `features/profile/` — full MVVM stack
- [ ] Profile screen: name, phone, DOB, blood group, photo
- [ ] Edit profile form
- [ ] Address list + add address

---

### Phase 3 — Core Patient Features

**Goal:** Appointments, gym QR card, prescriptions, medical records.

- [ ] `features/appointments/` — list, book, cancel
- [ ] `features/gym_card/` — membership details + QR code (`qr_flutter`)
- [ ] `features/prescriptions/` — list + PDF open (`open_filex`)
- [ ] `features/records/` — medical history list

---

### Phase 4 — Health Tracking

**Goal:** Lab booking + reports, body progress chart, nutrition.

- [ ] `features/lab/` — booking form, reports list, referrals
- [ ] `features/body_progress/` — log entry + `fl_chart` line chart
- [ ] `features/nutrition/` — meal plan viewer, meal tracking, AI nutrition

---

### Phase 5 — Shop, Community & Notifications

**Goal:** E-commerce flow, community features, push notifications.

- [ ] `features/shop/` — product grid, cart, checkout, orders
- [ ] `features/community/` — clubs, events, social feed
- [ ] FCM push notifications setup (`firebase_messaging`)
- [ ] `flutter_local_notifications` — local appointment reminders
- [ ] Invoices screen
- [ ] Meetings screen

---

## 13. Naming Conventions

| Type | Convention | Example |
|---|---|---|
| Files | `snake_case` | `auth_repository.dart` |
| Classes | `PascalCase` | `AuthRepository` |
| Variables / methods | `camelCase` | `getAccessToken()` |
| Constants | `camelCase` | `StorageKeys.accessToken` |
| BLoC Events | `PastTense + Event suffix` | `LoginSubmitted`, `AppointmentsLoadRequested` |
| BLoC States | `Adjective/Noun` | `AuthLoading`, `AuthSuccess`, `AuthError` |
| Interfaces / Contracts | `I` prefix | `IAuthRepository` |
| Models (data layer) | `*Model` suffix | `AppointmentModel` |
| Entities (domain) | No suffix | `Appointment`, `AuthUser` |
| Services | `*Service` suffix | `AuthService` |
| Repositories | `*Repository` suffix | `AuthRepository` |

---

## 14. Code Generation

Run this every time you create or modify a `@freezed` class or `@injectable` class:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or watch mode during development:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

**Files generated automatically:**
- `*.freezed.dart` — immutable model boilerplate
- `*.g.dart` — JSON serialization
- `injection.config.dart` — GetIt registrations

**Never manually edit generated files.**

---

## 15. Environment Config

### `.env.dev`

```
BASE_URL=http://localhost:3000
APP_ENV=development
```

### `.env.prod`

```
BASE_URL=https://api.fittoria.in
APP_ENV=production
```

### `core/constants/api_constants.dart`

```dart
abstract final class ApiConstants {
  static String get baseUrl => dotenv.env['BASE_URL']!;

  // Auth
  static const String login       = '/api/v2/auth/mobile/login';
  static const String refresh     = '/api/v2/auth/mobile/refresh';
  static const String logout      = '/api/v2/auth/mobile/logout';
  static const String mfaEnrol    = '/api/v2/auth/mfa/enrol';
  static const String mfaVerify   = '/api/v2/auth/mfa/enrol/verify';

  // Patient
  static const String profile      = '/api/patient/profile';
  static const String addresses    = '/api/patient/addresses';
  static const String appointments = '/api/patient/appointments';
  static const String gymCard      = '/api/patient/gym';
  static const String labBookings  = '/api/patient/lab-bookings';
  static const String labReports   = '/api/patient/lab-reports';
  static const String labReferrals = '/api/patient/lab-referrals';
  static const String prescriptions = '/api/patient/prescriptions';
  static const String records      = '/api/patient/records';
  static const String bodyProgress = '/api/patient/body-progress';
  static const String nutrition    = '/api/patient/nutrition';
  static const String aiNutrition  = '/api/patient/ai-nutrition';
  static const String shop         = '/api/patient/shop';
  static const String cart         = '/api/patient/cart';
  static const String orders       = '/api/patient/orders';
  static const String invoices     = '/api/patient/invoices';
  static const String clubs        = '/api/patient/clubs';
  static const String events       = '/api/patient/events';
  static const String social       = '/api/patient/social';
  static const String meetings     = '/api/patient/meetings';
  static const String points       = '/api/patient/points';
}
```

---

*This document is the single source of truth for the Fittoria Flutter Patient App.
Update it as architecture decisions evolve.*
