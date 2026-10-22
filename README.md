# AITA

NetBeans **Java Web Application** (Ant), not Maven. The app shows the full basic flow:

```text
JSP → MessageServlet → MessageDAO → DBContext → SQL Server
```

## Run in NetBeans

1. Open this folder in NetBeans as project **AITA**.
2. Confirm the library `lib/sqljdbc42-6.0.8112.jar` appears under Libraries.
3. Choose Apache Tomcat 10.0 as the server (Tomcat 10.0 works with JDK 8).
4. Run `data/setup_database.sql` in the already-created `AITA_DB` database.
5. Run the project and open `http://localhost:8080/AITA/`.

`src/java/util/DBContext.java` is configured for SQL Server on `localhost:1434`, database `AITA_DB`, user `sa`, password `123`. For a shared/public repository, change these values to local configuration before publishing real credentials.

The page lists rows read from `dbo.Messages`, making the JDBC connection easy to show.

## Enable the real AI Tutor

The chat endpoint calls Gemini when `GEMINI_API_KEY` is configured, otherwise it
uses OpenAI when `OPENAI_API_KEY` is configured. Before starting Tomcat, set one
of these in the Tomcat process environment; never place a key in JSP, Java source,
SQL scripts, or Git. Optionally set `GEMINI_MODEL` (default: `gemini-flash-latest`)
and `GEMINI_MAX_OUTPUT_TOKENS` (default: `65536`). Use a lower value only if
the selected Gemini model rejects that limit.
or `OPENAI_MODEL` (default: `gpt-6-luna`).

For a Windows development session started from PowerShell:

```powershell
$env:GEMINI_API_KEY = "your-key-here"
$env:GEMINI_MODEL = "gemini-flash-latest"
$env:GEMINI_MAX_OUTPUT_TOKENS = "65536"
```

Restart Tomcat from the same environment. If the key is unavailable, expired, or
the service times out, the UI reports that state and does not pretend that a
rule-based response came from the LLM.
