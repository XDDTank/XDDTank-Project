package game.view.prop
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.display.BitmapLoaderProxy;
   import ddt.manager.PathManager;
   import ddt.view.tips.ToolPropInfo;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import pet.date.PetSkillInfo;
   
   public class PetSkillCell extends PropCell
   {
       
      
      private var _skill:PetSkillInfo;
      
      private var _turnNum:int = 0;
      
      private var _tempPic:Sprite;
      
      private var _skillPic:BitmapLoaderProxy;
      
      private var _lockBg:Bitmap;
      
      private var _normHeight:Number;
      
      private var _normWidth:Number;
      
      private var _skillPicWidth:Number = 33;
      
      private var _skillPicHeight:Number = 33;
      
      private var _shineMC:MovieClip;
      
      public function PetSkillCell(param1:String = null, param2:int = -1, param3:Boolean = false, param4:Number = 0, param5:Number = 0)
      {
         super(param1,param2,param3);
         this.setGrayFilter();
         this._normWidth = param4;
         this._normHeight = param5;
      }
      
      override public function get tipStyle() : String
      {
         return "ddt.view.tips.PetSkillCellTip";
      }
      
      override public function get tipData() : Object
      {
         return this._skill;
      }
      
      private function creatTempSprite() : void
      {
         this._tempPic = new Sprite();
         this._tempPic.graphics.beginFill(16777215,0.1);
         this._tempPic.graphics.drawRect(0,0,this._skillPicWidth,this._skillPicHeight);
         this._tempPic.graphics.endFill();
         addChild(this._tempPic);
      }
      
      public function creteSkillCell(param1:PetSkillInfo, param2:Boolean = false) : void
      {
         ShowTipManager.Instance.removeTip(this);
         this._skill = param1;
         if(this._skill && this._skill.ID > 0)
         {
            this.creatTempSprite();
            this._skillPic = new BitmapLoaderProxy(PathManager.solveSkillPicUrl(this._skill.Pic),new Rectangle(0,0,this._skillPicWidth,this._skillPicHeight));
            addChild(this._skillPic);
            ShowTipManager.Instance.addTip(this);
            this._turnNum = this._skill.ColdDown;
            buttonMode = true;
         }
         else
         {
            _fore = _bitmapMgr.creatBitmapShape("asset.game.petSkillBarCellBg",null,false,true);
            addChild(_fore);
            buttonMode = false;
            _tipInfo = null;
         }
         if(param2)
         {
            this.drawLockBg();
         }
         this.shortcutKeyConfigUI();
         this.positionAdjust();
      }
      
      private function positionAdjust() : void
      {
         if(this._skillPic)
         {
            if(this._normWidth > 0)
            {
               this._skillPic.x = (this._normWidth - this._skillPicWidth) / 2;
            }
            if(this._normHeight > 0)
            {
               this._skillPic.y = (this._normHeight - this._skillPicHeight) / 2;
            }
         }
         if(_shortcutKeyShape && this._skillPic)
         {
            _shortcutKeyShape.x = this._skillPic.x;
            _shortcutKeyShape.y = this._skillPic.y;
         }
         if(_fore)
         {
            if(this._normWidth > 0)
            {
               _fore.x = (this._normWidth - this._skillPicWidth) / 2;
            }
            if(this._normHeight > 0)
            {
               _fore.y = (this._normHeight - this._skillPicHeight) / 2;
            }
         }
      }
      
      private function drawLockBg() : void
      {
         if(!this._skill && !this._lockBg)
         {
            this._lockBg = ComponentFactory.Instance.creatBitmap("asset.game.petSkillLockBg");
            addChild(this._lockBg);
         }
      }
      
      override protected function configUI() : void
      {
         _tipInfo = new ToolPropInfo();
         _tipInfo.showThew = true;
      }
      
      private function shortcutKeyConfigUI() : void
      {
         this._shineMC = ClassUtils.CreatInstance("asset.bossplayer.flashMC");
         this._shineMC.visible = false;
         this._shineMC.stop();
         addChild(this._shineMC);
         if(_shortcutKey != null && _shortcutKeyShape == null)
         {
            if(this._skill && this._skill.isActiveSkill || !this._skill)
            {
               _shortcutKeyShape = ComponentFactory.Instance.creatBitmap("asset.game.prop.ShortcutKey" + _shortcutKey);
               Bitmap(_shortcutKeyShape).smoothing = true;
               _shortcutKeyShape.y = -2;
               addChild(_shortcutKeyShape);
               drawLayer();
            }
            else
            {
               _shortcutKey = null;
            }
         }
      }
      
      public function shine() : void
      {
         this._shineMC.visible = true;
         this._shineMC.play();
      }
      
      public function stopShine() : void
      {
         this._shineMC.visible = false;
         this._shineMC.stop();
      }
      
      public function get skillInfo() : PetSkillInfo
      {
         return this._skill;
      }
      
      public function get isEnabled() : Boolean
      {
         if(this._skill && this._skill.isActiveSkill)
         {
            return true;
         }
         return false;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ShowTipManager.Instance.removeTip(this);
         if(this._lockBg)
         {
            ObjectUtils.disposeObject(this._lockBg);
         }
         this._lockBg = null;
         ObjectUtils.disposeObject(this._skillPic);
         this._skillPic = null;
         ObjectUtils.disposeObject(this._tempPic);
         this._tempPic = null;
         this._skill = null;
      }
      
      public function get turnNum() : int
      {
         return this._turnNum;
      }
      
      public function set turnNum(param1:int) : void
      {
         this._turnNum = param1;
      }
   }
}
