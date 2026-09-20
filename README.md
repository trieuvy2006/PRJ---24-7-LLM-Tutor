# AITA

NetBeans **Java Web Application** (Ant), not Maven. The app demonstrates the full basic flow:

```text
JSP form → DatabaseDemoServlet → DemoMessageDAO → DBContext → SQL Server
```

## Run in NetBeans

1. Open this folder in NetBeans as project **AITA**.
2. Confirm the library `lib/sqljdbc42-6.0.8112.jar` appears under Libraries.
3. Choose Apache Tomcat 10.0 as the server (Tomcat 10.0 works with JDK 8).
4. Run `data/setup_database.sql` in the already-created `AITA_DB` database.
5. Run the project and open `http://localhost:8080/AITA/`.

`src/java/util/DBContext.java` is configured for SQL Server on `localhost:1434`, database `AITA_DB`, user `sa`, password `123`. For a shared/public repository, change these values to local configuration before publishing real credentials.

The page allows adding a short message and immediately lists rows read from `dbo.DemoMessages`, making the JDBC connection easy to demonstrate.
