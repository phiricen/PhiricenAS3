package phiricen.visual
{
	import flash.display.*;
	import flash.errors.IllegalOperationError;
	import flash.geom.*;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class Reflector extends MovieClip
	{
		private var THIS:MovieClip = MovieClip(this);
		public function Reflector(_source:*)
		{
			var ori:BitmapData;
			if (_source is DisplayObject)
			{
				trace("DisplayObject");
				ori = new BitmapData(_source.width,_source.height,true,0);
				ori.draw(_source);
				getRef(ori);
			}
			else if (_source is String)
			{
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
				loader.load(new URLRequest(_source));

				function completeHandler(evt:Event):void
				{
					ori = evt.target.content.bitmapData;
					getRef(ori);
				}
			}

			function getRef(_bd:BitmapData)
			{
				//垂直方向翻轉，Matrix中第一、四個參數表示水平和垂直方向的scale      
				//第二、三參數表示水平和垂直方向的旋轉角度
				//最後二個表示坐標的相對位移，當垂直翻轉後，圖像的y坐標有變化，因此必須要移動
				var matrix:Matrix = new Matrix(1,0,0,-1,0,_bd.height);
				//取出圖片的圖像    
				//新增shape用來做漸變的透明效果  
				var shape:Shape = new Shape();
				//定義漸變matrix 用來設置填充效果
				var gradientMatrix:Matrix = new Matrix();
				gradientMatrix.createGradientBox(_bd.width,_bd.height, 0.5*Math.PI);
				//GradientType.LINEAR  線性填充;
				//這裡使用二種顏色
				//第三個參數是透名度的變化
				//第四個參數分别是颜色所佔的百分比      
				shape.graphics.beginGradientFill(GradientType.LINEAR, [0, 0], [.8, 0], [0, 128], gradientMatrix);
				shape.graphics.drawRect(0, 0, _bd.width,_bd.height);
				shape.graphics.endFill();
				//THIS.addChild(shape);

				//將透明度運用在背景中;
				var ref:BitmapData = new BitmapData(shape.width,shape.height);
				//var ref:BitmapData = _bd;
				_bd.draw(shape, null, null, BlendMode.ALPHA);

				var ORI_bmp:Bitmap=new Bitmap();
				ORI_bmp.bitmapData = _bd;

				var REF_bmp:Bitmap=new Bitmap();
				REF_bmp.bitmapData = ref;

				REF_bmp.y = ORI_bmp.y + ORI_bmp.height;

				var d:MovieClip=new MovieClip();
				d.addChild(ORI_bmp);
				THIS.addChild(d);
				//THIS.addChild(ORI_bmp);
				THIS.addChild(REF_bmp);
			}
		}
	}
}