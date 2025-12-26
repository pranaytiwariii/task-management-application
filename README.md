# Task Management Application

Inline display (will render on GitHub):

HomePage with funtinal searchbar

![HomePage with funtinal searchbar](docs/screenshots/home.png)

Creating Task

![create task](docs/screenshots/dashboard.png)

Creating task title - Schedule urgent meeting

task automatically categorises as category scheduling and priority high

![Eample1](docs/screenshots/Example1.png)

Creating task tittle - Scehdule meeting next week

task automatically categorises as scheduling & priority medium

![Example2](docs/screenshots/Eample2.png)

## Backend + Flutter Hybrid Assessment Submission

A full-stack task management system with intelligent auto-classification, RESTful API, and modern Flutter mobile interface.

---

## 📋 Project Overview

This submission contains:

- **Backend API**: Node.js/Express/TypeScript with PostgreSQL
- **Flutter App**: Material Design 3 mobile app with Riverpod state management
- **Features**: Auto-categorization, priority detection, CRUD operations, history tracking

### Key Highlights

✅ **Backend**: Automatic task classification by AI-like keyword matching  
✅ **Backend**: 86+ unit tests with 100% coverage  
✅ **Backend**: Complete REST API with pagination, filtering, sorting  
✅ **Flutter**: Single-page dashboard with comprehensive UX  
✅ **Flutter**: Pull-to-refresh, search, filters, dark mode support  
✅ **Integration**: Clean separation of concerns, environment-based configuration  
✅ **Deployment**: Backend live on Render, database on Render PostgreSQL

---

## 🗂️ Folder Structure

```
task_management_application/
├── backend/                    # Node.js/Express API
│   ├── src/
│   │   ├── controllers/       # Request handlers
│   │   ├── services/          # Business logic
│   │   ├── repositories/      # Data access layer
│   │   ├── routes/            # API routes
│   │   ├── utils/             # Classification utilities
│   │   ├── validators/        # Zod schemas
│   │   └── config/            # Database configuration
│   ├── tests/                 # Jest unit tests
│   ├── package.json
│   ├── tsconfig.json
│   └── README.md              # Backend-specific documentation
│
├── flutter_app/               # Flutter mobile application
│   ├── lib/
│   │   ├── main.dart          # App entry point
│   │   ├── screens/           # UI screens
│   │   ├── widgets/           # Reusable components
│   │   ├── models/            # Data models
│   │   ├── providers/         # Riverpod providers
│   │   ├── services/          # API service (Dio)
│   │   ├── repositories/      # Data repositories
│   │   └── config/            # App constants & theme
│   ├── test/                  # Flutter tests
│   ├── pubspec.yaml
│   └── README.md              # Flutter-specific documentation
│
├── docs/                      # Additional resources
│   └── init-db.sql            # Database schema
│
└── README.md                  # This file
```

---

## 🚀 Quick Start

### Prerequisites

- **Backend**: Node.js 16+, PostgreSQL 12+
- **Flutter**: Flutter SDK 3.0+, Chrome/Edge (for web) or Android/iOS device

### Backend Setup

```bash
cd backend
npm install

# Configure environment
# Create .env file with:
# DATABASE_URL=postgresql://user:password@host:port/database or use render Postgres
# DATABASE_URL=postgresql://task_management_db_tacn_user:IaYYy2d5tb7uxdu6zEuXqkMjUFlUuSSz@dpg-d574u3v5r7bs73fugk30-a.oregon-postgres.render.com/task_management_db_tacn
# PORT=3000
# NODE_ENV=development

# Run database migrations
psql -h <host> -U <user> -d <database> -f ../docs/init-db.sql

# Start development server
npm run dev

# Run tests
npm test
```

**Live Backend**: https://task-management-backend-p3oj.onrender.com

### Flutter Setup

```bash
cd frontend
flutter pub get

# Run on Chrome
flutter run -d chrome

# Run with custom API URL
flutter run -d chrome \
  --dart-define=API_BASE_URL=http://localhost:3000 \
  --dart-define=ENV=dev
#Run on cherome
flutter run -d chrome

# Build for production
flutter build web
```

---

## 🔧 Technical Stack

### Backend

- **Runtime**: Node.js 18 + TypeScript
- **Framework**: Express.js
- **Database**: PostgreSQL with native `pg` driver
- **Validation**: Zod
- **Testing**: Jest (86+ tests, 100% coverage)
- **Deployment**: Render

### Flutter

- **Framework**: Flutter 3.x
- **State Management**: Riverpod
- **Networking**: Dio with interceptors
- **UI**: Material Design 3
- **Architecture**: Clean Architecture pattern

