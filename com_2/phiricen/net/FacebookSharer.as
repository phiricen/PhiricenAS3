package phiricen.net
{
    public class FacebookSharer
    {
        public static function getFBShareLink(_url:String="",_title:String="",_summary:String="",_images:Array=null):String
        {
            var resultURL:String = "";
 
            var sharer:String = "http://www.facebook.com/sharer/sharer.php?m2w&s=100&";
            var url:String = _url == "" ? "":"p[url]=" + encodeURIComponent(_url)+"&";
            var title:String = _title == "" ? "":"p[title]=" + encodeURIComponent(_title)+"&";
            var summary:String = _summary == "" ? "":"p[summary]=" + encodeURIComponent(_summary)+"&";
            var image:String = "";
            if (_images != null)
            {
                for (var i:int = 0; i < _images.length; i++)
                {
                    image +=  "p[images][" + i + "]=" + _images[i];
                    image +=  i == _images.length-1 ? "":"&";
                }
            }
            resultURL = sharer + url + title + summary +  image;
            return resultURL;
        }
    }
}