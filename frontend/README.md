# Task Management App — Flutter Frontend

> **📖 For complete project overview, setup instructions, and deployment details, see the [root README](../README.md)**

This document contains Flutter-specific implementation details for the Task Management Application mobile interface.

## Overview

The Flutter app implements a single, comprehensive Task Dashboard screen with create/edit task functionality, robust API integration, and production-quality UX following Material Design 3.

**Key Technologies:**

- State management: Riverpod
- Networking: Dio with interceptors (auth, logging, error normalization)
- UI: Material Design 3, dark mode, skeleton loaders, pull-to-refresh, offline indicator
- Validation: Server-side via Joi/Zod (Node.js backend) and client-side form validation in Flutter
- Environment variables: All secrets configured via dart-define at runtime

## Features Implemented

### Task Dashboard

- Task list with:
  - Title
  - Category (color-coded chip)
  - Priority badge
  - Status indicator
  - Due date & assigned person
- Pull-to-refresh
- Search tasks with highlighting
- Filter by:
  - Category
  - Priority
  - Status
- Sorting options (e.g., by due date, priority)
- Task counts by status (Pending, In Progress, Completed)
- Quick filters by category and priority

### Create / Edit Task

- Bottom sheet form
- Input validation
- Fields:
  - Title (required)
  - Description (multiline, required)
  - Requirements (optional)
  - Assigned to (text field)
  - Due date (date picker)
- Displays auto-generated classification (category/priority) before saving
- Allows user to override category & priority if needed

### UI / UX

- Floating Action Button (FAB) to create tasks
- Clean, responsive layout following Material Design 3
- Dark mode support
- Loading indicators & skeleton loaders
- Error handling with Snackbars/Dialog with friendly messages
- Offline indicator (shows when network is unavailable)

### Integration & Quality

- Dio for API calls with proper interceptors (auth headers, logging, unified error mapping)
- Riverpod or Provider for robust state management
- Pagination on list endpoints (`limit`, `offset`)
- Filtering and sorting options via query params
- Environment variables for secrets and API base URL
- Export tasks to CSV

## Tech Stack

- Flutter 3, Dart
- Riverpod (or Provider)
- Dio
- Material Design 3

## Requirements Mapping

This app satisfies the assignment requirements:

- Task Dashboard with summary cards, task list, and bottom sheet form
- Validation (client-side) and meaningful error handling
- Pagination (`limit`, `offset`), filtering, sorting on list endpoints
- At least 3 unit tests for classification logic are present in backend
- Environment variables for secrets
- Task status counts and quick filters
- FAB for task creation
- Rich list item UI (title, chips, badges, due date, assignee, status)
- Pull-to-refresh, search with highlighting, and filter options
- Form includes Title, Description, Requirements, Due Date, Assigned To
- Pre-save auto classification with override capabilities
- Dark mode support, CSV export, MD3 UI, skeleton loaders
- Offline indicator, Riverpod/Provider, Dio interceptors, form validation

## Project Structure

- Flutter app sources are under [frontend/lib](lib)
- Widget test scaffolding: [frontend/test/widget_test.dart](test/widget_test.dart)
- Backend integration examples can reference your deployed API base URL

## Environment Variables

Supply environment values with `--dart-define` at run/build time:

```bash
flutter run \
	--dart-define=API_BASE_URL=https://<your-render-service>.onrender.com \
	--dart-define=ENV=prod
```

Common keys:

- `API_BASE_URL`: Base URL of the deployed backend on Render
- `ENV`: Environment label (e.g., `dev`, `staging`, `prod`)
- Any other secrets should be injected via `--dart-define` or managed by the backend

## Setup (Windows)

1. Install Flutter SDK and ensure `flutter doctor` passes
2. Install Android Studio / VS Code with Flutter/Dart plugins
3. In the `frontend` directory:

```powershell
flutter pub get
```

4. Run the app (replace the base URL):

```powershell
flutter run --dart-define=API_BASE_URL=https://<your-render-service>.onrender.com --dart-define=ENV=dev
```

5. Build for release (Android APK example):

```powershell
flutter build apk --dart-define=API_BASE_URL=https://<your-render-service>.onrender.com --dart-define=ENV=prod
```

## API Integration

- The list endpoint supports pagination, filtering, and sorting via query parameters:

```
GET /tasks?limit=20&offset=0&category=work&priority=high&status=pending&sort=dueDate:asc
```

- The create/edit form shows auto-generated classification prior to submission (category, priority). Users can override before saving.
- Errors are normalized by Dio interceptors to show friendly messages in Snackbars/Dialog.

### Dio Interceptors (Concept)

```dart
final dio = Dio(BaseOptions(baseUrl: const String.fromEnvironment('API_BASE_URL')))
	..interceptors.addAll([
		InterceptorsWrapper(
			onRequest: (options, handler) {
				// Example: attach auth headers if available
				// options.headers['Authorization'] = 'Bearer <token>';
				handler.next(options);
			},
			onResponse: (response, handler) => handler.next(response),
			onError: (error, handler) {
				// Map to user-friendly error messages
				handler.next(error);
			},
		),
		LogInterceptor(responseBody: false),
	]);
```

### Riverpod (Concept)

```dart
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
	final dio = ref.read(dioProvider);
	return TaskRepository(dio);
});

final taskListProvider = StateNotifierProvider<TaskListController, AsyncValue<List<Task>>>((ref) {
	final repo = ref.read(taskRepositoryProvider);
	return TaskListController(repo);
});
```

## CSV Export

- The UI includes an "Export to CSV" action to download or share current tasks as a CSV file.
- Export respects current filters/search where applicable.

## Testing

### Backend (Classification Logic)

- Run Jest tests from the backend folder:

```powershell
cd ../backend
npm install
npm test
```

- Tests include at least 3 unit cases for the classification utility (see [backend/tests/classification.util.test.ts](../backend/tests/classification.util.test.ts)).

### Flutter

- Run widget/unit tests:

```powershell
cd ../frontend
flutter test
```

## Deployment (Backend on Render)

1. Push backend to GitHub
2. Create a new Render Web Service and connect the repo
3. Set build command and start command according to backend `package.json`
   - Build: `npm install && npm run build`
   - Start: `npm run start`
4. Configure environment variables (e.g., database credentials, JWT secrets)
5. Deploy and note the service URL (e.g., `https://<your-service>.onrender.com`)
6. Use that URL via `--dart-define=API_BASE_URL` for the Flutter app

## Error Handling & Offline

- Snackbars and Dialogs display friendly error messages
- Offline indicator shows when there is no network; actions gracefully degrade
- Skeleton loaders and progress indicators are shown during fetching/processing

## Dark Mode

- Follows system theme with Material Design 3
- Uses distinct color schemes for light/dark

## Form Validation

- Client-side validation ensures required fields and basic constraints
- Server-side validation is performed by backend (Joi/Zod)

## Troubleshooting

- Wrong API base URL: confirm `--dart-define=API_BASE_URL` is set correctly
- CORS errors: configure backend CORS to allow your app
- Build issues: run `flutter clean` then `flutter pub get`
- Device not detected: ensure Android emulator is running or connect a device

---

For code references, see:

- Main entry: [frontend/lib/main.dart](lib/main.dart)
- Tests: [frontend/test/widget_test.dart](test/widget_test.dart)
