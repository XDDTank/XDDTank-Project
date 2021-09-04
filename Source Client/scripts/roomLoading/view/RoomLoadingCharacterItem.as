package roomLoading.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import game.model.GameInfo;
   import room.model.RoomPlayer;
   
   public class RoomLoadingCharacterItem extends Sprite implements Disposeable
   {
       
      
      private var _info:RoomPlayer;
      
      private var _gameInfo:GameInfo;
      
      private var _loadingArr:Array;
      
      private var _weapon:DisplayObject;
      
      private var _weaponcell:BaseCell;
      
      private var _displayMc:MovieClip;
      
      private var _index:int = 1;
      
      private var _animationFinish:Boolean = false;
      
      private var _vsType:int;
      
      public function RoomLoadingCharacterItem(param1:RoomPlayer, param2:GameInfo, param3:int = 1)
      {
         super();
         this._info = param1;
         this._vsType = param3;
         this._gameInfo = param2;
         this.init();
      }
      
      private function init() : void
      {
         if(this._vsType == 1)
         {
            this._displayMc = ComponentFactory.Instance.creat("asset.roomloading.displayMC");
         }
         else if(this._vsType == 2)
         {
            this._displayMc = ComponentFactory.Instance.creat("asset.roomloading.displayMC2V2");
         }
         else
         {
            this._displayMc = ComponentFactory.Instance.creat("asset.roomloading.displayMC3V3");
         }
         this._displayMc.addEventListener("appeared",this.__onAppeared);
         addChild(this._displayMc);
         this._displayMc.scaleX = this._info.team == RoomPlayer.BLUE_TEAM ? Number(1) : Number(-1);
         this._displayMc["character"].addChild(this._info.character);
         this._info.character.stopAnimation();
         this._info.character.setShowLight(false);
      }
      
      protected function __onAppeared(param1:Event) : void
      {
         this._animationFinish = true;
      }
      
      public function get isAnimationFinished() : Boolean
      {
         return this._animationFinish;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(param1:int) : void
      {
         this._index = param1;
      }
      
      public function get displayMc() : DisplayObject
      {
         return this._displayMc;
      }
      
      public function appear(param1:String) : void
      {
         this._displayMc.gotoAndPlay("appear" + param1);
      }
      
      public function disappear(param1:String) : void
      {
      }
      
      public function get info() : RoomPlayer
      {
         return this._info;
      }
      
      public function dispose() : void
      {
         if(this._info.character && this._info.character.parent)
         {
            this._info.character.parent.removeChild(this._info.character);
         }
         if(this._displayMc)
         {
            this._displayMc.removeEventListener("appeared",this.__onAppeared);
         }
         ObjectUtils.disposeObject(this._displayMc);
         this._displayMc = null;
         this._info = null;
         this._loadingArr = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
