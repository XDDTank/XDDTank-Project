// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.animations.ScaleEffect

package game.animations
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.greensock.TimelineMax;
    import com.greensock.TweenProxy;
    import flash.display.BitmapData;
    import ddt.utils.BitmapUtils;
    import flash.filters.GlowFilter;
    import com.greensock.TweenMax;
    import flash.display.Shape;

    public class ScaleEffect extends Sprite implements Disposeable 
    {

        private var src1:Bitmap;
        private var src2:Bitmap;
        private var mainTimeLine:TimelineMax;
        private var tp1:TweenProxy;
        private var tp2:TweenProxy;

        public function ScaleEffect(_arg_1:int, _arg_2:BitmapData, _arg_3:int=1)
        {
            var _local_4:BitmapData;
            super();
            _local_4 = _arg_2.clone();
            BitmapUtils.reverseBtimapData(_local_4);
            scaleX = _arg_3;
            graphics.beginFill(0, 0);
            graphics.drawRect(0, 0, 1000, 600);
            graphics.endFill();
            mouseEnabled = (mouseChildren = false);
            this.mainTimeLine = new TimelineMax({"useFrames":true});
            if (_arg_1 == 1)
            {
                this.runScale(_local_4);
            }
            else
            {
                if (_arg_1 == 2)
                {
                    this.runDownToUp(_local_4);
                }
                else
                {
                    if (_arg_1 == 3)
                    {
                        this.runRightToLeft(_local_4);
                    }
                    else
                    {
                        if (_arg_1 == 4)
                        {
                            this.centerToScale(_local_4);
                        }
                        else
                        {
                            if (_arg_1 == 5)
                            {
                                this.runUpToDown(_local_4);
                            };
                        };
                    };
                };
            };
        }

        private function runScale(_arg_1:BitmapData):void
        {
            this.src1 = new Bitmap(_arg_1, "auto", true);
            this.src2 = new Bitmap(_arg_1, "auto", true);
            addChild(this.src1);
            addChild(this.src2);
            this.src1.filters = (this.src2.filters = [new GlowFilter(0xFFCC00, 1, 38, 38, 0.3)]);
            this.tp1 = new TweenProxy(this.src1);
            this.tp1.registrationX = (this.src1.width / 2);
            this.tp1.registrationY = (this.src1.height / 2);
            this.tp2 = new TweenProxy(this.src2);
            this.tp2.registrationX = (this.src2.width / 2);
            this.tp2.registrationY = (this.src2.height / 2);
            this.tp1.x = (this.tp2.x = -50);
            this.tp1.y = (this.tp2.y = 750);
            this.tp1.alpha = (this.tp2.alpha = 0);
            this.tp1.scaleX = (this.tp1.scaleY = (this.tp2.scaleX = (this.tp2.scaleY = 1)));
            var _local_2:Array = TweenMax.allTo([this.tp1, this.tp2], 4, {
                "x":170,
                "y":320,
                "alpha":0.7,
                "scaleX":1.6,
                "scaleY":1.6
            });
            var _local_3:Array = TweenMax.allTo([this.tp1, this.tp2], 30, {
                "scaleX":1.7,
                "scaleY":1.7,
                "x":170,
                "y":290
            });
            var _local_4:Array = TweenMax.allTo([this.tp1, this.tp2], 4, {
                "scaleX":3,
                "scaleY":3,
                "alpha":1
            }, 1);
            this.mainTimeLine.appendMultiple(_local_2);
            this.mainTimeLine.appendMultiple(_local_3);
            this.mainTimeLine.appendMultiple(_local_4);
        }

        private function runUpToDown(_arg_1:BitmapData):void
        {
            var _local_2:Shape = new Shape();
            _local_2.graphics.beginFill(0, 1);
            _local_2.graphics.drawRect(0, 0, 1000, 100);
            _local_2.graphics.drawRect(0, 500, 1000, 100);
            _local_2.graphics.endFill();
            this.src1 = new Bitmap(_arg_1, "auto", true);
            addChild(this.src1);
            this.tp1 = new TweenProxy(this.src1);
            this.tp1.registrationX = (this.src1.width / 2);
            this.tp1.registrationY = (this.src1.height / 2);
            this.tp1.x = 170;
            this.tp1.y = 0;
            this.tp1.scale = 2;
            var _local_3:Array = TweenMax.allTo([this.tp1], 4, {
                "alpha":1,
                "y":250
            });
            var _local_4:Array = TweenMax.allTo([this.tp1], 40, {"y":290});
            this.mainTimeLine.appendMultiple(_local_3);
            this.mainTimeLine.appendMultiple(_local_4);
        }

        private function runDownToUp(_arg_1:BitmapData):void
        {
            this.src1 = new Bitmap(_arg_1, "auto", true);
            addChild(this.src1);
            this.tp1 = new TweenProxy(this.src1);
            this.tp1.registrationX = (this.src1.width / 2);
            this.tp1.registrationY = (this.src1.height / 2);
            this.tp1.x = 170;
            this.tp1.y = 1000;
            this.tp1.scale = 2;
            var _local_2:Array = TweenMax.allTo([this.tp1], 4, {
                "alpha":1,
                "y":290
            });
            var _local_3:Array = TweenMax.allTo([this.tp1], 22, {"y":250});
            this.mainTimeLine.appendMultiple(_local_2, 8);
            this.mainTimeLine.appendMultiple(_local_3);
        }

        private function runRightToLeft(_arg_1:BitmapData):void
        {
            this.src1 = new Bitmap(_arg_1, "auto", true);
            addChild(this.src1);
            this.tp1 = new TweenProxy(this.src1);
            this.tp1.registrationX = (this.src1.width / 2);
            this.tp1.registrationY = (this.src1.height / 2);
            this.tp1.x = 1200;
            this.tp1.y = 270;
            this.tp1.alpha = 1;
            var _local_2:TweenMax = TweenMax.to(this.tp1, 8, {
                "x":170,
                "alpha":1,
                "scaleX":1.8,
                "scaleY":1.8
            });
            var _local_3:TweenMax = TweenMax.to(this.tp1, 26, {"x":150});
            var _local_4:TweenMax = TweenMax.to(this.tp1, 4, {
                "x":0,
                "alpha":0
            });
            this.mainTimeLine.append(_local_2);
            this.mainTimeLine.append(_local_3);
            this.mainTimeLine.append(_local_4);
        }

        private function changeRegist():void
        {
            this.tp1.registrationX = this.src1.width;
            this.tp1.registrationY = this.src1.height;
        }

        private function runLeftToRight(_arg_1:BitmapData):void
        {
            this.src1 = new Bitmap(_arg_1, "auto", true);
            addChild(this.src1);
            this.tp1 = new TweenProxy(this.src1);
            this.tp1.registrationX = (this.src1.width / 2);
            this.tp1.registrationY = (this.src1.height / 2);
            this.tp1.x = 0;
            this.tp1.y = 270;
            this.tp1.scaleX = (this.tp1.scaleY = 1.8);
            this.tp1.alpha = 0.5;
            var _local_2:TweenMax = TweenMax.to(this.tp1, 3, {
                "x":220,
                "alpha":0.8
            });
            var _local_3:TweenMax = TweenMax.to(this.tp1, 24, {
                "scaleX":2.1,
                "scaleY":2.1,
                "x":240
            });
            var _local_4:TweenMax = TweenMax.to(this.tp1, 5, {
                "scaleX":4,
                "scaleY":4,
                "alpha":0
            });
            this.mainTimeLine.append(_local_2);
            this.mainTimeLine.append(_local_3);
            this.mainTimeLine.append(_local_4);
        }

        private function centerToScale(_arg_1:BitmapData):void
        {
            this.src1 = new Bitmap(_arg_1, "auto", true);
            this.src2 = new Bitmap(_arg_1, "auto", true);
            addChild(this.src1);
            addChild(this.src2);
            this.src1.filters = (this.src2.filters = [new GlowFilter(0xFFCC00, 1, 40, 40, 0.3)]);
            this.tp1 = new TweenProxy(this.src1);
            this.tp1.registrationX = (this.src1.width / 2);
            this.tp1.registrationY = (this.src1.height / 2);
            this.tp2 = new TweenProxy(this.src2);
            this.tp2.registrationX = (this.src2.width / 2);
            this.tp2.registrationY = (this.src2.height / 2);
            this.tp1.x = (this.tp2.x = 170);
            this.tp1.y = (this.tp2.y = 270);
            this.tp1.scaleX = (this.tp1.scaleY = (this.tp2.scaleX = (this.tp2.scaleY = 0)));
            this.tp1.alpha = (this.tp2.alpha = 0.2);
            var _local_2:Array = TweenMax.allTo([this.tp1, this.tp2], 6, {
                "scaleX":2,
                "scaleY":2,
                "alpha":0.8
            });
            var _local_3:Array = TweenMax.allTo([this.tp1, this.tp2], 28, {
                "scaleX":2.2,
                "scaleY":2.2
            });
            var _local_4:Array = TweenMax.allTo([this.tp1, this.tp2], 4, {
                "scaleX":3,
                "scaleY":3,
                "alpha":0
            }, 2);
            this.mainTimeLine.appendMultiple(_local_2);
            this.mainTimeLine.appendMultiple(_local_3);
            this.mainTimeLine.appendMultiple(_local_4);
        }

        public function dispose():void
        {
            this.mainTimeLine.complete(true);
            this.mainTimeLine = null;
            this.tp1 = null;
            this.tp2 = null;
            if (this.src1)
            {
                if (this.src1.parent)
                {
                    this.src1.parent.removeChild(this.src1);
                };
                try
                {
                    this.src1.bitmapData.dispose();
                }
                catch(e:Error)
                {
                };
                this.src1 = null;
            };
            if (this.src2)
            {
                if (this.src2.parent)
                {
                    this.src2.parent.removeChild(this.src2);
                };
                try
                {
                    this.src2.bitmapData.dispose();
                }
                catch(e:Error)
                {
                };
                this.src2 = null;
            };
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.animations

