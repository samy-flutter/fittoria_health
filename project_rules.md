# Fittoria Flutter — Project Rules

## Project Identity
- **App:** `fittoria_patient` — Patient-facing mobile app ONLY
- **Staff CRM is excluded.** Never scaffold staff/admin/doctor/gym-owner screens.
- **Architecture:** MVVM (Flutter official guide) — View → ViewModel(BLoC) → Repository → Service
- **Error Handling:** `dartz` — all repositories return `Either<Failure, T>`. No exceptions bubble to BLoC.
- **Ref:** `d:\flutter\fittoria\FITTORIA_FLUTTER.md`

---

## Architecture Rules

### MVVM Layer Enforcement
- **View** (`*_screen.dart`): No business logic. Only `BlocBuilder`/`BlocConsumer`. Dispatch events only.
- **ViewModel** (`*_bloc.dart`): No Dio calls. No direct storage access. Calls repository only.
- **Repository** (`*_repository.dart`): Calls service. Maps model → entity. Returns `Either<Failure, T>`. **Never throws.** Catches all exceptions internally and returns `Left(Failure)`.
- **Service** (`*_service.dart`): Dio calls only. Never touches BLoC or storage directly.
- **Never skip layers.** BLoC must not call Dio. View must not call Repository.

### BLoC Rules
- Use `Bloc<Event, State>`, NOT `Cubit`, for all features.
- Events: `sealed class`, named in past tense + `ed/Requested` suffix → `LoginSubmitted`, `AppointmentsLoadRequested`.
- States: `sealed class` → `*Initial`, `*Loading`, `*Loaded`, `*Error`.
- Every feature has exactly 3 BLoC files: `*_event.dart`, `*_state.dart`, `*_bloc.dart`.
- Use Dart 3 `switch` expressions in `BlocBuilder` for exhaustive state handling.
- Handle `Either` results in BLoC using `.fold((failure) => emit(XError(failure.message)), (data) => emit(XLoaded(data)))`.

### Repository Rules
- Implement the abstract contract from `domain/contracts/i_*.dart`.
- Annotate with `@Injectable(as: IXRepository)`.
- All repository methods return `Future<Either<Failure, T>>`. **Never throw, never return null.**
- Catch every exception type and return `Left(Failure)`. Mapping:
  - `SocketException` / `DioExceptionType.connectionError` → `Left(NetworkFailure('No internet connection.'))`
  - `DioExceptionType.connectionTimeout` / `receiveTimeout` → `Left(NetworkFailure('Request timed out.'))`
  - HTTP 401 → `Left(AuthFailure('Session expired. Please login again.'))`
  - HTTP 4xx → `Left(ServerFailure(response.data['message'] ?? 'Bad request.'))`
  - HTTP 5xx → `Left(ServerFailure('Server error. Try again later.'))`
  - `TypeError` / `Null check` / `FormatException` → `Left(ParseFailure('Unexpected response format.'))`
  - `FlutterSecureStorageError` / storage read null → `Left(CacheFailure('Failed to read local data.'))`
  - Any other `Exception` → `Left(UnknownFailure('Something went wrong.'))`
- Map data models (from `data/models/`) to domain entities (from `domain/entities/`) inside repository. Models must not leak out.

### Model Rules
- Data models: `@freezed` + `@JsonSerializable`. Suffix `*Model`. Live in `data/models/`.
- Domain entities: plain Dart class. No suffix. Live in `domain/entities/`. No JSON annotations.
- Run `build_runner` after every model change: `flutter pub run build_runner build --delete-conflicting-outputs`.
- Never manually edit `*.freezed.dart` or `*.g.dart`.

---

## Networking Rules

### Dio & Interceptors
- Single `DioClient` singleton registered via `get_it`.
- Interceptor order: `AuthInterceptor` → `RetryInterceptor` → `LogInterceptor` (debug only).
- `AuthInterceptor` MUST extend `QueuedInterceptor` — not `Interceptor`. Prevents parallel refresh calls.
- Token refresh uses a **separate** plain `Dio` instance (not the main `_dio`) to avoid interceptor loop.
- On 401 refresh failure: `SecureStorageService.clearAll()` → `appRouter.go(RouteNames.login)`.
- Retry: 3 attempts, delays `[1s, 2s, 4s]`, only on non-`badResponse` errors (network/timeout only).

### Error Handling — dartz `Either`

