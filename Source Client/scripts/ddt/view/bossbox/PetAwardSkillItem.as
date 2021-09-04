package ddt.view.bossbox
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import pet.date.PetEggInfo;
   import pet.date.PetSkillInfo;
   import petsBag.view.item.SkillItem;
   
   public class PetAwardSkillItem extends SkillItem
   {
       
      
      private var _bg:Bitmap;
      
      private var _eggInfo:PetEggInfo;
      
      public function PetAwardSkillItem()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("asset.awardSystem.petAward.skillBg");
         addChild(this._bg);
         width = this._bg.width;
         height = this._bg.height;
         super.initView();
      }
      
      public function get eggInfo() : PetEggInfo
      {
         return this._eggInfo;
      }
      
      public function set eggInfo(param1:PetEggInfo) : void
      {
         this._eggInfo = param1;
         var _loc2_:PetSkillInfo = new PetSkillInfo();
         _loc2_.ID = this._eggInfo.ID;
         _loc2_.Name = this._eggInfo.Name;
         _loc2_.Description = this._eggInfo.Desc;
         _loc2_.Pic = this._eggInfo.Icon;
      }
      
      override public function updateSize() : void
      {
         if(_skillIcon)
         {
            _skillIcon.x = (this._bg.width - 44) / 2;
            _skillIcon.y = (this._bg.height - 44) / 2;
         }
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         this._eggInfo = null;
         super.dispose();
      }
   }
}
