package phiricen.EX
{
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class ScrollBar extends MovieClip
	{
		public var adjustY:Number = 0;// 位置調整

		public var masker:Object = null;// 遮色片
		public var masked:Object = null;// 被遮物
		public var SB:Object = null;// ScrollBar
		public var UpButton:Object = null;// ScrollBar UpButton 卷軸向上捲
		public var DownButton:Object = null;// ScrollBar DownButton 卷軸向下捲
		public var Background:Object = null;// ScrollBar Background 卷軸背景
		public var ControlButton:Object = null;// ScrollBar ControlButon 卷軸控制器
		public var ControlButton_S9G:Rectangle = null;// ScrollBar ControlButton Scale9Grid 卷軸控制器的九格縮放 
		public var maskedMotionRange:Number;// 被遮物最大移動量
		public var scrollMotionRange:Number;// 捲軸最大移動量
		public var scrollSpeed:Number = 5;// 捲動速度
		public var scrollDelta:Number = 3;// 捲動行數

		private var mouseEvent:String = "none";
		private var onUpOrDownButtonPressed:String = "none";

		private var mousePoint:Point=new Point();

		private var maskRatio:Number;// 被遮物與遮色片的比值
		private var oldMaskRatio:Number = 0;
		private var scrollRatio:Number;// 卷軸背景與控制器的比值
		private var progress:Number = 0;// 進度比值

		public function ScrollBar(ScrollBar:Object,Masked:Object,Masker:Object,ScrollBarBackground:Object,ScrollBarControlButton:Object)
		{
			// 得到參數
			masked = Masked;
			masker = Masker;
			if (ScrollBarBackground != null)
			{
				Background = ScrollBarBackground;
			}
			if (ScrollBarControlButton != null)
			{
				ControlButton = ScrollBarControlButton;
			}
			SB = ScrollBar;

			masker.height = SB.height;

			// 指定遮色片
			masked.mask = masker;

			// 事件偵聽;
			this.addEventListener(Event.ADDED_TO_STAGE,OnATS);
			this.addEventListener(Event.ENTER_FRAME,OnEnterFrame);

			refreshMaskRatio();
		}

		private function refreshMaskRatio()
		{
			var timer:Timer = new Timer(50,1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,OnTimerComplete);
			timer.start();
			function OnTimerComplete(evt:TimerEvent)
			{
				maskRatio = masker.height / masked.height;
				if (oldMaskRatio != maskRatio)
				{
					reset(true);
				}
				oldMaskRatio = maskRatio;
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE,OnTimerComplete);
				timer = new Timer(50,1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE,OnTimerComplete);
				timer.start();
			}
		}

		private function OnATS(evt:Event)
		{			
			// 事件偵聽
			stage.addEventListener(MouseEvent.MOUSE_UP,OnMouseEvent);
			ControlButton.addEventListener(MouseEvent.MOUSE_DOWN,OnMouseEvent);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL,OnMouseEvent);

			if (UpButton != null)
			{
				UpButton.addEventListener(MouseEvent.MOUSE_UP,OnMouseEvent);
				UpButton.addEventListener(MouseEvent.MOUSE_DOWN,OnMouseEvent);
			}
			if (DownButton != null)
			{
				DownButton.addEventListener(MouseEvent.MOUSE_UP,OnMouseEvent);
				DownButton.addEventListener(MouseEvent.MOUSE_DOWN,OnMouseEvent);
			}
			reset();
		}

		public function reset(rememberProgress:Boolean=false)
		{
			// 被遮物與遮色片的比值
			maskRatio = masker.height / masked.height;

			// 被遮物位置
			if (UpButton != null)
			{
				// 被遮物的 Y = 調整後的 Y + ScrollBar UpButton 的底
				if (rememberProgress)
				{
					//
				}
				else
				{
					masked.y = adjustY;

					// 控制器的 Y 對齊 up_btn 的底部
					ControlButton.y = UpButton.y + UpButton.height;
				}
			}
			else
			{
				if (rememberProgress)
				{
					//
				}
				else
				{
					masked.y = adjustY;
					ControlButton.y = 0;
				}
			}

			// 被遮物最大移動量 = 被遮物的高 - 遮色片的高;
			maskedMotionRange = masked.height - masker.height;

			// 設定控制器的高度
			if (maskRatio < 1)
			{
				// 控制器的高 = 控制器背景 x 目標比值
				ControlButton.height = Background.height * maskRatio;

				// 隱藏卷軸
				SB.visible = true;
			}
			else
			{
				maskRatio = 1;
				ControlButton.height = Background.height;

				// 顯示捲軸
				SB.visible = false;
			}

			// 卷軸最大移動量 = 卷軸背景的底點 - 卷軸控制器的底點
			if (UpButton != null)
			{
				scrollMotionRange = Background.height - ControlButton.height;
			}
			else
			{
				scrollMotionRange = Background.height - ControlButton.height;
			}

			// 如果卷軸可以移動的量 <0 的話就乾脆讓他 =0 好了
			if (scrollMotionRange < 0)
			{
				scrollMotionRange = 0;
			}
			//trace("卷軸重置完成");
		}

		private function OnMouseEvent(evt:MouseEvent)
		{
			mouseEvent = evt.type;
			switch (evt.type)
			{
				case "mouseDown" :
					// 滑鼠定位 開始
					if (mousePoint.x == 0 && mousePoint.y == 0)
					{
						mousePoint.x = stage.mouseX;
						mousePoint.y = stage.mouseY;
					}
					switch (evt.currentTarget)
					{
						case UpButton :
							if (UpButton !== null)
							{
								onUpOrDownButtonPressed = "up";
							}
							break;
						case DownButton :
							if (DownButton !== null)
							{
								onUpOrDownButtonPressed = "down";
							}
							break;
					}
					break;
				case "mouseUp" :
					onUpOrDownButtonPressed = "none";

					// 滑鼠定位重置
					mousePoint.x = 0;
					mousePoint.y = 0;
					break;
				case "mouseWheel" :
					ControlButton.y -=  evt.delta*3;
					break;
			}
		}

		private function OnEnterFrame(evt:Event)
		{
			var top:Number;
			var bottom:Number;
			// 進度比 = 控制器的 Y / 卷軸移動範圍
			if (UpButton != null)
			{
				top = UpButton.y + UpButton.height;
				bottom = ControlButton.y;
			}
			else
			{
				top = Background.x;
				bottom = ControlButton.y;
			}

			// 進度比 = 控制器的移動距離 / 可移動距離
			progress =(bottom-top)/scrollMotionRange;

			switch (onUpOrDownButtonPressed)
			{
				case "up" :
					ControlButton.y -=  scrollSpeed;
					break;
				case "down" :
					ControlButton.y +=  scrollSpeed;
					break;
				case "none" :// 捲軸條件成立
					if (mouseEvent == "mouseDown")
					{
						var dX:Number = root.mouseX - mousePoint.x;
						var dY:Number = root.mouseY - mousePoint.y;
						ControlButton.y +=  dY;
					}
					break;
			}

			if (UpButton != null)
			{
				if (ControlButton.y <= UpButton.y + UpButton.height)
				{
					// 超出上端時
					ControlButton.y = UpButton.y + UpButton.height;

					// progress 強制設為 0
					progress = 0;
				}
				else if (ControlButton.y >=Background.y+Background.height-ControlButton.height)
				{
					// 超出下端時
					ControlButton.y = Background.y + Background.height - ControlButton.height;

					// progress 強制設為 1
					progress = 1;
				}
			}
			else
			{
				if (ControlButton.y <= Background.y)
				{
					// 超出上端時
					ControlButton.y = Background.y;

					// progress 強制設為 0
					progress = 0;
				}
				else if (ControlButton.y >=Background.y+Background.height-ControlButton.height)
				{
					// 超出下端時
					ControlButton.y = Background.y + Background.height - ControlButton.height;

					// progress 強制設為 1
					progress = 1;
				}
			}

			// 強制變更
			if (progress < 0)
			{
				progress = 0;
			}
			if (progress > 1)
			{
				progress = 1;
			}

			if (scrollMotionRange > 0)
			{
				// 目標的 Y 值 = 目標 Y 軸最大移動量 x 捲軸進度比
				if (UpButton != null)
				{
					masked.y = adjustY + Math.floor(maskedMotionRange) * progress * -1;
				}
				else
				{
					masked.y = adjustY + Math.floor(maskedMotionRange) * progress * -1;
				}
			}

			// 歸零
			mousePoint.x = root.mouseX;
			mousePoint.y = root.mouseY;
		}
	}
}