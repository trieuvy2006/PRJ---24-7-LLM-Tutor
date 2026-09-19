package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtils {

    public static Connection getConnection()
            throws ClassNotFoundException, SQLException {

        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

        String url = getConfig(
                "db.url",
                "DB_URL",
                "jdbc:sqlserver://localhost:1434;"
                + "databaseName=AITA_DB;"
                + "encrypt=true;"
                + "trustServerCertificate=true;");

        String user = getConfig("db.user", "DB_USER", "llm_tutor");
        String pass = getConfig("db.password", "DB_PASSWORD", "");

        if (pass.isEmpty()) {
            throw new SQLException("Missing database password. Set DB_PASSWORD or -Ddb.password.");
        }

        return DriverManager.getConnection(url, user, pass);
    }

    private static String getConfig(String propertyName, String envName, String defaultValue) {
        String propertyValue = System.getProperty(propertyName);
        if (propertyValue != null && !propertyValue.trim().isEmpty()) {
            return propertyValue.trim();
        }

        String envValue = System.getenv(envName);
        if (envValue != null && !envValue.trim().isEmpty()) {
            return envValue.trim();
        }

        return defaultValue;
    }
}
