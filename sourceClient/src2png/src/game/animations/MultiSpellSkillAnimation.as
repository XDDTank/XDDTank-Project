// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.animations.MultiSpellSkillAnimation

package game.animations
{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import flash.geom.Point;
    import game.objects.GamePlayer;
    import flash.display.Bitmap;
    import game.view.GameViewBase;
    import game.view.map.MapView;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    import com.pickgliss.utils.ObjectUtils;
    import flash.display.BitmapData;
    import road7th.math.interpolateNumber;
    import com.pickgliss.toplevel.StageReferance;
    import flash.events.Event;
    import flash.display.MovieClip;
    import com.pickgliss.utils.ClassUtils;
    import __AS3__.vec.*;

    public class MultiSpellSkillAnimation extends EventDispatcher implements IAnimate 
    {

        private static const SKILL_TYPE:int = 2;
        private static const OFF_X:int = -68;

        private var _typeList:Vector.<int> = Vector.<int>([1, 2, 3, 4]);
        private var _begin:Point;
        private var _end:Point;
        private var _scale:Number;
        private var _life:int;
        private var _backlist:Array;
        private var _finished:Boolean;
        private var _playerList:Vector.<GamePlayer>;
        private var _characterCopyList:Vector.<Bitmap>;
        private var _gameView:GameViewBase;
        private var map:MapView;
        private var _skillList:Vector.<Sprite>;
        private var _effectList:Vector.<ScaleEffect>;
        private var _skillTypeList:Vector.<int>;
        private var _container:Sprite;

        public function MultiSpellSkillAnimation(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Vector.<GamePlayer>, _arg_8:GameViewBase)
        {
            var _local_13:int;
            super();
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
            this._playerList = _arg_7;
            this._gameView = _arg_8;
            this._container = new Sprite();
            this._container.x = OFF_X;
            this._gameView.addChildAt(this._container, 1);
            this._life = 0;
            this._backlist = new Array();
            this._finished = false;
            this._skillList = new Vector.<Sprite>(this._playerList.length);
            this._effectList = new Vector.<ScaleEffect>(this._playerList.length);
            this._skillTypeList = new Vector.<int>(this._playerList.length);
            var _local_12:int;
            while (_local_12 < this._playerList.length)
            {
                _local_13 = this._typeList.splice(int((Math.random() * this._typeList.length)), 1)[0];
                this._skillTypeList[_local_12] = _local_13;
                _local_12++;
            };
        }

        public function get level():int
        {
            return (AnimationLevel.HIGHEST);
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
            var _local_1:int;
            while (_local_1 < this._skillList.length)
            {
                if (((this._skillList[_local_1]) && (this._skillList[_local_1].parent)))
                {
                    this._skillList[_local_1].parent.removeChild(this._skillList[_local_1]);
                };
                if (this._effectList[_local_1])
                {
                    this._effectList[_local_1].dispose();
                };
                _local_1++;
            };
            if (this.map)
            {
                this.map.lockPositon = false;
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
            ObjectUtils.disposeObject(this._container);
            this._container = null;
            this.map = null;
            this._playerList = null;
            this._gameView = null;
            this._skillList.length = 0;
            this._skillList = null;
            this._effectList.length = 0;
            this._effectList = null;
            this._skillTypeList.length = 0;
            this._skillTypeList = null;
        }

        public function update(movie:MapView):Boolean
        {
            var count:int;
            var a:Number;
            var i:int;
            var tp:Point;
            var s:Number;
            var m:Matrix;
            var bmd:BitmapData;
            var width:Number;
            try
            {
                count = this._playerList.length;
                this.map = movie;
                this._life++;
                i = 0;
                while (i < count)
                {
                    if (((this._skillList[i]) && (this._effectList[i])))
                    {
                        this._skillList[i].addChild(this._effectList[i]);
                    };
                    if (this._life == 1)
                    {
                        this.map.lockPositon = true;
                        this.map.sky.alpha = (1 - (this._life / 20));
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
                                    this._skillList[i] = this.createSkillCartoon(this._skillTypeList[i]);
                                    this._skillList[i].mouseChildren = (this._skillList[i].mouseEnabled = false);
                                    bmd = ((Math.random() > 0.3) ? this._playerList[i].character.charaterWithoutWeapon : this._playerList[i].character.winCharater);
                                    this._effectList[i] = new ScaleEffect((((i % 2) == 0) ? 2 : 5), bmd);
                                    this._skillList[i].addChild(this._effectList[i]);
                                    width = (StageReferance.stageWidth / 3);
                                    this._skillList[i].x = (((StageReferance.stageWidth / 2) - ((width * count) / 2)) + (width * i));
                                    this._container.addChild(this._skillList[i]);
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
                                                break;
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                    i = (i + 1);
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
            _local_2 = ("asset.game.specialSkillA" + _arg_1);
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


    }
}//package game.animations

