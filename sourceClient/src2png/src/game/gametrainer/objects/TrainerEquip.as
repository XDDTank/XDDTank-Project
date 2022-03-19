// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.gametrainer.objects.TrainerEquip

package game.gametrainer.objects
{
    import phy.object.PhysicalObj;
    import flash.display.MovieClip;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.ComponentFactory;

    public class TrainerEquip extends PhysicalObj 
    {

        private var _equip:MovieClip;

        public function TrainerEquip(_arg_1:int, _arg_2:int=1, _arg_3:Number=1, _arg_4:Number=1, _arg_5:Number=1, _arg_6:Number=1)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
            this.init();
        }

        private function init():void
        {
            var _local_1:String = ((PlayerManager.Instance.Self.Sex) ? "asset.trainer.TrainerManEquipAsset" : "asset.trainer.TrainerWomanEquipAsset");
            this._equip = ComponentFactory.Instance.creat(_local_1);
            addChild(this._equip);
        }

        override public function dispose():void
        {
            if (((this._equip) && (this._equip.parent)))
            {
                this._equip.parent.removeChild(this._equip);
            };
            this._equip = null;
            super.dispose();
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.gametrainer.objects

