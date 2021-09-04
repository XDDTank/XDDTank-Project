package store.view.Compose
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import store.HelpFrame;
   import store.HelpPrompt;
   import store.IStoreViewBG;
   import store.StoreDragInArea;
   import store.view.Compose.view.ComposeItemsView;
   import store.view.Compose.view.ComposeMaterialShow;
   
   public class StoreIIComposeBG extends Sprite implements IStoreViewBG
   {
      
      public static const MAX_COUNT:int = 99;
       
      
      private var _area:StoreDragInArea;
      
      private var _mainCellArray:Array;
      
      private var _bg:MutipleImage;
      
      private var _composeTitle:Bitmap;
      
      private var _composeMaterialShow:ComposeMaterialShow;
      
      public var START_COMPOSE:int = 0;
      
      private var _composeItemsView:ComposeItemsView;
      
      private var _composeUpgrades:MovieClip;
      
      private var _goldAlertFrame:BaseAlerFrame;
      
      private var _quickBuyFrame:QuickBuyFrame;
      
      public function StoreIIComposeBG()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._mainCellArray = new Array();
         this._composeTitle = ComponentFactory.Instance.creatBitmap("asset.ddtstore.ComposeTitle");
         this._area = new StoreDragInArea(this._mainCellArray);
         this.hide();
         this._composeMaterialShow = new ComposeMaterialShow();
         addChild(this._composeMaterialShow);
         this._composeItemsView = ComponentFactory.Instance.creatCustomObject("ddtstore.ComposeItemsView");
         addChild(this._composeItemsView);
      }
      
      public function setCell(param1:BagCell) : void
      {
         var _loc2_:int = 0;
         var _loc3_:InventoryItemInfo = param1.info as InventoryItemInfo;
         if(ComposeController.instance.model.composeItemInfoDic[_loc3_.TemplateID])
         {
            SocketManager.Instance.out.sendMoveGoods(_loc3_.BagType,_loc3_.Place,BagInfo.STOREBAG,_loc2_,_loc3_.Count,true);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StoreIIComposeBG.cannotCompose"));
         }
      }
      
      public function startShine(param1:int) : void
      {
      }
      
      public function refreshData(param1:Dictionary) : void
      {
         this._composeMaterialShow.info = this._composeMaterialShow.info;
      }
      
      public function updateData() : void
      {
      }
      
      public function stopShine() : void
      {
      }
      
      private function initEvent() : void
      {
         this._composeMaterialShow.addEventListener(ComposeEvents.START_COMPOSE,this.__sendCompose);
         ComposeController.instance.addEventListener(ComposeController.COMPOSE_PLAY,this.__playMc);
      }
      
      private function __playMc(param1:Event) : void
      {
         if(!this._composeUpgrades)
         {
            this._composeUpgrades = ClassUtils.CreatInstance("asset.strength.weaponUpgrades");
         }
         this._composeUpgrades.gotoAndPlay(1);
         this._composeUpgrades.addEventListener(Event.ENTER_FRAME,this.__composeUpgradesFrame);
         PositionUtils.setPos(this._composeUpgrades,"ddtstore.StoreIIStrengthBG.composeUpgradesPoint");
         addChild(this._composeUpgrades);
      }
      
      private function __composeUpgradesFrame(param1:Event) : void
      {
         if(this._composeUpgrades)
         {
            if(this._composeUpgrades.currentFrame == this._composeUpgrades.totalFrames)
            {
               this.removeComposeUpgradesMovie();
            }
         }
      }
      
      private function removeComposeUpgradesMovie() : void
      {
         if(this._composeUpgrades.hasEventListener(Event.ENTER_FRAME))
         {
            this._composeUpgrades.removeEventListener(Event.ENTER_FRAME,this.__composeUpgradesFrame);
         }
         if(this.contains(this._composeUpgrades))
         {
            this.removeChild(this._composeUpgrades);
         }
         if(this._composeUpgrades)
         {
            this._composeUpgrades.stop();
            ObjectUtils.disposeObject(this._composeUpgrades);
            this._composeUpgrades = null;
         }
      }
      
      private function __sendCompose(param1:ComposeEvents) : void
      {
         var _loc2_:BaseAlerFrame = null;
         if(this._composeMaterialShow.info)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            if(this._composeMaterialShow.getBind())
            {
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.StoreIIComposeBG.use"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               _loc2_.moveEnable = false;
               _loc2_.info.enableHtml = true;
               _loc2_.info.mutiline = true;
               _loc2_.addEventListener(FrameEvent.RESPONSE,this._bingResponse);
            }
            else
            {
               this.sendSocket();
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StoreIIComposeBG.selectComposeItem"));
         }
      }
      
      private function sendSocket() : void
      {
         SocketManager.Instance.out.sendItemCompose(this.START_COMPOSE,this._composeMaterialShow.info.TemplateID,this._composeMaterialShow.composeCount);
      }
      
      public function show() : void
      {
         this.visible = true;
      }
      
      public function hide() : void
      {
         this.visible = false;
      }
      
      public function get area() : Array
      {
         return null;
      }
      
      private function _bingResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this._bingResponse);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.sendSocket();
         }
         ObjectUtils.disposeObject(param1.target);
      }
      
      private function __quickBuyResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._goldAlertFrame.removeEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
         this._goldAlertFrame.dispose();
         this._goldAlertFrame = null;
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this._quickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            this._quickBuyFrame.itemID = EquipType.GOLD_BOX;
            this._quickBuyFrame.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            LayerManager.Instance.addToLayer(this._quickBuyFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      private function __openHelp(param1:MouseEvent) : void
      {
      }
      
      public function dispose() : void
      {
         this._mainCellArray = null;
         this._composeMaterialShow.removeEventListener(ComposeEvents.START_COMPOSE,this.__sendCompose);
         if(this._composeItemsView)
         {
            ObjectUtils.disposeObject(this._composeItemsView);
         }
         this._composeItemsView = null;
         if(this._composeMaterialShow)
         {
            ObjectUtils.disposeObject(this._composeMaterialShow);
         }
         this._composeMaterialShow = null;
         if(this._area)
         {
            this._area.dispose();
         }
         this._area = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         if(this._composeTitle)
         {
            ObjectUtils.disposeObject(this._composeTitle);
         }
         this._composeTitle = null;
         if(this._goldAlertFrame)
         {
            ObjectUtils.disposeObject(this._goldAlertFrame);
         }
         this._goldAlertFrame = null;
         if(this._quickBuyFrame)
         {
            ObjectUtils.disposeObject(this._quickBuyFrame);
         }
         this._quickBuyFrame = null;
         if(this._composeUpgrades)
         {
            this._composeUpgrades.stop();
            ObjectUtils.disposeObject(this._composeUpgrades);
            this._composeUpgrades = null;
         }
      }
      
      public function openHelp() : void
      {
         var _loc1_:HelpPrompt = ComponentFactory.Instance.creat("ddtstore.ComposeHelpPrompt");
         var _loc2_:HelpFrame = ComponentFactory.Instance.creat("ddtstore.HelpFrame");
         _loc2_.setView(_loc1_);
         _loc2_.titleText = LanguageMgr.GetTranslation("store.StoreIIComposeBG.say");
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
   }
}
