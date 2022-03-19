// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//vip.view.PrivilegeViewItem

package vip.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.text.FilterFrameText;
    import __AS3__.vec.Vector;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import ddt.utils.PositionUtils;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class PrivilegeViewItem extends Sprite implements Disposeable 
    {

        public static const TRUE_FLASE_TYPE:int = 0;
        public static const UNIT_TYPE:int = 1;
        public static const GRAPHICS_TYPE:int = 2;
        public static const NORMAL_TYPE:int = 3;

        private var _bg:Image;
        private var _titleTxt:FilterFrameText;
        private var _content:Vector.<String>;
        private var _displayContent:Vector.<DisplayObject>;
        private var _itemType:int;
        private var _itemIndex:int;
        private var _extraDisplayObject:*;
        private var _extraDisplayObjectList:Vector.<DisplayObject>;
        private var _interceptor:Function;
        private var _analyzeFunction:Function;
        private var _crossFilter:String = "0";

        public function PrivilegeViewItem(_arg_1:int=1, _arg_2:int=3, _arg_3:*=null)
        {
            this._itemIndex = _arg_1;
            this._itemType = _arg_2;
            this._extraDisplayObject = _arg_3;
            this._extraDisplayObjectList = new Vector.<DisplayObject>();
            this._analyzeFunction = this.analyzeContent;
            this.initView();
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItemBg");
            this._bg.visible = (((this._itemIndex % 2) == 0) ? true : false);
            this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItemTitleTxt");
            addChild(this._bg);
            addChild(this._titleTxt);
        }

        protected function analyzeContent(_arg_1:Vector.<String>):Vector.<DisplayObject>
        {
            var _local_4:String;
            var _local_5:FilterFrameText;
            var _local_6:Image;
            var _local_7:DisplayObject;
            var _local_8:Sprite;
            var _local_9:DisplayObject;
            var _local_2:Vector.<DisplayObject> = new Vector.<DisplayObject>();
            var _local_3:Point = ComponentFactory.Instance.creatCustomObject("vip.levelPrivilegeItemTxtStartPos");
            _loop_1:
            for each (_local_4 in _arg_1)
            {
                _local_5 = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItemTxt");
                _local_5.text = _local_4;
                PositionUtils.setPos(_local_5, _local_3);
                _local_3.x = (_local_3.x + (_local_5.width + 15));
                if (_local_4 == this._crossFilter)
                {
                    _local_6 = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItem.cross");
                    _local_6.x = ((_local_5.width - _local_6.width) + _local_5.x);
                    _local_6.y = _local_5.y;
                    _local_2.push(_local_6);
                }
                else
                {
                    switch (this._itemType)
                    {
                        case TRUE_FLASE_TYPE:
                            _local_7 = ((_local_4 == "1") ? ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItem.Tick") : ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItem.cross"));
                            _local_7.x = ((_local_5.width - _local_7.width) + _local_5.x);
                            _local_7.y = _local_5.y;
                            _local_2.push(_local_7);
                            continue _loop_1;
                        case UNIT_TYPE:
                            _local_5.text = (_local_5.text + String(this._extraDisplayObject));
                            break;
                        case GRAPHICS_TYPE:
                            _local_8 = new Sprite();
                            _local_9 = ComponentFactory.Instance.creatBitmap(this._extraDisplayObject);
                            this._extraDisplayObjectList.push(_local_9);
                            this._extraDisplayObjectList.push(_local_5);
                            _local_5.width = (_local_5.width - _local_9.width);
                            _local_9.x = (_local_5.width + _local_5.x);
                            _local_9.y = _local_5.y;
                            _local_8.addChild(_local_5);
                            _local_8.addChild(_local_9);
                            _local_2.push(_local_8);
                            continue _loop_1;
                    };
                    _local_2.push(_local_5);
                };
            };
            return (_local_2);
        }

        public function set crossFilter(_arg_1:String):void
        {
            this._crossFilter = _arg_1;
        }

        public function set contentInterceptor(_arg_1:Function):void
        {
            this._interceptor = _arg_1;
        }

        public function set itemTitleText(_arg_1:String):void
        {
            this._titleTxt.text = _arg_1;
        }

        public function set analyzeFunction(_arg_1:Function):void
        {
            this._analyzeFunction = _arg_1;
        }

        public function set itemContent(_arg_1:Vector.<String>):void
        {
            this._content = _arg_1;
            this._displayContent = this._analyzeFunction(this._content);
            this.updateView();
        }

        private function updateView():void
        {
            var _local_1:DisplayObject;
            for each (_local_1 in this._displayContent)
            {
                addChild(_local_1);
            };
        }

        public function dispose():void
        {
            var _local_1:DisplayObject;
            var _local_2:DisplayObject;
            if (this._displayContent != null)
            {
                for each (_local_2 in this._displayContent)
                {
                    ObjectUtils.disposeObject(_local_2);
                };
            };
            this._displayContent = null;
            for each (_local_1 in this._extraDisplayObjectList)
            {
                ObjectUtils.disposeObject(_local_1);
            };
            this._extraDisplayObjectList = null;
            ObjectUtils.disposeObject(this._bg);
            ObjectUtils.disposeObject(this._titleTxt);
            this._bg = null;
            this._titleTxt = null;
        }


    }
}//package vip.view

