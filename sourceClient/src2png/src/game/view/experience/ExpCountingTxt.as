// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.experience.ExpCountingTxt

package game.view.experience
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.ComponentFactory;
    import com.greensock.TweenLite;
    import com.greensock.easing.Quad;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ExpCountingTxt extends Sprite implements Disposeable 
    {

        protected var _text:*;
        protected var _value:Number;
        protected var _targetValue:Number;
        protected var _style:String;
        protected var _filters:Array;
        protected var _plus:String;
        public var maxValue:int = 2147483647;

        public function ExpCountingTxt(_arg_1:String, _arg_2:String)
        {
            this._style = _arg_1;
            this._filters = _arg_2.split(",");
            this.init();
        }

        public function get value():Number
        {
            return (this._value);
        }

        public function set value(_arg_1:Number):void
        {
            this._value = _arg_1;
        }

        public function get targetValue():Number
        {
            return (this._targetValue);
        }

        protected function init():void
        {
            this._text = ComponentFactory.Instance.creatComponentByStylename(this._style);
            this._targetValue = (this._value = 0);
            this._plus = "+";
            this._text.text = ((this._plus + String(this._value)) + " ");
            var _local_1:Array = [];
            var _local_2:int;
            while (_local_2 < this._filters.length)
            {
                _local_1.push(ComponentFactory.Instance.model.getSet(this._filters[_local_2]));
                _local_2++;
            };
            this._text.filters = _local_1;
            addChild(this._text);
        }

        public function updateNum(_arg_1:Number, _arg_2:Boolean=true):void
        {
            if (_arg_2)
            {
                this._targetValue = (this._targetValue + _arg_1);
            }
            else
            {
                this._targetValue = _arg_1;
            };
            if (this._targetValue > this.maxValue)
            {
                this._targetValue = this.maxValue;
            };
            TweenLite.killTweensOf(this);
            TweenLite.to(this, 0.5, {
                "value":this._targetValue,
                "ease":Quad.easeOut,
                "onUpdate":this.updateText,
                "onComplete":this.complete
            });
            dispatchEvent(new Event(Event.CHANGE));
        }

        protected function updateText():void
        {
            var _local_2:String;
            if ((!(this._text)))
            {
                return;
            };
            var _local_1:String = this._text.text;
            if (this._value < 0)
            {
                _local_2 = (String(Math.round(this._value)) + " ");
            }
            else
            {
                _local_2 = ((this._plus + String(Math.round(this._value))) + " ");
            };
            if (((_local_2.indexOf("+")) && (_local_2.indexOf("-"))))
            {
                _local_2 = _local_2.replace("-");
            };
            if (((!(_local_1 == "+0 ")) && (!(_local_2 == _local_1))))
            {
                SoundManager.instance.play("143");
            };
            this._text.text = _local_2;
        }

        public function complete(_arg_1:Event=null):void
        {
            this._value = this._targetValue;
            this.updateText();
            dispatchEvent(new Event(Event.COMPLETE));
        }

        public function dispose():void
        {
            ObjectUtils.disposeObject(this._text);
            this._text = null;
            this._filters = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.experience

