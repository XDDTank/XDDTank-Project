// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.view.MapObjView

package SingleDungeon.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.MovieClip;
    import SingleDungeon.model.WalkMapObject;
    import flash.events.MouseEvent;
    import ddt.manager.SharedManager;
    import flash.events.Event;
    import SingleDungeon.event.SingleDungeonEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;
    import flash.geom.Point;
    import ddt.manager.SocketManager;
    import flash.utils.setInterval;
    import game.view.DropGoods;
    import flash.media.SoundTransform;
    import flash.utils.clearInterval;

    public class MapObjView extends Sprite implements Disposeable 
    {

        private var _onCollecting:Boolean = false;
        private var _isCollectComplete:Boolean = false;
        private var _senceMap:SingleDungeonSenceMap;
        private var _dispChild:MovieClip;
        public var mapObjInfo:WalkMapObject;
        private var _intervalId:uint;
        private var _collectionAnm:MovieClip;

        public function MapObjView(_arg_1:SingleDungeonSenceMap, _arg_2:MovieClip)
        {
            this._senceMap = _arg_1;
            this._collectionAnm = _arg_2;
            this.initEvent();
            this.buttonMode = true;
        }

        public function set dispChild(_arg_1:MovieClip):void
        {
            if ((_arg_1 is MovieClip))
            {
                this.addChild(_arg_1);
                this._dispChild = _arg_1;
            };
        }

        private function initEvent():void
        {
            this.addEventListener(MouseEvent.CLICK, this.__onMouseClick);
            SharedManager.Instance.addEventListener(Event.CHANGE, this.__soundChange);
            this.__soundChange(null);
        }

        private function removeEvent():void
        {
            this.removeEventListener(MouseEvent.CLICK, this.__onMouseClick);
            SharedManager.Instance.removeEventListener(Event.CHANGE, this.__soundChange);
        }

        private function __onMouseClick(_arg_1:MouseEvent):void
        {
            if (this._isCollectComplete)
            {
                return;
            };
            if (this._senceMap.clickedBox == this)
            {
                if (this._collectionAnm.currentFrame < (this._collectionAnm.totalFrames - 5))
                {
                };
            }
            else
            {
                if ((!(this._senceMap.isCollecting)))
                {
                    this._senceMap.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.START_COLLECT, new Array(this, false)));
                };
            };
        }

        public function openBox():void
        {
            if (((!(this._senceMap.isCollecting)) && (!(this._isCollectComplete))))
            {
                this._onCollecting = true;
                this._collectionAnm.addEventListener(SingleDungeonEvent.COLLECTION_COMPLETE, this.__onCollectionComplete);
                this._senceMap.parent.addChild(this._collectionAnm);
                this._collectionAnm.gotoAndPlay(2);
                this._dispChild.play();
                if (((this.mapObjInfo.SceneID == 1) || (this.mapObjInfo.SceneID == 2)))
                {
                    SoundManager.instance.play("180");
                }
                else
                {
                    SoundManager.instance.play("181");
                };
                this._senceMap.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.START_COLLECT, new Array(this, this._onCollecting)));
            };
        }

        private function __onCollectionComplete(_arg_1:Event):void
        {
            this._isCollectComplete = true;
            this._onCollecting = false;
            if (this._collectionAnm)
            {
                this._collectionAnm.removeEventListener(SingleDungeonEvent.COLLECTION_COMPLETE, this.__onCollectionComplete);
                ObjectUtils.disposeObject(this._collectionAnm);
            };
            this._senceMap.armyPos = new Point(this.x, this.y);
            if (this.mapObjInfo)
            {
                SocketManager.Instance.out.sendWalkSceneObjectClick(this.mapObjInfo.ID);
            };
            if (((this.mapObjInfo.SceneID == 1) || (this.mapObjInfo.SceneID == 2)))
            {
                SoundManager.instance.stop("180");
            }
            else
            {
                SoundManager.instance.stop("181");
            };
            this._dispChild.gotoAndPlay("open");
            this._dispChild.mouseEnabled = false;
            this._senceMap.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.START_COLLECT, new Array(null, false)));
            this._intervalId = setInterval(this.showMovie, 100);
        }

        private function showMovie():void
        {
            if (DropGoods.isOver)
            {
                this.dispose();
            };
        }

        private function __soundChange(_arg_1:Event):void
        {
            var _local_2:SoundTransform = new SoundTransform();
            if (SharedManager.Instance.allowSound)
            {
                _local_2.volume = (SharedManager.Instance.soundVolumn / 100);
                this.soundTransform = _local_2;
            }
            else
            {
                _local_2.volume = 0;
                this.soundTransform = _local_2;
            };
        }

        public function dispose():void
        {
            this.removeEvent();
            clearInterval(this._intervalId);
            while (this._dispChild.numChildren > 0)
            {
                if ((this._dispChild.getChildAt(0) is MovieClip))
                {
                    (this._dispChild.getChildAt(0) as MovieClip).stop();
                };
                this._dispChild.removeChildAt(0);
            };
            this._dispChild = null;
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package SingleDungeon.view

