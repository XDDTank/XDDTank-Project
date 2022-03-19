// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.SoundEffectManager

package ddt.manager
{
    import flash.events.EventDispatcher;
    import flash.display.Loader;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.utils.Dictionary;
    import flash.events.IEventDispatcher;
    import flash.events.ProgressEvent;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.display.MovieClip;
    import ddt.command.SoundEffect;
    import flash.utils.getTimer;
    import ddt.events.SoundEffectEvent;

    public class SoundEffectManager extends EventDispatcher 
    {

        private static var _instance:SoundEffectManager;

        private var _loader:Loader;
        private var _soundDomain:ApplicationDomain;
        private var _context:LoaderContext;
        private var _lib:Dictionary;
        private var _delay:Dictionary;
        private var _maxCounts:Dictionary;
        private var _progress:Dictionary;
        private var _movieClips:Dictionary;
        private var _currentLib:String;

        public function SoundEffectManager(_arg_1:IEventDispatcher=null)
        {
            super(_arg_1);
        }

        public static function get Instance():SoundEffectManager
        {
            if (_instance == null)
            {
                _instance = new (SoundEffectManager)();
            };
            return (_instance);
        }


        public function setup():void
        {
            this._loader = new Loader();
            this._soundDomain = new ApplicationDomain();
            this._context = new LoaderContext(false, this._soundDomain);
            this._lib = new Dictionary();
            this._delay = new Dictionary();
            this._maxCounts = new Dictionary();
            this._progress = new Dictionary();
            this._movieClips = new Dictionary(true);
            this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.__onProgress);
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.__onLoadComplete);
        }

        public function loadSound(_arg_1:String):void
        {
            this._currentLib = _arg_1;
            if (this._progress[this._currentLib] == 1)
            {
                return;
            };
            this._progress[this._currentLib] = 0;
            this._loader.load(new URLRequest(this._currentLib), this._context);
        }

        public function definition(_arg_1:String):*
        {
            return (this._soundDomain.getDefinition(_arg_1));
        }

        public function get progress():int
        {
            return (this._progress[this._currentLib]);
        }

        public function controlMovie(_arg_1:MovieClip):void
        {
            _arg_1.addEventListener("play", this.__onPlay);
            this._movieClips[_arg_1] = _arg_1;
        }

        public function releaseMovie(_arg_1:MovieClip):void
        {
            _arg_1.removeEventListener("play", this.__onPlay);
            delete this._movieClips[_arg_1];
            this._movieClips[_arg_1] = null;
        }

        private function play(_arg_1:String):void
        {
            var _local_2:int;
            var _local_3:SoundEffect;
            if (this._lib[this._currentLib] == null)
            {
                this.loadSound(this._currentLib);
            }
            else
            {
                _local_2 = getTimer();
                if (this.checkPlay(_arg_1))
                {
                    _local_3 = new SoundEffect(_arg_1);
                    _local_3.addEventListener(Event.SOUND_COMPLETE, this.__onSoundComplete);
                    _local_3.play();
                };
            };
        }

        private function checkPlay(_arg_1:String):Boolean
        {
            var _local_2:int;
            if (this._delay[_arg_1])
            {
                if (this._delay[_arg_1].length > 0)
                {
                    _local_2 = getTimer();
                    if ((_local_2 - this._delay[_arg_1][0]) > 200)
                    {
                        if (this._delay[_arg_1].length >= this._maxCounts[_arg_1])
                        {
                            this._delay[_arg_1].shift();
                        };
                        this._delay[_arg_1].push(_local_2);
                        return (true);
                    };
                    return (false);
                };
            }
            else
            {
                this._delay[_arg_1] = [getTimer()];
                return (true);
            };
            return (true);
        }

        private function __onPlay(_arg_1:SoundEffectEvent):void
        {
            this._maxCounts[_arg_1.soundInfo.soundId] = _arg_1.soundInfo.maxCount;
            this.play(_arg_1.soundInfo.soundId);
        }

        private function __onProgress(_arg_1:ProgressEvent):void
        {
            this._progress[this._currentLib] = Math.floor((_arg_1.bytesLoaded / _arg_1.bytesTotal));
        }

        private function __onLoadComplete(_arg_1:Event):void
        {
            this._lib[this._currentLib] = true;
            this._progress[this._currentLib] = 1;
        }

        private function __onSoundComplete(_arg_1:Event):void
        {
            var _local_2:SoundEffect = (_arg_1.currentTarget as SoundEffect);
            this._delay[_local_2.id].shift();
            _local_2.dispose();
            _local_2 = null;
        }


    }
}//package ddt.manager

