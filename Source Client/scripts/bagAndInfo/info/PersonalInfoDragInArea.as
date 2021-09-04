package bagAndInfo.info
{
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.data.BagInfo;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import flash.display.Sprite;
   
   public class PersonalInfoDragInArea extends Sprite implements IAcceptDrag
   {
       
      
      private var temInfo:InventoryItemInfo;
      
      private var temEffect:DragEffect;
      
      public function PersonalInfoDragInArea()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         graphics.beginFill(0,0);
         graphics.drawRect(0,0,470,310);
         graphics.endFill();
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
         var _loc4_:BaseAlerFrame = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            return;
         }
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         var _loc3_:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(_loc2_.TemplateID);
         if(_loc3_)
         {
            if(_loc2_.NeedLevel > PlayerManager.Instance.Self.Grade)
            {
               DragManager.acceptDrag(this,DragEffect.NONE);
               return MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.data.player.SelfInfo.need"));
            }
         }
         if((_loc2_.BindType == 1 || _loc2_.BindType == 2 || _loc2_.BindType == 3) && _loc2_.IsBinds == false)
         {
            _loc4_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.BindsInfo"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
            _loc4_.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
            this.temInfo = _loc2_;
            this.temEffect = param1;
            DragManager.acceptDrag(this,DragEffect.NONE);
            return;
         }
         if(_loc2_)
         {
            param1.action = DragEffect.NONE;
            if(_loc2_.Place < 31)
            {
               DragManager.acceptDrag(this);
            }
            else if(PlayerManager.Instance.Self.canEquip(_loc2_))
            {
               if(PlayerManager.Instance.playerstate == PlayerViewState.FASHION)
               {
                  SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,_loc2_.Place,BagInfo.EQUIPBAG,PlayerManager.Instance.getDressEquipPlace(_loc2_),_loc2_.Count);
               }
               else
               {
                  SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,_loc2_.Place,BagInfo.EQUIPBAG,PlayerManager.Instance.getEquipPlace(_loc2_),_loc2_.Count);
               }
               DragManager.acceptDrag(this,DragEffect.MOVE);
            }
            else
            {
               DragManager.acceptDrag(this);
            }
         }
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = BaseAlerFrame(param1.currentTarget);
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.ESC_CLICK:
               _loc2_.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.sendDefy();
         }
      }
      
      private function sendDefy() : void
      {
         if(this.temInfo)
         {
            this.temEffect.action = DragEffect.NONE;
            if(this.temInfo.Place < 31)
            {
               DragManager.acceptDrag(this);
            }
            else if(PlayerManager.Instance.Self.canEquip(this.temInfo))
            {
               if(PlayerManager.Instance.playerstate == PlayerViewState.FASHION)
               {
                  SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,this.temInfo.Place,BagInfo.EQUIPBAG,PlayerManager.Instance.getDressEquipPlace(this.temInfo),this.temInfo.Count);
               }
               else
               {
                  SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,this.temInfo.Place,BagInfo.EQUIPBAG,PlayerManager.Instance.getEquipPlace(this.temInfo),this.temInfo.Count);
               }
               DragManager.acceptDrag(this,DragEffect.MOVE);
            }
            else
            {
               DragManager.acceptDrag(this);
            }
         }
      }
   }
}
