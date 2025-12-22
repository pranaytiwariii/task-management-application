import {
  Task,
  CreateTaskRequest,
  UpdateTaskRequest,
} from "../validators/task.schema";
import { TaskRepository } from "../repositories/task.repository";
import { ClassificationUtil } from "../utils/classification.util";

export class TaskService {
  private taskRepository: TaskRepository;

  constructor() {
    this.taskRepository = new TaskRepository();
  }

  /**
   * Get tasks with optional filtering and pagination
   */
  async getTasks(filters: {
    limit: number;
    offset: number;
    status?: string;
    category?: string;
    priority?: string;
  }): Promise<{
    tasks: Task[];
    pagination: {
      limit: number;
      offset: number;
      count: number;
    };
  }> {
    const result = await this.taskRepository.getTasks(filters);
    return result;
  }

  /**
   * Get a task by ID with its history
   */
  async getTaskById(
    taskId: string
  ): Promise<{ task: Task; history: any[] } | null> {
    // Step 1: Fetch task
    const task = await this.taskRepository.getTaskById(taskId);
    if (!task) {
      return null;
    }

    // Step 2: Fetch task history
    const history = await this.taskRepository.getTaskHistoryByTaskId(taskId);

    // Step 3: Return combined result
    return {
      task,
      history,
    };
  }

  /**
   * Update an existing task
   */
  async updateTask(
    taskId: string,
    updates: UpdateTaskRequest
  ): Promise<Task | null> {
    // Step 1: Fetch existing task
    const existingTask = await this.taskRepository.getTaskById(taskId);
    if (!existingTask) {
      return null;
    }

    // Step 2: Prepare update object with only provided fields
    const updateFields: any = {};
    const oldValues: Record<string, unknown> = {};
    const newValues: Record<string, unknown> = {};

    // Only add fields that are explicitly provided
    if (updates.title !== undefined) {
      updateFields.title = updates.title;
      oldValues.title = existingTask.title;
      newValues.title = updates.title;
    }

    if (updates.description !== undefined) {
      updateFields.description = updates.description;
      oldValues.description = existingTask.description;
      newValues.description = updates.description;
    }

    if (updates.status !== undefined) {
      updateFields.status = updates.status;
      oldValues.status = existingTask.status;
      newValues.status = updates.status;
    }

    if (updates.category !== undefined) {
      updateFields.category = updates.category;
      oldValues.category = existingTask.category;
      newValues.category = updates.category;
    }

    if (updates.priority !== undefined) {
      updateFields.priority = updates.priority;
      oldValues.priority = existingTask.priority;
      newValues.priority = updates.priority;
    }

    if (updates.assigned_to !== undefined) {
      updateFields.assigned_to = updates.assigned_to;
      oldValues.assigned_to = existingTask.assigned_to;
      newValues.assigned_to = updates.assigned_to;
    }

    if (updates.due_date !== undefined) {
      updateFields.due_date = updates.due_date;
      oldValues.due_date = existingTask.due_date;
      newValues.due_date = updates.due_date;
    }

    // Step 3: If no fields to update, return existing task
    if (Object.keys(updateFields).length === 0) {
      return existingTask;
    }

    // Step 4: Update task in database
    const updatedTask = await this.taskRepository.updateTask(
      taskId,
      updateFields
    );

    // Step 5: Create history entry with only changed fields
    await this.taskRepository.createTaskHistory({
      task_id: taskId,
      action: "updated",
      old_value: Object.keys(oldValues).length > 0 ? oldValues : null,
      new_value: Object.keys(newValues).length > 0 ? newValues : null,
      changed_by: null,
    });

    return updatedTask;
  }

  /**
   * Delete a task by ID
   */
  async deleteTask(taskId: string): Promise<boolean> {
    // Step 1: Check if task exists
    const existingTask = await this.taskRepository.getTaskById(taskId);
    if (!existingTask) {
      return false;
    }

    // Step 2: Delete task from database
    // Note: task_history will be automatically deleted due to ON DELETE CASCADE
    await this.taskRepository.deleteTaskById(taskId);

    return true;
  }

  /**
   * Create a new task with classification and entity extraction
   */
  async createTask(request: CreateTaskRequest): Promise<Task> {
    // Step 1: Classify category
    const category = ClassificationUtil.classifyCategory(
      request.title,
      request.description
    );

    // Step 2: Classify priority
    const priority = ClassificationUtil.classifyPriority(
      request.title,
      request.description
    );

    // Step 3: Extract entities
    const extractedEntities = ClassificationUtil.extractEntities(
      request.title,
      request.description,
      request.assigned_to
    );

    // Step 4: Get suggested actions
    const suggestedActions = ClassificationUtil.getSuggestedActions(category);

    // Step 5: Create task in database
    const task = await this.taskRepository.createTask({
      title: request.title,
      description: request.description || null,
      category,
      priority,
      assigned_to: request.assigned_to || null,
      due_date: request.due_date || null,
      extracted_entities: extractedEntities,
      suggested_actions: suggestedActions,
    });

    // Step 6: Create history entry for task creation
    await this.taskRepository.createTaskHistory({
      task_id: task.id,
      action: "created",
      old_value: null,
      new_value: {
        title: task.title,
        category: task.category,
        priority: task.priority,
        status: task.status,
      },
      changed_by: null,
    });

    return task;
  }
}
