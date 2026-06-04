# SKILL: Fittoria Flutter Patient App — Task Executor

## Metadata
- **Skill ID:** fittoria-flutter-task-executor
- **Scope:** Patient App only (Staff CRM excluded)
- **Architecture:** MVVM — View / BLoC (ViewModel) / Repository / Service
- **Error Handling:** `dartz` — `Either<Failure, T>` — [pub.dev/packages/dartz](https://pub.dev/packages/dartz)
- **Rules:** `.agents/rules/project-rules.md`
- **Blueprint:** `FITTORIA_FLUTTER.md`

---

## How to Use This Skill
Execute phases **in order**. Each phase is self-contained. Do not start a phase until the previous one compiles cleanly (`flutter analyze` — zero errors).

---

## Phase 0 — Project Setup & Core Infrastructure

**Goal:** Runnable empty shell with DI, networking, storage, routing, and theming wired up.

### Steps

1. **Create project**
   ```
   flutter create fittoria_patient --org com.fittoria --platforms android,ios
   ```

2. **Write `pubspec.yaml`** — copy exact dependencies from `FITTORIA_FLUTTER.md §3`

3. **Create folder skeleton**
   ```
   lib/
     core/constants/ core/network/ core/storage/
     core/router/ core/theme/ core/di/ core/utils/
     features/auth/ features/home/ features/appointments/
     features/gym_card/ features/lab/ features/prescriptions/
     features/records/ features/body_progress/ features/nutrition/
     features/shop/ features/profile/ features/community/
     shared/widgets/ shared/blocs/
   ```

4. **Create files (in this order):**
   - `core/constants/storage_keys.dart` — all storage key constants
   - `core/constants/api_constants.dart` — baseUrl getter + all endpoint strings
   - `core/error/failures.dart` — **`dartz` Failure sealed class hierarchy** (NetworkFailure, AuthFailure, ServerFailure, ParseFailure, CacheFailure, UnknownFailure)
   - `core/storage/secure_storage_service.dart` — `flutter_secure_storage` wrapper
   - `core/storage/preferences_service.dart` — `shared_preferences` wrapper
   - `core/network/auth_interceptor.dart` — `QueuedInterceptor`, 401 refresh + retry
   - `core/network/retry_interceptor.dart` — `dio_smart_retry`, 3 retries, `[1s,2s,4s]`
   - `core/network/dio_client.dart` — Dio builder, wires all interceptors
   - `core/di/injection.dart` — `@InjectableInit`, register all core singletons
   - `core/router/route_names.dart` — all path constants
   - `core/router/app_router.dart` — GoRouter + auth redirect guard
   - `core/theme/app_colors.dart`, `app_text_styles.dart`, `app_theme.dart`
   - `main.dart` — `dotenv.load`, `configureDependencies()`, `BlocObserver`, `runApp`

5. **Verify:** `flutter pub get` → `flutter analyze` → zero errors

---

## Phase 1 — Auth Feature

**Goal:** Login → token save → cold-start auto-login → MFA → logout. Token refresh end-to-end.

### File Creation Order (per MVVM)

```
domain/entities/auth_user.dart                   # plain Dart entity
domain/contracts/i_auth_repository.dart          # returns Either<Failure, T>
data/models/login_request_model.dart             # @freezed @JsonSerializable
data/models/auth_response_model.dart             # @freezed @JsonSerializable
data/models/token_model.dart                     # @freezed @JsonSerializable
data/services/auth_service.dart                  # Dio calls only — may throw
data/repositories/auth_repository.dart           # catches ALL exceptions → Left(Failure)
presentation/bloc/auth_event.dart                # sealed class
presentation/bloc/auth_state.dart                # sealed class — AuthError holds failure.message
presentation/bloc/auth_bloc.dart                 # Bloc<AuthEvent, AuthState> — uses .fold(), no try/catch
presentation/screens/login_screen.dart           # BlocConsumer
presentation/screens/mfa_screen.dart
```

**Contract pattern:**
```dart
// i_auth_repository.dart
abstract interface class IAuthRepository {
  Future<Either<Failure, AuthUser>> login(String phone, String password);
  Future<Either<Failure, Unit>> logout();
}
```

**Repository pattern:**
```dart
// auth_repository.dart
@Injectable(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  @override
  Future<Either<Failure, AuthUser>> login(String phone, String password) async {
    try {
      final model = await _authService.login(...);
      await _storage.saveTokens(model.accessToken, model.refreshToken, model.sessionId);
      return Right(model.toEntity());
    } on SocketException {
      return Left(NetworkFailure('No internet connection.'));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) return Left(AuthFailure('Invalid credentials.'));
      if ((e.response?.statusCode ?? 0) >= 500) return Left(ServerFailure('Server error.'));
      return Left(ServerFailure(e.response?.data['message'] ?? 'Request failed.'));
    } on TypeError catch (e) {
      return Left(ParseFailure('Parse error: $e'));
    } catch (e) {
      return Left(UnknownFailure('Unexpected: $e'));
    }
  }
}
```

**BLoC pattern (no try/catch):**
```dart
Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<AuthState> emit) async {
  emit(AuthLoading());
  final result = await _authRepository.login(event.phone, event.password);
  result.fold(
    (failure) => emit(AuthError(failure.message)),
    (user)    => emit(AuthSuccess(user)),
  );
}
```

### Code Generation
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Checklist
- [ ] Login form → `LoginSubmitted` event → `AuthLoading` → `AuthSuccess` → GoRouter to `/home`
- [ ] Cold start: token in SecureStorage → auto-redirect to `/home`
- [ ] 401 received → refresh call → new tokens saved → original request retried
- [ ] Refresh fails → `clearAll()` → redirect to `/login`
- [ ] Logout → `LogoutRequested` → `clearAll()` → redirect to `/login`

---

## Phase 2 — Home & Profile

**Goal:** Dashboard with summary cards. Profile view and edit. Bottom nav shell.

### Steps
1. Create `shared/widgets/patient_shell.dart` — `ShellRoute` with bottom `NavigationBar` (5 tabs: Home, Appointments, Gym, Lab, Profile)
2. Create `features/home/` full MVVM stack — `GET /api/patient/profile` for greeting + summary
3. Create `features/profile/` full MVVM stack
   - View: name, phone, DOB, blood group, avatar
   - Edit profile: `PUT /api/patient/profile`
   - Addresses: `GET/POST /api/patient/addresses`

### Checklist
- [ ] Bottom nav persists across tab switches (ShellRoute)
- [ ] Home shows patient name, today's appointment count, gym status
- [ ] Profile edit saves and refreshes state

---

## Phase 3 — Core Patient Features

**Goal:** Appointments, gym QR card, prescriptions, medical records.

### Steps (one MVVM stack per feature)

1. **Appointments** (`features/appointments/`)
   - List: `GET /api/patient/appointments`
   - Book: `POST /api/patient/appointments` — form with clinic/date/time
   - Cancel: `PATCH /api/patient/appointments/:id/cancel`

2. **Gym Card** (`features/gym_card/`)
   - `GET /api/patient/gym`
   - Display: membership plan, expiry, `qr_flutter` QR widget

3. **Prescriptions** (`features/prescriptions/`)
   - `GET /api/patient/prescriptions`
   - List → tap → `open_filex` to open PDF

4. **Records** (`features/records/`)
   - `GET /api/patient/records`
   - List → detail view

### Checklist
- [ ] All screens show `ShimmerLoader` while loading
- [ ] All error states show `AppErrorWidget` with retry button
- [ ] QR widget renders gym membership QR code correctly
- [ ] PDF opens via `open_filex`

---

## Phase 4 — Health Tracking

**Goal:** Lab booking, body progress chart, nutrition + AI.

### Steps

1. **Lab** (`features/lab/`)
   - Tabs: Bookings | Reports | Referrals
   - `GET/POST /api/patient/lab-bookings`
   - `GET /api/patient/lab-reports`
   - `GET /api/patient/lab-referrals`

2. **Body Progress** (`features/body_progress/`)
   - `GET /api/patient/body-progress` — render `fl_chart` LineChart
   - `POST /api/patient/body-progress` — log new metric (weight, body fat, waist)

3. **Nutrition** (`features/nutrition/`)
   - `GET /api/patient/nutrition` — meal plan display
   - `GET /api/patient/ai-nutrition` — AI suggestions card

### Checklist
- [ ] Lab booking form validates fields before submission
- [ ] Body progress chart shows last 30 data points
- [ ] Chart animates on load

---

## Phase 5 — Shop, Community & Notifications

**Goal:** E-commerce, community features, push notifications.

### Steps

1. **Shop** (`features/shop/`)
   - `GET /api/patient/shop` — product grid
   - `GET/POST /api/patient/cart` — cart badge in app bar
   - `POST /api/patient/orders`, `GET /api/patient/orders`
   - `GET /api/patient/invoices`

2. **Community** (`features/community/`)
   - `GET /api/patient/clubs`, `/events`, `/social`
   - `GET /api/patient/meetings`
   - `GET /api/patient/points` — loyalty points card

3. **Notifications**
   - `firebase_messaging`: `FirebaseMessaging.onMessage`, `onMessageOpenedApp`
   - `flutter_local_notifications`: appointment reminders
   - Request permission on first launch

### Checklist
- [ ] Cart item count shows as badge on shop tab
- [ ] Order placement shows success confirmation
- [ ] FCM token sent to backend on login
- [ ] Local notification fires 1 hour before appointment

---

## Per-Feature Template (Copy for Every New Feature)

```
features/<name>/
  domain/
    entities/<name>.dart
    contracts/i_<name>_repository.dart      # returns Either<Failure, T>
  data/
    models/<name>_model.dart                # @freezed
    services/<name>_service.dart            # Dio only — may throw
    repositories/<name>_repository.dart     # catches ALL errors → Left(Failure)
  presentation/
    bloc/<name>_event.dart                  # sealed class
    bloc/<name>_state.dart                  # *Error state holds String message
    bloc/<name>_bloc.dart                   # .fold() only, no try/catch
    screens/<name>_screen.dart              # BlocBuilder/Consumer
```

After each feature: run `build_runner`, run `flutter analyze`.

---

## Completion Criteria

A phase is **done** when:
1. `flutter analyze` — zero errors, zero warnings
2. `flutter pub run build_runner build` — succeeds cleanly
3. All checklist items in that phase are ticked
4. No layer violations (BLoC never imports Dio, View never imports Repository)
5. No repository method throws — all return `Either<Failure, T>`
6. No BLoC method uses `try/catch` — all use `.fold()` on `Either`
