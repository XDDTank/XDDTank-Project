package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.RuneSuitInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   
   public class RuneTip extends BaseTip
   {
      
      public static const THISWIDTH:int = 236;
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _tipTilte:FilterFrameText;
      
      private var _StrengthenLevelTxt:FilterFrameText;
      
      private var _propVec:Vector.<FilterFrameText>;
      
      private var _nextLevelTxt:FilterFrameText;
      
      private var _nextPropVec:Vector.<FilterFrameText>;
      
      private var _rule1:ScaleBitmapImage;
      
      private var _rule2:ScaleBitmapImage;
      
      private var _thisHeight:int;
      
      private var _playerInfo:PlayerInfo;
      
      private var _runeTipInfo:RuneSuitInfo;
      
      public function RuneTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
         this._rule1 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._rule2 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._tipTilte = ComponentFactory.Instance.creatComponentByStylename("SuidTips.title");
         this._StrengthenLevelTxt = ComponentFactory.Instance.creatComponentByStylename("SuidTips.StrengthenLevel");
         this._propVec = new Vector.<FilterFrameText>(8);
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            this._propVec[_loc1_] = ComponentFactory.Instance.creatComponentByStylename("SuidTips.propTxt");
            _loc1_++;
         }
         this._nextLevelTxt = ComponentFactory.Instance.creatComponentByStylename("SuidTips.NextTxt");
         this._nextPropVec = new Vector.<FilterFrameText>(8);
         var _loc2_:int = 0;
         while(_loc2_ < 8)
         {
            this._nextPropVec[_loc2_] = ComponentFactory.Instance.creatComponentByStylename("SuidTips.NextTxt");
            _loc2_++;
         }
         super.init();
         super.tipbackgound = this._bg;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._tipTilte);
         addChild(this._StrengthenLevelTxt);
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            addChild(this._propVec[_loc1_]);
            _loc1_++;
         }
         addChild(this._nextLevelTxt);
         var _loc2_:int = 0;
         while(_loc2_ < 8)
         {
            addChild(this._nextPropVec[_loc2_]);
            _loc2_++;
         }
         addChild(this._rule1);
         addChild(this._rule2);
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      override public function get tipData() : Object
      {
         return _tipData;
      }
      
      override public function set tipData(param1:Object) : void
      {
         if(param1)
         {
            this._playerInfo = param1 as PlayerInfo;
            this.visible = true;
            this._runeTipInfo = ItemManager.Instance.getRuneListByLevel(this._playerInfo.runeLevel);
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
         this.showMiddlePart();
         this.showButtomPart();
         this.upBackground();
      }
      
      private function showHeadPart() : void
      {
         this._tipTilte.text = LanguageMgr.GetTranslation("ddt.RuneTipPanel.title");
         this._rule1.x = this._tipTilte.x;
         this._rule1.y = this._tipTilte.y + this._tipTilte.textHeight + 12;
         this._thisHeight = this._rule1.y + this._rule1.height;
      }
      
      private function showMiddlePart() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this._playerInfo.runeLevel == 0)
         {
            this._StrengthenLevelTxt.visible = false;
            while(_loc3_ < 8)
            {
               this._propVec[_loc3_].visible = false;
               _loc3_++;
            }
            this._rule1.visible = false;
            this._rule2.x = this._tipTilte.x;
            this._rule2.y = this._tipTilte.y + this._tipTilte.textHeight + 12;
            this._thisHeight = this._rule2.y + this._rule2.height;
            return;
         }
         this._rule1.visible = true;
         var _loc1_:Array = new Array();
         this._StrengthenLevelTxt.text = LanguageMgr.GetTranslation("ddt.RuneTipPanel.EmbedLevelTxt",this._runeTipInfo.RuneCount,this._runeTipInfo.RuneLevel,this._runeTipInfo.RuneCount,this._runeTipInfo.RuneCount,this._runeTipInfo.RuneCount);
         this._StrengthenLevelTxt.y = this._rule1.y + this._rule1.height + 10;
         this._StrengthenLevelTxt.visible = true;
         if(this._runeTipInfo.Attack != 0)
         {
            _loc1_.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Attack",this._runeTipInfo.Attack));
         }
         if(this._runeTipInfo.Defence != 0)
         {
            _loc1_.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Defence",this._runeTipInfo.Defence));
         }
         if(this._runeTipInfo.Agility != 0)
         {
            _loc1_.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Agility",this._runeTipInfo.Agility));
         }
         if(this._runeTipInfo.Lucky != 0)
         {
            _loc1_.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Lucky",this._runeTipInfo.Lucky));
         }
         if(this._runeTipInfo.Guard != 0)
         {
            _loc1_.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Guard",this._runeTipInfo.Guard));
         }
         if(this._runeTipInfo.Damage != 0)
         {
            _loc1_.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Damage",this._runeTipInfo.Damage));
         }
         if(this._runeTipInfo.Blood != 0)
         {
            _loc1_.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Blood",this._runeTipInfo.Blood));
         }
         _loc2_ = 0;
         while(_loc2_ < 8)
         {
            if(_loc2_ < _loc1_.length)
            {
               this._propVec[_loc2_].text = _loc1_[_loc2_];
               this._propVec[_loc2_].y = this._StrengthenLevelTxt.y + this._StrengthenLevelTxt.textHeight + 8 + 20 * _loc2_;
               this._propVec[_loc2_].visible = true;
               this._rule2.x = this._propVec[_loc2_].x;
               this._rule2.y = this._propVec[_loc2_].y + this._propVec[_loc2_].textHeight + 12;
            }
            else
            {
               this._propVec[_loc2_].visible = false;
            }
            _loc2_++;
         }
         this._thisHeight = this._rule2.y + this._rule2.height;
      }
      
      private function showButtomPart() : void
      {
         var _loc2_:RuneSuitInfo = null;
         var _loc4_:int = 0;
         if(this._playerInfo.runeLevel == ItemManager.Instance.getRuneMaxLevel())
         {
            this._thisHeight = this._rule2.y + this._rule2.height - 10;
            this._nextLevelTxt.visible = false;
            this._rule2.visible = false;
            while(_loc4_ < 8)
            {
               this._nextPropVec[_loc4_].visible = false;
               _loc4_++;
            }
            return;
         }
         this._rule2.visible = true;
         var _loc1_:Array = new Array();
         _loc2_ = ItemManager.Instance.getRuneListByLevel(this._playerInfo.runeLevel + 1);
         this._nextLevelTxt.text = LanguageMgr.GetTranslation("ddt.RuneTipPanel.EmbedLevelTxt",_loc2_.RuneCount,_loc2_.RuneLevel,_loc2_.RuneCount,this.getNextRuneCount(_loc2_),_loc2_.RuneCount);
         if(_loc2_ == null)
         {
            return;
         }
         this._nextLevelTxt.visible = true;
         this._nextLevelTxt.y = this._rule2.y + this._rule2.height + 10;
         if(_loc2_.Attack != 0)
         {
            _loc1_.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Attack",_loc2_.Attack));
         }
         if(_loc2_.Defence != 0)
         {
            _loc1_.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Defence",_loc2_.Defence));
         }
         if(_loc2_.Agility != 0)
         {
            _loc1_.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Agility",_loc2_.Agility));
         }
         if(_loc2_.Lucky != 0)
         {
            _loc1_.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Lucky",_loc2_.Lucky));
         }
         if(_loc2_.Guard != 0)
         {
            _loc1_.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Guard",_loc2_.Guard));
         }
         if(_loc2_.Damage != 0)
         {
            _loc1_.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Damage",_loc2_.Damage));
         }
         if(_loc2_.Blood != 0)
         {
            _loc1_.push(LanguageMgr.GetTranslation("ddt.RuneTipPanel.Blood",_loc2_.Blood));
         }
         var _loc3_:int = 0;
         while(_loc3_ < 8)
         {
            if(_loc3_ < _loc1_.length)
            {
               this._nextPropVec[_loc3_].text = _loc1_[_loc3_];
               this._nextPropVec[_loc3_].visible = true;
               this._nextPropVec[_loc3_].y = this._nextLevelTxt.y + this._nextLevelTxt.textHeight + 8 + 20 * _loc3_;
               this._thisHeight = this._nextPropVec[_loc3_].y + this._nextPropVec[_loc3_].height;
            }
            else
            {
               this._nextPropVec[_loc3_].visible = false;
            }
            _loc3_++;
         }
      }
      
      private function getNextRuneCount(param1:RuneSuitInfo) : int
      {
         var _loc4_:ItemTemplateInfo = null;
         var _loc5_:ItemTemplateInfo = null;
         var _loc7_:int = 0;
         var _loc2_:int = param1.RuneLevel;
         var _loc3_:int = 0;
         var _loc6_:int = 0;
         while(_loc6_ <= 20)
         {
            _loc4_ = this._playerInfo.Bag.getItemAt(_loc6_);
            if(_loc4_)
            {
               _loc7_ = 1;
               while(_loc7_ < 5)
               {
                  if(_loc4_["Hole" + _loc7_] > 1)
                  {
                     _loc5_ = ItemManager.Instance.getTemplateById(_loc4_["Hole" + _loc7_]);
                     if(_loc5_ && int(_loc5_.Property1) >= _loc2_)
                     {
                        _loc3_++;
                     }
                  }
                  _loc7_++;
               }
            }
            _loc6_++;
         }
         return _loc3_;
      }
      
      private function upBackground() : void
      {
         this._bg.height = this._thisHeight + 13;
         this._bg.width = THISWIDTH;
         this.updateWH();
      }
      
      private function updateWH() : void
      {
         _width = this._bg.width;
         _height = this._bg.height;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         this._tipTilte = null;
         this._StrengthenLevelTxt = null;
         this._nextLevelTxt = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._propVec.length)
         {
            this._propVec[_loc1_] = null;
            _loc1_++;
         }
         this._propVec = null;
         var _loc2_:int = 0;
         while(_loc1_ < this._nextPropVec.length)
         {
            this._nextPropVec[_loc1_] = null;
            _loc1_++;
         }
         this._nextPropVec = null;
         this._rule1 = null;
         this._rule2 = null;
         this._playerInfo = null;
         this._runeTipInfo = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
