// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.propContainer.PlayerStateContainer

package game.view.propContainer
{
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import game.model.TurnedLiving;
    import ddt.events.LivingEvent;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.goods.EquipmentTemplateInfo;
    import flash.display.DisplayObject;
    import ddt.manager.ItemManager;
    import ddt.data.EquipType;
    import bagAndInfo.bag.ItemCellView;
    import ddt.view.PropItemView;
    import ddt.manager.PlayerManager;
    import ddt.manager.PetSkillManager;
    import pet.date.PetSkillInfo;
    import ddt.display.BitmapLoaderProxy;
    import ddt.manager.PathManager;
    import flash.geom.Rectangle;

    public class PlayerStateContainer extends SimpleTileList 
    {

        private var _info:TurnedLiving;

        public function PlayerStateContainer(_arg_1:Number=10)
        {
            super(_arg_1);
            hSpace = 6;
            vSpace = 4;
            mouseEnabled = false;
            mouseChildren = false;
        }

        public function get info():TurnedLiving
        {
            return (this._info);
        }

        public function set info(_arg_1:TurnedLiving):void
        {
            if (this._info == _arg_1)
            {
                return;
            };
            if (this._info)
            {
                this._info.removeEventListener(LivingEvent.ADD_STATE, this.__addingState);
                this._info.removeEventListener(LivingEvent.USE_PET_SKILL, this.__usePetSkill);
            };
            this._info = _arg_1;
            if (this._info)
            {
                this._info.addEventListener(LivingEvent.ADD_STATE, this.__addingState);
                this._info.addEventListener(LivingEvent.USE_PET_SKILL, this.__usePetSkill);
            };
        }

        private function __addingState(_arg_1:LivingEvent):void
        {
            var _local_2:InventoryItemInfo;
            var _local_3:EquipmentTemplateInfo;
            var _local_4:DisplayObject;
            if (visible == false)
            {
                visible = true;
            };
            if ((!(this._info.isLiving)))
            {
                visible = false;
                return;
            };
            if (_arg_1.value > 0)
            {
                _local_2 = new InventoryItemInfo();
                _local_2.TemplateID = _arg_1.value;
                ItemManager.fill(_local_2);
                _local_3 = ItemManager.Instance.getEquipTemplateById(_local_2.TemplateID);
                if (((!(_local_3)) || (!(_local_3.TemplateType == EquipType.HOLYGRAIL))))
                {
                    addChild(new ItemCellView(0, PropItemView.createView(_local_2.Pic, 40, 40)));
                }
                else
                {
                    _local_4 = PlayerManager.Instance.getDeputyWeaponIcon(_local_2, 1);
                    addChild(new ItemCellView(0, _local_4));
                };
            };
        }

        private function __usePetSkill(_arg_1:LivingEvent):void
        {
            visible = true;
            if ((!(this._info.isLiving)))
            {
                visible = false;
                return;
            };
            var _local_2:PetSkillInfo = PetSkillManager.instance.getSkillByID(_arg_1.value);
            if (((_local_2) && (_local_2.isActiveSkill)))
            {
                addChild(new ItemCellView(0, new BitmapLoaderProxy(PathManager.solveSkillPicUrl(_local_2.Pic), new Rectangle(0, 0, 40, 40))));
            };
        }

        override public function dispose():void
        {
            super.dispose();
            this.info = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.propContainer

