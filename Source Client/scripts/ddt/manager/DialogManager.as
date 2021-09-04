package ddt.manager
{
   import com.pickgliss.ui.DialogManagerBase;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.utils.PositionUtils;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ICharacter;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class DialogManager extends DialogManagerBase
   {
      
      private static var _instance:DialogManager;
       
      
      public function DialogManager()
      {
         super();
         this.addEventListener(Event.COMPLETE,this.__enableChat);
      }
      
      public static function get Instance() : DialogManager
      {
         if(_instance == null)
         {
            _instance = new DialogManager();
         }
         return _instance;
      }
      
      override public function showDialog(param1:int, param2:Number = 0, param3:Boolean = true, param4:Boolean = true, param5:Boolean = true, param6:int = 4) : void
      {
         super.showDialog(param1,param2,param3,param4,param5,param6);
         ChatManager.Instance.chatDisabled = true;
      }
      
      private function __enableChat(param1:Event) : void
      {
         ChatManager.Instance.chatDisabled = false;
      }
      
      override protected function Self(param1:int) : DisplayObject
      {
         var _loc2_:ICharacter = null;
         var _loc3_:PlayerInfo = new PlayerInfo();
         var _loc4_:SelfInfo = PlayerManager.Instance.Self;
         _loc3_.updateStyle(_loc4_.Sex,_loc4_.Hide,_loc4_.getPrivateStyle(),_loc4_.Colors,_loc4_.getSkinColor());
         _loc3_.WeaponID = PlayerManager.Instance.Self.WeaponID;
         _loc2_ = CharactoryFactory.createCharacter(_loc3_,"room");
         _loc2_.showGun = true;
         _loc2_.show(false,-1);
         _loc2_.setShowLight(true);
         _loc2_.scaleX = 1.4;
         _loc2_.scaleY = 1.4;
         PositionUtils.setPos(_loc2_,"dialog.headImgPos");
         var _loc5_:ItemTemplateInfo = new ItemTemplateInfo();
         _loc5_.TemplateID = -111;
         _loc5_.CategoryID = EquipType.FACE;
         if(param1 > 0)
         {
            _loc3_.setPartStyle(_loc5_,0,param1,"");
         }
         return _loc2_ as DisplayObject;
      }
      
      override protected function SelfName() : String
      {
         return PlayerManager.Instance.Self.NickName;
      }
   }
}
