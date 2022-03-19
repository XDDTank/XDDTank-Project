// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.club.ClubRecordList

package consortion.view.club
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class ClubRecordList extends Sprite implements Disposeable 
    {

        public static const INVITE:int = 1;
        public static const APPLY:int = 2;

        private var _items:Vector.<ClubRecordItem>;
        private var _panel:ScrollPanel;
        private var _vbox:VBox;
        private var _data:*;

        public function ClubRecordList()
        {
            this.init();
        }

        private function init():void
        {
            this._vbox = ComponentFactory.Instance.creatComponentByStylename("club.recordList.vbox");
            this._panel = ComponentFactory.Instance.creatComponentByStylename("club.recordList.panel");
            this._panel.setView(this._vbox);
            addChild(this._panel);
        }

        public function setData(_arg_1:Object, _arg_2:int):void
        {
            var _local_3:int;
            var _local_4:ClubRecordItem;
            if (this._data == _arg_1)
            {
                return;
            };
            this.clearItem();
            this._items = new Vector.<ClubRecordItem>();
            if (((_arg_1) && (_arg_1.length > 0)))
            {
                _local_3 = 0;
                while (_local_3 < _arg_1.length)
                {
                    _local_4 = new ClubRecordItem(_arg_2);
                    _local_4.info = _arg_1[_local_3];
                    this._items.push(_local_4);
                    this._vbox.addChild(_local_4);
                    _local_3++;
                };
            };
            this._panel.invalidateViewport();
        }

        private function clearItem():void
        {
            var _local_1:int;
            var _local_2:int;
            if (((this._items) && (this._items.length > 0)))
            {
                _local_1 = this._items.length;
                _local_2 = 0;
                while (_local_2 < _local_1)
                {
                    this._items[_local_2].dispose();
                    this._items[_local_2] = null;
                    _local_2++;
                };
            };
            this._items = null;
        }

        public function dispose():void
        {
            this.clearItem();
            ObjectUtils.disposeAllChildren(this);
            this._vbox = null;
            this._panel = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.view.club

