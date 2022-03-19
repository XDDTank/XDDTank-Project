// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.states.BaseStateView

package ddt.states
{
    import flash.display.Sprite;
    import ddt.interfaces.ITaskDirect;
    import flash.utils.Timer;
    import __AS3__.vec.Vector;
    import flash.display.DisplayObject;
    import ddt.loader.StartupResourceLoader;
    import ddt.manager.SoundManager;
    import ddt.manager.QQtipsManager;
    import com.pickgliss.toplevel.StageReferance;
    import com.pickgliss.ui.LayerManager;
    import flash.events.TimerEvent;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import com.greensock.TweenLite;
    import com.pickgliss.utils.ObjectUtils;
    import trainer.view.NewHandContainer;
    import ddt.manager.TaskDirectorManager;
    import __AS3__.vec.*;

    public class BaseStateView extends Sprite implements ITaskDirect 
    {

        private var _prepared:Boolean;
        private var _container:Sprite;
        private var _timer:Timer;
        private var _size:int = 60;
        private var _completed:int = 0;
        private var _shapes:Vector.<DisplayObject>;
        private var _oldStageWidth:int;

        public function BaseStateView():void
        {
            this._container = new Sprite();
        }

        public function get prepared():Boolean
        {
            return (this._prepared);
        }

        public function check(_arg_1:String):Boolean
        {
            return (true);
        }

        public function prepare():void
        {
            this._prepared = true;
        }

        public function enter(_arg_1:BaseStateView, _arg_2:Object=null):void
        {
            if (((!(this.getType() == StateType.ROOM_LOADING)) && (!(StartupResourceLoader.firstEnterHall))))
            {
                SoundManager.instance.playMusic("062", true, false);
            };
            QQtipsManager.instance.checkStateView(this.getType());
            this.playEnterMovie();
            this.showDirect();
        }

        private function playEnterMovie():void
        {
            if (((this._timer) && (this._timer.running)))
            {
                return;
            };
            this._completed = 0;
            if (((this._shapes == null) || (!(StageReferance.stageWidth == this._oldStageWidth))))
            {
                this.createShapes();
                this._oldStageWidth = StageReferance.stageWidth;
            };
            this.rebackInitState();
            this._container.visible = true;
            LayerManager.Instance.addToLayer(this._container, LayerManager.STAGE_TOP_LAYER, false, 0, true);
            this._timer = new Timer(20);
            this._timer.addEventListener(TimerEvent.TIMER, this.__tick);
            this._timer.start();
        }

        private function createShapes():void
        {
            var _local_1:int;
            var _local_2:int;
            var _local_4:Bitmap;
            var _local_3:BitmapData = new BitmapData(this._size, this._size, false, 0);
            this.removeShapes();
            this._shapes = new Vector.<DisplayObject>();
            do 
            {
                _local_2 = 0;
                do 
                {
                    _local_4 = new Bitmap(_local_3);
                    this._shapes.push(_local_4);
                    _local_2 = (_local_2 + this._size);
                } while (_local_2 < StageReferance.stageHeight);
                _local_1 = (_local_1 + this._size);
            } while (_local_1 < StageReferance.stageWidth);
        }

        private function removeShapes():void
        {
            var _local_1:DisplayObject;
            if (this._shapes)
            {
                while (this._shapes.length > 0)
                {
                    _local_1 = this._shapes.shift();
                    TweenLite.killTweensOf(_local_1);
                    ObjectUtils.disposeObject(_local_1);
                };
                this._shapes = null;
            };
        }

        private function rebackInitState():void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_1:int;
            _local_2 = 0;
            _local_3 = 0;
            do 
            {
                _local_2 = 0;
                do 
                {
                    this._shapes[_local_3].width = this._size;
                    this._shapes[_local_3].height = this._size;
                    this._shapes[_local_3].x = _local_1;
                    this._shapes[_local_3].y = _local_2;
                    this._shapes[_local_3].alpha = 1;
                    this._container.addChild(this._shapes[_local_3]);
                    _local_2 = (_local_2 + this._size);
                    _local_3++;
                } while (_local_2 < StageReferance.stageHeight);
                _local_1 = (_local_1 + this._size);
            } while (_local_1 < StageReferance.stageWidth);
        }

        private function __tick(_arg_1:TimerEvent):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:DisplayObject;
            var _local_2:int = (this._timer.currentCount - 1);
            if (_local_2 >= 0)
            {
                if ((this._size * _local_2) < StageReferance.stageWidth)
                {
                    _local_3 = int(Math.floor((StageReferance.stageHeight / this._size)));
                    _local_4 = (this._size >> 1);
                    _local_5 = 0;
                    while (_local_5 < _local_3)
                    {
                        _local_6 = this._shapes[(_local_5 + (_local_3 * _local_2))];
                        TweenLite.to(_local_6, 0.7, {
                            "x":(_local_6.x + _local_4),
                            "y":(_local_6.y + _local_4),
                            "width":0,
                            "height":0,
                            "alpha":0,
                            "onComplete":this.shapeTweenComplete
                        });
                        _local_5++;
                    };
                }
                else
                {
                    this._timer.stop();
                    this._timer.removeEventListener(TimerEvent.TIMER, this.__tick);
                };
            };
        }

        private function shapeTweenComplete():void
        {
            this._completed++;
            if (this._completed >= this._shapes.length)
            {
                this._container.visible = false;
            };
        }

        public function addedToStage():void
        {
        }

        public function leaving(_arg_1:BaseStateView):void
        {
            if (this._timer)
            {
                this._timer.removeEventListener(TimerEvent.TIMER, this.__tick);
                this._timer.stop();
            };
            this._timer = null;
            this.removeShapes();
            while (this._container.numChildren > 0)
            {
                this._container.removeChildAt(0);
            };
            NewHandContainer.Instance.clearArrowByID(-1);
            TaskDirectorManager.instance.removeArrow();
        }

        public function checkDispose(_arg_1:String):void
        {
            var _local_2:StateCreater = new StateCreater();
            var _local_3:Array = _local_2.getNeededUIModuleByType(_arg_1).split(",");
            _local_2 = null;
            _local_3 = null;
        }

        public function removedFromStage():void
        {
        }

        public function getView():DisplayObject
        {
            return (this);
        }

        public function getType():String
        {
            return (StateType.DEAFULT);
        }

        public function getBackType():String
        {
            return ("");
        }

        public function goBack():Boolean
        {
            return (false);
        }

        public function fadingComplete():void
        {
        }

        public function dispose():void
        {
        }

        public function refresh():void
        {
            this.playEnterMovie();
        }

        public function showDirect():void
        {
        }


    }
}//package ddt.states

