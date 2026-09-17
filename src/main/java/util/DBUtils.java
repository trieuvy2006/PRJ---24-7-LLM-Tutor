package util; 


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtils {
    public static Connection getConnection() throws ClassNotFoundException, SQLException {
       
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        
      
        String url = "jdbc:sqlserver://localhost:1433;databaseName=AITA_DB;encrypt=false;trustServerCertificate=true;";
        String user = "sa";     
        String pass = "123456";  
        
        return DriverManager.getConnection(url, user, pass);
    }
}