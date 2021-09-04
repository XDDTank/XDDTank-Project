package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.FilterFrameTextWithTips;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortiaLevelInfo;
   import consortion.event.ConsortionEvent;
   import ddt.data.ConsortiaDutyType;
   import ddt.data.ConsortiaInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ConsortiaDutyManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import road7th.utils.StringHelper;
   
   public class SelfConsortionHallLeftView extends Component implements Disposeable
   {
      
      public static const dataFormat:String = "YYYY-MM-DD";
       
      
      private var _bg:Bitmap;
      
      private var _bgI:Bitmap;
      
      private var _bulletinBg:Bitmap;
      
      private var _consortiaInfo:ConsortiaInfo;
      
      private var _consortionName:FilterFrameText;
      
      private var _level:ScaleFrameImage;
      
      private var _repute:FilterFrameText;
      
      private var _riches:FilterFrameText;
      
      private var _weekPay:FilterFrameTextWithTips;
      
      private var _placard:TextArea;
      
      private var _placardBtn:TextButton;
      
      private var _placardEditBtn:TextButton;
      
      private var _placardCancelBtn:TextButton;
      
      private var _inputMaxChars:FilterFrameText;
      
      private var _lastPlacard:String;
      
      private var _levelProgress:SelfConsortionInfoLevelProgress;
      
      private var _count:FilterFrameTextWithTips;
      
      public function SelfConsortionHallLeftView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.conortionHall.leftBg");
         this._bgI = ComponentFactory.Instance.creatBitmap("asset.conortionHall.leftBgI");
         this._bulletinBg = ComponentFactory.Instance.creatBitmap("asset.conortionAnnouncement.bg");
         this._consortionName = ComponentFactory.Instance.creatComponentByStylename("consortion.nameInputText");
         this._level = ComponentFactory.Instance.creatComponentByStylename("consortion.level");
         this._repute = ComponentFactory.Instance.creatComponentByStylename("consortion.repute");
         this._count = ComponentFactory.Instance.creatComponentByStylename("consortion.countTip");
         this._count.selectable = false;
         this._riches = ComponentFactory.Instance.creatComponentByStylename("consortion.riches");
         if(PlayerManager.Instance.Self.consortiaInfo.Riches < ConsortionModelControl.Instance.model.getLevelData(PlayerManager.Instance.Self.consortiaInfo.Level).Deduct)
         {
            this._weekPay = ComponentFactory.Instance.creatComponentByStylename("consortion.weekPayI");
         }
         else
         {
            this._weekPay = ComponentFactory.Instance.creatComponentByStylename("consortion.weekPay");
         }
         this._weekPay.mouseEnabled = true;
         this._weekPay.selectable = false;
         this._placard = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.placardText");
         this._placard.editable = false;
         this._placard.mouseChildren = false;
         this._placardBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.placardBtn");
         this._placardBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.modifyBtn");
         this._placardCancelBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.placardBtn");
         this._placardCancelBtn.text = LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText");
         this._placardCancelBtn.visible = false;
         this._placardEditBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.placardeditBtn");
         this._placardEditBtn.text = LanguageMgr.GetTranslation("consortion.ConsortionTask.publish");
         this._placardEditBtn.visible = false;
         this._inputMaxChars = ComponentFactory.Instance.creatComponentByStylename("consortion.inputMaxCharsTxt");
         this._inputMaxChars.visible = false;
         this._levelProgress = ComponentFactory.Instance.creat("SelfConsortionInfoLevelProgress");
         this._levelProgress.tipStyle = "ddt.view.tips.OneLineTip";
         this._levelProgress.tipDirctions = "3,7,6";
         this._levelProgress.tipGapV = 4;
         addChild(this._bg);
         addChild(this._bgI);
         addChild(this._bulletinBg);
         addChild(this._consortionName);
         addChild(this._level);
         addChild(this._repute);
         addChild(this._riches);
         addChild(this._weekPay);
         addChild(this._placard);
         addChild(this._placardBtn);
         addChild(this._placardCancelBtn);
         addChild(this._placardEditBtn);
         addChild(this._inputMaxChars);
         addChild(this._levelProgress);
         addChild(this._count);
         this.consortionInfo = PlayerManager.Instance.Self.consortiaInfo;
         this.upPlacard();
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this._consortiaInfoChange);
         PlayerManager.Instance.Self.consortiaInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__consortiaInfoPropChange);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.LEVEL_UP_RULE_CHANGE,this._levelUpRuleChange);
         this._placardBtn.addEventListener(MouseEvent.CLICK,this.__mouseClickHandler);
         this._placard.textField.addEventListener(Event.CHANGE,this.__inputHandler);
         this._placardCancelBtn.addEventListener(MouseEvent.CLICK,this.__cancelHandler);
         this._placardEditBtn.addEventListener(MouseEvent.CLICK,this.__edit);
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this._consortiaInfoChange);
         if(PlayerManager.Instance.Self.consortiaInfo)
         {
            PlayerManager.Instance.Self.consortiaInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__consortiaInfoPropChange);
         }
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.LEVEL_UP_RULE_CHANGE,this._levelUpRuleChange);
         if(this._placardBtn)
         {
            this._placardBtn.removeEventListener(MouseEvent.CLICK,this.__mouseClickHandler);
         }
         if(this._placardCancelBtn)
         {
            this._placardCancelBtn.removeEventListener(MouseEvent.CLICK,this.__cancelHandler);
         }
         if(this._placard)
         {
            this._placard.textField.removeEventListener(Event.CHANGE,this.__inputHandler);
         }
         if(this._placardEditBtn)
         {
            this._placardEditBtn.removeEventListener(MouseEvent.CLICK,this.__edit);
         }
      }
      
      private function __mouseClickHandler(param1:MouseEvent) : void
      {
         this._placard.editable = true;
         this._placard.mouseChildren = true;
         this._placardBtn.visible = false;
         this._placardEditBtn.visible = true;
         this._placardCancelBtn.visible = true;
         this._inputMaxChars.visible = true;
         this._inputMaxChars.text = LanguageMgr.GetTranslation("ddtcosrtion.inputMacChars",this._placard.textField.length);
      }
      
      private function __edit(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTF(StringHelper.trim(this._placard.textField.text));
         if(this._placard.textField.length > 50)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaAfficheFrame.long"));
            return;
         }
         if(FilterWordManager.isGotForbiddenWords(this._placard.textField.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaAfficheFrame"));
            return;
         }
         var _loc3_:String = FilterWordManager.filterWrod(this._placard.textField.text);
         _loc3_ = StringHelper.trim(_loc3_);
         SocketManager.Instance.out.sendConsortiaUpdatePlacard(_loc3_);
         this._placardBtn.visible = true;
         this._placardEditBtn.visible = false;
         this._placard.editable = false;
         this._placardCancelBtn.visible = false;
         this._placard.mouseChildren = false;
      }
      
      private function __cancelHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:String = PlayerManager.Instance.Self.consortiaInfo.Placard;
         this._placard.text = _loc2_ == "" ? LanguageMgr.GetTranslation("tank.consortia.myconsortia.systemWord") : _loc2_;
         this._placardBtn.visible = true;
         this._placardEditBtn.visible = false;
         this._placardCancelBtn.visible = false;
         this._inputMaxChars.visible = false;
         this._placard.mouseChildren = false;
      }
      
      private function __inputHandler(param1:Event) : void
      {
         if(this._placard.textField.textHeight > 80)
         {
            param1.stopImmediatePropagation();
            this._placard.text = this._lastPlacard;
            return;
         }
         this._lastPlacard = this._placard.text;
         this._inputMaxChars.text = LanguageMgr.GetTranslation("ddtcosrtion.inputMacChars",this._placard.textField.length);
      }
      
      private function upPlacard() : void
      {
         var _loc1_:String = PlayerManager.Instance.Self.consortiaInfo.Placard;
         this._placard.text = _loc1_ == "" ? LanguageMgr.GetTranslation("tank.consortia.myconsortia.systemWord") : _loc1_;
         this._lastPlacard = this._placard.text;
         this._placardBtn.visible = ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right,ConsortiaDutyType._4_Notice);
      }
      
      private function _levelUpRuleChange(param1:ConsortionEvent) : void
      {
         this.setWeekyPay();
      }
      
      private function setWeekyPay() : void
      {
         if(this._consortiaInfo && this._consortiaInfo.Level != 0 && ConsortionModelControl.Instance.model.levelUpData != null)
         {
            this._weekPay.text = String(ConsortionModelControl.Instance.model.getLevelData(this._consortiaInfo.Level).Deduct);
            if(this._weekPay.text != "")
            {
               this._weekPay.mouseEnabled = true;
            }
            else
            {
               this._weekPay.mouseEnabled = false;
            }
            this._weekPay.tipData = StringHelper.parseTime(this._consortiaInfo.DeductDate,1);
         }
      }
      
      private function _consortiaInfoChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["consortiaInfo"] || param1.changedProperties["experience"] || param1.changedProperties["count"])
         {
            this.consortionInfo = PlayerManager.Instance.Self.consortiaInfo;
         }
         if(param1.changedProperties["riches"])
         {
            this._riches.text = String(PlayerManager.Instance.Self.consortiaInfo.Riches);
         }
         if(param1.changedProperties["Right"])
         {
            this.upPlacard();
         }
      }
      
      private function __consortiaInfoPropChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties[ConsortiaInfo.PLACARD] || param1.changedProperties[ConsortiaInfo.IS_VOTING])
         {
            this.upPlacard();
         }
         this.consortionInfo = PlayerManager.Instance.Self.consortiaInfo;
      }
      
      private function set consortionInfo(param1:ConsortiaInfo) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:ConsortiaLevelInfo = null;
         if(param1 == null)
         {
            return;
         }
         this._consortiaInfo = param1;
         var _loc2_:ConsortiaLevelInfo = ConsortionModelControl.Instance.model.getLevelData(this._consortiaInfo.Level == 10 ? int(this._consortiaInfo.Level) : int(this._consortiaInfo.Level + 1));
         this._consortionName.text = this._consortiaInfo.ConsortiaName;
         this._level.setFrame(param1.Level);
         if(param1.Level == 10)
         {
            this._level.x = 140;
         }
         this._repute.text = LanguageMgr.GetTranslation("ddtcosrtion.requet",param1.Repute);
         this._riches.text = String(param1.Riches);
         if(param1.Level != 0)
         {
            this._count.text = String(param1.Count) + "/" + String(ConsortionModelControl.Instance.model.getLevelData(param1.Level).Count);
            this._count.mouseEnabled = true;
            this._count.tipData = param1;
         }
         this.setWeekyPay();
         if(this._consortiaInfo.Level <= 1)
         {
            _loc3_ = this._consortiaInfo.Experience;
            _loc4_ = _loc2_.Experience;
         }
         else
         {
            _loc5_ = ConsortionModelControl.Instance.model.getLevelData(param1.Level);
            _loc3_ = this._consortiaInfo.Experience - _loc5_.Experience;
            _loc4_ = _loc2_.Experience - _loc5_.Experience;
         }
         if(param1.Level >= 10)
         {
            this._levelProgress.setProgress(0,100);
            this._levelProgress.tipData = LanguageMgr.GetTranslation("ddt.consortion.upgradeHallTip");
         }
         else
         {
            this._levelProgress.setProgress(Number(_loc3_),Number(_loc4_));
            this._levelProgress.tipData = Number(_loc3_) + "/" + Number(_loc4_);
         }
      }
      
      private function getExperience() : int
      {
         var _loc4_:ConsortiaLevelInfo = null;
         var _loc1_:int = this._consortiaInfo.Level + 1;
         var _loc2_:int = 0;
         var _loc3_:int = 1;
         while(_loc3_ < _loc1_)
         {
            _loc4_ = ConsortionModelControl.Instance.model.getLevelData(_loc3_);
            _loc2_ += _loc4_.Experience;
            _loc3_++;
         }
         return _loc2_;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._bgI)
         {
            ObjectUtils.disposeObject(this._bgI);
         }
         this._bgI = null;
         if(this._bulletinBg)
         {
            ObjectUtils.disposeObject(this._bulletinBg);
         }
         this._bulletinBg = null;
         if(this._consortionName)
         {
            ObjectUtils.disposeObject(this._consortionName);
         }
         this._consortionName = null;
         if(this._level)
         {
            ObjectUtils.disposeObject(this._level);
         }
         this._level = null;
         if(this._repute)
         {
            ObjectUtils.disposeObject(this._repute);
         }
         this._repute = null;
         if(this._riches)
         {
            ObjectUtils.disposeObject(this._riches);
         }
         this._riches = null;
         if(this._weekPay)
         {
            ObjectUtils.disposeObject(this._weekPay);
         }
         this._weekPay = null;
         if(this._placard)
         {
            ObjectUtils.disposeObject(this._placard);
         }
         if(this._levelProgress)
         {
            ObjectUtils.disposeObject(this._levelProgress);
         }
         this._levelProgress = null;
         this._placard = null;
         if(this._placardBtn)
         {
            ObjectUtils.disposeObject(this._placardBtn);
         }
         this._placardBtn = null;
         if(this._placardCancelBtn)
         {
            ObjectUtils.disposeObject(this._placardCancelBtn);
         }
         this._placardCancelBtn = null;
         if(this._inputMaxChars)
         {
            ObjectUtils.disposeObject(this._inputMaxChars);
         }
         this._inputMaxChars = null;
         if(this._count)
         {
            ObjectUtils.disposeObject(this._count);
         }
         this._count = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
