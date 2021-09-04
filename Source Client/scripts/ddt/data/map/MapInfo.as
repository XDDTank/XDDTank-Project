package ddt.data.map
{
   public class MapInfo
   {
      
      public static var G:Number = 0.98;
       
      
      public var ID:int;
      
      public var Name:String;
      
      public var isOpen:Boolean;
      
      public var canSelect:Boolean;
      
      public var ForegroundWidth:Number;
      
      public var ForegroundHeight:Number;
      
      public var ForePic:String;
      
      public var BackroundWidht:Number;
      
      public var BackroundHeight:Number;
      
      public var BackPic:String;
      
      public var DeadWidth:Number;
      
      public var DeadHeight:Number;
      
      public var DeadPic:String;
      
      public var Pic:String;
      
      public var Description:String;
      
      private var _BackMusic:String = "050";
      
      public var Weight:int;
      
      public var Wind:Number;
      
      public var DragIndex:int;
      
      public var Type:int;
      
      public function MapInfo()
      {
         super();
      }
      
      public function get BackMusic() : String
      {
         return this._BackMusic;
      }
      
      public function set BackMusic(param1:String) : void
      {
         this._BackMusic = param1;
      }
   }
}
