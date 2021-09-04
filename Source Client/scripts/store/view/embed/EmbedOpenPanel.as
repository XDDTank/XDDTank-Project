package store.view.embed
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class EmbedOpenPanel extends Sprite implements Disposeable
   {
       
      
      private var _openBtn:BaseButton;
      
      private var _alert:BaseAlerFrame;
      
      private var _info:InventoryItemInfo;
      
      private var _index:int;
      
      public function EmbedOpenPanel()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      private function init() : void
      {
         this._openBtn = ComponentFactory.Instance.creat("ddtstore.embed.embedBg.openPanel.openBtn");
         addChild(this._openBtn);
      }
      
      protected function addEvent() : void
      {
         this._openBtn.addEventListener(MouseEvent.CLICK,this.__click);
      }
      
      protected function removeEvent() : void
      {
         this._openBtn.removeEventListener(MouseEvent.CLICK,this.__click);
         if(this._alert)
         {
            this._alert.removeEventListener(FrameEvent.RESPONSE,this.__response);
         }
      }
      
      protected function __click(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:Array = EquipType.getEmbedHoleInfo(this._info,this._index);
         if(this._alert)
         {
            this._alert.removeEventListener(FrameEvent.RESPONSE,this.__response);
            this._alert.dispose();
         }
         this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.store.embedBG.openEmbed.alert.msg",_loc2_[1],_loc2_[2]),LanguageMgr.GetTranslation("yes"),LanguageMgr.GetTranslation("no"),false,true,true);
         this._alert.addEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      protected function __response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._alert.removeEventListener(FrameEvent.RESPONSE,this.__response);
         this._alert.dispose();
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.checkDrill();
         }
      }
      
      private function checkDrill() : void
      {
         var _loc3_:QuickBuyFrame = null;
         var _loc1_:Array = EquipType.getEmbedHoleInfo(this._info,this._index);
         var _loc2_:int = PlayerManager.Instance.Self.Bag.getItemCountByTemplateId(EquipType.DIAMOND_DRIL);
         if(_loc2_ < _loc1_[1])
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.openHole.lessmsg"));
            _loc3_ = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            _loc3_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            _loc3_.itemID = EquipType.DIAMOND_DRIL;
            _loc3_.stoneNumber = _loc1_[1] - _loc2_;
            LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         else
         {
            SocketManager.Instance.out.sendOpenEmbedHole(this.index);
         }
      }
      
      public function get info() : InventoryItemInfo
      {
         return this._info;
      }
      
      public function set info(param1:InventoryItemInfo) : void
      {
         this._info = param1;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(param1:int) : void
      {
         this._index = param1;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._openBtn);
         this._openBtn = null;
         ObjectUtils.disposeObject(this._alert);
         this._alert = null;
         this._info = null;
      }
   }
}
