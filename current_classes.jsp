
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
        <select name="student_id">
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
        <input type="hidden" value="ListClasses" name="action">
        <input type="submit" value="ListClasses">
      </form>
      <%-- -------- Close Connection Code -------- --%>
      <%
          // Close the ResultSet from the student table
          rs.close();

      %>

      <%-- -------- Display Code -------- --%>
      <%
          String action = request.getParameter("action");
          System.out.println(action);
          // Check if an insertion is requested
          if (action != null && action.equals("ListClasses")) {
            System.out.println("Hrer");
              
            String student = "SELECT * " +
                              "FROM Class RIGHT JOIN Studentcoursedata " +
                              "ON Class.section_id=STUDENTCOURSEDATA.section_id "  +
                              "WHERE Studentcoursedata.student_id=" + request.getParameter("student_id") + 
                              "AND Class.qtr_yr='WI14' ";
            ResultSet class_set = statement.executeQuery(student);
            %>
                            <table border="1">
                <tr>
                  <th>SECTION_ID</th>
                  <th>COURSE_ID</th>
                  <th>COURSE_TITLE</th>
                  <th>QTR</th>
                  <th>ENROLLMENT_LIMIT</th>
                  <th>UNITS</th>
                </tr>
      <%
            while(class_set.next()){
      %>
                <tr>
                  <form action="class_enrollment.jsp" method="get">
                    <input type="hidden" value="insert" name="action">
                    <th><%= class_set.getInt("section_id") %></th>
                    <th><%= class_set.getInt("course_id") %></th>
                    <th><%= class_set.getString("c_title") %></th>
                    <th><%= class_set.getString("qtr_yr") %></th>
                    <th><%= class_set.getInt("e_limit") %></th>
                    <th><%= class_set.getInt("units") %></th>
                  </form>
                </tr>
          <%
            }
            // Close result set
            class_set.close();

          }
  
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
