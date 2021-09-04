package game.view.propContainer
{
   import bagAndInfo.bag.ItemCellView;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import ddt.data.EquipType;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.display.BitmapLoaderProxy;
   import ddt.events.LivingEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PathManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
   import ddt.view.PropItemView;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import game.model.TurnedLiving;
   import pet.date.PetSkillInfo;
   
   public class PlayerStateContainer extends SimpleTileList
   {
       
      
      private var _info:TurnedLiving;
      
      public function PlayerStateContainer(param1:Number = 10)
      {
         super(param1);
         hSpace = 6;
         vSpace = 4;
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public function get info() : TurnedLiving
      {
         return this._info;
      }
      
      public function set info(param1:TurnedLiving) : void
      {
         if(this._info == param1)
         {
            return;
         }
         if(this._info)
         {
            this._info.removeEventListener(LivingEvent.ADD_STATE,this.__addingState);
            this._info.removeEventListener(LivingEvent.USE_PET_SKILL,this.__usePetSkill);
         }
         this._info = param1;
         if(this._info)
         {
            this._info.addEventListener(LivingEvent.ADD_STATE,this.__addingState);
            this._info.addEventListener(LivingEvent.USE_PET_SKILL,this.__usePetSkill);
         }
      }
      
      private function __addingState(param1:LivingEvent) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:EquipmentTemplateInfo = null;
         var _loc4_:DisplayObject = null;
         if(visible == false)
         {
            visible = true;
         }
         if(!this._info.isLiving)
         {
            visible = false;
            return;
         }
         if(param1.value > 0)
         {
            _loc2_ = new InventoryItemInfo();
            _loc2_.TemplateID = param1.value;
            ItemManager.fill(_loc2_);
            _loc3_ = ItemManager.Instance.getEquipTemplateById(_loc2_.TemplateID);
            if(!_loc3_ || _loc3_.TemplateType != EquipType.HOLYGRAIL)
            {
               addChild(new ItemCellView(0,PropItemView.createView(_loc2_.Pic,40,40)));
            }
            else
            {
               _loc4_ = PlayerManager.Instance.getDeputyWeaponIcon(_loc2_,1);
               addChild(new ItemCellView(0,_loc4_));
            }
         }
      }
      
      private function __usePetSkill(param1:LivingEvent) : void
      {
         visible = true;
         if(!this._info.isLiving)
         {
            visible = false;
            return;
         }
         var _loc2_:PetSkillInfo = PetSkillManager.instance.getSkillByID(param1.value);
         if(_loc2_ && _loc2_.isActiveSkill)
         {
            addChild(new ItemCellView(0,new BitmapLoaderProxy(PathManager.solveSkillPicUrl(_loc2_.Pic),new Rectangle(0,0,40,40))));
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.info = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