**Package:** `dartz: ^0.10.1` — [pub.dev/packages/dartz](https://pub.dev/packages/dartz)

**Failure hierarchy** — define in `core/error/failures.dart`:
```dart
sealed class Failure { final String message; const Failure(this.message); }
final class NetworkFailure  extends Failure { const NetworkFailure(super.message); }  // SocketException, no internet
final class AuthFailure     extends Failure { const AuthFailure(super.message); }     // 401 Unauthorized
final class ServerFailure   extends Failure { const ServerFailure(super.message); }   // 4xx/5xx HTTP
final class ParseFailure    extends Failure { const ParseFailure(super.message); }    // TypeError, null, FormatException
final class CacheFailure    extends Failure { const CacheFailure(super.message); }    // SecureStorage / SharedPrefs errors
final class UnknownFailure  extends Failure { const UnknownFailure(super.message); } // catch-all
```

**Repository return pattern:**
```dart
Future<Either<Failure, AuthUser>> login(String phone, String password) async {
  try {
    final model = await _authService.login(...);
    return Right(model.toEntity());
  } on SocketException {
    return Left(NetworkFailure('No internet connection.'));
  } on DioException catch (e) {
    return Left(_mapDioError(e));
  } on TypeError catch (e) {
    return Left(ParseFailure('Response parse error: $e'));
  } catch (e) {
    return Left(UnknownFailure('Unexpected error: $e'));
  }
}
```

**BLoC consumption pattern:**
```dart
final result = await _repository.login(event.phone, event.password);
result.fold(
  (failure) => emit(AuthError(failure.message)),
  (user)    => emit(AuthSuccess(user)),
);
```

- BLoC **never** uses `try/catch`. It only calls `.fold()` on the `Either`.
- Views display `state.message` from the `*Error` state — already human-friendly.

---

## Storage Rules

| Data | Storage | Key constant |
|---|---|---|
| access_token | `flutter_secure_storage` | `StorageKeys.accessToken` |
| refresh_token | `flutter_secure_storage` | `StorageKeys.refreshToken` |
| session_id | `flutter_secure_storage` | `StorageKeys.sessionId` |
| user_id | `flutter_secure_storage` | `StorageKeys.userId` |
| theme_mode | `shared_preferences` | `StorageKeys.themeMode` |
| onboarding_done | `shared_preferences` | `StorageKeys.onboardingDone` |

- **Never** store tokens in `shared_preferences`.
- All key strings live in `core/constants/storage_keys.dart` — no inline strings.

---

## Navigation Rules
- Use `go_router` only. Never `Navigator.push` directly in feature screens.
- All route paths are constants in `core/router/route_names.dart`. No inline strings.
- Auth guard in `GoRouter.redirect` reads `SecureStorageService.getAccessToken()`.
- Bottom nav tabs use `ShellRoute`. Full-screen flows use top-level `GoRoute`.

---

## Dependency Injection Rules
- Use `get_it` + `injectable`. Register all services, repositories, and BLoCs.
- `@singleton` → `DioClient`, `SecureStorageService`, `PreferencesService`.
- `@injectable` → Services, Repositories.
- `@injectable` → BLoCs (factory — new instance per screen).
- Run `build_runner` after adding `@injectable` annotations.
- Never use `BuildContext` to obtain dependencies. Use `getIt<T>()`.

---

## Naming Conventions

| Type | Rule | Example |
|---|---|---|
| Files | `snake_case.dart` | `auth_repository.dart` |
| Classes | `PascalCase` | `AuthRepository` |
| Interfaces | `I` prefix | `IAuthRepository` |
| BLoC Events | Past tense | `LoginSubmitted` |
| BLoC States | Adjective/noun | `AuthLoading`, `AuthSuccess` |
| Data Models | `*Model` suffix | `AppointmentModel` |
| Domain Entities | No suffix | `Appointment` |
| Services | `*Service` | `AuthService` |
| Repositories | `*Repository` | `AuthRepository` |
| Route constants | `camelCase` in `RouteNames` | `RouteNames.appointments` |
| Storage constants | `camelCase` in `StorageKeys` | `StorageKeys.accessToken` |

---

## Safety Constraints
- Never commit `.env.dev` or `.env.prod`. Add to `.gitignore`.
- Never log tokens, refresh tokens, or session IDs — even in debug mode.
- Never expose `SecureStorageService` to the View layer.
- Never call `clearAll()` on storage unless the refresh token is confirmed invalid.
- All API endpoint strings must live in `ApiConstants`. No hardcoded URLs anywhere.
- `LogInterceptor` must be gated with `if (kDebugMode)` — never in production builds.

---

## Scope Constraint
Only implement Patient App APIs:
```
/api/v2/auth/mobile/*   /api/patient/profile     /api/patient/appointments
/api/patient/gym        /api/patient/lab-*        /api/patient/prescriptions
/api/patient/records    /api/patient/body-progress /api/patient/nutrition
/api/patient/ai-nutrition /api/patient/shop       /api/patient/cart
/api/patient/orders     /api/patient/invoices     /api/patient/clubs
/api/patient/events     /api/patient/social       /api/patient/meetings
/api/patient/points
```
