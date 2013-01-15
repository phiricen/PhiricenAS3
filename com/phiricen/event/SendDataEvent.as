package phiricen.event
{
	import flash.events.Event;
	public class SendDataEvent extends Event
	{
		public static const DATA_SENDER:String = "DataSender";
		
		public var data:Object;
		
		public function SendDataEvent (_type:String, _bubble:Boolean = false , _object:Object = null)
		{
			super (_type, _bubble, false);
			data = _object;
		}
	}
}