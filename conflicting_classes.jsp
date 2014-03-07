
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
            ("SELECT * FROM Student");
      %>
        <h1>Select a Student</h1>
      <form action="conflicting_classes.jsp" action="get">
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
              
            String student = "SELECT * FROM (SELECT mt.section_id as msection_id, start_time as mstart_time, end_time as mend_time,  " +
                             "days_of_week as mdays_of_week, mandatory as mmandatory, course_id as mcourse_id FROM Class AS cs  " +
                             "JOIN Meeting AS mt ON mt.section_id=cs.section_id " +
                             "INNER JOIN Studentcoursedata AS sd ON sd.section_id=mt.section_id " +
                             "WHERE sd.student_id=" +request.getParameter("student_id")+" AND cs.qtr_yr='WI14') AS taken " +
                             "JOIN (SELECT cs.*, days_of_week, start_time, end_time FROM Class as cs  " +
                             "JOIN Meeting as mt ON cs.section_id=mt.section_id " +
                             "WHERE cs.qtr_yr='WI14') AS cs ON cs.section_id<>msection_id AND  " +
                             "((cs.start_time<=mstart_time AND cs.end_time>mstart_time) OR  " +
                             "(cs.start_time<mend_time AND cs.end_time >mend_time))  ";

            ResultSet class_set = statement.executeQuery(student);
            %>
              <table border="1">
                <tr>
                  <th>SECTION_ID ENROLLED</th>
                  <th>START_TIME</th>
                  <th>END_TIME</th>
                  <th>SECTION_ID CONFLICTING</th>
                  <th>START_TIME</th>
                  <th>END_TIME</th>
                  <th>CONFLICTING DAYS</th>                  
                </tr>
      <%
            while(class_set.next()){
            String con_days = class_set.getString("days_of_week");
            System.out.println(con_days);
            String[] potential_con_days = con_days.split("(?=[A-Z])");
            //System.out.println(potential_con_days[0]);
            String days_conf = "";
            for(int i=0;i<potential_con_days.length;i++){
              if(!potential_con_days[i].equals("")){
                if(class_set.getString("mdays_of_week").contains(potential_con_days[i])){
                  System.out.println(":LKJSDFL:KJS");
                  days_conf = days_conf.concat(potential_con_days[i]);
                }
              }
            }
            if(days_conf.equals("")){
              System.out.println("noep");
              continue;
            }
      %>
                <tr>
                  <form action="class_enrollment.jsp" method="get">
                    <input type="hidden" value="insert" name="action">
                    <th><%= class_set.getInt("msection_id") %></th>
                    <th><%= class_set.getString("mstart_time") %></th>
                    <th><%= class_set.getString("mend_time") %></th>
                    <th><%= class_set.getString("section_id") %></th>
                    <th><%= class_set.getInt("start_time") %></th>
                    <th><%= class_set.getInt("end_time") %></th>
                    <th><%= days_conf %></th>
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
