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
              "INSERT INTO PREREQ VALUES (?, ?)");

            pstmt.setString(1, request.getParameter("PRE"));
            pstmt.setString(2, request.getParameter("ID"));

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
            ("SELECT * FROM PREREQ");
      %>
        <h1>Add Prereq</h1>
      <!-- Add an HTML table header row to format the results -->
        <table border="1">
          <tr>
            <th>PRE COURSE ID</th>
            <th>COURSE ID</th>
            <th>Action</th>
          </tr>
          <tr>
            <form action="add_prereq.jsp" method="get">
              <input type="hidden" value="insert" name="action">
              <th><input value="" name="PRE" size="15"></th>
              <th><input value="" name="ID" size="15"></th>
              <th><input type="submit" value="Insert"></th>
            </form>
          </tr>


      <%-- -------- Iteration Code -------- --%>
      <%
          // Iterate over the ResultSet
    
          while ( rs.next() ) {
    
      %>

          <tr>
            <form action="add_prereq.jsp" method="get">
              <input type="hidden" value="update" name="action">

              <%-- Get the PRE --%>
              <td>
                <input value="<%= rs.getString("pre_course_id") %>" 
                  name="PRE" size="15">
              </td>

              <%-- Get the ID --%>
              <td>
                <input value="<%= rs.getString("course_id") %>" 
                  name="ID" size="15">
              </td>
  
            </form>
            <form action="add_prereq.jsp" method="get">
              <input type="hidden" 
                value="<%= rs.getString("pre_course_id") %>" name="PRE">
                <input type="hidden" value="<%= rs.getString("course_id") %>" name="ID">
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
