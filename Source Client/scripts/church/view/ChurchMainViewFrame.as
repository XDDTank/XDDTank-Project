package church.view
{
   import baglocked.BaglockedManager;
   import church.controller.ChurchRoomListController;
   import church.model.ChurchRoomListModel;
   import church.view.weddingRoomList.CalculateDate;
   import church.view.weddingRoomList.WeddingRoomListView;
   import church.view.weddingRoomList.frame.WeddingRoomCreateView;
   import church.view.weddingRoomList.frame.WeddingUnmarryView;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChurchManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class ChurchMainViewFrame extends Frame
   {
       
      
      private var _bg:Bitmap;
      
      private var _titleBg:Bitmap;
      
      private var _controller:ChurchRoomListController;
      
      private var _model:ChurchRoomListModel;
      
      private var _weddingRoomListView:WeddingRoomListView;
      
      private var _btnCreateAsst:BaseButton;
      
      private var _btnDivorceAsset:BaseButton;
      
      private var _createRoomFrame:WeddingRoomCreateView;
      
      private var _weddingUnmarryView:WeddingUnmarryView;
      
      public function ChurchMainViewFrame(param1:ChurchRoomListController, param2:ChurchRoomListModel)
      {
         super();
         escEnable = true;
         this._controller = param1;
         this._model = param2;
         this.initialize();
         SocketManager.Instance.out.sendMarryRoomLogin();
         this.addEvent();
      }
      
      private function initialize() : void
      {
         this._titleBg = ComponentFactory.Instance.creatBitmap("asset.church.title");
         addToContent(this._titleBg);
         this._bg = ComponentFactory.Instance.creatBitmap("asset.ddtchurch.frameBg");
         addToContent(this._bg);
         this._weddingRoomListView = new WeddingRoomListView(this._controller,this._model);
         this.updateViewState();
         this._btnCreateAsst = ComponentFactory.Instance.creatComponentByStylename("church.main.btnCreateAsset");
         addToContent(this._btnCreateAsst);
         this._btnDivorceAsset = ComponentFactory.Instance.creatComponentByStylename("church.main.btnDivorceAsset");
         addToContent(this._btnDivorceAsset);
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._btnCreateAsst.addEventListener(MouseEvent.CLICK,this.__onClickListener);
         this._btnDivorceAsset.addEventListener(MouseEvent.CLICK,this.__onClickListener);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._btnCreateAsst.removeEventListener(MouseEvent.CLICK,this.__onClickListener);
         this._btnDivorceAsset.removeEventListener(MouseEvent.CLICK,this.__onClickListener);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function updateViewState() : void
      {
         addToContent(this._weddingRoomListView);
         PositionUtils.setPos(this._weddingRoomListView,"ddtweddingRoomListView");
         this._weddingRoomListView.updateList();
      }
      
      private function __onClickListener(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.currentTarget)
         {
            case this._btnCreateAsst:
               this.showWeddingRoomCreateView();
               break;
            case this._btnDivorceAsset:
               if(!PlayerManager.Instance.Self.IsMarried)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.weddingRoom.RoomListBtnPanel.clickListener"));
                  return;
               }
               this.openDivorce();
               break;
         }
      }
      
      private function openDivorce() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MATE_ONLINE_TIME,this.__mateTime);
         SocketManager.Instance.out.sendMateTime(PlayerManager.Instance.Self.SpouseID);
      }
      
      private function __mateTime(param1:CrazyTankSocketEvent) : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MATE_ONLINE_TIME,this.__mateTime);
         var _loc2_:Date = param1.pkg.readDate();
         if(_loc2_.fullYear < 2013)
         {
            _loc2_ = TimeManager.Instance.Now();
         }
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:int = CalculateDate.needMoney(_loc2_,_loc3_);
         this.showUnmarryFrame(_loc2_,_loc4_,_loc3_);
      }
      
      public function showWeddingRoomCreateView() : void
      {
         if(!PlayerManager.Instance.Self.IsMarried)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.weddingRoom.WeddingRoomControler.showCreateFrame"));
            return;
         }
         if(ChurchManager.instance.selfRoom)
         {
            SocketManager.Instance.out.sendEnterRoom(0,"");
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._createRoomFrame = ComponentFactory.Instance.creat("church.main.weddingRoomList.weddingRoomCreateView");
         this._createRoomFrame.setController(this._controller,this._model);
         this._createRoomFrame.show();
      }
      
      public function showUnmarryFrame(param1:Date, param2:int, param3:int) : void
      {
         this._weddingUnmarryView = ComponentFactory.Instance.creat("church.weddingRoomList.frame.WeddingUnmarryView");
         this._weddingUnmarryView.controller = this._controller;
         var _loc4_:Array = CalculateDate.start(param1,param3);
         this._weddingUnmarryView.setText(_loc4_[0],_loc4_[1]);
         this._weddingUnmarryView.show(param2);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this._controller = null;
         this._model = null;
         if(this._weddingRoomListView)
         {
            ObjectUtils.disposeObject(this._weddingRoomListView);
         }
         this._weddingRoomListView = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._titleBg)
         {
            ObjectUtils.disposeObject(this._titleBg);
         }
         this._titleBg = null;
         if(this._btnCreateAsst)
         {
            ObjectUtils.disposeObject(this._btnCreateAsst);
         }
         this._btnCreateAsst = null;
         if(this._btnDivorceAsset)
         {
            ObjectUtils.disposeObject(this._btnDivorceAsset);
         }
         this._btnDivorceAsset = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
