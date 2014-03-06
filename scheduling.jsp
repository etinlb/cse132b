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
      <%@ page language="java" import="java.util.Calendar" %>
      <%@ page language="java" import="java.util.Hashtable" %>
      <%@ page language="java" import="java.util.*"%>
      <%@ page language="java" import="java.util.LinkedHashMap"%>
  
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
              <input type="hidden" value="<%=request.getParameter("section_id")%>" name="section_id">
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
          final int start_month = Integer.parseInt(request.getParameter("s_month")) - 1;
          final int end_month = Integer.parseInt(request.getParameter("e_month")) - 1;
          final int start_day = Integer.parseInt(request.getParameter("s_day"));
          final int end_day = Integer.parseInt(request.getParameter("e_day"));
          String query = "SELECT DISTINCT days_of_week, start_time, end_time FROM Studentcoursedata AS sd " + 
           "JOIN Meeting AS m ON sd.section_id=m.section_id " + 
           "JOIN (SELECT DISTINCT sd.student_id FROM Studentcoursedata AS sd " + 
           "JOIN Meeting AS m ON m.section_id=sd.section_id " + 
           "WHERE m.section_id="+request.getParameter("section_id")+") AS enr_stu ON enr_stu.student_id=sd.student_id";

           System.out.println(query);

          ResultSet taken_times = statement.executeQuery(query);

           //scheduling java code.
          Hashtable<Integer,String > day_lookup = new Hashtable<Integer, String>();
          day_lookup.put(2, "M");
          day_lookup.put(3, "Tu");
          day_lookup.put(4, "W");
          day_lookup.put(5, "Th");
          day_lookup.put(6, "F");

          ArrayList<Integer> schedule_days = new ArrayList<Integer>();
          Calendar calendar = new GregorianCalendar() {{
              set(Calendar.YEAR, 2014);
              set(Calendar.MONTH, start_month);
              set(Calendar.DATE, start_day);
          }}; 

          if(start_month == end_month){
            schedule_days.add(calendar.get((Integer)Calendar.DAY_OF_WEEK)); 
            while(calendar.get(Calendar.DATE) != end_day){
                   calendar.add(Calendar.DATE, 1);  
              if ( calendar.get((Integer)Calendar.DAY_OF_WEEK) == 1 || 
                   calendar.get((Integer)Calendar.DAY_OF_WEEK) == 7 ) 
                continue;
            schedule_days.add(calendar.get((Integer)Calendar.DAY_OF_WEEK)); 
            System.out.println(calendar.get((Integer)Calendar.DAY_OF_WEEK));
            }
          }else{
            schedule_days.add(calendar.get((Integer)Calendar.DAY_OF_WEEK)); 
            while ( calendar.get(Calendar.MONTH) <= end_month && calendar.get(Calendar.DATE) != end_day) {
                  calendar.add(Calendar.DATE, 1);   
              if ( calendar.get((Integer)Calendar.DAY_OF_WEEK) == 1 || 
                   calendar.get((Integer)Calendar.DAY_OF_WEEK) == 7 ) 
                  continue;
                schedule_days.add(calendar.get((Integer)Calendar.DAY_OF_WEEK)); 
                System.out.println(calendar.get((Integer)Calendar.DAY_OF_WEEK));
             }
          }
          
          //Hashtable<String, String> hour_day_hash = new Hashtable<String, String>();
          LinkedHashMap<String,String> hour_day_hash = new LinkedHashMap<String,String>();

          System.out.println("sched_days = " + schedule_days.toString());
          
          for(int i=0; i<schedule_days.size(); i++){
            String day = day_lookup.get(schedule_days.get(i));
            System.out.println("day = " + day );
            System.out.println("sched_day = " + schedule_days.get(i));
            for(int x=8; x<=20; x++){
                  hour_day_hash.put(day + Integer.toString(x), "y");
            }
          }

          for(String key : hour_day_hash.keySet()){
            System.out.println(key);
                System.out.println(hour_day_hash.get(key));
          }
          while(taken_times.next()){
            String days = taken_times.getString("days_of_week");
            //System.out.println(days);
            String[] camelCaseWords = days.split("(?=[A-Z])");
            String start_times = taken_times.getString("start_time");
            String hour;
            if(start_times.length() == 3){
              hour = Character.toString(start_times.charAt(0));
            }else{
              hour = Character.toString(start_times.charAt(0)) + Character.toString(start_times.charAt(1));
            }
            System.out.println(hour);
            for(int i=0; i<camelCaseWords.length;i++){
              if(!camelCaseWords[i].equals("")){
                System.out.println("at index" + i + "=" + camelCaseWords[i]+"|" + " hour = "+ taken_times.getString("start_time"));
                hour_day_hash.put(camelCaseWords[i] + hour, "n");
              }
            }
          }
          for(String key : hour_day_hash.keySet()){
            if( hour_day_hash.get(key).equals("y")){
              System.out.println(key + hour_day_hash.get(key));
            }
          }
        }


      %>
     
			   <h1>Available Time Slots:</h1>

			
      <%


				/****************** END OF MASS CODE ********************/			
      	 
			   // Close the Statement
          statement.close();
          System.out.println("============================================================================");
  
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
