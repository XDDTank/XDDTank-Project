package petsBag.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TaskManager;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.OneLineTip;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import pet.date.PetInfo;
   import pet.date.PetSkillTemplateInfo;
   import petsBag.data.PetSkillItemInfo;
   import petsBag.event.PetSkillEvent;
   import petsBag.view.item.PetSkillLevelUpItem;
   import road7th.data.DictionaryData;
   
   public class PetSkillFrame extends PetRightBaseFrame
   {
      
      public static const SKILL_COUNT:int = 9;
       
      
      private var _bg2:Bitmap;
      
      private var _soulValueTxt:FilterFrameText;
      
      private var _soulTipArea:Sprite;
      
      private var _skillList:Vector.<PetSkillLevelUpItem>;
      
      private var _learnSkillTips:MovieClip;
      
      private var _mouseTip:OneLineTip;
      
      private var _titleBmp:Bitmap;
      
      private var _soulIcon:MovieClip;
      
      public function PetSkillFrame()
      {
         super();
         this.initEvent();
      }
      
      override protected function init() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:Point = null;
         super.init();
         this._titleBmp = ComponentFactory.Instance.creatBitmap("asset.petskill.title");
         addToContent(this._titleBmp);
         this._bg2 = ComponentFactory.Instance.creatBitmap("asset.petsBag.petSkillFrame.bg");
         addToContent(this._bg2);
         this._soulValueTxt = ComponentFactory.Instance.creat("petsBag.petSkillFrame.soulValuetxt");
         addToContent(this._soulValueTxt);
         this._soulIcon = ComponentFactory.Instance.creat("asset.newpetsbag.soul");
         addToContent(this._soulIcon);
         PositionUtils.setPos(this._soulIcon,"asset.newpetsbag.soulPos");
         this.createSkillList();
         if(!SavePointManager.Instance.savePoints[72] && TaskManager.instance.isAchieved(TaskManager.instance.getQuestByID(591)))
         {
            this._learnSkillTips = ClassUtils.CreatInstance("asset.trainer.clickToLearnSkill") as MovieClip;
            _loc2_ = ComponentFactory.Instance.creatCustomObject("trainer.learnPetSkill");
            this._learnSkillTips.x = _loc2_.x;
            this._learnSkillTips.y = _loc2_.y;
            _container.addChild(this._learnSkillTips);
         }
         _loc1_ = ComponentFactory.Instance.creat("petsBag.petSkillView.soulTipRect");
         this._soulTipArea = new Sprite();
         this._soulTipArea.graphics.beginFill(16711680,0);
         this._soulTipArea.graphics.drawRect(_loc1_.x,_loc1_.y,_loc1_.width,_loc1_.height);
         addToContent(this._soulTipArea);
         this._mouseTip = new OneLineTip();
         this._mouseTip.tipData = LanguageMgr.GetTranslation("petsBag.view.petSkillFrame.soulTipTxt");
         this._mouseTip.x = _loc1_.x;
         this._mouseTip.y = _loc1_.y + _loc1_.height;
         this._mouseTip.visible = false;
         addToContent(this._mouseTip);
      }
      
      private function initEvent() : void
      {
         this._soulTipArea.addEventListener(MouseEvent.ROLL_OVER,this.__mouseOver);
         this._soulTipArea.addEventListener(MouseEvent.ROLL_OUT,this.__mouseOut);
      }
      
      private function removeEvent() : void
      {
         this._soulTipArea.removeEventListener(MouseEvent.ROLL_OVER,this.__mouseOver);
         this._soulTipArea.removeEventListener(MouseEvent.ROLL_OUT,this.__mouseOut);
      }
      
      protected function __mouseOver(param1:MouseEvent) : void
      {
         this._mouseTip.visible = true;
      }
      
      protected function __mouseOut(param1:MouseEvent) : void
      {
         this._mouseTip.visible = false;
      }
      
      protected function createSkillList() : void
      {
         var _loc1_:PetSkillLevelUpItem = null;
         this._skillList = new Vector.<PetSkillLevelUpItem>();
         var _loc2_:int = 1;
         while(_loc2_ <= SKILL_COUNT)
         {
            _loc1_ = ComponentFactory.Instance.creat("petsBag.petSkillView.skillItem" + _loc2_,[_loc2_]);
            _loc1_.addEventListener(PetSkillEvent.UPGRADE,this.__itemClick);
            addToContent(_loc1_);
            this._skillList.push(_loc1_);
            _loc2_++;
         }
      }
      
      protected function __itemClick(param1:PetSkillEvent) : void
      {
         param1.stopImmediatePropagation();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._learnSkillTips)
         {
            this._learnSkillTips.parent.removeChild(this._learnSkillTips);
            this._learnSkillTips = null;
         }
         if(!SavePointManager.Instance.savePoints[72])
         {
            SavePointManager.Instance.setSavePoint(72);
         }
         var _loc2_:PetSkillTemplateInfo = param1.data;
         if(_loc2_)
         {
            SocketManager.Instance.out.sendPetSkillUp(_info.Place,_loc2_.SkillID,_loc2_.SkillPlace);
         }
      }
      
      override public function reset() : void
      {
         var _loc1_:PetSkillLevelUpItem = null;
         for each(_loc1_ in this._skillList)
         {
            _loc1_.reset();
         }
      }
      
      override public function set info(param1:PetInfo) : void
      {
         var _loc4_:int = 0;
         var _loc5_:PetSkillItemInfo = null;
         _info = param1;
         this._soulValueTxt.text = String(PlayerManager.Instance.Self.magicSoul);
         var _loc2_:DictionaryData = _info.skills;
         var _loc3_:int = 1;
         while(_loc3_ <= SKILL_COUNT)
         {
            if(_loc2_[_loc3_])
            {
               _loc4_ = _loc2_[_loc3_];
            }
            else
            {
               _loc4_ = PetSkillManager.instance.getSkillID(_loc3_,_info.KindID);
            }
            _loc5_ = new PetSkillItemInfo();
            _loc5_.skillID = _loc4_;
            _loc5_.petInfo = _info;
            this._skillList[_loc3_ - 1].info = _loc5_;
            _loc3_++;
         }
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg2);
         this._bg2 = null;
         ObjectUtils.disposeObject(this._soulValueTxt);
         this._soulValueTxt = null;
         ObjectUtils.disposeObject(this._soulIcon);
         this._soulIcon = null;
         while(this._skillList.length > 0)
         {
            this._skillList.shift().dispose();
         }
         ObjectUtils.disposeObject(this._soulTipArea);
         this._soulTipArea = null;
         ObjectUtils.disposeObject(this._mouseTip);
         this._mouseTip = null;
         this._skillList = null;
         if(this._titleBmp)
         {
            ObjectUtils.disposeObject(this._titleBmp);
         }
         this._titleBmp = null;
         super.dispose();
      }
   }
}
