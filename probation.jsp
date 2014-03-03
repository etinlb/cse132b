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
            PreparedStatement pstmt = conn.prepareStatement(
              "INSERT INTO PROBATIONPERIODS VALUES (?, ?, ?, ?)");
            
            pstmt.setInt(
              1, Integer.parseInt(request.getParameter("ID")));
            pstmt.setString(2, request.getParameter("S_PERIOD"));
            pstmt.setString(3, request.getParameter("E_PERIOD"));
            pstmt.setString(4, request.getParameter("REASON"));
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
              "DELETE FROM PROBATIONPERIODS WHERE ID = ? AND PERIODS = ?");

            pstmt.setInt(
              1, Integer.parseInt(request.getParameter("ID")));
            pstmt.setString( 2, request.getParameter("PERIOD"));
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
            ("SELECT * FROM PROBATIONPERIODS");
      %>
        <h1>Add Probation</h1>
      <!-- Add an HTML table header row to format the results -->
        <table border="1">
          <tr>
            <th>STUDENT ID</th>
            <th>START PERIOD</th>
            <th>END PERIOD</th>
            <th>REASON</th>
            <th>ACTION</th>
          </tr>
          <tr>
            <form action="probation.jsp" method="get">
              <input type="hidden" value="insert" name="action">
              <th><input value="" name="ID" size="15"></th>
              <th><input value="" name="S_PERIOD" size="15"></th>
              <th><input value="" name="E_PERIOD" size="15"></th>
              <th><input value="" name="REASON" size="60"></th>
              <th><input type="submit" value="Insert"></th>
            </form>
          </tr>

      <%-- -------- Iteration Code -------- --%>
      <%
          // Iterate over the ResultSet
    
          while ( rs.next() ) {
    
      %>

          <tr>
            <form action="probation.jsp" method="get">
              <input type="hidden" value="update" name="action">

              <%-- Get the ID --%>
              <td>
                <input value="<%= rs.getInt("student_id") %>" 
                  name="ID" size="15">
              </td>
  
              <%-- Get the START PERIOD --%>
              <td>
                <input value="<%= rs.getString("s_period") %>" 
                  name="PERIOD" size="15">
              </td>
              
              <%-- Get the END PERIOD --%>
              <td>
                <input value="<%= rs.getString("e_period") %>" 
                  name="PERIOD" size="15">
              </td>
              
              <%-- Get the REASON --%>
              <td>
                <input value="<%= rs.getString("reason") %>"
                  name="REASON" size="60">
              </td>

  
              <%-- Button --%>
              <td>
                <input type="submit" value="Update">
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
