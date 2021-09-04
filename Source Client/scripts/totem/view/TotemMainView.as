package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import road7th.comm.PackageIn;
   import totem.TotemManager;
   import totem.data.TotemEvent;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class TotemMainView extends Sprite implements Disposeable
   {
       
      
      private var _leftView:TotemLeftView;
      
      private var _bg:Bitmap;
      
      public function TotemMainView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.totem.totemViewBg");
         this._leftView = ComponentFactory.Instance.creatCustomObject("totemLeftView");
         addChild(this._bg);
         addChild(this._leftView);
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TOTEM,this.refresh);
      }
      
      private function refresh(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:Boolean = false;
         TotemManager.instance.isLast = false;
         TotemManager.instance.isUpgrade = false;
         var _loc2_:PackageIn = param1.pkg;
         PlayerManager.Instance.Self.GP = _loc2_.readInt();
         PlayerManager.Instance.Self.totemScores = _loc2_.readInt();
         var _loc3_:int = _loc2_.readInt();
         if(_loc3_ == PlayerManager.Instance.Self.totemId)
         {
            _loc4_ = false;
            SoundManager.instance.play("202");
         }
         else
         {
            SoundManager.instance.play("201");
            _loc4_ = true;
            TotemManager.instance.isUpgrade = true;
            if((_loc3_ - 10000) % 7 == 0)
            {
               TotemManager.instance.isLast = true;
            }
            PlayerManager.Instance.Self.totemId = _loc3_;
            TotemManager.instance.updatePropertyAddtion(PlayerManager.Instance.Self.totemId,PlayerManager.Instance.Self.propertyAddition);
            PlayerManager.Instance.dispatchEvent(new Event(PlayerManager.UPDATE_PLAYER_PROPERTY));
         }
         this._leftView.refreshView(_loc4_);
         TotemManager.instance.dispatchEvent(new TotemEvent(TotemEvent.TOTEM_UPDATE));
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.TOTEM,this.refresh);
      }
      
      public function showUserGuilde() : void
      {
         this._leftView.showUserGuilde();
      }
      
      public function dispose() : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_TOTEM);
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._leftView = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
