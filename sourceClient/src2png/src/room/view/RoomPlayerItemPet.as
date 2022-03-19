// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.RoomPlayerItemPet

package room.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import pet.date.PetInfo;
    import flash.utils.Dictionary;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.display.BitmapLoaderProxy;
    import ddt.manager.PathManager;
    import ddt.manager.PetBagManager;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;

    public class RoomPlayerItemPet extends Sprite implements Disposeable 
    {

        private var _petLevel:FilterFrameText;
        private var _petInfo:PetInfo;
        private var _headPetWidth:Number;
        private var _headPetHight:Number;
        private var _excursion:Number = 3;
        private var _icons:Dictionary;

        public function RoomPlayerItemPet(_arg_1:Number=0, _arg_2:Number=0)
        {
            this._headPetWidth = _arg_1;
            this._headPetHight = _arg_2;
            this._icons = new Dictionary();
            this._petLevel = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.playerItem.petLevelTxt");
            addChild(this._petLevel);
        }

        private function createPetIcon():void
        {
            var _local_1:BitmapLoaderProxy = new BitmapLoaderProxy(PathManager.solvePetIconUrl(PetBagManager.instance().getPicStr(this._petInfo)), null, true);
            _local_1.addEventListener(BitmapLoaderProxy.LOADING_FINISH, this.__iconLoadingFinish);
            this._icons[this._petInfo.ID] = _local_1;
        }

        public function updateView(_arg_1:PetInfo):void
        {
            this._petInfo = _arg_1;
            this.iconvisible();
            if (this._petInfo)
            {
                if (this._icons[this._petInfo.ID])
                {
                    this._icons[this._petInfo.ID].visible = true;
                }
                else
                {
                    this.createPetIcon();
                };
                this._petLevel.text = ("LV:" + this._petInfo.Level);
            }
            else
            {
                this._petLevel.text = "";
            };
        }

        private function iconvisible():void
        {
            var _local_1:BitmapLoaderProxy;
            for each (_local_1 in this._icons)
            {
                if (_local_1)
                {
                    _local_1.visible = false;
                };
            };
        }

        private function __iconLoadingFinish(_arg_1:Event):void
        {
            var _local_2:BitmapLoaderProxy;
            _local_2 = (_arg_1.target as BitmapLoaderProxy);
            _local_2.removeEventListener(BitmapLoaderProxy.LOADING_FINISH, this.__iconLoadingFinish);
            _local_2.scaleX = 0.5;
            _local_2.scaleY = 0.5;
            _local_2.x = (((this._headPetWidth - _local_2.width) / 2) + this._excursion);
            _local_2.y = ((this._headPetHight - _local_2.height) / 2);
            addChildAt(_local_2, 0);
            this._petLevel.x = (_local_2.x + ((_local_2.width - this._petLevel.width) / 2));
            this._petLevel.y = (this._headPetHight - this._petLevel.height);
        }

        public function dispose():void
        {
            var _local_1:BitmapLoaderProxy;
            if (this._petLevel)
            {
                ObjectUtils.disposeObject(this._petLevel);
            };
            this._petLevel = null;
            for each (_local_1 in this._icons)
            {
                if (_local_1)
                {
                    ObjectUtils.disposeObject(_local_1);
                };
                _local_1 = null;
            };
            this._icons = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package room.view

