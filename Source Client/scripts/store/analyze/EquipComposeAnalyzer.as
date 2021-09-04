package store.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import road7th.data.DictionaryData;
   import store.data.EquipComposeInfo;
   
   public class EquipComposeAnalyzer extends DataAnalyzer
   {
       
      
      public var list:DictionaryData;
      
      private var _xml:XML;
      
      public function EquipComposeAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:int = 0;
         var _loc4_:EquipComposeInfo = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         this._xml = new XML(param1);
         var _loc2_:XMLList = this._xml.item;
         if(this._xml.@value == "true")
         {
            this.list = new DictionaryData();
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new EquipComposeInfo();
               if(_loc2_[_loc3_].@TemplateIDs)
               {
                  _loc5_ = _loc2_[_loc3_].@TemplateIDs;
                  _loc6_ = _loc5_.split("|");
                  _loc4_.TemplateID = _loc6_[0];
                  _loc4_.rate = _loc6_[1];
               }
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               this.list.add(_loc4_.TemplateID,_loc4_);
               _loc3_++;
            }
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
