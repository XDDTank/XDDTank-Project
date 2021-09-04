package roomLoading.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import game.model.GameInfo;
   import room.events.RoomPlayerEvent;
   import room.model.RoomPlayer;
   
   public class RoomLoadingPrgressItem extends Sprite implements Disposeable
   {
      
      public static const LOADING_FINISHED:String = "loadingFinished";
       
      
      private var _info:RoomPlayer;
      
      private var _gameInfo:GameInfo;
      
      private var _vsType:int;
      
      private var _perecentageTxt:FilterFrameText;
      
      private var _okTxt:Bitmap;
      
      private var _index:int;
      
      private var blueIdx:int = 1;
      
      private var redIdx:int = 1;
      
      public function RoomLoadingPrgressItem(param1:RoomPlayer, param2:GameInfo, param3:int = 1)
      {
         super();
         this._info = param1;
         this._gameInfo = param2;
         this._vsType = param3;
         this.init();
      }
      
      private function init() : void
      {
         this._perecentageTxt = ComponentFactory.Instance.creatComponentByStylename("roomLoading.CharacterItemPercentageBlueTxt");
         this._perecentageTxt.text = "0%";
         addChild(this._perecentageTxt);
         this._okTxt = ComponentFactory.Instance.creatBitmap("asset.roomLoading.LoadingOK");
         this._info.addEventListener(RoomPlayerEvent.PROGRESS_CHANGE,this.__onProgress);
      }
      
      private function __onProgress(param1:RoomPlayerEvent) : void
      {
         this._perecentageTxt.text = String(int(this._info.progress)) + "%";
         if(this._info.progress > 99)
         {
            this.finishTxt();
            addChild(this._okTxt);
            this._info.removeEventListener(RoomPlayerEvent.PROGRESS_CHANGE,this.__onProgress);
            dispatchEvent(new Event(LOADING_FINISHED));
         }
      }
      
      private function finishTxt() : void
      {
         if(this._perecentageTxt)
         {
            this._perecentageTxt.visible = false;
         }
      }
      
      private function initPosByPlayer() : void
      {
         var _loc1_:String = this._info.team == RoomPlayer.BLUE_TEAM ? "blueTeam" : "redTeam";
         if(this._info.team == RoomPlayer.BLUE_TEAM)
         {
            if(this._info.isSelf || this.blueIdx == 1 && this._info.team != RoomPlayer.BLUE_TEAM)
            {
               PositionUtils.setPos(this._perecentageTxt,"asset.roomLoadingPlayerItem." + _loc1_ + "_" + 1 + "_" + this._vsType + ".progressPos");
               PositionUtils.setPos(this._okTxt,"asset.roomLoadingPlayerItem." + _loc1_ + "_" + 1 + "_" + this._vsType + ".progressPos");
               if(this._info.team != RoomPlayer.BLUE_TEAM)
               {
                  ++this.blueIdx;
               }
            }
            else
            {
               if(this.blueIdx == 1)
               {
                  ++this.blueIdx;
               }
               PositionUtils.setPos(this._perecentageTxt,"asset.roomLoadingPlayerItem." + _loc1_ + "_" + this.index + "_" + this._vsType + ".progressPos");
               PositionUtils.setPos(this._okTxt,"asset.roomLoadingPlayerItem." + _loc1_ + "_" + this.blueIdx + "_" + this._vsType + ".progressPos");
               ++this.blueIdx;
            }
         }
         else if(this._info.isSelf || this.index == 1 && this._info.team != RoomPlayer.RED_TEAM)
         {
            PositionUtils.setPos(this._perecentageTxt,"asset.roomLoadingPlayerItem." + _loc1_ + "_" + 1 + "_" + this._vsType + ".progressPos");
            PositionUtils.setPos(this._okTxt,"asset.roomLoadingPlayerItem." + _loc1_ + "_" + 1 + "_" + this._vsType + ".progressPos");
            if(this._info.team != RoomPlayer.RED_TEAM)
            {
               ++this.redIdx;
            }
         }
         else
         {
            if(this.redIdx == 1)
            {
               ++this.redIdx;
            }
            PositionUtils.setPos(this._perecentageTxt,"asset.roomLoadingPlayerItem." + _loc1_ + "_" + this.index + "_" + this._vsType + ".progressPos");
            PositionUtils.setPos(this._okTxt,"asset.roomLoadingPlayerItem." + _loc1_ + "_" + this.index + "_" + this._vsType + ".progressPos");
            ++this.redIdx;
         }
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(param1:int) : void
      {
         this._index = param1;
      }
      
      public function get perecentageTxt() : DisplayObject
      {
         return this._perecentageTxt;
      }
      
      public function get okTxt() : DisplayObject
      {
         return this._okTxt;
      }
      
      public function dispose() : void
      {
         this._info.removeEventListener(RoomPlayerEvent.PROGRESS_CHANGE,this.__onProgress);
         ObjectUtils.disposeObject(this._perecentageTxt);
         ObjectUtils.disposeObject(this._okTxt);
         this._info = null;
         this._perecentageTxt = null;
         this._okTxt = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
