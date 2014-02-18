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
            PreparedStatement enroll_entry_state = conn.prepareStatement(
              "INSERT INTO StudentCourseData VALUES (?, ?, ?, ?, ?, ?, ?)");

            enroll_entry_state.setInt(1, Integer.parseInt(request.getParameter("SECTION_ID")));
            enroll_entry_state.setInt(2, Integer.parseInt(request.getParameter("STUDENT_ID")));
            enroll_entry_state.setString(3, request.getParameter("GRADE_TYPE"));
            enroll_entry_state.setString(4, request.getParameter("GRADE"));
            enroll_entry_state.setString(5, "Completed");
            enroll_entry_state.setString(6, request.getParameter("QTR"));
            enroll_entry_state.setInt(7, Integer.parseInt(request.getParameter("UNITS")));
            int rowCount = enroll_entry_state.executeUpdate();

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
          ResultSet enrollment_set = statement.executeQuery
            ("SELECT * from StudentCourseData WHERE grade<>'WIP'");
      %>
        <h1>Add Class to Student History</h1>
      <!-- Add an HTML table header row to format the results -->
        <table border="1">
          <tr>
            <th>SECTION_ID</th>
            <th>STUDENT_ID</th>
            <th>GRADE_TYPE</th>
            <th>GRADE</th>
            <th>QUARTERTAKEN</th>
            <th>UNITS</th>
          </tr>
          <tr>
            <form action="past_enrollment.jsp" method="get">
              <input type="hidden" value="insert" name="action">
              <th><input value="" name="SECTION_ID" size="10"></th>
              <th><input value="" name="STUDENT_ID" size="10"></th>
              <th><input value="" name="GRADE_TYPE" size="15"></th>
              <th><input value="" name="GRADE" size="15"></th>
              <th><input value="" name="QTR" size="15"></th>
              <th><input value="" name="UNITS" size="15"></th>
              <th><input type="submit" value="Insert"></th>
            </form>
          </tr>

      <%-- -------- Iteration Code -------- --%>
      <%
          // Iterate over the ResultSet
    
          while ( enrollment_set.next() ) {
    
      %>

          <tr>
            <form action="past_enrollment.jsp" method="get">
              <input type="hidden" value="update" name="action">
              <td>
                <input value="<%= enrollment_set.getInt("section_id") %>" 
                  name="SECTION_ID" size="10">
              </td>
              <td>
                <input value="<%= enrollment_set.getInt("student_id") %>" 
                  name="STUDENT_ID" size="10">
              </td>
              <td>
                <input value="<%= enrollment_set.getString("grade_type") %>"
                  name="GRADE_TYPE" size="15">
              </td>
              <td>
                <input value="<%= enrollment_set.getString("grade") %>"
                  name="GRADE" size="15">
              </td>
              <td>
                <input value="<%= enrollment_set.getString("qtr") %>"
                  name="QTR" size="15">
              </td>              
              <td>
                <input value="<%= enrollment_set.getInt("units") %>"
                  name="UNITS" size="15">
              </td>
            </form>
          </tr>
      <%
          }
      %>

      <%-- -------- Close Connection Code -------- --%>
      <%
          // Close the ResultSet
          enrollment_set.close();
  
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
