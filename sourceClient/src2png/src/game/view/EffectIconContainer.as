// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.EffectIconContainer

package game.view
{
    import flash.display.Sprite;
    import road7th.data.DictionaryData;
    import __AS3__.vec.Vector;
    import game.view.effects.BaseMirariEffectIcon;
    import flash.display.DisplayObject;
    import road7th.data.DictionaryEvent;
    import flash.events.Event;
    import __AS3__.vec.*;

    [Event(name="change", type="flash.events.Event")]
    public class EffectIconContainer extends Sprite 
    {

        private var _data:DictionaryData;
        private var _spList:Array;
        private var _list:Vector.<BaseMirariEffectIcon> = new Vector.<BaseMirariEffectIcon>();

        public function EffectIconContainer()
        {
            mouseChildren = (mouseEnabled = false);
            this.initialize();
            this.initEvent();
        }

        private function initialize():void
        {
            if (((this._spList) || (this._data)))
            {
                this.release();
            };
            this._data = new DictionaryData();
            this._spList = [];
        }

        private function release():void
        {
            this.clearIcons();
            if (this._data)
            {
                this.removeEvent();
                this._data.clear();
            };
            this._data = null;
        }

        private function clearIcons():void
        {
            var _local_1:DisplayObject;
            for each (_local_1 in this._spList)
            {
                removeChild(_local_1);
            };
            this._spList = [];
        }

        private function drawIcons(_arg_1:Array):void
        {
            var _local_2:int;
            var _local_3:DisplayObject;
            _local_2 = 0;
            while (_local_2 < _arg_1.length)
            {
                _local_3 = this._data.list[_local_2];
                _local_3.x = ((_local_2 & 0x03) * 21);
                _local_3.y = ((_local_2 >> 2) * 21);
                this._spList.push(_local_3);
                addChild(_local_3);
                _local_2++;
            };
        }

        private function initEvent():void
        {
            this._data.addEventListener(DictionaryEvent.ADD, this.__changeEffectHandler);
            this._data.addEventListener(DictionaryEvent.REMOVE, this.__changeEffectHandler);
        }

        private function removeEvent():void
        {
            if (this._data)
            {
                this._data.removeEventListener(DictionaryEvent.ADD, this.__changeEffectHandler);
                this._data.removeEventListener(DictionaryEvent.REMOVE, this.__changeEffectHandler);
            };
        }

        private function __changeEffectHandler(_arg_1:DictionaryEvent):void
        {
            var _local_2:Sprite = (_arg_1.data as Sprite);
            this._updateList();
        }

        private function _updateList():void
        {
            this.clearIcons();
            this.drawIcons(this._data.list);
            dispatchEvent(new Event(Event.CHANGE));
        }

        override public function get width():Number
        {
            return ((this._spList.length % 5) * 21);
        }

        override public function get height():Number
        {
            return ((Math.floor((this._spList.length / 5)) + 1) * 21);
        }

        public function handleEffect(_arg_1:int, _arg_2:DisplayObject):void
        {
            if (_arg_2)
            {
                this._data.add(_arg_1, _arg_2);
            };
        }

        public function removeEffect(_arg_1:int):void
        {
            this._data.remove(_arg_1);
        }

        public function clearEffectIcon():void
        {
            this.release();
        }

        public function dispose():void
        {
            this.removeEvent();
            this.release();
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view

