// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.gametrainer.objects.TrainerWeapon

package game.gametrainer.objects
{
    import phy.object.PhysicalObj;
    import flash.display.MovieClip;
    import com.pickgliss.ui.ComponentFactory;

    public class TrainerWeapon extends PhysicalObj 
    {

        private var _weaponAsset:MovieClip;

        public function TrainerWeapon(_arg_1:int, _arg_2:int=1, _arg_3:Number=1, _arg_4:Number=1, _arg_5:Number=1, _arg_6:Number=1)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
            this.init();
        }

        private function init():void
        {
            this._weaponAsset = ComponentFactory.Instance.creat("asset.trainer.TrainerWeaponAsset");
            addChild(this._weaponAsset);
        }

        override public function dispose():void
        {
            if (((this._weaponAsset) && (this._weaponAsset.parent)))
            {
                this._weaponAsset.parent.removeChild(this._weaponAsset);
            };
            this._weaponAsset = null;
            super.dispose();
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.gametrainer.objects

