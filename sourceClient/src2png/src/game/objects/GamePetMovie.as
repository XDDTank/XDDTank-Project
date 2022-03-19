// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.objects.GamePetMovie

package game.objects
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import pet.date.PetInfo;
    import road.game.resource.ActionMovie;
    import flash.utils.Timer;
    import flash.events.Event;
    import com.pickgliss.loader.ModuleLoader;
    import ddt.utils.PositionUtils;
    import flash.geom.Point;
    import flash.events.TimerEvent;
    import com.pickgliss.utils.ObjectUtils;

    public class GamePetMovie extends Sprite implements Disposeable 
    {

        public static const PlayEffect:String = "PlayEffect";

        private var _petInfo:PetInfo;
        private var _player:GameTurnedLiving;
        private var _petMovie:ActionMovie;
        private var _isPlaying:Boolean = false;
        private var _actionTimer:Timer;
        private var _callBack:Function;
        private var _args:Array;

        public function GamePetMovie(_arg_1:PetInfo, _arg_2:GameTurnedLiving)
        {
            this._petInfo = _arg_1;
            this._player = _arg_2;
            this.init();
            this.initEvent();
        }

        private function initEvent():void
        {
            if (this._petMovie)
            {
                this._petMovie.addEventListener("effect", this.__playPlayerEffect);
            };
        }

        protected function __playPlayerEffect(_arg_1:Event):void
        {
            dispatchEvent(new Event(PlayEffect));
        }

        public function init():void
        {
            var _local_1:Class;
            if (((this._petInfo.assetReady) && (!(this._player.info.isBoss))))
            {
                _local_1 = (ModuleLoader.getDefinition(this._petInfo.actionMovieName) as Class);
                this._petMovie = new (_local_1)();
                addChild(this._petMovie);
            };
        }

        public function show(_arg_1:int=0, _arg_2:int=0):void
        {
            var _local_3:Class;
            if ((((this._petMovie == null) && (this._petInfo.assetReady)) && (!(this._player.info.isBoss))))
            {
                _local_3 = (ModuleLoader.getDefinition(this._petInfo.actionMovieName) as Class);
                this._petMovie = new (_local_3)();
                addChild(this._petMovie);
            };
            this._player.map.addToPhyLayer(this);
            PositionUtils.setPos(this, new Point(_arg_1, _arg_2));
        }

        public function hide():void
        {
            this._isPlaying = false;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }

        public function get info():PetInfo
        {
            return (this._petInfo);
        }

        public function set direction(_arg_1:int):void
        {
            if (this._petMovie)
            {
                this._petMovie.scaleX = -(_arg_1);
            };
        }

        public function doAction(_arg_1:String, _arg_2:Function=null, _arg_3:Array=null):void
        {
            this._callBack = _arg_2;
            this._args = _arg_3;
            this._isPlaying = true;
            if (this._petMovie)
            {
                this._petMovie.doAction(_arg_1, _arg_2, _arg_3);
            }
            else
            {
                if (this._actionTimer == null)
                {
                    this._actionTimer = new Timer(1000);
                    this._actionTimer.addEventListener(TimerEvent.TIMER, this.__timerHandler);
                };
                this._actionTimer.reset();
                this._actionTimer.start();
            };
        }

        protected function __timerHandler(_arg_1:TimerEvent):void
        {
            this._actionTimer.stop();
            this.callFun(this._callBack, this._args);
        }

        private function callFun(_arg_1:Function, _arg_2:Array):void
        {
            this._isPlaying = false;
            if (((_arg_2 == null) || (_arg_2.length == 0)))
            {
                (_arg_1());
            }
            else
            {
                if (_arg_2.length == 1)
                {
                    (_arg_1(_arg_2[0]));
                }
                else
                {
                    if (_arg_2.length == 2)
                    {
                        (_arg_1(_arg_2[0], _arg_2[1]));
                    }
                    else
                    {
                        if (_arg_2.length == 3)
                        {
                            (_arg_1(_arg_2[0], _arg_2[1], _arg_2[2]));
                        }
                        else
                        {
                            if (_arg_2.length == 4)
                            {
                                (_arg_1(_arg_2[0], _arg_2[1], _arg_2[2], _arg_2[3]));
                            };
                        };
                    };
                };
            };
        }

        public function get isPlaying():Boolean
        {
            return (this._isPlaying);
        }

        public function dispose():void
        {
            if (this._petMovie)
            {
                this._petMovie.removeEventListener("effect", this.__playPlayerEffect);
            };
            ObjectUtils.disposeObject(this._petMovie);
            this._petMovie = null;
            if (this._actionTimer)
            {
                this._actionTimer.removeEventListener(TimerEvent.TIMER, this.__timerHandler);
                this._actionTimer.stop();
                this._actionTimer = null;
            };
            this._petInfo = null;
            this._player = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.objects

