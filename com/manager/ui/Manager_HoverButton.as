package phiricen.manager.ui
{
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.events.Event;
	import flash.ui.MouseCursor;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.display.Loader;

	public class Manager_HoverButton extends MovieClip
	{
		private var buttons:Array;
		public function Manager_HoverButton()
		{

		}
		public function endow(_targets:Array)
		{
			buttons=new Array();
			for (var i:int=0; i<_targets.length; i++)
			{
				buttons.push(_targets[i]);
			}
			init();
		}
		private function init()
		{
			for (var i:int=0; i<buttons.length; i++)
			{
				switch (buttons[i].toString())
				{
					case "[object Loader]" :
						break;
					case "[object MovieClip]" :
						buttons[i].stop();
						break;
				}
				buttons[i].addEventListener(MouseEvent.ROLL_OUT,OnRollOut);
				buttons[i].addEventListener(MouseEvent.ROLL_OVER,OnRollOver);
			}
		}
		private function OnRollOver(evt:MouseEvent)
		{
			switch (evt.currentTarget.toString())
			{
				case "[object MovieClip]" :
					evt.currentTarget.gotoAndStop(2);
					break;
			}
			Mouse.cursor = MouseCursor.BUTTON;
		}
		private function OnRollOut(evt:MouseEvent)
		{
			switch (evt.currentTarget.toString())
			{
				case "[object MovieClip]" :
					evt.currentTarget.gotoAndStop(1);
					break;
			}
			Mouse.cursor = MouseCursor.AUTO;
		}
	}
}