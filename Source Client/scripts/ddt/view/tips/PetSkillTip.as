package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
   import flash.display.DisplayObject;
   import pet.date.PetBaseSkillInfo;
   import pet.date.PetSkillTemplateInfo;
   import petsBag.data.PetSkillItemInfo;
   
   public class PetSkillTip extends BaseTip
   {
      
      public static const ALERT_COLOR:String = "#ff0000";
      
      public static const NORMAL_COLOR:String = "#ffffff";
       
      
      private var _bg:ScaleBitmapImage;
      
      private var name_txt:FilterFrameText;
      
      private var ballType_txt:FilterFrameText;
      
      private var _container:VBox;
      
      private var _list:Array;
      
      private var _current:HBox;
      
      private var _next:HBox;
      
      private var _needLevel:FilterFrameText;
      
      private var _needSoul:FilterFrameText;
      
      private var _needPreSkill:FilterFrameText;
      
      private var _splitImg:ScaleBitmapImage;
      
      private var _splitImg2:ScaleBitmapImage;
      
      private var _skillInfo:PetSkillItemInfo;
      
      public function PetSkillTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
         this._list = [];
         addChild(this._bg);
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      override public function get tipData() : Object
      {
         return this._skillInfo;
      }
      
      override public function set tipData(param1:Object) : void
      {
         this._skillInfo = param1 as PetSkillItemInfo;
         if(!this._skillInfo)
         {
            return;
         }
         this.updateView();
      }
      
      private function createDescribe(param1:PetSkillItemInfo) : void
      {
         var _loc3_:FilterFrameText = null;
         var _loc4_:FilterFrameText = null;
         var _loc7_:PetBaseSkillInfo = null;
         var _loc2_:PetBaseSkillInfo = PetSkillManager.instance.getSkillBaseInfo(param1.skillID);
         var _loc5_:Boolean = Boolean(param1.petInfo.skills[PetSkillManager.instance.getTemplateInfoByID(param1.skillID).SkillPlace]);
         if(_loc5_)
         {
            this._current = new HBox();
            _loc3_ = ComponentFactory.Instance.creat("petsBag.petSkillTip.currentleftTxt");
            _loc3_.htmlText = LanguageMgr.GetTranslation("ddt.view.tips.petSkillTip.current");
            this._current.addChild(_loc3_);
            _loc4_ = ComponentFactory.Instance.creat("petsBag.petSkillTip.currentrightTxt");
            _loc4_.htmlText = _loc2_.Decription;
            _loc4_.height = _loc4_.textWidth + 10;
            this._current.addChild(_loc4_);
            this._list.push(this._current);
         }
         this._next = new HBox();
         _loc3_ = ComponentFactory.Instance.creat("petsBag.petSkillTip.nextTxtLeft");
         _loc3_.htmlText = LanguageMgr.GetTranslation("ddt.view.tips.petSkillTip.next");
         this._next.addChild(_loc3_);
         _loc4_ = ComponentFactory.Instance.creat("petsBag.petSkillTip.nextRightTxt");
         var _loc6_:int = !!_loc5_ ? int(PetSkillManager.instance.getTemplateInfoByID(param1.skillID).NextSkillId) : int(param1.skillID);
         if(_loc6_ < 0)
         {
            _loc4_.htmlText = LanguageMgr.GetTranslation("ddt.view.tips.petSkillTip.nextMAX");
         }
         else
         {
            _loc7_ = PetSkillManager.instance.getSkillBaseInfo(_loc6_);
            _loc4_.htmlText = _loc7_.Decription;
         }
         _loc4_.height = _loc4_.textWidth + 10;
         this._next.addChild(_loc4_);
         this._list.push(this._next);
      }
      
      private function createCondition(param1:PetSkillItemInfo) : void
      {
         var _loc2_:PetSkillTemplateInfo = null;
         var _loc4_:Boolean = false;
         var _loc7_:String = null;
         var _loc3_:PetSkillTemplateInfo = PetSkillManager.instance.getTemplateInfoByID(param1.skillID);
         if(this._skillInfo.petInfo.skills[_loc3_.SkillPlace])
         {
            _loc2_ = PetSkillManager.instance.getTemplateInfoByID(_loc3_.NextSkillId);
         }
         else
         {
            _loc2_ = _loc3_;
         }
         if(!_loc2_)
         {
            return;
         }
         this._splitImg2 = ComponentFactory.Instance.creatComponentByStylename("petsBag.petSkillTip.line");
         this._list.push(this._splitImg2);
         _loc4_ = _loc2_.MinLevel > param1.petInfo.Level;
         this._needLevel = ComponentFactory.Instance.creat("petsBag.petSkillTip.normalTxt");
         this._needLevel.htmlText = LanguageMgr.GetTranslation("ddt.view.tips.petSkillTip.needLevel",!!_loc4_ ? ALERT_COLOR : NORMAL_COLOR,_loc2_.MinLevel);
         this._list.push(this._needLevel);
         _loc4_ = _loc2_.MagicSoul > PlayerManager.Instance.Self.magicSoul;
         this._needSoul = ComponentFactory.Instance.creat("petsBag.petSkillTip.normalTxt");
         this._needSoul.htmlText = LanguageMgr.GetTranslation("ddt.view.tips.petSkillTip.needSoul",!!_loc4_ ? ALERT_COLOR : NORMAL_COLOR,_loc2_.MagicSoul);
         this._list.push(this._needSoul);
         var _loc5_:Array = _loc2_.BeforeSkillId.split(",");
         var _loc6_:int = int.MAX_VALUE;
         for each(_loc7_ in _loc5_)
         {
            if(_loc7_.length != 0)
            {
               if(_loc6_ > int(_loc7_))
               {
                  _loc6_ = int(_loc7_);
               }
            }
         }
         if(_loc6_ > 0)
         {
            _loc4_ = !PetSkillManager.instance.checkBeforeSkill(_loc2_,this._skillInfo.petInfo);
            this._needPreSkill = ComponentFactory.Instance.creat("petsBag.petSkillTip.normalTxt");
            this._needPreSkill.htmlText = LanguageMgr.GetTranslation("ddt.view.tips.petSkillTip.needSkill",!!_loc4_ ? ALERT_COLOR : NORMAL_COLOR,PetSkillManager.instance.getSkillBaseInfo(_loc6_).Name);
            this._list.push(this._needPreSkill);
         }
      }
      
      private function updateView() : void
      {
         var _loc3_:DisplayObject = null;
         while(this._list.length > 0)
         {
            this._list.shift().dispose();
         }
         this._list = [];
         ObjectUtils.disposeObject(this._container);
         var _loc1_:PetBaseSkillInfo = PetSkillManager.instance.getSkillBaseInfo(this._skillInfo.skillID);
         this.name_txt = ComponentFactory.Instance.creat("petsBag.petSkillTip.nameTxt");
         this.name_txt.text = _loc1_.Name;
         this._list.push(this.name_txt);
         this.ballType_txt = ComponentFactory.Instance.creat("petsBag.petSkillTip.normalTxt");
         this.ballType_txt.text = LanguageMgr.GetTranslation("ddt.view.tips.petSkillTip.skillType" + (this._skillInfo.skillID < 1000 ? 0 : 1));
         this._list.push(this.ballType_txt);
         this._splitImg = ComponentFactory.Instance.creatComponentByStylename("petsBag.petSkillTip.line");
         this._list.push(this._splitImg);
         this.createDescribe(this._skillInfo);
         this.createCondition(this._skillInfo);
         this._container = ComponentFactory.Instance.creat("petsBag.petSkillTip.vbox");
         addChild(this._container);
         var _loc2_:int = 0;
         while(_loc2_ < this._list.length)
         {
            _loc3_ = this._list[_loc2_];
            this._container.addChild(_loc3_);
            _loc2_++;
         }
         this._bg.width = this._container.width + 20;
         this._bg.height = this._container.height + 20;
         _width = this._bg.width;
         _height = this._bg.height;
      }
      
      override public function dispose() : void
      {
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(this._container)
         {
            ObjectUtils.disposeObject(this._container);
            this._container = null;
         }
         if(this._splitImg)
         {
            ObjectUtils.disposeObject(this._splitImg);
            this._splitImg = null;
         }
         if(this.name_txt)
         {
            ObjectUtils.disposeObject(this.name_txt);
            this.name_txt = null;
         }
         if(this._splitImg2)
         {
            ObjectUtils.disposeObject(this._splitImg2);
            this._splitImg2 = null;
         }
         if(this.ballType_txt)
         {
            ObjectUtils.disposeObject(this.ballType_txt);
            this.ballType_txt = null;
         }
      }
   }
}
