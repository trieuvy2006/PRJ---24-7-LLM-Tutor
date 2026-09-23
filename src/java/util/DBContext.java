package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * One place for the SQL Server connection used by the whole web application.
 */

public class DBContext {
    protected Connection connection;
    public DBContext()
    {
        try {
            // SQL Server standard port 1433
            String url = "jdbc:sqlserver://localhost:1433;databaseName=AITA_DB;encrypt=false;trustServerCertificate=true";
            String username = "sa";
            String password = "123";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException | SQLException ex) {
            ex.printStackTrace();
        }
    }
}
