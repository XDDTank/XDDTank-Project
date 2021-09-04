package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.ui.tip.ITip;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortionNewSkillInfo;
   
   public class SkillTipPanel extends BaseTip implements Disposeable, ITip
   {
      
      public static const THISWIDTH:int = 200;
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _rule1:ScaleBitmapImage;
      
      private var _rule2:ScaleBitmapImage;
      
      private var _buffName:FilterFrameText;
      
      private var _descriptionTxt:FilterFrameText;
      
      private var _needsTxt:Vector.<FilterFrameText>;
      
      private var _info:ConsortionNewSkillInfo;
      
      private var _thisHeight:int;
      
      private var _needArr:Array;
      
      public function SkillTipPanel()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
         this._rule1 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._rule2 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._needArr = new Array();
         this._needsTxt = new Vector.<FilterFrameText>(4);
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            this._needsTxt[_loc1_] = ComponentFactory.Instance.creatComponentByStylename("SkillTip.NeedsTxt");
            _loc1_++;
         }
         this._buffName = ComponentFactory.Instance.creatComponentByStylename("SkillTip.BuffnameTxt");
         this._descriptionTxt = ComponentFactory.Instance.creatComponentByStylename("SkillTip.DescriptionTxt");
         super.init();
         super.tipbackgound = this._bg;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            addChild(this._needsTxt[_loc1_]);
            _loc1_++;
         }
         addChild(this._buffName);
         addChild(this._descriptionTxt);
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
         if(param1 is ConsortionNewSkillInfo)
         {
            this._info = param1 as ConsortionNewSkillInfo;
            this.visible = true;
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
         this._buffName.text = this._info.BuffName;
         this._rule1.x = this._buffName.x;
         this._rule1.y = this._buffName.y + this._buffName.textHeight + 8;
         this._thisHeight = this._rule1.y + this._rule1.height;
      }
      
      private function showMiddlePart() : void
      {
         this._descriptionTxt.text = this._info.Description;
         this._descriptionTxt.y = this._rule1.y + 8;
         this._thisHeight = this._descriptionTxt.y + this._descriptionTxt.textHeight;
      }
      
      private function showButtomPart() : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:ConsortionNewSkillInfo = ConsortionModelControl.Instance.model.getInfoByBuffId(this._info.BuffID - 1);
         _loc2_ = new Array();
         if(ConsortionModelControl.Instance.model.getisLearnByBuffId(this._info.BuffID))
         {
            while(_loc3_ < 4)
            {
               this._needsTxt[_loc3_].visible = false;
               _loc3_++;
            }
            this._rule2.visible = false;
         }
         else
         {
            this._rule2.x = this._rule1.x;
            this._rule2.visible = true;
            this._rule2.y = this._descriptionTxt.y + this._descriptionTxt.textHeight + 8;
            _loc2_.push("需要贡献度" + this._info.NeedDevote.toString());
            if(ConsortionModelControl.Instance.model.getisUpgradeByType(0,this._info.BuffID))
            {
               _loc2_.push("需要技能研究院" + this._info.BuildLevel.toString() + "级");
            }
            if(ConsortionModelControl.Instance.model.getisUpgradeByType(1,this._info.BuffID))
            {
               _loc2_.push("需要人物" + this._info.NeedLevel.toString() + "级");
            }
            if(ConsortionModelControl.Instance.model.getisUpgradeByType(3,this._info.BuffID))
            {
               _loc2_.push("需要已学会" + _loc1_.BuffName);
            }
            _loc4_ = 0;
            while(_loc4_ < this._needsTxt.length)
            {
               if(_loc4_ < _loc2_.length)
               {
                  this._needsTxt[_loc4_].text = _loc2_[_loc4_];
                  if(_loc4_ == 0)
                  {
                     if(!ConsortionModelControl.Instance.model.getisUpgradeByType(2,this._info.BuffID))
                     {
                        this._needsTxt[_loc4_].textColor = 16777215;
                     }
                     else
                     {
                        this._needsTxt[_loc4_].textColor = 16711680;
                     }
                  }
                  this._needsTxt[_loc4_].visible = true;
                  this._needsTxt[_loc4_].y = this._rule2.y + this._rule2.height + 8 + 24 * _loc4_;
                  this._thisHeight = this._needsTxt[_loc4_].y + this._needsTxt[_loc4_].textHeight;
               }
               else
               {
                  this._needsTxt[_loc4_].visible = false;
               }
               _loc4_++;
            }
         }
      }
      
      private function setVisible() : void
      {
      }
      
      private function upBackground() : void
      {
         this._bg.height = this._thisHeight + 10;
         this._bg.width = THISWIDTH;
         _width = this._bg.width;
         _height = this._bg.height;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            this._needsTxt[_loc1_] = null;
            _loc1_++;
         }
         this._needsTxt = null;
         this._needArr = null;
         this._rule1 = null;
         this._rule2 = null;
         this._info = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
