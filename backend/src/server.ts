import app from "./app";
import pool from "./config/db";
import dotenv from "dotenv";

dotenv.config();

const PORT = process.env.PORT || 5000;

// Test database connection on startup
const testDatabaseConnection = async () => {
  try {
    await pool.query("SELECT NOW()");
    console.log("✓ Database connection successful");
    console.log(`  Connected to: ${process.env.DATABASE_URL}`);
    return true;
  } catch (error: any) {
    console.error("✗ Database connection failed");
    console.error(`  Error: ${error.message}`);
    return false;
  }
};

app.listen(PORT, async () => {
  console.log(`Server is running on port ${PORT}`);
  console.log(`Environment: ${process.env.NODE_ENV || "development"}`);

  // Test database connection
  const dbConnected = await testDatabaseConnection();
  if (!dbConnected) {
    console.warn(
      "Warning: Database connection failed. Please check your DATABASE_URL in .env file."
    );
  }
});
