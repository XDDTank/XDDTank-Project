// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.FriendGroupTip

package ddt.view.tips
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PlayerManager;
    import __AS3__.vec.Vector;
    import im.info.CustomInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class FriendGroupTip extends Sprite implements Disposeable 
    {

        private var _bg:ScaleBitmapImage;
        private var _vbox:VBox;
        private var _itemArr:Array;

        public function FriendGroupTip()
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("friendsGroupTip.bg");
            this._vbox = ComponentFactory.Instance.creatComponentByStylename("friendsGroupTip.ItemContainer");
            addChild(this._bg);
            addChild(this._vbox);
            this._itemArr = new Array();
        }

        public function update(_arg_1:String):void
        {
            var _local_4:FriendGroupTItem;
            this.clearItem();
            var _local_2:Vector.<CustomInfo> = PlayerManager.Instance.customList;
            var _local_3:int;
            while (_local_3 < (_local_2.length - 1))
            {
                _local_4 = new FriendGroupTItem();
                _local_4.info = _local_2[_local_3];
                _local_4.NickName = _arg_1;
                this._vbox.addChild(_local_4);
                this._itemArr.push(_local_4);
                _local_3++;
            };
            this._bg.height = (_local_2.length * 21);
        }

        private function clearItem():void
        {
            var _local_1:int;
            while (_local_1 < this._itemArr.length)
            {
                if (this._itemArr[_local_1])
                {
                    ObjectUtils.disposeObject(this._itemArr[_local_1]);
                };
                this._itemArr[_local_1] = null;
                _local_1++;
            };
            this._itemArr = new Array();
        }

        public function dispose():void
        {
            this.clearItem();
            this._itemArr = null;
            if (this._vbox)
            {
                ObjectUtils.disposeObject(this._vbox);
            };
            this._vbox = null;
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view.tips

