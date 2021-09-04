package game.actions
{
   import game.model.Living;
   
   public class UpdateStateAction extends BaseAction
   {
       
      
      private var _info:Living;
      
      private var _propertys:Object;
      
      private var _isExecute:Boolean;
      
      public function UpdateStateAction(param1:Living, param2:Object)
      {
         super();
         this._info = param1;
         this._propertys = param2;
      }
      
      override public function prepare() : void
      {
         if(_isPrepare)
         {
            return;
         }
         this.updateProperties();
         _isPrepare = true;
      }
      
      private function updateProperties() : void
      {
         var _loc1_:* = null;
         if(this._info && this._propertys)
         {
            for(_loc1_ in this._propertys)
            {
               if(this._info.hasOwnProperty(_loc1_))
               {
                  this._info[_loc1_] = this._propertys[_loc1_];
               }
            }
         }
         this._info = null;
         this._propertys = null;
      }
      
      override public function executeAtOnce() : void
      {
         super.executeAtOnce();
      }
      
      override public function cancel() : void
      {
         this.prepare();
      }
   }
}
