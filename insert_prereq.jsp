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
              "INSERT INTO PREREQ VALUES (?, ?");

            course_entry_state.setInt(
              1, Integer.parseInt(request.getParameter("PRE_COURSE_ID")));
            course_entry_state.setString(2,  Integer.parseInt(request.getParameter("COURSE_ID")));
            course_entry_state.setString(3, request.getParameter("LABWORK"));
            course_entry_state.setInt(4, Integer.parseInt(request.getParameter("UNITS")));
            course_entry_state.setString(5, request.getParameter("DEPARTMENT"));
            int rowCount = course_entry_state.executeUpdate();

            //prereq insertion 
            System.out.println("prereq is ");
            System.out.println(request.getParameter("PREREQ"));
            if ( request.getParameter("PREREQ") != ""){ 
              System.out.println("trying to insert prereq from above print");              
              PreparedStatement prereq_entry = conn.prepareStatement(
                "INSERT INTO Prereq VALUES (?, ?)");
              prereq_entry.setInt(
                1, Integer.parseInt(request.getParameter("PREREQ")));
              prereq_entry.setInt(
                2, Integer.parseInt(request.getParameter("COURSE_ID")));
              rowCount = prereq_entry.executeUpdate();
            }

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
            ("SELECT * from Course left join PREREQ on course.course_id=PREREQ.course_id");
      %>
        <h1>Insert a Prereq</h1>
      <!-- Add an HTML table header row to format the results -->
        <table border="1">
          <tr>
            <th>Course_id</th>
            <th>Gradeopt</th>
            <th>Labwork</th>
            <th>Units</th>
            <th>Department</th>
            <th>Preq</th>
          </tr>
          <tr>
            <form action="course_entry.jsp" method="get">
              <input type="hidden" value="insert" name="action">
              <th><input value="" name="COURSE_ID" size="10"></th>
              <th><input value="" name="GRADEOPT" size="10"></th>
              <th><input value="" name="LABWORK" size="15"></th>
              <th><input value="" name="UNITS" size="15"></th>
              <th><input value="" name="DEPARTMENT" size="15"></th>
              <th><input value="" name="PREREQ" size="15"></th>
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
                <input value="<%= course.getInt("course_id") %>" 
                  name="course_id" size="10">
              </td>
              <td>
                <input value="<%= course.getString("grade_opt") %>" 
                  name="grade_opt" size="10">
              </td>
              <td>
                <input value="<%= course.getString("labwork") %>"
                  name="labwork" size="15">
              </td>
              <td>
                <input value="<%= course.getInt("units") %>" 
                  name="units" size="15">
              </td>
              <td>
                <input value="<%= course.getString("d_name") %>" 
                  name="d_name" size="15">
              </td>

              <%
              if (course.getString("pre_course_id") != null){
              System.out.println("ENTERED HERE");               
              %>                    
              <td>
                <input value="<%= course.getString("pre_course_id") %>" 
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
