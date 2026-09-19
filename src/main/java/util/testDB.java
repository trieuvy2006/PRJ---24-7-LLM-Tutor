package util;

import java.sql.Connection;

public class TestDB {

    public static void main(String[] args) {

        try {
            Connection conn = DBUtils.getConnection();

            System.out.println("CONNECTED TO DATABASE!");

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}