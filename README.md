# PRJ---24-7-LLM-Tutor

Java Web MVC skeleton for the PRJ301 AI Tutor project.

## Open in NetBeans

This project is configured as a Maven Java Web project for NetBeans.

1. Open NetBeans.
2. Choose **File > Open Project**.
3. Select this project folder: `PRJ---24-7-LLM-Tutor`.
4. Use **Clean and Build** to generate `target/llm-tutor.war`.
5. To run the web app, configure a Tomcat server in NetBeans and run/deploy the Maven web project.

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
