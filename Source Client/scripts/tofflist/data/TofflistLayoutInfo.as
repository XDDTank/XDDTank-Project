package tofflist.data
{
   import flash.geom.Point;
   
   public class TofflistLayoutInfo
   {
       
      
      public var TitleHLinePoint:Vector.<Point>;
      
      public var TitleTextPoint:Vector.<Point>;
      
      public var TitleTextString:Array;
      
      public function TofflistLayoutInfo()
      {
         super();
         this.TitleHLinePoint = new Vector.<Point>();
         this.TitleTextPoint = new Vector.<Point>();
      }
      
      public function set titleHLinePt(param1:String) : void
      {
         this.TitleHLinePoint = this.parseValue(param1);
      }
      
      public function set titleTextPt(param1:String) : void
      {
         this.TitleTextPoint = this.parseValue(param1);
      }
      
      private function parseValue(param1:String) : Vector.<Point>
      {
         var _loc4_:String = null;
         var _loc5_:Point = null;
         var _loc2_:Vector.<Point> = new Vector.<Point>();
         var _loc3_:Array = param1.split("|");
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = new Point(_loc4_.split(",")[0],_loc4_.split(",")[1]);
            _loc2_.push(_loc5_);
         }
         return _loc2_;
      }
   }
}
