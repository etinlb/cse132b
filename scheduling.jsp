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
            ("select distinct section_id, course_id, c_title from class where qtr_yr = 'WI14'");
      %>
        <h1>Select a Current Section ID to Schedule a review session</h1>
      <form action="scheduling.jsp" action="get">
        <select name="section_id">
        <%
            // Iterate over the ResultSet
            while ( rs.next() ) {
        %>

          <option value="<%=rs.getInt("section_id")%>">
            Section ID = <%= rs.getInt("section_id")%>, Course ID = <%= rs.getString("course_id")%>, 
						Title = <%=rs.getString("c_title")%>  
          </option>
        <%
            }
        %>
        </select>
        <input type="hidden" value="get_times" name="action">
        <input type="submit" value="List Available Times">
      </form>
      <%-- -------- Close Connection Code -------- --%>
      <%
          // Close the ResultSet from the student table
          rs.close();

      %>

      <%-- -------- Display Code -------- --%>
      <%
          String action = request.getParameter("action");
          System.out.println(request.getParameter("section_id"));
          // Check if an insertion is requested
          if (action != null && action.equals("get_times")) {
              
            %>
        <h1>You Have Selected:</h1>
        <table border="5">
          <tr>
            <th> SECTION ID </th>
            <th> = </th>
            <th><%=request.getParameter("section_id")%></th>
          </tr>
        </table>
        <h1>Insert A Date And Time Range</h1>
        <table border="1">
          <tr>
            <th> START MONTH </th>
            <th> START DAY </th>
            <th> END MONTH </th>
            <th> END DAY </th>
            <th>Action</th>
          </tr>
          <tr>
            <form action="scheduling.jsp" method="get">
              <input type="hidden" value="get_it" name="action">
              <th><input value="" name="s_month" size="15"></th>
              <th><input value="" name="s_day" size="15"></th>
              <th><input value="" name="e_month" size="15"></th>
              <th><input value="" name="e_day" size="15"></th>
              <th><input type="submit" value="Get Schedule"></th>
            </form>
          </tr>
          <%
					}//close if ( action )  condition 

				if ( action != null && action.equals("get_it") ) 
				{
				/******************* MASS CODE HERE **********************/

      %>
     
			   <h1>Available Time Slots:</h1>
			
      <%


				/****************** END OF MASS CODE ********************/			
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
