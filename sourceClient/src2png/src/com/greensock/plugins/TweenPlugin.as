// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.plugins.TweenPlugin

package com.greensock.plugins
{
    import com.greensock.core.PropTween;
    import com.greensock.TweenLite;
    import com.greensock.core.*;
    import com.greensock.*;

    public class TweenPlugin 
    {

        public static const VERSION:Number = 1.4;
        public static const API:Number = 1;

        public var propName:String;
        public var overwriteProps:Array;
        public var round:Boolean;
        public var priority:int = 0;
        public var activeDisable:Boolean;
        public var onInitAllProps:Function;
        public var onComplete:Function;
        public var onEnable:Function;
        public var onDisable:Function;
        protected var _tweens:Array = [];
        protected var _changeFactor:Number = 0;


        private static function onTweenEvent(_arg_1:String, _arg_2:TweenLite):Boolean
        {
            var _local_4:Boolean;
            var _local_5:Array;
            var _local_6:int;
            var _local_3:PropTween = _arg_2.cachedPT1;
            if (_arg_1 == "onInitAllProps")
            {
                _local_5 = [];
                _local_6 = 0;
                while (_local_3)
                {
                    var _local_7:* = _local_6++;
                    _local_5[_local_7] = _local_3;
                    _local_3 = _local_3.nextNode;
                };
                _local_5.sortOn("priority", (Array.NUMERIC | Array.DESCENDING));
                while (--_local_6 > -1)
                {
                    PropTween(_local_5[_local_6]).nextNode = _local_5[(_local_6 + 1)];
                    PropTween(_local_5[_local_6]).prevNode = _local_5[(_local_6 - 1)];
                };
                _local_3 = (_arg_2.cachedPT1 = _local_5[0]);
            };
            while (_local_3)
            {
                if (((_local_3.isPlugin) && (_local_3.target[_arg_1])))
                {
                    if (_local_3.target.activeDisable)
                    {
                        _local_4 = true;
                    };
                    _local_7 = _local_3.target;
                    (_local_7[_arg_1]());
                };
                _local_3 = _local_3.nextNode;
            };
            return (_local_4);
        }

        public static function activate(_arg_1:Array):Boolean
        {
            var _local_3:Object;
            TweenLite.onPluginEvent = TweenPlugin.onTweenEvent;
            var _local_2:int = _arg_1.length;
            while (_local_2--)
            {
                if (_arg_1[_local_2].hasOwnProperty("API"))
                {
                    _local_3 = new ((_arg_1[_local_2] as Class))();
                    TweenLite.plugins[_local_3.propName] = _arg_1[_local_2];
                };
            };
            return (true);
        }


        public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite):Boolean
        {
            this.addTween(_arg_1, this.propName, _arg_1[this.propName], _arg_2, this.propName);
            return (true);
        }

        protected function addTween(_arg_1:Object, _arg_2:String, _arg_3:Number, _arg_4:*, _arg_5:String=null):void
        {
            var _local_6:Number;
            if (_arg_4 != null)
            {
                _local_6 = ((typeof(_arg_4) == "number") ? (Number(_arg_4) - _arg_3) : Number(_arg_4));
                if (_local_6 != 0)
                {
                    this._tweens[this._tweens.length] = new PropTween(_arg_1, _arg_2, _arg_3, _local_6, ((_arg_5) || (_arg_2)), false);
                };
            };
        }

        protected function updateTweens(_arg_1:Number):void
        {
            var _local_3:PropTween;
            var _local_4:Number;
            var _local_2:int = this._tweens.length;
            if (this.round)
            {
                while (--_local_2 > -1)
                {
                    _local_3 = this._tweens[_local_2];
                    _local_4 = (_local_3.start + (_local_3.change * _arg_1));
                    if (_local_4 > 0)
                    {
                        _local_3.target[_local_3.property] = ((_local_4 + 0.5) >> 0);
                    }
                    else
                    {
                        _local_3.target[_local_3.property] = ((_local_4 - 0.5) >> 0);
                    };
                };
            }
            else
            {
                while (--_local_2 > -1)
                {
                    _local_3 = this._tweens[_local_2];
                    _local_3.target[_local_3.property] = (_local_3.start + (_local_3.change * _arg_1));
                };
            };
        }

        public function get changeFactor():Number
        {
            return (this._changeFactor);
        }

        public function set changeFactor(_arg_1:Number):void
        {
            this.updateTweens(_arg_1);
            this._changeFactor = _arg_1;
        }

        public function killProps(_arg_1:Object):void
        {
            var _local_2:int = this.overwriteProps.length;
            while (--_local_2 > -1)
            {
                if ((this.overwriteProps[_local_2] in _arg_1))
                {
                    this.overwriteProps.splice(_local_2, 1);
                };
            };
            _local_2 = this._tweens.length;
            while (--_local_2 > -1)
            {
                if ((PropTween(this._tweens[_local_2]).name in _arg_1))
                {
                    this._tweens.splice(_local_2, 1);
                };
            };
        }


    }
}//package com.greensock.plugins

