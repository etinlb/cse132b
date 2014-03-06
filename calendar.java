import java.util.*;
import java.util.Calendar;
import java.util.Hashtable;
class calendar {





public static void main (String [] args)
{

System.out.println("String[0] = " + args[0] + " " +  "String[1] = " + args[1]);
System.out.println("String[2] = " + args[2] + " " +  "String[3] = " + args[3]);


Calendar calendar =  getDatesBetween( Integer.parseInt(args[0]), Integer.parseInt(args[1]), Integer.parseInt(args[2]), Integer.parseInt(args[3]) );


//System.out.println("calendar = " + calendar.toString() );


}


  public static Calendar getDatesBetween(final int start_month, final int start_day, 
																				 final int end_month, final int end_day) {

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
   while(calendar.get(Calendar.DATE) != end_day){
           calendar.add(Calendar.DATE, 1);  
   	if ( calendar.get((Integer)Calendar.DAY_OF_WEEK) == 1 || 
   			 calendar.get((Integer)Calendar.DAY_OF_WEEK) == 7 ) 
   	 	continue;
   	schedule_days.add(calendar.get((Integer)Calendar.DAY_OF_WEEK));	
		System.out.println(calendar.get((Integer)Calendar.DAY_OF_WEEK));
    }
    }else{
      while ( calendar.get(Calendar.MONTH) <= end_month && calendar.get(Calendar.DATE) != end_day) {
            calendar.add(Calendar.DATE, 1);   
    		if ( calendar.get((Integer)Calendar.DAY_OF_WEEK) == 1 || 
    				 calendar.get((Integer)Calendar.DAY_OF_WEEK) == 7 ) 
    				continue;
   				schedule_days.add(calendar.get((Integer)Calendar.DAY_OF_WEEK));	
  			 System.out.println(calendar.get((Integer)Calendar.DAY_OF_WEEK));
       }
   	}
   	
   	Hashtable<String, String> hour_day_hash = new Hashtable<String, String>();
			System.out.println("sched_days = " + schedule_days.toString());
   	
		for(int i=0; i<schedule_days.size(); i++){
	 		 String day = day_lookup.get(schedule_days.get(i));
			System.out.println("day = " + day );
			System.out.println("sched_day = " + schedule_days.get(i));
		    for(int x=8; x<=20; x++){
					    hour_day_hash.put(day + Integer.toString(x) , "y");
				}
								  
}

for(String key : hour_day_hash.keySet()){
	 	System.out.println(key);
		  	System.out.println(hour_day_hash.get(key));
}







    return calendar;
}



}
