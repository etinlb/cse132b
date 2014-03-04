
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
      <%@ page  language="java" import="java.util.Hashtable" %>
  
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
          ResultSet rs_student = statement.executeQuery
            ("SELECT * FROM Student " +
             "INNER JOIN msphdstudentdegree ON "  +
             "Student.student_id = msphdstudentdegree.student_id");
      %>
        <h1>Select a Student And Degree</h1>
      <form action="unit_report_ms.jsp" action="get">
        <select name="student_id">
        <%
            // Iterate over the ResultSet
            while ( rs_student.next() ) {
        %>

          <option value="<%=rs_student.getInt("student_id")%>">
            SSN = <%= rs_student.getInt("SSN")%>, NAME = <%= rs_student.getString("FIRSTNAME")%> <%=rs_student.getString("MIDDLENAME")%> <%=rs_student.getString("LASTNAME")%> 
          </option>
        <%
            }
        %>
        </select>

        <%-- -------- SELECT Statement Code -------- --%>
        <%

          // Use the created statement to SELECT
          // the student attributes FROM the Student table.
          ResultSet rs_degree = statement.executeQuery
            ("SELECT * FROM Degree WHERE type='MS' OR type='PHD'");
        %>
        <select name="degree">
        <%
            // Iterate over the ResultSet
            while ( rs_degree.next() ) {
        %>

          <option value="<%=rs_degree.getString("name_of_degree")%>">
            Degree = <%= rs_degree.getString("name_of_degree")%>
          </option>
        <%
            }
        %>
        </select>   

        <input type="hidden" value="ListRemainingUnits" name="action">
        <input type="submit" value="ListClasses">
      </form>
      <%-- -------- Close Connection Code -------- --%>
      <%
          // Close the ResultSet from the student table
          rs_student.close();
          rs_degree.close();

      %>

      <%-- -------- Display Code -------- --%>
      <%
          String action = request.getParameter("action");
          System.out.println(action);
          // Check if an insertion is requested
          if (action != null && action.equals("ListRemainingUnits")) {
            Hashtable<String, Integer> categories_hash
                                       = new Hashtable<String, Integer>();
            System.out.println("Hrer");

            String req_units = "SELECT * FROM Degreereq WHERE name_of_degree = '" + request.getParameter("degree") +"'";

            ResultSet categories = statement.executeQuery(req_units);

            int total = 0;
            while(categories.next()){
              categories_hash.put(categories.getString("category"), categories.getInt("units_req"));
              total += categories.getInt("units_req");

            }  
            String student_units = "SELECT cc.category, SUM(units) FROM Studentcoursedata AS sd " +
                            "INNER JOIN Class ON Class.section_id = sd.section_id " +
                            "INNER JOIN Classcategory AS cc ON cc.course_id = Class.course_id " +
                            "INNER JOIN msphdstudentdegree AS ms ON sd.student_id = ms.student_id " +
                            "WHERE sd.student_id='" + request.getParameter("student_id")  + "'" +
                            "AND cc.name_of_degree='" + request.getParameter("degree") + "'" +
                            "GROUP BY cc.category" ;
            ResultSet units_set = statement.executeQuery(student_units);
            int total_taken = 0;
            Hashtable<String, Integer> completed_hash
               = new Hashtable<String, Integer>();
            while(units_set.next()){
              int comp_units = units_set.getInt("sum");
              Integer needed = categories_hash.get(units_set.getString("category"));
              int diff;
              total_taken +=0;
              if(needed == null){
                diff = needed;
              }else{
                diff = needed - comp_units;
              }
              if(diff < 0){
                diff = 0;
              }
              completed_hash.put(units_set.getString("category"), diff);
            }
            total = total-total_taken; 
            if(total < 0){
              total = 0;
            }     
            %>
              <table border="1">
              <tr>
                <th>
                  FOR <%=request.getParameter("student_id")%>
                </th>
              </tr>
              <tr>
            <%
            for(String key : categories_hash.keySet()){
              %>
              <th><%=key%> REQ <%=categories_hash.get(key)%></th>
            <%
            }
            %>
              </tr>
              <tr>
            <%
            for(String key : categories_hash.keySet()){
              Integer diff = completed_hash.get(key);
              if (diff == null){
                diff = categories_hash.get(key);
              }
              %>

              <td> <%=diff%></td>
              <%
            }
            %>
            

            </tr>
            </td>
            <%
            // Close result set
            units_set.close();

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
