// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.prop.PlayerUsePropView

package game.view.prop
{
    import com.pickgliss.ui.core.Component;
    import flash.utils.Dictionary;
    import road7th.data.DictionaryData;
    import ddt.events.LivingEvent;
    import flash.display.Bitmap;
    import game.model.Player;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.goods.EquipmentTemplateInfo;
    import flash.display.DisplayObject;
    import ddt.manager.ItemManager;
    import ddt.data.EquipType;
    import ddt.view.PropItemView;
    import ddt.manager.PlayerManager;
    import ddt.data.goods.ItemTemplateInfo;
    import com.greensock.TweenLite;
    import flash.utils.setTimeout;
    import flash.utils.clearTimeout;
    import com.pickgliss.utils.ObjectUtils;

    public class PlayerUsePropView extends Component 
    {

        private var _usePropItemDic:Dictionary;
        private var _timeID:uint;
        private var _playerList:DictionaryData;

        public function PlayerUsePropView(_arg_1:DictionaryData)
        {
            this._playerList = _arg_1;
            this._usePropItemDic = new Dictionary();
            mouseEnabled = false;
            mouseChildren = false;
            this.initEvent();
        }

        private function initEvent():void
        {
            var _local_1:String;
            for (_local_1 in this._playerList)
            {
                this._playerList[_local_1].addEventListener(LivingEvent.ADD_STATE, this.__addingState, false, 0, true);
            };
        }

        private function __addingState(_arg_1:LivingEvent):void
        {
            var _local_3:Bitmap;
            var _local_2:Player = (_arg_1.target as Player);
            if (((!(_local_2)) || (!(_local_2.isLiving))))
            {
                return;
            };
            if (_arg_1.value == -1)
            {
                _local_3 = ComponentFactory.Instance.creatBitmap("game.crazyTank.view.specialKillAsset");
                _local_3.width = 40;
                _local_3.height = 40;
                this.addItem((_arg_1.target as Player), _local_3);
            };
        }

        public function useItem(_arg_1:Player, _arg_2:ItemTemplateInfo):void
        {
            var _local_3:EquipmentTemplateInfo;
            var _local_4:DisplayObject;
            if (_arg_1)
            {
                _local_3 = ItemManager.Instance.getEquipTemplateById(_arg_2.TemplateID);
                if (((!(_local_3)) || (!(_local_3.TemplateType == EquipType.HOLYGRAIL))))
                {
                    this.addItem(_arg_1, PropItemView.createView(_arg_2.Pic, 40, 40));
                }
                else
                {
                    _local_4 = PlayerManager.Instance.getDeputyWeaponIcon(_arg_2, 1);
                    this.addItem(_arg_1, _local_4);
                };
            };
        }

        private function addItem(_arg_1:Player, _arg_2:DisplayObject):void
        {
            var _local_3:PlayerUsePropItem;
            if ((!(this._usePropItemDic[_arg_1])))
            {
                _local_3 = new PlayerUsePropItem(_arg_1);
                this._usePropItemDic[_arg_1] = _local_3;
                _local_3.y = _height;
                _height = (_height + 50);
                addChild(this._usePropItemDic[_arg_1]);
                _local_3.start();
            };
            this._usePropItemDic[_arg_1].addProp(_arg_2);
        }

        public function hide():void
        {
            var _local_1:PlayerUsePropItem;
            for each (_local_1 in this._usePropItemDic)
            {
                TweenLite.to(_local_1, 0.5, {
                    "y":(_local_1.y - 50),
                    "alpha":0
                });
            };
            this._timeID = setTimeout(this.dispose, 1000);
        }

        public function clear():void
        {
            var _local_1:Object;
            _height = 0;
            clearTimeout(this._timeID);
            for (_local_1 in this._usePropItemDic)
            {
                TweenLite.killTweensOf(this._usePropItemDic[_local_1]);
                ObjectUtils.disposeObject(this._usePropItemDic[_local_1]);
                delete this._usePropItemDic[_local_1];
            };
        }

        override public function dispose():void
        {
            super.dispose();
            this.clear();
            clearTimeout(this._timeID);
        }


    }
}//package game.view.prop

