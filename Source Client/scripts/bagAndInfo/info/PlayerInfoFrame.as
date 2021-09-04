package bagAndInfo.info
{
   import bagAndInfo.BagAndGiftFrame;
   import bead.BeadManager;
   import bead.view.BeadInfoView;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PetBagManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import petsBag.view.others.PetOtherInfoView;
   import totem.TotemManager;
   import totem.view.TotemInfoView;
   
   public class PlayerInfoFrame extends Frame
   {
       
      
      private var _BG:ScaleBitmapImage;
      
      private var _bgI:Scale9CornerImage;
      
      private var _view:PlayerInfoView;
      
      private var _info:PlayerInfo;
      
      private var _totemView:TotemInfoView;
      
      private var _petsView:PetOtherInfoView;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _infoBtn:SelectedButton;
      
      private var _petBtn:SelectedButton;
      
      private var _beadBtn:SelectedButton;
      
      private var _totemBtn:SelectedButton;
      
      private var _hBox:HBox;
      
      private var _beadView:BeadInfoView;
      
      private var _tagCount:int = 0;
      
      private var _openTexp:Boolean;
      
      public function PlayerInfoFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this.escEnable = true;
         this.enterEnable = true;
         titleText = LanguageMgr.GetTranslation("tank.room.RoomIIPlayerItem.view");
         this._BG = ComponentFactory.Instance.creatComponentByStylename("PlayerInfoFrame.bg");
         this._bgI = ComponentFactory.Instance.creatComponentByStylename("totem.playerPersonBG");
         this._infoBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.playerInfoBtn");
         this._petBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.petInfoBtn");
         this._beadBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.beadInfoBtn");
         this._totemBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.totemInfoBtn");
         addToContent(this._BG);
         addToContent(this._bgI);
         addToContent(this._infoBtn);
         addToContent(this._totemBtn);
         addToContent(this._beadBtn);
         addToContent(this._petBtn);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._infoBtn);
         this._btnGroup.addSelectItem(this._beadBtn);
         this._btnGroup.addSelectItem(this._totemBtn);
         this._btnGroup.addSelectItem(this._petBtn);
         this._btnGroup.selectIndex = 0;
      }
      
      private function initEvent() : void
      {
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._infoBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._totemBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._beadBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._petBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
      }
      
      private function __soundPlayer(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __changeHandler(param1:Event) : void
      {
         switch(this._btnGroup.selectIndex)
         {
            case BagAndGiftFrame.BAGANDINFO:
               this.showInfoFrame();
               break;
            case BagAndGiftFrame.BEADVIEW:
               this.showBeadFrame();
               break;
            case BagAndGiftFrame.TOTEMVIEW:
               this.showTotem();
               break;
            case BagAndGiftFrame.PETVIEW:
               this.showPetsView();
         }
      }
      
      private function showTotem() : void
      {
         if(!this._totemView)
         {
            TotemManager.instance.loadTotemModule(this.doShowTotem);
         }
         else
         {
            this.setVisible(BagAndGiftFrame.TOTEMVIEW);
         }
      }
      
      private function doShowTotem() : void
      {
         this._totemView = new TotemInfoView(this._info);
         this._totemView.y = -3;
         addToContent(this._totemView);
         this.setVisible(BagAndGiftFrame.TOTEMVIEW);
      }
      
      private function setVisible(param1:int) : void
      {
         this._view.visible = param1 == BagAndGiftFrame.BAGANDINFO;
         if(this._beadView)
         {
            this._beadView.visible = param1 == BagAndGiftFrame.BEADVIEW;
         }
         if(this._totemView)
         {
            this._totemView.visible = param1 == BagAndGiftFrame.TOTEMVIEW;
         }
         if(this._petsView)
         {
            this._petsView.visible = param1 == BagAndGiftFrame.PETVIEW;
         }
      }
      
      private function showBeadFrame() : void
      {
         if(!this._beadView)
         {
            try
            {
               this._beadView = ComponentFactory.Instance.creatCustomObject("beadInfoView");
               addToContent(this._beadView);
               if(this._info)
               {
                  this._beadView.info = this._info;
               }
               this.setVisible(BagAndGiftFrame.BEADVIEW);
            }
            catch(e:Error)
            {
               ++_tagCount;
               if(_tagCount <= 3)
               {
                  BeadManager.instance.loadBeadModule(__createBead);
               }
            }
         }
         else
         {
            if(this._info)
            {
               this._beadView.info = this._info;
            }
            this.setVisible(BagAndGiftFrame.BEADVIEW);
         }
      }
      
      private function __createBead() : void
      {
         this.showBeadFrame();
      }
      
      private function showInfoFrame() : void
      {
         if(this._view == null)
         {
            this._view = ComponentFactory.Instance.creatCustomObject("bag.PersonalInfoView");
            this._view.showSelfOperation = false;
            addToContent(this._view);
         }
         if(this._info)
         {
            this._view.info = this._info;
            this._view.bagInfo = this._info.Bag;
         }
         this.setVisible(BagAndGiftFrame.BAGANDINFO);
      }
      
      private function showPetsView() : void
      {
         if(PetBagManager.instance().isloading)
         {
            this._petsView = ComponentFactory.Instance.creatCustomObject("bag.PersonalPetView");
            if(this._info)
            {
               this._petsView.info = this._info;
            }
            addToContent(this._petsView);
            this.setVisible(BagAndGiftFrame.PETVIEW);
         }
         else
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__loadPetsProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.NEW_PETS_BAG);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createPets);
         }
      }
      
      protected function __loadPetsProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.NEW_PETS_BAG)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__loadPetsProgress);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createPets);
      }
      
      private function __createPets(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.NEW_PETS_BAG)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createPets);
            PetBagManager.instance().isloading = true;
            this.showPetsView();
         }
      }
      
      private function removeEvent() : void
      {
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._infoBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._petBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._totemBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._btnGroup.selectIndex = 0;
         this.__changeHandler(null);
      }
      
      public function set info(param1:PlayerInfo) : void
      {
         this._info = param1;
         if(this._view)
         {
            this._view.info = this._info;
         }
         if(this._beadView)
         {
            this._beadView.info = this._info;
         }
         if(this._petsView)
         {
            this._petsView.info = this._info;
         }
         if(this._info.Grade < int(ServerConfigManager.instance.findInfoByName(ServerConfigManager.PET_OPEN_LEVEL).Value) || StateManager.isInFight && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._petBtn.enable = false;
         }
         else
         {
            this._petBtn.enable = true;
         }
         if(this._info.Grade < 9 || StateManager.isInFight && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._beadBtn.enable = false;
         }
         else
         {
            this._beadBtn.enable = true;
         }
         if(this._info.Grade < 17 || StateManager.isInFight && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._totemBtn.enable = false;
         }
         else
         {
            this._totemBtn.enable = true;
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this._info = null;
         if(this._BG)
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(this._bgI)
         {
            ObjectUtils.disposeObject(this._bgI);
         }
         this._bgI = null;
         if(this._infoBtn)
         {
            ObjectUtils.disposeObject(this._infoBtn);
         }
         this._infoBtn = null;
         if(this._petBtn)
         {
            ObjectUtils.disposeObject(this._petBtn);
            this._petBtn = null;
         }
         if(this._btnGroup)
         {
            ObjectUtils.disposeObject(this._btnGroup);
         }
         this._btnGroup = null;
         if(this._view)
         {
            this._view.dispose();
         }
         this._view = null;
         ObjectUtils.disposeObject(this._petsView);
         this._petsView = null;
         if(this._totemBtn)
         {
            ObjectUtils.disposeObject(this._totemBtn);
            this._totemBtn = null;
         }
         if(this._beadView)
         {
            this._beadView.dispose();
         }
         this._beadView = null;
         PlayerInfoViewControl.clearView();
         super.dispose();
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
