package ddt.data.analyze
{
   import bead.model.BeadConfig;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class BeadDataAnalyzer extends DataAnalyzer
   {
       
      
      private var _list:Object;
      
      private var _beadConfig:BeadConfig;
      
      public function BeadDataAnalyzer(param1:Function)
      {
         super(param1);
         this._beadConfig = new BeadConfig();
      }
      
      public function get list() : Object
      {
         return this._list;
      }
      
      public function get beadConfig() : BeadConfig
      {
         return this._beadConfig;
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:XMLList = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:XMLList = null;
         var _loc9_:Object = null;
         var _loc10_:XML = null;
         this._list = {};
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Config;
            ObjectUtils.copyPorpertiesByXML(this._beadConfig,_loc3_[0]);
            _loc4_ = _loc2_..Item;
            _loc5_ = _loc4_.length();
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               if(this._list[_loc4_[_loc6_].@Type])
               {
                  _loc7_ = this._list[_loc4_[_loc6_].@Type];
               }
               else
               {
                  _loc7_ = {};
                  this._list[_loc4_[_loc6_].@Type] = _loc7_;
               }
               _loc8_ = (_loc4_[_loc6_] as XML).attributes();
               _loc9_ = {};
               for each(_loc10_ in _loc8_)
               {
                  _loc9_[_loc10_.name().toString()] = _loc10_.toString();
               }
               _loc7_[_loc4_[_loc6_].@Level] = _loc9_;
               _loc6_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
