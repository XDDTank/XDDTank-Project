package tofflist.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.describeType;
   import tofflist.data.TofflistConsortiaData;
   import tofflist.data.TofflistConsortiaInfo;
   import tofflist.data.TofflistListData;
   import tofflist.data.TofflistPlayerInfo;
   
   public class TofflistListAnalyzer extends DataAnalyzer
   {
       
      
      public var data:TofflistListData;
      
      private var _xml:XML;
      
      public var listName:String;
      
      public function TofflistListAnalyzer(param1:Function, param2:String)
      {
         super(param1);
         this.listName = param2;
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:TofflistPlayerInfo = null;
         var _loc5_:XML = null;
         var _loc6_:int = 0;
         var _loc7_:TofflistConsortiaData = null;
         var _loc8_:TofflistConsortiaInfo = null;
         var _loc9_:TofflistPlayerInfo = null;
         this._xml = new XML(param1);
         var _loc2_:Array = new Array();
         this.data = new TofflistListData();
         this.data.lastUpdateTime = this._xml.@date;
         if(this._xml.@value == "true")
         {
            _loc3_ = XML(this._xml)..Item;
            _loc4_ = new TofflistPlayerInfo();
            _loc5_ = describeType(_loc4_);
            _loc6_ = 0;
            while(_loc6_ < _loc3_.length())
            {
               _loc7_ = new TofflistConsortiaData();
               _loc8_ = new TofflistConsortiaInfo();
               ObjectUtils.copyPorpertiesByXML(_loc8_,_loc3_[_loc6_]);
               _loc7_.consortiaInfo = _loc8_;
               if(_loc3_[_loc6_].children().length() > 0)
               {
                  _loc9_ = new TofflistPlayerInfo();
                  _loc9_.beginChanges();
                  ObjectUtils.copyPorpertiesByXML(_loc9_,_loc3_[_loc6_].Item[0]);
                  _loc9_.commitChanges();
                  _loc7_.playerInfo = _loc9_;
                  _loc2_.push(_loc7_);
               }
               _loc6_++;
            }
            this.data.list = _loc2_;
            onAnalyzeComplete();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
