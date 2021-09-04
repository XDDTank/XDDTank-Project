package SingleDungeon.view
{
   import SingleDungeon.event.SingleDungeonEvent;
   import SingleDungeon.model.WalkMapObject;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.media.SoundTransform;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import game.view.DropGoods;
   
   public class MapObjView extends Sprite implements Disposeable
   {
       
      
      private var _onCollecting:Boolean = false;
      
      private var _isCollectComplete:Boolean = false;
      
      private var _senceMap:SingleDungeonSenceMap;
      
      private var _dispChild:MovieClip;
      
      public var mapObjInfo:WalkMapObject;
      
      private var _intervalId:uint;
      
      private var _collectionAnm:MovieClip;
      
      public function MapObjView(param1:SingleDungeonSenceMap, param2:MovieClip)
      {
         super();
         this._senceMap = param1;
         this._collectionAnm = param2;
         this.initEvent();
         this.buttonMode = true;
      }
      
      public function set dispChild(param1:MovieClip) : void
      {
         if(param1 is MovieClip)
         {
            this.addChild(param1);
            this._dispChild = param1;
         }
      }
      
      private function initEvent() : void
      {
         this.addEventListener(MouseEvent.CLICK,this.__onMouseClick);
         SharedManager.Instance.addEventListener(Event.CHANGE,this.__soundChange);
         this.__soundChange(null);
      }
      
      private function removeEvent() : void
      {
         this.removeEventListener(MouseEvent.CLICK,this.__onMouseClick);
         SharedManager.Instance.removeEventListener(Event.CHANGE,this.__soundChange);
      }
      
      private function __onMouseClick(param1:MouseEvent) : void
      {
         if(this._isCollectComplete)
         {
            return;
         }
         if(this._senceMap.clickedBox == this)
         {
            if(this._collectionAnm.currentFrame < this._collectionAnm.totalFrames - 5)
            {
            }
         }
         else if(!this._senceMap.isCollecting)
         {
            this._senceMap.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.START_COLLECT,new Array(this,false)));
         }
      }
      
      public function openBox() : void
      {
         if(!this._senceMap.isCollecting && !this._isCollectComplete)
         {
            this._onCollecting = true;
            this._collectionAnm.addEventListener(SingleDungeonEvent.COLLECTION_COMPLETE,this.__onCollectionComplete);
            this._senceMap.parent.addChild(this._collectionAnm);
            this._collectionAnm.gotoAndPlay(2);
            this._dispChild.play();
            if(this.mapObjInfo.SceneID == 1 || this.mapObjInfo.SceneID == 2)
            {
               SoundManager.instance.play("180");
            }
            else
            {
               SoundManager.instance.play("181");
            }
            this._senceMap.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.START_COLLECT,new Array(this,this._onCollecting)));
         }
      }
      
      private function __onCollectionComplete(param1:Event) : void
      {
         this._isCollectComplete = true;
         this._onCollecting = false;
         if(this._collectionAnm)
         {
            this._collectionAnm.removeEventListener(SingleDungeonEvent.COLLECTION_COMPLETE,this.__onCollectionComplete);
            ObjectUtils.disposeObject(this._collectionAnm);
         }
         this._senceMap.armyPos = new Point(this.x,this.y);
         if(this.mapObjInfo)
         {
            SocketManager.Instance.out.sendWalkSceneObjectClick(this.mapObjInfo.ID);
         }
         if(this.mapObjInfo.SceneID == 1 || this.mapObjInfo.SceneID == 2)
         {
            SoundManager.instance.stop("180");
         }
         else
         {
            SoundManager.instance.stop("181");
         }
         this._dispChild.gotoAndPlay("open");
         this._dispChild.mouseEnabled = false;
         this._senceMap.dispatchEvent(new SingleDungeonEvent(SingleDungeonEvent.START_COLLECT,new Array(null,false)));
         this._intervalId = setInterval(this.showMovie,100);
      }
      
      private function showMovie() : void
      {
         if(DropGoods.isOver)
         {
            this.dispose();
         }
      }
      
      private function __soundChange(param1:Event) : void
      {
         var _loc2_:SoundTransform = new SoundTransform();
         if(SharedManager.Instance.allowSound)
         {
            _loc2_.volume = SharedManager.Instance.soundVolumn / 100;
            this.soundTransform = _loc2_;
         }
         else
         {
            _loc2_.volume = 0;
            this.soundTransform = _loc2_;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         clearInterval(this._intervalId);
         while(this._dispChild.numChildren > 0)
         {
            if(this._dispChild.getChildAt(0) is MovieClip)
            {
               (this._dispChild.getChildAt(0) as MovieClip).stop();
            }
            this._dispChild.removeChildAt(0);
         }
         this._dispChild = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
