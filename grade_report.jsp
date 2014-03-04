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
      <%@ page language="java" import="java.sql.*" import="java.text.*" %>
  
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
      <form action="grade_report.jsp" action="get">
        <select name="student_id">
        <%
            // Iterate over the ResultSet
            while ( rs.next() ) {
        %>

          <option value="<%=rs.getInt("student_id")%>">
            SSN = <%= rs.getInt("SSN")%>, 
						NAME = <%= rs.getString("FIRSTNAME")%> 
									 <%=rs.getString("MIDDLENAME")%>
										<%=rs.getString("LASTNAME")%> 
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
          
              
            String student = "SELECT c.section_id, c.course_id, c.c_title, c.qtr_yr, s.grade, s.units " +
						"FROM CLASS as c, STUDENTCOURSEDATA as s " +
						"WHERE s.student_id=" + request.getParameter("student_id") + 
						 " AND s.section_id = c.section_id AND s.grade <> 'WIP' AND s.grade <> 'IN'";
					   
			    ResultSet class_set = statement.executeQuery(student);
            %>
                <table border="1">
                <tr>
                  <th>SECTION_ID</th>
                  <th>COURSE_ID</th>
                  <th>COURSE_TITLE</th>
                  <th>QTR YR</th>
                  <th>GRADE</th>
                  <th>UNITS</th>
                </tr>
      <%
            while(class_set.next()){
      %>
                <tr>
                  <form action="grade_report.jsp" method="get">
                    <input type="hidden" value="insert" name="action">
                    <th><%= class_set.getInt("section_id") %></th>
                    <th><%= class_set.getString("course_id") %></th>
                    <th><%= class_set.getString("c_title") %></th>
                    <th><%= class_set.getString("qtr_yr") %></th>
                    <th><%= class_set.getString("grade") %></th>
                    <th><%= class_set.getInt("units") %></th>
                  </form>
                </tr>
          <%
            }
            // Close result set
            class_set.close();

          }
  
      %>

        </table>
      <%-- -------- Display More Code -------- --%>
      <%
          String action2 = request.getParameter("action");
          System.out.println(action2);
          // Check if an insertion is requested
          if (action2 != null && action2.equals("ListClasses")) {
            System.out.println("Grade Hrer");
              // 
       		String grades = 
          " SELECT qtr_yr, SUM(number_grade * units)/SUM(units) as acc, SUM(number_grade * units) as tot_units " +
          " FROM CLASS as c, STUDENTCOURSEDATA s INNER JOIN GRADE_CONVERSION g on s.grade = g.letter_grade" +
          " WHERE s.student_id =" + request.getParameter("student_id") + 
          " AND s.section_id = c.section_id AND s.grade <> 'WIP' AND s.grade <> 'IN'" +
          " GROUP BY qtr_yr, units";
					   
			   	ResultSet grade_set = statement.executeQuery(grades); 
            %>
                <table border="1">
                <tr>
                  <th>QTR YR</th>
                  <th>ACCUMULATIVE GPA</th>
                </tr>
      			<%
						DecimalFormat df = new DecimalFormat("#.##");
						double overall_gpa = 0; //SUM(acc*tot_units)
						double overall_units = 0; //SUM(tot_units)
           while(grade_set.next()){
						overall_gpa += grade_set.getDouble("acc") * grade_set.getInt("tot_units");
						overall_units += grade_set.getInt("tot_units");
       %>
          <tr>
          	<form action="grade_report.jsp" method="get">
                    <input type="hidden" value="insert" name="action">
                    <th><%= grade_set.getString("qtr_yr") %></th>
                    <th><%= grade_set.getDouble("acc") %></th>
             </form>
           </tr>
    		<%
            }
						if (overall_units != 0.0)
						{ 
            %>
            <table border="1">
            <tr>
							<th>OVERALL GPA</th>
            </tr>
             <tr>
             	 <form action="grade_report.jsp" method="get">
                       <input type="hidden" value="insert" name="action">
                       <th><%=df.format(overall_gpa/overall_units) %></th>
               </form>
             </tr>
      			<%
						}
 						// Close result set
            grade_set.close();

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
