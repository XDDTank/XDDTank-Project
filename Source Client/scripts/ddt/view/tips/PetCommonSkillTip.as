package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PetSkillManager;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import pet.date.PetCommonSkill;
   
   public class PetCommonSkillTip extends BaseTip
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var name_txt:FilterFrameText;
      
      private var ballType_txt:FilterFrameText;
      
      private var _descLbl:FilterFrameText;
      
      private var _descTxt:FilterFrameText;
      
      private var _coolDownTxt:FilterFrameText;
      
      private var _splitImg:ScaleBitmapImage;
      
      private var _splitImg2:ScaleBitmapImage;
      
      private var _info:PetCommonSkill;
      
      private var _container:Sprite;
      
      private var _data;
      
      private var LEADING:int = 5;
      
      public function PetCommonSkillTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.name_txt = ComponentFactory.Instance.creat("petsBag.PetSkillCellTip.name");
         this.ballType_txt = ComponentFactory.Instance.creat("core.petskillTip.ballTypeTxt");
         this._descLbl = ComponentFactory.Instance.creat("petsBag.PetSkillCellTip.descLbl");
         this._descLbl.text = LanguageMgr.GetTranslation("ddt.pets.skillTipDesc");
         this._descTxt = ComponentFactory.Instance.creat("petsBag.PetSkillCellTip.descTxt");
         this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
         this._splitImg = ComponentFactory.Instance.creatComponentByStylename("petTips.line");
         this._container = new Sprite();
         this._container.addChild(this.name_txt);
         this._container.addChild(this.ballType_txt);
         this._container.addChild(this._descLbl);
         this._container.addChild(this._descTxt);
         this._container.addChild(this._splitImg);
         super.init();
         this.tipbackgound = this._bg;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._container);
         this._container.mouseEnabled = false;
         this._container.mouseChildren = false;
         this.mouseChildren = false;
         this.mouseEnabled = false;
      }
      
      override public function get tipData() : Object
      {
         return this._info;
      }
      
      override public function set tipData(param1:Object) : void
      {
         this._data = param1;
         this._info = param1 as PetCommonSkill;
         if(!this._info)
         {
            return;
         }
         this.updateView();
      }
      
      private function updateView() : void
      {
         var _loc1_:Dictionary = PetSkillManager.instance.getPreSkill(this._data);
         this.name_txt.text = this._info.Name;
         this._descTxt.text = "本级:" + _loc1_["c"].join(",");
         this._descTxt.text += "\t  下一级:" + _loc1_["n"].join(",");
         this._descTxt.text += "   是否学习:" + this.fixPos();
         this._bg.width = this._container.width + 15;
         this._bg.height = this._container.height + 15;
         _width = this._bg.width;
         _height = this._bg.height;
      }
      
      private function fixPos() : void
      {
         this.ballType_txt.x = this.name_txt.x;
         this.ballType_txt.y = this.name_txt.y + this.name_txt.textHeight + this.LEADING * 2;
         this._splitImg.y = this.ballType_txt.y + this.ballType_txt.textHeight + this.LEADING;
         this._descLbl.x = this.ballType_txt.x;
         this._descLbl.y = this._splitImg.y + this._splitImg.height + this.LEADING;
         this._descTxt.x = this._descLbl.x + this._descLbl.textWidth + this.LEADING;
         this._descTxt.y = this._descLbl.y;
      }
      
      override public function dispose() : void
      {
         this._info = null;
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
         if(this._descTxt)
         {
            ObjectUtils.disposeObject(this._descTxt);
            this._descTxt = null;
         }
         if(this._coolDownTxt)
         {
            ObjectUtils.disposeObject(this._coolDownTxt);
            this._coolDownTxt = null;
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
         if(this._descLbl)
         {
            ObjectUtils.disposeObject(this._descLbl);
            this._descLbl = null;
         }
         if(this.ballType_txt)
         {
            ObjectUtils.disposeObject(this.ballType_txt);
            this.ballType_txt = null;
         }
      }
   }
}
