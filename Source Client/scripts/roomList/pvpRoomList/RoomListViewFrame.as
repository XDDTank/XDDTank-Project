package roomList.pvpRoomList
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.TaskDirectorType;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskDirectorManager;
   import flash.display.Bitmap;
   import flash.geom.Point;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class RoomListViewFrame extends Frame
   {
       
      
      private var _model:RoomListModel;
      
      private var _controller:RoomListController;
      
      private var _roomListBg:RoomListBGView;
      
      private var _playerList:RoomListPlayerListView;
      
      private var _titleBmp:Bitmap;
      
      public function RoomListViewFrame(param1:RoomListController, param2:RoomListModel)
      {
         this._controller = param1;
         this._model = param2;
         super();
         escEnable = true;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._roomListBg = new RoomListBGView(this._controller,this._model);
         this._playerList = new RoomListPlayerListView(this._model.getPlayerList());
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("roomList.playerListPos");
         this._playerList.x = _loc1_.x;
         this._playerList.y = _loc1_.y;
         this._titleBmp = ComponentFactory.Instance.creatBitmap("asset.fightRoom.title");
         addToContent(this._titleBmp);
         addToContent(this._roomListBg);
         addToContent(this._playerList);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         TaskDirectorManager.instance.showDirector(TaskDirectorType.ROOM_LIST,this);
      }
      
      override public function dispose() : void
      {
         TaskDirectorManager.instance.showDirector(TaskDirectorType.MAIN);
         this.removeEvent();
         NewHandContainer.Instance.clearArrowByID(ArrowType.CREAT_ROOM);
         if(NewHandContainer.Instance.hasArrow(ArrowType.BACK_GUILDE))
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.BACK_GUILDE);
         }
         if(this._roomListBg)
         {
            this._roomListBg.dispose();
            this._roomListBg = null;
         }
         if(this._playerList)
         {
            this._playerList.dispose();
            this._playerList = null;
         }
         RoomListController.Instance.removeEvent();
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         if(this._titleBmp)
         {
            ObjectUtils.disposeObject(this._titleBmp);
         }
         this._titleBmp = null;
         super.dispose();
      }
   }
}
