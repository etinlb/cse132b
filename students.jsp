
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
            
            // Create the prepared statement and use it to
            // INSERT the student attributes INTO the Student table.
            PreparedStatement pstmt = conn.prepareStatement(
              "INSERT INTO Student VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

            pstmt.setInt(
              1, Integer.parseInt(request.getParameter("SSN")));
            pstmt.setInt(2, Integer.parseInt(request.getParameter("student_id")));
            pstmt.setString(3, request.getParameter("FIRSTNAME"));
            pstmt.setString(4, request.getParameter("MIDDLENAME"));
            pstmt.setString(5, request.getParameter("LASTNAME"));
            pstmt.setString(6, request.getParameter("RESIDENCY"));
            pstmt.setString(7, request.getParameter("TYPE"));
            pstmt.setString(8, request.getParameter("E_PER"));
            int rowCount = pstmt.executeUpdate();

            // Commit transaction
            conn.commit();
            conn.setAutoCommit(true);
          }
      %>

      <%-- -------- UPDATE Code -------- --%>
      <%
          // Check if an update is requested
          if (action != null && action.equals("update")) {

            // Begin transaction
            conn.setAutoCommit(false);
            
            // Create the prepared statement and use it to
            // UPDATE the student attributes in the Student table.
            PreparedStatement pstmt = conn.prepareStatement(
              "UPDATE Student SET student_id = ?, FIRSTNAME = ?, " +
              "MIDDLENAME = ?, LASTNAME = ?, RESIDENCY = ? WHERE SSN = ?");

            pstmt.setString(1, request.getParameter("student_id"));
            pstmt.setString(2, request.getParameter("FIRSTNAME"));
            pstmt.setString(3, request.getParameter("MIDDLENAME"));
            pstmt.setString(4, request.getParameter("LASTNAME"));
            pstmt.setString(5, request.getParameter("RESIDENCY"));
            pstmt.setInt(
              6, Integer.parseInt(request.getParameter("SSN")));
            int rowCount = pstmt.executeUpdate();

            // Commit transaction
            conn.commit();
            conn.setAutoCommit(true);
          }
      %>

      <%-- -------- DELETE Code -------- --%>
      <%
          // Check if a delete is requested
          if (action != null && action.equals("delete")) {

            // Begin transaction
            conn.setAutoCommit(false);
            
            // Create the prepared statement and use it to
            // DELETE the student FROM the Student table.
            PreparedStatement pstmt = conn.prepareStatement(
              "DELETE CASCADE FROM Student WHERE student_id = ?");

            pstmt.setInt(
              1, Integer.parseInt(request.getParameter("student_id")));
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
            ("SELECT * FROM Student");
      %>
        <h1>Add a Student</h1>
      <!-- Add an HTML table header row to format the results -->
        <table border="1">
          <tr>
            <th>SSN</th>
            <th>STUDENT ID</th>
            <th>FIRST</th>
            <th>MIDDLE</th>
            <th>LAST</th>
            <th>RESIDENCY</th>
            <th>TYPE OF STUDENT</th>
            <th>ENROLLMENT PERIODS</th>
            <th>ACTION</th>
          </tr>
          <tr>
            <form action="students.jsp" method="get">
              <input type="hidden" value="insert" name="action">
              <th><input value="" name="SSN" size="10"></th>
              <th><input value="" name="student_id" size="10"></th>
              <th><input value="" name="FIRSTNAME" size="15"></th>
        <th><input value="" name="MIDDLENAME" size="15"></th>
              <th><input value="" name="LASTNAME" size="15"></th>
              <th><input value="" name="RESIDENCY" size="15"></th>
              <th><input value="" name="TYPE" size="15"></th>
              <th><input value="" name="E_PER" size="15"></th>
              <th><input type="submit" value="Insert"></th>
            </form>
          </tr>

      <%-- -------- Iteration Code -------- --%>
      <%
          // Iterate over the ResultSet
    
          while ( rs.next() ) {
    
      %>

          <tr>
            <form action="students.jsp" method="get">
              <input type="hidden" value="update" name="action">

              <%-- Get the SSN, which is a number --%>
              <td>
                <input value="<%= rs.getInt("SSN") %>" 
                  name="SSN" size="10">
              </td>
  
              <%-- Get the student_id --%>
              <td>
                <input value="<%= rs.getInt("student_id") %>" 
                  name="student_id" size="10">
              </td>
  
              <%-- Get the FIRSTNAME --%>
              <td>
                <input value="<%= rs.getString("FIRSTNAME") %>"
                  name="FIRSTNAME" size="15">
              </td>
  
              <%-- Get the LASTNAME --%>
              <td>
                <input value="<%= rs.getString("MIDDLENAME") %>" 
                  name="MIDDLENAME" size="15">
              </td>
  
        <%-- Get the LASTNAME --%>
              <td>
                <input value="<%= rs.getString("LASTNAME") %>" 
                  name="LASTNAME" size="15">
              </td>

              <%-- Get the COLLEGE --%>
              <td>
                <input value="<%= rs.getString("RESIDENCY") %>" 
                  name="RESIDENCY" size="15">
              </td>              
              <td>
                <input value="<%= rs.getString("TYPE") %>" 
                  name="TYPE" size="15">
              </td>
              <td>
                <input value="<%= rs.getString("E_PERIOD") %>" 
                  name="TYPE" size="15">
              </td>
  
              <%-- Button --%>
              <td>
                <input type="submit" value="Update">
              </td>
            </form>
            <form action="students.jsp" method="get">
              <input type="hidden" value="delete" name="action">
              <input type="hidden" 
                value="<%= rs.getInt("student_id") %>" name="student_id">
              <%-- Button --%>
              <td>
                <input type="submit" value="Delete">
              </td>
            </form>
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
