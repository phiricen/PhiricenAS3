package phiricen.visual
{
	import flash.events.Event;
	import flash.display.*;
	import flash.errors.IllegalOperationError;
	import flash.geom.*;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class Reflector extends MovieClip
	{
		private var THIS:MovieClip=MovieClip(this);
		public function Reflector(_source:String)
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			var request:URLRequest = new URLRequest(_source);
			loader.load(request);
			this.addChild(loader);

			function completeHandler(event:Event):void
			{
				var sourceImg:BitmapData = event.target.content.bitmapData;
				var bd:BitmapData = new BitmapData(sourceImg.width,sourceImg.height,true,0);
				//垂直方向翻轉，Matrix中第一、四個參數表示水平和垂直方向的scale      
				//第二、三參數表示水平和垂直方向的旋轉角度
				//最後二個表示坐標的相對位移，當垂直翻轉後，圖像的y坐標有變化，因此必須要移動
				var matrix:Matrix = new Matrix(1,0,0,-1,0,sourceImg.height);
				//取出圖片的圖像    
				bd.draw(sourceImg,matrix);
				//新增shape用來做漸變的透明效果  
				var shape:Shape = new Shape();
				//定義漸變matrix 用來設置填充效果
				var gradientMatrix:Matrix = new Matrix();
				gradientMatrix.createGradientBox(sourceImg.width,sourceImg.height, 0.5*Math.PI);
				//GradientType.LINEAR  線性填充;
				//這裡使用二種顏色
				//第三個參數是透名度的變化
				//第四個參數分别是颜色所佔的百分比      
				shape.graphics.beginGradientFill(GradientType.LINEAR, [0, 0], [.8, 0], [0, 128], gradientMatrix);
				shape.graphics.drawRect(0, 0, sourceImg.width,sourceImg.height);
				shape.graphics.endFill();
				//將透明度運用在背景中;
				bd.draw(shape, null, null, BlendMode.ALPHA);
				var ba:Bitmap = new Bitmap(bd);
				ba.y = ba.height;
				THIS.addChild(ba);
			}
		}
	}
}