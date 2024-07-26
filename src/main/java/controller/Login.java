package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import db.InitDB;

/**
 * Servlet implementation class Login
 */
@WebServlet(urlPatterns = "/Login")
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;
	Connection conn = null;
	InitDB con;
	

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Login() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String password = request.getParameter("password");
		String email = request.getParameter("email");
		PrintWriter out = response.getWriter();

		try {
			con = new InitDB();
			conn = InitDB.getConnection();			
			Statement statement = conn.createStatement();
			
			String sql = "SELECT password, userId FROM user WHERE email ='"+email+"'";
			
			

			ResultSet resultSet = statement.executeQuery(sql);
			ServletContext sc = request.getServletContext();

			if (resultSet.next()) {
				if (resultSet.getString("password").equals(password)) {
					HttpSession session = request.getSession();
					Cookie ck = new Cookie("userId", resultSet.getString("userId"));
					response.addCookie(ck);
					session.setAttribute("email", email);
					session.setAttribute("userId", resultSet.getString("userId"));
					
					out.print("hello");
					response.sendRedirect("dashboard.jsp");
				} else {
					String htmlMessage = "<p class='text-center text-danger'>*** Password Does Not Match ***</p>";

					sc.setAttribute("messages", htmlMessage);
					response.sendRedirect("login.jsp?res=no");
				}
			} else {
				String htmlMessage = "<p class='text-center text-danger'>*** Invalid Credentials ***</p>";

				sc.setAttribute("messages", htmlMessage);
				response.sendRedirect("login.jsp?res?no");
			}

		} catch (Exception e) {
			out.print(e);
		} finally {
			InitDB.closeConnection();
		}
	}

}
