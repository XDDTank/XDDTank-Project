// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.plugins.RoundPropsPlugin

package com.greensock.plugins
{
    import com.greensock.TweenLite;
    import com.greensock.core.PropTween;

    public class RoundPropsPlugin extends TweenPlugin 
    {

        public static const API:Number = 1;

        protected var _tween:TweenLite;

        public function RoundPropsPlugin()
        {
            this.propName = "roundProps";
            this.overwriteProps = ["roundProps"];
            this.round = true;
            this.priority = -1;
            this.onInitAllProps = this._initAllProps;
        }

        override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite):Boolean
        {
            this._tween = _arg_3;
            this.overwriteProps = this.overwriteProps.concat((_arg_2 as Array));
            return (true);
        }

        protected function _initAllProps():void
        {
            var _local_1:String;
            var _local_2:String;
            var _local_4:PropTween;
            var _local_3:Array = this._tween.vars.roundProps;
            var _local_5:int = _local_3.length;
            while (--_local_5 > -1)
            {
                _local_1 = _local_3[_local_5];
                _local_4 = this._tween.cachedPT1;
                while (_local_4)
                {
                    if (_local_4.name == _local_1)
                    {
                        if (_local_4.isPlugin)
                        {
                            _local_4.target.round = true;
                        }
                        else
                        {
                            this.add(_local_4.target, _local_1, _local_4.start, _local_4.change);
                            this._removePropTween(_local_4);
                            this._tween.propTweenLookup[_local_1] = this._tween.propTweenLookup.roundProps;
                        };
                    }
                    else
                    {
                        if ((((_local_4.isPlugin) && (_local_4.name == "_MULTIPLE_")) && (!(_local_4.target.round))))
                        {
                            _local_2 = ((" " + _local_4.target.overwriteProps.join(" ")) + " ");
                            if (_local_2.indexOf(((" " + _local_1) + " ")) != -1)
                            {
                                _local_4.target.round = true;
                            };
                        };
                    };
                    _local_4 = _local_4.nextNode;
                };
            };
        }

        protected function _removePropTween(_arg_1:PropTween):void
        {
            if (_arg_1.nextNode)
            {
                _arg_1.nextNode.prevNode = _arg_1.prevNode;
            };
            if (_arg_1.prevNode)
            {
                _arg_1.prevNode.nextNode = _arg_1.nextNode;
            }
            else
            {
                if (this._tween.cachedPT1 == _arg_1)
                {
                    this._tween.cachedPT1 = _arg_1.nextNode;
                };
            };
            if (((_arg_1.isPlugin) && (_arg_1.target.onDisable)))
            {
                _arg_1.target.onDisable();
            };
        }

        public function add(_arg_1:Object, _arg_2:String, _arg_3:Number, _arg_4:Number):void
        {
            addTween(_arg_1, _arg_2, _arg_3, (_arg_3 + _arg_4), _arg_2);
            this.overwriteProps[this.overwriteProps.length] = _arg_2;
        }


    }
}//package com.greensock.plugins

