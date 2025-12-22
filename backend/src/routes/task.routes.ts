import { Router } from "express";
import { TaskController } from "../controllers/task.controller";

const router = Router();
const taskController = new TaskController();

/**
 * GET /api/tasks
 * Retrieve tasks with optional filtering and pagination
 */
router.get("/", (req, res) => taskController.getTasks(req, res));

/**
 * GET /api/tasks/:id
 * Get a specific task by ID with its history
 */
router.get("/:id", (req, res) => taskController.getTaskById(req, res));

/**
 * POST /api/tasks
 * Create a new task
 */
router.post("/", (req, res) => taskController.createTask(req, res));

/**
 * PATCH /api/tasks/:id
 * Update a task
 */
router.patch("/:id", (req, res) => taskController.updateTask(req, res));

/**
 * DELETE /api/tasks/:id
 * Delete a task
 */
router.delete("/:id", (req, res) => taskController.deleteTask(req, res));

export default router;
