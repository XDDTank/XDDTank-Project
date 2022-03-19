// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.animations.SpellSkillAnimation

package game.animations
{
    import flash.events.EventDispatcher;
    import flash.geom.Point;
    import game.objects.GamePlayer;
    import flash.display.Bitmap;
    import game.view.GameViewBase;
    import flash.display.Sprite;
    import flash.display.MovieClip;
    import game.view.map.MapView;
    import flash.geom.Matrix;
    import flash.display.BitmapData;
    import road7th.math.interpolateNumber;
    import flash.events.Event;
    import com.pickgliss.utils.ClassUtils;
    import org.aswing.KeyboardManager;
    import flash.events.KeyboardEvent;

    public class SpellSkillAnimation extends EventDispatcher implements IAnimate 
    {

        private var _begin:Point;
        private var _end:Point;
        private var _scale:Number;
        private var _life:int;
        private var _backlist:Array;
        private var _finished:Boolean;
        private var _player:GamePlayer;
        private var _characterCopy:Bitmap;
        private var _gameView:GameViewBase;
        private var _skill:Sprite;
        private var _skillAsset:MovieClip;
        private var _effect:ScaleEffect;
        private var _skillType:int;
        private var map:MapView;

        public function SpellSkillAnimation(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:GamePlayer, _arg_8:GameViewBase)
        {
            this._scale = 1.5;
            var _local_9:Number = ((-(_arg_5) * this._scale) + _arg_3);
            var _local_10:Number = ((-(_arg_6) * this._scale) + _arg_4);
            var _local_11:Matrix = new Matrix(this._scale, 0, 0, this._scale);
            this._end = new Point(_arg_1, _arg_2);
            this._end = _local_11.transformPoint(this._end);
            this._end.x = ((_arg_3 / 2) - this._end.x);
            this._end.y = (((_arg_4 / 4) * 3) - this._end.y);
            this._end.x = ((this._end.x > 0) ? 0 : ((this._end.x < _local_9) ? _local_9 : this._end.x));
            this._end.y = ((this._end.y > 0) ? 0 : ((this._end.y < _local_10) ? _local_10 : this._end.y));
            this._player = _arg_7;
            this._gameView = _arg_8;
            this._life = 0;
            this._backlist = new Array();
            this._finished = false;
            this._skillType = Math.ceil((Math.random() * 4));
        }

        public function get level():int
        {
            return (AnimationLevel.HIGHT);
        }

        public function canAct():Boolean
        {
            return (!(this._finished));
        }

        public function prepare(_arg_1:AnimationSet):void
        {
        }

        public function canReplace(_arg_1:IAnimate):Boolean
        {
            return (false);
        }

        public function cancel():void
        {
            this.map.lockPositon = false;
            if (((this._skill) && (this._skill.parent)))
            {
                this._skill.parent.removeChild(this._skill);
            };
            if (((this._skillAsset) && (this._skillAsset.parent)))
            {
                this._skillAsset.parent.removeChild(this._skillAsset);
            };
            if (this._effect)
            {
                this._effect.dispose();
            };
            if (this.map)
            {
                this.map.restoreStageTopLiving();
                while (this._backlist.length > 0)
                {
                    this.map.setMatrx(this._backlist.pop());
                };
                if (this.map.ground)
                {
                    this.map.ground.alpha = 1;
                };
                if (this.map.stone)
                {
                    this.map.stone.alpha = 1;
                };
                if (this.map.sky)
                {
                    this.map.sky.alpha = 1;
                };
                this.map.showPhysical();
            };
            this.map = null;
            this._player = null;
            this._gameView = null;
            this._skill = null;
            this._skillAsset = null;
            this._effect = null;
        }

        public function update(movie:MapView):Boolean
        {
            var a:Number;
            var tp:Point;
            var s:Number;
            var m:Matrix;
            var bmd:BitmapData;
            try
            {
                this.map = movie;
                this._life++;
                if (((this._skill) && (this._effect)))
                {
                    this._skill.addChild(this._effect);
                };
                if (this._life == 1)
                {
                    this.map.lockPositon = true;
                    this.map.sky.alpha = (1 - (this._life / 20));
                    this.map.hidePhysical(this._player);
                    this.map.bringToStageTop(this._player);
                }
                else
                {
                    if (this._life < 6)
                    {
                        if (this._backlist.length == 0)
                        {
                            this._begin = new Point(this.map.x, this.map.y);
                            this._backlist.push(this.map.transform.matrix.clone());
                        };
                        this.map.sky.alpha = (1 - (this._life / 15));
                        tp = Point.interpolate(this._end, this._begin, ((this._life - 1) / 5));
                        s = interpolateNumber(0, 1, 1, this._scale, ((this._life - 1) / 5));
                        m = new Matrix();
                        m.scale(s, s);
                        m.translate(tp.x, tp.y);
                        this.map.setMatrx(m);
                        this._backlist.push(m);
                    }
                    else
                    {
                        if (this._life < 15)
                        {
                            this.map.sky.alpha = (1 - (this._life / 15));
                        }
                        else
                        {
                            if (this._life == 15)
                            {
                                this.map.sky.alpha = (1 - (this._life / 15));
                                if (((this._skillAsset) && (this._skillAsset.parent)))
                                {
                                    this._skillAsset.parent.removeChild(this._skillAsset);
                                };
                                this._skill = this.createSkillCartoon(this._skillType);
                                this._skill.mouseChildren = (this._skill.mouseEnabled = false);
                                bmd = ((Math.random() > 0.3) ? this._player.character.charaterWithoutWeapon : this._player.character.winCharater);
                                this._effect = new ScaleEffect(this._skillType, bmd);
                                this._skill.addChild(this._effect);
                                this._skill.scaleX = this._player.player.direction;
                                this._skill.x = ((this._player.player.direction > 0) ? 0 : 1000);
                                this._gameView.addChildAt(this._skill, 1);
                            }
                            else
                            {
                                if (this._life == 52)
                                {
                                    this.map.showPhysical();
                                }
                                else
                                {
                                    if (this._life > 47)
                                    {
                                        if (this._backlist.length > 0)
                                        {
                                            this.map.setMatrx(this._backlist.pop());
                                            this.map.sky.alpha = ((this._life - 47) / 5);
                                        }
                                        else
                                        {
                                            this.cancel();
                                            this._finished = true;
                                            dispatchEvent(new Event(Event.COMPLETE));
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            }
            catch(e:Error)
            {
                cancel();
            };
            return (true);
        }

        private function createSkillCartoon(_arg_1:int):Sprite
        {
            var _local_2:String = "";
            if (_arg_1 == 2)
            {
                _local_2 = ("asset.game.specialSkillA" + Math.ceil((Math.random() * 4)));
            }
            else
            {
                _local_2 = ("asset.game.specialSkillB" + Math.ceil((Math.random() * 4)));
            };
            return (MovieClip(ClassUtils.CreatInstance(_local_2)));
        }

        public function get finish():Boolean
        {
            return (this._finished);
        }

        public function get ownerID():int
        {
            return (AnimationSet.PUBLIC_OWNER);
        }

        private function test():void
        {
            KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN, this.__down);
        }

        protected function __down(_arg_1:KeyboardEvent):void
        {
            this._life++;
        }


    }
}//package game.animations

