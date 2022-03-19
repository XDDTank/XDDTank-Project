// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.plugins.TransformAroundPointPlugin

package com.greensock.plugins
{
    import flash.display.DisplayObject;
    import flash.geom.Point;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.display.Sprite;
    import flash.utils.getDefinitionByName;
    import com.greensock.TweenLite;
    import com.greensock.core.PropTween;
    import flash.display.*;
    import com.greensock.*;
    import com.greensock.core.*;

    public class TransformAroundPointPlugin extends TweenPlugin 
    {

        public static const API:Number = 1;
        private static var _classInitted:Boolean;
        private static var _isFlex:Boolean;

        protected var _target:DisplayObject;
        protected var _local:Point;
        protected var _point:Point;
        protected var _shortRotation:ShortRotationPlugin;
        protected var _proxy:DisplayObject;
        protected var _proxySizeData:Object;

        public function TransformAroundPointPlugin()
        {
            this.propName = "transformAroundPoint";
            this.overwriteProps = ["x", "y"];
            this.priority = -1;
        }

        override public function onInitTween(target:Object, value:*, tween:TweenLite):Boolean
        {
            var p:String;
            var short:ShortRotationPlugin;
            var sp:String;
            var m:Matrix;
            var point:Point;
            var b:Rectangle;
            var s:Sprite;
            var container:Sprite;
            var enumerables:Object;
            var endX:Number;
            var endY:Number;
            if ((!(value.point is Point)))
            {
                return (false);
            };
            this._target = (target as DisplayObject);
            this._point = value.point.clone();
            this._local = this._target.globalToLocal(this._target.parent.localToGlobal(this._point));
            if ((!(_classInitted)))
            {
                try
                {
                    _isFlex = Boolean(getDefinitionByName("mx.managers.SystemManager"));
                }
                catch(e:Error)
                {
                    _isFlex = false;
                };
                _classInitted = true;
            };
            if ((((!(isNaN(value.width))) || (!(isNaN(value.height)))) && (!(this._target.parent == null))))
            {
                m = this._target.transform.matrix;
                point = this._target.parent.globalToLocal(this._target.localToGlobal(new Point(100, 100)));
                this._target.width = (this._target.width * 2);
                if (point.x == this._target.parent.globalToLocal(this._target.localToGlobal(new Point(100, 100))).x)
                {
                    this._proxy = this._target;
                    this._target.rotation = 0;
                    this._proxySizeData = {};
                    if ((!(isNaN(value.width))))
                    {
                        addTween(this._proxySizeData, "width", (this._target.width / 2), value.width, "width");
                    };
                    if ((!(isNaN(value.height))))
                    {
                        addTween(this._proxySizeData, "height", this._target.height, value.height, "height");
                    };
                    b = this._target.getBounds(this._target);
                    s = new Sprite();
                    container = ((_isFlex) ? new (getDefinitionByName("mx.core.UIComponent"))() : new Sprite());
                    container.addChild(s);
                    container.visible = false;
                    this._proxy.parent.addChild(container);
                    this._target = s;
                    s.graphics.beginFill(0xFF, 0.4);
                    s.graphics.drawRect(b.x, b.y, b.width, b.height);
                    s.graphics.endFill();
                    s.transform.matrix = (this._target.transform.matrix = m);
                }
                else
                {
                    this._target.transform.matrix = m;
                };
            };
            for (p in value)
            {
                if (p != "point")
                {
                    if (p == "shortRotation")
                    {
                        this._shortRotation = new ShortRotationPlugin();
                        this._shortRotation.onInitTween(this._target, value[p], tween);
                        addTween(this._shortRotation, "changeFactor", 0, 1, "shortRotation");
                        for (sp in value[p])
                        {
                            this.overwriteProps[this.overwriteProps.length] = sp;
                        };
                    }
                    else
                    {
                        if (((p == "x") || (p == "y")))
                        {
                            addTween(this._point, p, this._point[p], value[p], p);
                            this.overwriteProps[this.overwriteProps.length] = p;
                        }
                        else
                        {
                            if (p == "scale")
                            {
                                addTween(this._target, "scaleX", this._target.scaleX, value.scale, "scaleX");
                                addTween(this._target, "scaleY", this._target.scaleY, value.scale, "scaleY");
                                this.overwriteProps[this.overwriteProps.length] = "scaleX";
                                this.overwriteProps[this.overwriteProps.length] = "scaleY";
                            }
                            else
                            {
                                if (!(((p == "width") || (p == "height")) && (!(this._proxy == null))))
                                {
                                    addTween(this._target, p, this._target[p], value[p], p);
                                    this.overwriteProps[this.overwriteProps.length] = p;
                                };
                            };
                        };
                    };
                };
            };
            if (tween != null)
            {
                enumerables = tween.vars;
                if ((("x" in enumerables) || ("y" in enumerables)))
                {
                    if (("x" in enumerables))
                    {
                        endX = ((typeof(enumerables.x) == "number") ? enumerables.x : (this._target.x + Number(enumerables.x)));
                    };
                    if (("y" in enumerables))
                    {
                        endY = ((typeof(enumerables.y) == "number") ? enumerables.y : (this._target.y + Number(enumerables.y)));
                    };
                    tween.killVars({
                        "x":true,
                        "y":true
                    }, false);
                    this.changeFactor = 1;
                    if ((!(isNaN(endX))))
                    {
                        addTween(this._point, "x", this._point.x, (this._point.x + (endX - this._target.x)), "x");
                    };
                    if ((!(isNaN(endY))))
                    {
                        addTween(this._point, "y", this._point.y, (this._point.y + (endY - this._target.y)), "y");
                    };
                    this.changeFactor = 0;
                };
            };
            return (true);
        }

        override public function killProps(_arg_1:Object):void
        {
            if (this._shortRotation != null)
            {
                this._shortRotation.killProps(_arg_1);
                if (this._shortRotation.overwriteProps.length == 0)
                {
                    _arg_1.shortRotation = true;
                };
            };
            super.killProps(_arg_1);
        }

        override public function set changeFactor(_arg_1:Number):void
        {
            var _local_2:Number;
            var _local_3:Number;
            var _local_4:Number;
            var _local_5:Point;
            var _local_6:PropTween;
            var _local_7:int;
            var _local_8:Number;
            if (((!(this._proxy == null)) && (!(this._proxy.parent == null))))
            {
                this._proxy.parent.addChild(this._target.parent);
            };
            if (this._target.parent)
            {
                _local_7 = _tweens.length;
                if (this.round)
                {
                    while (--_local_7 > -1)
                    {
                        _local_6 = _tweens[_local_7];
                        _local_2 = (_local_6.start + (_local_6.change * _arg_1));
                        _local_6.target[_local_6.property] = ((_local_2 > 0) ? int((_local_2 + 0.5)) : int((_local_2 - 0.5)));
                    };
                    _local_5 = this._target.parent.globalToLocal(this._target.localToGlobal(this._local));
                    _local_3 = ((this._target.x + this._point.x) - _local_5.x);
                    _local_4 = ((this._target.y + this._point.y) - _local_5.y);
                    this._target.x = ((_local_3 > 0) ? int((_local_3 + 0.5)) : int((_local_3 - 0.5)));
                    this._target.y = ((_local_4 > 0) ? int((_local_4 + 0.5)) : int((_local_4 - 0.5)));
                }
                else
                {
                    while (--_local_7 > -1)
                    {
                        _local_6 = _tweens[_local_7];
                        _local_6.target[_local_6.property] = (_local_6.start + (_local_6.change * _arg_1));
                    };
                    _local_5 = this._target.parent.globalToLocal(this._target.localToGlobal(this._local));
                    this._target.x = (this._target.x + (this._point.x - _local_5.x));
                    this._target.y = (this._target.y + (this._point.y - _local_5.y));
                };
            };
            _changeFactor = _arg_1;
            if (((!(this._proxy == null)) && (!(this._proxy.parent == null))))
            {
                _local_8 = this._target.rotation;
                this._proxy.rotation = (this._target.rotation = 0);
                if (this._proxySizeData.width != undefined)
                {
                    this._proxy.width = (this._target.width = this._proxySizeData.width);
                };
                if (this._proxySizeData.height != undefined)
                {
                    this._proxy.height = (this._target.height = this._proxySizeData.height);
                };
                this._proxy.rotation = (this._target.rotation = _local_8);
                _local_5 = this._target.parent.globalToLocal(this._target.localToGlobal(this._local));
                _local_3 = ((this._target.x + this._point.x) - _local_5.x);
                _local_4 = ((this._target.y + this._point.y) - _local_5.y);
                if (this.round)
                {
                    this._proxy.x = ((_local_3 > 0) ? int((_local_3 + 0.5)) : int((_local_3 - 0.5)));
                    this._proxy.y = ((_local_4 > 0) ? int((_local_4 + 0.5)) : int((_local_4 - 0.5)));
                }
                else
                {
                    this._proxy.x = _local_3;
                    this._proxy.y = _local_4;
                };
                this._proxy.parent.removeChild(this._target.parent);
            };
        }


    }
}//package com.greensock.plugins

