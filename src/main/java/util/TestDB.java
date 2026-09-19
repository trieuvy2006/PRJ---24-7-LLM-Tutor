package util;

import java.sql.Connection;
import java.sql.DatabaseMetaData;

public class TestDB {

    public static void main(String[] args) {
        try (Connection conn = DBUtils.getConnection()) {
            DatabaseMetaData metaData = conn.getMetaData();

            System.out.println("CONNECTED TO DATABASE!");
            System.out.println("URL: " + metaData.getURL());
            System.out.println("USER: " + metaData.getUserName());
            System.out.println("DRIVER: " + metaData.getDriverName());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
