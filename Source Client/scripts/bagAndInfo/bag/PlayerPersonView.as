package bagAndInfo.bag
{
   import bagAndInfo.info.GlowPropButton;
   import bagAndInfo.info.PropButton;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import road7th.data.DictionaryData;
   
   public class PlayerPersonView extends Sprite implements Disposeable
   {
       
      
      private var _info:PlayerInfo;
      
      private var _bigBg:Bitmap;
      
      private var _HpBg:Bitmap;
      
      private var _personBg:MutipleImage;
      
      private var _personBgI:MutipleImage;
      
      private var _attackTxt:FilterFrameText;
      
      private var _agilityTxt:FilterFrameText;
      
      private var _defenceTxt:FilterFrameText;
      
      private var _luckTxt:FilterFrameText;
      
      private var _damageTxt:FilterFrameText;
      
      private var _damageButton:PropButton;
      
      private var _armorTxt:FilterFrameText;
      
      private var _armorButton:PropButton;
      
      private var _HPText:FilterFrameText;
      
      private var _hpButton:PropButton;
      
      private var _vitality:FilterFrameText;
      
      private var _vitalityBuntton:PropButton;
      
      private var _attackButton:GlowPropButton;
      
      private var _agilityButton:GlowPropButton;
      
      private var _defenceButton:GlowPropButton;
      
      private var _luckButton:GlowPropButton;
      
      public function PlayerPersonView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bigBg = ComponentFactory.Instance.creatBitmap("asset.bagAndInfopersonInfo.bigBg");
         addChild(this._bigBg);
         this._HpBg = ComponentFactory.Instance.creatBitmap("asset.bagAndInfo.HPbg");
         this._HpBg.visible = true;
         addChild(this._HpBg);
         this._personBg = ComponentFactory.Instance.creatComponentByStylename("personInfoViewBigBg");
         addChild(this._personBg);
         this._personBgI = ComponentFactory.Instance.creatComponentByStylename("personInfoViewBigBgI");
         addChild(this._personBgI);
         this._attackTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewAttackText");
         addChild(this._attackTxt);
         PositionUtils.setPos(this._attackTxt,"personInfoViewAttackTextPos");
         this._attackButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.AttackButton");
         this._attackButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.attact");
         this._attackButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.attactDetail");
         this._attackButton.propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.propertySourceTxt",0,0,0,0);
         ShowTipManager.Instance.addTip(this._attackButton);
         addChild(this._attackButton);
         this._agilityTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewAgilityText");
         addChild(this._agilityTxt);
         PositionUtils.setPos(this._agilityTxt,"personInfoViewAgilityPos");
         this._agilityButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.AgilityButton");
         this._agilityButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.agility");
         this._agilityButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.agilityDetail");
         this._agilityButton.propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.propertySourceTxt",0,0,0,0);
         ShowTipManager.Instance.addTip(this._agilityButton);
         addChild(this._agilityButton);
         this._defenceTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewDefenceText");
         addChild(this._defenceTxt);
         PositionUtils.setPos(this._defenceTxt,"personInfoViewDefencePos");
         this._defenceButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.DefenceButton");
         this._defenceButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.defense");
         this._defenceButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.defenseDetail");
         this._defenceButton.propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.propertySourceTxt",0,0,0,0);
         ShowTipManager.Instance.addTip(this._defenceButton);
         addChild(this._defenceButton);
         this._luckTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewLuckText");
         addChild(this._luckTxt);
         PositionUtils.setPos(this._luckTxt,"personInfoViewLuckPos");
         this._luckButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.LuckButton");
         this._luckButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.luck");
         this._luckButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.luckDetail");
         this._luckButton.propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.propertySourceTxt",0,0,0,0);
         ShowTipManager.Instance.addTip(this._luckButton);
         addChild(this._luckButton);
         this._damageTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewDamageText");
         addChild(this._damageTxt);
         this._damageButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.DamageButton");
         this._damageButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.damage");
         this._damageButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.damageDetail");
         (this._damageButton as GlowPropButton).propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.damagePropertySourceTxt",0,0);
         ShowTipManager.Instance.addTip(this._damageButton);
         addChild(this._damageButton);
         this._armorTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewArmorText");
         addChild(this._armorTxt);
         this._armorButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.ArmorButton");
         this._armorButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.recovery");
         this._armorButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.recoveryDetail");
         (this._armorButton as GlowPropButton).propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.recoveryPropertySourceTxt",0);
         ShowTipManager.Instance.addTip(this._armorButton);
         addChild(this._armorButton);
         this._HPText = ComponentFactory.Instance.creatComponentByStylename("personInfoViewHPText");
         addChild(this._HPText);
         this._HPText.visible = true;
         this._hpButton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.HPButton");
         this._hpButton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.hp");
         this._hpButton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.hpDetail");
         (this._hpButton as GlowPropButton).propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.hpPropertySourceTxt",0,0,0);
         ShowTipManager.Instance.addTip(this._hpButton);
         addChild(this._hpButton);
         this._vitality = ComponentFactory.Instance.creatComponentByStylename("personInfoViewVitalityText");
         addChild(this._vitality);
         this._vitalityBuntton = ComponentFactory.Instance.creatCustomObject("bagAndInfo.info.VitalityButton");
         this._vitalityBuntton.property = LanguageMgr.GetTranslation("tank.view.personalinfoII.energy");
         this._vitalityBuntton.detail = LanguageMgr.GetTranslation("tank.view.personalinfoII.energyDetail");
         ShowTipManager.Instance.addTip(this._vitalityBuntton);
         addChild(this._vitalityBuntton);
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.addEventListener(PlayerManager.UPDATE_PLAYER_PROPERTY,this.__onUpdatePlayerProperty);
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.removeEventListener(PlayerManager.UPDATE_PLAYER_PROPERTY,this.__onUpdatePlayerProperty);
      }
      
      public function set info(param1:PlayerInfo) : void
      {
         if(this._info == param1)
         {
            return;
         }
         if(this._info)
         {
            this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeHandler);
            this._info = null;
         }
         this._info = param1;
         if(this._info)
         {
            this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeHandler);
         }
         this.updatePersonInfo();
      }
      
      public function get info() : PlayerInfo
      {
         return this._info;
      }
      
      private function __changeHandler(param1:PlayerPropertyEvent) : void
      {
         this.updatePersonInfo();
      }
      
      private function __onUpdatePlayerProperty(param1:Event) : void
      {
         var _loc5_:String = null;
         var _loc6_:DictionaryData = null;
         var _loc9_:DictionaryData = null;
         if(this._info.propertyAddition == null)
         {
            return;
         }
         var _loc2_:Vector.<GlowPropButton> = Vector.<GlowPropButton>([this._attackButton,this._defenceButton,this._agilityButton,this._luckButton,this._hpButton]);
         var _loc3_:Array = ["Attack","Defence","Agility","Luck","HP"];
         var _loc4_:int = 0;
         for each(_loc5_ in _loc3_)
         {
            _loc9_ = this._info.getPropertyAdditionByType(_loc5_);
            if(_loc9_)
            {
               if(_loc4_ < 4)
               {
                  _loc2_[_loc4_].propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.propertySourceTxtI",_loc9_["fashion"],_loc9_["Equip"],_loc9_["Bead"],int(_loc9_["Pet"] / 100).toString(),_loc9_["Totem"],_loc9_["Embed"]);
               }
               else
               {
                  _loc2_[_loc4_].propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.propertySourceTxt",_loc9_["Equip"],_loc9_["Bead"],int(_loc9_["Pet"] / 100).toString(),_loc9_["Totem"],_loc9_["Embed"]);
               }
            }
            if(_loc4_ >= 4)
            {
               break;
            }
            _loc4_++;
         }
         _loc6_ = this._info.getPropertyAdditionByType("Damage");
         if(_loc6_)
         {
            GlowPropButton(this._damageButton).propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.hpPropertySourceTxtDameage",_loc6_["Equip"],_loc6_["Totem"],_loc6_["attack"]);
         }
         var _loc7_:DictionaryData = this._info.getPropertyAdditionByType("Armor");
         if(_loc7_)
         {
            GlowPropButton(this._armorButton).propertySource = LanguageMgr.GetTranslation("tank.view.personalinfoII.hpPropertySourceTxtArmor",_loc7_["Equip"],_loc7_["Totem"],_loc7_["defence"]);
         }
         var _loc8_:DictionaryData = this._info.getPropertyAdditionByType("Energy");
      }
      
      private function updatePersonInfo() : void
      {
         if(this._info == null)
         {
            return;
         }
         this.__onUpdatePlayerProperty(null);
         if(this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._attackTxt.htmlText = this.getHtmlTextByString(String(this._info.Attack <= 0 ? "" : this._info.Attack),0);
            this._defenceTxt.htmlText = this.getHtmlTextByString(String(this._info.Defence <= 0 ? "" : this._info.Defence),0);
            this._agilityTxt.htmlText = this.getHtmlTextByString(String(this._info.Agility <= 0 ? "" : this._info.Agility),0);
            this._luckTxt.htmlText = this.getHtmlTextByString(String(this._info.Luck <= 0 ? "" : this._info.Luck),0);
            this._damageTxt.htmlText = this.getHtmlTextByString(String(this.info.Damage <= 0 ? "0" : this.info.Damage),1);
            this._armorTxt.htmlText = this.getHtmlTextByString(String(this.info.Guard <= 0 ? "0" : this.info.Guard),1);
            this._HPText.htmlText = this.getHtmlTextByString(String(this._info.hp),1);
            this._vitality.htmlText = this.getHtmlTextByString(String(this._info.Energy <= 0 ? "" : this._info.Energy),1);
         }
         else
         {
            this._attackTxt.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(this._info.Attack < 0 ? 0 : this._info.Attack),0);
            this._agilityTxt.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(this._info.Agility < 0 ? 0 : this._info.Agility),0);
            this._defenceTxt.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(this._info.Defence < 0 ? 0 : this._info.Defence),0);
            this._luckTxt.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(this._info.Luck < 0 ? 0 : this._info.Luck),0);
            this._damageTxt.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(this.info.Damage <= 0 ? "0" : this.info.Damage),1);
            this._armorTxt.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(this.info.Guard <= 0 ? "0" : this.info.Guard),1);
            this._HPText.htmlText = this._info == null ? "" : String(this._info.hp < 0 ? 0 : this._info.hp);
            this._vitality.htmlText = this._info == null ? "" : this.getHtmlTextByString(String(this._info.Energy < 0 ? 0 : this._info.Energy),1);
         }
         if(this._info.ID != PlayerManager.Instance.Self.ID)
         {
            this.removeTips();
         }
      }
      
      private function getHtmlTextByString(param1:String, param2:int) : String
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         switch(param2)
         {
            case 0:
               _loc3_ = "<TEXTFORMAT LEADING=\'-1\'><P ALIGN=\'CENTER\'><FONT FACE=\'宋体\' SIZE=\'14\' COLOR=\'#11B7D5\' ><B>";
               _loc4_ = "</B></FONT></P></TEXTFORMAT>";
               break;
            case 1:
               _loc3_ = "<TEXTFORMAT LEADING=\'-1\'><P ALIGN=\'CENTER\'><FONT FACE=\'宋体\' SIZE=\'14\' COLOR=\'#9EE6D2\' LETTERSPACING=\'0\' KERNING=\'1\'><B>";
               _loc4_ = "</B></FONT></P></TEXTFORMAT>";
               break;
            case 2:
               _loc3_ = "<TEXTFORMAT LEADING=\'-1\'><P ALIGN=\'CENTER\'><FONT FACE=\'宋体\' SIZE=\'14\' COLOR=\'#FFF6C9\' LETTERSPACING=\'0\' KERNING=\'1\'><B>";
               _loc4_ = "</B></FONT></P></TEXTFORMAT>";
         }
         return _loc3_ + param1 + _loc4_;
      }
      
      private function removeTips() : void
      {
         ShowTipManager.Instance.removeTip(this._damageButton);
         ShowTipManager.Instance.removeTip(this._armorButton);
         ShowTipManager.Instance.removeTip(this._hpButton);
         ShowTipManager.Instance.removeTip(this._vitalityBuntton);
         ShowTipManager.Instance.removeTip(this._attackButton);
         ShowTipManager.Instance.removeTip(this._agilityButton);
         ShowTipManager.Instance.removeTip(this._defenceButton);
         ShowTipManager.Instance.removeTip(this._luckButton);
      }
      
      public function setHpVisble(param1:Boolean) : void
      {
         this._HpBg.visible = param1;
         this._HPText.visible = param1;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeTips();
         if(this._bigBg)
         {
            ObjectUtils.disposeObject(this._bigBg);
            this._bigBg = null;
         }
         if(this._HpBg)
         {
            ObjectUtils.disposeObject(this._HpBg);
            this._HpBg = null;
         }
         if(this._personBg)
         {
            ObjectUtils.disposeObject(this._personBg);
            this._personBg = null;
         }
         if(this._personBgI)
         {
            ObjectUtils.disposeObject(this._personBgI);
            this._personBgI = null;
         }
         if(this._attackTxt)
         {
            ObjectUtils.disposeObject(this._attackTxt);
            this._attackTxt = null;
         }
         if(this._agilityTxt)
         {
            ObjectUtils.disposeObject(this._agilityTxt);
            this._agilityTxt = null;
         }
         if(this._defenceTxt)
         {
            ObjectUtils.disposeObject(this._defenceTxt);
            this._defenceTxt = null;
         }
         if(this._luckTxt)
         {
            ObjectUtils.disposeObject(this._luckTxt);
            this._luckTxt = null;
         }
         ObjectUtils.disposeObject(this._damageTxt);
         this._damageTxt = null;
         ObjectUtils.disposeObject(this._armorTxt);
         this._armorTxt = null;
         ObjectUtils.disposeObject(this._HPText);
         this._HPText = null;
         ObjectUtils.disposeObject(this._vitality);
         this._vitality = null;
         if(this._damageButton)
         {
            ObjectUtils.disposeObject(this._damageButton);
            this._damageButton = null;
         }
         if(this._armorButton)
         {
            ObjectUtils.disposeObject(this._armorButton);
            this._armorButton = null;
         }
         if(this._hpButton)
         {
            ObjectUtils.disposeObject(this._hpButton);
            this._hpButton = null;
         }
         if(this._vitalityBuntton)
         {
            ObjectUtils.disposeObject(this._vitalityBuntton);
            this._vitalityBuntton = null;
         }
         if(this._attackButton)
         {
            ObjectUtils.disposeObject(this._attackButton);
            this._attackButton = null;
         }
         if(this._agilityButton)
         {
            ObjectUtils.disposeObject(this._agilityButton);
            this._agilityButton = null;
         }
         if(this._defenceButton)
         {
            ObjectUtils.disposeObject(this._defenceButton);
            this._defenceButton = null;
         }
         if(this._luckButton)
         {
            ObjectUtils.disposeObject(this._luckButton);
            this._luckButton = null;
         }
         if(this._info)
         {
            this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeHandler);
         }
         this._info = null;
      }
   }
}
