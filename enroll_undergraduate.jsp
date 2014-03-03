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
            
            PreparedStatement pstmt = conn.prepareStatement(
              "INSERT INTO UGSTUDENTDEGREE VALUES (?, ?, ?, ?, ?)");

            pstmt.setInt(1, Integer.parseInt(request.getParameter("STUDENT_ID")));
            if(request.getParameter("MINOR") != ""){
              System.out.println("INSERTING MINOR");
              pstmt.setString(2, request.getParameter("MINOR"));
            }else{
              System.out.println("INSERTING null");
              pstmt.setString(2, null);
            }
            pstmt.setString(3, request.getParameter("MAJOR"));
            pstmt.setString(4, request.getParameter("MS5YR"));
            pstmt.setString(5, request.getParameter("COLLEGE"));
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
            ("SELECT * FROM UGSTUDENTDEGREE");
      %>
        <h1>Enroll Student in Undergraduate</h1>
      <!-- Add an HTML table header row to format the results -->
        <table border="1">
          <tr>
            <th>STUDENT ID</th>
            <th>MINOR</th>
            <th>MAJOR</th>
            <th>MS5YR (Y/N)</th>
            <th>COLLEGE</th>
            <th>ACTION</th>
          </tr>
          <tr>
            <form action="enroll_undergraduate.jsp" method="get">
              <input type="hidden" value="insert" name="action">
              <th><input value="" name="STUDENT_ID" size="10"></th>
              <th><input value="" name="MINOR" size="10"></th>
              <th><input value="" name="MAJOR" size="15"></th>
              <th><input value="" name="MS5YR" size="15"></th>
              <th><input value="" name="COLLEGE" size="15"></th>
              <th><input type="submit" value="Insert"></th>
            </form>
          </tr>

      <%-- -------- Iteration Code -------- --%>
      <%
          // Iterate over the ResultSet
    
          while ( rs.next() ) {
    
      %>

          <tr>
            <form action="enroll_undergraduate.jsp" method="get">
              <input type="hidden" value="update" name="action">

              <td>
                <input value="<%= rs.getString("student_id") %>" 
                  name="STUDENT_ID" size="10">
              </td>
              <%
              if (rs.getString("minor") != null){
                System.out.println("ENTERED HERE");               
              %>                    
                <td>
                  <input value="<%= rs.getString("minor") %>" 
                    name="prereq" size="15">
                </td>
              <% 
              }else{
              %>
                <td>
                  <input value="None" 
                    name="prereq" size="15">
                </td>
              <%
              }
              %>
              <td>
                <input value="<%= rs.getString("major") %>"
                  name="MAJOR" size="15">
              </td>
              <td>
                <input value="<%= rs.getString("MS5yr") %>" 
                  name="MS5YR" size="15">
              </td>
              <td>
                <input value="<%= rs.getString("college") %>"
                  name="COLLEGE" size="15">
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
