import { Request, Response } from "express";
import { createTaskSchema, updateTaskSchema } from "../validators/task.schema";
import { TaskService } from "../services/task.service";
import { z } from "zod";

export class TaskController {
  private taskService: TaskService;

  constructor() {
    this.taskService = new TaskService();
  }

  /**
   * Get tasks with optional filtering and pagination
   * GET /api/tasks
   */
  async getTasks(req: Request, res: Response): Promise<void> {
    try {
      // Extract and parse query parameters
      const limit = Math.min(parseInt(req.query.limit as string) || 10, 100);
      const offset = parseInt(req.query.offset as string) || 0;
      const status = (req.query.status as string) || undefined;
      const category = (req.query.category as string) || undefined;
      const priority = (req.query.priority as string) || undefined;

      // Call service to get tasks
      const result = await this.taskService.getTasks({
        limit,
        offset,
        status,
        category,
        priority,
      });

      // Return response
      res.status(200).json({
        success: true,
        data: result,
      });
    } catch (error) {
      this.handleError(error, res);
    }
  }

  /**
   * Create a new task
   * POST /api/tasks
   */
  async createTask(req: Request, res: Response): Promise<void> {
    try {
      // Validate request body
      const validatedData = createTaskSchema.parse(req.body);

      // Call service to create task
      const task = await this.taskService.createTask(validatedData);

      // Return response
      res.status(201).json({
        success: true,
        message: "Task created successfully",
        data: task,
      });
    } catch (error) {
      this.handleError(error, res);
    }
  }

  /**
   * Get a task by ID with its history
   * GET /api/tasks/:id
   */
  async getTaskById(req: Request, res: Response): Promise<void> {
    try {
      const taskId = req.params.id;

      // Validate UUID format
      if (!this.isValidUUID(taskId)) {
        res.status(400).json({
          success: false,
          message: "Invalid task ID format",
        });
        return;
      }

      // Call service to get task with history
      const result = await this.taskService.getTaskById(taskId);

      if (!result) {
        res.status(404).json({
          success: false,
          message: "Task not found",
        });
        return;
      }

      // Return response
      res.status(200).json({
        success: true,
        data: result,
      });
    } catch (error) {
      this.handleError(error, res);
    }
  }

  /**
   * Update a task
   * PATCH /api/tasks/:id
   */
  async updateTask(req: Request, res: Response): Promise<void> {
    try {
      const taskId = req.params.id;

      // Validate UUID format
      if (!this.isValidUUID(taskId)) {
        res.status(400).json({
          success: false,
          message: "Invalid task ID format",
        });
        return;
      }

      // Validate request body
      const validatedData = updateTaskSchema.parse(req.body);

      // Call service to update task
      const task = await this.taskService.updateTask(taskId, validatedData);

      if (!task) {
        res.status(404).json({
          success: false,
          message: "Task not found",
        });
        return;
      }

      // Return response
      res.status(200).json({
        success: true,
        message: "Task updated successfully",
        data: task,
      });
    } catch (error) {
      this.handleError(error, res);
    }
  }

  /**
   * Delete a task
   * DELETE /api/tasks/:id
   */
  async deleteTask(req: Request, res: Response): Promise<void> {
    try {
      const taskId = req.params.id;

      // Validate UUID format
      if (!this.isValidUUID(taskId)) {
        res.status(400).json({
          success: false,
          message: "Invalid task ID format",
        });
        return;
      }

      // Call service to delete task
      const deleted = await this.taskService.deleteTask(taskId);

      if (!deleted) {
        res.status(404).json({
          success: false,
          message: "Task not found",
        });
        return;
      }

      // Return response
      res.status(200).json({
        success: true,
        message: "Task deleted successfully",
      });
    } catch (error) {
      this.handleError(error, res);
    }
  }

  /**
   * Validate UUID format
   */
  private isValidUUID(uuid: string): boolean {
    const uuidRegex =
      /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    return uuidRegex.test(uuid);
  }

  /**
   * Handle errors from validation and service
   */
  private handleError(error: unknown, res: Response): void {
    if (error instanceof z.ZodError) {
      res.status(400).json({
        success: false,
        message: "Validation failed",
        errors: error.issues.map((issue: z.ZodIssue) => ({
          field: issue.path.join("."),
          message: issue.message,
        })),
      });
    } else if (error instanceof Error) {
      console.error("Error:", error.message);
      res.status(500).json({
        success: false,
        message: "Internal server error",
        error: error.message,
      });
    } else {
      res.status(500).json({
        success: false,
        message: "Unknown error occurred",
      });
    }
  }
}
