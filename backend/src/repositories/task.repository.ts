import pool from "../config/db";
import { Task, TaskHistory } from "../validators/task.schema";

export class TaskRepository {
  /**
   * Get a task by ID
   */
  async getTaskById(id: string): Promise<Task | null> {
    const query = "SELECT * FROM tasks WHERE id = $1";
    const result = await pool.query(query, [id]);

    if (result.rows.length === 0) {
      return null;
    }

    return this.mapRowToTask(result.rows[0]);
  }

  /**
   * Get task history by task ID
   */
  async getTaskHistoryByTaskId(taskId: string): Promise<TaskHistory[]> {
    const query = `
      SELECT * FROM task_history
      WHERE task_id = $1
      ORDER BY changed_at DESC
    `;

    const result = await pool.query(query, [taskId]);
    return result.rows.map((row) => this.mapRowToTaskHistory(row));
  }

  /**
   * Update a task
   */
  async updateTask(id: string, updates: Record<string, any>): Promise<Task> {
    // Build dynamic UPDATE query
    const setClauses: string[] = [];
    const values: any[] = [];
    let paramCount = 1;

    for (const [key, value] of Object.entries(updates)) {
      setClauses.push(`${key} = $${paramCount}`);
      values.push(value);
      paramCount++;
    }

    // Always update the updated_at timestamp
    setClauses.push(`updated_at = NOW()`);

    const query = `
      UPDATE tasks
      SET ${setClauses.join(", ")}
      WHERE id = $${paramCount}
      RETURNING *
    `;

    values.push(id);
    const result = await pool.query(query, values);
    return this.mapRowToTask(result.rows[0]);
  }

  /**
   * Delete a task by ID
   */
  async deleteTaskById(id: string): Promise<void> {
    const query = "DELETE FROM tasks WHERE id = $1";
    await pool.query(query, [id]);
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
      page: number;
      limit: number;
      total: number;
    };
  }> {
    // Build dynamic WHERE clause
    const whereConditions: string[] = [];
    const values: any[] = [];
    let paramCount = 1;

    if (filters.status) {
      whereConditions.push(`status = $${paramCount}`);
      values.push(filters.status);
      paramCount++;
    }

    if (filters.category) {
      whereConditions.push(`category = $${paramCount}`);
      values.push(filters.category);
      paramCount++;
    }

    if (filters.priority) {
      whereConditions.push(`priority = $${paramCount}`);
      values.push(filters.priority);
      paramCount++;
    }

    // Build WHERE clause string
    const whereClause =
      whereConditions.length > 0
        ? `WHERE ${whereConditions.join(" AND ")}`
        : "";

    // Get total count
    const countQuery = `SELECT COUNT(*) as total FROM tasks ${whereClause}`;
    const countResult = await pool.query(countQuery, values);
    const totalCount = parseInt(countResult.rows[0].total, 10);

    // Add pagination parameters
    const paginationValues = [...values, filters.limit, filters.offset];

    // Get tasks with pagination
    const query = `
      SELECT * FROM tasks
      ${whereClause}
      ORDER BY created_at DESC
      LIMIT $${paramCount}
      OFFSET $${paramCount + 1}
    `;

    const result = await pool.query(query, paginationValues);

    const page = Math.floor(filters.offset / filters.limit) + 1;

    return {
      tasks: result.rows.map((row) => this.mapRowToTask(row)),
      pagination: {
        page: page,
        limit: filters.limit,
        total: totalCount,
      },
    };
  }

  /**
   * Create a new task
   */
  async createTask(taskData: {
    title: string;
    description: string | null;
    category: string;
    priority: string;
    assigned_to: string | null;
    due_date: string | null;
    extracted_entities: Record<string, unknown>;
    suggested_actions: string[];
  }): Promise<Task> {
    const query = `
      INSERT INTO tasks (
        title,
        description,
        category,
        priority,
        assigned_to,
        due_date,
        extracted_entities,
        suggested_actions,
        status,
        created_at,
        updated_at
      )
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, NOW(), NOW())
      RETURNING *
    `;

    const values = [
      taskData.title,
      taskData.description,
      taskData.category,
      taskData.priority,
      taskData.assigned_to,
      taskData.due_date,
      JSON.stringify(taskData.extracted_entities),
      JSON.stringify(taskData.suggested_actions),
      "pending",
    ];

    const result = await pool.query(query, values);
    return this.mapRowToTask(result.rows[0]);
  }

  /**
   * Create a task history entry
   */
  async createTaskHistory(historyData: {
    task_id: string;
    action: string;
    old_value: Record<string, unknown> | null;
    new_value: Record<string, unknown> | null;
    changed_by: string | null;
  }): Promise<TaskHistory> {
    const query = `
      INSERT INTO task_history (
        task_id,
        action,
        old_value,
        new_value,
        changed_by,
        changed_at
      )
      VALUES ($1, $2, $3, $4, $5, NOW())
      RETURNING *
    `;

    const values = [
      historyData.task_id,
      historyData.action,
      historyData.old_value ? JSON.stringify(historyData.old_value) : null,
      historyData.new_value ? JSON.stringify(historyData.new_value) : null,
      historyData.changed_by,
    ];

    const result = await pool.query(query, values);
    return this.mapRowToTaskHistory(result.rows[0]);
  }

  /**
   * Map database row to Task object
   */
  private mapRowToTask(row: any): Task {
    return {
      id: row.id,
      title: row.title,
      description: row.description,
      category: row.category,
      priority: row.priority,
      status: row.status,
      assigned_to: row.assigned_to,
      due_date: row.due_date,
      extracted_entities:
        typeof row.extracted_entities === "string"
          ? JSON.parse(row.extracted_entities)
          : row.extracted_entities,
      suggested_actions:
        typeof row.suggested_actions === "string"
          ? JSON.parse(row.suggested_actions)
          : row.suggested_actions,
      created_at: row.created_at,
      updated_at: row.updated_at,
    };
  }

  /**
   * Map database row to TaskHistory object
   */
  private mapRowToTaskHistory(row: any): TaskHistory {
    return {
      id: row.id,
      task_id: row.task_id,
      action: row.action,
      old_value:
        typeof row.old_value === "string"
          ? JSON.parse(row.old_value)
          : row.old_value,
      new_value:
        typeof row.new_value === "string"
          ? JSON.parse(row.new_value)
          : row.new_value,
      changed_by: row.changed_by,
      changed_at: row.changed_at,
    };
  }
}
