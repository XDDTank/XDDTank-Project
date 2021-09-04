package consortion.view.selfConsortia
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModel;
   import consortion.ConsortionModelControl;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ConsortionUpGradeFrame extends Frame
   {
       
      
      private var _level:SelectedButton;
      
      private var _store:SelectedButton;
      
      private var _shop:SelectedButton;
      
      private var _bank:SelectedButton;
      
      private var _skill:SelectedButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _wordAndBmp2:MutipleImage;
      
      private var _levelNum:FilterFrameText;
      
      private var _storeNum:FilterFrameText;
      
      private var _shopNum:FilterFrameText;
      
      private var _bankNum:FilterFrameText;
      
      private var _skillNum:FilterFrameText;
      
      private var _explainWord:FilterFrameText;
      
      private var _nextLevel:FilterFrameText;
      
      private var _requireText:FilterFrameText;
      
      private var _consumeText:FilterFrameText;
      
      private var _tiptitle:FilterFrameText;
      
      private var _explain:FilterFrameText;
      
      private var _next:FilterFrameText;
      
      private var _require:FilterFrameText;
      
      private var _consume:FilterFrameText;
      
      private var _ok:BaseButton;
      
      public function ConsortionUpGradeFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.titleText");
         this._level = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.level");
         this._store = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.store");
         this._shop = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.shop");
         this._bank = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.bank");
         this._skill = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.skill");
         this._btnGroup = new SelectedButtonGroup();
         this._wordAndBmp2 = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.bmp2");
         this._levelNum = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.levelNum");
         this._storeNum = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.storeNum");
         this._shopNum = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.shopNum");
         this._bankNum = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.bankNum");
         this._skillNum = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.skillNum");
         this._explainWord = ComponentFactory.Instance.creatComponentByStylename("consortion.upGrade.explainWord");
         this._explainWord.text = LanguageMgr.GetTranslation("consortion.upGrade.explainWord.text");
         this._nextLevel = ComponentFactory.Instance.creatComponentByStylename("consortion.upGrade.nextLevel");
         this._nextLevel.text = LanguageMgr.GetTranslation("consortion.upGrade.nextLevel.text");
         this._requireText = ComponentFactory.Instance.creatComponentByStylename("consortion.upGrade.require");
         this._requireText.text = LanguageMgr.GetTranslation("consortion.upGrade.require.text");
         this._consumeText = ComponentFactory.Instance.creatComponentByStylename("consortion.upGrade.consume");
         this._consumeText.text = LanguageMgr.GetTranslation("consortion.upGrade.consume.text");
         this._tiptitle = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.title");
         this._explain = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.explain");
         this._next = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.next");
         this._require = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.require");
         this._consume = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.consume");
         this._ok = ComponentFactory.Instance.creatComponentByStylename("consortion.upGradeFrame.ok");
         addToContent(this._wordAndBmp2);
         addToContent(this._level);
         addToContent(this._shop);
         addToContent(this._skill);
         addToContent(this._levelNum);
         addToContent(this._storeNum);
         addToContent(this._shopNum);
         addToContent(this._bankNum);
         addToContent(this._skillNum);
         addToContent(this._explainWord);
         addToContent(this._nextLevel);
         addToContent(this._requireText);
         addToContent(this._consumeText);
         addToContent(this._tiptitle);
         addToContent(this._explain);
         addToContent(this._next);
         addToContent(this._require);
         addToContent(this._consume);
         addToContent(this._ok);
         this._btnGroup.addSelectItem(this._level);
         this._btnGroup.addSelectItem(this._shop);
         this._btnGroup.addSelectItem(this._skill);
         this._btnGroup.selectIndex = 0;
         this.setLeveText();
         this.showView(this._btnGroup.selectIndex);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._btnGroup.addEventListener(Event.CHANGE,this.__btnChangeHandler);
         this._ok.addEventListener(MouseEvent.CLICK,this.__okHandler);
         PlayerManager.Instance.Self.consortiaInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this._consortiaInfoChange);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._btnGroup.removeEventListener(Event.CHANGE,this.__btnChangeHandler);
         this._ok.removeEventListener(MouseEvent.CLICK,this.__okHandler);
         PlayerManager.Instance.Self.consortiaInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this._consortiaInfoChange);
      }
      
      private function _consortiaInfoChange(param1:PlayerPropertyEvent) : void
      {
         this.setLeveText();
      }
      
      private function setLeveText() : void
      {
         this._levelNum.text = "Lv." + String(PlayerManager.Instance.Self.consortiaInfo.StoreLevel);
         this._shopNum.text = "Lv." + String(PlayerManager.Instance.Self.consortiaInfo.ShopLevel);
         this._skillNum.text = "Lv." + String(PlayerManager.Instance.Self.consortiaInfo.SmithLevel);
         this.showView(this._btnGroup.selectIndex);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __btnChangeHandler(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this.showView(this._btnGroup.selectIndex);
      }
      
      private function showView(param1:int) : void
      {
         var _loc2_:Vector.<String> = new Vector.<String>();
         switch(param1)
         {
            case 0:
               this._tiptitle.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.titleTxt");
               _loc2_ = ConsortionModelControl.Instance.model.getLevelString(ConsortionModel.LEVEL,PlayerManager.Instance.Self.consortiaInfo.StoreLevel);
               if(PlayerManager.Instance.Self.consortiaInfo.StoreLevel >= ConsortionModel.CONSORTION_MAX_LEVEL)
               {
                  this._ok.enable = false;
               }
               else
               {
                  this._ok.enable = true;
               }
               break;
            case 1:
               this._tiptitle.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.consortiaShopUpgrade");
               _loc2_ = ConsortionModelControl.Instance.model.getLevelString(ConsortionModel.SHOP,PlayerManager.Instance.Self.consortiaInfo.ShopLevel);
               if(PlayerManager.Instance.Self.consortiaInfo.ShopLevel >= ConsortionModel.SHOP_MAX_LEVEL)
               {
                  this._ok.enable = false;
               }
               else
               {
                  this._ok.enable = true;
               }
               break;
            case 2:
               this._tiptitle.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.consortiaSkillUpgrade");
               _loc2_ = ConsortionModelControl.Instance.model.getLevelString(ConsortionModel.SKILL,PlayerManager.Instance.Self.consortiaInfo.SmithLevel);
               if(PlayerManager.Instance.Self.consortiaInfo.SmithLevel >= ConsortionModel.SKILL_MAX_LEVEL)
               {
                  this._ok.enable = false;
               }
               else
               {
                  this._ok.enable = true;
               }
         }
         this._explain.text = _loc2_[0];
         this._next.text = _loc2_[1];
         this._require.text = _loc2_[2];
         this._consume.htmlText = _loc2_[3];
      }
      
      private function __okHandler(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this.checkGoldOrLevel())
         {
            switch(this._btnGroup.selectIndex)
            {
               case 0:
                  _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.sure"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
                  _loc2_.moveEnable = false;
                  _loc2_.addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
                  break;
               case 1:
                  _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.CONSORTIASHOPGRADE"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
                  _loc2_.moveEnable = false;
                  _loc2_.addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
                  break;
               case 2:
                  _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.CONSORTIASKILLGRADE"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
                  _loc2_.moveEnable = false;
                  _loc2_.addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
            }
         }
      }
      
      private function __confirmResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         ObjectUtils.disposeObject(_loc2_);
         if(_loc2_ && _loc2_.parent)
         {
            _loc2_.parent.removeChild(_loc2_);
         }
         _loc2_ = null;
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(!ConsortionModelControl.Instance.model.checkConsortiaRichesForUpGrade(this._btnGroup.selectIndex))
            {
               this.openRichesTip();
               return;
            }
            this.sendUpGradeData();
         }
      }
      
      private function sendUpGradeData() : void
      {
         switch(this._btnGroup.selectIndex)
         {
            case 0:
               SocketManager.Instance.out.sendConsortiaHallUp();
               break;
            case 1:
               SocketManager.Instance.out.sendConsortiaShopUp();
               break;
            case 2:
               SocketManager.Instance.out.sendConsortiaSkillUp();
         }
      }
      
      private function openRichesTip() : void
      {
         SoundManager.instance.play("047");
         var _loc1_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.consortion.skillItem.click.enough1"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
         _loc1_.addEventListener(FrameEvent.RESPONSE,this.__noEnoughHandler);
      }
      
      private function __noEnoughHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               ConsortionModelControl.Instance.alertTaxFrame();
         }
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__noEnoughHandler);
         _loc2_.dispose();
         _loc2_ = null;
      }
      
      private function checkGoldOrLevel() : Boolean
      {
         var _loc1_:BaseAlerFrame = null;
         switch(this._btnGroup.selectIndex)
         {
            case 0:
               if(PlayerManager.Instance.Self.consortiaInfo.StoreLevel >= ConsortionModel.CONSORTION_MAX_LEVEL)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.consortiaHallLevel"));
                  return false;
               }
               if(PlayerManager.Instance.Self.consortiaInfo.StoreLevel >= PlayerManager.Instance.Self.consortiaInfo.Level && PlayerManager.Instance.Self.consortiaInfo.Level != 10)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.pleaseUpgradeI"));
                  return false;
               }
               break;
            case 1:
               if(PlayerManager.Instance.Self.consortiaInfo.ShopLevel >= ConsortionModel.SHOP_MAX_LEVEL)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.consortiaShopLevel"));
                  return false;
               }
               if(PlayerManager.Instance.Self.consortiaInfo.ShopLevel >= PlayerManager.Instance.Self.consortiaInfo.StoreLevel && PlayerManager.Instance.Self.consortiaInfo.StoreLevel != 10)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.pleaseUpgrade"));
                  return false;
               }
               break;
            case 2:
               if(PlayerManager.Instance.Self.consortiaInfo.SmithLevel >= ConsortionModel.SKILL_MAX_LEVEL)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.skill"));
               }
               else if(PlayerManager.Instance.Self.consortiaInfo.SmithLevel >= PlayerManager.Instance.Self.consortiaInfo.StoreLevel && PlayerManager.Instance.Self.consortiaInfo.StoreLevel != 10)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.pleaseUpgrade"));
                  return false;
               }
         }
         if(this._btnGroup.selectIndex == 0 && PlayerManager.Instance.Self.Gold < ConsortionModelControl.Instance.model.getLevelData(PlayerManager.Instance.Self.consortiaInfo.StoreLevel + 1).NeedGold)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return false;
            }
            _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
            _loc1_.moveEnable = false;
            _loc1_.addEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
            return false;
         }
         return true;
      }
      
      private function __quickBuyResponse(param1:FrameEvent) : void
      {
         var _loc3_:QuickBuyFrame = null;
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
         _loc2_.dispose();
         if(_loc2_.parent)
         {
            _loc2_.parent.removeChild(_loc2_);
         }
         _loc2_ = null;
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            _loc3_ = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            _loc3_.itemID = EquipType.GOLD_BOX;
            _loc3_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      private function __cancelHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._level = null;
         this._store = null;
         this._shop = null;
         this._bank = null;
         this._skill = null;
         this._wordAndBmp2 = null;
         this._levelNum = null;
         this._storeNum = null;
         this._shopNum = null;
         this._bankNum = null;
         this._skillNum = null;
         this._explainWord = null;
         this._nextLevel = null;
         this._requireText = null;
         this._consumeText = null;
         this._tiptitle = null;
         this._explain = null;
         this._next = null;
         this._require = null;
         this._consume = null;
         this._ok = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
