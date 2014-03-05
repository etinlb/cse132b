
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
      <%@ page  language="java" import="java.util.ArrayList" %>
  
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
          // Check if an insertion is requested
          if (action != null && action.equals("ListRemainingUnits")) {
            Hashtable<String, Double> categories_gpa
                                       = new Hashtable<String, Double>();
            Hashtable<String, Integer> categories_units
                                       = new Hashtable<String, Integer>();
            System.out.println("Hrer");
            System.out.println(request.getParameter("degree"));
            System.out.println(request.getParameter("student_id"));
            String req_units = "SELECT * FROM Degreereq WHERE name_of_degree = '" + request.getParameter("degree") +"'";

            ResultSet categories = statement.executeQuery(req_units);



            int total = 0;
            while(categories.next()){
              categories_units.put(categories.getString("category"), categories.getInt("units_req"));
              categories_gpa.put(categories.getString("category"), categories.getDouble("avg_gpa"));
            } 
            String student_units = "SELECT cc.category, SUM(units) as comp_un, " + 
                                   "SUM(number_grade * units)/SUM(units) as gpa  FROM Studentcoursedata AS sd " +
                                   "INNER JOIN Class ON Class.section_id = sd.section_id " +
                                   "LEFT JOIN Classcategory AS cc ON cc.course_id = Class.course_id " +
                                   "INNER JOIN msphdstudentdegree AS ms ON sd.student_id = ms.student_id "+
                                   "INNER JOIN GRADE_CONVERSION g on sd.grade = g.letter_grade " +
                                   "WHERE sd.student_id=" + request.getParameter("student_id") + " " +
                                   "AND cc.name_of_degree='"+request.getParameter("degree") + "' AND sd.grade <> 'WIP' AND sd.grade <> 'IN' "+
                                   "GROUP BY cc.category"; 
            ResultSet units_set = statement.executeQuery(student_units);
            int total_taken = 0;
            Hashtable<String, Integer> completed_units
               = new Hashtable<String, Integer>();
            Hashtable<String, Double> completed_gpa
               = new Hashtable<String, Double>();
            while(units_set.next()){
              int comp_units = units_set.getInt("comp_un");
              System.out.println(comp_units);
              Double gpa = units_set.getDouble("gpa");
              Integer needed_units = categories_units.get(units_set.getString("category"));
              Double needed_gpa = categories_gpa.get(units_set.getString("category"));

              int diff;
              if(needed_units == null){
                diff = needed_units;
              }else{
                diff = needed_units - comp_units;
              }
              if(diff < 0){
                diff = 0;
              }
              completed_units.put(units_set.getString("category"), diff);
              completed_gpa.put(units_set.getString("category"), gpa);
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
            for(String key : categories_units.keySet()){
              %>
              <th><%=key%> REQ UNITS <%=categories_units.get(key)%> REQ GPA <%=categories_gpa.get(key)%></th>
            <%
            }
            %>
              </tr>
              <tr>
            <%
            for(String key : categories_units.keySet()){
              System.out.println("here");
              String display;
              Integer diff = completed_units.get(key);
              Double gpa = completed_gpa.get(key);
              if (diff == null || gpa == null){
                display = "Have not taken classes, no GPA present. Needs full units " + categories_units.get(key);
                System.out.println("1");
                //diff = categories_units.get(key);
              }else{ 
                if (diff == 0){
                  display = "Completed units with " + categories_units.get(key) + " taken. "; 
                  System.out.println("2");

                }else{
                  diff = categories_units.get(key) - completed_units.get(key);
                  display = "Need " +diff+ " units. ";
                                  System.out.println("3");

                }
                if(categories_gpa.get(key) > completed_gpa.get(key)){
                  gpa = categories_gpa.get(key) - completed_gpa.get(key);
                  display += "Need to raise current gpa (" +completed_gpa.get(key)+") by " + 
                          gpa +  " to " + categories_gpa.get(key);
                  System.out.println("4");

                }else{
                  display += "GPA is ok with " + completed_gpa.get(key);
                  System.out.println("5");
                }
              }
              %>
              
              <td><%=display%></td>
              <%
            }
            %>
            

            </tr>
            <%
            String courses_taken = "Select * FROM Classcategory AS cc " + 
                    "left JOIN (SELECT cs.course_id, sd.grade FROM Class AS cs, Studentcoursedata AS sd " +
                    "INNER JOIN GRADE_CONVERSION g on sd.grade = g.letter_grade " +
                    "WHERE sd.section_id=cs.section_id AND " +
                    "sd.student_id=" + request.getParameter("student_id")+" AND sd.grade <> 'WIP' AND sd.grade <> 'IN') AS c ON c.course_id=cc.course_id " +
                    "WHERE name_of_degree='Database Design' AND c.course_id IS null ";
            ResultSet not_taken = statement.executeQuery(courses_taken); 
            ArrayList<String> tmp = new ArrayList<String>();

             Hashtable<String, ArrayList<String>> cat_classes
               = new Hashtable<String, ArrayList<String>>();
            while (not_taken.next()){
              String key = not_taken.getString("category");
              if(cat_classes.containsKey(key)){
                tmp = cat_classes.get(key);
                System.out.println("tmp is" + tmp);
                tmp.add(not_taken.getString("course_id"));
                cat_classes.remove(key);
                cat_classes.put(key, tmp);
                System.out.println(cat_classes.get(key));
              }else{
                //key not in, make new key and list
                 ArrayList<String> course_ids = new ArrayList<String>();
                 course_ids.add(not_taken.getString("course_id"));
                 cat_classes.put(key, course_ids);
              }
            }
            %>
            <tr>
            <%
            for(String key : cat_classes.keySet()){
              %>
              <th><%=key%></th>
              <%
              for(String cat : cat_classes.get(key)){
                %>
                <td><%=cat%></td>
                <%
              }
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