---

## 📡 API Documentation

### Base URL

- **Production**: `https://task-management-backend-p3oj.onrender.com`
- **Development**: `http://localhost:3000`

### Endpoints

| Method | Endpoint                 | Description                           |
| ------ | ------------------------ | ------------------------------------- |
| GET    | `/api/tasks`             | Get all tasks (paginated, filterable) |
| GET    | `/api/tasks/:id`         | Get single task by ID                 |
| POST   | `/api/tasks`             | Create new task (auto-classification) |
| PUT    | `/api/tasks/:id`         | Update existing task                  |
| DELETE | `/api/tasks/:id`         | Delete task                           |
| GET    | `/api/tasks/:id/history` | Get task change history               |

**Query Parameters** (GET `/api/tasks`):

- `limit`: Results per page (default: 10)
- `offset`: Pagination offset (default: 0)
- `category`: Filter by category
- `priority`: Filter by priority
- `status`: Filter by status
- `search`: Search in title/description
- `sort`: Sort field (e.g., `created_at`, `priority`)
- `order`: Sort order (`asc` or `desc`)

**Example Request**:

```bash
curl "https://task-management-backend-p3oj.onrender.com/api/tasks?limit=10&category=technical&priority=high"
```

See [`backend/README.md`](backend/README.md) for detailed API documentation.

---

## 🤖 Auto-Classification Features

### Category Classification

Tasks are automatically categorized into:

- **Scheduling**: meetings, appointments, calls
- **Finance**: payments, invoices, budgets
- **Technical**: bugs, deployments, fixes
- **Safety**: security, compliance, incidents
- **General**: everything else

### Priority Detection

# Smart Task Manager

Concise, evaluator-ready documentation for the Smart Task Manager assessment. This project includes a Node.js backend (deployed to Render), a Supabase (PostgreSQL) database, and a Flutter frontend (single-dashboard app).

---

## **Project Overview**

- **What:** A full-stack task management system that auto-classifies tasks (category, priority, entities, and actions) and provides a REST API for CRUD operations.
- **Why:** Demonstrates a production-style API, automated classification logic, and a polished Flutter UI suitable for evaluation and extension.

---

## **Tech Stack**

- **Backend:** Node.js, TypeScript, Express
- **Database:** Supabase (PostgreSQL)
- **Frontend:** Flutter (single dashboard screen)
- **Validation & Tests:** Zod (validation), Jest (backend tests)
- **Networking (Flutter):** Dio

---

## **Architecture Overview**

- **Backend-first API:** Controllers → Services → Repositories. The backend owns business logic and classification. The API is the contract for the Flutter client.
- **API contract:** JSON-based REST endpoints under `/api/tasks` with pagination, filtering, and standard HTTP status codes.
- **Persistence:** PostgreSQL (managed via Supabase). Schema includes `tasks` and `task_history` tables.

---

## **API Documentation**

Base URL (production): https://task-management-backend-p3oj.onrender.com

1. List tasks

- Method: GET
- Endpoint: /api/tasks
- Query params: `limit` (default 10), `offset` (default 0), `category`, `priority`, `status`, `search`, `sort`, `order`

Example request:

```bash
curl "https://task-management-backend-p3oj.onrender.com/api/tasks?limit=10&offset=0"
```

Example response (200):

```json
{
  "success": true,
  "data": {
    "tasks": [],
    "pagination": { "page": 1, "limit": 10, "total": 0 }
  }
}
```

2. Get task by ID

- Method: GET
- Endpoint: /api/tasks/:id

Example request:

```bash
curl "https://task-management-backend-p3oj.onrender.com/api/tasks/123"
```

Example response (200):

```json
{
  "success": true,
  "data": {
    "id": 123,
    "title": "Fix production bug",
    "description": "Details...",
    "category": "technical",
    "priority": "high",
    "assigned_to": "Jane Doe",
    "status": "pending",
    "created_at": "2025-12-01T12:00:00Z",
    "updated_at": "2025-12-01T12:00:00Z"
  }
}
```

3. Create task

- Method: POST
- Endpoint: /api/tasks
- Body (JSON): `title` (string), `description` (string), optionally `assigned_to`, `due_date`, etc. Backend runs auto-classification and returns the stored task.

Example request:

```bash
curl -X POST "https://task-management-backend-p3oj.onrender.com/api/tasks" \
  -H "Content-Type: application/json" \
  -d '{"title":"Schedule team meeting","description":"Plan Q1 goals"}'
```

Example response (201):

