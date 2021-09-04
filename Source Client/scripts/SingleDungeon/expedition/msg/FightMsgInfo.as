package SingleDungeon.expedition.msg
{
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   
   public class FightMsgInfo
   {
       
      
      private var _templateID:int;
      
      public var times:int;
      
      public var dungeonName:String;
      
      public var count:int;
      
      public var name:String;
      
      public function FightMsgInfo()
      {
         super();
      }
      
      public function set templateID(param1:int) : void
      {
         var _loc2_:ItemTemplateInfo = null;
         this._templateID = param1;
         if(param1 != 1 && param1 != -1 && param1 != -2)
         {
            if(this._templateID == -3)
            {
               this.name = LanguageMgr.GetTranslation("gold");
            }
            else if(this._templateID == -100)
            {
               this.name = LanguageMgr.GetTranslation("exp");
            }
            else
            {
               _loc2_ = ItemManager.Instance.getTemplateById(this._templateID);
               this.name = _loc2_.Name;
            }
         }
      }
      
      public function get templateID() : int
      {
         return this._templateID;
      }
   }
}
