package phiricen
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.events.Event;

	public class MovieClipScaler extends MovieClip
	{
		// SimulationRectangle
		// Control Rectangle
		public var SR:Rectangle;
		public var CR:Rectangle;
		public var CR2:Rectangle;

		public var SR_Bitmap:Bitmap;
		public var CR_Bitmap:Bitmap;
		public var CR2_Bitmap:Bitmap;

		public var SR_BitmapData:BitmapData;
		public var CR_BitmapData:BitmapData;
		public var CR2_BitmapData:BitmapData;

		public var source_mc:MovieClip;
		public var subSource_mc:MovieClip;
		public var controlPoint:MovieClip=new MovieClip();
		public var controlArea:MovieClip=new MovieClip();

		public var SR_mc:MovieClip=new MovieClip();
		public var CR_mc:MovieClip=new MovieClip();
		public var CR2_mc:MovieClip=new MovieClip();

		private var rectangleLineLength:Number = 10;
		private var THIS:MovieClip = MovieClip(this);
		private var oldPoint:Point=new Point();
		private var newPoint:Point=new Point();
		private var dragging:Boolean = false;

		public function MovieClipScaler(_mc:MovieClip,_mask:MovieClip=null)
		{
			if (_mask == null)
			{
				_mask = _mc;
			}
			this.addEventListener(MouseEvent.MOUSE_OVER,OnMouse);
			this.addEventListener(MouseEvent.MOUSE_OUT,OnMouse);
			this.addEventListener(Event.ENTER_FRAME,OnDragging);
			source_mc = _mc;
			subSource_mc = _mask;
			THIS.name = "Controler_mc";
			THIS.x = _mc.x;
			THIS.y = _mc.y;
			SR_mc.name = "SR_mc";
			CR_mc.name = "CR_mc";
			CR2_mc.name = "CR2_mc";

			this.alpha = 0;
			this.x = 0;
			this.y = 0;

			drawSR();
			drawCR();
			drawCR2();

			function OnMouse(evt:MouseEvent)
			{
				switch (evt.type)
				{
					case "mouseDown" :
						switch (evt.target.name)
						{
							case "SR_mc" :
								SR_mc.startDrag();
								break;
							case "CR_mc" :
								oldPoint.x = CR_mc.x;
								oldPoint.y = CR_mc.y;
								CR_mc.startDrag();
								break;
							case "CR2_mc" :
								oldPoint.x = CR2_mc.x;
								oldPoint.y = CR2_mc.y;
								CR2_mc.startDrag();
								dragging = true;
								break;
						}
						break;
					case "mouseUp" :
						if (evt.target.name == "SR_mc")
						{
							THIS["SR_mc"].stopDrag();
						}
						if (evt.currentTarget.name == "CR_mc")
						{
							THIS["CR_mc"].stopDrag();
							newPoint.x = CR_mc.x;
							newPoint.y = CR_mc.y;
							startScale();
						}
						else if (evt.currentTarget.name == "CR2_mc")
						{
							THIS["CR2_mc"].stopDrag();
							dragging = false;
							newPoint.x = CR2_mc.x;
							newPoint.y = CR2_mc.y;
							startScale2();
						}
						_mc.x = THIS["SR_mc"].x;
						_mc.y = THIS["SR_mc"].y;
						break;
					case "mouseOver" :
						THIS.alpha = 1;
						SR_Bitmap.alpha = 0.3;
						CR_Bitmap.alpha = 0.6;
						break;
					case "mouseOut" :
						THIS.alpha = 0;
						break;
				}
			}
			function OnDragging(evt:Event)
			{
				/*
				if (dragging)
				{
				trace(newPoint,oldPoint);
				var tempX:Number=CR2_mc.x;
				var tempY:Number=CR2_mc.y;
				var dX = tempX - oldPoint.x;
				var dY = tempY - oldPoint.y;
				trace(dX,dY);
				if(dx>=dy)
				{}
				else
				{}
				}
				*/
			}

			function startScale()
			{
				var oldWidth:Number = SR_Bitmap.width;
				var oldHeight:Number = SR_Bitmap.height;
				var newWidth:Number=oldWidth+(newPoint.x-oldPoint.x);
				var newHeight:Number=oldHeight+(newPoint.y-oldPoint.y);
				var XScale:Number = Math.floor(newWidth / oldWidth * 100) / 100;
				var YScale:Number = Math.floor(newHeight / oldHeight * 100) / 100;
				SR_Bitmap.width *=  XScale;
				SR_Bitmap.height *=  YScale;
				source_mc.x = SR_Bitmap.x;
				source_mc.y = SR_Bitmap.y;
				source_mc.width *=  XScale;
				source_mc.height *=  YScale;
				CR_mc.x = SR_Bitmap.x + SR_Bitmap.width - CR_mc.width;
				CR_mc.y = SR_Bitmap.y + SR_Bitmap.height - CR_mc.height;
				CR2_mc.x = SR_Bitmap.x + SR_Bitmap.width;
				CR2_mc.y = SR_Bitmap.y + SR_Bitmap.height;
			}

			function startScale2()
			{
				var oldWidth:Number = SR_Bitmap.width;
				var oldHeight:Number = SR_Bitmap.height;
				var newWidth:Number=oldWidth+(newPoint.x-oldPoint.x);
				var newHeight:Number=oldHeight+(newPoint.y-oldPoint.y);
				var XScale:Number = Math.floor(newWidth / oldWidth * 100) / 100;
				var YScale:Number = Math.floor(newHeight / oldHeight * 100) / 100;
				if (XScale <= YScale)
				{
					YScale = XScale;
				}
				else
				{
					XScale=YScale;
					}
				SR_Bitmap.width *=  XScale;
				SR_Bitmap.height *=  YScale;
				source_mc.x = SR_Bitmap.x;
				source_mc.y = SR_Bitmap.y;
				source_mc.width *=  XScale;
				source_mc.height *=  YScale;
				CR_mc.x = SR_Bitmap.x + SR_Bitmap.width - CR_mc.width;
				CR_mc.y = SR_Bitmap.y + SR_Bitmap.height - CR_mc.height;
				CR2_mc.x = SR_Bitmap.x + SR_Bitmap.width;
				CR2_mc.y = SR_Bitmap.y + SR_Bitmap.height;
			}

			function drawSR()
			{
				SR = new Rectangle(0,0,subSource_mc.width,subSource_mc.height);
				SR_BitmapData = new BitmapData(subSource_mc.width,subSource_mc.height,false,0x000000);
				SR_BitmapData.fillRect(SR,0x000000);
				SR_Bitmap = new Bitmap(SR_BitmapData);
				SR_mc.addChild(SR_Bitmap);
				THIS.addChild(SR_mc);
				SR_mc.x = _mc.x;
				SR_mc.y = _mc.y;
				SR_mc.addEventListener(MouseEvent.MOUSE_UP,OnMouse);
				SR_mc.addEventListener(MouseEvent.MOUSE_DOWN,OnMouse);
			}

			function drawCR()
			{
				CR_BitmapData = new BitmapData(rectangleLineLength,rectangleLineLength,false,0x0000FF);
				CR = new Rectangle(0,0,rectangleLineLength,rectangleLineLength);
				CR_BitmapData.fillRect(CR,0x000000);
				CR_Bitmap = new Bitmap(CR_BitmapData);
				CR_mc.addChild(CR_Bitmap);
				SR_mc.addChild(CR_mc);
				CR_mc.x = SR_Bitmap.width - rectangleLineLength;
				CR_mc.y = SR_Bitmap.height - rectangleLineLength;
				CR_mc.alpha = 0.5;
				CR_mc.addEventListener(MouseEvent.MOUSE_UP,OnMouse);
				CR_mc.addEventListener(MouseEvent.MOUSE_DOWN,OnMouse);
			}

			function drawCR2()
			{
				CR2_BitmapData = new BitmapData(rectangleLineLength,rectangleLineLength,false,0x0000FF);
				CR2 = new Rectangle(0,0,rectangleLineLength,rectangleLineLength);
				CR2_BitmapData.fillRect(CR2,0x000000);
				CR2_Bitmap = new Bitmap(CR2_BitmapData);
				CR2_mc.addChild(CR2_Bitmap);
				SR_mc.addChild(CR2_mc);
				CR2_mc.x = SR_Bitmap.width;
				CR2_mc.y = SR_Bitmap.height;
				CR2_mc.alpha = 0.5;
				CR2_mc.addEventListener(MouseEvent.MOUSE_UP,OnMouse);
				CR2_mc.addEventListener(MouseEvent.MOUSE_DOWN,OnMouse);
			}

		}
	}
}