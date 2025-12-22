import { z } from "zod";

export const createTaskSchema = z.object({
  title: z.string().min(1, "Title is required").max(255, "Title too long"),
  description: z.string().optional().nullable(),
  assigned_to: z.string().optional().nullable(),
  due_date: z.string().datetime().optional().nullable(),
});

export type CreateTaskRequest = z.infer<typeof createTaskSchema>;

export const updateTaskSchema = z.object({
  title: z
    .string()
    .min(1, "Title is required")
    .max(255, "Title too long")
    .optional(),
  description: z.string().optional().nullable(),
  status: z.enum(["pending", "in_progress", "completed"]).optional(),
  category: z
    .enum(["scheduling", "finance", "technical", "safety", "general"])
    .optional(),
  priority: z.enum(["low", "medium", "high"]).optional(),
  assigned_to: z.string().optional().nullable(),
  due_date: z.string().datetime().optional().nullable(),
});

export type UpdateTaskRequest = z.infer<typeof updateTaskSchema>;

export interface Task {
  id: string;
  title: string;
  description: string | null;
  category: string;
  priority: string;
  status: string;
  assigned_to: string | null;
  due_date: string | null;
  extracted_entities: Record<string, unknown>;
  suggested_actions: string[];
  created_at: string;
  updated_at: string;
}

export interface TaskHistory {
  id: string;
  task_id: string;
  action: string;
  old_value: Record<string, unknown> | null;
  new_value: Record<string, unknown> | null;
  changed_by: string | null;
  changed_at: string;
}
