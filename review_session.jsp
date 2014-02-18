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
            PreparedStatement class_entry_state = conn.prepareStatement(
              "INSERT INTO MEETING VALUES (?, ?, ?, ?, ?, ?, ?)");

            class_entry_state.setInt(1, Integer.parseInt(request.getParameter("SECTION_ID")));
            class_entry_state.setString(2, request.getParameter("DAYS_OF_WEEK"));
            class_entry_state.setString(3, request.getParameter("TIME_RANGE"));
            class_entry_state.setString(4, request.getParameter("DATE_RANGE"));
            class_entry_state.setString(5, request.getParameter("MANDATORY"));
            class_entry_state.setString(6, "rv");
            class_entry_state.setString(7, request.getParameter("LOCATION"));
            int rowCount = class_entry_state.executeUpdate();

            // Commit transaction
            conn.commit();
            conn.setAutoCommit(true);
          }
      %>

      <%-- -------- SELECT Statement Code -------- --%>
      <%
          // Create the statement
          Statement statement = conn.createStatement();
          //get the classes
          ResultSet rs =  statement.executeQuery("SELECT * from MEETING WHERE type='rv'");
      %>
      <h1>Add a Review</h1>
      <!-- Add an HTML table header row to format the results -->
        <table border="1">
          <tr>
            <th>SECTION ID</th>
            <th>DAYS OF WEEK</th>
            <th>TIME RANGE</th>
            <th>DATE RANGE</th>
            <th>MANDATORY</th>
            <th>LOCATION</th>
            <th>ACTION</th>
          </tr>
          <tr>
            <form action="review_session.jsp" method="get">
              <input type="hidden" value="insert" name="action">
              <th><input value="" name="SECTION_ID" size="10"></th>
              <th><input value="" name="DAYS_OF_WEEK" size="10"></th>
              <th><input value="" name="TIME_RANGE" size="15"></th>
              <th><input value="" name="DATE_RANGE" size="15"></th>
              <th><input value="" name="MANDATORY" size="15"></th>
              <th><input value="" name="LOCATION" size="15"></th>
              <th><input type="submit" value="Insert"></th>
            </form>
          </tr>

      <%-- -------- Iteration Code -------- --%>
      <%
          // Iterate over the ResultSet
    
          while ( rs.next() ) {
    
      %>

          <tr>
            <form action="review_session.jsp" method="get">
              <input type="hidden" value="update" name="action">
              <td>
                <input value="<%= rs.getInt("section_id") %>" 
                  name="SECTION_ID" size="10">
              </td>
              <td>
                <input value="<%= rs.getString("days_of_week") %>" 
                  name="DAYS_OF_WEEK" size="10">
              </td>
              <td>
                <input value="<%= rs.getString("time_range") %>"
                  name="TIME_RANGE" size="15">
              </td>
              <td>
                <input value="<%= rs.getString("date_range") %>" 
                  name="DATE_RANGE" size="15">
              </td>
              <td>
                <input value="<%= rs.getString("mandatory") %>" 
                  name="MANDATORY" size="15">
              </td>
              <td>
                <input value="<%= rs.getString("location") %>" 
                  name="LOCATION" size="15">
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
