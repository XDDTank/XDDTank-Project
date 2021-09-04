package vip.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.VipConfigInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.VipPrivilegeConfigManager;
   import ddt.view.PlayerPortraitView;
   import ddt.view.common.VipLevelIcon;
   import ddt.view.tips.OneLineTip;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import vip.VipController;
   
   public class VipFrameHead extends Sprite implements Disposeable
   {
       
      
      private var _topBG:Bitmap;
      
      private var _nameBg:Bitmap;
      
      private var _selfName:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _vipIcon:VipLevelIcon;
      
      private var _vipLevelProgress:VipLevelProgress;
      
      private var _vipRuleDescriptionBtn:TextButton;
      
      private var _selfLevel:FilterFrameText;
      
      private var _nextLevel:FilterFrameText;
      
      private var _dueDataWord:FilterFrameText;
      
      private var _dueData:FilterFrameText;
      
      private var _DueTipSprite:Sprite;
      
      private var _DueTip:OneLineTip;
      
      private var _portrait:PlayerPortraitView;
      
      private var _isVipRechargeShow:Boolean = false;
      
      private var _descriptionFrame:Frame;
      
      private var _frameBg:Scale9CornerImage;
      
      private var _okBtn:TextButton;
      
      private var _contenttxt:MovieImage;
      
      public function VipFrameHead(param1:Boolean = false)
      {
         super();
         this._isVipRechargeShow = param1;
         this.init();
      }
      
      private function init() : void
      {
         if(this._isVipRechargeShow)
         {
            this._topBG = ComponentFactory.Instance.creatBitmap("vipRecharge.topBG");
         }
         else
         {
            this._topBG = ComponentFactory.Instance.creatBitmap("VIPFrame.topBG");
         }
         this._nameBg = ComponentFactory.Instance.creatBitmap("asset.ddtvipView.nameBg");
         this._selfName = ComponentFactory.Instance.creat("VipStatusView.name");
         this._vipIcon = ComponentFactory.Instance.creatCustomObject("VipStatusView.vipIcon");
         this._vipLevelProgress = ComponentFactory.Instance.creat("VIPFrame.vipLevelProgress");
         if(!this._isVipRechargeShow)
         {
            this._dueDataWord = ComponentFactory.Instance.creatComponentByStylename("VipStatusView.dueDateFontTxt");
            this._dueDataWord.text = LanguageMgr.GetTranslation("ddt.vip.dueDateFontTxt");
            this._dueData = ComponentFactory.Instance.creat("VipStatusView.dueDate");
            this._vipRuleDescriptionBtn = ComponentFactory.Instance.creatComponentByStylename("vipHead.RuleDescriptionBtn");
            this._vipRuleDescriptionBtn.text = LanguageMgr.GetTranslation("ddt.vip.vipFrameHead.VipPrivilegeTxt");
         }
         this._selfLevel = ComponentFactory.Instance.creat("VipStatusView.selfLevel");
         this._nextLevel = ComponentFactory.Instance.creat("VipStatusView.nextLevel");
         this._portrait = ComponentFactory.Instance.creatCustomObject("vip.PortraitView",["right",0,ComponentFactory.Instance.creatBitmap("asset.ddtvip.playerIcon")]);
         this._portrait.info = PlayerManager.Instance.Self;
         addChild(this._topBG);
         addChild(this._nameBg);
         addChild(this._portrait);
         addChild(this._vipLevelProgress);
         if(!this._isVipRechargeShow)
         {
            addChild(this._vipRuleDescriptionBtn);
            addChild(this._dueDataWord);
            addChild(this._dueData);
         }
         addChild(this._selfLevel);
         addChild(this._nextLevel);
         this.addTipSprite();
         this.upView();
         this.addEvent();
      }
      
      private function addTipSprite() : void
      {
         var _loc1_:Point = null;
         this._DueTipSprite = new Sprite();
         this._DueTipSprite.graphics.beginFill(0,0);
         this._DueTipSprite.graphics.drawRect(0,0,this._vipLevelProgress.width,this._vipLevelProgress.height);
         this._DueTipSprite.graphics.endFill();
         _loc1_ = ComponentFactory.Instance.creatCustomObject("Vip.DueTipSpritePos");
         this._DueTipSprite.x = _loc1_.x;
         this._DueTipSprite.y = _loc1_.y;
         addChild(this._DueTipSprite);
         this._DueTip = new OneLineTip();
         addChild(this._DueTip);
         this._DueTip.x = this._DueTipSprite.x;
         this._DueTip.y = this._DueTipSprite.y + 25;
         this._DueTip.visible = false;
      }
      
      private function addEvent() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         if(this._vipRuleDescriptionBtn)
         {
            this._vipRuleDescriptionBtn.addEventListener(MouseEvent.CLICK,this.__helpHandler);
         }
         this._DueTipSprite.addEventListener(MouseEvent.MOUSE_OVER,this.__showDueTip);
         this._DueTipSprite.addEventListener(MouseEvent.MOUSE_OUT,this.__hideDueTip);
      }
      
      private function __helpHandler(param1:MouseEvent) : void
      {
         this._descriptionFrame = ComponentFactory.Instance.creatComponentByStylename("vip.VipPrivilegeFrame");
         LayerManager.Instance.addToLayer(this._descriptionFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function __helpFrameRespose(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.disposeHelpFrame();
         }
      }
      
      private function __closeHelpFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function disposeHelpFrame() : void
      {
         this._okBtn.removeEventListener(MouseEvent.CLICK,this.__closeHelpFrame);
         this._descriptionFrame.dispose();
         this._okBtn = null;
         this._contenttxt = null;
         this._descriptionFrame = null;
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         if(this._DueTipSprite)
         {
            this._DueTipSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.__showDueTip);
            this._DueTipSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.__hideDueTip);
         }
      }
      
      private function __showDueTip(param1:MouseEvent) : void
      {
         this._DueTip.visible = true;
      }
      
      private function __hideDueTip(param1:MouseEvent) : void
      {
         this._DueTip.visible = false;
      }
      
      private function __propertyChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["isVip"] || param1.changedProperties["VipExpireDay"] || param1.changedProperties["VIPNextLevelDaysNeeded"])
         {
            this.upView();
         }
      }
      
      private function upView() : void
      {
         var _loc5_:int = 0;
         var _loc6_:Date = null;
         var _loc7_:int = 0;
         var _loc1_:VipConfigInfo = VipPrivilegeConfigManager.Instance.getById(0);
         if(PlayerManager.Instance.Self.VIPLevel != 10 && PlayerManager.Instance.Self.IsVIP)
         {
            _loc5_ = _loc1_["Level" + (PlayerManager.Instance.Self.VIPLevel + 1).toString()] - PlayerManager.Instance.Self.VIPExp;
            this._DueTip.tipData = LanguageMgr.GetTranslation("ddt.vip.dueTime.tip",_loc5_,PlayerManager.Instance.Self.VIPLevel + 1);
         }
         else if(!PlayerManager.Instance.Self.IsVIP)
         {
            this._DueTip.tipData = LanguageMgr.GetTranslation("ddt.vip.vipIcon.reduceVipExp");
         }
         else
         {
            this._DueTip.tipData = LanguageMgr.GetTranslation("ddt.vip.vipIcon.upGradFull");
         }
         if(!PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.VIPLevel == 0)
         {
            this._DueTip.tipData = LanguageMgr.GetTranslation("ddt.vip.vipFrame.youarenovip");
         }
         this._selfName.text = PlayerManager.Instance.Self.NickName;
         if(this._selfName.text.length > 7)
         {
            this._selfName.text = this._selfName.text.substr(0,4) + "...";
         }
         if(PlayerManager.Instance.Self.IsVIP)
         {
            if(this._vipName)
            {
               ObjectUtils.disposeObject(this._vipName);
            }
            this._vipName = VipController.instance.getVipNameTxt(263,PlayerManager.Instance.Self.VIPtype);
            this._vipName.textSize = 18;
            this._vipName.x = this._selfName.x;
            this._vipName.y = this._selfName.y;
            this._vipName.text = this._selfName.text;
            addChild(this._vipName);
            DisplayUtils.removeDisplay(this._selfName);
         }
         else
         {
            addChild(this._selfName);
            DisplayUtils.removeDisplay(this._vipName);
         }
         this._vipIcon.setInfo(PlayerManager.Instance.Self,true,true);
         if(PlayerManager.Instance.Self.IsVIP)
         {
            this._vipIcon.x = this._vipName.x + this._vipName.textWidth + 45;
         }
         else
         {
            this._vipIcon.x = this._selfName.x + this._selfName.textWidth + 45;
         }
         addChild(this._vipIcon);
         this._selfLevel.text = "LV:" + PlayerManager.Instance.Self.VIPLevel;
         this._nextLevel.text = "LV:" + (PlayerManager.Instance.Self.VIPLevel + 1);
         if(!this._isVipRechargeShow)
         {
            _loc6_ = PlayerManager.Instance.Self.VIPExpireDay as Date;
            this._dueData.text = _loc6_.fullYear + "-" + (_loc6_.month + 1) + "-" + _loc6_.date;
         }
         if(!PlayerManager.Instance.Self.IsVIP && !this._isVipRechargeShow)
         {
            this._dueData.text = "";
         }
         if(PlayerManager.Instance.Self.VIPLevel == 10)
         {
            this._nextLevel.text = "";
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = PlayerManager.Instance.Self.VIPLevel;
         if(PlayerManager.Instance.Self.VIPLevel == 10)
         {
            _loc7_ = 0;
            this._vipLevelProgress.setProgress(1,1);
            this._vipLevelProgress.labelText = _loc7_ + "/" + _loc7_;
         }
         else
         {
            _loc2_ = PlayerManager.Instance.Self.VIPExp;
            _loc3_ = _loc1_["Level" + (PlayerManager.Instance.Self.VIPLevel + 1).toString()];
            this._vipLevelProgress.setProgress(_loc2_,_loc3_);
            this._vipLevelProgress.labelText = _loc2_ + "/" + _loc3_;
         }
         this.grayOrLightVIP();
      }
      
      private function grayOrLightVIP() : void
      {
         if(!PlayerManager.Instance.Self.IsVIP)
         {
            this._vipIcon.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._vipLevelProgress.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else
         {
            this._vipIcon.filters = null;
            this._vipLevelProgress.filters = null;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._topBG)
         {
            ObjectUtils.disposeObject(this._topBG);
         }
         this._topBG = null;
         if(this._nameBg)
         {
            ObjectUtils.disposeObject(this._nameBg);
         }
         this._nameBg = null;
         if(this._vipIcon)
         {
            ObjectUtils.disposeObject(this._vipIcon);
         }
         this._vipIcon = null;
         if(this._vipLevelProgress)
         {
            ObjectUtils.disposeObject(this._vipLevelProgress);
         }
         this._vipLevelProgress = null;
         if(this._selfLevel)
         {
            ObjectUtils.disposeObject(this._selfLevel);
         }
         this._selfLevel = null;
         if(this._nextLevel)
         {
            ObjectUtils.disposeObject(this._nextLevel);
         }
         this._nextLevel = null;
         if(this._vipName)
         {
            ObjectUtils.disposeObject(this._vipName);
         }
         this._vipName = null;
         if(this._DueTipSprite)
         {
            ObjectUtils.disposeObject(this._DueTipSprite);
         }
         this._DueTipSprite = null;
         if(this._DueTip)
         {
            ObjectUtils.disposeObject(this._DueTip);
         }
         this._DueTip = null;
         if(this._dueDataWord)
         {
            ObjectUtils.disposeObject(this._dueDataWord);
         }
         this._dueDataWord = null;
         if(this._dueData)
         {
            ObjectUtils.disposeObject(this._dueData);
         }
         this._dueData = null;
         if(this._vipRuleDescriptionBtn)
         {
            this._vipRuleDescriptionBtn.dispose();
         }
         this._vipRuleDescriptionBtn = null;
         if(parent)
         {
            this.parent.removeChild(this);
         }
         ObjectUtils.disposeObject(this._portrait);
      }
   }
}
