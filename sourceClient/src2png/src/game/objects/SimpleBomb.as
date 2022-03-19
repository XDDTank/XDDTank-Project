// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.objects.SimpleBomb

package game.objects
{
    import phy.bombs.BaseBomb;
    import game.view.Bomb;
    import game.model.Living;
    import road7th.utils.MovieClipWrapper;
    import phy.object.SmallObject;
    import game.model.GameInfo;
    import flash.display.MovieClip;
    import flash.display.Bitmap;
    import flash.geom.Point;
    import game.view.smallMap.SmallBomb;
    import game.view.map.MapView;
    import ddt.manager.BallManager;
    import flash.geom.Rectangle;
    import phy.maps.Map;
    import par.emitters.Emitter;
    import game.model.Player;
    import game.GameManager;
    import ddt.manager.SharedManager;
    import par.ParticleManager;
    import game.animations.PhysicalObjFocusAnimation;
    import game.animations.AnimationLevel;
    import phy.object.Physics;
    import flash.geom.Matrix;
    import game.animations.ShockMapAnimation;
    import ddt.manager.SoundManager;
    import flash.events.Event;
    import com.pickgliss.ui.ComponentFactory;

    public class SimpleBomb extends BaseBomb 
    {

        protected var _info:Bomb;
        protected var _lifeTime:int;
        protected var _owner:Living;
        protected var _emitters:Array;
        protected var _spinV:Number;
        protected var _blastMC:MovieClipWrapper;
        protected var _dir:int = 1;
        protected var _smallBall:SmallObject;
        private var _game:GameInfo;
        private var _bitmapNum:int;
        private var _refineryLevel:int;
        protected var _bullet:MovieClip;
        protected var _blastOut:MovieClip;
        protected var _crater:Bitmap;
        protected var _craterBrink:Bitmap;
        private var _endPoint:Point;
        private var _lastPos:Point = new Point();
        private var _nowPos:Point = new Point();
        private var fastModel:Boolean;

        public function SimpleBomb(_arg_1:Bomb, _arg_2:Living, _arg_3:int=0)
        {
            this._info = _arg_1;
            this._lifeTime = 0;
            this._owner = _arg_2;
            this._bitmapNum = 0;
            this._refineryLevel = _arg_3;
            this._emitters = new Array();
            this._smallBall = new SmallBomb();
            super(this._info.Id, _arg_1.Template.Mass, _arg_1.Template.Weight, _arg_1.Template.Wind, _arg_1.Template.DragIndex);
            this.createBallAsset();
        }

        public function get map():MapView
        {
            return (_map as MapView);
        }

        public function get info():Bomb
        {
            return (this._info);
        }

        public function get owner():Living
        {
            return (this._owner);
        }

        private function createBallAsset():void
        {
            var _local_1:BombAsset;
            this._bullet = BallManager.createBulletMovie(this.info.Template.ID);
            this._blastOut = BallManager.createBlastOutMovie(this.info.Template.blastOutID);
            if (BallManager.hasBombAsset(this.info.Template.craterID))
            {
                _local_1 = BallManager.getBombAsset(this.info.Template.craterID);
                this._crater = _local_1.crater;
                this._craterBrink = _local_1.craterBrink;
            };
        }

        protected function initMovie():void
        {
            super.setMovie(this._bullet, this._crater, this._craterBrink);
            if (this._blastOut)
            {
                this._blastOut.x = 0;
                this._blastOut.y = 0;
            };
            if ((!(this._info)))
            {
                return;
            };
            if (((((this.owner) && (!(this.owner.isSelf))) && (this._info.Template.ID == Bomb.FLY_BOMB)) && (this.owner.isHidden)))
            {
                this.visible = false;
                this._smallBall.visible = false;
            };
            this._blastMC = new MovieClipWrapper(this._blastOut, false, true);
            _testRect = new Rectangle(-3, -3, 6, 6);
            addSpeedXY(new Point(this._info.VX, this._info.VY));
            this._dir = ((this._info.VX >= 0) ? 1 : -1);
            x = this._info.X;
            y = this._info.Y;
            if (this._info.Template.SpinV > 0)
            {
                _movie.scaleX = this._dir;
            }
            else
            {
                _movie.scaleY = this._dir;
            };
            rotation = ((motionAngle * 180) / Math.PI);
            mouseChildren = (mouseEnabled = false);
        }

        override public function setMap(_arg_1:Map):void
        {
            super.setMap(_arg_1);
            if (_arg_1)
            {
                this._game = this.map.game;
                this.initMovie();
            };
        }

        override public function startMoving():void
        {
            var _local_1:int;
            var _local_2:Emitter;
            var _local_3:Player;
            super.startMoving();
            if (GameManager.Instance.Current == null)
            {
                return;
            };
            if (((SharedManager.Instance.showParticle) && (visible)))
            {
                _local_1 = 0;
                if (this._info.changedPartical != "")
                {
                    if (this.owner.isPlayer())
                    {
                        _local_3 = (this.owner as Player);
                        _local_1 = _local_3.currentWeapInfo.refineryLevel;
                    };
                    _local_2 = ParticleManager.creatEmitter(int(this._info.changedPartical));
                };
                if (_local_2)
                {
                    _map.particleEnginee.addEmitter(_local_2);
                    this._emitters.push(_local_2);
                };
            };
            this._spinV = (this._info.Template.SpinV * this._dir);
        }

        override public function get smallView():SmallObject
        {
            return (this._smallBall);
        }

        override public function moveTo(_arg_1:Point):void
        {
            var _local_2:BombAction;
            var _local_3:Emitter;
            while (this._info.Actions.length > 0)
            {
                if (this._info.Actions[0].time > this._lifeTime) break;
                _local_2 = this._info.Actions.shift();
                this._info.UsedActions.push(_local_2);
                _local_2.execute(this, this._game);
                if ((!(_isLiving)))
                {
                    return;
                };
            };
            if (_isLiving)
            {
                if (_map.IsOutMap(_arg_1.x, _arg_1.y))
                {
                    this.die();
                }
                else
                {
                    this.map.smallMap.updatePos(this._smallBall, pos);
                    for each (_local_3 in this._emitters)
                    {
                        _local_3.x = x;
                        _local_3.y = y;
                        _local_3.angle = motionAngle;
                    };
                    pos = _arg_1;
                    if (this.isSetFocus())
                    {
                        this.map.animateSet.addAnimation(new PhysicalObjFocusAnimation(this, 25, 0, AnimationLevel.HIGHT, this._info.livingID));
                    };
                };
            };
        }

        private function isSetFocus():Boolean
        {
            var _local_1:int = GameManager.Instance.Current.roomType;
            if (this._info.shootCount == 1)
            {
                return (true);
            };
            this._lastPos = GameManager.Instance.Current.lastShootPos;
            this._nowPos.x = this._info.target.x;
            this._nowPos.y = this._info.target.y;
            return (this.shootPointDirect());
        }

        private function shootPointDirect(_arg_1:int=200, _arg_2:int=200):Boolean
        {
            if (((this._nowPos == null) || (this._lastPos == null)))
            {
                return (true);
            };
            if (Math.abs((this._nowPos.x - this._lastPos.x)) > _arg_1)
            {
                return (true);
            };
            if (Math.abs((this._nowPos.y - this._lastPos.y)) > _arg_2)
            {
                return (true);
            };
            return (false);
        }

        public function clearWG():void
        {
            _wf = 0;
            _gf = 0;
            _arf = 0;
        }

        override public function bomb():void
        {
            var _local_2:Physics;
            var _local_3:uint;
            this.map.transform.matrix = new Matrix();
            if (this._info.IsHole)
            {
                super.DigMap();
                this.map.smallMap.draw();
                this.map.resetMapChanged();
            };
            var _local_1:Array = this.map.getPhysicalObjectByPoint(pos, 100, this);
            for each (_local_2 in _local_1)
            {
                if ((_local_2 is TombView))
                {
                    _local_2.startMoving();
                };
            };
            this.stopMoving();
            if ((!(this.fastModel)))
            {
                if (this._info.Template.Shake)
                {
                    _local_3 = 7;
                    if (this.info.damageMod < 1)
                    {
                        _local_3 = 4;
                    };
                    if (this.info.damageMod > 2)
                    {
                        _local_3 = 14;
                    };
                    this.map.addAnimation(new ShockMapAnimation(this, _local_3, 0, AnimationLevel.HIGHT), this.owner);
                }
                else
                {
                    this.map.livingSetCenter(this.x, this.y, false, AnimationLevel.HIGHT, this._owner.LivingID);
                };
                if (((this.info.shootCount == 1) || (!(this.shootPointDirect(200, 30)))))
                {
                    this.map.livingSetCenter(this.x, this.y, false, AnimationLevel.HIGHT, this._owner.LivingID);
                };
                this._nowPos.x = this._info.target.x;
                this._nowPos.y = this._info.target.y;
                if (this.map.lockOwner == this._info.livingID)
                {
                    GameManager.Instance.Current.lastShootPos = this._nowPos;
                };
            };
            if ((!(this.fastModel)))
            {
                if (_isLiving)
                {
                    SoundManager.instance.play(this._info.Template.BombSound);
                };
                if (visible)
                {
                    this._blastMC.movie.x = x;
                    this._blastMC.movie.y = y;
                    _map.addToPhyLayer(this._blastMC.movie);
                    this._blastMC.addEventListener(Event.COMPLETE, this.__complete);
                    this._blastMC.play();
                }
                else
                {
                    this.die();
                };
            }
            else
            {
                this.die();
            };
            if (parent)
            {
                parent.removeChild(this);
            };
            dispatchEvent(new Event(Event.COMPLETE));
        }

        override public function bombAtOnce():void
        {
            var _local_1:BombAction;
            var _local_5:BombAction;
            this.fastModel = true;
            var _local_2:int;
            while (_local_2 < this._info.Actions.length)
            {
                if (this._info.Actions[_local_2].type == ActionType.BOMB)
                {
                    _local_1 = this._info.Actions[_local_2];
                    break;
                };
                _local_2++;
            };
            var _local_3:int = this._info.Actions.indexOf(_local_1);
            var _local_4:Array = this._info.Actions.splice(_local_3, 1);
            if (_local_1)
            {
                this._info.Actions.push(_local_1);
            };
            while (this._info.Actions.length > 0)
            {
                _local_5 = this._info.Actions.shift();
                this._info.UsedActions.push(_local_5);
                _local_5.execute(this, this._game);
                if ((!(_isLiving)))
                {
                    return;
                };
            };
            if (this._info)
            {
                this._info.Actions = [];
            };
        }

        private function __complete(_arg_1:Event):void
        {
            this.die();
        }

        override public function die():void
        {
            dispatchEvent(new Event(Event.COMPLETE));
            super.die();
            this.dispose();
        }

        override public function stopMoving():void
        {
            var _local_1:Emitter;
            for each (_local_1 in this._emitters)
            {
                _map.particleEnginee.removeEmitter(_local_1);
            };
            this._emitters = [];
            super.stopMoving();
        }

        override protected function updatePosition(_arg_1:Number):void
        {
            this._lifeTime = (this._lifeTime + 40);
            var _local_2:Point = ComponentFactory.Instance.creatCustomObject("tian.bombSpeed");
            super.updatePosition((_arg_1 * _local_2.y));
            if ((!(_isLiving)))
            {
                return;
            };
            if (((this._spinV > 1) || (this._spinV < -1)))
            {
                this._spinV = int((this._spinV * this._info.Template.SpinVA));
                _movie.rotation = (_movie.rotation + this._spinV);
            };
            rotation = ((motionAngle * 180) / Math.PI);
        }

        public function get target():Point
        {
            if (this._info)
            {
                return (this._info.target);
            };
            return (null);
        }

        override public function dispose():void
        {
            super.dispose();
            if (this._blastMC)
            {
                this._blastMC.removeEventListener(Event.COMPLETE, this.__complete);
                this._blastMC.dispose();
                this._blastMC = null;
            };
            if (_map)
            {
                _map.removePhysical(this);
            };
            if (this._smallBall)
            {
                if (this._smallBall.parent)
                {
                    this._smallBall.parent.removeChild(this._smallBall);
                };
                this._smallBall.dispose();
                this._smallBall = null;
            };
            if (parent)
            {
                parent.removeChild(this);
            };
            this._crater = null;
            this._craterBrink = null;
            this._owner = null;
            this._emitters = null;
            this._info = null;
            this._game = null;
            this._bullet = null;
            this._blastOut = null;
        }


    }
}//package game.objects

