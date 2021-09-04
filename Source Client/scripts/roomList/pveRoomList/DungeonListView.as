package roomList.pveRoomList
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.manager.ChatManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   import roomList.LookupEnumerate;
   import roomList.movingNotification.MovingNotificationManager;
   
   public class DungeonListView extends Sprite implements Disposeable
   {
       
      
      private var _leaf1:Bitmap;
      
      private var _leaf2:Bitmap;
      
      private var _dungeonListBGView:DungeonListBGView;
      
      private var _chatView:Sprite;
      
      private var _playerList:DungeonRoomListPlayerListView;
      
      private var _model:DungeonListModel;
      
      private var _controlle:DungeonListController;
      
      public function DungeonListView(param1:DungeonListController, param2:DungeonListModel)
      {
         this._controlle = param1;
         this._model = param2;
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._dungeonListBGView = new DungeonListBGView(this._controlle,this._model);
         PositionUtils.setPos(this._dungeonListBGView,"asset.ddtdungeonList.bgview.pos");
         addChild(this._dungeonListBGView);
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("dungeonList.playerListPos");
         this._playerList = new DungeonRoomListPlayerListView(this._model.getPlayerList());
         this._playerList.type = LookupEnumerate.DUNGEON_LIST;
         this._playerList.x = _loc1_.x;
         this._playerList.y = _loc1_.y;
         addChild(this._playerList);
         MovingNotificationManager.Instance.showIn(this);
         PositionUtils.setPos(MovingNotificationManager.Instance.view,"asset.ddtroomList.MovingNotificationDungeonPos");
         ChatManager.Instance.state = ChatManager.CHAT_DUNGEONLIST_STATE;
         this._chatView = ChatManager.Instance.view;
         addChild(this._chatView);
         this._leaf1 = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.pve.leaf1");
         addChild(this._leaf1);
         this._leaf2 = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.pve.leaf2");
         addChild(this._leaf2);
      }
      
      public function dispose() : void
      {
         MovingNotificationManager.Instance.hide();
         if(this._dungeonListBGView && this._dungeonListBGView.parent)
         {
            this._dungeonListBGView.parent.removeChild(this._dungeonListBGView);
            this._dungeonListBGView.dispose();
            this._dungeonListBGView = null;
         }
         if(this._playerList && this._playerList.parent)
         {
            this._playerList.parent.removeChild(this._playerList);
            this._playerList.dispose();
            this._playerList = null;
         }
         this._model = null;
         this._controlle = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
