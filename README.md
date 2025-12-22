# Task Management Backend

TypeScript backend application using Express and PostgreSQL.

## Setup

### Install Dependencies

```bash
npm install
```

### Environment Variables

Create a `.env` file with the following variables:

```
DATABASE_URL=postgresql://username:password@localhost:5432/task_management
NODE_ENV=development
PORT=5000
```

### Database Setup

1. Create PostgreSQL database:

```sql
CREATE DATABASE task_management;
```

2. Run migrations (create your migration files)

## Scripts

- `npm run dev` - Start development server with ts-node
- `npm run build` - Compile TypeScript to JavaScript
- `npm run watch` - Watch mode for TypeScript compilation
- `npm start` - Start production server
- `npm run lint` - Run ESLint

## Project Structure

```
backend/
├── src/
│   ├── app.ts              # Express app configuration
│   ├── server.ts           # Server entry point
│   ├── controllers/        # Request handlers
│   ├── middlewares/        # Custom middleware
│   ├── models/             # Database models
│   ├── routes/             # API routes
│   ├── services/           # Business logic
│   └── utils/              # Utility functions
├── config/
│   └── db.ts               # Database connection
├── dist/                   # Compiled JavaScript (generated)
├── .env                    # Environment variables
├── .gitignore              # Git ignore file
├── package.json            # Dependencies
└── tsconfig.json           # TypeScript configuration
```

## API Endpoints

- `GET /health` - Health check endpoint

## Getting Started

1. Install dependencies: `npm install`
2. Configure `.env` file with your database URL
3. Run development server: `npm run dev`
4. Server will start on port 5000 (or custom PORT)
