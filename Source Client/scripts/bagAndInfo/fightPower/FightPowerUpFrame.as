package bagAndInfo.fightPower
{
   import bagAndInfo.BagAndGiftFrame;
   import bagAndInfo.BagAndInfoManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.bagStore.BagStore;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PetBagManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   import store.StoreMainView;
   
   public class FightPowerUpFrame extends Frame
   {
       
      
      private var _btnTypeList:Vector.<uint>;
      
      private var _btnList:Vector.<PowerUpSystemButton>;
      
      private var _buttonVBox:VBox;
      
      private var _hBoxList:Vector.<HBox>;
      
      public function FightPowerUpFrame()
      {
         super();
         escEnable = true;
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this.initView();
         this.initEvent();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function initView() : void
      {
         var _loc5_:HBox = null;
         var _loc6_:PowerUpSystemButton = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         titleText = LanguageMgr.GetTranslation("ddt.FightPowerUpFrame.titleTxt");
         this._buttonVBox = ComponentFactory.Instance.creatComponentByStylename("hall.fightPowerUpButtonVBox");
         this._hBoxList = new Vector.<HBox>();
         var _loc1_:uint = 0;
         while(_loc1_ < 4)
         {
            _loc5_ = ComponentFactory.Instance.creatComponentByStylename("hall.fightPowerUpButtonHBox");
            this._hBoxList.push(_loc5_);
            _loc1_++;
         }
         this._btnList = new Vector.<PowerUpSystemButton>();
         this._btnTypeList = new Vector.<uint>();
         this.addBtns();
         var _loc2_:uint = 0;
         while(_loc2_ < this._btnTypeList.length)
         {
            _loc6_ = new PowerUpSystemButton(this._btnTypeList[_loc2_]);
            this._btnList.push(_loc6_);
            _loc6_.addEventListener(MouseEvent.CLICK,this.__clickButton);
            this._hBoxList[int(_loc2_ / 2)].addChild(_loc6_);
            _loc2_++;
         }
         var _loc3_:uint = 0;
         while(_loc3_ < 4)
         {
            this._buttonVBox.addChild(this._hBoxList[_loc3_]);
            _loc3_++;
         }
         this._btnList.sort(this.sortBtnByProgress);
         var _loc4_:Vector.<PowerUpSystemButton> = this.getRecommendList();
         if(_loc4_.length > 0)
         {
            _loc7_ = _loc4_.length > 2 ? uint(2) : uint(_loc4_.length);
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc4_[_loc8_].setRecommendVisible();
               _loc8_++;
            }
         }
         addToContent(this._buttonVBox);
      }
      
      private function getRecommendList() : Vector.<PowerUpSystemButton>
      {
         var _loc1_:Vector.<PowerUpSystemButton> = new Vector.<PowerUpSystemButton>();
         var _loc2_:uint = 0;
         while(_loc2_ < this._btnList.length)
         {
            if(this._btnList[_loc2_].progress <= 35)
            {
               _loc1_.push(this._btnList[_loc2_]);
            }
            _loc2_++;
         }
         if(_loc1_.length > 1)
         {
            _loc1_.sort(this.sortBtnByType);
         }
         return _loc1_;
      }
      
      private function addBtns() : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc1_:int = PlayerManager.Instance.Self.Grade;
         if(_loc1_ >= FightPowerController.Instance.getMinLevelByType(FightPowerController.EQUIP_FIGHT_POWER))
         {
            this._btnTypeList.push(PowerUpSystemButton.EQUIP_SYSTEM);
         }
         if(_loc1_ >= FightPowerController.Instance.getMinLevelByType(FightPowerController.STRENG_FIGHT_POWER))
         {
            this._btnTypeList.push(PowerUpSystemButton.STRENG_SYSTEM);
         }
         if(_loc1_ >= FightPowerController.Instance.getMinLevelByType(FightPowerController.BEAD_FIGHT_POWER))
         {
            this._btnTypeList.push(PowerUpSystemButton.BEAD_SYSTEM);
         }
         if(_loc1_ >= FightPowerController.Instance.getMinLevelByType(FightPowerController.PET_FIGHT_POWER))
         {
            this._btnTypeList.push(PowerUpSystemButton.PET_SYSTEM);
         }
         if(_loc1_ >= FightPowerController.Instance.getMinLevelByType(FightPowerController.TOTEM_FIGHT_POWER))
         {
            this._btnTypeList.push(PowerUpSystemButton.TOTEM_SYSTEM);
         }
         if(_loc1_ >= FightPowerController.Instance.getMinLevelByType(FightPowerController.RUNE_FIGHT_POWER))
         {
            this._btnTypeList.push(PowerUpSystemButton.RUNE_SYSTEM);
         }
         if(_loc1_ >= FightPowerController.Instance.getMinLevelByType(FightPowerController.REFINING_FIGHT_POWER))
         {
            this._btnTypeList.push(PowerUpSystemButton.REFINING_SYSTEM);
         }
         if(_loc1_ >= FightPowerController.Instance.getMinLevelByType(FightPowerController.PET_ADVANCE_FIGHT_POWER))
         {
            this._btnTypeList.push(PowerUpSystemButton.PETADVANCE_SYSTEM);
         }
         if(this._btnTypeList.length < 8)
         {
            _loc2_ = this._btnTypeList.length;
            _loc3_ = 0;
            while(_loc3_ < 8 - _loc2_)
            {
               this._btnTypeList.push(PowerUpSystemButton.NOT_OPEN);
               _loc3_++;
            }
         }
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         var _loc1_:uint = 0;
         while(_loc1_ < this._btnList.length)
         {
            this._btnList[_loc1_].removeEventListener(MouseEvent.CLICK,this.__clickButton);
            _loc1_++;
         }
      }
      
      private function sortBtnByProgress(param1:PowerUpSystemButton, param2:PowerUpSystemButton) : int
      {
         if(param1.progress >= param2.progress)
         {
            return 1;
         }
         return -1;
      }
      
      private function sortBtnByType(param1:PowerUpSystemButton, param2:PowerUpSystemButton) : int
      {
         if(param1.type >= param2.type)
         {
            return 1;
         }
         return -1;
      }
      
      private function __clickButton(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch((param1.target as PowerUpSystemButton).type)
         {
            case PowerUpSystemButton.EQUIP_SYSTEM:
               BagStore.instance.show(StoreMainView.COMPOSE);
               BagAndInfoManager.Instance.hideBagAndInfo();
               break;
            case PowerUpSystemButton.STRENG_SYSTEM:
               BagStore.instance.show(StoreMainView.STRENGTH);
               BagAndInfoManager.Instance.hideBagAndInfo();
               break;
            case PowerUpSystemButton.BEAD_SYSTEM:
               BagAndInfoManager.Instance.showBagAndInfo(BagAndGiftFrame.BEADVIEW);
               break;
            case PowerUpSystemButton.PET_SYSTEM:
               PetBagManager.instance().openPetFrame(0);
               break;
            case PowerUpSystemButton.TOTEM_SYSTEM:
               BagAndInfoManager.Instance.showBagAndInfo(BagAndGiftFrame.TOTEMVIEW);
               break;
            case PowerUpSystemButton.RUNE_SYSTEM:
               BagStore.instance.show(StoreMainView.EMBED);
               BagAndInfoManager.Instance.hideBagAndInfo();
               break;
            case PowerUpSystemButton.PETADVANCE_SYSTEM:
               PetBagManager.instance().openPetFrame(1);
               break;
            case PowerUpSystemButton.REFINING_SYSTEM:
               BagStore.instance.show(StoreMainView.REFINING);
               BagAndInfoManager.Instance.hideBagAndInfo();
         }
         this.dispose();
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:HBox = null;
         this.removeEvent();
         for each(_loc1_ in this._hBoxList)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
         ObjectUtils.disposeObject(this._hBoxList);
         this._hBoxList = null;
         ObjectUtils.disposeObject(this._buttonVBox);
         this._buttonVBox = null;
         this._btnList = null;
         this._btnTypeList = null;
         super.dispose();
      }
   }
}
