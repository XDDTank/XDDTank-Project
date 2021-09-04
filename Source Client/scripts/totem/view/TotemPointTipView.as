package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.text.TextFormat;
   import totem.TotemManager;
   import totem.data.TotemDataVo;
   
   public class TotemPointTipView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Image;
      
      private var _seperateLine1:Image;
      
      private var _propertyNameTxt:FilterFrameText;
      
      private var _propertyValueTxt:FilterFrameText;
      
      private var _possibleNameTxt:FilterFrameText;
      
      private var _possibleValueTxt:FilterFrameText;
      
      private var _needGradeTxt:FilterFrameText;
      
      private var _propertyValueList:Array;
      
      private var _possibleValeList:Array;
      
      private var _propertyValueTextFormatList:Vector.<TextFormat>;
      
      private var _propertyValueGlowFilterList:Vector.<GlowFilter>;
      
      private var _possibleValueTxtColorList:Array;
      
      private var _honorExpSprite:Sprite;
      
      private var _honorTxt:FilterFrameText;
      
      private var _expTxt:FilterFrameText;
      
      private var _statusValueList:Array;
      
      private var _tipPosFix:Point;
      
      private var _seperateLine1Pos1:Point;
      
      public function TotemPointTipView()
      {
         this._possibleValueTxtColorList = [16752450,9634815,35314,9035310,16727331];
         super();
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this.initData();
         this.initView();
      }
      
      private function initData() : void
      {
         this._propertyValueTextFormatList = new Vector.<TextFormat>();
         this._propertyValueGlowFilterList = new Vector.<GlowFilter>();
         var _loc1_:int = 1;
         while(_loc1_ <= 7)
         {
            this._propertyValueTextFormatList.push(ComponentFactory.Instance.model.getSet("totem.totemWindow.propertyName" + _loc1_ + ".tf"));
            this._propertyValueGlowFilterList.push(ComponentFactory.Instance.model.getSet("totem.totemWindow.propertyName" + _loc1_ + ".gf"));
            _loc1_++;
         }
         this._propertyValueList = LanguageMgr.GetTranslation("ddt.totem.sevenProperty").split(",");
         this._possibleValeList = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.possibleValueTxt").split(",");
         this._statusValueList = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.statusValueTxt").split(",");
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
         this._seperateLine1 = ComponentFactory.Instance.creatComponentByStylename("totemTIPSeprateLine");
         this._propertyNameTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.propertyNameTxt");
         this._propertyNameTxt.text = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.propertyNameTxt");
         this._propertyValueTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.propertyValueTxt");
         this._possibleNameTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.possibleNameTxt");
         this._possibleNameTxt.text = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.possibleNameTxt");
         this._possibleValueTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.possibleValueTxt");
         this._needGradeTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.needGradeTxt");
         this._honorExpSprite = ComponentFactory.Instance.creatCustomObject("totem.totemPointTip.honorExpSprite");
         this._honorTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.honor");
         this._expTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.exp");
         this._honorExpSprite.addChild(this._needGradeTxt);
         this._honorExpSprite.addChild(this._honorTxt);
         this._honorExpSprite.addChild(this._expTxt);
         this._tipPosFix = ComponentFactory.Instance.creatCustomObject("totem.totemTipAreaFix");
         this._seperateLine1Pos1 = ComponentFactory.Instance.creatCustomObject("totem.totemTip.seperateLine1Pos1");
         addChild(this._bg);
         addChild(this._seperateLine1);
         addChild(this._propertyNameTxt);
         addChild(this._propertyValueTxt);
         addChild(this._possibleNameTxt);
         addChild(this._possibleValueTxt);
         addChild(this._honorExpSprite);
      }
      
      public function show(param1:TotemDataVo, param2:Boolean, param3:Boolean) : void
      {
         this.showStatus1();
         var _loc4_:int = param1.Location;
         var _loc5_:int = TotemManager.instance.getAddValue(_loc4_,TotemManager.instance.getAddInfo(TotemManager.instance.getTotemPointLevel(PlayerManager.Instance.Self.totemId) + 7));
         this._propertyValueTxt.text = this._propertyValueList[_loc4_ - 1] + "+" + _loc5_;
         this._propertyValueTxt.setTextFormat(this._propertyValueTextFormatList[_loc4_ - 1]);
         this._propertyValueTxt.filters = [this._propertyValueGlowFilterList[_loc4_ - 1]];
         var _loc6_:int = param1.Random;
         if(_loc6_ >= 100)
         {
            _loc4_ = 0;
         }
         else if(_loc6_ >= 80 && _loc6_ < 100)
         {
            _loc4_ = 1;
         }
         else if(_loc6_ >= 40 && _loc6_ < 80)
         {
            _loc4_ = 2;
         }
         else if(_loc6_ >= 20 && _loc6_ < 40)
         {
            _loc4_ = 3;
         }
         else
         {
            _loc4_ = 4;
         }
         this._possibleValueTxt.text = this._possibleValeList[_loc4_];
         this._possibleValueTxt.setTextFormat(new TextFormat(null,null,this._possibleValueTxtColorList[_loc4_]));
         this._honorTxt.text = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.honorTxt",param1.ConsumeHonor);
         this._expTxt.text = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.expTxt",param1.ConsumeExp);
         this._needGradeTxt.text = LanguageMgr.GetTranslation("ddt.totem.needGradeTxt",param1.needGrade);
         if(PlayerManager.Instance.Self.Grade < param1.needGrade)
         {
            this._needGradeTxt.setTextFormat(new TextFormat(null,null,16711680));
         }
         if(PlayerManager.Instance.Self.totemScores < param1.ConsumeHonor)
         {
            this._honorTxt.setTextFormat(new TextFormat(null,null,16711680));
         }
         if(TotemManager.instance.usableGP < param1.ConsumeExp)
         {
            this._expTxt.setTextFormat(new TextFormat(null,null,16711680));
         }
         this._bg.width = this._seperateLine1.x + this._seperateLine1.width + this._tipPosFix.x;
         this._bg.height = this._honorExpSprite.y + this._honorExpSprite.height + this._tipPosFix.y;
      }
      
      private function showStatus1() : void
      {
         this._possibleNameTxt.text = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.possibleNameTxt");
         this._honorExpSprite.visible = true;
         this._needGradeTxt.visible = true;
         DisplayUtils.setDisplayPos(this._seperateLine1,this._seperateLine1Pos1);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._needGradeTxt = null;
         this._propertyNameTxt = null;
         this._propertyValueTxt = null;
         this._possibleNameTxt = null;
         this._possibleValueTxt = null;
         this._propertyValueList = null;
         this._possibleValeList = null;
         this._propertyValueTextFormatList = null;
         this._propertyValueGlowFilterList = null;
         ObjectUtils.disposeObject(this._honorTxt);
         this._honorTxt = null;
         ObjectUtils.disposeObject(this._expTxt);
         this._expTxt = null;
         this._honorExpSprite = null;
         this._statusValueList = null;
         this._possibleValueTxtColorList = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
