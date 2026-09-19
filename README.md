# PRJ---24-7-LLM-Tutor

Java Web MVC skeleton for the PRJ301 AI Tutor project.

## Open in NetBeans

This project is configured as a Maven Java Web project for NetBeans.

1. Open NetBeans.
2. Choose **File > Open Project**.
3. Select this project folder: `PRJ---24-7-LLM-Tutor`.
4. Use **Clean and Build** to generate `target/llm-tutor.war`.
5. To run the web app, configure a Tomcat server in NetBeans and run/deploy the Maven web project.

## Database Setup

The SQL Server database is not stored in GitHub. Each teammate needs to create a local database from the script:

```text
data/setup_database.sql
```

In SQL Server Management Studio, connect with an admin Windows account, open `data/setup_database.sql`, then execute it. The script creates:

- Database: `AITA_DB`
- SQL login/user: `llm_tutor`
- Table: `dbo.ErrorLogs`

After running the script, set these environment variables on each machine:

```text
DB_URL=jdbc:sqlserver://localhost:1434;databaseName=AITA_DB;encrypt=true;trustServerCertificate=true;
DB_USER=llm_tutor
DB_PASSWORD=your_sql_login_password
```

Do not commit real database passwords to GitHub. Use `data/db.env.example` as a template only.

## Milestone 1 Structure

```text
src/main/java/
├── controller/      Servlet controllers
├── filter/          Request validation filters
├── model/dao/       JDBC DAO classes
├── model/dto/       Data Transfer Objects
└── service/         AI tutor/API logic

src/main/webapp/
├── assets/          CSS, JS, Images
├── tutor-chat.jsp   AI chat UI
├── history.jsp      Question history UI
├── tutor-chat.html  Static demo UI for screenshots
└── history.html     Static demo history page
```

## MVC Diagram

- Markdown/Mermaid version: `docs/mvc-architecture.md`
- Draw.io version: `diagrams/mvc-architecture.drawio`
- AI usage log draft: `docs/ai-usage-log.md`

Open the `.drawio` file with diagrams.net/draw.io to export PNG for the weekly report.

For a quick browser preview without Tomcat, open:

```text
src/main/webapp/tutor-chat.html
```
