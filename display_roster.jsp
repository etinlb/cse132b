
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

      <%-- -------- SELECT Statement Code -------- --%>
      <%
          // Create the statement
          Statement statement = conn.createStatement();

          // Use the created statement to SELECT
          // the student attributes FROM the Student table.
          ResultSet rs = statement.executeQuery
            ("SELECT * FROM Class");
      %>
        <h1>Select a Class</h1>
      <form action="display_roster.jsp" action="get">
        <select name="c_title">
        <%
            // Iterate over the ResultSet
            while ( rs.next() ) {
        %>

          <option value="<%=rs.getString("c_title")%>">
            Title = <%= rs.getString("c_title")%> Course_id = <%= rs.getString("course_id")%>, QUARTER = <%= rs.getString("qtr_yr")%> Section_id = <%=rs.getInt("section_id")%> 
          </option>
        <%
            }
        %>
        </select>
        <input type="hidden" value="ListRoster" name="action">
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
          if (action != null && action.equals("ListRoster")) {
            System.out.println("Hrer");
              
            String query = "SELECT * " +
                           "FROM STUDENT INNER JOIN STUDENTCOURSEDATA ON " +
                           "STUDENT.student_id = STUDENTCOURSEDATA.student_id " +
                           "WHERE section_id IN ( SELECT section_id FROM CLASS WHERE c_title ='"  + request.getParameter("c_title") + "')";
            ResultSet student_set = statement.executeQuery(query);
            %>
                <table border="1">
                <tr>
                  <th>SSN</th>
                  <th>Student_id</th>
                  <th>Name</th>
                  <th>Residency</th>
                  <th>Type</th>
                  <th>Units</th>
                  <th>Grade_Option</th>
                </tr>
      <%
            while(student_set.next()){
      %>
                <tr>
                  <form action="class_enrollment.jsp" method="get">
                    <input type="hidden" value="insert" name="action">
                    <th><%= student_set.getInt("SSN") %></th>
                    <th><%= student_set.getInt("student_id") %></th>
                    <th><%= student_set.getString("FIRSTNAME") %> <%= student_set.getString("MIDDLENAME") %> <%= student_set.getString("LASTNAME") %></th>
                    <th><%= student_set.getString("RESIDENCY") %></th>
                    <th><%= student_set.getString("TYPE") %></th>
                    <th><%= student_set.getInt("units") %></th>
                    <th><%= student_set.getString("grade_type") %></th>
                  </form>
                </tr>
          <%
            }
            // Close result set
            student_set.close();

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
