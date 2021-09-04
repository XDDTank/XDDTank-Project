package vip.view
{
   import baglocked.BaglockedManager;
   import com.greensock.TweenMax;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.BossBoxManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.bossbox.AwardsView;
   import ddt.view.bossbox.AwardsViewII;
   import ddt.view.bossbox.VipInfoTipBox;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import platformapi.tencent.DiamondManager;
   import road7th.data.DictionaryData;
   import vip.VipController;
   
   public class GiveYourselfOpenView extends Sprite implements Disposeable
   {
      
      public static const VIP_LEVEL1:String = "112112";
      
      public static const VIP_LEVEL2:String = "112113";
      
      public static const VIP_LEVEL3:String = "112114";
      
      public static const VIP_LEVEL4:String = "112115";
      
      public static const VIP_LEVEL5:String = "112116";
      
      public static const VIP_LEVEL6:String = "112117";
      
      public static const VIP_LEVEL7:String = "112118";
      
      public static const VIP_LEVEL8:String = "112119";
      
      public static const VIP_LEVEL9:String = "112120";
      
      public static const VIP_LEVEL10:String = "112204";
      
      public static const VIP_LEVEL11:String = "112205";
      
      public static const VIP_LEVEL12:String = "112206";
      
      public static var _vipChestsArr:Array = [VIP_LEVEL1,VIP_LEVEL2,VIP_LEVEL3,VIP_LEVEL4,VIP_LEVEL5,VIP_LEVEL6,VIP_LEVEL7,VIP_LEVEL8,VIP_LEVEL9,VIP_LEVEL10,VIP_LEVEL11,VIP_LEVEL12];
      
      public static var millisecondsPerDay:int = 1000 * 60 * 60 * 24;
       
      
      private var _BG:Bitmap;
      
      protected var _showPayMoneyBG:Image;
      
      protected var _openVipBtn:BaseButton;
      
      protected var _renewalVipBtn:BaseButton;
      
      protected var _rewardBtn:BaseButton;
      
      private var _rewardEffet:IEffect;
      
      protected var _rewardShin:Scale9CornerImage;
      
      protected var _money:FilterFrameText;
      
      protected var _isSelf:Boolean;
      
      private var _halfYearBtn:SelectedButton;
      
      private var _threeMonthBtn:SelectedButton;
      
      private var _oneMonthBtn:SelectedButton;
      
      protected var _vipPrivilegeTxt:VipPrivilegeTxt;
      
      protected var _spreeView:VipSpreeView;
      
      private var _openVipTimeBtnGroup:SelectedButtonGroup;
      
      private var _selectedBtnImage:Image;
      
      private var _discountIcon:Image;
      
      private var _btnBg:Scale9CornerImage;
      
      protected var _itemScroll:ScrollPanel;
      
      private var awards:AwardsViewII;
      
      private var alertFrame:BaseAlerFrame;
      
      private var _vipInfoTipBox:VipInfoTipBox;
      
      private var _confirmFrame:BaseAlerFrame;
      
      private var _moneyConfirm:BaseAlerFrame;
      
      protected var days:int = 0;
      
      protected var payNum:int = 0;
      
      protected var time:String = "";
      
      public function GiveYourselfOpenView()
      {
         super();
         this._init();
      }
      
      private function getOpenMoney(param1:int) : int
      {
         var _loc2_:Array = ServerConfigManager.instance.VIPRenewalPrice.reverse();
         return _loc2_[param1].split("|")[0];
      }
      
      private function _init() : void
      {
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._isSelf = true;
         this.initContent();
         this.addTextAndBtn();
         this.upPayMoneyText();
         this.showOpenOrRenewal();
         this.rewardBtnCanUse();
      }
      
      private function initContent() : void
      {
         this._BG = ComponentFactory.Instance.creatBitmap("GiveYourselfOpenView.BG");
         this._btnBg = ComponentFactory.Instance.creatComponentByStylename("openVipBtnBg");
         addChild(this._btnBg);
         if(DiamondManager.instance.isInTencent)
         {
            this._halfYearBtn = ComponentFactory.Instance.creatComponentByStylename("diamond.ddtvip.halfYearBtn");
            this._threeMonthBtn = ComponentFactory.Instance.creatComponentByStylename("diamond.ddtvip.threeMonthBtn");
            this._oneMonthBtn = ComponentFactory.Instance.creatComponentByStylename("diamond.ddtvip.oneMonthBtn");
         }
         else
         {
            this._halfYearBtn = ComponentFactory.Instance.creatComponentByStylename("ddtvip.halfYearBtn");
            this._threeMonthBtn = ComponentFactory.Instance.creatComponentByStylename("ddtvip.threeMonthBtn");
            this._oneMonthBtn = ComponentFactory.Instance.creatComponentByStylename("ddtvip.oneMonthBtn");
         }
         this._discountIcon = ComponentFactory.Instance.creatComponentByStylename("vip.discountIcon");
         this._vipPrivilegeTxt = ComponentFactory.Instance.creatCustomObject("vip.vipPrivilegeTxt");
         this._spreeView = ComponentFactory.Instance.creatCustomObject("vip.VipSpreeView");
         this._spreeView.setView(6);
         this._itemScroll = ComponentFactory.Instance.creatComponentByStylename("ddtvip.PrivilegeItemList");
         this._itemScroll.setView(this._spreeView);
         this._itemScroll.vScrollProxy = ScrollPanel.ON;
         this._selectedBtnImage = ComponentFactory.Instance.creatComponentByStylename("vip.LevelPrivilegeView.selectedBtnImage");
         addChild(this._BG);
         addChild(this._halfYearBtn);
         addChild(this._threeMonthBtn);
         addChild(this._oneMonthBtn);
         addChild(this._selectedBtnImage);
         addChild(this._itemScroll);
         this._itemScroll.invalidateViewport();
         this._openVipTimeBtnGroup = new SelectedButtonGroup();
         this._openVipTimeBtnGroup.addSelectItem(this._halfYearBtn);
         this._openVipTimeBtnGroup.addSelectItem(this._threeMonthBtn);
         this._openVipTimeBtnGroup.addSelectItem(this._oneMonthBtn);
         this._openVipTimeBtnGroup.selectIndex = 0;
      }
      
      private function addTextAndBtn() : void
      {
         this._money = ComponentFactory.Instance.creat("GiveYourselfOpenView.money");
         this._openVipBtn = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.openVipBtn");
         this._renewalVipBtn = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.renewalVipBtn");
         this._rewardBtn = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.rewardBtn");
         this._rewardShin = ComponentFactory.Instance.creatComponentByStylename("rewardBtn.shin");
         this._rewardEffet = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._rewardBtn);
         addChild(this._openVipBtn);
         addChild(this._renewalVipBtn);
         addChild(this._rewardBtn);
         addChild(this._rewardShin);
         this._rewardShin.mouseEnabled = this._rewardShin.mouseChildren = false;
         this._money.text = PlayerManager.Instance.Self.Money + LanguageMgr.GetTranslation("money");
      }
      
      protected function showOpenOrRenewal() : void
      {
         if(this._isSelf)
         {
            if(PlayerManager.Instance.Self.VIPLevel > 0 && !PlayerManager.Instance.Self.IsVIP)
            {
               this._openVipBtn.visible = false;
               this._renewalVipBtn.visible = true;
            }
            else if(!PlayerManager.Instance.Self.IsVIP)
            {
               this._openVipBtn.visible = true;
               this._renewalVipBtn.visible = false;
            }
            else if(!PlayerManager.Instance.Self.openVipType)
            {
               this._openVipBtn.visible = false;
               this._renewalVipBtn.visible = true;
            }
            else
            {
               this._openVipBtn.visible = true;
               this._renewalVipBtn.visible = false;
            }
         }
         else
         {
            this._openVipBtn.visible = true;
            this._renewalVipBtn.visible = false;
         }
      }
      
      protected function rewardBtnCanUse() : void
      {
         if(this._isSelf && PlayerManager.Instance.Self.IsVIP)
         {
            if(PlayerManager.Instance.Self.canTakeVipReward)
            {
               this._rewardBtn.visible = true;
               this._rewardShin.alpha = 1;
               this._rewardShin.visible = true;
               TweenMax.to(this._rewardShin,0.5,{
                  "alpha":0,
                  "yoyo":true,
                  "repeat":-1
               });
               PositionUtils.setPos(this._openVipBtn,"vip.rewardState.OpenRenewalBtnPos");
               PositionUtils.setPos(this._renewalVipBtn,"vip.rewardState.OpenRenewalBtnPos");
            }
            else
            {
               this._rewardBtn.visible = false;
               this._rewardShin.visible = false;
               TweenMax.killTweensOf(this._rewardShin);
               PositionUtils.setPos(this._openVipBtn,"vip.normalState.OpenRenewalBtnPos");
               PositionUtils.setPos(this._renewalVipBtn,"vip.normalState.OpenRenewalBtnPos");
            }
         }
         else
         {
            this._rewardBtn.visible = false;
            this._rewardShin.visible = false;
            TweenMax.killTweensOf(this._rewardShin);
            PositionUtils.setPos(this._openVipBtn,"vip.normalState.OpenRenewalBtnPos");
            PositionUtils.setPos(this._renewalVipBtn,"vip.normalState.OpenRenewalBtnPos");
         }
      }
      
      private function initEvent() : void
      {
         this._openVipBtn.addEventListener(MouseEvent.CLICK,this.__openVip);
         this._renewalVipBtn.addEventListener(MouseEvent.CLICK,this.__openVip);
         this._openVipTimeBtnGroup.addEventListener(Event.CHANGE,this.__upPayNum);
         this._rewardBtn.addEventListener(MouseEvent.CLICK,this.__reward);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         this._halfYearBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._threeMonthBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._oneMonthBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
      }
      
      private function removeEvent() : void
      {
         this._openVipBtn.removeEventListener(MouseEvent.CLICK,this.__openVip);
         this._renewalVipBtn.removeEventListener(MouseEvent.CLICK,this.__openVip);
         this._openVipTimeBtnGroup.removeEventListener(Event.CHANGE,this.__upPayNum);
         this._rewardBtn.removeEventListener(MouseEvent.CLICK,this.__reward);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         this._halfYearBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._threeMonthBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._oneMonthBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
      }
      
      private function __soundPlay(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __reward(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Date = null;
         var _loc4_:Date = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.canTakeVipReward || PlayerManager.Instance.Self.IsVIP == false)
         {
            this._vipInfoTipBox = ComponentFactory.Instance.creat("vip.VipInfoTipFrame");
            this._vipInfoTipBox.escEnable = true;
            this._vipInfoTipBox.vipAwardGoodsList = this.getVIPInfoTip(BossBoxManager.instance.inventoryItemList);
            this._vipInfoTipBox.addEventListener(FrameEvent.RESPONSE,this.__responseVipInfoTipHandler);
            LayerManager.Instance.addToLayer(this._vipInfoTipBox,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         else
         {
            _loc2_ = 0;
            _loc3_ = PlayerManager.Instance.Self.systemDate as Date;
            if(_loc3_.day == 0)
            {
               _loc2_ = 1;
            }
            else
            {
               _loc2_ = 8 - _loc3_.day;
            }
            _loc4_ = new Date(_loc3_.getTime() + _loc2_ * millisecondsPerDay);
            this.alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.vip.vipView.cueDateScript",_loc4_.month + 1,_loc4_.date),LanguageMgr.GetTranslation("ok"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            this.alertFrame.moveEnable = false;
            this.alertFrame.addEventListener(FrameEvent.RESPONSE,this.__alertHandler);
         }
      }
      
      private function __alertHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.alertFrame.removeEventListener(FrameEvent.RESPONSE,this.__alertHandler);
         if(this.alertFrame && this.alertFrame.parent)
         {
            this.alertFrame.parent.removeChild(this.alertFrame);
         }
         if(this.alertFrame)
         {
            this.alertFrame.dispose();
         }
         this.alertFrame = null;
      }
      
      private function __responseVipInfoTipHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._vipInfoTipBox.removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this._vipInfoTipBox.dispose();
               this._vipInfoTipBox = null;
               break;
            case FrameEvent.ENTER_CLICK:
               this.showAwards(this._vipInfoTipBox.selectCellInfo);
               this._vipInfoTipBox.dispose();
               this._vipInfoTipBox = null;
         }
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.awards.removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.awards.dispose();
               this.awards = null;
         }
      }
      
      private function showAwards(param1:ItemTemplateInfo) : void
      {
         this.awards = ComponentFactory.Instance.creat("vip.awardFrame");
         this.awards.escEnable = true;
         this.awards.boxType = 2;
         this.awards.vipAwardGoodsList = this._getStrArr(BossBoxManager.instance.inventoryItemList);
         this.awards.addEventListener(AwardsView.HAVEBTNCLICK,this.__sendReward);
         this.awards.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         LayerManager.Instance.addToLayer(this.awards,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __sendReward(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this.awards.removeEventListener(AwardsView.HAVEBTNCLICK,this.__sendReward);
         this.awards.dispose();
         PlayerManager.Instance.Self.canTakeVipReward = false;
         this.rewardBtnCanUse();
      }
      
      private function __propertyChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["Money"])
         {
            this._money.text = PlayerManager.Instance.Self.Money + LanguageMgr.GetTranslation("money");
         }
         if(param1.changedProperties["isVip"] || param1.changedProperties["canTakeVipReward"])
         {
            this.showOpenOrRenewal();
            this.rewardBtnCanUse();
         }
      }
      
      private function __upPayNum(param1:Event) : void
      {
         this.upPayMoneyText();
      }
      
      protected function __openVip(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.Money < this.payNum)
         {
            this._moneyConfirm = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            this._moneyConfirm.moveEnable = false;
            this._moneyConfirm.addEventListener(FrameEvent.RESPONSE,this.__moneyConfirmHandler);
            return;
         }
         var _loc2_:String = LanguageMgr.GetTranslation("ddt.vip.vipView.confirmforSelf",this.time,this.payNum);
         this._confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("ddt.vip.vipFrame.ConfirmTitle"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.BLCAK_BLOCKGOUND);
         this._confirmFrame.moveEnable = false;
         this._confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__confirm);
      }
      
      private function __moneyConfirmHandler(param1:FrameEvent) : void
      {
         this._moneyConfirm.removeEventListener(FrameEvent.RESPONSE,this.__moneyConfirmHandler);
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               LeavePageManager.leaveToFillPath();
         }
         this._moneyConfirm.dispose();
         if(this._moneyConfirm.parent)
         {
            this._moneyConfirm.parent.removeChild(this._moneyConfirm);
         }
         this._moneyConfirm = null;
      }
      
      private function __confirm(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirm);
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.sendVip();
               this.upPayMoneyText();
         }
         this._confirmFrame.dispose();
         if(this._confirmFrame.parent)
         {
            this._confirmFrame.parent.removeChild(this._confirmFrame);
         }
      }
      
      protected function sendVip() : void
      {
         this.days = 0;
         switch(this._openVipTimeBtnGroup.selectIndex)
         {
            case 2:
               this.days = 30;
               break;
            case 1:
               this.days = 30 * 3;
               break;
            case 0:
               this.days = 30 * 6;
         }
         this.send();
      }
      
      protected function send() : void
      {
         VipController.instance.sendOpenVip(PlayerManager.Instance.Self.NickName,this.days);
      }
      
      protected function upPayMoneyText() : void
      {
         this.payNum = 0;
         this.time = "";
         this.payNum = this.getOpenMoney(this._openVipTimeBtnGroup.selectIndex);
         switch(this._openVipTimeBtnGroup.selectIndex)
         {
            case 2:
               this.time = "1个月";
               this._spreeView.setView(1);
               this._itemScroll.invalidateViewport();
               break;
            case 1:
               this.time = "3个月";
               this._spreeView.setView(3);
               this._itemScroll.invalidateViewport();
               break;
            case 0:
               this.time = "6个月";
               this._spreeView.setView(6);
               this._itemScroll.invalidateViewport();
         }
      }
      
      private function _getStrArr(param1:DictionaryData) : Array
      {
         return param1[_vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 1]];
      }
      
      private function getVIPInfoTip(param1:DictionaryData) : Array
      {
         var _loc2_:Array = null;
         return PlayerManager.Instance.Self.VIPLevel == 12 ? [ItemManager.Instance.getTemplateById(int(_vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 2])),ItemManager.Instance.getTemplateById(int(_vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 1]))] : [ItemManager.Instance.getTemplateById(int(_vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 1])),ItemManager.Instance.getTemplateById(int(_vipChestsArr[PlayerManager.Instance.Self.VIPLevel]))];
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._halfYearBtn);
         this._halfYearBtn = null;
         ObjectUtils.disposeObject(this._threeMonthBtn);
         this._threeMonthBtn = null;
         ObjectUtils.disposeObject(this._oneMonthBtn);
         this._oneMonthBtn = null;
         ObjectUtils.disposeObject(this._vipPrivilegeTxt);
         this._vipPrivilegeTxt = null;
         ObjectUtils.disposeObject(this._discountIcon);
         this._discountIcon = null;
         ObjectUtils.disposeObject(this._selectedBtnImage);
         this._selectedBtnImage = null;
         if(this._rewardEffet)
         {
            this._rewardEffet.dispose();
         }
         this._rewardEffet = null;
         if(this._openVipBtn)
         {
            ObjectUtils.disposeObject(this._openVipBtn);
         }
         this._openVipBtn = null;
         if(this._BG)
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(this._money)
         {
            ObjectUtils.disposeObject(this._money);
         }
         this._money = null;
         if(this._showPayMoneyBG)
         {
            ObjectUtils.disposeObject(this._showPayMoneyBG);
         }
         this._showPayMoneyBG = null;
         if(this._confirmFrame)
         {
            this._confirmFrame.dispose();
         }
         this._confirmFrame = null;
         if(this._moneyConfirm)
         {
            this._moneyConfirm.dispose();
         }
         this._moneyConfirm = null;
         if(this._renewalVipBtn)
         {
            ObjectUtils.disposeObject(this._renewalVipBtn);
         }
         this._renewalVipBtn = null;
         if(this._rewardBtn)
         {
            ObjectUtils.disposeObject(this._rewardBtn);
         }
         this._rewardBtn = null;
         if(this.alertFrame)
         {
            this.alertFrame.dispose();
         }
         this.alertFrame = null;
         if(this._rewardShin)
         {
            TweenMax.killTweensOf(this._rewardShin);
         }
         if(this._rewardShin)
         {
            ObjectUtils.disposeObject(this._rewardShin);
         }
         this._rewardShin = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         ObjectUtils.disposeObject(this._spreeView);
         this._spreeView = null;
      }
   }
}
