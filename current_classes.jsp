
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

      <%-- -------- Display Code -------- --%>
      <%
          String action = request.getParameter("action");
          // Check if an insertion is requested
          if (action != null && action.equals("ListClasses")) {

            %>
            <p>HHHHHHAHAHAHAKAUFHOIASDUHFKJLSDHFKJLHSDLKFH </p>
            <%
            
/*             
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
            conn.setAutoCommit(true); */
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
        <h1>Select a Student</h1>
      <form action="current_classes.jsp" action="get">
        <select>
        <%
            // Iterate over the ResultSet
            while ( rs.next() ) {
        %>

          <option value="<%=rs.getInt("student_id")%>">
            SSN = <%= rs.getInt("SSN")%>, NAME = <%= rs.getString("FIRSTNAME")%> <%=rs.getString("MIDDLENAME")%> <%=rs.getString("LASTNAME")%> 
          </option>
        <%
            }
        %>
        </select>
        <input type="submit" value="ListClasses">
      </form>
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
