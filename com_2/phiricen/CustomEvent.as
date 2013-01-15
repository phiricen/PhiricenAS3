package phiricen
{
	import flash.events.Event;
	public class CustomEvent extends Event
	{
		public static const DATA_SENDER:String = "DataSender";
		
		public var data:Object;
		
		public function CustomEvent (_type:String, _bubble:Boolean = false , _object:Object = null)
		{
			super (_type, _bubble, false);
			data = _object;
		}
	}
}