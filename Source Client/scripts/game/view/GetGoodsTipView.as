package game.view
{
   import bagAndInfo.BagAndInfoManager;
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.events.Event;
   
   public class GetGoodsTipView extends BaseAlerFrame
   {
      
      public static const P_cellIndex:String = "cellIndex";
      
      public static const P_type:String = "type";
       
      
      private var _cell:BaseCell;
      
      private var _itemName:FilterFrameText;
      
      private var _type:int;
      
      private var _item:InventoryItemInfo;
      
      public function GetGoodsTipView()
      {
         super();
         info = new AlertInfo();
         info.title = LanguageMgr.GetTranslation("AlertDialog.Info");
         info.bottomGap = 20;
         info.showCancel = false;
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__alertResponse);
         BagAndInfoManager.Instance.addEventListener(Event.OPEN,this.__openBag);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__alertResponse);
         BagAndInfoManager.Instance.removeEventListener(Event.OPEN,this.__openBag);
      }
      
      private function __alertResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            PlayerManager.Instance.Self.EquipInfo = this._item;
            if(this._item && this._item.CategoryID == 40)
            {
               if(ItemManager.Instance.getEquipTemplateById(this._item.TemplateID).NeedLevel > PlayerManager.Instance.Self.Grade)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.data.player.SelfInfo.need"));
               }
               else if(EquipType.ContrastGoods(this._item))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.immediatelyequipment.fail"));
               }
               else if(StateManager.currentStateType == StateType.SHOP)
               {
                  SocketManager.Instance.out.sendMoveGoods(0,this._item.Place,0,PlayerManager.Instance.getEquipPlace(this._item),0);
               }
               else
               {
                  BagAndInfoManager.Instance.showBagAndInfo();
               }
            }
            else if(EquipType.isPackage(this._item) || EquipType.canBeUsed(this._item))
            {
               BagAndInfoManager.Instance.showBagAndInfo();
            }
         }
         this.dispose();
      }
      
      protected function __openBag(param1:Event) : void
      {
         this.dispose();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,false,0,false);
      }
      
      override protected function init() : void
      {
         super.init();
         this._cell = ComponentFactory.Instance.creat("core.getGoodsTip.cell",[ComponentFactory.Instance.creatBitmap("asset.newCore.itemCellBg")]);
         addToContent(this._cell);
         this._itemName = ComponentFactory.Instance.creatComponentByStylename("core.getGoodsTipName");
         this._itemName.mouseEnabled = false;
         this._itemName.multiline = true;
         this._itemName.wordWrap = true;
         addToContent(this._itemName);
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set type(param1:int) : void
      {
         this._type = param1;
         if(this._type == 40)
         {
            info.submitLabel = LanguageMgr.GetTranslation("GetGoodsTipView.immediatelyEquip");
         }
         else
         {
            info.submitLabel = LanguageMgr.GetTranslation("GetGoodsTipView.immediatelyOpen");
         }
      }
      
      public function get item() : InventoryItemInfo
      {
         return this._item;
      }
      
      public function set item(param1:InventoryItemInfo) : void
      {
         this._item = param1;
         this.type = this._item.CategoryID;
         this._cell.info = this._item;
         this._itemName.text = this._item.Name;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         ObjectUtils.disposeObject(this._cell);
         this._cell = null;
         ObjectUtils.disposeObject(this._itemName);
         this._itemName = null;
         this._item = null;
      }
   }
}
