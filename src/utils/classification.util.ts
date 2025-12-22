interface CategoryKeywords {
  [key: string]: string[];
}

interface PriorityKeywords {
  [key: string]: string[];
}

const CATEGORY_KEYWORDS: CategoryKeywords = {
  scheduling: [
    "meeting",
    "schedule",
    "call",
    "appointment",
    "deadline",
    "conference",
    "standup",
    "sync",
  ],
  finance: [
    "payment",
    "invoice",
    "bill",
    "budget",
    "cost",
    "expense",
    "financial",
    "accounting",
  ],
  technical: [
    "bug",
    "fix",
    "error",
    "install",
    "repair",
    "maintain",
    "deploy",
    "code",
    "system",
  ],
  safety: [
    "safety",
    "hazard",
    "inspection",
    "compliance",
    "ppe",
    "accident",
    "incident",
  ],
};

const PRIORITY_KEYWORDS: PriorityKeywords = {
  high: ["urgent", "asap", "immediately", "today", "critical", "emergency"],
  medium: ["soon", "this week", "important", "next week"],
};

export class ClassificationUtil {
  /**
   * Classify task category based on keywords in title and description
   */
  static classifyCategory(title: string, description?: string | null): string {
    const text = `${title} ${description || ""}`.toLowerCase();

    for (const [category, keywords] of Object.entries(CATEGORY_KEYWORDS)) {
      if (keywords.some((keyword) => text.includes(keyword))) {
        return category;
      }
    }

    return "general";
  }

  /**
   * Classify task priority based on keywords in title and description
   */
  static classifyPriority(title: string, description?: string | null): string {
    const text = `${title} ${description || ""}`.toLowerCase();

    for (const [priority, keywords] of Object.entries(PRIORITY_KEYWORDS)) {
      if (keywords.some((keyword) => text.includes(keyword))) {
        return priority;
      }
    }

    return "low";
  }

  /**
   * Extract entities from task (keywords, assigned person, dates)
   */
  static extractEntities(
    title: string,
    description: string | null | undefined,
    assigned_to: string | null | undefined
  ): Record<string, unknown> {
    const text = `${title} ${description || ""}`.toLowerCase();
    const foundKeywords = this.extractKeywords(text);

    return {
      keywords: foundKeywords,
      assigned_person: assigned_to || null,
      text_length: `${title} ${description || ""}`.length,
    };
  }

  /**
   * Extract suggested actions based on category
   */
  static getSuggestedActions(category: string): string[] {
    const actionMap: Record<string, string[]> = {
      scheduling: ["Block calendar", "Send invite", "Prepare agenda"],
      finance: ["Check budget", "Generate invoice", "Process payment"],
      technical: ["Diagnose issue", "Assign technician", "Create ticket"],
      safety: ["Conduct inspection", "Notify supervisor", "Document incident"],
      general: ["Review task", "Plan approach", "Assign resource"],
    };

    return actionMap[category] || actionMap["general"];
  }

  /**
   * Extract keywords from text
   */
  private static extractKeywords(text: string): string[] {
    const allKeywords = Object.values(CATEGORY_KEYWORDS).flat();
    const foundKeywords = allKeywords.filter((keyword) =>
      text.includes(keyword)
    );
    return [...new Set(foundKeywords)]; // Remove duplicates
  }
}
