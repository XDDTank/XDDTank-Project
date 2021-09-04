package petsBag.view.item
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.display.BitmapLoaderProxy;
   import ddt.manager.PathManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   import pet.date.PetSkillTemplateInfo;
   import petsBag.data.PetSkillItemInfo;
   import petsBag.event.PetSkillEvent;
   
   public class PetSkillLevelUpItem extends Component
   {
       
      
      private var _container:Sprite;
      
      private var _bg:ScaleFrameImage;
      
      private var _levelBg:Bitmap;
      
      private var _upgradeButton:BaseButton;
      
      private var _leveltxt:FilterFrameText;
      
      private var _skillIcon:BitmapLoaderProxy;
      
      private var _templeteInfo:PetSkillTemplateInfo;
      
      private var _info:PetSkillItemInfo;
      
      private var _shine:MovieClip;
      
      private var _grayFilter:Array;
      
      private var _place:int;
      
      private var _lastLevel:int = -1;
      
      private var _lastSkill:PetSkillTemplateInfo;
      
      private var _lastClickTime:uint;
      
      public function PetSkillLevelUpItem(param1:int)
      {
         this._place = param1;
         super();
         this.initEvent();
      }
      
      override protected function init() : void
      {
         this._container = new Sprite();
         addChild(this._container);
         this._bg = ComponentFactory.Instance.creat("petsBag.petSkillFrame.skillItem.bg");
         this._bg.setFrame(2);
         this._container.addChild(this._bg);
         this._levelBg = ComponentFactory.Instance.creat("asset.petsBag.petSkillFrame.skillLevelBg");
         addChild(this._levelBg);
         this._leveltxt = ComponentFactory.Instance.creat("petsBag.petSkillFrame.skillItem.levelTxt");
         addChild(this._leveltxt);
         this._upgradeButton = ComponentFactory.Instance.creat("petsBag.petSkillFrame.skillItem.upgradeBtn");
         addChild(this._upgradeButton);
         this._grayFilter = ComponentFactory.Instance.creatFilters("grayFilter");
         tipStyle = "ddt.view.tips.PetSkillTip";
         tipDirctions = "5,7,4,6";
         _width = 44;
         _height = 44;
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__click);
      }
      
      protected function __click(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         if(getTimer() - this._lastClickTime < 300)
         {
            return;
         }
         this._lastClickTime = getTimer();
         if(this._upgradeButton.visible)
         {
            SoundManager.instance.play("008");
            dispatchEvent(new PetSkillEvent(PetSkillEvent.UPGRADE,this._templeteInfo));
         }
      }
      
      public function get isLearning() : Boolean
      {
         return this._info.petInfo.skills[this._templeteInfo.SkillPlace];
      }
      
      public function get info() : PetSkillItemInfo
      {
         return this._info;
      }
      
      public function set info(param1:PetSkillItemInfo) : void
      {
         this._info = param1;
         this._templeteInfo = PetSkillManager.instance.getTemplateInfoByID(this._info.skillID);
         ShowTipManager.Instance.removeTip(this);
         if(!this._templeteInfo)
         {
            return;
         }
         if(!this._lastSkill || this._lastSkill.skillInfo.Pic != this._templeteInfo.skillInfo.Pic)
         {
            ObjectUtils.disposeObject(this._skillIcon);
            this._bg.setFrame(this._info.skillID < 1000 ? int(1) : int(2));
            this._skillIcon = new BitmapLoaderProxy(PathManager.solveSkillPicUrl(this._templeteInfo.skillInfo.Pic),new Rectangle(0,0,44,44));
            this._container.addChildAt(this._skillIcon,1);
         }
         this._leveltxt.text = [this._templeteInfo.SkillLevel,this._templeteInfo.SkillMaxLevel].join("/");
         this._levelBg.visible = this._leveltxt.visible = this.isLearning;
         this._container.filters = !!this.isLearning ? null : this._grayFilter;
         this._upgradeButton.visible = PetSkillManager.instance.checkCanUpgrade(this._info.skillID,this._info.petInfo);
         if(this._lastSkill && this.isLearning && this._templeteInfo.SkillLevel == this._lastLevel + 1)
         {
            if(!this._shine)
            {
               this._shine = ComponentFactory.Instance.creat("petsBag.petSkillView.skillItem.shine");
               this._container.addChild(this._shine);
            }
            this._shine.play();
         }
         this._lastLevel = !!this.isLearning ? int(this._templeteInfo.SkillLevel) : int(0);
         this._lastSkill = this._templeteInfo;
         tipData = this._info;
         ShowTipManager.Instance.addTip(this);
      }
      
      public function reset() : void
      {
         this._lastLevel = -1;
         if(this._shine)
         {
            this._shine.gotoAndStop(1);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeObject(this._container);
         this._container = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._levelBg);
         this._levelBg = null;
         ObjectUtils.disposeObject(this._upgradeButton);
         this._upgradeButton = null;
         ObjectUtils.disposeObject(this._leveltxt);
         this._leveltxt = null;
         ObjectUtils.disposeObject(this._skillIcon);
         this._skillIcon = null;
         ObjectUtils.disposeObject(this._shine);
         this._shine = null;
         this._templeteInfo = null;
         this._info = null;
         this._grayFilter.length = 0;
         this._grayFilter = null;
      }
   }
}
