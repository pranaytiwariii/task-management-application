import { ClassificationUtil } from "../src/utils/classification.util";

describe("ClassificationUtil", () => {
  // ============================================================================
  // CATEGORY CLASSIFICATION TESTS
  // ============================================================================

  describe("classifyCategory()", () => {
    describe("Scheduling category detection", () => {
      it("should classify 'schedule urgent meeting' as scheduling", () => {
        const result = ClassificationUtil.classifyCategory(
          "schedule urgent meeting"
        );
        expect(result).toBe("scheduling");
      });

      it("should classify text with appointment keyword as scheduling", () => {
        const result = ClassificationUtil.classifyCategory(
          "Schedule a conference call"
        );
        expect(result).toBe("scheduling");
      });

      it("should classify text with deadline keyword as scheduling", () => {
        const result = ClassificationUtil.classifyCategory("Project deadline");
        expect(result).toBe("scheduling");
      });

      it("should detect scheduling in description when not in title", () => {
        const result = ClassificationUtil.classifyCategory(
          "Prepare task",
          "Setup meeting for tomorrow"
        );
        expect(result).toBe("scheduling");
      });

      it("should be case-insensitive for scheduling keywords", () => {
        const result = ClassificationUtil.classifyCategory(
          "SCHEDULE MEETING NOW"
        );
        expect(result).toBe("scheduling");
      });
    });

    describe("Finance category detection", () => {
      it("should classify 'process invoice payment' as finance", () => {
        const result = ClassificationUtil.classifyCategory(
          "process invoice payment"
        );
        expect(result).toBe("finance");
      });

      it("should classify text with bill keyword as finance", () => {
        const result = ClassificationUtil.classifyCategory("Pay monthly bill");
        expect(result).toBe("finance");
      });

      it("should classify text with budget keyword as finance", () => {
        const result = ClassificationUtil.classifyCategory("Review Q4 budget");
        expect(result).toBe("finance");
      });

      it("should detect finance in description", () => {
        const result = ClassificationUtil.classifyCategory(
          "Financial task",
          "Process payment for client"
        );
        expect(result).toBe("finance");
      });

      it("should be case-insensitive for finance keywords", () => {
        const result = ClassificationUtil.classifyCategory(
          "PROCESS INVOICE IMMEDIATELY"
        );
        expect(result).toBe("finance");
      });
    });

    describe("Technical category detection", () => {
      it("should classify 'fix production bug' as technical", () => {
        const result =
          ClassificationUtil.classifyCategory("fix production bug");
        expect(result).toBe("technical");
      });

      it("should classify text with error keyword as technical", () => {
        const result = ClassificationUtil.classifyCategory("Debug error");
        expect(result).toBe("technical");
      });

      it("should classify text with deploy keyword as technical", () => {
        const result = ClassificationUtil.classifyCategory("Deploy new code");
        expect(result).toBe("technical");
      });

      it("should detect technical in description", () => {
        const result = ClassificationUtil.classifyCategory(
          "System maintenance",
          "Fix critical bug in production"
        );
        expect(result).toBe("technical");
      });

      it("should be case-insensitive for technical keywords", () => {
        const result = ClassificationUtil.classifyCategory(
          "FIX PRODUCTION BUG ASAP"
        );
        expect(result).toBe("technical");
      });
    });

    describe("Safety category detection", () => {
      it("should classify text with safety keyword as safety", () => {
        const result = ClassificationUtil.classifyCategory("Safety audit");
        expect(result).toBe("safety");
      });

      it("should classify text with hazard keyword as safety", () => {
        const result = ClassificationUtil.classifyCategory("Identify hazards");
        expect(result).toBe("safety");
      });

      it("should classify text with inspection keyword as safety", () => {
        const result = ClassificationUtil.classifyCategory(
          "Conduct safety inspection"
        );
        expect(result).toBe("safety");
      });

      it("should detect safety in description", () => {
        const result = ClassificationUtil.classifyCategory(
          "Compliance check",
          "Report safety incident"
        );
        expect(result).toBe("safety");
      });
    });

    describe("General category fallback", () => {
      it("should return general when no keywords match", () => {
        const result = ClassificationUtil.classifyCategory(
          "Complete task without specific context"
        );
        expect(result).toBe("general");
      });

      it("should return general for empty title", () => {
        const result = ClassificationUtil.classifyCategory("");
        expect(result).toBe("general");
      });

      it("should return general for null description", () => {
        const result = ClassificationUtil.classifyCategory(
          "Generic task",
          null
        );
        expect(result).toBe("general");
      });

      it("should return general for undefined description", () => {
        const result = ClassificationUtil.classifyCategory(
          "Generic task",
          undefined
        );
        expect(result).toBe("general");
      });

      it("should return general for unrelated text", () => {
        const result = ClassificationUtil.classifyCategory(
          "Lorem ipsum dolor sit amet"
        );
        expect(result).toBe("general");
      });
    });

    describe("Multiple keyword matching (first match wins)", () => {
      it("should return first matching category when multiple keywords present", () => {
        // Since scheduling comes first in CATEGORY_KEYWORDS, meeting keyword should be found first
        const result = ClassificationUtil.classifyCategory(
          "schedule meeting and process payment"
        );
        expect(result).toBe("scheduling");
      });

      it("should match technical before general", () => {
        const result = ClassificationUtil.classifyCategory("Fix issue now");
        expect(result).toBe("technical");
      });
    });
  });

  // ============================================================================
  // PRIORITY CLASSIFICATION TESTS
  // ============================================================================

  describe("classifyPriority()", () => {
    describe("High priority detection", () => {
      it("should classify 'urgent task today' as high priority", () => {
        const result = ClassificationUtil.classifyPriority("urgent task today");
        expect(result).toBe("high");
      });

      it("should detect urgent keyword as high priority", () => {
        const result = ClassificationUtil.classifyPriority("Urgent request");
        expect(result).toBe("high");
      });

      it("should detect asap keyword as high priority", () => {
        const result = ClassificationUtil.classifyPriority("Do this ASAP");
        expect(result).toBe("high");
      });

      it("should detect immediately keyword as high priority", () => {
        const result =
          ClassificationUtil.classifyPriority("Handle immediately");
        expect(result).toBe("high");
      });

      it("should detect critical keyword as high priority", () => {
        const result = ClassificationUtil.classifyPriority("Critical issue");
        expect(result).toBe("high");
      });

      it("should detect emergency keyword as high priority", () => {
        const result = ClassificationUtil.classifyPriority("Emergency fix");
        expect(result).toBe("high");
      });

      it("should find high priority in description", () => {
        const result = ClassificationUtil.classifyPriority(
          "Review task",
          "This is urgent and needs immediate attention"
        );
        expect(result).toBe("high");
      });

      it("should be case-insensitive for high priority keywords", () => {
        const result = ClassificationUtil.classifyPriority(
          "URGENT ASAP CRITICAL"
        );
        expect(result).toBe("high");
      });
    });

    describe("Medium priority detection", () => {
      it("should classify 'important task this week' as medium priority", () => {
        const result = ClassificationUtil.classifyPriority(
          "important task this week"
        );
        expect(result).toBe("medium");
      });

      it("should detect important keyword as medium priority", () => {
        const result = ClassificationUtil.classifyPriority("Important update");
        expect(result).toBe("medium");
      });

      it("should detect 'this week' keyword as medium priority", () => {
        const result = ClassificationUtil.classifyPriority("Due this week");
        expect(result).toBe("medium");
      });

      it("should detect soon keyword as medium priority", () => {
        const result = ClassificationUtil.classifyPriority("Do this soon");
        expect(result).toBe("medium");
      });

      it("should detect 'next week' keyword as medium priority", () => {
        const result = ClassificationUtil.classifyPriority("Next week task");
        expect(result).toBe("medium");
      });

      it("should find medium priority in description", () => {
        const result = ClassificationUtil.classifyPriority(
          "Update task",
          "This should be completed soon"
        );
        expect(result).toBe("medium");
      });

      it("should be case-insensitive for medium priority keywords", () => {
        const result = ClassificationUtil.classifyPriority(
          "IMPORTANT TASK THIS WEEK"
        );
        expect(result).toBe("medium");
      });
    });

    describe("Low priority detection (default)", () => {
      it("should classify 'optional task' as low priority", () => {
        const result = ClassificationUtil.classifyPriority("optional task");
        expect(result).toBe("low");
      });

      it("should return low for text without priority keywords", () => {
        const result = ClassificationUtil.classifyPriority("Generic task");
        expect(result).toBe("low");
      });

      it("should return low for empty title", () => {
        const result = ClassificationUtil.classifyPriority("");
        expect(result).toBe("low");
      });

      it("should return low for null description", () => {
        const result = ClassificationUtil.classifyPriority("Task", null);
        expect(result).toBe("low");
      });

      it("should return low for undefined description", () => {
        const result = ClassificationUtil.classifyPriority("Task", undefined);
        expect(result).toBe("low");
      });

      it("should return low for unrelated text", () => {
        const result = ClassificationUtil.classifyPriority(
          "Lorem ipsum dolor sit amet"
        );
        expect(result).toBe("low");
      });
    });

    describe("High vs Medium priority precedence", () => {
      it("should detect high priority even when medium keywords present", () => {
        const result = ClassificationUtil.classifyPriority(
          "urgent task this week"
        );
        expect(result).toBe("high");
      });

      it("should return first matching priority (high before medium)", () => {
        const result = ClassificationUtil.classifyPriority(
          "Important but also urgent"
        );
        expect(result).toBe("high");
      });
    });
  });

  // ============================================================================
  // ENTITY EXTRACTION TESTS
  // ============================================================================

  describe("extractEntities()", () => {
    describe("Keyword extraction", () => {
      it("should extract scheduling keywords from title", () => {
        const result = ClassificationUtil.extractEntities(
          "schedule meeting",
          null,
          null
        );
        expect(result.keywords).toContain("meeting");
        expect(result.keywords).toContain("schedule");
      });

      it("should extract finance keywords from description", () => {
        const result = ClassificationUtil.extractEntities(
          "Task",
          "Process invoice payment",
          null
        );
        expect(result.keywords).toContain("payment");
        expect(result.keywords).toContain("invoice");
      });

      it("should extract technical keywords", () => {
        const result = ClassificationUtil.extractEntities(
          "fix production bug",
          null,
          null
        );
        expect(result.keywords).toContain("bug");
        expect(result.keywords).toContain("fix");
      });

      it("should extract keywords from both title and description", () => {
        const result = ClassificationUtil.extractEntities(
          "schedule meeting",
          "Process invoice",
          null
        );
        expect(result.keywords).toContain("meeting");
        expect(result.keywords).toContain("invoice");
      });

      it("should handle no matching keywords", () => {
        const result = ClassificationUtil.extractEntities(
          "generic task",
          null,
          null
        ) as any;
        expect(Array.isArray(result.keywords)).toBe(true);
        expect(result.keywords.length).toBe(0);
      });

      it("should remove duplicate keywords", () => {
        const result = ClassificationUtil.extractEntities(
          "meeting meeting meeting",
          null,
          null
        ) as any;
        const meetingCount = result.keywords.filter(
          (k: string) => k === "meeting"
        ).length;
        expect(meetingCount).toBe(1);
      });

      it("should be case-insensitive for keywords", () => {
        const result = ClassificationUtil.extractEntities(
          "SCHEDULE MEETING NOW",
          null,
          null
        );
        expect(result.keywords).toContain("meeting");
        expect(result.keywords).toContain("schedule");
      });
    });

    describe("Assigned person extraction", () => {
      it("should include assigned_to when provided", () => {
        const result = ClassificationUtil.extractEntities(
          "Task",
          null,
          "john@example.com"
        );
        expect(result.assigned_person).toBe("john@example.com");
      });

      it("should return null for assigned_person when not provided", () => {
        const result = ClassificationUtil.extractEntities("Task", null, null);
        expect(result.assigned_person).toBeNull();
      });

      it("should return null for assigned_person when undefined", () => {
        const result = ClassificationUtil.extractEntities(
          "Task",
          null,
          undefined
        );
        expect(result.assigned_person).toBeNull();
      });

      it("should preserve assigned_to email format", () => {
        const email = "jane.doe@company.com";
        const result = ClassificationUtil.extractEntities("Task", null, email);
        expect(result.assigned_person).toBe(email);
      });

      it("should preserve assigned_to with different formats", () => {
        const name = "John Doe";
        const result = ClassificationUtil.extractEntities("Task", null, name);
        expect(result.assigned_person).toBe(name);
      });
    });

    describe("Text length calculation", () => {
      it("should calculate correct text_length for title only", () => {
        const title = "Test task";
        const result = ClassificationUtil.extractEntities(title, null, null);
        // Implementation adds space: "Test task " = 10 characters
        expect(result.text_length).toBe(title.length + 1);
      });

      it("should include title and description in text_length", () => {
        const title = "Test";
        const description = "Description";
        const combined = `${title} ${description}`;
        const result = ClassificationUtil.extractEntities(
          title,
          description,
          null
        );
        expect(result.text_length).toBe(combined.length);
      });

      it("should handle null description in text_length", () => {
        const title = "Test task";
        const result = ClassificationUtil.extractEntities(title, null, null);
        // Implementation adds space: "Test task " = 10 characters
        expect(result.text_length).toBe(title.length + 1);
      });

      it("should handle undefined description in text_length", () => {
        const title = "Test task";
        const result = ClassificationUtil.extractEntities(
          title,
          undefined,
          null
        );
        // Implementation adds space: "Test task " = 10 characters
        expect(result.text_length).toBe(title.length + 1);
      });

      it("should be numeric value", () => {
        const result = ClassificationUtil.extractEntities(
          "Title",
          "description",
          null
        );
        expect(typeof result.text_length).toBe("number");
      });
    });

    describe("Response structure", () => {
      it("should return object with keywords property", () => {
        const result = ClassificationUtil.extractEntities("Task", null, null);
        expect(result).toHaveProperty("keywords");
      });

      it("should return object with assigned_person property", () => {
        const result = ClassificationUtil.extractEntities("Task", null, null);
        expect(result).toHaveProperty("assigned_person");
      });

      it("should return object with text_length property", () => {
        const result = ClassificationUtil.extractEntities("Task", null, null);
        expect(result).toHaveProperty("text_length");
      });

      it("should have exactly 3 properties in result", () => {
        const result = ClassificationUtil.extractEntities(
          "Task",
          "Desc",
          "user@example.com"
        );
        expect(Object.keys(result).length).toBe(3);
      });
    });

    describe("Edge cases and special inputs", () => {
      it("should handle empty title", () => {
        const result = ClassificationUtil.extractEntities("", null, null);
        expect(result.keywords).toBeDefined();
        // Implementation always adds space: " " = 1 character
        expect(result.text_length).toBe(1);
      });

      it("should handle very long title", () => {
        const longTitle = "a".repeat(1000);
        const result = ClassificationUtil.extractEntities(
          longTitle,
          null,
          null
        );
        // Implementation adds space: 1000 chars + space = 1001
        expect(result.text_length).toBe(1001);
      });

      it("should handle special characters", () => {
        const result = ClassificationUtil.extractEntities(
          "Task! @#$% schedule",
          null,
          null
        );
        expect(result.keywords).toContain("schedule");
      });

      it("should handle numbers in title", () => {
        const result = ClassificationUtil.extractEntities(
          "Fix bug 123 now",
          null,
          null
        );
        expect(result.keywords).toContain("bug");
      });
    });
  });

  // ============================================================================
  // INTEGRATION TESTS
  // ============================================================================

  describe("Integration scenarios", () => {
    it("should correctly classify a complete task scenario", () => {
      const title = "Schedule urgent meeting";
      const description = "Important deadline tomorrow";

      const category = ClassificationUtil.classifyCategory(title, description);
      const priority = ClassificationUtil.classifyPriority(title, description);
      const entities = ClassificationUtil.extractEntities(
        title,
        description,
        "john@example.com"
      );

      expect(category).toBe("scheduling");
      expect(priority).toBe("high");
      expect(entities.keywords).toContain("meeting");
      expect(entities.assigned_person).toBe("john@example.com");
    });

    it("should handle a finance task with no urgency", () => {
      const title = "Process monthly invoice";
      const description = "Review and approve payment";

      const category = ClassificationUtil.classifyCategory(title, description);
      const priority = ClassificationUtil.classifyPriority(title, description);

      expect(category).toBe("finance");
      expect(priority).toBe("low");
    });

    it("should classify a critical technical issue", () => {
      const title = "Fix critical bug";
      const description = "Production system down, needs immediate fix";

      const category = ClassificationUtil.classifyCategory(title, description);
      const priority = ClassificationUtil.classifyPriority(title, description);
      const entities = ClassificationUtil.extractEntities(
        title,
        description,
        null
      );

      expect(category).toBe("technical");
      expect(priority).toBe("high");
      expect(entities.keywords).toContain("bug");
    });

    it("should classify a generic low-priority task", () => {
      const title = "Review documentation";

      const category = ClassificationUtil.classifyCategory(title, null);
      const priority = ClassificationUtil.classifyPriority(title, null);

      expect(category).toBe("general");
      expect(priority).toBe("low");
    });
  });

  // ============================================================================
  // SUGGESTED ACTIONS TESTS
  // ============================================================================

  describe("getSuggestedActions()", () => {
    it("should return scheduling actions for scheduling category", () => {
      const actions = ClassificationUtil.getSuggestedActions("scheduling");
      expect(actions).toContain("Block calendar");
      expect(actions).toContain("Send invite");
      expect(actions).toContain("Prepare agenda");
      expect(actions.length).toBe(3);
    });

    it("should return finance actions for finance category", () => {
      const actions = ClassificationUtil.getSuggestedActions("finance");
      expect(actions).toContain("Check budget");
      expect(actions).toContain("Generate invoice");
      expect(actions).toContain("Process payment");
    });

    it("should return technical actions for technical category", () => {
      const actions = ClassificationUtil.getSuggestedActions("technical");
      expect(actions).toContain("Diagnose issue");
      expect(actions).toContain("Assign technician");
      expect(actions).toContain("Create ticket");
    });

    it("should return safety actions for safety category", () => {
      const actions = ClassificationUtil.getSuggestedActions("safety");
      expect(actions).toContain("Conduct inspection");
      expect(actions).toContain("Notify supervisor");
      expect(actions).toContain("Document incident");
    });

    it("should return general actions for general category", () => {
      const actions = ClassificationUtil.getSuggestedActions("general");
      expect(actions).toContain("Review task");
      expect(actions).toContain("Plan approach");
      expect(actions).toContain("Assign resource");
    });

    it("should return general actions for unknown category", () => {
      const actions = ClassificationUtil.getSuggestedActions("unknown");
      expect(actions).toContain("Review task");
      expect(actions).toContain("Plan approach");
      expect(actions).toContain("Assign resource");
    });

    it("should return array of strings", () => {
      const actions = ClassificationUtil.getSuggestedActions("scheduling");
      expect(Array.isArray(actions)).toBe(true);
      expect(actions.every((action) => typeof action === "string")).toBe(true);
    });

    it("should be case-sensitive for category parameter", () => {
      const actions2 = ClassificationUtil.getSuggestedActions("SCHEDULING");
      // Since we check exact keys, uppercase won't match
      expect(actions2).toEqual(
        ClassificationUtil.getSuggestedActions("general")
      );
    });
  });
});
