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
              "INSERT INTO Class VALUES (?, ?, ?, ?, ?, ?)");

            class_entry_state.setInt(1, Integer.parseInt(request.getParameter("SECTION_ID")));
            class_entry_state.setInt(2, Integer.parseInt(request.getParameter("COURSE_ID")));
            class_entry_state.setString(3, request.getParameter("C_TITLE"));
            class_entry_state.setString(4, request.getParameter("qtr"));
            class_entry_state.setInt(5, Integer.parseInt(request.getParameter("year")));
            class_entry_state.setInt(6, Integer.parseInt(request.getParameter("limit")));
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
          ResultSet rs =  statement.executeQuery("SELECT * from Class");
      %>
        <h1>Add a Class</h1>
      <!-- Add an HTML table header row to format the results -->
        <table border="1">
          <tr>
            <th>SECTION ID</th>
            <th>COURSE ID</th>
            <th>COURSE TITLE</th>
            <th>QTR</th>
            <th>YEAR</th>
            <th>ENROLL LIMIT</th>
            <th>ACTION</th>
          </tr>
          <tr>
            <form action="class.jsp" method="get">
              <input type="hidden" value="insert" name="action">
              <th><input value="" name="SECTION_ID" size="10"></th>
              <th><input value="" name="COURSE_ID" size="10"></th>
              <th><input value="" name="C_TITLE" size="15"></th>
              <th><input value="" name="qtr" size="15"></th>
              <th><input value="" name="year" size="15"></th>
              <th><input value="" name="limit" size="15"></th>
              <th><input type="submit" value="Insert"></th>
            </form>
          </tr>

      <%-- -------- Iteration Code -------- --%>
      <%
          // Iterate over the ResultSet
    
          while ( rs.next() ) {
    
      %>

          <tr>
            <form action="class.jsp" method="get">
              <input type="hidden" value="update" name="action">
              <td>
                <input value="<%= rs.getInt("section_id") %>" 
                  name="section_id" size="10">
              </td>
              <td>
                <input value="<%= rs.getInt("course_id") %>" 
                  name="course_id" size="10">
              </td>
              <td>
                <input value="<%= rs.getString("c_title") %>"
                  name="c_title" size="15">
              </td>
              <td>
                <input value="<%= rs.getString("qtr") %>" 
                  name="qtr" size="15">
              </td>
              <td>
                <input value="<%= rs.getInt("year") %>" 
                  name="year" size="15">
              </td>
              <td>
                <input value="<%= rs.getString("e_limit") %>" 
                  name="limit" size="15">
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