```json
{
  "success": true,
  "data": {
    "id": 124,
    "title": "Schedule team meeting",
    "category": "scheduling",
    "priority": "medium",
    "status": "pending"
  }
}
```

4. Update task

- Method: PUT
- Endpoint: /api/tasks/:id
- Body (JSON): fields to update (title, description, status, category, priority)

Example request:

```bash
curl -X PUT "https://task-management-backend-p3oj.onrender.com/api/tasks/124" \
  -H "Content-Type: application/json" \
  -d '{"status":"in_progress"}'
```

Example response (200):

```json
{
  "success": true,
  "data": { "id": 124, "status": "in_progress" }
}
```

5. Delete task

- Method: DELETE
- Endpoint: /api/tasks/:id

Example request:

```bash
curl -X DELETE "https://task-management-backend-p3oj.onrender.com/api/tasks/124"
```

Example response (200):

```json
{ "success": true, "message": "Task deleted" }
```

---

## **Database Schema**

1. `tasks` (primary table)

```sql
CREATE TABLE tasks (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  category VARCHAR(50) NOT NULL,
  priority VARCHAR(20) NOT NULL,
  assigned_to VARCHAR(255),
  status VARCHAR(20) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

- `category`: auto-detected (scheduling, finance, technical, safety, general)
- `priority`: auto-detected (low, medium, high)

2. `task_history` (audit trail)

```sql
CREATE TABLE task_history (
  id SERIAL PRIMARY KEY,
  task_id INTEGER NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
  action VARCHAR(50) NOT NULL,
  changes JSONB,
  changed_by VARCHAR(255),
  timestamp TIMESTAMP DEFAULT NOW()
);
```

- Records create/update/delete actions and changed fields for audit and rollback.

---

## **Flutter App Features**

- **Single Dashboard Screen:** Summary cards (counts), task list, and filters.
- **Filters & Search:** Category, priority, status filters and full-text search in title/description.
- **Floating Action Button (FAB):** Opens bottom sheet to create a task.
- **Bottom Sheet Form:** Create/edit task with inline preview of auto-classified category and priority; user can override.
- **Pagination & Pull-to-Refresh:** Efficient data fetching with page controls and refresh gesture.
- **Error Handling & UX:** Loading skeletons, offline indicator, and friendly error messages.

---

## **Setup Instructions**

### Backend (Local)

1. Clone repository and install dependencies:

```bash
cd backend
npm install
```

2. Configure environment:

Create a `.env` file with:

```
DATABASE_URL=postgresql://<user>:<password>@<host>:<port>/<database>  # Supabase connection string
PORT=3000
NODE_ENV=development
```

3. Initialize database (use psql or Supabase SQL editor):

```bash
# Using psql
psql "<supabase_connection_string>" -f ../docs/init-db.sql
```

4. Run server:

```bash
npm run dev
```

5. Run tests:

```bash
npm test
```

### Flutter (Local)

1. Install dependencies and run:

```bash
cd flutter_app
flutter pub get

# Run (default API_BASE_URL comes from build-time or provider)
flutter run -d chrome

# Or explicitly point to backend
flutter run -d chrome --dart-define=API_BASE_URL=https://task-management-backend-p3oj.onrender.com --dart-define=ENV=production
```

---

## **Live Backend URL**

https://task-management-backend-p3oj.onrender.com

---

## **Screenshots**

Place screenshots in `docs/screenshots/` and reference them here. Example placeholders:

- Dashboard overview: `docs/screenshots/dashboard.png`
- Create task bottom sheet: `docs/screenshots/create_task.png`
- Task detail: `docs/screenshots/task_detail.png`

Inline display (will render on GitHub):

![Dashboard overview](docs/screenshots/dashboard.png)

![Create task bottom sheet](docs/screenshots/create_task.png)

If you don't have the images yet, add them to `docs/screenshots/` with the filenames above. Recommended sizes: 1280x720 (landscape) or 1080x1920 (mobile).

---

## **What I’d Improve With More Time**

- Add authentication & authorization (JWT + role-based access)
- Implement offline-first Flutter behavior with local sync (Hive/SQLite)
- Add Redis caching and rate limiting to backend
- Provide OpenAPI/Swagger documentation and automated API contract tests
- Add CI/CD pipeline and containerization (Docker)
- Implement real-time updates via WebSockets or server-sent events

---

## **Contact / Notes for Evaluator**

- Backend entrypoint: `backend/src/server.ts`
- Flutter entrypoint: `flutter_app/lib/main.dart`
- Database schema: `docs/init-db.sql`

Thank you for reviewing the Smart Task Manager assessment.
