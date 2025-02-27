package db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class InitDB {
	public static Connection con = null;

	public static Connection getConnection() {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/parkme", "root", "root");

		} catch (Exception e) {
			System.out.println(e);
		}
		return con;
	}

	public static void closeConnection() {
		try {
			if (con != null)
				con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static void main(String args[]) {
		con = InitDB.getConnection();
		if (con != null) {
			System.out.println("YES");
		}
	}
}
