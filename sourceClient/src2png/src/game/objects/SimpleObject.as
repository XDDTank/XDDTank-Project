// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.objects.SimpleObject

package game.objects
{
    import phy.object.PhysicalObj;
    import flash.display.MovieClip;
    import flash.utils.Dictionary;
    import phy.object.SmallObject;
    import flash.utils.Timer;
    import phy.object.PhysicsLayer;
    import com.pickgliss.loader.ModuleLoader;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.DebugManager;
    import flash.events.TimerEvent;
    import game.view.smallMap.SmallLiving;
    import flash.display.FrameLabel;
    import road.game.resource.ActionMovie;
    import flash.media.SoundTransform;

    public class SimpleObject extends PhysicalObj 
    {

        protected var m_model:String;
        protected var m_action:String;
        protected var m_movie:MovieClip;
        protected var actionMapping:Dictionary;
        private var _smallMapView:SmallObject;
        private var _isBottom:Boolean;
        private var _timer:Timer;

        public function SimpleObject(_arg_1:int, _arg_2:int, _arg_3:String, _arg_4:String, _arg_5:Boolean=false)
        {
            super(_arg_1, _arg_2);
            this.actionMapping = new Dictionary();
            mouseChildren = false;
            mouseEnabled = false;
            scrollRect = null;
            this.m_model = _arg_3;
            this.m_action = _arg_4;
            this._isBottom = _arg_5;
            this.creatMovie(this.m_model);
            this.playAction(this.m_action);
            this.initSmallMapView();
        }

        override public function get layer():int
        {
            if (this._isBottom)
            {
                return (PhysicsLayer.AppointBottom);
            };
            return (PhysicsLayer.SimpleObject);
        }

        protected function creatMovie(_arg_1:String):void
        {
            var _local_2:Class;
            if (ModuleLoader.hasDefinition(this.m_model))
            {
                _local_2 = (ModuleLoader.getDefinition(this.m_model) as Class);
                if (this.m_movie)
                {
                    ObjectUtils.disposeObject(this.m_movie);
                    this.m_movie = null;
                };
            }
            else
            {
                DebugManager.getInstance().handle(("#game 缺少资源:" + _arg_1));
            };
            if (_local_2)
            {
                this.m_movie = new (_local_2)();
                addChild(this.m_movie);
            }
            else
            {
                this.m_movie = new MovieClip();
                addChild(this.m_movie);
                this._timer = new Timer(500);
                this._timer.addEventListener(TimerEvent.TIMER, this.__checkActionIsReady);
                this._timer.start();
            };
        }

        protected function __checkActionIsReady(_arg_1:TimerEvent):void
        {
            if (ModuleLoader.hasDefinition(this.m_model))
            {
                this._timer.stop();
                this._timer.removeEventListener(TimerEvent.TIMER, this.__checkActionIsReady);
                this._timer = null;
                this.creatMovie(this.m_model);
            };
        }

        protected function initSmallMapView():void
        {
            if (layerType == 0)
            {
                this._smallMapView = new SmallLiving();
                this._smallMapView.visible = false;
            };
        }

        override public function get smallView():SmallObject
        {
            return (this._smallMapView);
        }

        public function playAction(_arg_1:String):void
        {
            var _local_2:FrameLabel;
            if (this.actionMapping[_arg_1])
            {
                _arg_1 = this.actionMapping[_arg_1];
            };
            if ((this.m_movie is ActionMovie))
            {
                if (_arg_1 != "")
                {
                    this.m_movie.gotoAndPlay(_arg_1);
                };
                return;
            };
            if (this.m_movie)
            {
                if ((_arg_1 is String))
                {
                    for each (_local_2 in this.m_movie.currentLabels)
                    {
                        if (_local_2.name == _arg_1)
                        {
                            this.m_movie.gotoAndPlay(_arg_1);
                        };
                    };
                };
            };
            if (((_arg_1 == "1") || (_arg_1 == "2")))
            {
                this.m_movie.gotoAndPlay(_arg_1);
            };
            if (this._smallMapView != null)
            {
                this._smallMapView.visible = (_arg_1 == "2");
            };
        }

        override public function collidedByObject(_arg_1:PhysicalObj):void
        {
            this.playAction("pick");
        }

        override public function setActionMapping(_arg_1:String, _arg_2:String):void
        {
            if ((this.m_movie is ActionMovie))
            {
                (this.m_movie as ActionMovie).setActionMapping(_arg_1, _arg_2);
                return;
            };
            this.actionMapping[_arg_1] = _arg_2;
        }

        override public function dispose():void
        {
            if (this._timer)
            {
                this._timer.removeEventListener(TimerEvent.TIMER, this.__checkActionIsReady);
            };
            this._timer = null;
            var _local_1:SoundTransform = new SoundTransform();
            _local_1.volume = 0;
            if (this.m_movie)
            {
                this.m_movie.stop();
                this.m_movie.soundTransform = _local_1;
            };
            super.dispose();
            if (((this.m_movie) && (this.m_movie.parent)))
            {
                removeChild(this.m_movie);
            };
            this.m_movie = null;
            if (this._smallMapView)
            {
                this._smallMapView.dispose();
                this._smallMapView = null;
            };
        }

        public function get movie():MovieClip
        {
            return (this.m_movie);
        }


    }
}//package game.objects

