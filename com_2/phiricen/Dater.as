package phiricen
{

	public class Dater
	{
		public var tempDate:Date;
		public var year:String;
		public var month:String;
		public var date:String;
		public var hour:String;
		public var minute:String;
		public var second:String;
		public var serial:String;

		public function Dater()
		{
			tempDate=new Date();
			year = tempDate.fullYear.toString();
			month = [tempDate.month + 1].toString();
			date = tempDate.date.toString();
			hour = tempDate.hours.toString();
			minute = tempDate.minutes.toString();
			second = tempDate.seconds.toString();

			if (month.length == 1)
			{
				month = "0" + month;
			}
			if (date.length == 1)
			{
				date = "0" + date;
			}
			if (minute.length == 1)
			{
				minute = "0" + minute;
			}
			if (hour.length == 1)
			{
				hour = "0" + hour;
			}
			if (second.length == 1)
			{
				second = "0" + second;
			}
			serial=year+month+date+hour+minute+second;
		}
	}
}