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
            ("SELECT * FROM COURSE");
      %>
        <h1>Select a Course</h1>
      <form action="decision_support.jsp" action="get">
        <select name="course_id">
        <%
            // Iterate over the ResultSet
            while ( rs.next() ) {
        %>

          <option value="<%=rs.getString("course_id")%>">
            COURSE ID = <%= rs.getString("course_id")%>
          </option>
        <%
            }
        %>
        </select>
        <input type="hidden" value="Course Selected" name="action">
        <input type="submit" value="Select Course">
      </form>

      <%-- -------- SELECT Statement Code -------- --%>
      <%

          String action = request.getParameter("action");
          // Use the created statement to SELECT
          // the student attributes FROM the Student table.
					String courseID = "initial";
					if ( action.equals("Course Selected") )
					{
					 String student2 = 
              " SELECT c.course_id, c.c_title, " + 
							" sum(case when grade LIKE 'A%' then 1 else 0 end) Acount, " +
              " sum(case when grade LIKE 'B%' then 1 else 0 end) Bcount, " +
							" sum(case when grade LIKE 'C%' then 1 else 0 end) Ccount, " +
              " sum(case when grade LIKE 'D%' then 1 else 0 end) Dcount, " +
              " sum(g.number_grade)/count(*) AS avg_gpa " +
              " FROM Instructorof AS i LEFT JOIN class AS c ON i.section_id = c.section_id " +
              " LEFT JOIN studentcoursedata as s on i.section_id = s.section_id  " +
              " LEFT JOIN grade_conversion as g on s.grade = g.letter_grade " +
							" WHERE c.course_id ='" + request.getParameter("course_id") + "'" +
							" GROUP BY c.course_id, c.c_title";
						ResultSet course_set = statement.executeQuery(student2); 
            courseID = request.getParameter("course_id");
      		%>
    				<table border="1">
                <tr>
                  <th>COURSE ID</th>
                  <th>Course Title</th>
									<th> A's </th>
									<th> B's </th>
									<th> C's </th>
									<th> D's </th>
                  <th>Avg GPA</th>
                </tr> 
          <%
      			while(course_set.next() ) 
						{
       		%>
                <tr>
                  <form action="decision_support.jsp" method="get">
                    <input type="hidden" value="insert" name="action">
                    <th><%= course_set.getString("course_id") %></th>
                    <th><%= course_set.getString("c_title") %></th>
                    <th><%= course_set.getInt("acount") %></th>
                    <th><%= course_set.getInt("bcount") %></th>
                    <th><%= course_set.getInt("ccount") %></th>
                    <th><%= course_set.getInt("dcount") %></th>
                    <th><%= course_set.getDouble("avg_gpa") %></th>
                  </form>
                </tr>
          <%
            }

					}

					if ( action.equals("Course Selected") || action.equals("Selected Professor") )
