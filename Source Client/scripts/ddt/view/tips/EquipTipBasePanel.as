package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import road7th.utils.DateUtils;
   import store.StoreController;
   import store.data.RefiningConfigInfo;
   
   public class EquipTipBasePanel extends Component
   {
      
      public static const THISWIDTH:int = 200;
      
      public static const MAX_HOLE:int = 4;
       
      
      private var _bg:DisplayObject;
      
      private var _equipName:FilterFrameText;
      
      private var _StrengthLimit:FilterFrameText;
      
      private var _equipPosition:FilterFrameText;
      
      private var _NeedLevel:FilterFrameText;
      
      private var _MainPropertyTxt:Vector.<FilterFrameText>;
      
      private var _propVec:Vector.<FilterFrameText>;
      
      private var _refiningTitleTxt:FilterFrameText;
      
      private var _refiningTitleDec:FilterFrameText;
      
      private var _refiningTxtVec:Vector.<FilterFrameText>;
      
      private var _embedVec:Vector.<EquipTipEmbedItem>;
      
      private var _DescriptionTxt:FilterFrameText;
      
      private var _equipScore:FilterFrameText;
      
      private var _rule3:ScaleBitmapImage;
      
      private var _rule4:ScaleBitmapImage;
      
      private var _rule5:ScaleBitmapImage;
      
      private var _rule6:ScaleBitmapImage;
      
      private var _info:ItemTemplateInfo;
      
      private var _EquipInfo:EquipmentTemplateInfo;
      
      private var _thisHeight:int;
      
      private var _bindImage:ScaleFrameImage;
      
      private var _Property:Boolean;
      
      private var _AngleTxt:FilterFrameText;
      
      private var _timeRule:ScaleBitmapImage;
      
      private var _restTimeTxt:FilterFrameText;
      
      private var _type:int;
      
      public function EquipTipBasePanel(param1:int = 0)
      {
         this._type = param1;
         super();
      }
      
      override protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename(this._type == 0 ? "core.GoodsTipBg" : "EquipsTipPanel.bg");
         this._rule3 = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.HRule");
         this._rule4 = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.HRule");
         this._rule5 = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.HRule");
         this._rule6 = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.HRule");
         this._equipName = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.name");
         this._equipName.y += this._type == 0 ? 0 : 32;
         this._StrengthLimit = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.Position");
         this._equipPosition = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.Position");
         this._AngleTxt = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.AngleTitle");
         this._NeedLevel = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.Position");
         this._MainPropertyTxt = new Vector.<FilterFrameText>(2);
         var _loc1_:int = 0;
         while(_loc1_ < 2)
         {
            this._MainPropertyTxt[_loc1_] = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.MainProperty");
            _loc1_++;
         }
         this._propVec = new Vector.<FilterFrameText>(6);
         var _loc2_:int = 0;
         while(_loc2_ < 6)
         {
            this._propVec[_loc2_] = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.basePropTitle");
            _loc2_++;
         }
         this._refiningTitleTxt = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.refiningTitleTxt");
         this._refiningTitleDec = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.refiningDecTxt");
         this._refiningTxtVec = new Vector.<FilterFrameText>(5);
         var _loc3_:int = 0;
         while(_loc3_ < this._refiningTxtVec.length)
         {
            this._refiningTxtVec[_loc3_] = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.refiningTxt");
            _loc3_++;
         }
         this._embedVec = new Vector.<EquipTipEmbedItem>(MAX_HOLE);
         var _loc4_:int = 0;
         while(_loc4_ < MAX_HOLE)
         {
            this._embedVec[_loc4_] = new EquipTipEmbedItem(_loc4_);
            _loc4_++;
         }
         this._DescriptionTxt = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.Description");
         this._equipScore = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.Score");
         this._bindImage = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.BoundImage");
         this._timeRule = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.HRule");
         this._restTimeTxt = ComponentFactory.Instance.creatComponentByStylename("EquipsTipPanel.remainTimeTxt");
         super.init();
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._bg);
         addChild(this._equipName);
         addChild(this._StrengthLimit);
         addChild(this._equipPosition);
         addChild(this._NeedLevel);
         addChild(this._AngleTxt);
         var _loc1_:int = 0;
         while(_loc1_ < 2)
         {
            addChild(this._MainPropertyTxt[_loc1_]);
            _loc1_++;
         }
         addChild(this._refiningTitleTxt);
         addChild(this._refiningTitleDec);
         var _loc2_:int = 0;
         while(_loc2_ < this._refiningTxtVec.length)
         {
            addChild(this._refiningTxtVec[_loc2_]);
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(_loc3_ < 6)
         {
            addChild(this._propVec[_loc3_]);
            _loc3_++;
         }
         var _loc4_:int = 0;
         while(_loc4_ < MAX_HOLE)
         {
            addChild(this._embedVec[_loc4_]);
            _loc4_++;
         }
         addChild(this._DescriptionTxt);
         addChild(this._equipScore);
         addChild(this._rule3);
         addChild(this._rule4);
         addChild(this._rule5);
         addChild(this._rule6);
         addChild(this._timeRule);
         addChild(this._restTimeTxt);
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      override public function get tipData() : Object
      {
         return _tipData;
      }
      
      override public function set tipData(param1:Object) : void
      {
         if(param1 is ItemTemplateInfo)
         {
            this._info = param1 as ItemTemplateInfo;
            this.visible = true;
            _tipData = this._info;
            this._EquipInfo = ItemManager.Instance.getEquipTemplateById(this._info.TemplateID);
            this.upView();
         }
         else if(param1 is ShopItemInfo)
         {
            this._info = ItemManager.Instance.getTemplateById(param1.TemplateID);
            this.visible = true;
            _tipData = this._info;
            this._EquipInfo = ItemManager.Instance.getEquipTemplateById(this._info.TemplateID);
            this.upView();
         }
         else
         {
            this.visible = false;
         }
      }
      
      private function upView() : void
      {
         this._thisHeight = 0;
         this.showHeadPart();
         this.showHeadTwoPart();
         this.showMiddlePart();
         this.showMiddleTwoPart();
         this.showRefiningPart();
         this.showEmbedInfo();
         this.showButtomPart();
         this.showRemainTime();
         this.upBackground();
      }
      
      private function showHeadPart() : void
      {
         var _loc2_:int = 0;
         var _loc3_:RefiningConfigInfo = null;
         var _loc1_:InventoryItemInfo = this._info as InventoryItemInfo;
         if(_loc1_ == null || ItemManager.Instance.judgeJewelry(this._info))
         {
            this._equipName.text = this._info.Name;
         }
         else if(_loc1_.StrengthenLevel == 0)
         {
            this._equipName.text = this._info.Name;
         }
         else
         {
            this._equipName.text = this._info.Name + "+" + String(_loc1_.StrengthenLevel);
         }
         if(ItemManager.Instance.judgeJewelry(this._info))
         {
            if(_loc1_)
            {
               _loc3_ = StoreController.instance.Model.getRefiningConfigByLevel(_loc1_.StrengthenLevel);
               if(_loc3_)
               {
                  _loc2_ = _loc3_.Level % 10;
                  this._equipName.text += "(" + _loc3_.Desc + ")";
               }
               else
               {
                  this._equipName.text += LanguageMgr.GetTranslation("ddt.EquipTipPanel.refiningDefault",0);
               }
            }
            else
            {
               this._equipName.text += LanguageMgr.GetTranslation("ddt.EquipTipPanel.refiningDefault",0);
            }
         }
         if(this._EquipInfo.QualityID == 1)
         {
            this._equipName.textColor = 6277377;
         }
         else if(this._EquipInfo.QualityID == 2)
         {
            this._equipName.textColor = 128510;
         }
         else if(this._EquipInfo.QualityID == 3)
         {
            this._equipName.textColor = 13396991;
         }
         else if(this._EquipInfo.QualityID == 4)
         {
            this._equipName.textColor = 16729014;
         }
         else if(this._EquipInfo.QualityID == 5)
         {
            this._equipName.textColor = 16744448;
         }
         this._thisHeight = this._equipName.y + this._equipName.textHeight + 10;
         this._StrengthLimit.visible = true;
         if(this._EquipInfo.TemplateType == 7 || this._EquipInfo.TemplateType == 8 || this._EquipInfo.TemplateType == 9 || this._EquipInfo.TemplateType == 10)
         {
            this._StrengthLimit.text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.Synthesis");
         }
         else if(this._EquipInfo.TemplateType == EquipType.EMBED_TYPE)
         {
            this._StrengthLimit.visible = false;
         }
         else if(EquipType.NoStrengLimitGood(this._info) || this._EquipInfo.StrengthLimit <= 0)
         {
            this._StrengthLimit.text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.NoStrengLimit");
         }
         else
         {
            this._StrengthLimit.text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.StrengthLimit",this._EquipInfo.StrengthLimit);
         }
         if(this._StrengthLimit.visible)
         {
            this._StrengthLimit.x = this._equipName.x;
            this._StrengthLimit.y = this._thisHeight;
            this._thisHeight = this._StrengthLimit.y + this._StrengthLimit.textHeight + 18;
         }
      }
      
      private function showHeadTwoPart() : void
      {
         var _loc1_:InventoryItemInfo = this._info as InventoryItemInfo;
         if(_loc1_)
         {
            this._bindImage.setFrame(!!_loc1_.IsBinds ? int(1) : int(2));
            PositionUtils.setPos(this._bindImage,"ddtcore.equipTip.BindPos");
            this._bindImage.y += this._type == 0 ? 0 : 32;
            addChild(this._bindImage);
         }
         else if(this._bindImage.parent)
         {
            this._bindImage.parent.removeChild(this._bindImage);
         }
         this._equipPosition.visible = true;
         switch(this._EquipInfo.TemplateType)
         {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
            case 11:
            case 13:
               this._equipPosition.text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.PositionTxt" + this._EquipInfo.TemplateType);
               break;
            case 12:
               this._equipPosition.visible = false;
         }
         if(this._equipPosition.visible)
         {
            this._equipPosition.y = this._thisHeight;
            this._thisHeight = this._equipPosition.y + this._equipPosition.textHeight + 8;
         }
         this._NeedLevel.text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.NeedLevel",this._info.NeedLevel);
         if(PlayerManager.Instance.Self.Grade < this._info.NeedLevel)
         {
            this._NeedLevel.textColor = 15207950;
         }
         else
         {
            this._NeedLevel.textColor = 16119285;
         }
         this._NeedLevel.x = this._equipPosition.x;
         this._NeedLevel.y = this._thisHeight;
         this._thisHeight = this._NeedLevel.y + this._NeedLevel.textHeight;
      }
      
      private function showMiddlePart() : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc1_:InventoryItemInfo = this._info as InventoryItemInfo;
         var _loc2_:Array = new Array();
         var _loc3_:EquipmentTemplateInfo = ItemManager.Instance.getEquipPropertyListById(this._EquipInfo.MainProperty1ID);
         var _loc4_:EquipmentTemplateInfo = ItemManager.Instance.getEquipPropertyListById(this._EquipInfo.MainProperty2ID);
         if(_loc1_ == null || _loc1_.StrengthenLevel == 0 || ItemManager.Instance.judgeJewelry(this._info))
         {
            _loc5_ = 0;
            _loc6_ = 0;
         }
         else
         {
            _loc5_ = ItemManager.Instance.getMinorProperty(this._info,_loc1_);
            _loc6_ = ItemManager.Instance.getTwoMinorProperty(this._info,_loc1_);
         }
         if(this._EquipInfo.MainProperty1ID != 0)
         {
            _loc2_.push(LanguageMgr.GetTranslation("ddt.EquipTipPanel.PropArr",_loc3_.PropertyName,this._EquipInfo.MainProperty1Value,_loc1_ != null ? (_loc1_.StrengthenLevel > 0 ? (_loc5_ != 0 ? "(+" + _loc5_ + ")" : "") : "") : ""));
         }
         if(this._EquipInfo.MainProperty2ID != 0)
         {
            _loc2_.push(LanguageMgr.GetTranslation("ddt.EquipTipPanel.PropArr",_loc4_.PropertyName,this._EquipInfo.MainProperty2Value,_loc1_ != null ? (_loc1_.StrengthenLevel > 0 ? (_loc6_ != 0 ? "(+" + _loc6_ + ")" : "") : "") : ""));
         }
         if(_loc2_.length == 0)
         {
            this._rule3.y = this._NeedLevel.y + this._NeedLevel.textHeight + 10;
            this._AngleTxt.visible = false;
            this._MainPropertyTxt[0].visible = false;
            this._MainPropertyTxt[1].visible = false;
         }
         else
         {
            _loc7_ = 0;
            while(_loc7_ < 2)
            {
               if(_loc7_ < _loc2_.length)
               {
                  this._MainPropertyTxt[_loc7_].htmlText = _loc2_[_loc7_];
                  this._MainPropertyTxt[_loc7_].y = this._NeedLevel.y + this._NeedLevel.textHeight + 10 + 24 * _loc7_;
                  this._MainPropertyTxt[_loc7_].visible = true;
                  if(this._EquipInfo.TemplateType == 5)
                  {
                     this._AngleTxt.text = LanguageMgr.GetTranslation("ddt.angle") + ":" + this._info.Property5 + "°" + "~" + this._info.Property6 + "°";
                     this._AngleTxt.visible = true;
                     this._AngleTxt.x = this._MainPropertyTxt[_loc7_].x;
                     this._AngleTxt.y = this._MainPropertyTxt[_loc7_].y + this._MainPropertyTxt[_loc7_].textHeight + 6;
                     this._thisHeight = this._AngleTxt.y + this._AngleTxt.textHeight;
                     this._rule3.y = this._AngleTxt.y + this._AngleTxt.textHeight + 12;
                  }
                  else
                  {
                     this._AngleTxt.visible = false;
                     this._rule3.y = this._MainPropertyTxt[_loc7_].y + this._MainPropertyTxt[_loc7_].textHeight + 12;
                  }
               }
               else
               {
                  this._MainPropertyTxt[_loc7_].visible = false;
               }
               _loc7_++;
            }
            this._thisHeight = this._rule3.y + this._rule3.height;
         }
      }
      
      private function showMiddleTwoPart() : void
      {
         var _loc4_:EquipmentTemplateInfo = null;
         var _loc1_:Array = new Array();
         var _loc2_:int = 1;
         while(_loc2_ < 7)
         {
            _loc4_ = ItemManager.Instance.getEquipPropertyListById(this._EquipInfo["MinorProperty" + _loc2_ + "ID"]);
            if(this._EquipInfo["MinorProperty" + _loc2_ + "ID"] != 0)
            {
               _loc1_.push(LanguageMgr.GetTranslation("ddt.EquipTipPanel.PropArr1",_loc4_.PropertyName,this._EquipInfo["MinorProperty" + _loc2_ + "Value"]));
            }
            _loc2_++;
         }
         if(_loc1_.length == 0)
         {
            this._rule4.visible = false;
            this._Property = false;
         }
         else
         {
            this._rule4.visible = true;
            this._Property = true;
         }
         var _loc3_:int = 0;
         while(_loc3_ < 6)
         {
            if(_loc3_ < _loc1_.length)
            {
               this._propVec[_loc3_].text = _loc1_[_loc3_];
               this._propVec[_loc3_].textColor = 6277377;
               this._propVec[_loc3_].y = this._rule3.y + this._rule3.height + 8 + 24 * _loc3_;
               this._propVec[_loc3_].visible = true;
               this._rule4.y = this._propVec[_loc3_].y + this._propVec[_loc3_].textHeight + 12;
               this._thisHeight = this._rule4.y + this._rule4.height;
            }
            else
            {
               this._propVec[_loc3_].visible = false;
            }
            _loc3_++;
         }
      }
      
      private function showRefiningPart() : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:RefiningConfigInfo = null;
         var _loc4_:RefiningConfigInfo = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         this._rule6.visible = false;
         this._refiningTitleTxt.visible = false;
         this._refiningTitleDec.visible = false;
         var _loc1_:int = 0;
         while(_loc1_ < this._refiningTxtVec.length)
         {
            this._refiningTxtVec[_loc1_].visible = false;
            _loc1_++;
         }
         if(ItemManager.Instance.judgeJewelry(this._info))
         {
            if(this._info is InventoryItemInfo)
            {
               this._rule6.visible = true;
               this._refiningTitleTxt.visible = true;
               _loc2_ = this._info as InventoryItemInfo;
               this._thisHeight += 6;
               _loc3_ = StoreController.instance.Model.getRefiningConfigByLevel(_loc2_.StrengthenLevel);
               _loc4_ = StoreController.instance.Model.getRefiningConfigByLevel(this._EquipInfo.StrengthLimit);
               if(!_loc3_ || _loc2_.StrengthenLevel == 0)
               {
                  this._refiningTitleTxt.text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.refiningTitle2");
                  this._refiningTitleTxt.y = this._thisHeight;
                  this._thisHeight += this._refiningTitleTxt.height;
                  this._refiningTitleDec.text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.refiningTitleDic",_loc4_.Desc);
                  this._refiningTitleDec.y = this._thisHeight;
                  this._thisHeight += this._refiningTitleDec.height;
               }
               else
               {
                  this._refiningTitleDec.visible = true;
                  _loc5_ = 0;
                  while(_loc5_ < this._refiningTxtVec.length)
                  {
                     this._refiningTxtVec[_loc5_].visible = true;
                     _loc5_++;
                  }
                  this._refiningTitleTxt.text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.refiningTitle1");
                  this._refiningTitleTxt.y = this._thisHeight;
                  this._thisHeight += this._refiningTitleTxt.height;
                  this._refiningTitleDec.text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.refiningTitleDic",_loc4_.Desc);
                  this._refiningTitleDec.y = this._thisHeight;
                  this._thisHeight += this._refiningTitleDec.height;
                  this._refiningTxtVec[0].text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.refiningTxt0",_loc3_.Blood);
                  this._refiningTxtVec[1].text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.refiningTxt1",_loc3_.Attack);
                  this._refiningTxtVec[2].text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.refiningTxt2",_loc3_.Defence);
                  this._refiningTxtVec[3].text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.refiningTxt3",_loc3_.Agility);
                  this._refiningTxtVec[4].text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.refiningTxt4",_loc3_.Lucky);
                  _loc6_ = 0;
                  while(_loc6_ < this._refiningTxtVec.length)
                  {
                     this._refiningTxtVec[_loc6_].y = this._thisHeight;
                     this._thisHeight += this._refiningTxtVec[_loc6_].height;
                     _loc6_++;
                  }
               }
               this._rule6.y = this._thisHeight + 6;
               this._thisHeight = this._rule6.y + this._rule6.height;
            }
         }
      }
      
      private function showEmbedInfo() : void
      {
         var _loc1_:int = 0;
         var _loc3_:Array = null;
         this._rule5.visible = false;
         var _loc2_:Boolean = false;
         if(this._info is InventoryItemInfo)
         {
            _loc1_ = 0;
            while(_loc1_ < MAX_HOLE)
            {
               if(this._info["Hole" + (_loc1_ + 1)])
               {
                  if(!_loc2_)
                  {
                     this._thisHeight += 6;
                     this._rule5.visible = true;
                     _loc2_ = true;
                  }
                  this._embedVec[_loc1_].holeID = this._info["Hole" + (_loc1_ + 1)];
                  this._embedVec[_loc1_].y = this._thisHeight;
                  this._thisHeight += this._embedVec[_loc1_].height;
                  this._embedVec[_loc1_].visible = true;
               }
               else
               {
                  this._embedVec[_loc1_].visible = false;
               }
               _loc1_++;
            }
         }
         else if(this._info is ItemTemplateInfo)
         {
            _loc1_ = 0;
            while(_loc1_ < 4)
            {
               _loc3_ = EquipType.getEmbedHoleInfo(this._info,_loc1_);
               if(_loc3_[0] != 0)
               {
                  if(!_loc2_)
                  {
                     this._thisHeight += 6;
                     this._rule5.visible = true;
                     _loc2_ = true;
                  }
                  if(_loc3_[0] == "-1" && _loc3_[1] == "0")
                  {
                     this._embedVec[_loc1_].holeID = 1;
                  }
                  else
                  {
                     this._embedVec[_loc1_].holeID = _loc3_[0];
                  }
                  this._embedVec[_loc1_].y = this._thisHeight;
                  this._thisHeight += this._embedVec[_loc1_].height;
                  this._embedVec[_loc1_].visible = true;
               }
               else
               {
                  this._embedVec[_loc1_].visible = false;
               }
               _loc1_++;
            }
         }
         if(_loc2_)
         {
            this._rule5.y = this._thisHeight + 6;
            this._thisHeight = this._rule5.y + this._rule5.height;
         }
      }
      
      private function showButtomPart() : void
      {
         var _loc4_:RefiningConfigInfo = null;
         this._DescriptionTxt.text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.Description") + "\n" + this._info.Description;
         this._DescriptionTxt.x = this._equipPosition.x;
         this._DescriptionTxt.y = this._thisHeight + 12;
         var _loc1_:int = 0;
         if(this._EquipInfo.TemplateType == 7 || this._EquipInfo.TemplateType == 8 || this._EquipInfo.TemplateType == 9 || this._EquipInfo.TemplateType == 10)
         {
            _loc1_ += 4 * Math.pow(2,EquipmentTemplateInfo.MAX_SMELT_LEVEL + 1);
         }
         else
         {
            _loc1_ += Math.pow(this._EquipInfo.StrengthLimit,2);
         }
         _loc1_ += this.getPropertyPoint(this._EquipInfo.MainProperty1ID,this._EquipInfo.MainProperty1Value);
         _loc1_ += this.getPropertyPoint(this._EquipInfo.MainProperty2ID,this._EquipInfo.MainProperty2Value);
         var _loc2_:int = 1;
         while(_loc2_ < 7)
         {
            _loc1_ += this.getPropertyPoint(this._EquipInfo["MinorProperty" + _loc2_ + "ID"],this._EquipInfo["MinorProperty" + _loc2_ + "Value"]);
            _loc2_++;
         }
         var _loc3_:InventoryItemInfo = this._info as InventoryItemInfo;
         if(_loc3_)
         {
            _loc4_ = StoreController.instance.Model.getRefiningConfigByLevel(_loc3_.StrengthenLevel);
            _loc1_ += this.getPropertyPoint(7,_loc4_.Blood);
            _loc1_ += this.getPropertyPoint(1,_loc4_.Attack);
            _loc1_ += this.getPropertyPoint(2,_loc4_.Defence);
            _loc1_ += this.getPropertyPoint(3,_loc4_.Agility);
            _loc1_ += this.getPropertyPoint(4,_loc4_.Lucky);
         }
         this._equipScore.text = LanguageMgr.GetTranslation("ddt.EquipTipPanel.equipScore",_loc1_);
         this._equipScore.y = this._DescriptionTxt.y + this._DescriptionTxt.textHeight + 12;
         this._thisHeight = this._equipScore.y + this._equipScore.textHeight;
      }
      
      private function getPropertyPoint(param1:int, param2:int) : int
      {
         switch(param1)
         {
            case 1:
            case 2:
            case 3:
            case 4:
               return param2 * 2;
            case 5:
            case 6:
               return param2 * 5;
            case 7:
               return param2;
            case 8:
               return param2 * 10;
            default:
               return 0;
         }
      }
      
      private function showRemainTime() : void
      {
         var _loc1_:InventoryItemInfo = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:ShopItemInfo = null;
         this._timeRule.visible = this._restTimeTxt.visible = false;
         if(this._info is InventoryItemInfo)
         {
            _loc1_ = InventoryItemInfo(this._info);
            if(_loc1_.ValidDate > 0)
            {
               _loc2_ = _loc1_.getRemainSecond();
               _loc3_ = _loc2_ / DateUtils.DAY_SECONDS;
               _loc4_ = _loc2_ % DateUtils.DAY_SECONDS / DateUtils.HOUR_SECONDS;
               _loc5_ = _loc2_ % DateUtils.HOUR_SECONDS / DateUtils.MINITE_SECONDS;
               if(!_loc1_.IsUsed)
               {
                  this._restTimeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time") + _loc1_.ValidDate + LanguageMgr.GetTranslation("day");
                  this._restTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
               }
               else if(_loc2_ > 0)
               {
                  _loc6_ = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less");
                  if(_loc3_ > 1)
                  {
                     _loc6_ += _loc3_ + LanguageMgr.GetTranslation("day");
                  }
                  else if(_loc3_ > 0)
                  {
                     _loc6_ += _loc3_ + LanguageMgr.GetTranslation("day");
                     if(_loc4_ > 0)
                     {
                        _loc6_ += _loc4_ + LanguageMgr.GetTranslation("hours");
                     }
                  }
                  else
                  {
                     if(_loc4_ > 0)
                     {
                        _loc6_ += _loc4_ + LanguageMgr.GetTranslation("hours");
                     }
                     _loc6_ += _loc5_ + 1 + LanguageMgr.GetTranslation("minute");
                  }
                  this._restTimeTxt.text = _loc6_;
                  this._restTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
               }
               else
               {
                  this._restTimeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.over");
                  this._restTimeTxt.textColor = GoodTip.ITEM_PAST_DUE_COLOR;
               }
               this._timeRule.visible = this._restTimeTxt.visible = true;
               this._timeRule.y = this._thisHeight + 12;
               this._restTimeTxt.y = this._timeRule.y + this._timeRule.height + 2;
               this._thisHeight = this._restTimeTxt.y + this._restTimeTxt.textHeight;
            }
         }
         else
         {
            _loc7_ = ShopManager.Instance.getGoodsByTemplateID(this._info.TemplateID);
            if(_loc7_ && _loc7_.BuyType == 0 && _loc7_.AUnit > 0)
            {
               this._timeRule.visible = this._restTimeTxt.visible = true;
               this._restTimeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time") + _loc7_.AUnit + LanguageMgr.GetTranslation("day");
               this._restTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
               this._timeRule.y = this._thisHeight + 12;
               this._restTimeTxt.y = this._timeRule.y + this._timeRule.height + 2;
               this._thisHeight = this._restTimeTxt.y + this._restTimeTxt.textHeight;
            }
         }
      }
      
      private function upBackground() : void
      {
         this._bg.height = this._thisHeight + 14;
         this._bg.width = THISWIDTH + this._type * 10;
         this.updateWH();
      }
      
      private function updateWH() : void
      {
         _width = this._bg.width + 17;
         _height = this._bg.height;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         this._equipName = null;
         this._StrengthLimit = null;
         this._equipPosition = null;
         this._NeedLevel = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._MainPropertyTxt.length)
         {
            ObjectUtils.disposeObject(this._MainPropertyTxt[_loc1_]);
            this._MainPropertyTxt[_loc1_] = null;
            _loc1_++;
         }
         this._MainPropertyTxt = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._propVec.length)
         {
            ObjectUtils.disposeObject(this._propVec[_loc2_]);
            this._propVec[_loc2_] = null;
            _loc2_++;
         }
         this._propVec = null;
         var _loc3_:int = 0;
         while(_loc3_ < this._refiningTxtVec.length)
         {
            ObjectUtils.disposeObject(this._refiningTxtVec[_loc3_]);
            this._refiningTxtVec[_loc3_] = null;
            _loc3_++;
         }
         this._refiningTxtVec = null;
         ObjectUtils.disposeObject(this._refiningTitleTxt);
         this._refiningTitleTxt = null;
         ObjectUtils.disposeObject(this._refiningTitleDec);
         this._refiningTitleDec = null;
         ObjectUtils.disposeObject(this._rule3);
         this._rule3 = null;
         ObjectUtils.disposeObject(this._rule4);
         this._rule4 = null;
         ObjectUtils.disposeObject(this._rule5);
         this._rule5 = null;
         ObjectUtils.disposeObject(this._rule6);
         this._rule6 = null;
         this._info = null;
         this._EquipInfo = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
