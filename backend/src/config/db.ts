import { Pool } from "pg";
import dotenv from "dotenv";

dotenv.config();

// Use SSL for external connections (local dev with Render external URL)
// Internal Render services don't need SSL
const isExternalConnection = process.env.DATABASE_URL?.includes("render.com");

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ...(isExternalConnection && {
    ssl: {
      rejectUnauthorized: false,
    },
  }),
});

pool.on("error", (err: Error) => {
  console.error("Unexpected error on idle client", err);
});

export default pool;
