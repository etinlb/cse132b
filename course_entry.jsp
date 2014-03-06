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
          Class.forName("org.postgresql.Driver"); 
          Connection conn = null;
          try {
          // Load Oracle Driver class file
           // (new com.microsoft.sqlserver.jdbc.SQLServerDriver());
          // Make a connection to the Oracle datasource "cse132b"
          //Connection conn = null;
          conn = DriverManager.getConnection
            ("jdbc:postgresql://localhost:8080/cse132b", 
              "sa", "123456");
          } catch (Exception e){
              try{
                  //Class.forName("org.postgresql.Driver"); 
                  // Make a connection to the Oracle datasource "cse132b"
                 conn = DriverManager.getConnection
                        ("jdbc:postgresql://localhost:5432/cse132b", 
                         "sa", "123456");
              } catch (Exception es){
                out.println(e.getMessage());
              }
          }

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
            PreparedStatement course_entry_state = conn.prepareStatement(
              "INSERT INTO Course VALUES (?, ?, ?, ?, ?, ?)");

            course_entry_state.setString(1, request.getParameter("COURSE_ID"));
            course_entry_state.setString(2, request.getParameter("GRADEOPT"));
            course_entry_state.setString(3, request.getParameter("LABWORK"));
            course_entry_state.setInt(4, Integer.parseInt(request.getParameter("START_UNITS")));
            course_entry_state.setInt(5, Integer.parseInt(request.getParameter("END_UNITS")));
            course_entry_state.setString(6, request.getParameter("DEPARTMENT"));
            int rowCount = course_entry_state.executeUpdate();

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
          ResultSet course = statement.executeQuery
            ("SELECT * from Course");
      %>
        <h1>Enter a Course</h1>
      <!-- Add an HTML table header row to format the results -->
        <table border="1">
          <tr>
            <th>COURSE ID</th>
            <th>GRADEOPT</th>
            <th>LABWORK</th>
            <th>START UNITS</th>
            <th>END	UNITS</th>
            <th>DEPARTMENT</th>
            <th>ACTION</th>
          </tr>
          <tr>
            <form action="course_entry.jsp" method="get">
              <input type="hidden" value="insert" name="action">
              <th><input value="" name="COURSE_ID" size="15"></th>
              <th><input value="" name="GRADEOPT" size="15"></th>
              <th><input value="" name="LABWORK" size="15"></th>
              <th><input value="" name="START_UNITS" size="15"></th>
              <th><input value="" name="END_UNITS" size="15"></th>
              <th><input value="" name="DEPARTMENT" size="15"></th>
              <th><input type="submit" value="Insert"></th>
            </form>
          </tr>

      <%-- -------- Iteration Code -------- --%>
      <%
          // Iterate over the ResultSet
    
          while ( course.next() ) {
    
      %>

          <tr>
            <form action="course_entry.jsp" method="get">
              <input type="hidden" value="update" name="action">
              <td>
                <input value="<%= course.getString("course_id") %>" 
                  name="course_id" size="15">
              </td>
              <td>
                <input value="<%= course.getString("grade_opt") %>" 
                  name="grade_opt" size="15">
              </td>
              <td>
                <input value="<%= course.getString("labwork") %>"
                  name="labwork" size="15">
              </td>
              <td>
                <input value="<%= course.getInt("start_units") %>" 
                  name="units" size="15">
              </td>
              <td>
                <input value="<%= course.getInt("end_units") %>" 
                  name="units" size="15">
              </td>
              <td>
                <input value="<%= course.getString("d_name") %>" 
                  name="d_name" size="15">
              </td>
            </form>
          </tr>
      <%
          }
      %>

      <%-- -------- Close Connection Code -------- --%>
      <%
          // Close the ResultSet
          course.close();
  
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
