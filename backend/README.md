# Task Management Backend

A professional Node.js/Express backend application for task management with automatic classification, priority detection, and comprehensive REST API.

## Table of Contents

- [Project Overview](#project-overview)
- [Tech Stack](#tech-stack)
- [Setup Instructions](#setup-instructions)
- [API Documentation](#api-documentation)
- [Database Schema](#database-schema)
- [Classification Logic](#classification-logic)
- [Deployment](#deployment)
- [What I'd Improve](#what-id-improve)

---

## Project Overview

This backend provides a complete task management system with:

- **Auto-Classification**: Intelligently categorizes tasks (scheduling, finance, technical, safety, general)
- **Priority Detection**: Automatically detects task priority (high, medium, low)
- **Entity Extraction**: Extracts keywords and assigned personnel from task descriptions
- **Full CRUD Operations**: Complete Create, Read, Update, Delete functionality
- **Audit Trail**: Tracks all changes with history records
- **RESTful API**: Professional API endpoints with proper HTTP status codes

### Key Features

✅ Automatic task classification by keywords  
✅ Priority level detection  
✅ Entity extraction (keywords, assigned person)  
✅ Task history/audit trail tracking  
✅ Full CRUD API endpoints  
✅ Comprehensive unit tests (86+ tests, 100% coverage)

---

## Tech Stack

**Backend Framework:**

- Node.js + Express.js
- TypeScript (strict mode)

**Database:**

- PostgreSQL 12+
- Direct SQL queries (no ORM)

**Testing:**

- Jest framework
- ts-jest for TypeScript support

**Code Quality:**

- ESLint
- TypeScript compiler

**Build & Runtime:**

- ts-node for development
- Compiled JavaScript for production

---

## Setup Instructions

### Prerequisites

- Node.js 16+
- PostgreSQL 12+
- npm or yarn

### Installation

1. **Clone the repository**

```bash
git clone <repository-url>
cd backend
```

2. **Install dependencies**

```bash
npm install
```

3. **Configure environment variables**

```bash
# Copy the example file
cp .env.example .env

# Edit .env with your database credentials
# DATABASE_URL=postgresql://username:password@localhost:5432/task_management
# PORT=5000
# NODE_ENV=development
```

4. **Create PostgreSQL database**

```bash
psql -U postgres
CREATE DATABASE task_management;
\q
```

5. **Initialize database schema** (tables will be created automatically on first request)

6. **Start the development server**

```bash
npm run dev
```

The server will start on `http://localhost:5000`

### Available Scripts

```bash
npm run dev              # Start development server with hot reload
npm run server           # Start with nodemon (file watching)
npm run build            # Compile TypeScript to JavaScript
npm run watch            # Watch TypeScript compilation
npm start                # Run production build
npm test                 # Run Jest unit tests once
npm run test:watch       # Run tests in watch mode
npm run test:coverage    # Generate coverage report
npm run lint             # Run ESLint
```

---

## API Documentation

### Base URL

```
http://localhost:5000/api
```

### 1. Create Task

**POST** `/tasks`

Creates a new task with automatic classification and priority detection.

**Request Body:**

```json
{
  "title": "Schedule urgent meeting with team",
  "description": "Discuss project timeline and deliverables",
  "assigned_to": "john@example.com"
}
```

**Response (201):**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "Schedule urgent meeting with team",
    "description": "Discuss project timeline and deliverables",
    "category": "scheduling",
    "priority": "high",
    "assigned_to": "john@example.com",
    "status": "pending",
    "created_at": "2025-12-22T10:30:00Z",
    "updated_at": "2025-12-22T10:30:00Z"
  }
}
```

---

### 2. Get All Tasks

**GET** `/tasks`

Retrieves all tasks with filtering and pagination.

**Query Parameters:**

- `category` (optional): Filter by category (scheduling, finance, technical, safety, general)
- `priority` (optional): Filter by priority (high, medium, low)
- `status` (optional): Filter by status (pending, in_progress, completed)
- `page` (optional, default: 1): Page number for pagination
- `limit` (optional, default: 10): Items per page

**Example:**

```bash
GET /tasks?category=scheduling&priority=high&page=1&limit=5
```

**Response (200):**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "title": "Schedule meeting",
      "category": "scheduling",
      "priority": "high",
      "status": "pending",
      "created_at": "2025-12-22T10:30:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 5,
    "total": 25
  }
}
```

---

### 3. Get Task by ID

**GET** `/tasks/:id`

Retrieves a specific task with complete history.

**Response (200):**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "Schedule meeting",
    "description": "Team sync",
    "category": "scheduling",
    "priority": "high",
    "assigned_to": "john@example.com",
    "status": "pending",
    "created_at": "2025-12-22T10:30:00Z",
    "updated_at": "2025-12-22T10:30:00Z",
    "history": [
      {
        "id": 1,
        "task_id": 1,
        "action": "created",
        "changes": null,
        "changed_by": "system",
        "timestamp": "2025-12-22T10:30:00Z"
      }
    ]
  }
}
```

---

### 4. Update Task

**PATCH** `/tasks/:id`

Updates a task and records changes in history.

**Request Body:**

```json
{
  "title": "Updated task title",
  "status": "in_progress"
}
```

**Response (200):**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "Updated task title",
    "status": "in_progress",
    "updated_at": "2025-12-22T11:00:00Z"
  }
}
```

---

### 5. Delete Task

**DELETE** `/tasks/:id`

Deletes a task and all associated history records.

**Response (200):**

```json
{
  "success": true,
  "message": "Task deleted successfully"
}
```

---

### Error Responses

**400 Bad Request:**

```json
{
  "success": false,
  "error": "Validation failed",
  "details": ["Title is required", "Title must be at least 3 characters"]
}
```

**404 Not Found:**

```json
{
  "success": false,
  "error": "Task not found"
}
```

**500 Internal Server Error:**

```json
{
  "success": false,
  "error": "Internal server error"
}
```

---

## Database Schema

### Tables

#### `tasks`

Main tasks table storing task information.

| Column      | Type         | Constraints       | Description              |
| ----------- | ------------ | ----------------- | ------------------------ |
| id          | SERIAL       | PRIMARY KEY       | Unique task identifier   |
| title       | VARCHAR(255) | NOT NULL          | Task title               |
| description | TEXT         |                   | Detailed description     |
| category    | VARCHAR(50)  | NOT NULL          | Auto-classified category |
| priority    | VARCHAR(20)  | NOT NULL          | Auto-detected priority   |
| assigned_to | VARCHAR(255) |                   | Person assigned to task  |
| status      | VARCHAR(20)  | DEFAULT 'pending' | Task status              |
| created_at  | TIMESTAMP    | DEFAULT NOW()     | Creation timestamp       |
| updated_at  | TIMESTAMP    | DEFAULT NOW()     | Last update timestamp    |

#### `task_history`

Audit trail tracking all changes to tasks.

| Column     | Type         | Constraints   | Description                             |
| ---------- | ------------ | ------------- | --------------------------------------- |
| id         | SERIAL       | PRIMARY KEY   | History record ID                       |
| task_id    | INTEGER      | FOREIGN KEY   | Reference to task                       |
| action     | VARCHAR(50)  | NOT NULL      | Action type (created, updated, deleted) |
| changes    | JSONB        |               | JSON object of changed fields           |
| changed_by | VARCHAR(255) |               | User who made the change                |
| timestamp  | TIMESTAMP    | DEFAULT NOW() | When change occurred                    |

### SQL Creation

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

CREATE TABLE task_history (
  id SERIAL PRIMARY KEY,
  task_id INTEGER NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
  action VARCHAR(50) NOT NULL,
  changes JSONB,
  changed_by VARCHAR(255),
  timestamp TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_tasks_category ON tasks(category);
CREATE INDEX idx_tasks_priority ON tasks(priority);
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_task_history_task_id ON task_history(task_id);
```

---

## Classification Logic

The backend automatically classifies tasks using keyword matching. This functionality is thoroughly tested with 86+ unit tests.

### Category Classification

Tasks are categorized into 5 categories based on keywords found in title and description:

#### 1. **Scheduling**

Keywords: meeting, schedule, call, appointment, deadline, conference, standup, sync

Example:

```typescript
classifyCategory("Schedule urgent meeting tomorrow");
// Returns: "scheduling"
```

#### 2. **Finance**

Keywords: payment, invoice, bill, budget, cost, expense, financial, accounting

Example:

```typescript
classifyCategory("Process invoice for Q4 payment");
// Returns: "finance"
```

#### 3. **Technical**

Keywords: bug, fix, error, install, repair, maintain, deploy, code, system

Example:

```typescript
classifyCategory("Fix production bug in payment system");
// Returns: "technical"
```

#### 4. **Safety**

Keywords: safety, hazard, inspection, compliance, ppe, accident, incident

Example:

```typescript
classifyCategory("Conduct safety inspection");
// Returns: "safety"
```

#### 5. **General** (Default)

Used when no category keywords are matched.

### Priority Detection

Priorities are detected based on urgency keywords:

#### High Priority

Keywords: urgent, asap, immediately, critical, emergency, today

#### Medium Priority

Keywords: soon, this week, important, next week

#### Low Priority (Default)

Used when no priority keywords are found.

### Entity Extraction

The system extracts:

- **Keywords**: All detected classification keywords
- **Assigned Person**: From the `assigned_to` field
- **Text Length**: Combined character count of title and description

Example:

```typescript
extractEntities("Schedule meeting", "Process invoice", "john@example.com");
// Returns: {
//   keywords: ["meeting", "invoice"],
//   assigned_person: "john@example.com",
//   text_length: 35
// }
```

### Suggested Actions

Based on category, the system suggests actions:

- **Scheduling**: "Block calendar", "Send invite", "Prepare agenda"
- **Finance**: "Check budget", "Generate invoice", "Process payment"
- **Technical**: "Diagnose issue", "Assign technician", "Create ticket"
- **Safety**: "Conduct inspection", "Notify supervisor", "Document incident"
- **General**: "Review task", "Plan approach", "Assign resource"

---

## Tests

### Running Tests

```bash
# Run all tests
npm test

# Run tests in watch mode (auto-rerun on changes)
npm run test:watch

# Run tests with coverage report
npm run test:coverage
```

### Test Coverage

Current coverage: **100%** of `src/utils/classification.util.ts`

- **86 total tests passing**
- **Category classification**: 26 tests
- **Priority detection**: 23 tests
- **Entity extraction**: 25 tests
- **Suggested actions**: 8 tests
- **Integration scenarios**: 4 tests

Test file: `tests/classification.util.test.ts`

---

## Deployment

### Deployment URL

**Production:** https://task-management-render.onrender.com

### Deployment Instructions

The application is designed to be deployed on Render.com:

1. **Create Render account and link GitHub**
2. **Create PostgreSQL instance** on Render
3. **Create Web Service** from GitHub repository
4. **Configure environment variables** in Render dashboard:
   ```
   DATABASE_URL=postgresql://...
   NODE_ENV=production
   PORT=3000
   ```
5. **Set build command:** `npm install && npm run build`
6. **Set start command:** `npm start`
7. **Deploy** - Service will auto-update on push to main

---

## Project Structure

```
backend/
├── src/
│   ├── app.ts                    # Express app setup
│   ├── server.ts                 # Server entry point
│   ├── config/
│   │   └── db.ts                 # Database connection pool
│   ├── controllers/
│   │   └── task.controller.ts    # Request handlers
│   ├── middlewares/
│   │   └── errorHandler.ts       # Error handling middleware
│   ├── repositories/
│   │   └── task.repository.ts    # Database queries
│   ├── routes/
│   │   └── task.routes.ts        # API route definitions
│   ├── services/
│   │   └── task.service.ts       # Business logic
│   ├── utils/
│   │   └── classification.util.ts # Classification logic
│   └── validators/
│       └── task.schema.ts         # Zod validation schemas
├── tests/
│   └── classification.util.test.ts # Unit tests (86+ tests)
├── jest.config.js               # Jest configuration
├── tsconfig.json                # TypeScript configuration
├── package.json                 # Dependencies
├── .env.example                 # Environment template
├── .gitignore                   # Git ignore rules
└── README.md                    # This file
```

---

## What I'd Improve

Given more time, these enhancements would improve the system:

### 1. **Advanced Classification**

- [ ] ML-based classification using training data
- [ ] Custom keyword mappings per user/organization
- [ ] Weighted keyword scoring

### 2. **Caching**

- [ ] Redis caching for frequently accessed tasks
- [ ] Query result caching
- [ ] Classification result memoization

### 3. **API Enhancements**

- [ ] GraphQL API alternative
- [ ] WebSocket support for real-time updates
- [ ] Batch operations (bulk create/update/delete)
- [ ] Advanced search with full-text indexing

### 4. **Authentication & Authorization**

- [ ] JWT token-based authentication
- [ ] Role-based access control (RBAC)
- [ ] Per-user task isolation
- [ ] Audit logging with user tracking

### 5. **Monitoring & Observability**

- [ ] Request logging with Winston/Pino
- [ ] Performance monitoring
- [ ] Error tracking with Sentry
- [ ] Health check endpoint

### 6. **Database Optimizations**

- [ ] Query optimization with EXPLAIN ANALYZE
- [ ] Archival strategy for old tasks
- [ ] Connection pooling configuration tuning

### 7. **Testing Enhancements**

- [ ] Integration tests with database
- [ ] End-to-end API tests
- [ ] Performance/load testing
- [ ] Contract testing for API stability

### 8. **Documentation**

- [ ] OpenAPI/Swagger documentation
- [ ] API client SDK generation
- [ ] Architecture decision records (ADRs)

### 9. **DevOps**

- [ ] Docker containerization
- [ ] CI/CD pipeline improvements
- [ ] Kubernetes deployment configs
- [ ] Infrastructure as Code (IaC)

### 10. **Developer Experience**

- [ ] Hot module reloading in development
- [ ] Better error messages and debugging
- [ ] Request/response logging middleware
- [ ] Database seeding scripts

---

## License

ISC

---

**Last Updated:** December 22, 2025
