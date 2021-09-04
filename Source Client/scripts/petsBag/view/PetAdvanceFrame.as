package petsBag.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.events.BagEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PetBagManager;
   import ddt.manager.PetInfoManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import pet.date.PetAdvanceInfo;
   import pet.date.PetInfo;
   import petsBag.view.item.PetAdvanceBar;
   import petsBag.view.item.PetAdvancePropertyItem;
   import petsBag.view.item.PetBigItem;
   import petsBag.view.item.PetBlessBar;
   
   public class PetAdvanceFrame extends PetRightBaseFrame
   {
       
      
      private var _bg2:MutipleImage;
      
      private var _btnBg:Scale9CornerImage;
      
      private var _leftLabel:Bitmap;
      
      private var _rightLabel:Bitmap;
      
      private var _leftNum1:ScaleFrameImage;
      
      private var _leftNum2:ScaleFrameImage;
      
      private var _rightNum1:ScaleFrameImage;
      
      private var _rightNum2:ScaleFrameImage;
      
      private var _currentBg:ScaleFrameImage;
      
      private var _nextBg:ScaleFrameImage;
      
      private var _currentPet:PetBigItem;
      
      private var _nextPet:PetBigItem;
      
      private var _advanceBar:PetAdvanceBar;
      
      private var _propertyList:Vector.<PetAdvancePropertyItem>;
      
      private var _vBox:VBox;
      
      private var _advanceBlessLabel:FilterFrameText;
      
      private var _blessBar:PetBlessBar;
      
      private var _advanceBlessTipTxt:FilterFrameText;
      
      private var _advanceNeedTxt:FilterFrameText;
      
      private var _advanceNeedLabel:Bitmap;
      
      private var _stoneCountTxt:FilterFrameText;
      
      private var _advanceCountBg:Bitmap;
      
      private var _advanceBtn:BaseButton;
      
      private var _advanceShine:MovieClip;
      
      private var _lastInfo:PetInfo;
      
      private var _titleBmp:Bitmap;
      
      private var _bloodLabel:MutipleImage;
      
      private var _attackLabel:MutipleImage;
      
      private var _defenceLabel:MutipleImage;
      
      private var _agilityLabel:MutipleImage;
      
      private var _luckLabel:MutipleImage;
      
      public function PetAdvanceFrame()
      {
         super();
         this.initEvent();
      }
      
      override protected function init() : void
      {
         var _loc2_:PetAdvancePropertyItem = null;
         super.init();
         this._titleBmp = ComponentFactory.Instance.creatBitmap("asset.petAdv.title");
         addToContent(this._titleBmp);
         this._bg2 = ComponentFactory.Instance.creatComponentByStylename("petsBag.petAdvanceFrame.bg");
         addToContent(this._bg2);
         this._btnBg = ComponentFactory.Instance.creatComponentByStylename("asset.newpetsBag.petadvacebtnBg");
         addToContent(this._btnBg);
         this._leftLabel = ComponentFactory.Instance.creatBitmap("asset.petsBag.petAdvance.BlueLabel");
         addToContent(this._leftLabel);
         this._rightLabel = ComponentFactory.Instance.creatBitmap("asset.petsBag.petAdvance.RedLabel");
         addToContent(this._rightLabel);
         this._leftNum1 = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.currentNum1");
         addToContent(this._leftNum1);
         this._leftNum2 = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.currentNum2");
         addToContent(this._leftNum2);
         this._rightNum1 = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.nextNum1");
         addToContent(this._rightNum1);
         this._rightNum2 = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.nextNum2");
         addToContent(this._rightNum2);
         this._currentBg = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.petBg1");
         addToContent(this._currentBg);
         this._nextBg = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.petBg2");
         addToContent(this._nextBg);
         this._currentPet = ComponentFactory.Instance.creat("petsBag.petAdvanceView.currentPet");
         this._currentPet.showTip = false;
         addToContent(this._currentPet);
         this._nextPet = ComponentFactory.Instance.creat("petsBag.petAdvanceView.nextPet");
         this._nextPet.showTip = false;
         addToContent(this._nextPet);
         this._bloodLabel = ComponentFactory.Instance.creatComponentByStylename("petsBag.petAdvanceFrame.propertyItem.bloodLabel");
         addToContent(this._bloodLabel);
         this._attackLabel = ComponentFactory.Instance.creatComponentByStylename("petsBag.petAdvanceFrame.propertyItem.attackLabel");
         addToContent(this._attackLabel);
         this._defenceLabel = ComponentFactory.Instance.creatComponentByStylename("petsBag.petAdvanceFrame.propertyItem.defenceLabel");
         addToContent(this._defenceLabel);
         this._agilityLabel = ComponentFactory.Instance.creatComponentByStylename("petsBag.petAdvanceFrame.propertyItem.agilityLabel");
         addToContent(this._agilityLabel);
         this._luckLabel = ComponentFactory.Instance.creatComponentByStylename("petsBag.petAdvanceFrame.propertyItem.luckLabel");
         addToContent(this._luckLabel);
         this._advanceBar = ComponentFactory.Instance.creat("petsBag.petAdvanceView.advanceBar");
         addToContent(this._advanceBar);
         this._vBox = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.vbox");
         addToContent(this._vBox);
         this._propertyList = new Vector.<PetAdvancePropertyItem>();
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            _loc2_ = new PetAdvancePropertyItem(_loc1_);
            this._vBox.addChild(_loc2_);
            this._propertyList.push(_loc2_);
            _loc1_++;
         }
         this._advanceBlessLabel = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.advanceBlessLabel");
         this._advanceBlessLabel.text = LanguageMgr.GetTranslation("petsBag.view.petAdvanceFrame.blessLabel");
         addToContent(this._advanceBlessLabel);
         this._blessBar = ComponentFactory.Instance.creat("petsBag.petAdvanceView.blessBar");
         this._blessBar.maxValue = 100;
         addToContent(this._blessBar);
         this._advanceBlessTipTxt = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.advanceBlessTipTxt");
         this._advanceBlessTipTxt.text = LanguageMgr.GetTranslation("petsBag.view.petAdvanceFrame.blessTipLabel");
         addToContent(this._advanceBlessTipTxt);
         this._advanceNeedLabel = ComponentFactory.Instance.creatBitmap("asset.advanceNeed.label");
         addToContent(this._advanceNeedLabel);
         this._advanceNeedTxt = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.advanceNeedTxt");
         addToContent(this._advanceNeedTxt);
         this._advanceCountBg = ComponentFactory.Instance.creatBitmap("asset.advanceNum.bg");
         addToContent(this._advanceCountBg);
         this._stoneCountTxt = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.stoneCountTxt");
         addToContent(this._stoneCountTxt);
         this._advanceBtn = ComponentFactory.Instance.creat("petsBag.view.infoFrame.advanceBtn");
         addToContent(this._advanceBtn);
         PositionUtils.setPos(this._advanceBtn,"petsBag.view.infoFrame.advanceBtn.Pos");
      }
      
      protected function initEvent() : void
      {
         this._advanceBtn.addEventListener(MouseEvent.CLICK,this.__btnClick);
         PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this.__bagUpdate);
      }
      
      protected function removeEvent() : void
      {
         this._advanceBtn.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE,this.__bagUpdate);
         if(this._advanceShine)
         {
            this._advanceShine.removeEventListener(Event.COMPLETE,this.__onComplete);
         }
      }
      
      protected function __btnClick(param1:MouseEvent) : void
      {
         var _loc4_:QuickBuyFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:PetAdvanceInfo = PetInfoManager.instance.getAdvanceInfo(_info.OrderNumber + 1);
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:int = PetBagManager.instance().petModel.getAdvanceStoneCount();
         if(_loc3_ < _loc2_.StoneNum)
         {
            _loc4_ = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            _loc4_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            _loc4_.itemID = PetBagManager.instance().petModel.AdvanceStoneTemplateId;
            _loc4_.stoneNumber = _loc2_.StoneNum - _loc3_;
            LayerManager.Instance.addToLayer(_loc4_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         else if(_loc2_.Grade > _info.Level)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("petsBag.view.petAdvanceFrame.advanceFailed"));
         }
         else
         {
            SocketManager.Instance.out.sendPetAdvance(_info.Place);
         }
      }
      
      protected function __bagUpdate(param1:Event) : void
      {
         var _loc2_:PetAdvanceInfo = PetInfoManager.instance.getAdvanceInfo(_info.OrderNumber + 1);
         this.updateNeedCondition(_loc2_);
      }
      
      override public function set info(param1:PetInfo) : void
      {
         var _loc2_:PetAdvanceInfo = null;
         var _loc3_:PetInfo = null;
         _info = param1;
         if(_info && _info.MagicLevel > 0)
         {
            this.setAdvanceFont(_info.OrderNumber);
            this._advanceBar.type = _info.OrderNumber < 10 ? int(0) : int(1);
            this._advanceBar.level = _info.OrderNumber;
            this._blessBar.value = _info.Bless;
            _loc2_ = PetInfoManager.instance.getAdvanceInfo(_info.OrderNumber + 1);
            this.updateNeedCondition(_loc2_);
            if(_loc2_)
            {
               this.setProperty(_info,true);
               this._advanceBtn.enable = true;
            }
            else
            {
               this.setProperty(_info,false);
               this._advanceBtn.enable = false;
            }
            this._currentPet.info = _info;
            _loc3_ = PetInfoManager.instance.getPetInfoByTemplateID(_info.TemplateID);
            _loc3_.OrderNumber = _info.OrderNumber >= 60 ? int(60) : int(int(_info.OrderNumber / 10 + 1) * 10);
            this._nextPet.info = _loc3_;
            this.checkAdvanceShine();
            this.checkBless();
         }
         else
         {
            dispatchEvent(new FrameEvent(FrameEvent.CLOSE_CLICK));
         }
         this._lastInfo = _info;
      }
      
      override public function reset() : void
      {
         this._lastInfo = null;
      }
      
      private function updateNeedCondition(param1:PetAdvanceInfo) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         if(param1)
         {
            _loc2_ = PetBagManager.instance().petModel.getAdvanceStoneCount() < param1.StoneNum;
            _loc3_ = param1.Grade > _info.Level;
            this._advanceNeedTxt.htmlText = LanguageMgr.GetTranslation("petsBag.view.petAdvanceFrame.advanceNeedTxt",!!_loc2_ ? "#00b4ff" : "#00b4ff",param1.StoneNum,!!_loc3_ ? "#00b4ff" : "#00b4ff",param1.Grade);
            this.setProperty(_info,true);
         }
         else
         {
            this._advanceNeedTxt.htmlText = LanguageMgr.GetTranslation("petsBag.view.petAdvanceFrame.advanceNeedTxtMax");
            this.setProperty(_info,false);
         }
         this._stoneCountTxt.text = String(PetBagManager.instance().petModel.getAdvanceStoneCount());
      }
      
      private function checkAdvanceShine() : void
      {
         if(this._lastInfo && _info.OrderNumber - this._lastInfo.OrderNumber >= 1)
         {
            if(!this._advanceShine)
            {
               this._advanceShine = ComponentFactory.Instance.creat("petsBag.petAdvanceView.advanceShine");
               this._advanceShine.addEventListener(Event.COMPLETE,this.__onComplete);
            }
            this._advanceShine.gotoAndPlay(1);
            addToContent(this._advanceShine);
         }
      }
      
      private function checkBless() : void
      {
         if(this._lastInfo && _info.Bless - this._lastInfo.Bless >= 1)
         {
            this._blessBar.shine();
         }
      }
      
      protected function __onComplete(param1:Event) : void
      {
         this._advanceShine.stop();
         if(this._advanceShine.parent)
         {
            this._advanceShine.parent.removeChild(this._advanceShine);
         }
      }
      
      private function setAdvanceFont(param1:int) : void
      {
         this._leftNum1.setFrame(param1 / 10 + 1);
         this._leftNum2.setFrame(param1 % 10 + 1);
         this._currentBg.setFrame(param1 / 10);
         var _loc2_:int = param1 >= 60 ? int(6) : int(param1 / 10 + 1);
         this._rightNum1.setFrame(_loc2_ + 1);
         this._rightNum2.setFrame(1);
         this._nextBg.setFrame(_loc2_);
      }
      
      private function setProperty(param1:PetInfo, param2:Boolean) : void
      {
         this._propertyList[0].value = param1.Blood / 100;
         this._propertyList[1].value = param1.Attack / 100;
         this._propertyList[2].value = param1.Defence / 100;
         this._propertyList[3].value = param1.Agility / 100;
         this._propertyList[4].value = param1.Luck / 100;
         if(param2)
         {
            this._propertyList[0].addValue = param1.VBloodGrow / 100 * PetBagManager.instance().petModel.getAddLife(param1.OrderNumber);
            this._propertyList[1].addValue = param1.VAttackGrow / 100 * PetBagManager.instance().petModel.getAddProperty(param1.OrderNumber);
            this._propertyList[2].addValue = param1.VDefenceGrow / 100 * PetBagManager.instance().petModel.getAddProperty(param1.OrderNumber);
            this._propertyList[3].addValue = param1.VAgilityGrow / 100 * PetBagManager.instance().petModel.getAddProperty(param1.OrderNumber);
            this._propertyList[4].addValue = param1.VLuckGrow / 100 * PetBagManager.instance().petModel.getAddProperty(param1.OrderNumber);
         }
         else
         {
            this._propertyList[0].addValue = this._propertyList[1].addValue = this._propertyList[2].addValue = this._propertyList[3].addValue = this._propertyList[4].addValue = 0;
         }
      }
      
      private function getFormatNum(param1:int) : int
      {
         if(param1 == 0)
         {
            return 10;
         }
         return param1;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         if(this._titleBmp)
         {
            ObjectUtils.disposeObject(this._titleBmp);
         }
         this._titleBmp = null;
         ObjectUtils.disposeObject(this._bg2);
         this._bg2 = null;
         ObjectUtils.disposeObject(this._btnBg);
         this._btnBg = null;
         ObjectUtils.disposeObject(this._leftLabel);
         this._leftLabel = null;
         ObjectUtils.disposeObject(this._rightLabel);
         this._rightLabel = null;
         ObjectUtils.disposeObject(this._leftNum1);
         this._leftNum1 = null;
         ObjectUtils.disposeObject(this._leftNum2);
         this._leftNum2 = null;
         ObjectUtils.disposeObject(this._rightNum1);
         this._rightNum1 = null;
         ObjectUtils.disposeObject(this._rightNum2);
         this._rightNum2 = null;
         ObjectUtils.disposeObject(this._currentBg);
         this._currentBg = null;
         ObjectUtils.disposeObject(this._nextBg);
         this._nextBg = null;
         ObjectUtils.disposeObject(this._currentPet);
         this._currentPet = null;
         ObjectUtils.disposeObject(this._nextPet);
         this._nextPet = null;
         ObjectUtils.disposeObject(this._advanceBar);
         this._advanceBar = null;
         while(this._propertyList.length > 0)
         {
            this._propertyList.shift().dispose();
         }
         this._propertyList = null;
         ObjectUtils.disposeObject(this._vBox);
         this._vBox = null;
         ObjectUtils.disposeObject(this._bloodLabel);
         this._bloodLabel = null;
         ObjectUtils.disposeObject(this._attackLabel);
         this._attackLabel = null;
         ObjectUtils.disposeObject(this._defenceLabel);
         this._defenceLabel = null;
         ObjectUtils.disposeObject(this._agilityLabel);
         this._agilityLabel = null;
         ObjectUtils.disposeObject(this._luckLabel);
         this._luckLabel = null;
         ObjectUtils.disposeObject(this._advanceBlessLabel);
         this._advanceBlessLabel = null;
         ObjectUtils.disposeObject(this._blessBar);
         this._blessBar = null;
         ObjectUtils.disposeObject(this._advanceBlessTipTxt);
         this._advanceBlessTipTxt = null;
         ObjectUtils.disposeObject(this._advanceNeedTxt);
         this._advanceNeedTxt = null;
         ObjectUtils.disposeObject(this._stoneCountTxt);
         this._stoneCountTxt = null;
         ObjectUtils.disposeObject(this._advanceBtn);
         this._advanceBtn = null;
         ObjectUtils.disposeObject(this._advanceShine);
         this._advanceShine = null;
         ObjectUtils.disposeObject(this._advanceNeedLabel);
         this._advanceNeedLabel = null;
         ObjectUtils.disposeObject(this._advanceCountBg);
         this._advanceCountBg = null;
      }
   }
}
