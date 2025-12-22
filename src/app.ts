import express, { Express, Request, Response, NextFunction } from "express";
import cors from "cors";
import bodyParser from "body-parser";
import dotenv from "dotenv";
import pool from "./config/db";
import taskRoutes from "./routes/task.routes";

dotenv.config();

const app: Express = express();

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Health check route
app.get("/health", (_req: Request, res: Response) => {
  res.status(200).json({ status: "OK", message: "Server is running" });
});

// Database connection check route
app.get("/db-check", async (_req: Request, res: Response) => {
  try {
    await pool.query("SELECT NOW()");
    res.status(200).json({
      status: "OK",
      message: "Database connection successful",
    });
  } catch (error: any) {
    res.status(500).json({
      status: "ERROR",
      message: "Database connection failed",
      error: error.message,
    });
  }
});

// API Routes
app.use("/api/tasks", taskRoutes);

// Error handling middleware
app.use((err: any, _req: Request, res: Response, _next: NextFunction) => {
  console.error("Error:", err);
  res.status(err.status || 500).json({
    error: {
      message: err.message || "Internal Server Error",
      status: err.status || 500,
    },
  });
});

export default app;
