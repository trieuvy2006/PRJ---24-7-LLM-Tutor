package model.dao;

import util.DBUtils;
import java.sql.Connection;

public class ErrorLogDAO {

    public void saveError(String source, String message) {

        try {
            Connection conn = DBUtils.getConnection();

            System.out.println("Connected to AITA_DB!");

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}