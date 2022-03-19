// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.SimpleItem

package ddt.view
{
    import com.pickgliss.ui.core.Component;
    import flash.display.DisplayObject;
    import __AS3__.vec.Vector;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.ComponentFactory;
    import __AS3__.vec.*;

    public class SimpleItem extends Component 
    {

        public static const P_backStyle:String = "backStyle";
        public static const P_foreStyle:String = "foreStyle";

        private var _backStyle:String;
        private var _foreStyle:String;
        private var _back:DisplayObject;
        private var _fore:Vector.<DisplayObject>;
        private var _foreLinks:Array;


        override protected function init():void
        {
            this._fore = new Vector.<DisplayObject>();
            this._foreLinks = new Array();
            super.init();
        }

        public function set backStyle(_arg_1:String):void
        {
            if (_arg_1 == this._backStyle)
            {
                return;
            };
            this._backStyle = _arg_1;
            if (this._back)
            {
                ObjectUtils.disposeObject(this._back);
            };
            this._back = ComponentFactory.Instance.creat(this._backStyle);
            onPropertiesChanged(P_backStyle);
        }

        public function set foreStyle(_arg_1:String):void
        {
            if (_arg_1 == this._foreStyle)
            {
                return;
            };
            this._foreStyle = _arg_1;
            this.clearObject();
            this._foreLinks = ComponentFactory.parasArgs(_arg_1);
            onPropertiesChanged(P_foreStyle);
        }

        private function clearObject():void
        {
            var _local_1:int;
            while (_local_1 < this._foreLinks.length)
            {
                if (this._foreLinks[_local_1])
                {
                    ObjectUtils.disposeObject(this._foreLinks[_local_1]);
                };
                _local_1++;
            };
        }

        private function createObject():void
        {
            var _local_2:DisplayObject;
            var _local_1:int;
            while (_local_1 < this._foreLinks.length)
            {
                _local_2 = ComponentFactory.Instance.creat(this._foreLinks[_local_1]);
                this._fore.push(_local_2);
                _local_1++;
            };
        }

        public function get foreItems():Vector.<DisplayObject>
        {
            return (this._fore);
        }

        public function get backItem():DisplayObject
        {
            return (this._back);
        }

        override protected function addChildren():void
        {
            super.addChildren();
            if (this._back)
            {
                addChild(this._back);
            };
            var _local_1:int;
            while (_local_1 < this._fore.length)
            {
                addChild(this._fore[_local_1]);
                _local_1++;
            };
        }

        override protected function onProppertiesUpdate():void
        {
            super.onProppertiesUpdate();
            if (_changedPropeties[P_backStyle])
            {
                if (((this._back) && ((this._back.width > 0) || (this._back.height > 0))))
                {
                    _width = this._back.width;
                    _height = this._back.height;
                };
            };
            if (_changedPropeties[P_foreStyle])
            {
                this.createObject();
            };
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._back);
            this._back = null;
            var _local_1:int;
            while (_local_1 < this._fore.length)
            {
                ObjectUtils.disposeObject(this._fore[_local_1]);
                this._fore[_local_1] = null;
                _local_1++;
            };
            this._foreLinks = null;
            super.dispose();
        }


    }
}//package ddt.view

