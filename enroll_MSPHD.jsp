<html>

<body>
  <table border="1">
    <tr>
      <td valign="top">
        <%-- -------- Include menu HTML code -------- --%>
        <jsp:include page="menu.html" />
      </td>
      <td>

      <%-- Set the scripting language to Java and --%>
      <%-- Import the java.sql package --%>
      <%@ page language="java" import="java.sql.*" %>
  
      <%-- -------- Open Connection Code -------- --%>
      <%
        try {
          // Load Oracle Driver class file
          DriverManager.registerDriver
            (new com.microsoft.sqlserver.jdbc.SQLServerDriver());
  
          // Make a connection to the Oracle datasource "cse132b"
          Connection conn = DriverManager.getConnection
            ("jdbc:sqlserver://localhost:1433;databaseName=cse132b", 
              "sa", "123456");

      %>

      <%-- -------- INSERT Code -------- --%>
      <%
          String action = request.getParameter("action");
          // Check if an insertion is requested
          if (action != null && action.equals("insert")) {

            // Begin transaction
            conn.setAutoCommit(false);
            
            PreparedStatement pstmt = conn.prepareStatement(
              "INSERT INTO MSPHDSTUDENTDEGREE VALUES (?, ?, ?)");

            pstmt.setInt(
              1, Integer.parseInt(request.getParameter("STUDENT_ID")));
            pstmt.setString(2, request.getParameter("NAME_OF_DEGREE"));
            pstmt.setString(3, request.getParameter("CONCENTRATION"));
            int rowCount = pstmt.executeUpdate();

            // Commit transaction
            conn.commit();
            conn.setAutoCommit(true);
          }
      %>

      <%-- -------- SELECT Statement Code -------- --%>
      <%
          // Create the statement
          Statement statement = conn.createStatement();

          // Use the created statement to SELECT
          // the student attributes FROM the Student table.
          ResultSet rs = statement.executeQuery
            ("SELECT * FROM MSPHDSTUDENTDEGREE");
      %>
        <h1>Enroll Student As MSPHD</h1>
      <!-- Add an HTML table header row to format the results -->
        <table border="1">
          <tr>
            <th>STUDENT_ID</th>
            <th>NAME_OF_DEGREE</th>
            <th>CONCENTRATION</th>
            <th>ACTION</th>
          </tr>
          <tr>
            <form action="enroll_MSPHD.jsp" method="get">
              <input type="hidden" value="insert" name="action">
              <th><input value="" name="STUDENT_ID" size="10"></th>
              <th><input value="" name="NAME_OF_DEGREE" size="10"></th>
              <th><input value="" name="CONCENTRATION" size="15"></th>
              <th><input type="submit" value="Insert"></th>
            </form>
          </tr>

      <%-- -------- Iteration Code -------- --%>
      <%
          // Iterate over the ResultSet
    
          while ( rs.next() ) {
    
      %>

          <tr>
            <form action="enroll_MSPHD.jsp" method="get">
              <input type="hidden" value="update" name="action">

              <td>
                <input value="<%= rs.getString("student_id") %>" 
                  name="STUDENT_ID" size="10">
              </td>
  
              <%-- Get the student_id --%>
              <td>
                <input value="<%= rs.getString("name_of_degree") %>" 
                  name="NAME_OF_DEGREE" size="10">
              </td>
              <td>
                <input value="<%= rs.getString("concentration") %>"
                  name="CONCENTRATION" size="15">
              </td>
          </tr>
      <%
          }
      %>

      <%-- -------- Close Connection Code -------- --%>
      <%
          // Close the ResultSet
          rs.close();
  
          // Close the Statement
          statement.close();
  
          // Close the Connection
          conn.close();
        } catch (SQLException sqle) {
          out.println(sqle.getMessage());
        } catch (Exception e) {
          out.println(e.getMessage());
        }
      %>
        </table>
      </td>
    </tr>
  </table>
</body>

</html>
