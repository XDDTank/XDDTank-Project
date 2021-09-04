package game.view.playerThumbnail
{
   import ddt.events.GameEvent;
   import flash.display.Sprite;
   import game.model.GameInfo;
   import game.model.Living;
   import game.model.Player;
   import game.objects.GameLiving;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import room.model.RoomInfo;
   
   public class PlayerThumbnailController extends Sprite
   {
       
      
      private var _info:GameInfo;
      
      private var _team1:DictionaryData;
      
      private var _team2:DictionaryData;
      
      private var _isConsortion1:Boolean = true;
      
      private var _isConsortion2:Boolean = true;
      
      private var _consortionId1:Array;
      
      private var _consortionId2:Array;
      
      private var _list1:PlayerThumbnailList;
      
      private var _list2:PlayerThumbnailList;
      
      private var _bossThumbnailContainer:BossThumbnail;
      
      public function PlayerThumbnailController(param1:GameInfo)
      {
         this._info = param1;
         this._team1 = new DictionaryData();
         this._team2 = new DictionaryData();
         this._consortionId1 = new Array();
         this._consortionId2 = new Array();
         super();
         this.init();
         this.initEvents();
      }
      
      private function init() : void
      {
         this.initInfo();
         this._list1 = new PlayerThumbnailList(this._team1,-1,this._isConsortion1);
         this._list2 = new PlayerThumbnailList(this._team2,1,this._isConsortion2);
         addChild(this._list1);
         this._list1.x = 246;
         this._list2.x = 360;
         addChild(this._list2);
      }
      
      private function initInfo() : void
      {
         var _loc4_:Living = null;
         var _loc1_:DictionaryData = this._info.livings;
         var _loc2_:int = -1;
         var _loc3_:int = -1;
         for each(_loc4_ in _loc1_)
         {
            if(_loc4_ is Player)
            {
               if(this._info.roomType != RoomInfo.MATCH_ROOM || (_loc4_ as Player).playerInfo.ConsortiaID == 0)
               {
                  this._isConsortion1 = false;
                  this._isConsortion2 = false;
               }
               if(_loc4_.team == 1)
               {
                  this._team1.add((_loc4_ as Player).playerInfo.ID,_loc4_);
                  if(this._isConsortion1)
                  {
                     if(_loc2_ != (_loc4_ as Player).playerInfo.ConsortiaID && _loc2_ == -1)
                     {
                        this._isConsortion1 = false;
                        _loc2_ = (_loc4_ as Player).playerInfo.ConsortiaID;
                     }
                     else if(_loc2_ != (_loc4_ as Player).playerInfo.ConsortiaID)
                     {
                        this._isConsortion1 = false;
                     }
                     else
                     {
                        this._isConsortion1 = true;
                     }
                  }
               }
               else if(this._info.gameMode != 5)
               {
                  this._team2.add((_loc4_ as Player).playerInfo.ID,_loc4_);
                  if(this._isConsortion2)
                  {
                     if(_loc3_ != (_loc4_ as Player).playerInfo.ConsortiaID && _loc3_ == -1)
                     {
                        this._isConsortion2 = false;
                        _loc3_ = (_loc4_ as Player).playerInfo.ConsortiaID;
                     }
                     else if(_loc3_ != (_loc4_ as Player).playerInfo.ConsortiaID)
                     {
                        this._isConsortion2 = false;
                     }
                     else
                     {
                        this._isConsortion2 = true;
                     }
                  }
               }
            }
         }
      }
      
      public function set currentBoss(param1:Living) : void
      {
         this.removeThumbnailContainer();
         if(param1 == null)
         {
            return;
         }
         this._bossThumbnailContainer = new BossThumbnail(param1);
         this._bossThumbnailContainer.x = this._list1.x + 110;
         this._bossThumbnailContainer.y = -10;
         addChild(this._bossThumbnailContainer);
      }
      
      public function removeThumbnailContainer() : void
      {
         if(this._bossThumbnailContainer)
         {
            this._bossThumbnailContainer.dispose();
         }
         this._bossThumbnailContainer = null;
      }
      
      public function addLiving(param1:GameLiving) : void
      {
         if(param1.info.typeLiving == 4 || param1.info.typeLiving == 5 || param1.info.typeLiving == 6 || param1.info.typeLiving == 12)
         {
            if(this._info.gameMode != 5)
            {
               this.currentBoss = param1.info;
            }
         }
         else if(param1.info.typeLiving == 1 || param1.info.typeLiving == 2)
         {
            this._team2.add(param1.info.LivingID,param1);
         }
      }
      
      private function initEvents() : void
      {
         this._info.livings.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         this._list1.addEventListener(GameEvent.WISH_SELECT,this.__thumbnailListHandle);
         this._list2.addEventListener(GameEvent.WISH_SELECT,this.__thumbnailListHandle);
      }
      
      private function removeEvents() : void
      {
         this._info.livings.removeEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         this._list1.removeEventListener(GameEvent.WISH_SELECT,this.__thumbnailListHandle);
         this._list2.removeEventListener(GameEvent.WISH_SELECT,this.__thumbnailListHandle);
      }
      
      private function __thumbnailListHandle(param1:GameEvent) : void
      {
         dispatchEvent(new GameEvent(GameEvent.WISH_SELECT,param1.data));
      }
      
      private function __removePlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:Player = param1.data as Player;
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.character)
         {
            _loc2_.character.resetShowBitmapBig();
         }
         if(this._bossThumbnailContainer && this._bossThumbnailContainer.Id == _loc2_.LivingID)
         {
            this._bossThumbnailContainer.dispose();
            this._bossThumbnailContainer = null;
         }
         else if(_loc2_.team == 1)
         {
            this._team1.remove((param1.data as Player).playerInfo.ID);
         }
         else
         {
            this._team2.remove((param1.data as Player).playerInfo.ID);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(parent)
         {
            parent.removeChild(this);
         }
         this._info = null;
         this._team1 = null;
         this._team2 = null;
         this._consortionId1 = null;
         this._consortionId2 = null;
         this._list1.dispose();
         this._list2.dispose();
         if(this._bossThumbnailContainer)
         {
            this._bossThumbnailContainer.dispose();
         }
         this._bossThumbnailContainer = null;
         this._list1 = null;
         this._list2 = null;
      }
   }
}