/*START*/ {
						ResultSet rs2 = statement.executeQuery
            ("SELECT DISTINCT c.course_id, i.fac_fname, i.fac_lname" +
						" FROM Instructorof AS i LEFT JOIN class AS c ON i.section_id = c.section_id" +
						" WHERE c.course_id='" + courseID +"'"); 
						System.out.println( "course id print" + courseID );
      %>
        <h1>Select a Professor</h1>
      <form action="decision_support.jsp" action="get">
        <select name="prof">
        <%
            // Iterate over the ResultSet
            while ( rs2.next() ) 
 						{
        %>

          <option value="<%=rs2.getString("fac_lname")%>,<%=rs2.getString("fac_fname")%>,<%=rs2.getString("course_id")%>">
            PROFESSOR = <%= rs2.getString("fac_lname")%>, <%= rs2.getString("fac_fname")%>
          </option>
        <%
            }
        %>
        </select>
        <input type="hidden" value="Selected Professor" name="action">
        <input type="submit" value="Select Professor">
      </form>
      <%-- -------- SELECT Statement Code -------- --%>
      <%
					if ( action.equals("Selected Professor") )
					{
						String delim = "[,]";
						String [] data = request.getParameter("prof").split(delim);
						String pass_on = request.getParameter("prof");
						System.out.println( data[0] );
						System.out.println( data[1] );
						System.out.println( data[2] );
            System.out.println("L::LSDKFJ:LSKDFJLSDJFL:KSDJFL:KSDJFL");
					 String student3 = 
              " SELECT c.course_id, c.c_title, i.fac_lname, i.fac_fname," + 
							" sum(case when grade LIKE 'A%' then 1 else 0 end) Acount, " +
              " sum(case when grade LIKE 'B%' then 1 else 0 end) Bcount, " +
							" sum(case when grade LIKE 'C%' then 1 else 0 end) Ccount, " +
              " sum(case when grade LIKE 'D%' then 1 else 0 end) Dcount, " +
              " sum(g.number_grade)/count(*) AS avg_gpa " +
              " FROM Instructorof AS i LEFT JOIN class AS c ON i.section_id = c.section_id " +
              " LEFT JOIN studentcoursedata as s on i.section_id = s.section_id  " +
              " LEFT JOIN grade_conversion as g on s.grade = g.letter_grade " +
							" WHERE c.course_id ='" + data[2] + "' AND i.fac_lname='" + data[0] +"' AND " +
							" i.fac_fname ='" + data[1] + "'" +
							" GROUP BY c.course_id, c.c_title, i.fac_lname, i.fac_fname";
						ResultSet instr_set= statement.executeQuery(student3); 
						System.out.println( "EXECUTED" );
      		%>
    				<table border="1">
                <tr>
                  <th>COURSE ID</th>
                  <th>Instructor Fname</th>
                  <th>Instructor Lname</th>
                  <th>Course Title</th>
									<th> A's </th>
									<th> B's </th>
									<th> C's </th>
									<th> D's </th>
                  <th>Avg GPA</th>
                </tr> 
          <%
      			while(instr_set.next() ) 
						{
       		%>
                <tr>
                  <form action="decision_support.jsp" method="get">
                    <input type="hidden" value="insert" name="action">
                    <th><%= instr_set.getString("course_id") %></th>
                    <th><%= instr_set.getString("fac_fname") %></th>
                    <th><%= instr_set.getString("fac_lname") %></th>
                    <th><%= instr_set.getString("c_title") %></th>
                    <th><%= instr_set.getInt("acount") %></th>
                    <th><%= instr_set.getInt("bcount") %></th>
                    <th><%= instr_set.getInt("ccount") %></th>
                    <th><%= instr_set.getInt("dcount") %></th>
                    <th><%= instr_set.getDouble("avg_gpa") %></th>
                  </form>
                </tr>
          <%
            }
					}
					if ( action.equals("Selected Professor") || action.equals("QTR Selected") )
/*START*/ {
						String delim = "[,]";
						String [] data = request.getParameter("prof").split(delim);
						String pass_on = request.getParameter("prof");
						System.out.println( data[0] );
						System.out.println( data[1] );
						System.out.println( data[2] );
          
						ResultSet rs3 = statement.executeQuery
            ("SELECT c.qtr_yr" +
						" FROM Instructorof AS i LEFT JOIN class AS c ON i.section_id = c.section_id" +
						" WHERE c.course_id='" + data[2] +"' AND i.fac_fname='" +
							data[1] + "' AND i.fac_lname='" + data[0] + "'"); 
      %>
        <h1>Select a Quarter</h1>
      <form action="decision_support.jsp" action="get">
        <select name="qtr">
        <%
            // Iterate over the ResultSet
            while ( rs3.next() ) 
 						{
        %>

          <option value="<%=pass_on%>,<%=rs3.getString("qtr_yr")%>">
            QUARTER = <%= rs3.getString("qtr_yr")%>
          </option>
        <%
            }
        %>
        </select>
        <input type="hidden" value="QTR Selected" name="action">
        <input type="submit" value="Select QTR">
      </form>
      <%-- -------- Close Connection Code -------- --%>
      <%
          // Close the ResultSet from the student table
          rs3.close();
/*END3*/   }
          // Close the ResultSet from the student table
          rs2.close();
/*END2*/   }

          // Close the ResultSet from the student table
          rs.close();

      %>
      <%-- -------- Display Code -------- --%>
      <%
						String delim = "[,]";
						String [] data = request.getParameter("qtr").split(delim);
						System.out.println(request.getParameter("qtr"));
						System.out.println( "final set = " + data[0] + data[1] + data[2] + data[3]);
					 String student = 
              " SELECT c.course_id, c.qtr_yr, fac_fname, i.fac_lname, c.c_title, " + 
							" sum(case when grade LIKE 'A%' then 1 else 0 end) Acount, " +
              " sum(case when grade LIKE 'B%' then 1 else 0 end) Bcount, " +
							" sum(case when grade LIKE 'C%' then 1 else 0 end) Ccount, " +
              " sum(case when grade LIKE 'D%' then 1 else 0 end) Dcount, " +
              " sum(g.number_grade)/count(*) AS avg_gpa " +
              " FROM Instructorof AS i LEFT JOIN class AS c ON i.section_id = c.section_id " +
              " LEFT JOIN studentcoursedata as s on i.section_id = s.section_id  " +
              " LEFT JOIN grade_conversion as g on s.grade = g.letter_grade " +
              " WHERE c.course_id='" + data[2] + "' AND i.fac_fname='" + data[1] + "'" +
							" AND i.fac_lname='" + data[0] + "'" +
              " AND c.qtr_yr='" + data[3] + "' AND s.grade <> 'WIP' AND s.grade <> 'IN' " +
              " GROUP BY i.fac_fname, i.fac_lname, c.c_title, c.qtr_yr, c.course_id";
										    ResultSet final_set = statement.executeQuery(student); 
          
					// Check if an insertion is requested
          if (action != null && action.equals("QTR Selected")) 
					{
      		%>
    				<table border="1">
                <tr>
                  <th>COURSE ID</th>
                  <th>QTR YR</th>
                  <th>Instructor Fname</th>
                  <th>Instructor Lname</th>
                  <th>Course Title</th>
									<th> A's </th>
									<th> B's </th>
									<th> C's </th>
									<th> D's </th>
                  <th>Avg GPA</th>
                </tr> 
          <%
      			while(final_set.next() ) 
						{
       		%>
                <tr>
                  <form action="decision_support.jsp" method="get">
                    <input type="hidden" value="insert" name="action">
                    <th><%= final_set.getString("course_id") %></th>
                    <th><%= final_set.getString("qtr_yr") %></th>
                    <th><%= final_set.getString("fac_fname") %></th>
                    <th><%= final_set.getString("fac_lname") %></th>
                    <th><%= final_set.getString("c_title") %></th>
                    <th><%= final_set.getInt("acount") %></th>
                    <th><%= final_set.getInt("bcount") %></th>
                    <th><%= final_set.getInt("ccount") %></th>
                    <th><%= final_set.getInt("dcount") %></th>
                    <th><%= final_set.getDouble("avg_gpa") %></th>
                  </form>
                </tr>
          <%
            }

			    }
            // Close result set
            final_set.close();

          
  
      %>
        </table>
      <%
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
        <%-- </table> --%>
      </td>
    </tr>
  </table>
</body>
</html>
